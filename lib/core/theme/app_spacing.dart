import 'package:flutter/foundation.dart';

/// Spacing scale, in logical pixels. Use these instead of magic numbers.
@immutable
class AppSpacing {
  const AppSpacing({
    this.xs = 4,
    this.sm = 8,
    this.md = 12,
    this.lg = 16,
    this.xl = 24,
    this.xxl = 32,
    this.minTouchTarget = 48,
  });

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;

  /// Minimum width and height of anything tappable (accessibility floor).
  final double minTouchTarget;
}
