import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/providers/active_module_provider.dart';
import '../../domain/progress_snapshot.dart';
import 'progress_analytics_provider.dart';
import 'progress_version_provider.dart';

/// The dashboard snapshot (US-070), cached until [progressVersionProvider]
/// is bumped. Scoped to the active module (US-101 module switch).
final FutureProvider<ProgressSnapshot> progressSnapshotProvider =
    FutureProvider<ProgressSnapshot>((ref) {
      ref.watch(progressVersionProvider);
      final moduleId = ref.watch(activeModuleProvider).moduleId;
      return ref.watch(progressAnalyticsProvider).snapshot(moduleId: moduleId);
    });
