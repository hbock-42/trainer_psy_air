import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/repositories/model/session.dart';
import '../../domain/time_series.dart';
import 'progress_analytics_provider.dart';
import 'progress_version_provider.dart';

/// Argument of [familyTimeSeriesProvider]: a family and an optional range
/// and mode. A record, so equal queries share one cached series.
typedef TimeSeriesQuery = ({
  String familyId,
  DateTime? from,
  DateTime? to,
  SessionMode? mode,
});

/// Score-over-time series of one family (US-071 charts). Auto-disposed when
/// no chart watches it; recomputed when [progressVersionProvider] is bumped.
final familyTimeSeriesProvider = FutureProvider.autoDispose
    .family<TimeSeries, TimeSeriesQuery>((ref, query) {
      ref.watch(progressVersionProvider);
      return ref
          .watch(progressAnalyticsProvider)
          .familyTimeSeries(
            query.familyId,
            from: query.from,
            to: query.to,
            mode: query.mode,
          );
    });
