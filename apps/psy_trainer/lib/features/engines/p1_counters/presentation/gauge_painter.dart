import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../domain/gauge.dart';

/// Draws one [Gauge], vector-only (no image assets): a [GaugeKind.circular]
/// dial with a single needle, a [GaugeKind.linear] scale with a sliding
/// pointer, a [GaugeKind.multiNeedle] altimeter-style dial with a fast
/// "fine" needle and a slow "coarse" one, or a [GaugeKind.drum]
/// odometer-style digit strip. Theme-aware: every colour is passed in
/// (same convention as `TubesPainter`), never read from a `Theme`.
class GaugePainter extends CustomPainter {
  const GaugePainter({
    required this.gauge,
    required this.trackColor,
    required this.tickColor,
    required this.majorTickColor,
    required this.needleColor,
    required this.fineNeedleColor,
    required this.textColor,
  });

  final Gauge gauge;
  final Color trackColor;
  final Color tickColor;
  final Color majorTickColor;
  final Color needleColor;
  final Color fineNeedleColor;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    switch (gauge.kind) {
      case GaugeKind.circular:
        _paintCircular(canvas, size);
      case GaugeKind.multiNeedle:
        _paintMultiNeedle(canvas, size);
      case GaugeKind.linear:
        _paintLinear(canvas, size);
      case GaugeKind.drum:
        _paintDrum(canvas, size);
    }
  }

  void _paintCircular(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 * 0.88;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * 0.08
      ..color = trackColor;
    canvas.drawArc(
      rect,
      GaugeGeometry.startAngle,
      GaugeGeometry.sweepAngle,
      false,
      trackPaint,
    );

    final majorCount = ((gauge.rangeMax - gauge.rangeMin) / gauge.majorStep)
        .round();
    final totalMinorTicks = majorCount * gauge.minorPerMajor;
    for (var i = 0; i <= totalMinorTicks; i++) {
      final value = gauge.rangeMin + i * gauge.minorStep;
      final isMajor = i % gauge.minorPerMajor == 0;
      _drawCircularTick(canvas, center, radius, value, isMajor);
    }

    final needleAngle = GaugeGeometry.circularAngleForValue(
      gauge.value,
      gauge.rangeMin,
      gauge.rangeMax,
    );
    _drawNeedle(canvas, center, radius * 0.75, needleAngle, needleColor, 3);
    canvas.drawCircle(center, radius * 0.06, Paint()..color = needleColor);
  }

  void _drawCircularTick(
    Canvas canvas,
    Offset center,
    double radius,
    num value,
    bool isMajor,
  ) {
    final angle = GaugeGeometry.circularAngleForValue(
      value,
      gauge.rangeMin,
      gauge.rangeMax,
    );
    final outer = radius * 1.0;
    final inner = radius * (isMajor ? 0.82 : 0.9);
    final p1 = center + Offset(math.cos(angle), math.sin(angle)) * outer;
    final p2 = center + Offset(math.cos(angle), math.sin(angle)) * inner;
    final paint = Paint()
      ..color = isMajor ? majorTickColor : tickColor
      ..strokeWidth = isMajor ? 2.5 : 1.2;
    canvas.drawLine(p1, p2, paint);
  }

  void _drawNeedle(
    Canvas canvas,
    Offset center,
    double length,
    double angle,
    Color color,
    double width,
  ) {
    final tip = center + Offset(math.cos(angle), math.sin(angle)) * length;
    canvas.drawLine(
      center,
      tip,
      Paint()
        ..color = color
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round,
    );
  }

  void _paintMultiNeedle(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) / 2 * 0.88;
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * 0.06
        ..color = trackColor,
    );

    final fineAngle = GaugeGeometry.fineAngleForValue(
      gauge.value,
      gauge.minorCycle,
    );
    final coarseAngle = GaugeGeometry.coarseAngleForValue(
      gauge.value,
      gauge.rangeMax,
    );
    // Both needles sweep the full circle starting at "up" (-pi/2), not the
    // 270°-opening convention used by the single-needle dial.
    _drawNeedle(
      canvas,
      center,
      radius * 0.85,
      fineAngle - math.pi / 2,
      fineNeedleColor,
      2.5,
    );
    _drawNeedle(
      canvas,
      center,
      radius * 0.5,
      coarseAngle - math.pi / 2,
      needleColor,
      4,
    );
    canvas.drawCircle(center, radius * 0.06, Paint()..color = needleColor);
  }

  void _paintLinear(Canvas canvas, Size size) {
    final barTop = size.height * 0.35;
    final barBottom = size.height * 0.55;
    final left = size.width * 0.08;
    final right = size.width * 0.92;
    final barRect = Rect.fromLTRB(left, barTop, right, barBottom);
    canvas.drawRect(
      barRect,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = trackColor,
    );

    final majorCount = ((gauge.rangeMax - gauge.rangeMin) / gauge.majorStep)
        .round();
    final totalMinorTicks = majorCount * gauge.minorPerMajor;
    for (var i = 0; i <= totalMinorTicks; i++) {
      final value = gauge.rangeMin + i * gauge.minorStep;
      final isMajor = i % gauge.minorPerMajor == 0;
      final fraction = GaugeGeometry.linearFractionForValue(
        value,
        gauge.rangeMin,
        gauge.rangeMax,
      );
      final x = left + (right - left) * fraction;
      final tickTop = isMajor ? barTop - 10 : barTop - 5;
      canvas.drawLine(
        Offset(x, tickTop),
        Offset(x, barTop),
        Paint()
          ..color = isMajor ? majorTickColor : tickColor
          ..strokeWidth = isMajor ? 2 : 1,
      );
    }

    final pointerFraction = GaugeGeometry.linearFractionForValue(
      gauge.value,
      gauge.rangeMin,
      gauge.rangeMax,
    );
    final pointerX = left + (right - left) * pointerFraction;
    final path = Path()
      ..moveTo(pointerX, barBottom + 2)
      ..lineTo(pointerX - 6, barBottom + 14)
      ..lineTo(pointerX + 6, barBottom + 14)
      ..close();
    canvas.drawPath(path, Paint()..color = needleColor);
  }

  void _paintDrum(Canvas canvas, Size size) {
    final digitCount = gauge.digitCount ?? 3;
    final digits = gauge.value
        .round()
        .toString()
        .padLeft(digitCount, '0')
        .split('');
    final cellWidth = size.width / digitCount;
    for (var i = 0; i < digitCount; i++) {
      final rect = Rect.fromLTWH(i * cellWidth, 0, cellWidth, size.height);
      final inset = rect.deflate(cellWidth * 0.08);
      canvas.drawRect(
        inset,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5
          ..color = trackColor,
      );
      final textPainter = TextPainter(
        text: TextSpan(
          text: digits[i],
          style: TextStyle(
            color: textColor,
            fontSize: size.height * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        rect.center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) =>
      oldDelegate.gauge.kind != gauge.kind ||
      oldDelegate.gauge.value != gauge.value ||
      oldDelegate.gauge.rangeMin != gauge.rangeMin ||
      oldDelegate.gauge.rangeMax != gauge.rangeMax ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.needleColor != needleColor;
}
