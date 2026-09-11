import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/exam_summary.dart';
import 'progress_analytics_provider.dart';
import 'progress_version_provider.dart';

/// Exam simulations newest first (US-071 exam chart, US-062 results), cached
/// until [progressVersionProvider] is bumped.
final FutureProvider<List<ExamSummary>> examHistoryProvider =
    FutureProvider<List<ExamSummary>>((ref) {
      ref.watch(progressVersionProvider);
      return ref.watch(progressAnalyticsProvider).examHistory();
    });
