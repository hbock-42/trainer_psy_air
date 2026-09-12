import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart' show CustomPainter;

import 'package:psy_content/psy_content.dart';
import '../domain/viewpoint_geometry.dart';
import '../domain/viewpoint_scene.dart';
import 'viewpoint_palette.dart';

/// Draws the scene as seen from one azimuth: a minimal 2.5-D / isometric
/// projection (US-034 acceptance: "no 3D engine, no assets").
///
/// Ground positions are projected with [lateralOf] (screen X) and
/// [depthOf] (near/far); objects are painted back-to-front (farthest
/// first) so a nearer object correctly overlaps ("occults") a farther one
/// along the same line of sight, exactly the cue the lesson teaches
/// candidates to read. Farther objects are drawn smaller and higher, nearer
/// ones bigger and lower, for a simple depth-of-field illusion without any
/// real 3-D transform.
class ViewpointScenePainter extends CustomPainter {
  const ViewpointScenePainter({required this.objects, required this.azimuth});

  final List<ViewpointObject> objects;
  final int azimuth;

  static const double _maxLateral = gridRadius * math.sqrt2;
  static const double _maxDepth = gridRadius * math.sqrt2;

  @override
  void paint(Canvas canvas, Size size) {
    if (objects.isEmpty) return;

    final projected =
        [
            for (final object in objects)
              (
                object: object,
                lateral: lateralOf(object.gx, object.gy, azimuth),
                depth: depthOf(object.gx, object.gy, azimuth),
              ),
          ]
          // Farthest (largest depth) first: nearer objects paint on top.
          ..sort((a, b) => b.depth.compareTo(a.depth));

    const horizonFrac = 0.30;
    const groundFrac = 0.90;
    final horizonY = size.height * horizonFrac;
    final groundY = size.height * groundFrac;

    for (final p in projected) {
      // 0 = nearest, 1 = farthest.
      final farNorm = ((p.depth / _maxDepth) + 1) / 2;
      final nearNorm = 1 - farNorm;
      final scale = 0.5 + 0.5 * nearNorm;
      final baseY = horizonY + (groundY - horizonY) * nearNorm;
      final lateralNorm = (p.lateral / _maxLateral).clamp(-1.0, 1.0);
      final centerX =
          size.width / 2 +
          lateralNorm * (size.width * 0.38) * (0.6 + 0.4 * scale);
      _paintSolid(
        canvas,
        p.object,
        Offset(centerX, baseY),
        scale * size.shortestSide * 0.16,
      );
    }
  }

  void _paintSolid(
    Canvas canvas,
    ViewpointObject object,
    Offset base,
    double unit,
  ) {
    final color = viewpointColorOf(object.colorIndex);
    final light = Color.lerp(color, const Color(0xFFFFFFFF), 0.35)!;
    final dark = Color.lerp(color, const Color(0xFF000000), 0.25)!;

    // Ground shadow, common to every solid.
    final shadowPaint = Paint()..color = const Color(0x33000000);
    canvas.drawOval(
      Rect.fromCenter(center: base, width: unit * 1.6, height: unit * 0.5),
      shadowPaint,
    );

    switch (object.kind) {
      case SolidKind.cube:
        _paintCube(canvas, base, unit, color, light, dark);
      case SolidKind.cylinder:
        _paintCylinder(canvas, base, unit, color, light, dark);
      case SolidKind.cone:
        _paintCone(canvas, base, unit, color, light, dark);
      case SolidKind.sphere:
        _paintSphere(canvas, base, unit, color, light);
      case SolidKind.pyramid:
        _paintPyramid(canvas, base, unit, color, light, dark);
    }
  }

  void _paintCube(
    Canvas canvas,
    Offset base,
    double unit,
    Color front,
    Color top,
    Color side,
  ) {
    final h = unit * 1.6;
    final w = unit * 1.4;
    final depth = unit * 0.5;
    final topLeft = Offset(base.dx - w / 2, base.dy - h);
    final topRight = Offset(base.dx + w / 2, base.dy - h);
    final bottomRight = Offset(base.dx + w / 2, base.dy);

    canvas.drawRect(
      Rect.fromPoints(topLeft, bottomRight),
      Paint()..color = front,
    );
    // Top face (parallelogram), lighter.
    final topPath = Path()
      ..moveTo(topLeft.dx, topLeft.dy)
      ..lineTo(topLeft.dx + depth, topLeft.dy - depth)
      ..lineTo(topRight.dx + depth, topRight.dy - depth)
      ..lineTo(topRight.dx, topRight.dy)
      ..close();
    canvas.drawPath(topPath, Paint()..color = top);
    // Side face, darker.
    final sidePath = Path()
      ..moveTo(topRight.dx, topRight.dy)
      ..lineTo(topRight.dx + depth, topRight.dy - depth)
      ..lineTo(bottomRight.dx + depth, bottomRight.dy - depth)
      ..lineTo(bottomRight.dx, bottomRight.dy)
      ..close();
    canvas.drawPath(sidePath, Paint()..color = side);
  }

  void _paintCylinder(
    Canvas canvas,
    Offset base,
    double unit,
    Color front,
    Color top,
    Color side,
  ) {
    final h = unit * 1.8;
    final w = unit * 1.2;
    final capHeight = unit * 0.35;
    final bodyRect = Rect.fromLTRB(
      base.dx - w / 2,
      base.dy - h,
      base.dx + w / 2,
      base.dy,
    );
    canvas.drawRect(bodyRect, Paint()..color = front);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(base.dx, base.dy - h),
        width: w,
        height: capHeight,
      ),
      Paint()..color = top,
    );
    // Shaded strip down one side for a hint of curvature.
    canvas.drawRect(
      Rect.fromLTRB(base.dx, base.dy - h, base.dx + w / 2, base.dy),
      Paint()..color = side.withAlpha(120),
    );
  }

  void _paintCone(
    Canvas canvas,
    Offset base,
    double unit,
    Color front,
    Color top,
    Color side,
  ) {
    final h = unit * 1.8;
    final w = unit * 1.3;
    final apex = Offset(base.dx, base.dy - h);
    final path = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(base.dx - w / 2, base.dy)
      ..lineTo(base.dx + w / 2, base.dy)
      ..close();
    canvas.drawPath(path, Paint()..color = front);
    // Darker half for a simple lit/shaded split.
    final shadedHalf = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(base.dx, base.dy)
      ..lineTo(base.dx + w / 2, base.dy)
      ..close();
    canvas.drawPath(shadedHalf, Paint()..color = side.withAlpha(140));
    canvas.drawOval(
      Rect.fromCenter(center: base, width: w, height: unit * 0.35),
      Paint()..color = top,
    );
  }

  void _paintSphere(
    Canvas canvas,
    Offset base,
    double unit,
    Color color,
    Color highlight,
  ) {
    final radius = unit * 0.85;
    final center = Offset(base.dx, base.dy - radius);
    canvas.drawCircle(center, radius, Paint()..color = color);
    canvas.drawCircle(
      Offset(center.dx - radius * 0.3, center.dy - radius * 0.3),
      radius * 0.4,
      Paint()..color = highlight.withAlpha(180),
    );
  }

  void _paintPyramid(
    Canvas canvas,
    Offset base,
    double unit,
    Color front,
    Color top,
    Color side,
  ) {
    final h = unit * 1.7;
    final w = unit * 1.4;
    final apex = Offset(base.dx, base.dy - h);
    final leftPath = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(base.dx - w / 2, base.dy)
      ..lineTo(base.dx, base.dy)
      ..close();
    final rightPath = Path()
      ..moveTo(apex.dx, apex.dy)
      ..lineTo(base.dx, base.dy)
      ..lineTo(base.dx + w / 2, base.dy)
      ..close();
    canvas.drawPath(leftPath, Paint()..color = top);
    canvas.drawPath(rightPath, Paint()..color = side);
  }

  @override
  bool shouldRepaint(covariant ViewpointScenePainter oldDelegate) =>
      oldDelegate.objects != objects || oldDelegate.azimuth != azimuth;
}
