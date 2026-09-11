import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  final light = AppTheme.light();

  Color fillColor(WidgetTester tester) {
    final decoration = tester
        .widget<AnimatedContainer>(find.byType(AnimatedContainer))
        .decoration;
    return (decoration! as BoxDecoration).color!;
  }

  double fillFraction(WidgetTester tester) {
    return tester
        .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
        .widthFactor!;
  }

  testWidgets('fills proportionally and shows the remaining time', (
    tester,
  ) async {
    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: 45),
          total: Duration(minutes: 1),
        ),
      ),
    );
    expect(fillFraction(tester), 0.75);
    expect(fillColor(tester), light.colors.accent);
    expect(find.text('0:45'), findsOneWidget);
  });

  testWidgets('turns to the error colour under 20 %', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: 11),
          total: Duration(minutes: 1),
        ),
      ),
    );
    expect(fillColor(tester), light.colors.error);

    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: 12),
          total: Duration(minutes: 1),
        ),
      ),
    );
    expect(
      fillColor(tester),
      light.colors.accent,
      reason: 'exactly 20 % is not yet warning',
    );
  });

  testWidgets('clamps overshoot and negative values', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: -5),
          total: Duration(seconds: 30),
        ),
      ),
    );
    expect(fillFraction(tester), 0);
    expect(find.text('0:00'), findsOneWidget);

    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: 90),
          total: Duration(seconds: 30),
        ),
      ),
    );
    expect(fillFraction(tester), 1);
  });

  testWidgets('label can be hidden', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(seconds: 30),
          total: Duration(minutes: 1),
          showLabel: false,
        ),
      ),
    );
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('announces remaining and total time', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      const SizedBox(
        width: 300,
        child: CountdownTimerBar(
          remaining: Duration(minutes: 2, seconds: 5),
          total: Duration(minutes: 10),
        ),
      ),
    );
    expect(find.bySemanticsLabel('Time remaining'), findsOneWidget);
    final node = tester.getSemantics(find.bySemanticsLabel('Time remaining'));
    expect(node.value, '2:05 of 10:00');
    handle.dispose();
  });

  test('format renders m:ss and h:mm:ss', () {
    expect(CountdownTimerBar.format(const Duration(seconds: 7)), '0:07');
    expect(
      CountdownTimerBar.format(const Duration(minutes: 12, seconds: 30)),
      '12:30',
    );
    expect(
      CountdownTimerBar.format(
        const Duration(hours: 1, minutes: 2, seconds: 3),
      ),
      '1:02:03',
    );
    expect(CountdownTimerBar.format(const Duration(seconds: -3)), '0:00');
  });
}
