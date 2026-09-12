import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/model/attempt.dart';
import '../adaptive/adaptive_difficulty_policy.dart';
import 'activity_engine.dart';

part 'item_source.freezed.dart';
part 'item_source.g.dart';

/// Where a session's items come from: a fixed list of bank items or a
/// generator recipe. JSON-serialisable so it can be stored in the
/// `TrainingSession.config` and rebuilt on resume.
@Freezed(unionKey: 'kind')
sealed class ItemSource with _$ItemSource {
  const ItemSource._();

  /// Play [items] in order. A [GeneratedItem] in the list is materialised
  /// by the engine; every other item is played as is.
  @FreezedUnionValue('bank')
  const factory ItemSource.bank(List<Item> items) = BankSource;

  /// Generate [count] items from `generatorId` with [params]. One seed per
  /// item and one difficulty within [difficulty] are drawn from
  /// `Random(seed)`, so the whole section is reproducible from [seed].
  /// [seed] is also the run's `runSeed` (US-037): every item's `generate`
  /// call gets it unchanged, plus its own `index` (0-based position),
  /// alongside the per-item seed it always got.
  @FreezedUnionValue('generator')
  const factory ItemSource.generator({
    required GeneratorId generatorId,
    required int seed,
    @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)
    required GeneratorParams params,
    required int count,
    @Default(DifficultyRange(min: 3, max: 3)) DifficultyRange difficulty,
  }) = GeneratorSource;

  /// Generate [count] items from `generatorId` with [params], starting at
  /// [initialDifficulty] and adjusted in-session by [policy] (US-053): +1
  /// after a few consecutive correct-and-fast answers, -1 after a couple of
  /// wrong ones (see [AdaptiveDifficultyPolicy]). Unlike
  /// [ItemSource.generator], the difficulty of item *k* is not fixed up
  /// front — it depends on how items `0..k-1` were answered — so items are
  /// materialised lazily, one at a time, as `ActivitySession` shows them
  /// (see `materialiseAdaptive`); [materialise] throws for this kind, and
  /// `itemCount` is the only thing about it known ahead of time. [runSeed]
  /// plays the same role as `ItemSource.generator.seed` (US-037): every
  /// item's `generate` call gets it unchanged, so a run is reproducible
  /// from `(runSeed, the answers given)`. [fastThresholdMs] is normally the
  /// family's own median response time (`StatsService`/`FamilyProgress
  /// .medianResponseMs`, resolved once when the session is built); null
  /// falls back to a fraction of the per-item time limit (see
  /// [AdaptiveDifficultyPolicy.fastCutoffMs]).
  @FreezedUnionValue('adaptive')
  const factory ItemSource.adaptive({
    required GeneratorId generatorId,
    required int runSeed,
    @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)
    required GeneratorParams params,
    required int count,
    required int initialDifficulty,
    int? fastThresholdMs,
    @Default(AdaptiveDifficultyPolicy.standard) AdaptiveDifficultyPolicy policy,
  }) = AdaptiveSource;

  /// Replays generated items from their stored [AttemptOrigin]s (US-054
  /// "retry my mistakes"): each origin carries everything
  /// `ActivityEngine.generate` needs (`generatorId`, `seed`, `params`,
  /// `difficulty`) to reproduce the exact same item, so a session can be
  /// built over past mistakes without keeping the items themselves around.
  /// Every origin must be for the engine's own generator (checked in
  /// [materialise]). Minimal, additive runtime addition; not stored in
  /// `TrainingSession.config` today (a retry session starts fresh each
  /// time), so it has no JSON union value.
  const factory ItemSource.replay(List<AttemptOrigin> origins) = ReplaySource;

  factory ItemSource.fromJson(Map<String, Object?> json) =>
      _$ItemSourceFromJson(json);

  /// Number of items the session will play.
  int get itemCount => switch (this) {
    BankSource(:final items) => items.length,
    GeneratorSource(:final count) => count,
    AdaptiveSource(:final count) => count,
    ReplaySource(:final origins) => origins.length,
  };

  /// True for [ItemSource.adaptive]: see [materialiseAdaptive].
  bool get isAdaptive => this is AdaptiveSource;

  /// Builds the concrete items with [engine]. Deterministic. Throws
  /// [UnsupportedError] for [ItemSource.adaptive]: an adaptive source has no
  /// fixed item list (the difficulty of item *k* depends on how items
  /// `0..k-1` were answered) — `ActivitySession` materialises it lazily
  /// with [materialiseAdaptive] instead.
  List<SessionItem> materialise(ActivityEngine engine) => switch (this) {
    BankSource(:final items) => [
      for (final item in items) SessionItem.of(engine.materialise(item), item),
    ],
    GeneratorSource(
      :final generatorId,
      :final seed,
      :final params,
      :final count,
      :final difficulty,
    ) =>
      _generate(engine, generatorId, seed, params, count, difficulty),
    AdaptiveSource() => throw UnsupportedError(
      'ItemSource.adaptive materialises lazily; use materialiseAdaptive',
    ),
    ReplaySource(:final origins) => [
      for (final origin in origins) _replay(engine, origin),
    ],
  };

  /// Materialises item [index] of an [ItemSource.adaptive] source at
  /// [difficulty] (the adaptive policy's current level). The per-item seed
  /// is a pure function of `(runSeed, index)` (unlike
  /// [ItemSource.generator]'s sequential draw from one `Random`), so items
  /// can be (re)materialised in any order — needed since a resumed session
  /// replays earlier indices from their stored attempts, not from a
  /// upfront-built list.
  SessionItem materialiseAdaptive(
    ActivityEngine engine,
    int index,
    int difficulty,
  ) {
    final self = this;
    if (self is! AdaptiveSource) {
      throw StateError(
        'materialiseAdaptive is only valid for ItemSource.adaptive',
      );
    }
    final itemSeed = _adaptiveItemSeed(self.runSeed, index);
    final item = engine.generate(
      params: self.params,
      seed: itemSeed,
      difficulty: difficulty,
      index: index,
      runSeed: self.runSeed,
    );
    return SessionItem(
      item: item,
      origin: AttemptOrigin(
        generatorId: self.generatorId.jsonName,
        seed: itemSeed,
        params: generatorParamsToJson(self.params),
        difficulty: difficulty,
      ),
    );
  }

  /// Deterministic per-item seed for [ItemSource.adaptive], addressable by
  /// [index] directly (not a running draw from one shared `Random`, which
  /// would force materialising every earlier index first).
  static int _adaptiveItemSeed(int runSeed, int index) =>
      Random(runSeed + index * 0x1000193).nextInt(1 << 31);

  /// Rebuilds the exact item [origin] describes against [engine] (must be
  /// the origin's own generator). Used to replay one attempt
  /// ([ItemSource.replay]) and to restore an [ItemSource.adaptive] run's
  /// already-played items on resume — their difficulty was decided by the
  /// policy at the time and is recorded in the attempt's own [origin],
  /// which is exactly what this reconstructs from.
  static Item itemFromOrigin(
    ActivityEngine engine,
    AttemptOrigin origin, {
    int index = 0,
    int? runSeed,
  }) {
    final generatorId = engine.generatorId;
    if (generatorId == null || generatorId.jsonName != origin.generatorId) {
      throw ArgumentError.value(
        origin.generatorId,
        'origin.generatorId',
        'does not match ${engine.familyId}\'s generator',
      );
    }
    final params = GeneratorParams.fromJson({
      ...origin.params,
      generatorParamsUnionKey: origin.generatorId,
    });
    return engine.generate(
      params: params,
      seed: origin.seed,
      difficulty: origin.difficulty,
      index: index,
      runSeed: runSeed ?? origin.seed,
    );
  }

  static SessionItem _replay(ActivityEngine engine, AttemptOrigin origin) =>
      SessionItem(item: itemFromOrigin(engine, origin), origin: origin);

  static List<SessionItem> _generate(
    ActivityEngine engine,
    GeneratorId generatorId,
    int seed,
    GeneratorParams params,
    int count,
    DifficultyRange difficulty,
  ) {
    final rng = Random(seed);
    final span = difficulty.max - difficulty.min + 1;
    return [
      for (var i = 0; i < count; i++)
        () {
          final itemSeed = rng.nextInt(1 << 31);
          final level = difficulty.min + rng.nextInt(span);
          final item = engine.generate(
            params: params,
            seed: itemSeed,
            difficulty: level,
            index: i,
            runSeed: seed,
          );
          return SessionItem(
            item: item,
            origin: AttemptOrigin(
              generatorId: generatorId.jsonName,
              seed: itemSeed,
              params: generatorParamsToJson(params),
              difficulty: level,
            ),
          );
        }(),
    ];
  }
}

/// A concrete item ready to play plus what an attempt on it must store:
/// the bank `itemId` for bank items or the [AttemptOrigin] for generated
/// ones (exactly one is set, as `NewAttempt` requires).
class SessionItem {
  const SessionItem({required this.item, this.itemId, this.origin})
    : assert(
        (itemId == null) != (origin == null),
        'exactly one of itemId/origin is set',
      );

  /// Pairs a materialised [item] with the bank entry it came from
  /// ([source]): a recipe yields an origin, anything else its bank id.
  factory SessionItem.of(Item item, Item source) => switch (source) {
    GeneratedItem(:final generatorId, :final seed, :final params) =>
      SessionItem(
        item: item,
        origin: AttemptOrigin(
          generatorId: generatorId.jsonName,
          seed: seed,
          params: generatorParamsToJson(params),
          difficulty: source.difficulty,
        ),
      ),
    _ => SessionItem(item: item, itemId: source.id),
  };

  final Item item;
  final String? itemId;
  final AttemptOrigin? origin;

  bool get isGenerated => origin != null;
}
