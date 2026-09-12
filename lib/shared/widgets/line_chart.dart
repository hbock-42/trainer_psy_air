import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// One value of a [LineChartSeries].
@immutable
class LineChartPoint {
  const LineChartPoint(this.x, this.y);

  final double x;
  final double y;

  @override
  bool operator ==(Object other) =>
      other is LineChartPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'LineChartPoint($x, $y)';
}

/// One line of a [LineChart]: its points in ascending `x` order.
@immutable
class LineChartSeries {
  const LineChartSeries({
    required this.label,
    required this.points,
    this.color,
  });

  /// Name of the series, shown in the default tooltip.
  final String label;

  /// Points sorted by `x` (the chart does not sort them).
  final List<LineChartPoint> points;

  /// Line colour; defaults to the accent for the first series, then
  /// `success`, `warning`, `error`.
  final Color? color;
}

/// A labelled position on an axis.
@immutable
class LineChartTick {
  const LineChartTick(this.value, this.label);

  final double value;
  final String label;

  @override
  bool operator ==(Object other) =>
      other is LineChartTick && other.value == value && other.label == label;

  @override
  int get hashCode => Object.hash(value, label);
}

/// The point of one series under the pointer.
@immutable
class LineChartHitEntry {
  const LineChartHitEntry({
    required this.seriesIndex,
    required this.pointIndex,
    required this.point,
  });

  final int seriesIndex;
  final int pointIndex;
  final LineChartPoint point;
}

/// What the pointer is over: the nearest `x` among every series' points and,
/// for each series that has a point at that `x`, the point.
@immutable
class LineChartHit {
  const LineChartHit({required this.x, required this.entries});

  final double x;
  final List<LineChartHitEntry> entries;
}

/// Maps data coordinates to pixels inside a plot rectangle. Pure Dart, so
/// the mapping is unit-testable without a widget tree.
@immutable
class LineChartScale {
  const LineChartScale({
    required this.xMin,
    required this.xMax,
    required this.yMin,
    required this.yMax,
    required this.plot,
  }) : assert(xMax > xMin, 'xMax must be greater than xMin'),
       assert(yMax > yMin, 'yMax must be greater than yMin');

  /// Fits the `x` range to the points of [series] and, when [yMin] / [yMax]
  /// are null, the `y` range to their values with [yPadding] of headroom on
  /// each side. A degenerate range (one point, or every value equal) is
  /// widened by [degenerateHalfRange] on both sides so it still maps.
  factory LineChartScale.fit({
    required Iterable<LineChartSeries> series,
    required Rect plot,
    double? yMin,
    double? yMax,
    double yPadding = 0.1,
    double degenerateHalfRange = 0.5,
  }) {
    var xLo = double.infinity;
    var xHi = double.negativeInfinity;
    var yLo = double.infinity;
    var yHi = double.negativeInfinity;
    for (final s in series) {
      for (final p in s.points) {
        xLo = math.min(xLo, p.x);
        xHi = math.max(xHi, p.x);
        yLo = math.min(yLo, p.y);
        yHi = math.max(yHi, p.y);
      }
    }
    if (xLo == double.infinity) {
      xLo = 0;
      xHi = 0;
      yLo = 0;
      yHi = 0;
    }
    if (xHi <= xLo) {
      xLo -= degenerateHalfRange;
      xHi += degenerateHalfRange;
    }
    var lo = yMin ?? yLo;
    var hi = yMax ?? yHi;
    if (yMin == null || yMax == null) {
      final span = hi - lo;
      final pad = span <= 0 ? degenerateHalfRange : span * yPadding;
      if (yMin == null) lo -= pad;
      if (yMax == null) hi += pad;
    }
    if (hi <= lo) {
      lo -= degenerateHalfRange;
      hi += degenerateHalfRange;
    }
    return LineChartScale(xMin: xLo, xMax: xHi, yMin: lo, yMax: hi, plot: plot);
  }

  final double xMin;
  final double xMax;
  final double yMin;
  final double yMax;

  /// The area where lines are drawn, in the chart's coordinates.
  final Rect plot;

  double dx(double x) => plot.left + (x - xMin) / (xMax - xMin) * plot.width;

  /// `y` grows upwards: [yMax] maps to the top of [plot].
  double dy(double y) => plot.bottom - (y - yMin) / (yMax - yMin) * plot.height;

  Offset toOffset(LineChartPoint p) => Offset(dx(p.x), dy(p.y));

  /// Inverse of [dx]; not clamped.
  double xAt(double pixelX) =>
      xMin + (pixelX - plot.left) / plot.width * (xMax - xMin);

  /// The nearest `x` (by pixel distance) among every point of [series], and
  /// each series' point at that `x`. Null when there is no point.
  LineChartHit? nearest(Iterable<LineChartSeries> series, double pixelX) {
    double? bestX;
    var bestDistance = double.infinity;
    for (final s in series) {
      for (final p in s.points) {
        final distance = (dx(p.x) - pixelX).abs();
        if (distance < bestDistance) {
          bestDistance = distance;
          bestX = p.x;
        }
      }
    }
    if (bestX == null) return null;
    return hitAt(series, bestX);
  }

  /// The entries of every series that has a point at exactly [x].
  LineChartHit hitAt(Iterable<LineChartSeries> series, double x) {
    final entries = <LineChartHitEntry>[];
    var seriesIndex = 0;
    for (final s in series) {
      for (var i = 0; i < s.points.length; i++) {
        if (s.points[i].x == x) {
          entries.add(
            LineChartHitEntry(
              seriesIndex: seriesIndex,
              pointIndex: i,
              point: s.points[i],
            ),
          );
        }
      }
      seriesIndex++;
    }
    return LineChartHit(x: x, entries: entries);
  }

  @override
  bool operator ==(Object other) =>
      other is LineChartScale &&
      other.xMin == xMin &&
      other.xMax == xMax &&
      other.yMin == yMin &&
      other.yMax == yMax &&
      other.plot == plot;

  @override
  int get hashCode => Object.hash(xMin, xMax, yMin, yMax, plot);
}

/// Formats a tick or tooltip value.
typedef LineChartFormatter = String Function(double value);

/// Builds the tooltip shown over [LineChart] for a hit.
typedef LineChartTooltipBuilder =
    Widget Function(BuildContext context, LineChartHit hit);

/// One or more series drawn as lines over a grid, painted with
/// `CustomPaint`: horizontal gridlines at [yTicks] with their labels on the
/// left, [xTicks] labels under the baseline, points on every value and, for
/// a single series, a faint area under the line.
///
/// Hovering (mouse) or pressing (touch) shows a tooltip at the nearest `x`
/// and a vertical guide; a release reports the hit through [onPointSelected]
/// so the caller can open a detail panel. [selectedX] paints a persistent
/// highlight (the exam chart keeps the tapped attempt selected).
///
/// Colours come from the theme (grid: `border`, labels: `textSecondary`,
/// lines: accent then the semantic tokens), so the chart reads in dark mode
/// without any extra work. Range and mode selectors live outside the chart.
///
/// Accessibility: one semantics node, [semanticsLabel] and a caller-written
/// [semanticsValue] such as "accuracy from 40 % to 70 % over 6 sessions";
/// the painting and the tooltip are excluded.
class LineChart extends StatefulWidget {
  const LineChart({
    required this.series,
    required this.semanticsLabel,
    required this.semanticsValue,
    this.yMin,
    this.yMax,
    this.xTicks = const [],
    this.yTicks = const [],
    this.height = 200,
    this.formatX,
    this.formatY,
    this.tooltipBuilder,
    this.onPointSelected,
    this.selectedX,
    this.showPoints = true,
    super.key,
  }) : assert(height > 0, 'height must be positive');

  final List<LineChartSeries> series;
  final String semanticsLabel;
  final String semanticsValue;

  /// Fixed `y` bounds; null fits the data with 10 % of headroom.
  final double? yMin;
  final double? yMax;

  /// Labelled positions; [yTicks] also draw gridlines.
  final List<LineChartTick> xTicks;
  final List<LineChartTick> yTicks;

  /// Height of the whole chart (labels included) in logical pixels.
  final double height;

  /// Formatters of the default tooltip; default to one decimal.
  final LineChartFormatter? formatX;
  final LineChartFormatter? formatY;

  /// Replaces the default tooltip (`x`, then `label : y` per series).
  final LineChartTooltipBuilder? tooltipBuilder;

  /// Called on a tap / click release with the hit under the pointer.
  final ValueChanged<LineChartHit>? onPointSelected;

  /// `x` of the persistently highlighted point, if any.
  final double? selectedX;

  /// Whether every value gets a dot (off for dense series).
  final bool showPoints;

  /// Diameter of the point dots; the ring on the hit point is larger.
  static const double pointRadius = 3.5;

  /// [count] evenly spaced ticks between [min] and [max] inclusive.
  static List<LineChartTick> evenTicks(
    double min,
    double max, {
    required LineChartFormatter format,
    int count = 5,
  }) {
    assert(count >= 2, 'at least two ticks');
    final ticks = <LineChartTick>[];
    for (var i = 0; i < count; i++) {
      final value = min + (max - min) * i / (count - 1);
      ticks.add(LineChartTick(value, format(value)));
    }
    return ticks;
  }

  /// The colour of series [index] when none is given: accent, then the
  /// semantic tokens.
  static Color defaultColor(AppTheme theme, int index) => switch (index % 4) {
    0 => theme.colors.accent,
    1 => theme.colors.success,
    2 => theme.colors.warning,
    _ => theme.colors.error,
  };

  static String _defaultFormat(double v) => v.toStringAsFixed(1);

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  /// The point under the pointer (hover) or last pressed (touch).
  LineChartHit? _hit;

  void _update(LineChartScale scale, Offset local) {
    final hit = scale.nearest(widget.series, local.dx);
    if (hit?.x != _hit?.x) setState(() => _hit = hit);
  }

  void _clear() {
    if (_hit != null) setState(() => _hit = null);
  }

  @override
  void didUpdateWidget(LineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.series, widget.series) && _hit != null) {
      // The data moved under the tooltip: drop a hit that no longer exists.
      final stillThere = widget.series.any(
        (s) => s.points.any((p) => p.x == _hit!.x),
      );
      if (!stillThere) _hit = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.series.isNotEmpty, 'A line chart needs at least one series');
    final theme = AppTheme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);
    final textDirection = Directionality.of(context);
    final labelStyle = theme.textStyles.caption.copyWith(
      color: theme.colors.textSecondary,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    final colors = [
      for (var i = 0; i < widget.series.length; i++)
        widget.series[i].color ?? LineChart.defaultColor(theme, i),
    ];

    return Semantics(
      container: true,
      label: widget.semanticsLabel,
      value: widget.semanticsValue,
      child: ExcludeSemantics(
        child: SizedBox(
          height: widget.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, widget.height);
              final plot = LineChartLayout.plotRect(
                size: size,
                xTicks: widget.xTicks,
                yTicks: widget.yTicks,
                labelStyle: labelStyle,
                textScaler: textScaler,
                textDirection: textDirection,
                gap: theme.spacing.sm,
              );
              final scale = LineChartScale.fit(
                series: widget.series,
                plot: plot,
                yMin: widget.yMin,
                yMax: widget.yMax,
              );
              final hit = _hit;
              return MouseRegion(
                cursor: SystemMouseCursors.basic,
                onHover: (e) => _update(scale, e.localPosition),
                onExit: (_) => _clear(),
                child: Listener(
                  behavior: HitTestBehavior.opaque,
                  onPointerDown: (e) => _update(scale, e.localPosition),
                  onPointerMove: (e) => _update(scale, e.localPosition),
                  // The tooltip stays after a touch release (there is no
                  // hover to keep it); the mouse's exit clears it.
                  onPointerUp: (e) {
                    final hit = scale.nearest(
                      widget.series,
                      e.localPosition.dx,
                    );
                    if (hit != null) widget.onPointSelected?.call(hit);
                  },
                  onPointerCancel: (_) => _clear(),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: LineChartPainter(
                            series: widget.series,
                            colors: colors,
                            scale: scale,
                            xTicks: widget.xTicks,
                            yTicks: widget.yTicks,
                            gridColor: theme.colors.border,
                            axisColor: theme.colors.borderStrong,
                            guideColor: theme.colors.textMuted,
                            surfaceColor: theme.colors.surface,
                            labelStyle: labelStyle,
                            textScaler: textScaler,
                            textDirection: textDirection,
                            gap: theme.spacing.sm,
                            showPoints: widget.showPoints,
                            highlightX: hit?.x,
                            selectedX: widget.selectedX,
                          ),
                        ),
                      ),
                      if (hit != null && hit.entries.isNotEmpty)
                        _TooltipLayer(
                          hit: hit,
                          scale: scale,
                          chartSize: size,
                          child: widget.tooltipBuilder != null
                              ? widget.tooltipBuilder!(context, hit)
                              : _DefaultTooltip(
                                  hit: hit,
                                  series: widget.series,
                                  colors: colors,
                                  formatX:
                                      widget.formatX ??
                                      LineChart._defaultFormat,
                                  formatY:
                                      widget.formatY ??
                                      LineChart._defaultFormat,
                                ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Computes where the plot area sits inside the chart so the painter, the
/// hit-testing and the tooltip agree.
abstract final class LineChartLayout {
  /// The plot rectangle: room on the left for the widest `y` label, under
  /// the baseline for one line of `x` labels, and half a label on the right
  /// and top so the end labels and the last point are not clipped.
  static Rect plotRect({
    required Size size,
    required List<LineChartTick> xTicks,
    required List<LineChartTick> yTicks,
    required TextStyle labelStyle,
    required TextScaler textScaler,
    required TextDirection textDirection,
    required double gap,
  }) {
    var leftLabels = 0.0;
    for (final t in yTicks) {
      leftLabels = math.max(
        leftLabels,
        _measure(t.label, labelStyle, textScaler, textDirection).width,
      );
    }
    var bottomLabels = 0.0;
    var lastXLabelHalf = 0.0;
    for (final t in xTicks) {
      final m = _measure(t.label, labelStyle, textScaler, textDirection);
      bottomLabels = math.max(bottomLabels, m.height);
      lastXLabelHalf = math.max(lastXLabelHalf, m.width / 2);
    }
    final left = leftLabels > 0 ? leftLabels + gap : LineChart.pointRadius * 2;
    final bottom = bottomLabels > 0
        ? bottomLabels + gap
        : LineChart.pointRadius * 2;
    final right = math.max(lastXLabelHalf, LineChart.pointRadius * 2);
    const top = LineChart.pointRadius * 2;
    final width = math.max(1.0, size.width - left - right);
    final height = math.max(1.0, size.height - top - bottom);
    return Rect.fromLTWH(left, top, width, height);
  }

  static Size _measure(
    String text,
    TextStyle style,
    TextScaler textScaler,
    TextDirection textDirection,
  ) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: textDirection,
      textScaler: textScaler,
      maxLines: 1,
    )..layout();
    final size = painter.size;
    painter.dispose();
    return size;
  }
}

/// Paints grid, axis labels, lines, points and the hit / selection guides.
/// Public so tests can paint it directly.
class LineChartPainter extends CustomPainter {
  const LineChartPainter({
    required this.series,
    required this.colors,
    required this.scale,
    required this.xTicks,
    required this.yTicks,
    required this.gridColor,
    required this.axisColor,
    required this.guideColor,
    required this.surfaceColor,
    required this.labelStyle,
    required this.textScaler,
    required this.textDirection,
    required this.gap,
    required this.showPoints,
    this.highlightX,
    this.selectedX,
  });

  final List<LineChartSeries> series;
  final List<Color> colors;
  final LineChartScale scale;
  final List<LineChartTick> xTicks;
  final List<LineChartTick> yTicks;
  final Color gridColor;
  final Color axisColor;
  final Color guideColor;
  final Color surfaceColor;
  final TextStyle labelStyle;
  final TextScaler textScaler;
  final TextDirection textDirection;
  final double gap;
  final bool showPoints;
  final double? highlightX;
  final double? selectedX;

  @override
  void paint(Canvas canvas, Size size) {
    final plot = scale.plot;
    final grid = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Gridlines and y labels.
    for (final t in yTicks) {
      final y = scale.dy(t.value);
      if (y < plot.top - 0.5 || y > plot.bottom + 0.5) continue;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), grid);
      final painter = _text(t.label);
      painter.paint(
        canvas,
        Offset(plot.left - gap - painter.width, y - painter.height / 2),
      );
      painter.dispose();
    }

    // Baseline and x labels.
    canvas.drawLine(
      Offset(plot.left, plot.bottom),
      Offset(plot.right, plot.bottom),
      Paint()
        ..color = axisColor
        ..strokeWidth = 1,
    );
    double? lastRight;
    for (final t in xTicks) {
      final x = scale.dx(t.value);
      if (x < plot.left - 0.5 || x > plot.right + 0.5) continue;
      final painter = _text(t.label);
      final double left = (x - painter.width / 2).clamp(
        0.0,
        math.max(0.0, size.width - painter.width),
      );
      // Skip a label that would overlap the previous one.
      if (lastRight != null && left < lastRight + gap / 2) {
        painter.dispose();
        continue;
      }
      painter.paint(canvas, Offset(left, plot.bottom + gap));
      lastRight = left + painter.width;
      painter.dispose();
    }

    canvas.save();
    canvas.clipRect(plot.inflate(LineChart.pointRadius * 2));

    // Selection guide (persistent) then hover guide.
    for (final (x, dashed) in [(selectedX, false), (highlightX, true)]) {
      if (x == null) continue;
      final px = scale.dx(x);
      final paint = Paint()
        ..color = guideColor
        ..strokeWidth = 1;
      if (dashed) {
        _dashedLine(
          canvas,
          Offset(px, plot.top),
          Offset(px, plot.bottom),
          paint,
        );
      } else {
        canvas.drawLine(Offset(px, plot.top), Offset(px, plot.bottom), paint);
      }
    }

    // Lines, area (single series) and points.
    for (var i = 0; i < series.length; i++) {
      final s = series[i];
      if (s.points.isEmpty) continue;
      final color = colors[i];
      final path = Path();
      for (var j = 0; j < s.points.length; j++) {
        final o = scale.toOffset(s.points[j]);
        if (j == 0) {
          path.moveTo(o.dx, o.dy);
        } else {
          path.lineTo(o.dx, o.dy);
        }
      }
      if (series.length == 1 && s.points.length > 1) {
        final area = Path.from(path)
          ..lineTo(scale.dx(s.points.last.x), plot.bottom)
          ..lineTo(scale.dx(s.points.first.x), plot.bottom)
          ..close();
        canvas.drawPath(area, Paint()..color = color.withValues(alpha: 0.12));
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeJoin = StrokeJoin.round
          ..strokeCap = StrokeCap.round,
      );
      if (showPoints || s.points.length == 1) {
        final dot = Paint()..color = color;
        for (final p in s.points) {
          canvas.drawCircle(scale.toOffset(p), LineChart.pointRadius, dot);
        }
      }
      // Rings on the hit and selected points.
      for (final x in {highlightX, selectedX}) {
        if (x == null) continue;
        for (final p in s.points) {
          if (p.x != x) continue;
          final o = scale.toOffset(p);
          canvas.drawCircle(
            o,
            LineChart.pointRadius + 3,
            Paint()..color = surfaceColor,
          );
          canvas.drawCircle(
            o,
            LineChart.pointRadius + 3,
            Paint()
              ..color = color
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2,
          );
          canvas.drawCircle(o, LineChart.pointRadius, Paint()..color = color);
        }
      }
    }
    canvas.restore();
  }

  TextPainter _text(String text) => TextPainter(
    text: TextSpan(text: text, style: labelStyle),
    textDirection: textDirection,
    textScaler: textScaler,
    maxLines: 1,
  )..layout();

  static void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 4.0;
    const space = 3.0;
    final length = (b - a).distance;
    if (length == 0) return;
    final direction = (b - a) / length;
    var travelled = 0.0;
    while (travelled < length) {
      final end = math.min(travelled + dash, length);
      canvas.drawLine(a + direction * travelled, a + direction * end, paint);
      travelled = end + space;
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) =>
      series != oldDelegate.series ||
      colors != oldDelegate.colors ||
      scale != oldDelegate.scale ||
      xTicks != oldDelegate.xTicks ||
      yTicks != oldDelegate.yTicks ||
      gridColor != oldDelegate.gridColor ||
      axisColor != oldDelegate.axisColor ||
      guideColor != oldDelegate.guideColor ||
      surfaceColor != oldDelegate.surfaceColor ||
      labelStyle != oldDelegate.labelStyle ||
      textScaler != oldDelegate.textScaler ||
      textDirection != oldDelegate.textDirection ||
      gap != oldDelegate.gap ||
      showPoints != oldDelegate.showPoints ||
      highlightX != oldDelegate.highlightX ||
      selectedX != oldDelegate.selectedX;
}

/// Places the tooltip next to the hit point, flipping to the left past the
/// middle of the plot and clamped inside the chart.
class _TooltipLayer extends StatelessWidget {
  const _TooltipLayer({
    required this.hit,
    required this.scale,
    required this.chartSize,
    required this.child,
  });

  final LineChartHit hit;
  final LineChartScale scale;
  final Size chartSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    final px = scale.dx(hit.x);
    final onRight = px <= scale.plot.center.dx;
    // Anchor on the highest point of the hit so the box never covers it.
    var top = scale.plot.bottom;
    for (final e in hit.entries) {
      top = math.min(top, scale.dy(e.point.y));
    }
    final maxWidth = math.max(80.0, chartSize.width * 0.6);
    return Positioned(
      left: onRight ? px + theme.spacing.md : null,
      right: onRight ? null : chartSize.width - px + theme.spacing.md,
      top: math.max(0.0, top - theme.spacing.md),
      child: IgnorePointer(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: maxWidth,
            maxHeight: math.max(0.0, chartSize.height),
          ),
          child: LineChartTooltip(child: child),
        ),
      ),
    );
  }
}

/// The tooltip frame of [LineChart]: a raised surface with a border, used
/// by the default tooltip and available to custom [LineChart.tooltipBuilder]s
/// that only want to change the content.
class LineChartTooltip extends StatelessWidget {
  const LineChartTooltip({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colors.surfaceRaised,
        borderRadius: theme.radii.mdAll,
        border: Border.all(color: theme.colors.borderStrong),
      ),
      child: Padding(padding: EdgeInsets.all(theme.spacing.sm), child: child),
    );
  }
}

class _DefaultTooltip extends StatelessWidget {
  const _DefaultTooltip({
    required this.hit,
    required this.series,
    required this.colors,
    required this.formatX,
    required this.formatY,
  });

  final LineChartHit hit;
  final List<LineChartSeries> series;
  final List<Color> colors;
  final LineChartFormatter formatX;
  final LineChartFormatter formatY;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatX(hit.x), style: theme.textStyles.label),
        for (final e in hit.entries)
          Text(
            '${series[e.seriesIndex].label} : ${formatY(e.point.y)}',
            style: theme.textStyles.caption.copyWith(
              color: colors[e.seriesIndex],
            ),
          ),
      ],
    );
  }
}
