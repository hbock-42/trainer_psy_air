import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  final light = AppTheme.light();

  List<AnimatedContainer> dots(WidgetTester tester) {
    return tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .toList();
  }

  testWidgets('draws one dot per step, filled up to the current one', (
    tester,
  ) async {
    await tester.pumpApp(const ProgressDots(current: 3, total: 5));
    final all = dots(tester);
    expect(all, hasLength(5));

    for (var i = 0; i < 5; i++) {
      final decoration = all[i].decoration! as BoxDecoration;
      if (i < 3) {
        expect(decoration.color, light.colors.accent, reason: 'dot ${i + 1}');
        expect(decoration.border, isNull);
      } else {
        expect(decoration.color?.a, 0, reason: 'dot ${i + 1}');
        expect(decoration.border, isNotNull);
      }
    }
  });

  testWidgets('the current dot is larger than the others', (tester) async {
    await tester.pumpApp(const ProgressDots(current: 2, total: 4));
    final all = dots(tester);
    expect(
      all[1].constraints!.maxWidth,
      greaterThan(all[0].constraints!.maxWidth),
    );
    expect(
      all[1].constraints!.maxWidth,
      greaterThan(all[2].constraints!.maxWidth),
    );
  });

  testWidgets('falls back to a bar above maxDots', (tester) async {
    await tester.pumpApp(
      const SizedBox(width: 300, child: ProgressDots(current: 10, total: 40)),
    );
    expect(find.byType(AnimatedContainer), findsNothing);
    expect(
      tester
          .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
          .widthFactor,
      0.25,
    );
  });

  testWidgets('announces "current of total"', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(const ProgressDots(current: 7, total: 12));
    final node = tester.getSemantics(find.bySemanticsLabel('Progress'));
    expect(node.value, '7 of 12');
    handle.dispose();
  });

  test('rejects out-of-range positions', () {
    expect(
      () => ProgressDots(current: 0, total: 3),
      throwsA(isA<AssertionError>()),
    );
    expect(
      () => ProgressDots(current: 4, total: 3),
      throwsA(isA<AssertionError>()),
    );
  });
}
