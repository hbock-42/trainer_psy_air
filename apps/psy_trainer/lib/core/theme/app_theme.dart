import 'package:flutter/widgets.dart';

import 'app_colors.dart';
import 'app_durations.dart';
import 'app_radii.dart';
import 'app_spacing.dart';
import 'app_text_styles.dart';

export 'app_colors.dart';
export 'app_durations.dart';
export 'app_radii.dart';
export 'app_spacing.dart';
export 'app_text_styles.dart';

/// Immutable bundle of every design token.
///
/// There is no `ThemeData` in this project: widgets read tokens through
/// [AppTheme.of], which looks up the nearest [AppThemeScope].
@immutable
class AppTheme {
  const AppTheme({
    required this.colors,
    required this.textStyles,
    this.spacing = const AppSpacing(),
    this.radii = const AppRadii(),
    this.durations = const AppDurations(),
  });

  /// The light theme.
  factory AppTheme.light() => AppTheme._fromColors(AppColors.light);

  /// The dark theme.
  factory AppTheme.dark() => AppTheme._fromColors(AppColors.dark);

  /// Picks light or dark from a platform [Brightness].
  factory AppTheme.forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? AppTheme.dark() : AppTheme.light();
  }

  factory AppTheme._fromColors(AppColors colors) {
    return AppTheme(
      colors: colors,
      textStyles: AppTextStyles.standard(
        primary: colors.textPrimary,
        secondary: colors.textSecondary,
      ),
    );
  }

  final AppColors colors;
  final AppTextStyles textStyles;
  final AppSpacing spacing;
  final AppRadii radii;
  final AppDurations durations;

  bool get isDark => colors.brightness == Brightness.dark;

  /// The theme of the nearest [AppThemeScope]. Throws if there is none: every
  /// screen must sit under the scope installed by the root app (or by
  /// `pumpApp` in tests).
  static AppTheme of(BuildContext context) {
    final theme = maybeOf(context);
    assert(
      theme != null,
      'AppTheme.of() called with a context that has no AppThemeScope ancestor. '
      'Wrap the app (or the widget under test) in an AppThemeScope.',
    );
    return theme!;
  }

  /// Like [of] but returns null when there is no [AppThemeScope] ancestor.
  static AppTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppThemeScope>()?.theme;
  }
}

/// Provides an [AppTheme] to the subtree and installs the matching
/// `DefaultTextStyle` (body) so plain `Text` widgets render correctly under a
/// `WidgetsApp`. Dependents rebuild when the theme instance changes.
class AppThemeScope extends InheritedWidget {
  AppThemeScope({required this.theme, required Widget child, super.key})
    : super(
        child: DefaultTextStyle(style: theme.textStyles.body, child: child),
      );

  final AppTheme theme;

  @override
  bool updateShouldNotify(AppThemeScope oldWidget) => theme != oldWidget.theme;
}
