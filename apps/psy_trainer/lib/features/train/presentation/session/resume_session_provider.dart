import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repositories.dart';
import '../../../progress/presentation/providers/progress_version_provider.dart';

/// A crash-recoverable practice session: young enough (< 24h) that resuming
/// it still makes sense, plus the attempts already recorded so
/// `ActivitySessionRequest.resume` can rebuild it.
class ResumeCandidate {
  const ResumeCandidate({required this.session, required this.attempts});

  final TrainingSession session;
  final List<Attempt> attempts;
}

const Duration _maxResumeAge = Duration(hours: 24);

/// Crash-safe resume (US-051): looks at every `inProgress` practice session
/// on build, silently marks anything older than [_maxResumeAge] as
/// `abandoned` (nobody is coming back for it) and hands the Train home the
/// most recent survivor, if any, to offer as "Reprendre la session".
///
/// Depends on [progressVersionProvider] so it re-checks after any session
/// finishes and on `engineClockProvider`-free `DateTime.now()`; tests pass
/// their own `now` through [resumeSessionNowProvider] instead of mocking
/// `DateTime.now()`.
final FutureProvider<ResumeCandidate?> resumeSessionProvider =
    FutureProvider<ResumeCandidate?>((ref) async {
      ref.watch(progressVersionProvider);
      final repository = ref.watch(progressRepositoryProvider);
      final now = ref.watch(resumeSessionNowProvider)();
      final inProgress = await repository.sessions(
        mode: SessionMode.practice,
        status: SessionStatus.inProgress,
      );

      TrainingSession? candidate;
      for (final session in inProgress) {
        if (now.difference(session.startedAt) > _maxResumeAge) {
          unawaited(
            repository.finishSession(
              session.id,
              status: SessionStatus.abandoned,
              endedAt: now,
            ),
          );
          continue;
        }
        // `sessions()` returns newest first: the first survivor is the most
        // recent one.
        candidate ??= session;
      }
      if (candidate == null) return null;
      final attempts = await repository.attemptsForSession(candidate.id);
      return ResumeCandidate(session: candidate, attempts: attempts);
    });

/// Time source for [resumeSessionProvider]; tests override it to control
/// which in-progress sessions count as "young enough".
final Provider<DateTime Function()> resumeSessionNowProvider =
    Provider<DateTime Function()>(
      (ref) =>
          () => DateTime.now().toUtc(),
    );
