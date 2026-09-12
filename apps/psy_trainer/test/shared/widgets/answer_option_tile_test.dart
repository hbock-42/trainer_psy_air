import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/visuals.dart';

void main() {
  final light = AppTheme.light();
  final tile = find.byType(AnswerOptionTile);

  Widget build(AnswerOptionState state, {VoidCallback? onPressed, int? index}) {
    return SizedBox(
      width: 320,
      child: AnswerOptionTile(
        label: 'Paris',
        index: index,
        state: state,
        onPressed: onPressed,
      ),
    );
  }

  testWidgets('idle tile shows label, index badge and reports taps', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      build(AnswerOptionState.idle, index: 2, onPressed: () => taps++),
    );
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(tester.getSize(tile).height, greaterThanOrEqualTo(48));
    expect(tester.borderColorOf(tile), light.colors.border);

    await tester.tap(tile);
    expect(taps, 1);
  });

  testWidgets('each state has its own border colour and trailing mark', (
    tester,
  ) async {
    await tester.pumpApp(build(AnswerOptionState.selected));
    expect(tester.borderColorOf(tile), light.colors.accent);
    expect(tester.backgroundOf(tile), light.colors.accentSubtle);
    expect(find.byType(AppIcon), findsNothing);

    await tester.pumpApp(build(AnswerOptionState.correct));
    expect(tester.borderColorOf(tile), light.colors.success);
    expect(
      tester.widget<AppIcon>(find.byType(AppIcon)).glyph,
      AppIconGlyph.check,
    );

    await tester.pumpApp(build(AnswerOptionState.wrong));
    expect(tester.borderColorOf(tile), light.colors.error);
    expect(
      tester.widget<AppIcon>(find.byType(AppIcon)).glyph,
      AppIconGlyph.cross,
    );

    await tester.pumpApp(build(AnswerOptionState.disabled));
    expect(tester.borderColorOf(tile), light.colors.border);
    expect(find.byType(AppIcon), findsNothing);
  });

  testWidgets('revealed and disabled tiles ignore taps', (tester) async {
    for (final state in [
      AnswerOptionState.correct,
      AnswerOptionState.wrong,
      AnswerOptionState.disabled,
    ]) {
      var taps = 0;
      await tester.pumpApp(build(state, onPressed: () => taps++));
      await tester.tap(tile);
      expect(taps, 0, reason: '$state must not be tappable');
    }
  });

  testWidgets('selected tile can still be tapped (to change the answer)', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpApp(
      build(AnswerOptionState.selected, onPressed: () => taps++),
    );
    await tester.tap(tile);
    expect(taps, 1);
  });

  testWidgets('semantics: option index, label, selected flag and state hint', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      build(AnswerOptionState.selected, index: 3, onPressed: () {}),
    );
    expect(
      tester.getSemantics(tile),
      matchesSemantics(
        label: 'Option 3. Paris',
        hint: 'Selected',
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );

    await tester.pumpApp(build(AnswerOptionState.wrong, index: 3));
    // Focus semantics catch up one frame after the node becomes unfocusable.
    await tester.pumpAndSettle();
    expect(
      tester.getSemantics(tile),
      matchesSemantics(
        label: 'Option 3. Paris',
        hint: 'Wrong answer',
        isButton: true,
        hasSelectedState: true,
        hasEnabledState: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('hover raises the idle tile', (tester) async {
    await tester.pumpApp(build(AnswerOptionState.idle, onPressed: () {}));
    await tester.hover(tile);
    expect(tester.backgroundOf(tile), light.colors.surfaceRaised);
    expect(tester.borderColorOf(tile), light.colors.borderStrong);
  });

  testWidgets('custom child replaces the text but keeps the label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      const SizedBox(
        width: 320,
        child: AnswerOptionTile(
          label: 'Figure B',
          child: SizedBox(width: 40, height: 40),
        ),
      ),
    );
    expect(find.text('Figure B'), findsNothing);
    expect(
      tester.getSemantics(tile),
      matchesSemantics(
        label: 'Figure B',
        isButton: true,
        hasEnabledState: true,
        hasSelectedState: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('long labels wrap without overflow at 1.3x', (tester) async {
    await tester.pumpApp(
      SizedBox(
        width: 280,
        child: AnswerOptionTile(
          index: 1,
          label:
              'A rather long answer that needs to wrap on two lines at least',
          onPressed: () {},
        ),
      ),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });

  test('index outside 1..6 is rejected', () {
    expect(
      () => AnswerOptionTile(label: 'x', index: 7),
      throwsA(isA<AssertionError>()),
    );
  });
}
