import 'package:flutter/widgets.dart';

/// A small, fixed, colour-blind-unfriendly-but-legible palette for ball
/// colour indices (0-based); repeats past its length rather than throwing,
/// so an unusually high `colourCount` still renders (with repeats) instead
/// of crashing.
const List<Color> tubesBallPalette = [
  Color(0xFFE0483C), // red
  Color(0xFF3C7DE0), // blue
  Color(0xFF3CAE5A), // green
  Color(0xFFE0B23C), // amber
  Color(0xFF8E5CE0), // purple
  Color(0xFF3CC7C2), // teal
];

/// Draws one set of U-tubes (a `planning_tubes` configuration): [tubes] is
/// bottom-to-top ball colour indices per tube, [capacities] the tube
/// capacities (same length). Vector only (no image assets), theme-aware
/// for the tube walls; ball fills come from [tubesBallPalette].
class TubesPainter extends CustomPainter {
  const TubesPainter({
    required this.tubes,
    required this.capacities,
    required this.wallColor,
    required this.emptySlotColor,
  });

  final List<List<int>> tubes;
  final List<int> capacities;
  final Color wallColor;
  final Color emptySlotColor;

  @override
  void paint(Canvas canvas, Size size) {
    final tubeCount = tubes.length;
    if (tubeCount == 0) return;
    const gapFactor = 0.12;
    final gap = size.width * gapFactor / tubeCount;
    final tubeWidth = (size.width - gap * (tubeCount - 1)) / tubeCount;

    for (var i = 0; i < tubeCount; i++) {
      final left = i * (tubeWidth + gap);
      _paintTube(
        canvas,
        Rect.fromLTWH(left, 0, tubeWidth, size.height),
        tubes[i],
        capacities[i],
      );
    }
  }

  void _paintTube(Canvas canvas, Rect rect, List<int> balls, int capacity) {
    if (capacity <= 0) return;
    final radius = Radius.circular(rect.width * 0.3);
    final outline = RRect.fromRectAndCorners(
      rect,
      bottomLeft: radius,
      bottomRight: radius,
    );
    final wallPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = rect.width * 0.06
      ..color = wallColor;
    canvas.drawRRect(outline, wallPaint);

    final slotHeight = rect.height / capacity;
    final pad = rect.width * 0.08;
    for (var slot = 0; slot < capacity; slot++) {
      final slotRect = Rect.fromLTWH(
        rect.left + pad,
        rect.bottom - (slot + 1) * slotHeight + pad,
        rect.width - pad * 2,
        slotHeight - pad,
      );
      if (slot < balls.length) {
        final color = tubesBallPalette[balls[slot] % tubesBallPalette.length];
        canvas.drawOval(slotRect, Paint()..color = color);
      } else {
        canvas.drawOval(
          slotRect.deflate(slotRect.width * 0.15),
          Paint()..color = emptySlotColor,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant TubesPainter oldDelegate) =>
      oldDelegate.tubes != tubes ||
      oldDelegate.capacities != capacities ||
      oldDelegate.wallColor != wallColor ||
      oldDelegate.emptySlotColor != emptySlotColor;
}
