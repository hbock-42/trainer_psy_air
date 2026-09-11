import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// One spoke of a [RadarChart].
@immutable
class RadarChartAxis {
  const RadarChartAxis({
    required this.label,
    required this.value,
    this.valueLabel,
  }) : assert(value >= 0 && value <= 1, 'value must be in 0..1');

  /// Short label painted at the end of the spoke.
  final String label;

  /// 0 (centre) .. 1 (outer ring).
  final double value;

  /// How the value reads to a screen reader (`niveau 3 sur 5`); defaults to
  /// a percentage.
  final String? valueLabel;

  String get semanticsValue => valueLabel ?? '${(value * 100).round()} %';
}

/// A radar (spider) chart of at least three 0..1 values, painted with
/// `CustomPaint`: concentric rings, one spoke per axis, a filled polygon of
/// the values and the axis labels around the outside.
///
/// Fills the available width up to [maxSize] (always square). Only the
/// accent colour and grey tokens are used; a band colour per axis does not
/// read well on a polygon, so callers that need level bands should use
/// [HorizontalBarChart] instead.
///
/// Accessibility: the chart is one semantics node whose value lists every
/// axis (`label: valueLabel`), prefixed by [semanticsLabel].
class RadarChart extends StatelessWidget {
  const RadarChart({
    required this.axes,
    required this.semanticsLabel,
    this.rings = 4,
    this.maxSize = 320,
    super.key,
  }) : assert(axes.length >= minAxes, 'A radar chart needs at least 3 axes'),
       assert(rings >= 1, 'rings must be at least 1');

  /// Fewer axes than this do not make a polygon; use a bar chart.
  static const int minAxes = 3;

  final List<RadarChartAxis> axes;
  final String semanticsLabel;

  /// Number of concentric rings (the outer one is the 100 % ring).
  final int rings;

  /// Largest side in logical pixels; the chart shrinks below narrow parents.
  final double maxSize;

  /// The textual description of the chart, also used for semantics.
  static String describe(Iterable<RadarChartAxis> axes) =>
      axes.map((a) => '${a.label} : ${a.semanticsValue}').join(', ');

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final labelStyle = theme.textStyles.caption.copyWith(
      color: theme.colors.textSecondary,
    );
    return Semantics(
      container: true,
      label: semanticsLabel,
      value: describe(axes),
      child: ExcludeSemantics(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final side = constraints.hasBoundedWidth
                ? math.min(constraints.maxWidth, maxSize)
                : maxSize;
            return SizedBox(
              width: side,
              height: side,
              child: CustomPaint(
                painter: _RadarChartPainter(
                  axes: axes,
                  rings: rings,
                  gridColor: theme.colors.border,
                  outerRingColor: theme.colors.borderStrong,
                  fillColor: theme.colors.accent.withValues(alpha: 0.25),
                  strokeColor: theme.colors.accent,
                  labelStyle: labelStyle,
                  textScaler: textScaler,
                  textDirection: Directionality.of(context),
                  labelGap: theme.spacing.sm,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _RadarChartPainter extends CustomPainter {
  const _RadarChartPainter({
    required this.axes,
    required this.rings,
    required this.gridColor,
    required this.outerRingColor,
    required this.fillColor,
    required this.strokeColor,
    required this.labelStyle,
    required this.textScaler,
    required this.textDirection,
    required this.labelGap,
  });

  final List<RadarChartAxis> axes;
  final int rings;
  final Color gridColor;
  final Color outerRingColor;
  final Color fillColor;
  final Color strokeColor;
  final TextStyle labelStyle;
  final TextScaler textScaler;
  final TextDirection textDirection;
  final double labelGap;

  @override
  void paint(Canvas canvas, Size size) {
    final n = axes.length;
    final center = size.center(Offset.zero);
    // Reserve a band around the plot for the labels (two scaled lines).
    final lineHeight = textScaler.scale(labelStyle.fontSize ?? 12) * 1.3;
    final labelBand = lineHeight * 2 + labelGap;
    final radius = math.max(0.0, size.shortestSide / 2 - labelBand);
    if (radius <= 0) return;

    Offset pointAt(int index, double fraction) {
      final angle = -math.pi / 2 + 2 * math.pi * index / n;
      return center +
          Offset(math.cos(angle), math.sin(angle)) * (radius * fraction);
    }

    final grid = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final outer = Paint()
      ..color = outerRingColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Rings.
    for (var r = 1; r <= rings; r++) {
      final fraction = r / rings;
      final ring = Path();
      for (var i = 0; i < n; i++) {
        final p = pointAt(i, fraction);
        if (i == 0) {
          ring.moveTo(p.dx, p.dy);
        } else {
          ring.lineTo(p.dx, p.dy);
        }
      }
      ring.close();
      canvas.drawPath(ring, r == rings ? outer : grid);
    }

    // Spokes.
    for (var i = 0; i < n; i++) {
      canvas.drawLine(center, pointAt(i, 1), grid);
    }

    // Value polygon.
    final polygon = Path();
    for (var i = 0; i < n; i++) {
      final p = pointAt(i, axes[i].value);
      if (i == 0) {
        polygon.moveTo(p.dx, p.dy);
      } else {
        polygon.lineTo(p.dx, p.dy);
      }
    }
    polygon.close();
    canvas.drawPath(polygon, Paint()..color = fillColor);
    canvas.drawPath(
      polygon,
      Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeJoin = StrokeJoin.round,
    );
    final dot = Paint()..color = strokeColor;
    for (var i = 0; i < n; i++) {
      canvas.drawCircle(pointAt(i, axes[i].value), 3, dot);
    }

    // Labels, anchored on the side of the spoke they sit on.
    final maxLabelWidth = size.width * 0.28;
    for (var i = 0; i < n; i++) {
      final angle = -math.pi / 2 + 2 * math.pi * i / n;
      final direction = Offset(math.cos(angle), math.sin(angle));
      final anchor = center + direction * (radius + labelGap);
      final painter = TextPainter(
        text: TextSpan(text: axes[i].label, style: labelStyle),
        textAlign: TextAlign.center,
        textDirection: textDirection,
        textScaler: textScaler,
        maxLines: 2,
        ellipsis: '…',
      )..layout(maxWidth: maxLabelWidth);
      // Slide the box so the point of the anchor touches the text on the
      // side facing the centre: (dx + 1) / 2 in 0..1 maps left -> right.
      final dx = anchor.dx - painter.width * (1 - direction.dx) / 2;
      final dy = anchor.dy - painter.height * (1 - direction.dy) / 2;
      painter.paint(canvas, Offset(dx, dy));
      painter.dispose();
    }
  }

  @override
  bool shouldRepaint(_RadarChartPainter oldDelegate) =>
      axes != oldDelegate.axes ||
      rings != oldDelegate.rings ||
      gridColor != oldDelegate.gridColor ||
      outerRingColor != oldDelegate.outerRingColor ||
      fillColor != oldDelegate.fillColor ||
      strokeColor != oldDelegate.strokeColor ||
      labelStyle != oldDelegate.labelStyle ||
      textScaler != oldDelegate.textScaler ||
      textDirection != oldDelegate.textDirection ||
      labelGap != oldDelegate.labelGap;
}
