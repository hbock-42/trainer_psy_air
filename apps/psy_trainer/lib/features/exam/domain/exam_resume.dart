import '../../../core/repositories/model/attempt.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/progress_repository.dart';

/// How long an interrupted exam stays worth resuming, counted from its
/// last recorded attempt (US-064): "an interrupted exam can be resumed once
/// within 10 minutes (timer continued), otherwise marked aborted."
const Duration examResumeWindow = Duration(minutes: 10);

/// The timestamp [isExamResumable] judges [session] against: the answer
/// time of its last attempt across every section, or the session's own
/// start when nothing was answered yet (interrupted during the very first
/// item's briefing).
DateTime examResumeReferenceTime(
  TrainingSession session,
  List<Attempt> attempts,
) {
  if (attempts.isEmpty) return session.startedAt;
  return attempts
      .map((a) => a.answeredAt)
      .reduce((a, b) => a.isAfter(b) ? a : b);
}

/// Whether [session] is still worth offering "Reprendre" at [now]: less than
/// [examResumeWindow] since [examResumeReferenceTime].
bool isExamResumable(
  TrainingSession session,
  List<Attempt> attempts,
  DateTime now,
) =>
    now.difference(examResumeReferenceTime(session, attempts)) <=
    examResumeWindow;

/// The blueprint section index to resume at: the highest `sectionIndex`
/// among [attempts] (the section that was running, or last finished, when
/// the exam was interrupted), or 0 when nothing was answered yet.
int examResumeSectionIndex(List<Attempt> attempts) {
  if (attempts.isEmpty) return 0;
  return attempts
      .map((a) => a.sectionIndex ?? 0)
      .reduce((a, b) => a > b ? a : b);
}

/// One in-progress exam session worth resuming: the session itself, every
/// attempt recorded on it (across all sections, so `ActivitySession.resume`
/// can restore each section's outcomes) and the section to resume at.
class ExamResumeCandidate {
  const ExamResumeCandidate({
    required this.session,
    required this.attempts,
    required this.sectionIndex,
  });

  final TrainingSession session;
  final List<Attempt> attempts;
  final int sectionIndex;
}

/// Scans [sessions] (assumed newest-first, `ProgressRepository.sessions`'
/// own order) for the newest one still resumable (`isExamResumable`),
/// abandoning every other in-progress exam session found along the way
/// through [progress] -- crash leftovers older than [examResumeWindow], or
/// duplicates of the one just picked: "otherwise marked aborted" (US-064).
/// Returns null when none qualifies.
Future<ExamResumeCandidate?> findResumableExamSession({
  required List<TrainingSession> sessions,
  required ProgressRepository progress,
  required DateTime now,
}) async {
  ExamResumeCandidate? candidate;
  for (final session in sessions) {
    final attempts = await progress.attemptsForSession(session.id);
    if (candidate == null && isExamResumable(session, attempts, now)) {
      candidate = ExamResumeCandidate(
        session: session,
        attempts: attempts,
        sectionIndex: examResumeSectionIndex(attempts),
      );
    } else {
      await progress.finishSession(
        session.id,
        status: SessionStatus.abandoned,
        endedAt: now,
      );
    }
  }
  return candidate;
}
