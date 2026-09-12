import 'package:freezed_annotation/freezed_annotation.dart';

part 'family_progress.freezed.dart';

/// Sign of a [Trend].
enum TrendDirection { up, flat, down }

/// How a family's accuracy moved over a window of sessions (7 or 30 days).
///
/// [slope] is the least-squares slope of session accuracy against time, in
/// accuracy points per day; [delta] is last-minus-first session accuracy
/// (both 0..1 scale, so 0.05 = 5 points). [direction] is [TrendDirection.up]
/// or [TrendDirection.down] only when both agree and the delta reaches the
/// configured threshold; with fewer than two sessions it is flat.
@freezed
abstract class Trend with _$Trend {
  const factory Trend({
    required TrendDirection direction,
    required double slope,
    required double delta,
    required int sessions,
  }) = _Trend;

  const Trend._();

  static const Trend none = Trend(
    direction: TrendDirection.flat,
    slope: 0,
    delta: 0,
    sessions: 0,
  );

  bool get isNegative => direction == TrendDirection.down;
}

/// Everything the dashboard shows for one family (US-070): lifetime accuracy
/// and speed, a 1..5 level, short and long trends, volume and recency.
/// A family never practised has zero attempts, level 1, flat trends and
/// null speed/date.
@freezed
abstract class FamilyProgress with _$FamilyProgress {
  const factory FamilyProgress({
    required String familyId,
    required int attempts,
    required int correct,
    required int sessions,
    required int level,
    required Trend trend7d,
    required Trend trend30d,
    double? medianResponseMs,
    DateTime? lastPractisedAt,
  }) = _FamilyProgress;

  const FamilyProgress._();

  static const int minLevel = 1;
  static const int maxLevel = 5;

  double get accuracy => attempts == 0 ? 0 : correct / attempts;

  bool get hasData => attempts > 0;

  /// Level mapped onto 0..1 (level 1 = 0, level 5 = 1).
  double get levelFraction => (level - minLevel) / (maxLevel - minLevel);
}
