import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Corner radii of the design system.
@immutable
class AppRadii {
  const AppRadii({
    this.sm = const Radius.circular(6),
    this.md = const Radius.circular(10),
    this.lg = const Radius.circular(16),
    this.full = const Radius.circular(999),
  });

  /// Badges, small chips, progress bars.
  final Radius sm;

  /// Buttons, keypad keys, answer tiles.
  final Radius md;

  /// Cards and sheets.
  final Radius lg;

  /// Pills and dots.
  final Radius full;

  BorderRadius get smAll => BorderRadius.all(sm);
  BorderRadius get mdAll => BorderRadius.all(md);
  BorderRadius get lgAll => BorderRadius.all(lg);
  BorderRadius get fullAll => BorderRadius.all(full);
}
