import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

void main() {
  final light = AppTheme.light();
  final key = find.byType(AppKeypadButton);

  testWidgets('digit key shows its label, is 56+ wide, reports taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(AppKeypadButton(label: '7', onPressed: () => taps++));
    expect(find.text('7'), findsOneWidget);
    final size = tester.getSize(key);
    expect(size.width, greaterThanOrEqualTo(56));
    expect(size.height, greaterThanOrEqualTo(56));
    await tester.tap(key);
    expect(taps, 1);
  });

  testWidgets('icon key uses the icon and the explicit semantics label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      AppKeypadButton(
        label: 'del',
        icon: AppIconGlyph.cross,
        semanticsLabel: 'Delete',
        onPressed: () {},
      ),
    );
    expect(find.text('del'), findsNothing);
    expect(find.byType(AppIcon), findsOneWidget);
    expect(
      tester.getSemantics(key),
      matchesSemantics(
        label: 'Delete',
        isButton: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('emphasized key is accent-filled; plain key is a surface', (
    tester,
  ) async {
    await tester.pumpApp(
      AppKeypadButton(label: 'OK', emphasized: true, onPressed: () {}),
    );
    expect(tester.backgroundOf(key), light.colors.accent);

    await tester.pumpApp(AppKeypadButton(label: '1', onPressed: () {}));
    expect(tester.backgroundOf(key), light.colors.surface);
    expect(tester.borderColorOf(key), light.colors.border);
  });

  testWidgets('press tints with the accent, hover raises, focus rings', (
    tester,
  ) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpApp(
      AppKeypadButton(label: '5', focusNode: node, onPressed: () {}),
    );

    final press = await tester.startGesture(tester.getCenter(key));
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(key), light.colors.accentSubtle);
    expect(tester.borderColorOf(key), light.colors.accent);
    await press.up();
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(key), light.colors.surface);

    await tester.hover(key);
    expect(tester.backgroundOf(key), light.colors.surfaceRaised);

    node.requestFocus();
    await tester.pumpAndSettle();
    expect(tester.focusRingVisible(key), isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
  });

  testWidgets('disabled key ignores taps and is dimmed', (tester) async {
    await tester.pumpApp(const AppKeypadButton(label: '9'));
    await tester.tap(key);
    expect(tester.backgroundOf(key), isNot(light.colors.surface));
    expect(tester.takeException(), isNull);
  });
}
