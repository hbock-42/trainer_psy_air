import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

void main() {
  final light = AppTheme.light();

  testWidgets('renders its label and calls onPressed on tap', (tester) async {
    var taps = 0;
    await tester.pumpApp(
      PrimaryButton(label: 'Start', onPressed: () => taps++),
    );

    expect(find.text('Start'), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(taps, 1);
  });

  testWidgets('is at least 48x48 and grows with text scaling', (tester) async {
    await tester.pumpApp(PrimaryButton(label: 'Go', onPressed: () {}));
    final normal = tester.getSize(find.byType(PrimaryButton));
    expect(normal.height, greaterThanOrEqualTo(48));
    expect(normal.width, greaterThanOrEqualTo(48));

    await tester.pumpApp(
      PrimaryButton(label: 'Go', onPressed: () {}),
      textScale: 1.3,
    );
    final scaled = tester.getSize(find.byType(PrimaryButton));
    expect(scaled.height, greaterThan(normal.height));
    expect(tester.takeException(), isNull);
  });

  testWidgets('exposes button semantics with the label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(PrimaryButton(label: 'Validate', onPressed: () {}));

    expect(
      tester.getSemantics(find.byType(PrimaryButton)),
      matchesSemantics(
        label: 'Validate',
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

  testWidgets('disabled: no tap, dimmed, flagged in semantics', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(const PrimaryButton(label: 'Disabled'));

    expect(
      tester.backgroundOf(find.byType(PrimaryButton)),
      isNot(light.colors.accent),
    );
    expect(
      tester.getSemantics(find.byType(PrimaryButton)),
      matchesSemantics(
        label: 'Disabled',
        isButton: true,
        hasEnabledState: true,
      ),
    );
    await tester.tap(find.byType(PrimaryButton));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    handle.dispose();
  });

  testWidgets('hover and press change the background', (tester) async {
    await tester.pumpApp(PrimaryButton(label: 'Hover', onPressed: () {}));
    final button = find.byType(PrimaryButton);
    final idle = tester.backgroundOf(button);
    expect(idle, light.colors.accent);

    final gesture = await tester.hover(button);
    final hovered = tester.backgroundOf(button);
    expect(hovered, isNot(idle));

    await gesture.moveTo(Offset.zero);
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(button), idle);

    final press = await tester.startGesture(tester.getCenter(button));
    await tester.pumpAndSettle();
    final pressed = tester.backgroundOf(button);
    expect(pressed, isNot(idle));
    expect(pressed, isNot(hovered));
    await press.up();
    await tester.pumpAndSettle();
    expect(tester.backgroundOf(button), idle);
  });

  testWidgets('focus shows the ring and Enter activates', (tester) async {
    var taps = 0;
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpApp(
      PrimaryButton(label: 'Focus', focusNode: node, onPressed: () => taps++),
    );
    final button = find.byType(PrimaryButton);
    expect(tester.focusRingVisible(button), isFalse);

    node.requestFocus();
    await tester.pumpAndSettle();
    expect(tester.focusRingVisible(button), isTrue);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(taps, 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(taps, 2);
  });

  testWidgets('expand stretches to the available width', (tester) async {
    await tester.pumpApp(
      SizedBox(
        width: 300,
        child: PrimaryButton(label: 'Wide', expand: true, onPressed: () {}),
      ),
    );
    expect(tester.getSize(find.byType(PrimaryButton)).width, 300);
  });

  testWidgets('shows a leading icon when given', (tester) async {
    await tester.pumpApp(
      PrimaryButton(label: 'Play', icon: AppIconGlyph.play, onPressed: () {}),
    );
    expect(find.byType(AppIcon), findsOneWidget);
  });
}
