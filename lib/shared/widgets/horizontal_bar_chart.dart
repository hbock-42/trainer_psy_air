import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// One row of a [HorizontalBarChart].
@immutable
class BarChartEntry {
  const BarChartEntry({
    required this.label,
    required this.value,
    this.valueLabel,
    this.color,
  }) : assert(value >= 0 && value <= 1, 'value must be in 0..1');

  final String label;

  /// 0 (empty) .. 1 (full bar).
  final double value;

  /// Text shown at the end of the bar and read by screen readers
  /// (`niveau 3 sur 5`); defaults to a percentage.
  final String? valueLabel;

  /// Bar colour; defaults to the accent. Use the semantic tokens
  /// (`success` / `warning` / `error`) for level bands.
  final Color? color;

  String get semanticsValue => valueLabel ?? '${(value * 100).round()} %';
}

/// Horizontal bars, one per entry, with the label on the left and the value
/// on the right. The natural fallback of [RadarChart] below three axes.
///
/// Text scales with `MediaQuery.textScaler` (labels wrap), the bars are
/// painted with `CustomPaint` in the theme's radii. One semantics node
/// listing every entry, prefixed by [semanticsLabel].
class HorizontalBarChart extends StatelessWidget {
  const HorizontalBarChart({
    required this.entries,
    required this.semanticsLabel,
    this.barHeight = 12,
    super.key,
  }) : assert(entries.length > 0, 'A bar chart needs at least one entry');

  final List<BarChartEntry> entries;
  final String semanticsLabel;
  final double barHeight;

  /// The textual description of the chart, also used for semantics.
  static String describe(Iterable<BarChartEntry> entries) =>
      entries.map((e) => '${e.label} : ${e.semanticsValue}').join(', ');

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      container: true,
      label: semanticsLabel,
      value: describe(entries),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < entries.length; i++) ...[
              if (i > 0) SizedBox(height: theme.spacing.md),
              _BarRow(entry: entries[i], barHeight: barHeight),
            ],
          ],
        ),
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({required this.entry, required this.barHeight});

  final BarChartEntry entry;
  final double barHeight;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(entry.label, style: theme.textStyles.bodyStrong),
            ),
            SizedBox(width: theme.spacing.md),
            Text(
              entry.semanticsValue,
              style: theme.textStyles.caption.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.xs),
        SizedBox(
          height: barHeight,
          child: CustomPaint(
            painter: _BarPainter(
              value: entry.value,
              trackColor: theme.colors.border,
              fillColor: entry.color ?? theme.colors.accent,
              radius: theme.radii.sm,
            ),
          ),
        ),
      ],
    );
  }
}

class _BarPainter extends CustomPainter {
  const _BarPainter({
    required this.value,
    required this.trackColor,
    required this.fillColor,
    required this.radius,
  });

  final double value;
  final Color trackColor;
  final Color fillColor;
  final Radius radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = radius;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, r),
      Paint()..color = trackColor,
    );
    if (value <= 0) return;
    final width = (size.width * value).clamp(size.height, size.width);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, width, size.height), r),
      Paint()..color = fillColor,
    );
  }

  @override
  bool shouldRepaint(_BarPainter oldDelegate) =>
      value != oldDelegate.value ||
      trackColor != oldDelegate.trackColor ||
      fillColor != oldDelegate.fillColor ||
      radius != oldDelegate.radius;
}
