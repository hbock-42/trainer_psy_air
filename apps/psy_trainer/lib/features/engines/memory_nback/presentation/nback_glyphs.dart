import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Colour-blind-safe hues for `NbackStimulusKind.colour` (Okabe & Ito 2008,
/// chosen for maximum pairwise distinguishability under the common forms of
/// colour vision deficiency), each paired with a distinct glyph shape drawn
/// on top so the activity never relies on hue alone (spec open question
/// 10). `family.json`'s default `paletteSize` is 3, so only the first
/// entries are ever shown by default; the list has 7 so `NbackParams`'s
/// documented "3 of 7 colours" range is fully covered.
const List<Color> nbackPalette = [
  Color(0xFFE69F00), // orange
  Color(0xFF56B4E9), // sky blue
  Color(0xFF009E73), // bluish green
  Color(0xFFF0E442), // yellow
  Color(0xFF0072B2), // blue
  Color(0xFFD55E00), // vermillion
  Color(0xFFCC79A7), // reddish purple
];

/// One glyph per palette index, painted in a contrasting outline over the
/// colour patch so hue is never the only cue.
enum NbackGlyph { circle, triangle, square, diamond, star, cross, hexagon }

/// `nbackPalette[i]` always pairs with `NbackGlyph.values[i]`.
NbackGlyph nbackGlyphOf(int paletteIndex) =>
    NbackGlyph.values[paletteIndex % NbackGlyph.values.length];

/// Draws [glyph] centred in its bounds, stroked in [color].
class NbackGlyphPainter extends CustomPainter {
  const NbackGlyphPainter({required this.glyph, required this.color});

  final NbackGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.08
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final center = size.center(Offset.zero);
    final r = size.shortestSide / 2 * 0.7;
    switch (glyph) {
      case NbackGlyph.circle:
        canvas.drawCircle(center, r, paint);
      case NbackGlyph.square:
        canvas.drawRect(Rect.fromCircle(center: center, radius: r), paint);
      case NbackGlyph.triangle:
        canvas.drawPath(_polygon(center, r, 3, rotation: -1.5708), paint);
      case NbackGlyph.diamond:
        canvas.drawPath(_polygon(center, r, 4), paint);
      case NbackGlyph.hexagon:
        canvas.drawPath(_polygon(center, r, 6), paint);
      case NbackGlyph.star:
        canvas.drawPath(_star(center, r), paint);
      case NbackGlyph.cross:
        canvas
          ..drawLine(center + Offset(-r, -r), center + Offset(r, r), paint)
          ..drawLine(center + Offset(-r, r), center + Offset(r, -r), paint);
    }
  }

  static Path _polygon(
    Offset center,
    double r,
    int sides, {
    double rotation = 0,
  }) {
    final path = Path();
    for (var i = 0; i < sides; i++) {
      final angle = rotation + i * 2 * math.pi / sides;
      final point = center + Offset(r * math.cos(angle), r * math.sin(angle));
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    return path;
  }

  static Path _star(Offset center, double r) {
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final angle = -math.pi / 2 + i * math.pi / 5;
      final radius = i.isEven ? r : r * 0.45;
      final point =
          center + Offset(radius * math.cos(angle), radius * math.sin(angle));
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(covariant NbackGlyphPainter oldDelegate) =>
      oldDelegate.glyph != glyph || oldDelegate.color != color;
}
