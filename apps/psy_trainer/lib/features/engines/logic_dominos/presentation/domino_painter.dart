import 'package:flutter/widgets.dart';

/// Pip layout of a domino half, one entry per value 0-6, each pip as a
/// fractional `(x, y)` of the half's box (0..1).
const Map<int, List<Offset>> _pipLayouts = {
  0: [],
  1: [Offset(0.5, 0.5)],
  2: [Offset(0.25, 0.25), Offset(0.75, 0.75)],
  3: [Offset(0.25, 0.25), Offset(0.5, 0.5), Offset(0.75, 0.75)],
  4: [
    Offset(0.25, 0.25),
    Offset(0.75, 0.25),
    Offset(0.25, 0.75),
    Offset(0.75, 0.75),
  ],
  5: [
    Offset(0.25, 0.25),
    Offset(0.75, 0.25),
    Offset(0.5, 0.5),
    Offset(0.25, 0.75),
    Offset(0.75, 0.75),
  ],
  6: [
    Offset(0.25, 0.2),
    Offset(0.75, 0.2),
    Offset(0.25, 0.5),
    Offset(0.75, 0.5),
    Offset(0.25, 0.8),
    Offset(0.75, 0.8),
  ],
};

/// Draws one domino (two stacked halves, a middle divider, and pips) --
/// US-024's vector rendering, no image assets.
///
/// [top] / [bottom] are `0..6`, or null to draw a blank ("missing") half.
class DominoPainter extends CustomPainter {
  const DominoPainter({
    required this.top,
    required this.bottom,
    required this.faceColor,
    required this.borderColor,
    required this.pipColor,
    required this.missingColor,
  });

  final int? top;
  final int? bottom;
  final Color faceColor;
  final Color borderColor;
  final Color pipColor;

  /// Fill of a half whose value is null (the domino being guessed).
  final Color missingColor;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = Radius.circular(size.width * 0.12);
    final outline = RRect.fromRectAndRadius(Offset.zero & size, radius);
    final facePaint = Paint()..color = faceColor;
    canvas.drawRRect(outline, facePaint);

    final halfHeight = size.height / 2;
    _paintHalf(canvas, Rect.fromLTWH(0, 0, size.width, halfHeight), top);
    _paintHalf(
      canvas,
      Rect.fromLTWH(0, halfHeight, size.width, halfHeight),
      bottom,
    );

    final dividerPaint = Paint()
      ..color = borderColor
      ..strokeWidth = size.width * 0.03;
    canvas.drawLine(
      Offset(size.width * 0.08, halfHeight),
      Offset(size.width * 0.92, halfHeight),
      dividerPaint,
    );

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.04;
    canvas.drawRRect(outline, borderPaint);
  }

  void _paintHalf(Canvas canvas, Rect box, int? value) {
    if (value == null) {
      final missingPaint = Paint()..color = missingColor;
      canvas.drawRect(box.deflate(box.width * 0.04), missingPaint);
      return;
    }
    final pipPaint = Paint()..color = pipColor;
    final pipRadius = box.shortestSide * 0.11;
    for (final pip in _pipLayouts[value] ?? const <Offset>[]) {
      canvas.drawCircle(
        Offset(box.left + pip.dx * box.width, box.top + pip.dy * box.height),
        pipRadius,
        pipPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant DominoPainter oldDelegate) =>
      oldDelegate.top != top ||
      oldDelegate.bottom != bottom ||
      oldDelegate.faceColor != faceColor ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.pipColor != pipColor ||
      oldDelegate.missingColor != missingColor;
}
