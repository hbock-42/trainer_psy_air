import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../domain/matrix_figure.dart';

/// Draws one [MatrixFigure] (ARCHITECTURE.md: vector drawing with
/// `CustomPainter`, no image assets). [count] copies of [MatrixFigure
/// .outerShape] are laid out in a row, each carrying [MatrixFigure
/// .innerShape] nested inside when present; [MatrixFigure.position] shifts
/// the whole cluster within the tile (an `Alignment`) and [MatrixFigure
/// .sizeStep] scales it.
class MatrixFigurePainter extends CustomPainter {
  const MatrixFigurePainter({required this.figure, required this.color});

  final MatrixFigure figure;
  final Color color;

  static const List<double> _sizeScales = [0.55, 0.75, 1.0];

  @override
  void paint(Canvas canvas, Size size) {
    final scale = _sizeScales[figure.sizeStep];
    final unit = math.min(size.width, size.height) * 0.32 * scale;
    final spacing = unit * 1.9;
    final clusterWidth = spacing * (figure.count - 1);
    final alignment = _alignmentOf(figure.position);
    final center = Offset(
      size.width / 2 +
          alignment.x *
              (size.width / 2 - unit - clusterWidth / 2).clamp(
                0,
                double.infinity,
              ),
      size.height / 2 +
          alignment.y * (size.height / 2 - unit).clamp(0, double.infinity),
    );
    final start = center.dx - clusterWidth / 2;

    for (var i = 0; i < figure.count; i++) {
      final origin = Offset(start + spacing * i, center.dy);
      _paintOuter(canvas, origin, unit);
      final inner = figure.innerShape;
      if (inner != null) {
        _paintShape(
          canvas,
          origin,
          unit * 0.45,
          inner,
          figure.rotationDegrees,
          FillPattern.solid,
        );
      }
    }
  }

  void _paintOuter(Canvas canvas, Offset origin, double unit) {
    _paintShape(
      canvas,
      origin,
      unit,
      figure.outerShape,
      figure.rotationDegrees,
      figure.fill,
    );
  }

  void _paintShape(
    Canvas canvas,
    Offset origin,
    double radius,
    ShapeKind shape,
    int rotationDegrees,
    FillPattern fill,
  ) {
    canvas.save();
    canvas.translate(origin.dx, origin.dy);
    canvas.rotate(rotationDegrees * math.pi / 180);

    final path = _pathOf(shape, radius);
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = color;

    switch (fill) {
      case FillPattern.solid:
        canvas.drawPath(path, Paint()..color = color);
      case FillPattern.outline:
        canvas.drawPath(path, strokePaint);
      case FillPattern.hatched:
        canvas.save();
        canvas.clipPath(path);
        _drawHatching(canvas, radius);
        canvas.restore();
        canvas.drawPath(path, strokePaint);
      case FillPattern.dotted:
        canvas.save();
        canvas.clipPath(path);
        _drawDots(canvas, radius);
        canvas.restore();
        canvas.drawPath(path, strokePaint);
    }
    canvas.restore();
  }

  /// Fixed iteration counts throughout (never a `+= radius / k` step): a
  /// zero or near-zero [radius] (a widget laid out before its final size is
  /// known, e.g. mid-test) must not turn a float increment into an
  /// infinite loop.
  void _drawHatching(Canvas canvas, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..color = color;
    const lines = 5;
    for (var i = 0; i <= lines; i++) {
      final x = -radius + (2 * radius) * i / lines;
      canvas.drawLine(Offset(x, -radius), Offset(x + radius, radius), paint);
    }
  }

  void _drawDots(Canvas canvas, double radius) {
    final paint = Paint()..color = color;
    const perAxis = 5;
    for (var i = 0; i <= perAxis; i++) {
      final x = -radius + (2 * radius) * i / perAxis;
      for (var j = 0; j <= perAxis; j++) {
        final y = -radius + (2 * radius) * j / perAxis;
        canvas.drawCircle(Offset(x, y), radius / 10, paint);
      }
    }
  }

  Path _pathOf(ShapeKind shape, double r) {
    final path = Path();
    switch (shape) {
      case ShapeKind.circle:
        path.addOval(Rect.fromCircle(center: Offset.zero, radius: r));
      case ShapeKind.square:
        path.addRect(Rect.fromCircle(center: Offset.zero, radius: r * 0.85));
      case ShapeKind.triangle:
        path.moveTo(0, -r);
        path.lineTo(r * 0.87, r * 0.5);
        path.lineTo(-r * 0.87, r * 0.5);
        path.close();
      case ShapeKind.diamond:
        path.moveTo(0, -r);
        path.lineTo(r, 0);
        path.lineTo(0, r);
        path.lineTo(-r, 0);
        path.close();
      case ShapeKind.star:
        _addStar(path, r);
      case ShapeKind.hexagon:
        _addPolygon(path, r, 6);
    }
    return path;
  }

  void _addPolygon(Path path, double r, int sides) {
    for (var i = 0; i < sides; i++) {
      final angle = -math.pi / 2 + i * 2 * math.pi / sides;
      final point = Offset(r * math.cos(angle), r * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
  }

  void _addStar(Path path, double r) {
    const points = 5;
    for (var i = 0; i < points * 2; i++) {
      final angle = -math.pi / 2 + i * math.pi / points;
      final radius = i.isEven ? r : r * 0.42;
      final point = Offset(radius * math.cos(angle), radius * math.sin(angle));
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
  }

  Alignment _alignmentOf(PositionSlot slot) => switch (slot) {
    PositionSlot.center => Alignment.center,
    PositionSlot.topLeft => Alignment.topLeft,
    PositionSlot.topRight => Alignment.topRight,
    PositionSlot.bottomLeft => Alignment.bottomLeft,
    PositionSlot.bottomRight => Alignment.bottomRight,
  };

  @override
  bool shouldRepaint(MatrixFigurePainter oldDelegate) =>
      oldDelegate.figure != figure || oldDelegate.color != color;
}
