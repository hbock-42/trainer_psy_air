import 'package:psy_content/psy_content.dart';

import '../../../../core/repositories/content_repository.dart';
import '../../../../core/repositories/model/session.dart';
import '../engine/activity_session_config.dart';
import '../engine/item_source.dart';
import '../engine/timing_policy.dart';
import 'mistake_pool.dart';

/// Turns a [MistakePool] into the `ItemSource` a retry session plays: bank
/// items are fetched from [contentRepository] (`itemsByIds` skips ids that
/// no longer exist); generated items are replayed from their stored
/// `AttemptOrigin`s (`ItemSource.replay`), which reproduces the exact item
/// without the engine at build time (`ActivitySession` materialises it when
/// the session starts, as it does for any other source).
///
/// [pool] is entirely bank or entirely generated in practice — one practice
/// session plays one family, and a family is entirely bank-driven or
/// entirely generator-driven (ARCHITECTURE.md "Engine" step 5) — but bank
/// entries win if a pool ever mixes both.
Future<ItemSource> itemSourceOfMistakes(
  MistakePool pool,
  ContentRepository contentRepository,
) async {
  final bankIds = pool.bankItemIds;
  if (bankIds.isNotEmpty) {
    return ItemSource.bank(await contentRepository.itemsByIds(bankIds));
  }
  return ItemSource.replay(pool.generatedOrigins);
}

/// Builds the `ActivitySessionConfig` a retry session runs (US-054): same
/// family, practice mode and timing as any other practice run, but its
/// [ItemSource] plays [pool] instead of a fresh draw. Used both by the
/// launcher ("Reprendre mes erreurs", family-scoped) and the summary screen
/// ("Refaire les erreurs", session-scoped) — they differ only in how [pool]
/// was computed (`MistakePool.fromFamilyHistory` / `.fromSessionOutcomes`).
Future<ActivitySessionConfig> buildMistakeSessionConfig({
  required String familyId,
  required MistakePool pool,
  required ContentRepository contentRepository,
  TimingPolicy timing = TimingPolicy.none,
  LocalizedText? title,
}) async {
  final source = await itemSourceOfMistakes(pool, contentRepository);
  return ActivitySessionConfig(
    familyId: familyId,
    mode: SessionMode.practice,
    source: source,
    timing: timing,
    title: title,
  );
}
