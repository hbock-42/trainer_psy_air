import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The glyphs available to [AppIcon]. No icon font is bundled (Material is
/// off-limits): each glyph is a few strokes painted by [_AppIconPainter] on a
/// 24x24 grid.
enum AppIconGlyph {
  check,
  cross,
  chevronLeft,
  chevronRight,
  clock,
  play,
  pause,
  settings,
  chart,
  book,
  target,
}

/// A vector icon drawn with `CustomPaint`.
///
/// Defaults to the current `DefaultTextStyle` colour so it follows the text it
/// sits next to. Decorative by default (excluded from semantics); pass
/// [semanticsLabel] when the icon carries meaning on its own.
class AppIcon extends StatelessWidget {
  const AppIcon(
    this.glyph, {
    this.size = 24,
    this.color,
    this.semanticsLabel,
    super.key,
  });

  final AppIconGlyph glyph;
  final double size;
  final Color? color;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final resolved =
        color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF000000);
    final painting = SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _AppIconPainter(glyph, resolved)),
    );
    if (semanticsLabel == null) {
      return ExcludeSemantics(child: painting);
    }
    return Semantics(label: semanticsLabel, image: true, child: painting);
  }
}

class _AppIconPainter extends CustomPainter {
  const _AppIconPainter(this.glyph, this.color);

  final AppIconGlyph glyph;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.shortestSide / 24;
    canvas.save();
    canvas.translate(
      (size.width - 24 * scale) / 2,
      (size.height - 24 * scale) / 2,
    );
    canvas.scale(scale);

    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    switch (glyph) {
      case AppIconGlyph.check:
        canvas.drawPath(
          Path()
            ..moveTo(5, 12.5)
            ..lineTo(10, 17.5)
            ..lineTo(19, 7),
          stroke,
        );
      case AppIconGlyph.cross:
        canvas.drawLine(const Offset(6, 6), const Offset(18, 18), stroke);
        canvas.drawLine(const Offset(18, 6), const Offset(6, 18), stroke);
      case AppIconGlyph.chevronLeft:
        canvas.drawPath(
          Path()
            ..moveTo(15, 5)
            ..lineTo(8, 12)
            ..lineTo(15, 19),
          stroke,
        );
      case AppIconGlyph.chevronRight:
        canvas.drawPath(
          Path()
            ..moveTo(9, 5)
            ..lineTo(16, 12)
            ..lineTo(9, 19),
          stroke,
        );
      case AppIconGlyph.clock:
        canvas.drawCircle(const Offset(12, 12), 9, stroke);
        canvas.drawPath(
          Path()
            ..moveTo(12, 7)
            ..lineTo(12, 12)
            ..lineTo(15.5, 14.5),
          stroke,
        );
      case AppIconGlyph.play:
        canvas.drawPath(
          Path()
            ..moveTo(8, 5)
            ..lineTo(19, 12)
            ..lineTo(8, 19)
            ..close(),
          fill,
        );
      case AppIconGlyph.pause:
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(6, 5, 4, 14),
            const Radius.circular(1),
          ),
          fill,
        );
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            const Rect.fromLTWH(14, 5, 4, 14),
            const Radius.circular(1),
          ),
          fill,
        );
      case AppIconGlyph.settings:
        canvas.drawCircle(const Offset(12, 12), 3, stroke);
        canvas.drawCircle(const Offset(12, 12), 7, stroke);
        for (var i = 0; i < 8; i++) {
          final angle = i * math.pi / 4;
          final dir = Offset(math.cos(angle), math.sin(angle));
          canvas.drawLine(
            const Offset(12, 12) + dir * 7,
            const Offset(12, 12) + dir * 10,
            stroke,
          );
        }
      case AppIconGlyph.chart:
        canvas.drawPath(
          Path()
            ..moveTo(4, 4)
            ..lineTo(4, 20)
            ..lineTo(20, 20),
          stroke,
        );
        canvas.drawRect(const Rect.fromLTWH(7, 13, 3, 6), fill);
        canvas.drawRect(const Rect.fromLTWH(12, 9, 3, 10), fill);
        canvas.drawRect(const Rect.fromLTWH(17, 5, 3, 14), fill);
      case AppIconGlyph.book:
        canvas.drawPath(
          Path()
            ..moveTo(12, 7)
            ..lineTo(12, 19.5)
            ..moveTo(12, 7)
            ..quadraticBezierTo(9, 4.5, 4, 5)
            ..lineTo(4, 17.5)
            ..quadraticBezierTo(9, 17, 12, 19.5)
            ..quadraticBezierTo(15, 17, 20, 17.5)
            ..lineTo(20, 5)
            ..quadraticBezierTo(15, 4.5, 12, 7),
          stroke,
        );
      case AppIconGlyph.target:
        canvas.drawCircle(const Offset(12, 12), 9, stroke);
        canvas.drawCircle(const Offset(12, 12), 5.5, stroke);
        canvas.drawCircle(const Offset(12, 12), 2, fill);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_AppIconPainter oldDelegate) {
    return oldDelegate.glyph != glyph || oldDelegate.color != color;
  }
}
