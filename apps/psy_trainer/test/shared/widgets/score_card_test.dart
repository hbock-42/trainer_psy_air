import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/pump_app.dart';

void main() {
  final light = AppTheme.light();

  Color colorOfText(WidgetTester tester, String text) {
    return tester.widget<Text>(find.text(text)).style!.color!;
  }

  testWidgets('shows title, value, subtitle', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 240,
        child: ScoreCard(
          title: 'Accuracy',
          value: '87 %',
          subtitle: 'Last 7 days',
        ),
      ),
    );
    expect(find.text('ACCURACY'), findsOneWidget);
    expect(find.text('87 %'), findsOneWidget);
    expect(find.text('Last 7 days'), findsOneWidget);
    expect(find.byType(AppCard), findsOneWidget);
  });

  testWidgets('delta is coloured by sign', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 240,
        child: ScoreCard(
          title: 'Score',
          value: '12',
          delta: 3.5,
          deltaSuffix: '%',
        ),
      ),
    );
    expect(colorOfText(tester, '+3.5%'), light.colors.success);

    await tester.pumpApp(
      const SizedBox(
        width: 240,
        child: ScoreCard(title: 'Score', value: '12', delta: -2),
      ),
    );
    expect(colorOfText(tester, '-2'), light.colors.error);

    await tester.pumpApp(
      const SizedBox(
        width: 240,
        child: ScoreCard(title: 'Score', value: '12', delta: 0),
      ),
    );
    expect(colorOfText(tester, '0'), light.colors.textMuted);
  });

  testWidgets('semantics groups everything into one node', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      const SizedBox(
        width: 240,
        child: ScoreCard(
          title: 'Accuracy',
          value: '87 %',
          subtitle: 'Last 7 days',
          delta: 1,
        ),
      ),
    );
    final node = tester.getSemantics(find.bySemanticsLabel('Accuracy'));
    expect(node.value, '87 %, Last 7 days, change +1');
    handle.dispose();
  });

  testWidgets('narrow card at 1.3x does not overflow', (tester) async {
    await tester.pumpApp(
      const SizedBox(
        width: 150,
        child: ScoreCard(
          title: 'Mental arithmetic',
          value: '1234/2000',
          delta: 12.5,
        ),
      ),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
  });

  test('formatDelta', () {
    expect(ScoreCard.formatDelta(3.5), '+3.5');
    expect(ScoreCard.formatDelta(3.0), '+3');
    expect(ScoreCard.formatDelta(-2.25), '-2.3');
    expect(ScoreCard.formatDelta(0), '0');
    expect(ScoreCard.formatDelta(-0.04), '0');
  });
}
