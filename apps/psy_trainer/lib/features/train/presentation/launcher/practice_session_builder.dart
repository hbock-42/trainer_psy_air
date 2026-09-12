import 'dart:math';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/content_repository.dart';
import '../../../../core/repositories/model/session.dart';
import '../../domain/engine/activity_session_config.dart';
import '../../domain/engine/item_source.dart';
import '../../domain/engine/timing_policy.dart';
import 'practice_config.dart';

/// Turns the launcher's [PracticeConfig] into the `ActivitySessionConfig`
/// `/train/session` runs (US-051).
///
/// - Generated families (`family.generatorId` set) get a fresh
///   [ItemSource.generator]: a new random seed every run, the family's
///   real-test defaults (`GeneratorParams.defaultsFor`) and a difficulty
///   range narrowed to one level when the launcher picked one, the full
///   1..5 span on "Auto".
/// - Bank families sample `count` items from [contentRepository], balanced
///   across tags when the bank has more matching items than [count] asks
///   for (round-robin over each item's first tag, the repository has no
///   tag filter of its own).
Future<ActivitySessionConfig> buildActivitySessionConfig({
  required TestFamily family,
  required PracticeConfig config,
  required ContentRepository contentRepository,
  Random? random,
}) async {
  final source = family.generatorId != null
      ? _generatorSource(family, config, random ?? Random())
      : await _bankSource(family, config, contentRepository);
  return ActivitySessionConfig(
    familyId: family.id,
    mode: SessionMode.practice,
    source: source,
    timing: TimingPolicy.forPractice(family, timed: config.timed),
    title: family.name,
  );
}

ItemSource _generatorSource(
  TestFamily family,
  PracticeConfig config,
  Random random,
) {
  final level = config.difficulty;
  return ItemSource.generator(
    generatorId: family.generatorId!,
    seed: random.nextInt(1 << 31),
    params: GeneratorParams.defaultsFor(family.generatorId!),
    count: config.itemCount,
    difficulty: level == null
        ? const DifficultyRange(min: 1, max: 5)
        : DifficultyRange(min: level, max: level),
  );
}

Future<ItemSource> _bankSource(
  TestFamily family,
  PracticeConfig config,
  ContentRepository contentRepository,
) async {
  final candidates = await contentRepository.items(
    familyId: family.id,
    minDifficulty: config.difficulty,
    maxDifficulty: config.difficulty,
  );
  return ItemSource.bank(_balancedByTag(candidates, config.itemCount));
}

/// Picks up to [count] of [candidates], round-robin over each item's first
/// tag (untagged items share one bucket) so no single tag dominates the
/// session. [candidates] is assumed already shuffled (the repository's
/// default); ties within a tag keep that order.
List<Item> _balancedByTag(List<Item> candidates, int count) {
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
