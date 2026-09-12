import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/widgets.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/streak_service.dart';

/// GitHub-style calendar heat-map of daily activity (US-073): one column per
/// rolling 7-day chunk of [days] (oldest first, last column ending today),
/// one row per day within the chunk, painted with `CustomPainter`. Columns
/// are *not* aligned to calendar weeks (Monday-first, say) — they are simply
/// "the last N days" cut into sevens so every day in [days] is shown; the
/// data itself (`StreakService.summarize`'s `heatmap`) is what "12 weeks"
/// means here.
class ActivityHeatmap extends StatelessWidget {
  const ActivityHeatmap({
    required this.days,
    required this.semanticsLabel,
    required this.semanticsValue,
    this.cellSize = 14,
    this.cellGap = 3,
    super.key,
  }) : assert(cellSize > 0, 'cellSize must be positive'),
       assert(cellGap >= 0, 'cellGap must not be negative');

  /// Oldest first; a multiple of 7 (a whole number of columns).
  final List<DailyActivity> days;

  final String semanticsLabel;
  final String semanticsValue;

  final double cellSize;
  final double cellGap;

  /// 0 (no activity) to 4 (heaviest), by item count. Thresholds are fixed
  /// (not relative to the user's own goal) so the shape of the map does not
  /// change as the goal is edited.
  static int level(int itemCount) => switch (itemCount) {
    0 => 0,
    <= 2 => 1,
    <= 5 => 2,
    <= 9 => 3,
    _ => 4,
  };

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final columns = (days.length / 7).ceil();
    final width = columns * cellSize + (columns - 1) * cellGap;
    final height = 7 * cellSize + 6 * cellGap;
    return Semantics(
      container: true,
      label: semanticsLabel,
      value: semanticsValue,
      child: ExcludeSemantics(
        child: SizedBox(
          width: width,
          height: height,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _ActivityHeatmapPainter(
                days: days,
                cellSize: cellSize,
                cellGap: cellGap,
                emptyColor: theme.colors.border,
                activeColor: theme.colors.accent,
                subtleColor: theme.colors.accentSubtle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityHeatmapPainter extends CustomPainter {
  const _ActivityHeatmapPainter({
    required this.days,
    required this.cellSize,
    required this.cellGap,
    required this.emptyColor,
    required this.activeColor,
    required this.subtleColor,
  });

  final List<DailyActivity> days;
  final double cellSize;
  final double cellGap;
  final Color emptyColor;
  final Color activeColor;
  final Color subtleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(cellSize * 0.2);
    for (var i = 0; i < days.length; i++) {
      final column = i ~/ 7;
      final row = i % 7;
      final level = ActivityHeatmap.level(days[i].itemCount);
      final color = level == 0
          ? emptyColor
          : Color.lerp(subtleColor, activeColor, level / 4)!;
      final rect = Rect.fromLTWH(
        column * (cellSize + cellGap),
        row * (cellSize + cellGap),
        cellSize,
        cellSize,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, radius),
        Paint()..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_ActivityHeatmapPainter oldDelegate) =>
      !listEquals(days, oldDelegate.days) ||
      cellSize != oldDelegate.cellSize ||
      cellGap != oldDelegate.cellGap ||
      emptyColor != oldDelegate.emptyColor ||
      activeColor != oldDelegate.activeColor ||
      subtleColor != oldDelegate.subtleColor;
}
