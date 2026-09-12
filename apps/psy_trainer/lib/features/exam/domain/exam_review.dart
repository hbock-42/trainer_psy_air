import '../../../core/repositories/model/attempt.dart';
import '../../../core/repositories/model/session.dart';
import '../../train/domain/engine/engine.dart';

/// One section's played items, rebuilt from persisted attempts, for the
/// exam report's item-by-item review (US-062).
class ExamReviewSection {
  const ExamReviewSection({
    required this.sectionIndex,
    required this.familyId,
    required this.outcomes,
  });

  final int sectionIndex;
  final String familyId;
  final List<ItemOutcome> outcomes;
}

/// Rebuilds the review of an exam session entirely from what is persisted:
/// the per-section `ActivitySessionConfig`s stored in
/// `TrainingSession.config` (`ExamRunController` puts them there when it
/// starts the session) and the session's [attempts].
///
/// Each section's items are re-materialised from its config exactly as
/// `ActivitySession.resume` does (same generator seed, same bank items),
/// so no per-attempt difficulty or item snapshot needs to be stored
/// separately. A section whose engine is no longer registered is omitted
/// rather than guessed at.
List<ExamReviewSection> buildExamReview({
  required TrainingSession session,
  required List<Attempt> attempts,
  required EngineRegistry engines,
}) {
  final configs = sectionConfigsOf(session);
  final bySection = <int, List<Attempt>>{};
  for (final attempt in attempts) {
    bySection.putIfAbsent(attempt.sectionIndex ?? 0, () => []).add(attempt);
  }

  final result = <ExamReviewSection>[];
  for (final config in configs) {
    if (!engines.hasFamily(config.familyId)) continue;
    final sectionIndex = config.sectionIndex ?? 0;
    final engine = engines.byFamily(config.familyId);
    final items = config.source.materialise(engine);
    final sectionAttempts =
        (bySection[sectionIndex] ?? const <Attempt>[]).toList()
          ..sort((a, b) => a.position.compareTo(b.position));

    final outcomes = <ItemOutcome>[];
    for (final attempt in sectionAttempts) {
      final localIndex = attempt.position - config.positionOffset;
      if (localIndex < 0 || localIndex >= items.length) continue;
      final sessionItem = items[localIndex];
      final answer = attempt.answer == null
          ? const Answer.timeout()
          : Answer.fromJson(attempt.answer!);
      outcomes.add(
        ItemOutcome(
          index: localIndex,
          item: sessionItem.item,
          answer: answer,
          result: ItemResult(
            correct: attempt.isCorrect,
            timedOut: attempt.answer == null,
            skipped: answer.isSkip,
          ),
          responseMs: attempt.responseMs,
        ),
      );
    }
    outcomes.sort((a, b) => a.index.compareTo(b.index));
    result.add(
      ExamReviewSection(
        sectionIndex: sectionIndex,
        familyId: config.familyId,
        outcomes: outcomes,
      ),
    );
  }
  return result;
}

/// The per-section configs an `ExamRunController` stored on the session at
/// `startSession` time (`config: {'sections': [...]}`).
List<ActivitySessionConfig> sectionConfigsOf(TrainingSession session) {
  final raw = session.config['sections'];
  if (raw is! List) return const [];
  return [
    for (final entry in raw)
      ActivitySessionConfig.fromJson(Map<String, Object?>.from(entry as Map)),
  ];
}
