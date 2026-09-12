import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Draws one net cell (a square tile): a rounded background, a letter or a
/// small asymmetric shape, rotated by [rotation] (degrees) and, for a
/// mirrored trap tile, flipped horizontally first (so it never looks
/// rotation-correct however far it is spun).
class CubeFaceTilePainter extends CustomPainter {
  const CubeFaceTilePainter({
    required this.value,
    required this.rotation,
    required this.mirrored,
    required this.background,
    required this.border,
    required this.foreground,
    this.empty = false,
  });

  final String value;
  final int rotation;
  final bool mirrored;
  final Color background;
  final Color border;
  final Color foreground;

  /// An empty target slot: draws only the dashed-looking outline.
  final bool empty;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2),
      const Radius.circular(8),
    );
    final fillPaint = Paint()..color = background;
    canvas.drawRRect(rrect, fillPaint);
    final borderPaint = Paint()
      ..color = border
      ..style = PaintingStyle.stroke
      ..strokeWidth = empty ? 1.5 : 2;
    canvas.drawRRect(rrect, borderPaint);
    if (empty) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    if (mirrored) canvas.scale(-1, 1);
    canvas.rotate(rotation * math.pi / 180);
    if (value.length == 1) {
      _paintLetter(canvas, size, value, foreground);
    } else {
      _paintShape(canvas, size, value, foreground);
    }
    canvas.restore();
  }

  void _paintLetter(Canvas canvas, Size size, String letter, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          color: color,
          fontSize: size.shortestSide * 0.5,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
  }

  void _paintShape(Canvas canvas, Size size, String shape, Color color) {
    final s = size.shortestSide * 0.32;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = switch (shape) {
      // An arrow pointing up: clearly asymmetric under any 90° rotation.
      'arrow' =>
        (Path()
          ..moveTo(0, -s)
          ..lineTo(s * 0.7, s * 0.2)
          ..lineTo(s * 0.25, s * 0.2)
          ..lineTo(s * 0.25, s)
          ..lineTo(-s * 0.25, s)
          ..lineTo(-s * 0.25, s * 0.2)
          ..lineTo(-s * 0.7, s * 0.2)
          ..close()),
      // An L-shaped flag.
      'flag' =>
        (Path()
          ..moveTo(-s * 0.4, -s)
          ..lineTo(-s * 0.4, s)
          ..lineTo(-s * 0.1, s)
          ..lineTo(-s * 0.1, -s * 0.2)
          ..lineTo(s * 0.6, -s * 0.2)
          ..lineTo(s * 0.6, -s)
          ..close()),
      // A right-angle hook.
      'hook' =>
        (Path()
          ..moveTo(-s * 0.6, -s)
          ..lineTo(-s * 0.1, -s)
          ..lineTo(-s * 0.1, s * 0.5)
          ..lineTo(s * 0.6, s * 0.5)
          ..lineTo(s * 0.6, s)
          ..lineTo(-s * 0.6, s)
          ..close()),
      // A wedge (right triangle).
      'wedge' =>
        (Path()
          ..moveTo(-s, -s)
          ..lineTo(s, -s)
          ..lineTo(-s, s)
          ..close()),
      // A chevron pointing right.
      'chevron' =>
        (Path()
          ..moveTo(-s * 0.6, -s)
          ..lineTo(s * 0.6, -s * 0.2)
          ..lineTo(-s * 0.6, s * 0.6)
          ..lineTo(-s * 0.2, s * 0.6)
          ..lineTo(s, -s * 0.2)
          ..lineTo(-s * 0.2, -s)
          ..close()),
      // A map pin.
      'pin' =>
        (Path()
          ..addOval(
            Rect.fromCircle(center: Offset(0, -s * 0.3), radius: s * 0.5),
          )
          ..moveTo(-s * 0.4, -s * 0.1)
          ..lineTo(0, s)
          ..lineTo(s * 0.4, -s * 0.1)
          ..close()),
      // A lightning bolt.
      'bolt' =>
        (Path()
          ..moveTo(s * 0.2, -s)
          ..lineTo(-s * 0.4, s * 0.1)
          ..lineTo(0, s * 0.1)
          ..lineTo(-s * 0.2, s)
          ..lineTo(s * 0.4, -s * 0.15)
          ..lineTo(0, -s * 0.15)
          ..close()),
      // A comb (three teeth): asymmetric because the spine sits at top.
      'comb' =>
        (Path()
          ..addRect(Rect.fromLTWH(-s, -s, 2 * s, s * 0.35))
          ..addRect(Rect.fromLTWH(-s, -s * 0.65, s * 0.3, s * 1.65))
          ..addRect(Rect.fromLTWH(-s * 0.2, -s * 0.65, s * 0.3, s * 1.65))
          ..addRect(Rect.fromLTWH(s * 0.6, -s * 0.65, s * 0.3, s * 1.65))),
      _ => (Path()..addOval(Rect.fromCircle(center: Offset.zero, radius: s))),
    };
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CubeFaceTilePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.rotation != rotation ||
      oldDelegate.mirrored != mirrored ||
      oldDelegate.background != background ||
      oldDelegate.border != border ||
      oldDelegate.foreground != foreground ||
      oldDelegate.empty != empty;
}
