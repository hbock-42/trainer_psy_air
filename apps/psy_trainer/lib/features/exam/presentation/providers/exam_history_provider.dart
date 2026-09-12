import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repository_providers.dart';
import '../../../progress/domain/exam_summary.dart';
import '../../../progress/presentation/providers/progress_analytics_provider.dart';
import 'exam_resume_provider.dart';

/// One row of the exam history (US-064): the summary plus the blueprint's
/// display name (null when the blueprint was removed since).
class ExamHistoryEntry {
  const ExamHistoryEntry({required this.summary, this.blueprintName});

  final ExamSummary summary;
  final String? blueprintName;

  /// Wall-clock length of the simulation, or null while it is still
  /// `inProgress` (no `endedAt` yet).
  Duration? get duration => summary.endedAt?.difference(summary.startedAt);
}

/// Past simulations, newest first (`ProgressAnalytics.examHistory`), each
/// with its blueprint's name resolved for display: date, score, duration
/// and status, tapping a finished one opens its report (US-062).
final FutureProvider<List<ExamHistoryEntry>> examHistoryProvider =
    FutureProvider<List<ExamHistoryEntry>>((ref) async {
      // Marks any exam interrupted for more than 10 minutes abandoned
      // before the history reflects it (US-064) -- same pass the Exam
      // home's "Reprendre" card runs, cached by Riverpod either way.
      await ref.watch(examResumeProvider.future);
      final analytics = ref.watch(progressAnalyticsProvider);
      final content = ref.watch(contentRepositoryProvider);
      final history = await analytics.examHistory();
      final names = <String, String?>{};
      final entries = <ExamHistoryEntry>[];
      for (final summary in history) {
        final blueprintId = summary.blueprintId;
        String? name;
        if (blueprintId != null) {
          if (!names.containsKey(blueprintId)) {
            final blueprint = await content.blueprintById(blueprintId);
            names[blueprintId] = blueprint?.name.fr;
          }
          name = names[blueprintId];
        }
        entries.add(ExamHistoryEntry(summary: summary, blueprintName: name));
      }
      return entries;
    });
