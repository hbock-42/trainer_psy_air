import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Typography scale of the design system.
///
/// Uses the platform font (no bundled font). Sizes are the unscaled values;
/// `Text` multiplies them by `MediaQuery.textScaler` at render time, so every
/// layout must tolerate scaling up to 1.3x.
@immutable
class AppTextStyles {
  const AppTextStyles({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.bodyStrong,
    required this.label,
    required this.caption,
    required this.numeric,
  });

  /// Builds the scale for a given foreground colour set.
  factory AppTextStyles.standard({
    required Color primary,
    required Color secondary,
  }) {
    TextStyle base(double size, FontWeight weight, {double? height}) {
      return TextStyle(
        color: primary,
        fontSize: size,
        fontWeight: weight,
        height: height ?? 1.3,
        decoration: TextDecoration.none,
      );
    }

    return AppTextStyles(
      display: base(
        48,
        FontWeight.w700,
        height: 1.1,
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
      headline: base(28, FontWeight.w700, height: 1.2),
      title: base(20, FontWeight.w600),
      body: base(16, FontWeight.w400, height: 1.45),
      bodyStrong: base(16, FontWeight.w600, height: 1.45),
      label: base(14, FontWeight.w600),
      caption: base(12, FontWeight.w400).copyWith(color: secondary),
      numeric: base(
        22,
        FontWeight.w600,
      ).copyWith(fontFeatures: const [FontFeature.tabularFigures()]),
    );
  }

  /// Big numbers: score values, exam countdown.
  final TextStyle display;

  /// Screen titles.
  final TextStyle headline;

  /// Section and card titles.
  final TextStyle title;

  /// Default reading style; installed as `DefaultTextStyle`.
  final TextStyle body;

  /// Emphasised body text (answer options, button labels).
  final TextStyle bodyStrong;

  /// Small emphasised text: badges, tabs, secondary buttons.
  final TextStyle label;

  /// Helper text, drawn in the secondary colour.
  final TextStyle caption;

  /// Tabular digits for keypads, timers and inline numbers.
  final TextStyle numeric;
}
