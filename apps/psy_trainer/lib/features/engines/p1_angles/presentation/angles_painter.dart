import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart'
    show
        CustomPainter,
        FontWeight,
        TextDirection,
        TextPainter,
        TextSpan,
        TextStyle;

import '../domain/angle_board.dart';

/// Draws every [angles] (spec §2.3 row 5, US-114): each as two rays from a
/// shared vertex with the swept region shaded and its arc traced, laid out
/// in a single row of equal cells, labelled A, B, C... above the vertex.
///
/// Vector drawing only (`CustomPainter`, no image assets, ARCHITECTURE.md
/// "Engine" hard rule); the actual degree value is never printed on the
/// board itself, only in the practice feedback (the renderer's job, not the
/// painter's).
class AnglesPainter extends CustomPainter {
  const AnglesPainter({
    required this.angles,
    required this.rayColor,
    required this.arcColor,
    required this.labelColor,
  });

  final List<DrawnAngle> angles;
  final Color rayColor;
  final Color arcColor;
  final Color labelColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (angles.isEmpty) return;
    final cellWidth = size.width / angles.length;

    for (var i = 0; i < angles.length; i++) {
      final cellRect = Rect.fromLTWH(i * cellWidth, 0, cellWidth, size.height);
      _paintAngle(canvas, cellRect, angles[i]);
    }
  }

  void _paintAngle(Canvas canvas, Rect cell, DrawnAngle angle) {
    final vertex = Offset(cell.center.dx, cell.center.dy + cell.height * 0.12);
    final rayLength = math.min(cell.width, cell.height) * 0.38;
    final sweepRad = angle.sweepDeg * math.pi / 180;
    final endRad = angle.startRad + sweepRad;

    final rayPaint = Paint()
      ..color = rayColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final ray1 =
        vertex +
        Offset(math.cos(angle.startRad), math.sin(angle.startRad)) * rayLength;
    final ray2 =
        vertex + Offset(math.cos(endRad), math.sin(endRad)) * rayLength;

    // Shaded wedge, then the two rays, then the arc on top.
    final wedgeRadius = rayLength * 0.55;
    final wedgePath = Path()
      ..moveTo(vertex.dx, vertex.dy)
      ..arcTo(
        Rect.fromCircle(center: vertex, radius: wedgeRadius),
        angle.startRad,
        sweepRad,
        false,
      )
      ..close();
    canvas.drawPath(wedgePath, Paint()..color = arcColor.withAlpha(40));

    canvas.drawLine(vertex, ray1, rayPaint);
    canvas.drawLine(vertex, ray2, rayPaint);

    final arcPaint = Paint()
      ..color = arcColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawArc(
      Rect.fromCircle(center: vertex, radius: wedgeRadius),
      angle.startRad,
      sweepRad,
      false,
      arcPaint,
    );

    final labelPainter = TextPainter(
      text: TextSpan(
        text: angle.label,
        style: TextStyle(
          color: labelColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    labelPainter.paint(
      canvas,
      Offset(
        cell.center.dx - labelPainter.width / 2,
        vertex.dy - rayLength - labelPainter.height - 4,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant AnglesPainter oldDelegate) =>
      oldDelegate.angles != angles ||
      oldDelegate.rayColor != rayColor ||
      oldDelegate.arcColor != arcColor ||
      oldDelegate.labelColor != labelColor;
}
