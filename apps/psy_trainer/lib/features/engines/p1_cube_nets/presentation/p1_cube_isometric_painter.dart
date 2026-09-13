import 'package:flutter/widgets.dart';

import '../../spatial_cubes/domain/cube_face.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart' show CubeNetCellFace;
import 'p1_cube_glyph_paint.dart';

/// A small isometric drawing of a cube (three visible faces: top, front,
/// right), used for both the reference cube and the rotation-matching
/// candidate. Same diamond-face layout as PSY0's `spatial_cubes`
/// `CubeIsometricPainter`, but paints the actual glyph (through
/// [paintP1CubeGlyph]: latin letters or invented runes, mirrored where the
/// puzzle marks a trap) instead of a plain 2-letter abbreviation, since the
/// whole point of rotation-matching is telling a genuine glyph from a
/// mirrored one.
class P1CubeIsometricPainter extends CustomPainter {
  const P1CubeIsometricPainter({
    required this.faces,
    required this.edgeColor,
    required this.topFill,
    required this.frontFill,
    required this.rightFill,
    required this.glyphColor,
  });

  final Map<CubeFace, CubeNetCellFace> faces;
  final Color edgeColor;
  final Color topFill;
  final Color frontFill;
  final Color rightFill;
  final Color glyphColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final top = h * 0.08;
    final mid = h * 0.42;
    final bottom = h * 0.92;
    final halfW = w * 0.42;
    final shoulder = mid * 0.6 + top * 0.2;

    final topFace = Path()
      ..moveTo(cx, top)
      ..lineTo(cx + halfW, shoulder)
      ..lineTo(cx, mid)
      ..lineTo(cx - halfW, shoulder)
      ..close();
    final frontFace = Path()
      ..moveTo(cx - halfW, shoulder)
      ..lineTo(cx, mid)
      ..lineTo(cx, bottom)
      ..lineTo(cx - halfW, bottom - (mid - shoulder))
      ..close();
    final rightFace = Path()
      ..moveTo(cx + halfW, shoulder)
      ..lineTo(cx, mid)
      ..lineTo(cx, bottom)
      ..lineTo(cx + halfW, bottom - (mid - shoulder))
      ..close();

    _drawFace(canvas, topFace, topFill, faces[CubeFace.top]);
    _drawFace(canvas, frontFace, frontFill, faces[CubeFace.front]);
    _drawFace(canvas, rightFace, rightFill, faces[CubeFace.right]);
  }

  void _drawFace(Canvas canvas, Path path, Color fill, CubeNetCellFace? face) {
    canvas.drawPath(path, Paint()..color = fill);
    canvas.drawPath(
      path,
      Paint()
        ..color = edgeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );
    if (face == null) return;
    final bounds = path.getBounds();
    canvas.save();
    canvas.translate(bounds.center.dx, bounds.center.dy);
    paintP1CubeGlyph(
      canvas,
      Size(bounds.width * 0.6, bounds.height * 0.6),
      face.value,
      rotation: face.rotation,
      mirrored: face.mirrored,
      color: glyphColor,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant P1CubeIsometricPainter oldDelegate) =>
      oldDelegate.faces != faces;
}
