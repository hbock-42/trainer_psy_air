import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';

void main() {
  test('light and dark palettes differ in brightness and background', () {
    final light = AppTheme.light();
    final dark = AppTheme.dark();

    expect(light.isDark, isFalse);
    expect(dark.isDark, isTrue);
    expect(light.colors.background, isNot(dark.colors.background));
    expect(AppTheme.forBrightness(Brightness.dark).isDark, isTrue);
    expect(AppTheme.forBrightness(Brightness.light).isDark, isFalse);
  });

  test('spacing scale is 4/8/12/16/24/32 with a 48 touch target', () {
    const spacing = AppSpacing();
    expect(
      [spacing.xs, spacing.sm, spacing.md, spacing.lg, spacing.xl, spacing.xxl],
      [4, 8, 12, 16, 24, 32],
    );
    expect(spacing.minTouchTarget, 48);
  });

  test('text styles carry the palette colours and no decoration', () {
    final theme = AppTheme.dark();
    expect(theme.textStyles.body.color, theme.colors.textPrimary);
    expect(theme.textStyles.caption.color, theme.colors.textSecondary);
    expect(theme.textStyles.body.decoration, TextDecoration.none);
    expect(
      theme.textStyles.display.fontSize,
      greaterThan(theme.textStyles.headline.fontSize!),
    );
  });

  testWidgets('AppTheme.of finds the nearest scope and installs body text', (
    tester,
  ) async {
    late AppTheme found;
    late TextStyle defaultStyle;
    final theme = AppTheme.dark();

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: AppThemeScope(
          theme: theme,
          child: Builder(
            builder: (context) {
              found = AppTheme.of(context);
              defaultStyle = DefaultTextStyle.of(context).style;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    expect(found, same(theme));
    expect(defaultStyle.color, theme.colors.textPrimary);
  });

  testWidgets('AppTheme.maybeOf is null without a scope', (tester) async {
    AppTheme? found;
    await tester.pumpWidget(
      Builder(
        builder: (context) {
          found = AppTheme.maybeOf(context);
          return const SizedBox();
        },
      ),
    );
    expect(found, isNull);
  });

  testWidgets('dependents rebuild when the scoped theme changes', (
    tester,
  ) async {
    var builds = 0;
    final child = Builder(
      builder: (context) {
        AppTheme.of(context);
        builds++;
        return const SizedBox();
      },
    );

    await tester.pumpWidget(
      AppThemeScope(theme: AppTheme.light(), child: child),
    );
    await tester.pumpWidget(
      AppThemeScope(theme: AppTheme.dark(), child: child),
    );

    expect(builds, 2);
  });
}
