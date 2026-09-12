import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../../../core/theme/app_theme.dart';

/// A two-sided card that flips around its vertical axis (widgets-layer
/// animation: `AnimatedBuilder` + `Transform`, no package dependency).
///
/// [flipped] drives the animation (front -> back and back); [front]/[back]
/// are painted at half the rotation each so neither ever renders mirrored.
class FlipCard extends StatefulWidget {
  const FlipCard({
    required this.front,
    required this.back,
    required this.flipped,
    super.key,
  });

  final Widget front;
  final Widget back;
  final bool flipped;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppTheme.of(context).durations.slow,
    value: widget.flipped ? 1 : 0,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = AppTheme.of(context).durations.slow;
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.flipped != widget.flipped) {
      if (widget.flipped) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final angle = _controller.value * math.pi;
        final showBack = _controller.value >= 0.5;
        final side = showBack
            ? Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..rotateY(math.pi),
                child: widget.back,
              )
            : widget.front;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.0015)
            ..rotateY(angle),
          child: side,
        );
      },
    );
  }
}
