import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/features/progress/domain/daily_goal.dart';
import 'package:psy_trainer/features/progress/domain/streak_service.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/streak_card.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

StreakSummary summary({
  int currentStreak = 5,
  int bestStreak = 12,
  int todayItems = 8,
  double todayMinutes = 0,
  DailyGoal goal = DailyGoal.defaults,
}) => StreakSummary(
  currentStreak: currentStreak,
  bestStreak: bestStreak,
  todayItems: todayItems,
  todayMinutes: todayMinutes,
  goal: goal,
  heatmap: [
    for (var i = 0; i < 84; i++)
      DailyActivity(date: DateTime(2026, 9, i + 1), itemCount: i % 3),
  ],
);

void main() {
  testWidgets('shows the current streak, the best streak and today\'s goal', (
    tester,
  ) async {
    await tester.pumpApp(StreakCard(summary: summary()), align: false);

    expect(find.text(l10nFr.streakDays(5)), findsOneWidget);
    expect(find.text(l10nFr.streakBest(12)), findsOneWidget);
    expect(find.text(l10nFr.streakGoalItems(8, 20)), findsOneWidget);
    expect(find.text(l10nFr.streakGoalMet), findsNothing);
  });

  testWidgets('shows the goal-met caption once the target is reached', (
    tester,
  ) async {
    await tester.pumpApp(
      StreakCard(summary: summary(todayItems: 20)),
      align: false,
    );

    expect(find.text(l10nFr.streakGoalMet), findsOneWidget);
  });

  testWidgets('a minutes goal shows the minutes caption', (tester) async {
    await tester.pumpApp(
      StreakCard(
        summary: summary(
          todayMinutes: 12,
          goal: const DailyGoal(unit: GoalUnit.minutes),
        ),
      ),
      align: false,
    );

    expect(find.text(l10nFr.streakGoalMinutes(12, 20)), findsOneWidget);
  });

  testWidgets('the ring and the heat-map carry accessible summaries', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(StreakCard(summary: summary()), align: false);

    expect(find.bySemanticsLabel(l10nFr.streakSemanticsLabel), findsOneWidget);
    expect(
      find.bySemanticsLabel(l10nFr.activityHeatmapSemanticsLabel),
      findsOneWidget,
    );
    expect(find.byType(ArcGauge), findsOneWidget);
    handle.dispose();
  });
}
