import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repository_providers.dart';
import '../../../progress/domain/exam_summary.dart';
import '../../../progress/presentation/providers/progress_analytics_provider.dart';
import '../../../train/presentation/engine/engine_registry_provider.dart';
import '../../domain/exam_review.dart';

/// Everything `ExamReportScreen` shows for one session: the score summary
/// (US-062, `StatsService.examSummary` through `ProgressAnalytics`), the
/// blueprint's display name, the per-section review rebuilt from the
/// persisted attempts (`buildExamReview`) and the per-section delta against
/// the previous completed simulation of the same blueprint.
///
/// `ExamSummary` only carries the global `deltaVsPrevious` (US-075); the
/// per-section one asked for here is computed by diffing this session's
/// `SectionScore.accuracy` against the previous summary's, matched by
/// `sectionIndex` — a plain read of two already-computed summaries, so it
/// lives here rather than in `StatsService`.
class ExamReportData {
  const ExamReportData({
    required this.summary,
    required this.blueprintName,
    required this.reviewSections,
    required this.sectionDeltas,
  });

  final ExamSummary summary;
  final String? blueprintName;
  final List<ExamReviewSection> reviewSections;

  /// `accuracy - previous.accuracy` per `SectionScore.sectionIndex`; absent
  /// for a section not scored in the previous completed simulation (or when
  /// there is none).
  final Map<int, double> sectionDeltas;
}

final examReportProvider = FutureProvider.autoDispose
    .family<ExamReportData?, String>((ref, sessionId) async {
      final progress = ref.watch(progressRepositoryProvider);
      final content = ref.watch(contentRepositoryProvider);
      final analytics = ref.watch(progressAnalyticsProvider);
      final engines = ref.watch(engineRegistryProvider);

      final session = await progress.sessionById(sessionId);
      if (session == null) return null;
      final summary = await analytics.examSummary(sessionId);
      if (summary == null) return null;

      final blueprintId = summary.blueprintId;
      final blueprint = blueprintId == null
          ? null
          : await content.blueprintById(blueprintId);

      final attempts = await progress.attemptsForSession(sessionId);
      final review = buildExamReview(
        session: session,
        attempts: attempts,
        engines: engines,
      );

      final previousId = summary.previousSessionId;
      final sectionDeltas = <int, double>{};
      if (previousId != null) {
        final previous = await analytics.examSummary(previousId);
        if (previous != null) {
          final previousBySection = {
            for (final s in previous.sections) s.sectionIndex: s.accuracy,
          };
          for (final section in summary.sections) {
            final prevAccuracy = previousBySection[section.sectionIndex];
            if (prevAccuracy != null) {
              sectionDeltas[section.sectionIndex] =
                  section.accuracy - prevAccuracy;
            }
          }
        }
      }

      return ExamReportData(
        summary: summary,
        blueprintName: blueprint?.name.fr,
        reviewSections: review,
        sectionDeltas: sectionDeltas,
      );
    });
