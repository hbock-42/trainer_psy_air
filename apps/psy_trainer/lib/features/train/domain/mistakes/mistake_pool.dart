import 'package:psy_content/psy_content.dart';

import '../../../../core/repositories/model/attempt.dart';
import '../engine/activity_engine.dart';
import '../engine/item_result.dart';

/// One item currently worth re-drilling: a bank item by id, or a generated
/// item by its [AttemptOrigin] (US-054 "retry my mistakes"). Exactly one of
/// [itemId] / [origin] is set, the same shape `SessionItem` uses for a
/// played item.
class MistakeEntry {
  const MistakeEntry.bank(this.itemId) : origin = null;

  const MistakeEntry.generated(this.origin) : itemId = null;

  final String? itemId;
  final AttemptOrigin? origin;

  bool get isGenerated => origin != null;

  /// Stable identity used to dedupe/group entries: the bank id, or
  /// `generatorId:seed` (an item's identity is its seed alone, the same
  /// convention as `ActivityEngine.generatedItemId`).
  String get key => itemId ?? '${origin!.generatorId}:${origin!.seed}';

  @override
  bool operator ==(Object other) => other is MistakeEntry && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'MistakeEntry($key)';
}

/// The items worth re-drilling for one family (US-054 "retry my
/// mistakes"): either the failed/timed-out/skipped items of one finished
/// session (summary's "Refaire les erreurs"), or every bank/generated item
/// the family got wrong in the last 30 days and has not cleared since (the
/// launcher's "Reprendre mes erreurs"). Pure Dart — no repository or engine
/// access, only the outcomes/attempts already in hand; a `ProgressRepository`
/// query (`attemptsForFamily`) and a `ContentRepository` lookup
/// (`itemsByIds`) supply those from the presentation layer.
///
/// An item **leaves** the pool once it has 2 consecutive correct answers —
/// the acceptance criterion of the card — tracked as a per-item streak that
/// any wrong/timed-out/skipped answer resets to 0. [fromSessionOutcomes]
/// never needs the streak (a practice session never answers the same item
/// twice), only [fromFamilyHistory].
class MistakePool {
  const MistakePool(this.entries);

  static const MistakePool empty = MistakePool([]);

  /// Most-recently-relevant first (see [fromFamilyHistory]).
  final List<MistakeEntry> entries;

  bool get isEmpty => entries.isEmpty;

  bool get isNotEmpty => entries.isNotEmpty;

  int get length => entries.length;

  List<String> get bankItemIds => [
    for (final e in entries)
      if (e.itemId != null) e.itemId!,
  ];

  List<AttemptOrigin> get generatedOrigins => [
    for (final e in entries)
      if (e.origin != null) e.origin!,
  ];

  /// At most [count] entries, keeping [entries]' own order (most-recently-
  /// relevant first) — the launcher caps a family's pool at the chosen item
  /// count.
  MistakePool capped(int count) => entries.length <= count
      ? this
      : MistakePool(entries.take(count).toList());

  /// Session-scoped retry (summary's "Refaire les erreurs"): every item
  /// [outcomes] got wrong, timed out on or skipped, in play order.
  ///
  /// [sessionParams] is the `GeneratorParams` the session's
  /// `ItemSource.generator` used (every item of one practice session shares
  /// one recipe): required whenever [outcomes] contains a generated item,
  /// since the concrete `Item` `ActivityEngine.generate` returns only
  /// carries `ItemOrigin` (`generatorId` + `seed`), not the params that
  /// produced it.
  factory MistakePool.fromSessionOutcomes(
    List<ItemOutcome> outcomes, {
    GeneratorParams? sessionParams,
  }) {
    final entries = <MistakeEntry>[];
    final seen = <String>{};
    for (final outcome in outcomes) {
      if (outcome.isCorrect) continue;
      final item = outcome.item;
      final itemOrigin = item.origin;
      final entry = itemOrigin == null
          ? MistakeEntry.bank(item.id)
          : MistakeEntry.generated(
              AttemptOrigin(
                generatorId: itemOrigin.generatorId.jsonName,
                seed: itemOrigin.seed,
                params: sessionParams == null
                    ? const {}
                    : generatorParamsToJson(sessionParams),
                difficulty: item.difficulty,
              ),
            );
      if (seen.add(entry.key)) entries.add(entry);
    }
    return MistakePool(entries);
  }

  /// Family-scoped retry (launcher's "Reprendre mes erreurs"): folds
  /// [attempts] (already restricted to one family and a time window, oldest
  /// first — `ProgressRepository.attemptsForFamily(familyId:, from:)`) into
  /// one streak per item (bank id or generated `generatorId`+`seed`); an
  /// item is in the pool when it failed at least once and its trailing
  /// streak of correct answers is under [clearAfter]. Ordered by the most
  /// recent attempt on each item, newest first.
  factory MistakePool.fromFamilyHistory(
    List<Attempt> attempts, {
    int clearAfter = 2,
  }) {
    final entryByKey = <String, MistakeEntry>{};
    final streakByKey = <String, int>{};
    final everFailedByKey = <String, bool>{};
    final lastSeenIndexByKey = <String, int>{};

    for (var i = 0; i < attempts.length; i++) {
      final attempt = attempts[i];
      final itemId = attempt.itemId;
      final origin = attempt.origin;
      final key = itemId ?? '${origin!.generatorId}:${origin.seed}';
      entryByKey[key] = itemId != null
          ? MistakeEntry.bank(itemId)
          : MistakeEntry.generated(origin!);
      lastSeenIndexByKey[key] = i;
      if (attempt.isCorrect) {
        streakByKey[key] = (streakByKey[key] ?? 0) + 1;
      } else {
        streakByKey[key] = 0;
        everFailedByKey[key] = true;
      }
    }

    final keys = entryByKey.keys.toList()
      ..sort(
        (a, b) => lastSeenIndexByKey[b]!.compareTo(lastSeenIndexByKey[a]!),
      );

    return MistakePool([
      for (final key in keys)
        if ((everFailedByKey[key] ?? false) &&
            (streakByKey[key] ?? 0) < clearAfter)
          entryByKey[key]!,
    ]);
  }
}
