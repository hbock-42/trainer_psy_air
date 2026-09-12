import 'package:flutter/widgets.dart';

import '../domain/cube_face.dart';
import '../domain/cube_net_puzzle.dart';

/// A small isometric drawing of the folded cube (three visible faces:
/// top, front, right), for the practice-mode explanation (spec §2.4-L
/// AC: "practice mode shows the folded cube ... as an isometric
/// drawing"). Illustrative only -- it does not attempt to reproduce each
/// glyph's exact 3D rotation, only which value sits on which face.
class CubeIsometricPainter extends CustomPainter {
  const CubeIsometricPainter({
    required this.faces,
    required this.edgeColor,
    required this.topFill,
    required this.frontFill,
    required this.rightFill,
    required this.textColor,
  });

  final Map<CubeFace, CubeNetCellFace> faces;
  final Color edgeColor;
  final Color topFill;
  final Color frontFill;
  final Color rightFill;
  final Color textColor;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final top = h * 0.08;
    final mid = h * 0.42;
    final bottom = h * 0.92;
    final halfW = w * 0.42;

    final topFace = Path()
      ..moveTo(cx, top)
      ..lineTo(cx + halfW, mid * 0.6 + top * 0.2)
      ..lineTo(cx, mid)
      ..lineTo(cx - halfW, mid * 0.6 + top * 0.2)
      ..close();
    final frontFace = Path()
      ..moveTo(cx - halfW, mid * 0.6 + top * 0.2)
      ..lineTo(cx, mid)
      ..lineTo(cx, bottom)
      ..lineTo(cx - halfW, bottom - (mid - (mid * 0.6 + top * 0.2)))
      ..close();
    final rightFace = Path()
      ..moveTo(cx + halfW, mid * 0.6 + top * 0.2)
      ..lineTo(cx, mid)
      ..lineTo(cx, bottom)
      ..lineTo(cx + halfW, bottom - (mid - (mid * 0.6 + top * 0.2)))
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
    final label = face.value.length <= 2
        ? face.value.toUpperCase()
        : face.value.substring(0, 2).toUpperCase();
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: textColor,
          fontSize: bounds.shortestSide * 0.35,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      bounds.center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CubeIsometricPainter oldDelegate) =>
      oldDelegate.faces != faces;
}
