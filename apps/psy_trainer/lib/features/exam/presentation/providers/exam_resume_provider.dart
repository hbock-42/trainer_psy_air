import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/model/session.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../progress/presentation/providers/progress_version_provider.dart';
import '../../domain/exam_resume.dart';

/// The most recent interrupted exam worth offering "Reprendre" on, plus its
/// blueprint's display name (null when the blueprint was removed since).
class ExamResumeEntry {
  const ExamResumeEntry({required this.candidate, this.blueprintName});

  final ExamResumeCandidate candidate;
  final String? blueprintName;
}

/// Crash-safe exam resume (US-064): looks at every `inProgress` exam
/// session on build, silently marks anything whose last attempt is older
/// than [examResumeWindow] as `abandoned` and hands the Exam home the most
/// recent survivor, if any, to offer as "Reprendre la simulation".
///
/// Mirrors `resumeSessionProvider` (US-051, practice): depends on
/// [progressVersionProvider] so it re-checks after any session finishes;
/// tests pass their own `now` through [examResumeNowProvider] instead of
/// mocking `DateTime.now()`.
final FutureProvider<ExamResumeEntry?> examResumeProvider =
    FutureProvider<ExamResumeEntry?>((ref) async {
      ref.watch(progressVersionProvider);
      final progress = ref.watch(progressRepositoryProvider);
      final content = ref.watch(contentRepositoryProvider);
      final now = ref.watch(examResumeNowProvider)();

      final inProgress = await progress.sessions(
        mode: SessionMode.exam,
        status: SessionStatus.inProgress,
      );
      final candidate = await findResumableExamSession(
        sessions: inProgress,
        progress: progress,
        now: now,
      );
      if (candidate == null) return null;

      final blueprintId = candidate.session.blueprintId;
      final blueprint = blueprintId == null
          ? null
          : await content.blueprintById(blueprintId);
      return ExamResumeEntry(
        candidate: candidate,
        blueprintName: blueprint?.name.fr,
      );
    });

/// Time source for [examResumeProvider]; tests override it to control which
/// in-progress exam sessions count as "young enough".
final Provider<DateTime Function()> examResumeNowProvider =
    Provider<DateTime Function()>(
      (ref) =>
          () => DateTime.now().toUtc(),
    );
