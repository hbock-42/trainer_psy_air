import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

void main() {
  final light = AppTheme.light();

  testWidgets('renders label, calls onPressed, meets the touch target', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      SecondaryButton(label: 'Skip', onPressed: () => taps++),
    );

    expect(find.text('Skip'), findsOneWidget);
    expect(
      tester.getSize(find.byType(SecondaryButton)).height,
      greaterThanOrEqualTo(48),
    );
    await tester.tap(find.byType(SecondaryButton));
    expect(taps, 1);
  });

  testWidgets('is outlined when idle and tinted on hover', (tester) async {
    await tester.pumpApp(SecondaryButton(label: 'Hover', onPressed: () {}));
    final button = find.byType(SecondaryButton);
    expect(tester.borderColorOf(button), light.colors.borderStrong);
    expect(tester.backgroundOf(button)?.a, 0);

    await tester.hover(button);
    expect(tester.backgroundOf(button), light.colors.surfaceRaised);
  });

  testWidgets('disabled uses the faint border and reports disabled semantics', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(const SecondaryButton(label: 'Off'));
    final button = find.byType(SecondaryButton);
    expect(tester.borderColorOf(button), light.colors.border);
    expect(
      tester.getSemantics(button),
      matchesSemantics(label: 'Off', isButton: true, hasEnabledState: true),
    );
    handle.dispose();
  });

  testWidgets('focus ring appears when focused', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpApp(
      SecondaryButton(label: 'Focus', focusNode: node, onPressed: () {}),
    );
    node.requestFocus();
    await tester.pumpAndSettle();
    expect(tester.focusRingVisible(find.byType(SecondaryButton)), isTrue);
  });

  testWidgets('does not overflow at 1.3x text scale in a narrow column', (
    tester,
  ) async {
    await tester.pumpApp(
      SizedBox(
        width: 200,
        child: SecondaryButton(
          label: 'A fairly long secondary label',
          expand: true,
          onPressed: () {},
        ),
      ),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });
}
