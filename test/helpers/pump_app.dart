import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

/// Colours used by the test harness. They mirror the root app's palette so a
/// widget under test renders the way it does inside [PsyTrainerApp]; keep them
/// in sync with the design system once US-003 lands (then read them from
/// `AppTheme` instead).
const Color testBackground = Color(0xFF0B1D3A);
const Color testForeground = Color(0xFFF5F7FA);

/// Default text style installed by [pumpApp], matching `lib/app.dart`.
const TextStyle testTextStyle = TextStyle(
  color: testForeground,
  fontSize: 16,
  decoration: TextDecoration.none,
);

/// Pumps [child] inside the ancestors every widget in this app expects.
///
/// The app is built on `package:flutter/widgets.dart` only (no Material, no
/// Cupertino), so there is no `MaterialApp` to provide the usual context.
/// This helper installs exactly what `WidgetsApp` and the root `builder` in
/// `lib/app.dart` would:
///
/// * `ProviderScope` for Riverpod, with optional [overrides];
/// * `MediaQuery` from the test binding's window (respects the surface size
///   set by `tester.view` or `golden_config.dart`);
/// * `Directionality` (left-to-right) and `DefaultTextStyle` so `Text`
///   renders without the yellow "missing style" look;
/// * a `ColoredBox` background matching the app's dark ground.
///
/// It deliberately does not wrap in a `WidgetsApp`/`Navigator`: most widget
/// tests do not need routing, and the lighter tree keeps them fast and free
/// of route-transition frames. Test screens that push routes through
/// `PsyTrainerApp` directly (see `test/app_test.dart`).
///
/// Example:
///
/// ```dart
/// await pumpApp(tester, const ScoreTile(score: 42));
/// expect(find.text('42'), findsOneWidget);
/// ```
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<Override> overrides = const [],
  TextDirection textDirection = TextDirection.ltr,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MediaQuery.fromView(
        view: tester.view,
        child: Directionality(
          textDirection: textDirection,
          child: DefaultTextStyle(
            style: testTextStyle,
            child: ColoredBox(color: testBackground, child: child),
          ),
        ),
      ),
    ),
  );
}
