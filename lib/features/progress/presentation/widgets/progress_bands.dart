import 'dart:ui';

import '../../../../core/theme/app_theme.dart';
import '../../domain/family_progress.dart';

/// Semantic colour bands shared by the dashboard charts: a figure is painted
/// `error` when weak, `warning` when middling and `success` when strong, so
/// the gauge, bars and score chips agree.
abstract final class ProgressBands {
  /// Readiness below this (0..100) is painted `error`.
  static const double readinessWarningFrom = 40;

  /// Readiness at or above this (0..100) is painted `success`.
  static const double readinessSuccessFrom = 70;

  /// Levels 1..2 are `error`, 3 is `warning`, 4..5 `success`.
  static const int levelWarningFrom = 3;
  static const int levelSuccessFrom = 4;

  static Color readiness(AppTheme theme, double value) {
    if (value < readinessWarningFrom) return theme.colors.error;
    if (value < readinessSuccessFrom) return theme.colors.warning;
    return theme.colors.success;
  }

  static Color level(AppTheme theme, int level) {
    if (level < levelWarningFrom) return theme.colors.error;
    if (level < levelSuccessFrom) return theme.colors.warning;
    return theme.colors.success;
  }

  /// A session score in 0..1 uses the same thresholds as readiness.
  static Color score(AppTheme theme, double score) =>
      readiness(theme, score * 100);
}

/// Overall direction of the candidate's progress, derived from the 30-day
/// trends of the families with data: `up` when more families improve than
/// decline, `down` in the opposite case, `flat` otherwise.
TrendDirection overallTrend(Iterable<FamilyProgress> families) {
  var ups = 0;
  var downs = 0;
  for (final f in families) {
    if (!f.hasData) continue;
    switch (f.trend30d.direction) {
      case TrendDirection.up:
        ups++;
      case TrendDirection.down:
        downs++;
      case TrendDirection.flat:
        break;
    }
  }
  if (ups > downs) return TrendDirection.up;
  if (downs > ups) return TrendDirection.down;
  return TrendDirection.flat;
}
