import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/progress_snapshot.dart';
import 'progress_analytics_provider.dart';
import 'progress_version_provider.dart';

/// The dashboard snapshot (US-070), cached until [progressVersionProvider]
/// is bumped.
final FutureProvider<ProgressSnapshot> progressSnapshotProvider =
    FutureProvider<ProgressSnapshot>((ref) {
      ref.watch(progressVersionProvider);
      return ref.watch(progressAnalyticsProvider).snapshot();
    });
