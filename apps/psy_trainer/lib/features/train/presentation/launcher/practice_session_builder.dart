import 'dart:math';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/content_repository.dart';
import '../../../../core/repositories/model/session.dart';
import '../../domain/engine/activity_session_config.dart';
import '../../domain/engine/item_source.dart';
import '../../domain/engine/timing_policy.dart';
import 'practice_config.dart';

/// Called once, with every distinct [Passage] the sampled bank items of a
/// session reference (order unspecified), right after the session config is
/// built.
///
/// A `PassageResolver` (`presentation/renderers/mcq_renderer.dart`) is
/// synchronous, so a family whose renderer shows a passage panel (`english`,
/// US-027) needs its passages preloaded before the session starts; the
/// launcher screens pass a callback that stashes them somewhere the renderer
/// can read synchronously (see `EnglishPassageCache` in
/// `features/engines/english/presentation/`). Families with no
/// `passageId` items never trigger this.
typedef PassagesLoaded = void Function(List<Passage> passages);

/// Picks which of a family's candidate bank items make up a session, given
/// how many the launcher asked for ([PracticeConfig.itemCount]).
///
/// The default is [balanceByTag]; a family registers its own in
/// [itemSamplers] when plain per-item balancing would break a domain
/// invariant. `english` (US-027) needs [passageAwareSampler]: the 3-5 MCQs
/// attached to the same reading passage must stay together, complete, and
/// in their authored order.
typedef ItemSampler = List<Item> Function(List<Item> candidates, int count);

/// Family-specific [ItemSampler]s, keyed by family id. A family absent from
/// this map gets [balanceByTag].
final Map<String, ItemSampler> itemSamplers = {'english': passageAwareSampler};

/// Turns the launcher's [PracticeConfig] into the `ActivitySessionConfig`
/// `/train/session` runs (US-051).
///
/// - Generated families (`family.generatorId` set) get a fresh
///   [ItemSource.adaptive] (US-053): a new random `runSeed` every run, the
///   family's real-test defaults (`GeneratorParams.defaultsFor`), starting
///   at the launcher's chosen level or, on "Auto" (`config.difficulty ==
///   null`), at [autoLevel] — the caller resolves this from `StatsService`
///   (`ProgressAnalytics.familyProgress(family.id).level`, "the per-family
///   level derived from recent accuracy & speed", US-075) and passes it in;
///   [autoFastThresholdMs] is that same family's median response time
///   (`FamilyProgress.medianResponseMs`), the adaptation policy's "fast"
///   cutoff. From there the session adapts itself every item it plays (see
///   `ActivitySession`/`AdaptiveDifficultyPolicy`), whatever level it
///   started at — a manually fixed level is still a *starting* level, not a
///   ceiling.
/// - Bank families sample `count` items from [contentRepository] with the
///   family's [ItemSampler] (see [itemSamplers]), then, if [onPassagesLoaded]
///   is given and the sample references any passage, load those and hand
///   them to it. "Auto" here still samples from the whole available pool
///   (no `minDifficulty`/`maxDifficulty`), same as before this story: unlike
///   a generator, a bank's item pool at exactly the resolved level may be
///   thin or empty (not every family's content is calibrated across all 5
///   levels yet), so narrowing to it risks an empty or starved session.
///   There is also no in-session adaptation for bank families — the whole
///   sample is drawn once, up front; re-sampling the next item from a new
///   band mid-session (as generated families do) would need on-demand bank
///   queries per item, which this story's budget did not cover. Documented
///   deviation, per the card's own "apply adaptation to generated families
///   only" fallback.
Future<ActivitySessionConfig> buildActivitySessionConfig({
  required TestFamily family,
  required PracticeConfig config,
  required ContentRepository contentRepository,
  int autoLevel = 1,
  int? autoFastThresholdMs,
  Random? random,
  PassagesLoaded? onPassagesLoaded,
}) async {
  final source = family.generatorId != null
      ? _adaptiveSource(
          family,
          config,
          random ?? Random(),
          autoLevel,
          autoFastThresholdMs,
        )
      : await _bankSource(family, config, contentRepository, onPassagesLoaded);
  return ActivitySessionConfig(
    familyId: family.id,
    mode: SessionMode.practice,
    source: source,
    timing: TimingPolicy.forPractice(family, timed: config.timed),
    title: family.name,
  );
}

ItemSource _adaptiveSource(
  TestFamily family,
  PracticeConfig config,
  Random random,
  int autoLevel,
  int? autoFastThresholdMs,
) {
  final level = config.difficulty ?? autoLevel;
  return ItemSource.adaptive(
    generatorId: family.generatorId!,
    runSeed: random.nextInt(1 << 31),
    params: GeneratorParams.defaultsFor(family.generatorId!),
    count: config.itemCount,
    initialDifficulty: level,
    fastThresholdMs: autoFastThresholdMs,
  );
}

Future<ItemSource> _bankSource(
  TestFamily family,
  PracticeConfig config,
  ContentRepository contentRepository,
  PassagesLoaded? onPassagesLoaded,
) async {
  final candidates = await contentRepository.items(
    familyId: family.id,
    minDifficulty: config.difficulty,
    maxDifficulty: config.difficulty,
  );
  final sampler = itemSamplers[family.id] ?? balanceByTag;
  final sampled = sampler(candidates, config.itemCount);
  if (onPassagesLoaded != null) {
    final passageIds = {
      for (final item in sampled)
        if (item is McqItem && item.passageId != null) item.passageId!,
    };
    if (passageIds.isNotEmpty) {
      onPassagesLoaded(await contentRepository.passagesByIds(passageIds));
    }
  }
  return ItemSource.bank(sampled);
}

/// Picks up to [count] of [candidates], round-robin over each item's first
/// tag (untagged items share one bucket) so no single tag dominates the
/// session. [candidates] is assumed already shuffled (the repository's
/// default); ties within a tag keep that order. Returns [candidates]
/// unchanged when there are no more of them than [count] asks for.
List<Item> balanceByTag(List<Item> candidates, int count) {
  if (candidates.length <= count) return candidates;
  final byTag = <String, List<Item>>{};
  for (final item in candidates) {
    final tag = item.tags.isEmpty ? '' : item.tags.first;
    byTag.putIfAbsent(tag, () => []).add(item);
  }
  final tags = byTag.keys.toList();
  final picked = <Item>[];
  var i = 0;
  while (picked.length < count && picked.length < candidates.length) {
    final list = byTag[tags[i % tags.length]]!;
    if (list.isNotEmpty) picked.add(list.removeAt(0));
    i++;
  }
  return picked;
}

/// [ItemSampler] for families whose `McqItem`s can share a `passageId`
/// (`english`, US-027).
///
/// [candidates] is first grouped into "units": every item sharing a
/// `passageId` becomes one unit, sorted by id (the authored, and only
/// sensible, question order within a passage — ids are `<family>.<kind>.NNNN`
/// so this is also chronological); every other item is its own unit. Units
/// keep the order they are first seen in [candidates].
///
/// When every candidate fits, they are returned as-is except reordered so
/// each passage's questions are adjacent and complete. Otherwise units are
/// drawn round-robin over each unit's tag (its first item's first tag),
/// exactly like [balanceByTag] but at unit granularity, so a passage is
/// never picked apart: the final count may overshoot [count] by up to one
/// passage's worth of questions rather than split a set.
List<Item> passageAwareSampler(List<Item> candidates, int count) {
  final units = _passageUnits(candidates);
  if (candidates.length <= count) {
    return [for (final unit in units) ...unit];
  }
  final byTag = <String, List<List<Item>>>{};
  for (final unit in units) {
    final tag = unit.first.tags.isEmpty ? '' : unit.first.tags.first;
    byTag.putIfAbsent(tag, () => []).add(unit);
  }
  final tags = byTag.keys.toList();
  final picked = <Item>[];
  var i = 0;
  var misses = 0;
  while (picked.length < count && misses < tags.length) {
    final units = byTag[tags[i % tags.length]]!;
    if (units.isEmpty) {
      misses++;
    } else {
      misses = 0;
      picked.addAll(units.removeAt(0));
    }
    i++;
  }
  return picked;
}

/// Groups [candidates] into passage-complete units; see [passageAwareSampler].
List<List<Item>> _passageUnits(List<Item> candidates) {
  final units = <List<Item>>[];
  final unitIndexByPassage = <String, int>{};
  for (final item in candidates) {
    final passageId = item is McqItem ? item.passageId : null;
    if (passageId == null) {
      units.add([item]);
      continue;
    }
    final existing = unitIndexByPassage[passageId];
    if (existing == null) {
      unitIndexByPassage[passageId] = units.length;
      units.add([item]);
    } else {
      units[existing] = [...units[existing], item]
        ..sort((a, b) => a.id.compareTo(b.id));
    }
  }
  return units;
}
