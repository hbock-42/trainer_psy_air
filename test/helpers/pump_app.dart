import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';

/// Test helpers that reproduce the root context of the real app: a
/// `WidgetsApp` (shortcuts, focus, media query, directionality) with an
/// `AppThemeScope` and the page background.
extension PumpApp on WidgetTester {
  /// Pumps [widget] centred on a themed page.
  ///
  /// [textScale] sets `MediaQuery.textScaler`; [theme] defaults to light.
  /// When [align] is false the widget fills the page instead of being
  /// centred (for scaffolds and lists).
  ///
  /// Hover and focus highlights are forced on (`alwaysTraditional`): the test
  /// platform is Android, where Flutter hides them until a key event arrives.
  Future<void> pumpApp(
    Widget widget, {
    AppTheme? theme,
    double textScale = 1.0,
    bool align = true,
  }) async {
    final effectiveTheme = theme ?? AppTheme.light();
    FocusManager.instance.highlightStrategy =
        FocusHighlightStrategy.alwaysTraditional;
    addTearDown(() {
      FocusManager.instance.highlightStrategy =
          FocusHighlightStrategy.automatic;
    });
    await pumpWidget(
      WidgetsApp(
        color: effectiveTheme.colors.background,
        debugShowCheckedModeBanner: false,
        builder: (context, _) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: AppThemeScope(
              theme: effectiveTheme,
              child: ColoredBox(
                color: effectiveTheme.colors.background,
                child: align ? Center(child: widget) : widget,
              ),
            ),
          );
        },
      ),
    );
  }

  /// Moves a mouse pointer over [finder] and pumps. Returns the gesture so the
  /// test can move it away again.
  Future<TestGesture> hover(Finder finder) async {
    final gesture = await createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(getCenter(finder));
    await pumpAndSettle();
    return gesture;
  }
}

/// Function-style variant of [PumpApp.pumpApp] that also installs a
/// `ProviderScope` (with optional Riverpod [overrides]) so screens that read
/// providers can be pumped. Its signature matches the `pump` parameter of
/// `pumpGolden` in `golden_config.dart`.
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  AppTheme? theme,
  double textScale = 1.0,
  bool align = false,
}) {
  return tester.pumpApp(
    ProviderScope(overrides: overrides, child: child),
    theme: theme,
    textScale: textScale,
    align: align,
  );
}
