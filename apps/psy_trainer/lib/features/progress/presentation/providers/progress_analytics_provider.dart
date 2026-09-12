import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/repository_providers.dart';
import '../../domain/progress_analytics.dart';
import 'stats_service_provider.dart';

/// Async access to the stats service over the app repositories.
final Provider<ProgressAnalytics> progressAnalyticsProvider =
    Provider<ProgressAnalytics>(
      (ref) => ProgressAnalytics(
        progress: ref.watch(progressRepositoryProvider),
        content: ref.watch(contentRepositoryProvider),
        stats: ref.watch(statsServiceProvider),
      ),
    );
