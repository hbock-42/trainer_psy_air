import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/providers/dashboard_labels_provider.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/exam_score_chart_card.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/family_trend_charts.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';
import '../progress_fixtures.dart';

void main() {
  late ProgressFixture fixture;
  late ProviderContainer container;

  setUp(() {
    fixture = ProgressFixture();
    container = ProviderContainer(overrides: fixture.overrides);
    addTearDown(container.dispose);
  });

  Future<void> pumpCard(
    WidgetTester tester, {
    AppTheme? theme,
    double textScale = 1.0,
    double width = 500,
  }) async {
    await tester.binding.setSurfaceSize(Size(width, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final labels = await container.read(dashboardLabelsProvider.future);
    await tester.pumpApp(
      UncontrolledProviderScope(
        container: container,
        child: ListView(children: [ExamScoreChartCard(labels: labels)]),
      ),
      theme: theme,
      textScale: textScale,
      align: false,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders nothing without a completed simulation', (tester) async {
    await fixture.practice('arithmetic_grid', daysAgo: 1, correct: 8);
    // An abandoned simulation does not count either.
    final session = await fixture.progress.startSession(
      mode: SessionMode.exam,
      blueprintId: blueprint.id,
      startedAt: daysAgo(2),
    );
    await fixture.progress.finishSession(
      session.id,
      status: SessionStatus.abandoned,
    );
    await pumpCard(tester);
    expect(find.byType(ExamScoreChart), findsNothing);
    expect(find.byType(LineChart), findsNothing);
    expect(find.text(AppStrings.examChartTitle), findsNothing);
  });

  testWidgets('plots completed simulations oldest first with a summary', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await fixture.exam(daysAgo: 10, correct: 4);
    await fixture.exam(daysAgo: 5, correct: 6);
    await fixture.exam(daysAgo: 1, correct: 8);
    await pumpCard(tester);

    expect(find.text(AppStrings.examChartTitle), findsOneWidget);
    expect(find.text(AppStrings.examChartHint), findsOneWidget);
    final node = tester.getSemantics(find.byType(LineChart));
    expect(node.label, AppStrings.examChartSemanticsLabel);
    expect(node.value, AppStrings.examChartSummary(40, 80, 3));
    expect(node.value, 'de 40 % à 80 % sur 3 simulations');
    expect(find.byType(ExamSectionBreakdown), findsNothing);
    handle.dispose();
  });

  testWidgets('tapping a point opens the per-section breakdown', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await fixture.exam(daysAgo: 10, correct: 4);
    await fixture.exam(daysAgo: 1, correct: 8);
    await pumpCard(tester);

    final chart = tester.getRect(find.byType(LineChart));
    // Right edge: the latest simulation.
    await tester.tapAt(Offset(chart.right - 2, chart.center.dy));
    await tester.pumpAndSettle();

    expect(find.byType(ExamSectionBreakdown), findsOneWidget);
    expect(
      find.text(
        AppStrings.examSectionsTitle(FamilyTrendCharts.longDate(daysAgo(1))),
      ),
      findsOneWidget,
    );
    // The tooltip of the tapped point stays visible.
    expect(find.text(AppStrings.examAttempt(2)), findsOneWidget);
    expect(find.text(AppStrings.examScoreLine(80)), findsOneWidget);

    final bars = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.examSectionsSemanticsLabel),
    );
    expect(
      bars.value,
      '1. Grilles de calcul : 8/10 · 80 %, 2. Dominos : 8/10 · 80 %',
    );

    // Left edge: the first simulation.
    await tester.tapAt(Offset(chart.left + 45, chart.center.dy));
    await tester.pumpAndSettle();
    expect(
      find.text(
        AppStrings.examSectionsTitle(FamilyTrendCharts.longDate(daysAgo(10))),
      ),
      findsOneWidget,
    );
    expect(find.text(AppStrings.examAttempt(1)), findsOneWidget);

    // Tapping the same point again closes the panel.
    await tester.tapAt(Offset(chart.left + 45, chart.center.dy));
    await tester.pumpAndSettle();
    expect(find.byType(ExamSectionBreakdown), findsNothing);
    handle.dispose();
  });

  testWidgets('a section never reached reads as such', (tester) async {
    final handle = tester.ensureSemantics();
    // Only the first section was answered.
    final startedAt = daysAgo(1);
    final session = await fixture.progress.startSession(
      mode: SessionMode.exam,
      blueprintId: blueprint.id,
      startedAt: startedAt,
    );
    await fixture.progress.recordAttempts([
      for (var i = 0; i < 10; i++)
        NewAttempt(
          sessionId: session.id,
          familyId: 'arithmetic_grid',
          origin: AttemptOrigin(generatorId: 'g', seed: i),
          isCorrect: i < 5,
          responseMs: 800,
          position: i,
          sectionIndex: 0,
          answeredAt: startedAt.add(Duration(seconds: i)),
        ),
    ]);
    await fixture.progress.finishSession(
      session.id,
      status: SessionStatus.completed,
    );
    await pumpCard(tester);
    final chart = tester.getRect(find.byType(LineChart));
    await tester.tapAt(chart.center);
    await tester.pumpAndSettle();
    final bars = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.examSectionsSemanticsLabel),
    );
    expect(
      bars.value,
      '1. Grilles de calcul : 5/10 · 50 %, '
      '2. Dominos : ${AppStrings.examSectionNotReached}',
    );
    handle.dispose();
  });

  testWidgets('a single simulation, dark and 1.3x on a phone, no overflow', (
    tester,
  ) async {
    await fixture.exam(daysAgo: 1, correct: 7);
    await pumpCard(tester, theme: AppTheme.dark(), textScale: 1.3, width: 360);
    expect(tester.takeException(), isNull);
    final chart = tester.getRect(find.byType(LineChart));
    await tester.tapAt(chart.center);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(ExamSectionBreakdown), findsOneWidget);
  });

  test('completedOldestFirst drops abandoned sims and sorts by date', () {
    ExamSummary exam(String id, int day, SessionStatus status) => ExamSummary(
      sessionId: id,
      startedAt: DateTime.utc(2026, 9, day),
      status: status,
      score: 0.5,
      sections: const [],
    );
    final history = [
      exam('c', 3, SessionStatus.completed),
      exam('b', 2, SessionStatus.abandoned),
      exam('a', 1, SessionStatus.completed),
    ];
    expect(
      ExamScoreChartCard.completedOldestFirst(history).map((e) => e.sessionId),
      ['a', 'c'],
    );
    expect(
      ExamScoreChartCard.describe([history.last]),
      '50 % sur 1 simulation',
    );
  });
}
