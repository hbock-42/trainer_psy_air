import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/model/session.dart';
import '../../../../core/repositories/repository_providers.dart';
import 'exam_history_provider.dart';
import 'progress_version_provider.dart';

/// One row of the dashboard's "recent activity" list: a finished session
/// (practice drill or exam simulation) with its score.
@immutable
class RecentActivity {
  const RecentActivity({
    required this.sessionId,
    required this.mode,
    required this.status,
    required this.startedAt,
    required this.attempts,
    this.familyId,
    this.blueprintId,
    this.score,
  });

  final String sessionId;
  final SessionMode mode;
  final SessionStatus status;
  final DateTime startedAt;

  /// Attempts recorded in the session (0 when it ended before any answer).
  final int attempts;
  final String? familyId;
  final String? blueprintId;

  /// 0..1: the exam summary score for a simulation, the session's stored
  /// score otherwise, falling back to the accuracy over its attempts; null
  /// when nothing was answered.
  final double? score;

  bool get isExam => mode == SessionMode.exam;

  int? get percent => score == null ? null : (score! * 100).round();
}

/// How many finished sessions the dashboard lists.
const int recentActivityLimit = 10;

/// The last [recentActivityLimit] finished sessions, newest first, cached
/// until [progressVersionProvider] is bumped.
final FutureProvider<List<RecentActivity>> recentActivityProvider =
    FutureProvider<List<RecentActivity>>((ref) async {
      ref.watch(progressVersionProvider);
      final progress = ref.watch(progressRepositoryProvider);
      // Over-fetch: in-progress sessions are filtered out client side.
      final sessions = (await progress.sessions(
        limit: recentActivityLimit * 2,
      )).where((s) => s.isFinished).take(recentActivityLimit).toList();
      if (sessions.isEmpty) return const [];

      final oldest = sessions
          .map((s) => s.startedAt)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final rows = await progress.sessionFamilyStats(from: oldest);
      final attemptsBySession = <String, int>{};
      final correctBySession = <String, int>{};
      for (final row in rows) {
        attemptsBySession.update(
          row.sessionId,
          (n) => n + row.attempts,
          ifAbsent: () => row.attempts,
        );
        correctBySession.update(
          row.sessionId,
          (n) => n + row.correct,
          ifAbsent: () => row.correct,
        );
      }
      final exams = {
        for (final e in await ref.watch(examHistoryProvider.future))
          e.sessionId: e,
      };

      return [
        for (final s in sessions)
          RecentActivity(
            sessionId: s.id,
            mode: s.mode,
            status: s.status,
            startedAt: s.startedAt,
            attempts: attemptsBySession[s.id] ?? 0,
            familyId: s.familyId,
            blueprintId: s.blueprintId,
            score: _score(
              session: s,
              examScore: exams[s.id]?.score,
              attempts: attemptsBySession[s.id] ?? 0,
              correct: correctBySession[s.id] ?? 0,
            ),
          ),
      ];
    });

double? _score({
  required TrainingSession session,
  required double? examScore,
  required int attempts,
  required int correct,
}) {
  if (session.mode == SessionMode.exam && examScore != null) return examScore;
  if (session.score != null) return session.score;
  if (attempts == 0) return null;
  return correct / attempts;
}
