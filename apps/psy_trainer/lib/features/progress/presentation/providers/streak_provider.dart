import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repositories.dart';
import '../../domain/progress_domain.dart';
import 'daily_goal_provider.dart';
import 'progress_version_provider.dart';

/// The pure streak service, real clock (tests override with a fixed one).
final Provider<StreakService> streakServiceProvider = Provider<StreakService>(
  (ref) => const StreakService(),
);

/// The dashboard's streak card and heat-map (US-073): every practice/exam
/// attempt and flashcard review becomes an [ActivityEvent], summarised by
/// [StreakService.summarize] against the current [dailyGoalProvider].
/// Cached until [progressVersionProvider] is bumped (a finished session) or
/// the goal changes.
final FutureProvider<StreakSummary> streakSummaryProvider =
    FutureProvider<StreakSummary>((ref) async {
      ref.watch(progressVersionProvider);
      final goal = ref.watch(dailyGoalProvider);
      final repository = ref.watch(progressRepositoryProvider);
      final attempts = await repository.allAttempts();
      final reviews = await repository.allFlashcardReviews();
      final events = [
        for (final a in attempts)
          ActivityEvent(at: a.answeredAt, responseMs: a.responseMs),
        for (final r in reviews)
          if (r.lastReviewedAt != null) ActivityEvent(at: r.lastReviewedAt!),
      ];
      return ref
          .watch(streakServiceProvider)
          .summarize(events: events, goal: goal);
    });
