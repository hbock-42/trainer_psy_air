import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/model/session.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../domain/recommendation.dart';
import '../../domain/recommendation_service.dart';
import 'dashboard_labels_provider.dart';
import 'progress_snapshot_provider.dart';
import 'progress_version_provider.dart';
import 'recommendation_service_provider.dart';
import 'stats_service_provider.dart';

/// "Train next" (US-072): the top 3 weak areas plus rule-based nudges, over
/// the dashboard snapshot and the few extra rows `RecommendationService`
/// needs (the last completed simulation, families with an unread lesson,
/// the due flashcard count). Cached like the other stats providers until
/// [progressVersionProvider] is bumped.
final FutureProvider<List<Recommendation>> recommendationsProvider =
    FutureProvider<List<Recommendation>>((ref) async {
      ref.watch(progressVersionProvider);
      final snapshot = await ref.watch(progressSnapshotProvider.future);
      final labels = await ref.watch(dashboardLabelsProvider.future);
      final progress = ref.watch(progressRepositoryProvider);
      final content = ref.watch(contentRepositoryProvider);
      final stats = ref.watch(statsServiceProvider);
      final service = ref.watch(recommendationServiceProvider);

      final familyNames = {
        for (final f in snapshot.families)
          f.familyId: labels.familyName(f.familyId, short: false),
      };

      DateTime? lastCompletedExamAt;
      for (final exam in snapshot.exams) {
        if (exam.status != SessionStatus.completed) continue;
        if (lastCompletedExamAt == null ||
            exam.startedAt.isAfter(lastCompletedExamAt)) {
          lastCompletedExamAt = exam.startedAt;
        }
      }

      final readLessonIds = {
        for (final read in await progress.lessonsRead()) read.lessonId,
      };
      final missingLessons = <MissingLesson>[];
      for (final family in snapshot.families) {
        if (!family.hasData) continue;
        final lessons = await content.lessons(familyId: family.familyId);
        if (lessons.isEmpty) continue;
        final unread = lessons.where((l) => !readLessonIds.contains(l.id));
        if (unread.isEmpty) continue;
        missingLessons.add((
          familyId: family.familyId,
          lessonId: unread.first.id,
        ));
      }

      final dueFlashcards = await progress.dueFlashcardReviews(now: stats.now);

      return service.recommendations(
        weakAreas: snapshot.weakAreas,
        families: snapshot.families,
        readiness: snapshot.readiness,
        lastCompletedExamAt: lastCompletedExamAt,
        missingLessons: missingLessons,
        familyNames: familyNames,
        dueFlashcardsCount: dueFlashcards.length,
      );
    });
