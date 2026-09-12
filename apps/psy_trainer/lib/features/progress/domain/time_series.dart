import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/repositories/model/session.dart';

part 'time_series.freezed.dart';

/// One session of one family on a score-over-time chart (US-071): its
/// accuracy and median speed. [unanswered] attempts (timeouts) are counted
/// in [attempts] as wrong.
@freezed
abstract class TrendPoint with _$TrendPoint {
  const factory TrendPoint({
    required String sessionId,
    required SessionMode mode,
    required DateTime at,
    required int attempts,
    required int correct,
    required int unanswered,
    required double medianResponseMs,
  }) = _TrendPoint;

  const TrendPoint._();

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// The chart series of one family over a range: one [TrendPoint] per
/// session, oldest first. [from]/[to] echo the requested range (null = open).
@freezed
abstract class TimeSeries with _$TimeSeries {
  const factory TimeSeries({
    required String familyId,
    required List<TrendPoint> points,
    DateTime? from,
    DateTime? to,
  }) = _TimeSeries;

  const TimeSeries._();

  bool get isEmpty => points.isEmpty;

  TrendPoint? get latest => points.isEmpty ? null : points.last;

  int get totalAttempts => points.fold(0, (sum, p) => sum + p.attempts);
}
