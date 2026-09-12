import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../core/theme/app_theme.dart';

/// A 270-degree arc gauge showing a single 0..1 [value], with [child] (the
/// formatted figure) centred inside the arc.
///
/// Pure presentational: the caller decides the [color] (typically a semantic
/// band such as `success` / `warning` / `error`) and the text it reads as.
/// [semanticsLabel] and [semanticsValue] describe the gauge to screen
/// readers; the painted arc and the [child] are excluded from semantics.
class ArcGauge extends StatelessWidget {
  const ArcGauge({
    required this.value,
    required this.semanticsLabel,
    required this.semanticsValue,
    this.child,
    this.color,
    this.size = 168,
    super.key,
  }) : assert(size > 0, 'size must be positive');

  /// Progress in 0..1; values outside the range are clamped when painted.
  final double value;

  /// Arc colour; defaults to the accent.
  final Color? color;

  /// Diameter of the gauge in logical pixels.
  final double size;

  /// Widget drawn in the centre (the value text, a caption...).
  final Widget? child;

  final String semanticsLabel;
  final String semanticsValue;

  /// Sweep of the arc: three quarters of a turn, open at the bottom.
  static const double sweepAngle = 1.5 * math.pi;

  /// Where the arc starts: bottom-left, so the opening faces down.
  static const double startAngle = 0.75 * math.pi;

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context);
    return Semantics(
      container: true,
      label: semanticsLabel,
      value: semanticsValue,
      child: ExcludeSemantics(
        child: SizedBox(
          width: size,
          height: size,
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _ArcGaugePainter(
                value: value.clamp(0.0, 1.0),
                trackColor: theme.colors.border,
                arcColor: color ?? theme.colors.accent,
                strokeWidth: size * 0.085,
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(size * 0.2),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ArcGaugePainter extends CustomPainter {
  const _ArcGaugePainter({
    required this.value,
    required this.trackColor,
    required this.arcColor,
    required this.strokeWidth,
  });

  final double value;
  final Color trackColor;
  final Color arcColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      ArcGauge.startAngle,
      ArcGauge.sweepAngle,
      false,
      track,
    );
    if (value <= 0) return;
    final arc = Paint()
      ..color = arcColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      ArcGauge.startAngle,
      ArcGauge.sweepAngle * value,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_ArcGaugePainter oldDelegate) =>
      value != oldDelegate.value ||
      trackColor != oldDelegate.trackColor ||
      arcColor != oldDelegate.arcColor ||
      strokeWidth != oldDelegate.strokeWidth;
}
