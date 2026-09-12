import 'package:flutter/foundation.dart';

/// Motion tokens. Keep animations short: the app is a training tool, not a
/// showcase, and the exam mode must feel instantaneous.
@immutable
class AppDurations {
  const AppDurations({
    this.fast = const Duration(milliseconds: 90),
    this.normal = const Duration(milliseconds: 180),
    this.slow = const Duration(milliseconds: 320),
  });

  /// Press feedback, hover tints.
  final Duration fast;

  /// State changes (selected, correct/wrong), colour shifts.
  final Duration normal;

  /// Page transitions, progress bars.
  final Duration slow;
}
