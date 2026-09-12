import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/progress/domain/streak_service.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/activity_heatmap.dart';

import '../../../../helpers/pump_app.dart';

List<DailyActivity> days(int count, int Function(int index) itemCountAt) => [
  for (var i = 0; i < count; i++)
    DailyActivity(date: DateTime(2026, 1, i + 1), itemCount: itemCountAt(i)),
];

void main() {
  test('level() buckets item counts into 0..4', () {
    expect(ActivityHeatmap.level(0), 0);
    expect(ActivityHeatmap.level(1), 1);
    expect(ActivityHeatmap.level(2), 1);
    expect(ActivityHeatmap.level(3), 2);
    expect(ActivityHeatmap.level(5), 2);
    expect(ActivityHeatmap.level(6), 3);
    expect(ActivityHeatmap.level(9), 3);
    expect(ActivityHeatmap.level(10), 4);
    expect(ActivityHeatmap.level(100), 4);
  });

  testWidgets('paints one cell per day without throwing', (tester) async {
    await tester.pumpApp(
      ActivityHeatmap(
        days: days(84, (i) => i % 5),
        semanticsLabel: 'Calendrier',
        semanticsValue: '10/84 jours actifs',
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(ActivityHeatmap), findsOneWidget);
  });

  testWidgets('exposes the label and value as one semantics node', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      ActivityHeatmap(
        days: days(7, (i) => 0),
        semanticsLabel: 'Calendrier',
        semanticsValue: '0/7 jours actifs',
      ),
    );

    final node = tester.getSemantics(find.bySemanticsLabel('Calendrier'));
    expect(node.value, '0/7 jours actifs');
    handle.dispose();
  });
}
