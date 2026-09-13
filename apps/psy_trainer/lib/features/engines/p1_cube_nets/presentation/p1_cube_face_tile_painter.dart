import 'package:flutter/widgets.dart';

import 'p1_cube_glyph_paint.dart';

/// Draws one net cell (a square tile): a rounded background, then the
/// glyph via [paintP1CubeGlyph] -- the only part that differs between the
/// `latin` and `runic` alphabets (`docs/content/psy1-spec.md` §2.3/§4.1
/// row 8). Same chrome as PSY0's `spatial_cubes`
/// `CubeFaceTilePainter`, kept independent since that painter's shape
/// switch has no rune-polygon case and lives in another engine's
/// `presentation/` (`docs/ARCHITECTURE.md`'s per-story file boundary).
class P1CubeFaceTilePainter extends CustomPainter {
  const P1CubeFaceTilePainter({
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

  /// An empty target slot: draws only the outline.
  final bool empty;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(
      rect.deflate(2),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, Paint()..color = background);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = empty ? 1.5 : 2,
    );
    if (empty) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    paintP1CubeGlyph(
      canvas,
      size,
      value,
      rotation: rotation,
      mirrored: mirrored,
      color: foreground,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant P1CubeFaceTilePainter oldDelegate) =>
      oldDelegate.value != value ||
      oldDelegate.rotation != rotation ||
      oldDelegate.mirrored != mirrored ||
      oldDelegate.background != background ||
      oldDelegate.border != border ||
      oldDelegate.foreground != foreground ||
      oldDelegate.empty != empty;
}
