import 'dart:math';

import 'package:psy_content/psy_content.dart';
import '../../../core/repositories/content_repository.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/progress_repository.dart';
import '../../train/domain/engine/engine.dart';

/// One section of a blueprint the exam runner will actually play: the
/// original [section] (its index in the blueprint is [sectionIndex]) turned
/// into the `ActivitySessionConfig` `SessionHost` runs.
class PlannedExamSection {
  const PlannedExamSection({
    required this.sectionIndex,
    required this.section,
    required this.config,
  });

  final int sectionIndex;
  final ExamSection section;
  final ActivitySessionConfig config;
}

/// Turns a [blueprint] into the ordered list of sections the runner plays:
/// sections whose family has no registered engine are dropped (US-060/061,
/// "not available yet"); the rest get an `ActivitySessionConfig` bound to
/// [sessionId] (`ownsSession: false`, the exam runner finishes the session
/// itself once every section ran) with a `positionOffset` that keeps
/// `NewAttempt.position` unique across the whole exam.
///
/// - `generated` sections draw a fresh seed per run from [random].
/// - `bank` sections sample [ContentRepository.items], excluding items used
///   in the candidate's last `avoidRecentSessions` sessions of that family,
///   filtered by `tags`/`anyTags` and balanced round-robin over the tag
///   matching `balanceByTagPrefix` when one is given (falls back to the
///   repository's own random order otherwise).
Future<List<PlannedExamSection>> planExamSections({
  required ExamBlueprint blueprint,
  required EngineRegistry engines,
  required ContentRepository content,
  required ProgressRepository progress,
  required String sessionId,
  Random? random,
}) async {
  final rng = random ?? Random();
  final planned = <PlannedExamSection>[];
  var offset = 0;
  for (var i = 0; i < blueprint.sections.length; i++) {
    final section = blueprint.sections[i];
    if (!engines.hasFamily(section.familyId)) continue;
    final family = await content.familyById(section.familyId);
    final source = switch (section.itemSelection) {
      GeneratedSelection() => _generatorSource(section, rng),
      BankSelection() => await _bankSource(section, content, progress),
    };
    final config = ActivitySessionConfig(
      familyId: section.familyId,
      mode: SessionMode.exam,
      source: source,
      timing: TimingPolicy.fromSection(section),
      scoringPolicy: section.scoringPolicy,
      liveFeedback: section.liveFeedback,
      briefing: _briefingText(section, family),
      title: section.title ?? family?.name,
      blueprintId: blueprint.id,
      sectionIndex: i,
      sessionId: sessionId,
      ownsSession: false,
      positionOffset: offset,
    );
    planned.add(
      PlannedExamSection(sectionIndex: i, section: section, config: config),
    );
    offset += source.itemCount;
  }
  return planned;
}

ItemSource _generatorSource(ExamSection section, Random random) {
  final selection = section.itemSelection as GeneratedSelection;
  return ItemSource.generator(
    generatorId: selection.generatorId,
    seed: random.nextInt(1 << 31),
    params: selection.params,
    count: section.itemCount,
    difficulty: selection.difficulty,
  );
}

Future<ItemSource> _bankSource(
  ExamSection section,
  ContentRepository content,
  ProgressRepository progress,
) async {
  final selection = section.itemSelection as BankSelection;
  final excludeIds = await _recentItemIds(
    familyId: section.familyId,
    sessions: selection.avoidRecentSessions,
    progress: progress,
  );
  final pool = await content.items(
    familyId: section.familyId,
    minDifficulty: selection.difficulty?.min,
    maxDifficulty: selection.difficulty?.max,
    excludeIds: excludeIds,
  );
  final filtered = _filterByTags(pool, selection);
  final picked = selection.balanceByTagPrefix != null
      ? _balanceByPrefix(
          filtered,
          section.itemCount,
          selection.balanceByTagPrefix!,
        )
      : filtered.take(section.itemCount).toList();
  return ItemSource.bank(picked);
}

Future<Set<String>> _recentItemIds({
  required String familyId,
  required int sessions,
  required ProgressRepository progress,
}) async {
  if (sessions <= 0) return const {};
  final recent = await progress.sessions(familyId: familyId, limit: sessions);
  final ids = <String>{};
  for (final session in recent) {
    final attempts = await progress.attemptsForSession(session.id);
    for (final attempt in attempts) {
      final itemId = attempt.itemId;
      if (itemId != null) ids.add(itemId);
    }
  }
  return ids;
}

List<Item> _filterByTags(List<Item> items, BankSelection selection) {
  final tags = selection.tags;
  final anyTags = selection.anyTags;
  if (tags == null && anyTags == null) return items;
  return items.where((item) {
    final itemTags = item.tags.toSet();
    if (tags != null && !itemTags.containsAll(tags)) return false;
    if (anyTags != null && !itemTags.any(anyTags.contains)) return false;
    return true;
  }).toList();
}

/// Round-robin over the tag starting with [prefix] (untagged/other items
/// share one bucket), so no single tag dominates the section.
List<Item> _balanceByPrefix(List<Item> candidates, int count, String prefix) {
  if (candidates.length <= count) return candidates;
  final byTag = <String, List<Item>>{};
  for (final item in candidates) {
    final tag = item.tags.firstWhere(
      (t) => t.startsWith(prefix),
      orElse: () => '',
    );
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

/// The briefing shown by `SessionHost`: the section's own briefing or the
/// family description, plus the section's duration/item count and a
/// keyboard-only warning (US-061/063 "desktop only").
LocalizedText? _briefingText(ExamSection section, TestFamily? family) {
  final base = section.briefing ?? family?.description;
  final minutes = section.sectionTimeSec == null
      ? null
      : (section.sectionTimeSec! / 60).ceil();
  final detailsFr = [
    if (minutes != null) '$minutes min',
    '${section.itemCount} question${section.itemCount > 1 ? 's' : ''}',
  ].join(' · ');
  final warningFr = section.inputRequirement == InputRequirement.keyboard
      ? '\n\nCette activité nécessite un clavier physique : sur un appareil '
            'tactile, la version proposée n\'est pas représentative du vrai '
            'test.'
      : '';
  final fr = '${base?.fr ?? ''}\n\n$detailsFr$warningFr'.trim();
  final baseEn = base?.en;
  final detailsEn = [
    if (minutes != null) '$minutes min',
    '${section.itemCount} item${section.itemCount > 1 ? 's' : ''}',
  ].join(' · ');
  final warningEn = section.inputRequirement == InputRequirement.keyboard
      ? '\n\nThis activity needs a physical keyboard: on a touch device the '
            'fallback is not representative of the real test.'
      : '';
  final en = baseEn == null ? null : '$baseEn\n\n$detailsEn$warningEn'.trim();
  return LocalizedText(fr: fr, en: en);
}
