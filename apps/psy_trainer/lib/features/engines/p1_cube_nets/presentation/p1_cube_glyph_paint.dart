import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../domain/p1_cube_alphabet.dart';

/// Draws one cube-face glyph -- a single latin letter, or an invented
/// [RuneGlyph] polygon -- centred at the canvas origin, rotated by
/// [rotation] degrees and, for a mirrored trap, flipped horizontally
/// first. Shared by the net-folding tile painter and the rotation
/// isometric painter (`p1_cube_isometric_painter.dart`) so both alphabets
/// (latin/runic) and the mirrored-trap rendering live in exactly one
/// place.
void paintP1CubeGlyph(
  Canvas canvas,
  Size extent,
  String value, {
  required int rotation,
  required bool mirrored,
  required Color color,
}) {
  canvas.save();
  if (mirrored) canvas.scale(-1, 1);
  canvas.rotate(rotation * math.pi / 180);
  if (isRuneGlyphId(value)) {
    _paintRune(canvas, extent, value, color);
  } else {
    _paintLetter(canvas, extent, value, color);
  }
  canvas.restore();
}

void _paintLetter(Canvas canvas, Size extent, String letter, Color color) {
  final painter = TextPainter(
    text: TextSpan(
      text: letter,
      style: TextStyle(
        color: color,
        fontSize: extent.shortestSide * 0.5,
        fontWeight: FontWeight.w700,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
}

void _paintRune(Canvas canvas, Size extent, String runeId, Color color) {
  final glyph = runeGlyphById(runeId);
  final scale = extent.shortestSide * 0.42;
  final path = Path();
  for (var i = 0; i < glyph.points.length; i++) {
    final p = glyph.points[i];
    final offset = Offset(p.x * scale, p.y * scale);
    if (i == 0) {
      path.moveTo(offset.dx, offset.dy);
    } else {
      path.lineTo(offset.dx, offset.dy);
    }
  }
  path.close();
  canvas.drawPath(path, Paint()..color = color);
}
