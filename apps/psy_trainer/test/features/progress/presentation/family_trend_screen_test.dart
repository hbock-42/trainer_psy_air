import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/family_trend_screen.dart';
import 'package:psy_trainer/features/progress/presentation/providers/family_time_series_provider.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/family_trend_charts.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/segmented_choice.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/pump_app.dart';
import 'progress_fixtures.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  late ProgressFixture fixture;
  late ProviderContainer container;

  setUp(() {
    fixture = ProgressFixture();
    container = ProviderContainer(overrides: fixture.overrides);
    addTearDown(container.dispose);
  });

  Future<void> pumpScreen(
    WidgetTester tester, {
    String familyId = 'arithmetic_grid',
    TrendRange initialRange = TrendRange.month,
    AppTheme? theme,
    double textScale = 1.0,
    Size? surface,
  }) async {
    if (surface != null) {
      await tester.binding.setSurfaceSize(surface);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    await tester.pumpApp(
      UncontrolledProviderScope(
        container: container,
        child: FamilyTrendScreen(
          familyId: familyId,
          initialRange: initialRange,
        ),
      ),
      theme: theme,
      textScale: textScale,
      align: false,
    );
    await tester.pumpAndSettle();
  }

  /// Sessions of `arithmetic_grid`: 45 days ago (outside 30 j), 20 and 10
  /// days ago (30 j only), 3 days ago and today (7 j), plus one simulation
  /// 2 days ago.
  Future<void> seed() async {
    await fixture.practice('arithmetic_grid', daysAgo: 45, correct: 3);
    await fixture.practice('arithmetic_grid', daysAgo: 20, correct: 4);
    await fixture.practice('arithmetic_grid', daysAgo: 10, correct: 5);
    await fixture.practice('arithmetic_grid', daysAgo: 3, correct: 7);
    await fixture.exam(daysAgo: 2, correct: 6);
    await fixture.practice('arithmetic_grid', daysAgo: 0, correct: 9);
  }

  /// The semantics node of the accuracy (first) or speed (second) chart.
  SemanticsNode chartNode(WidgetTester tester, {int index = 0}) =>
      tester.getSemantics(find.byType(LineChart).at(index));

  testWidgets('shows the family name, both charts and the filters', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await seed();
    await pumpScreen(tester, surface: const Size(500, 1400));

    expect(find.text('Grilles de calcul'), findsOneWidget);
    expect(find.byType(LineChart), findsNWidgets(2));
    expect(find.text(l10nFr.trendAccuracyTitle), findsOneWidget);
    expect(find.text(l10nFr.trendSpeedTitle), findsOneWidget);
    expect(find.byType(SegmentedChoice<TrendRange>), findsOneWidget);
    expect(find.byType(SegmentedChoice<SessionMode?>), findsOneWidget);
    expect(find.text(l10nFr.trendRange7d), findsOneWidget);
    expect(find.text(l10nFr.trendRange30d), findsOneWidget);
    expect(find.text(l10nFr.trendRangeAll), findsOneWidget);

    // 30 days: five sessions (4 practice + 1 exam), 40 % -> 90 %.
    final accuracy = chartNode(tester);
    expect(accuracy.label, l10nFr.trendAccuracyTitle);
    expect(accuracy.value, l10nFr.trendAccuracySummary(5, 90, 40));
    expect(accuracy.value, 'de 40 % à 90 % sur 5 sessions');
    final speed = chartNode(tester, index: 1);
    expect(speed.label, l10nFr.trendSpeedTitle);
    expect(speed.value, l10nFr.trendSpeedSummary(5, l10nFr.seconds(0.8), l10nFr.seconds(0.8)));
    expect(speed.value, 'de 0,8 s à 0,8 s sur 5 sessions');
    handle.dispose();
  });

  testWidgets('the range selector narrows and widens the series', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await seed();
    await pumpScreen(tester, surface: const Size(500, 1400));

    await tester.tap(find.text(l10nFr.trendRange7d));
    await tester.pumpAndSettle();
    expect(chartNode(tester).value, l10nFr.trendAccuracySummary(3, 90, 70));

    await tester.tap(find.text(l10nFr.trendRangeAll));
    await tester.pumpAndSettle();
    expect(chartNode(tester).value, l10nFr.trendAccuracySummary(6, 90, 30));

    // The selected pill carries the selected flag.
    expect(
      tester.getSemantics(find.bySemanticsLabel(l10nFr.trendRangeAll)),
      matchesSemantics(
        label: l10nFr.trendRangeAll,
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
    expect(
      tester.getSemantics(find.bySemanticsLabel(l10nFr.trendRange7d)),
      matchesSemantics(
        label: l10nFr.trendRange7d,
        isButton: true,
        // Not selected (the matcher's default), with a selected state.
        hasSelectedState: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('the mode filter keeps only exercises or simulations', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await seed();
    await pumpScreen(tester, surface: const Size(500, 1400));

    await tester.tap(find.text(l10nFr.trendModePractice));
    await tester.pumpAndSettle();
    expect(chartNode(tester).value, l10nFr.trendAccuracySummary(4, 90, 40));

    await tester.tap(find.text(l10nFr.trendModeExam));
    await tester.pumpAndSettle();
    expect(chartNode(tester).value, l10nFr.trendAccuracySummary(1, 60, 60));
    expect(chartNode(tester).value, '60 % sur 1 session');
    handle.dispose();
  });

  testWidgets('shows the empty caption when the range has no session', (
    tester,
  ) async {
    await fixture.practice('arithmetic_grid', daysAgo: 45, correct: 3);
    await pumpScreen(tester, initialRange: TrendRange.week);
    expect(find.text(l10nFr.trendEmpty), findsOneWidget);
    expect(find.byType(LineChart), findsNothing);

    await tester.tap(find.text(l10nFr.trendRangeAll));
    await tester.pumpAndSettle();
    expect(find.text(l10nFr.trendEmpty), findsNothing);
    expect(find.byType(LineChart), findsNWidgets(2));
  });

  testWidgets('an unknown family falls back to the generic title', (
    tester,
  ) async {
    await pumpScreen(tester, familyId: 'nope');
    expect(find.text(l10nFr.familyTrendTitle), findsOneWidget);
    expect(find.text(l10nFr.trendEmpty), findsOneWidget);
  });

  testWidgets('a failing series shows the error message', (tester) async {
    container = ProviderContainer(
      overrides: [
        ...fixture.overrides,
        familyTimeSeriesProvider.overrideWith(
          (ref, query) => throw StateError('boom'),
        ),
      ],
    );
    addTearDown(container.dispose);
    await pumpScreen(tester);
    expect(find.text(l10nFr.progressError), findsOneWidget);
  });

  testWidgets('the tooltip shows date, kind, accuracy and response time', (
    tester,
  ) async {
    await seed();
    await pumpScreen(tester, surface: const Size(500, 1400));

    // Hover the right edge of the accuracy chart: the latest session.
    final chart = tester.getRect(find.byType(LineChart).first);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await gesture.moveTo(Offset(chart.right - 2, chart.center.dy));
    await tester.pumpAndSettle();

    expect(find.byType(TrendTooltip), findsOneWidget);
    expect(find.text(FamilyTrendCharts.longDate(now)), findsOneWidget);
    expect(find.text(l10nFr.activityPractice), findsOneWidget);
    expect(
      find.text(l10nFr.trendTooltipAccuracy(9, 10, 90)),
      findsOneWidget,
    );
    expect(find.text('Réussite : 9/10 (90 %)'), findsOneWidget);
    expect(find.text(l10nFr.trendTooltipSpeed(l10nFr.seconds(0.8))), findsOneWidget);
    expect(find.text('Temps : 0,8 s'), findsOneWidget);

    // Left edge: the oldest session in range, the simulation is second.
    await gesture.moveTo(Offset(chart.left + 40, chart.center.dy));
    await tester.pumpAndSettle();
    expect(
      find.text(l10nFr.trendTooltipAccuracy(4, 10, 40)),
      findsOneWidget,
    );

    // Point of the exam session (index 3 of 5).
    final plotX = chart.left + 40 + (chart.right - 2 - chart.left - 40) * 3 / 4;
    await gesture.moveTo(Offset(plotX, chart.center.dy));
    await tester.pumpAndSettle();
    expect(find.text(l10nFr.activityExam), findsOneWidget);
    expect(
      find.text(l10nFr.trendTooltipAccuracy(6, 10, 60)),
      findsOneWidget,
    );
  });

  testWidgets('phone width at 1.3x in dark mode does not overflow', (
    tester,
  ) async {
    await seed();
    await pumpScreen(
      tester,
      theme: AppTheme.dark(),
      textScale: 1.3,
      surface: const Size(360, 1600),
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(LineChart), findsNWidgets(2));
  });

  group('FamilyTrendCharts helpers', () {
    TrendPoint point(int day, {double ms = 800}) => TrendPoint(
      sessionId: 's$day',
      mode: SessionMode.practice,
      at: DateTime.utc(2026, 9, day, 10),
      attempts: 10,
      correct: 5,
      unanswered: 0,
      medianResponseMs: ms,
    );

    test('dateTicks keeps first and last, spreads the rest', () {
      expect(FamilyTrendCharts.dateTicks(const []), isEmpty);
      expect(FamilyTrendCharts.dateTicks([point(3)]), [
        const LineChartTick(0, '03/09'),
      ]);
      final ticks = FamilyTrendCharts.dateTicks([
        for (var d = 1; d <= 9; d++) point(d),
      ]);
      expect(ticks.map((t) => t.value), [0, 3, 5, 8]);
      expect(ticks.first.label, '01/09');
      expect(ticks.last.label, '09/09');
      expect(
        FamilyTrendCharts.dateTicks([point(1), point(2)]).map((t) => t.value),
        [0, 1],
      );
    });

    test('speedCeiling rounds the slowest session up to whole seconds', () {
      expect(FamilyTrendCharts.speedCeiling([point(1, ms: 300)]), 1);
      expect(
        FamilyTrendCharts.speedCeiling([
          point(1, ms: 1200),
          point(2, ms: 2400),
        ]),
        3,
      );
    });

    test('summaries and formats', () {
      expect(l10nFr.seconds(1.25), '1,3 s');
      expect(l10nFr.trendAccuracySummary(1, 70, 40), '70 % sur 1 session');
      expect(l10nFr.trendSpeedSummary(1, l10nFr.seconds(0.9), l10nFr.seconds(1)), '0,9 s sur 1 session');
      expect(TrendRange.all.from(now), isNull);
      expect(TrendRange.week.from(now), now.subtract(const Duration(days: 7)));
      expect(
        TrendRange.month.from(now),
        now.subtract(const Duration(days: 30)),
      );
    });
  });
}
