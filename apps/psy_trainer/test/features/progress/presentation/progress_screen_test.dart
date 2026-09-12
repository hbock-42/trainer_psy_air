import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/progress/presentation/family_trend_screen.dart';
import 'package:psy_trainer/features/progress/presentation/progress_screen.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_snapshot_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_version_provider.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/exam_score_chart_card.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/family_levels_chart.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/progress_empty_state.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/readiness_card.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/recent_activity_list.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/train_next_card.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_launcher_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/onboarding_fakes.dart';
import '../../../helpers/pump_app.dart';
import 'progress_fixtures.dart';

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
        child: const ProgressScreen(),
      ),
      textScale: textScale,
      align: false,
    );
    await tester.pumpAndSettle();
  }

  /// Practises the three first families so the radar has enough data.
  Future<void> seedThreeFamilies() async {
    await fixture.practice('arithmetic_grid', daysAgo: 3, correct: 10);
    await fixture.practice('logic_dominos', daysAgo: 2, correct: 7);
    await fixture.practice('memory_nback', daysAgo: 1, correct: 3);
  }

  testWidgets('shows the loading message, then the empty state', (
    tester,
  ) async {
    await tester.pumpApp(
      UncontrolledProviderScope(
        container: container,
        child: const ProgressScreen(),
      ),
      align: false,
    );
    expect(find.text(AppStrings.progressLoading), findsOneWidget);
    await tester.pumpAndSettle();

    expect(find.byType(ProgressEmptyState), findsOneWidget);
    expect(find.text(AppStrings.progressEmptyTitle), findsOneWidget);
    expect(find.text(AppStrings.progressEmptyAction), findsOneWidget);
    expect(find.byType(ReadinessCard), findsNothing);
  });

  testWidgets('shows the error message when the snapshot fails', (
    tester,
  ) async {
    container = ProviderContainer(
      overrides: [
        ...fixture.overrides,
        progressSnapshotProvider.overrideWith(
          (ref) => throw StateError('boom'),
        ),
      ],
    );
    addTearDown(container.dispose);
    await pumpScreen(tester);
    expect(find.text(AppStrings.progressError), findsOneWidget);
    expect(find.byType(ProgressEmptyState), findsNothing);
  });

  testWidgets('the gauge shows the rounded readiness and its trend', (
    tester,
  ) async {
    await seedThreeFamilies();
    await pumpScreen(tester);

    final snapshot = await container.read(progressSnapshotProvider.future);
    expect(snapshot.isEmpty, isFalse);
    final expected = snapshot.readiness.rounded;
    expect(expected, greaterThan(0));

    expect(find.byType(ReadinessCard), findsOneWidget);
    expect(find.byType(ArcGauge), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(ArcGauge),
        matching: find.text('$expected'),
      ),
      findsOneWidget,
    );
    expect(find.text(AppStrings.readinessOutOf), findsOneWidget);
    // Single sessions per family: no trend yet.
    expect(find.text(AppStrings.readinessTrendFlat), findsOneWidget);
    expect(find.text(AppStrings.readinessFamilies(3, 4)), findsOneWidget);
    expect(find.text(AppStrings.readinessExams(0)), findsOneWidget);
    // No exam date: no countdown chip.
    expect(find.byType(ExamCountdownChip), findsNothing);
  });

  testWidgets('the gauge semantics carries value and trend', (tester) async {
    final handle = tester.ensureSemantics();
    await seedThreeFamilies();
    await pumpScreen(tester);
    final snapshot = await container.read(progressSnapshotProvider.future);
    final node = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.readinessSemanticsLabel),
    );
    expect(
      node.value,
      '${snapshot.readiness.rounded} ${AppStrings.readinessOutOf}, '
      '${AppStrings.readinessTrendFlat}',
    );
    handle.dispose();
  });

  testWidgets('the exam countdown chip shows the days left', (tester) async {
    await seedThreeFamilies();
    await fixture.progress.saveProfile(
      UserProfile(locale: 'fr', examDate: now.add(const Duration(days: 12))),
    );
    await pumpScreen(tester);

    expect(find.byType(ExamCountdownChip), findsOneWidget);
    expect(find.text(AppStrings.examDaysLeft(12)), findsOneWidget);
    expect(find.text('J-12'), findsOneWidget);
  });

  testWidgets('the countdown chip says passed after the exam date', (
    tester,
  ) async {
    await seedThreeFamilies();
    await fixture.progress.saveProfile(
      UserProfile(locale: 'fr', examDate: daysAgo(2)),
    );
    await pumpScreen(tester);
    expect(find.text(AppStrings.examDatePassed), findsOneWidget);
  });

  testWidgets('three practised families draw a radar in real-test order', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await seedThreeFamilies();
    await pumpScreen(tester);

    expect(find.byType(FamilyLevelsChart), findsOneWidget);
    expect(find.byType(RadarChart), findsOneWidget);
    expect(find.byType(HorizontalBarChart), findsNothing);

    final node = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.familyLevelsSemanticsLabel),
    );
    // Every content family, in `order`, short names, level or "not practised".
    expect(
      node.value,
      'Calcul : ${AppStrings.familyLevel(5)}, '
      'Dominos : ${AppStrings.familyLevel(3)}, '
      'N-back : ${AppStrings.familyLevel(1)}, '
      'Anglais : ${AppStrings.familyNotPractised}',
    );
    handle.dispose();
  });

  testWidgets('fewer than three practised families fall back to bars', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await fixture.practice('english', daysAgo: 1, correct: 8);
    await fixture.practice('arithmetic_grid', daysAgo: 2, correct: 4);
    await pumpScreen(tester);

    expect(find.byType(RadarChart), findsNothing);
    expect(find.byType(HorizontalBarChart), findsOneWidget);
    final node = tester.getSemantics(
      find.bySemanticsLabel(AppStrings.familyLevelsSemanticsLabel),
    );
    // Only practised families, full names, still in real-test order.
    expect(
      node.value,
      'Grilles de calcul : ${AppStrings.familyLevel(1)}, '
      'Anglais : ${AppStrings.familyLevel(4)}',
    );
    handle.dispose();
  });

  testWidgets('lessons alone leave the chart without families', (tester) async {
    await fixture.progress.markLessonRead(lesson.id);
    await pumpScreen(tester);
    expect(find.byType(ProgressEmptyState), findsNothing);
    expect(find.text(AppStrings.readinessLessons(1, 1)), findsOneWidget);
    expect(find.text(AppStrings.familyLevelsNone), findsOneWidget);
    expect(find.text(AppStrings.recentActivityNone), findsOneWidget);
  });

  testWidgets('train next lists the weakest families with a train action', (
    tester,
  ) async {
    await fixture.practice('arithmetic_grid', daysAgo: 3, correct: 10);
    await fixture.practice('logic_dominos', daysAgo: 2, correct: 5);
    await fixture.practice('memory_nback', daysAgo: 1, correct: 2);
    await pumpScreen(tester);

    final card = find.byType(TrainNextCard);
    expect(card, findsOneWidget);
    expect(find.text(AppStrings.trainNextEmpty), findsNothing);
    final buttons = find.descendant(
      of: card,
      matching: find.widgetWithText(
        SecondaryButton,
        AppStrings.trainNextActionFamily,
      ),
    );
    expect(buttons, findsNWidgets(2));
    // Weakest first, full family names, an FR reason built from the data.
    final nback = tester.getTopLeft(find.text('Mémoire n-back'));
    final dominos = tester.getTopLeft(find.text('Dominos').last);
    expect(nback.dy, lessThan(dominos.dy));
    expect(
      find.textContaining('précision 20 % sur Mémoire n-back'),
      findsOneWidget,
    );
    expect(find.textContaining('précision 50 % sur Dominos'), findsOneWidget);
  });

  testWidgets('strong families show the "nothing to recommend" caption', (
    tester,
  ) async {
    await seedThreeFamilies();
    await fixture.practice('memory_nback', daysAgo: 0, correct: 10);
    await fixture.practice('memory_nback', daysAgo: 0, correct: 10);
    await pumpScreen(tester);
    // memory_nback: 23/30 = 0.77 > 0.6 and the 30-day trend is up: no weak
    // area, and readiness is not high enough yet to suggest a simulation.
    expect(find.text(AppStrings.trainNextEmpty), findsOneWidget);
    expect(find.text(AppStrings.readinessTrendUp), findsOneWidget);
  });

  testWidgets('recent activity lists sessions and sims newest first', (
    tester,
  ) async {
    await fixture.practice('arithmetic_grid', daysAgo: 5, correct: 8);
    await fixture.exam(daysAgo: 3, correct: 6);
    await fixture.practice(
      'english',
      daysAgo: 1,
      correct: 2,
      attempts: 4,
      status: SessionStatus.abandoned,
    );
    // An in-progress session is not listed.
    await fixture.progress.startSession(
      mode: SessionMode.practice,
      familyId: 'logic_dominos',
      startedAt: daysAgo(0),
    );
    await pumpScreen(tester, surface: const Size(400, 2000));

    final list = find.byType(RecentActivityList);
    expect(list, findsOneWidget);
    final english = find.text('${AppStrings.activityPractice} · Anglais');
    final exam = find.text('${AppStrings.activityExam} · PSY0 complet');
    final calcul = find.text(
      '${AppStrings.activityPractice} · Grilles de calcul',
    );
    expect(english, findsOneWidget);
    expect(exam, findsOneWidget);
    expect(calcul, findsOneWidget);
    expect(
      find.descendant(of: list, matching: find.textContaining('Dominos')),
      findsNothing,
    );

    final englishY = tester.getTopLeft(english).dy;
    final examY = tester.getTopLeft(exam).dy;
    final calculY = tester.getTopLeft(calcul).dy;
    expect(englishY, lessThan(examY));
    expect(examY, lessThan(calculY));

    // Scores: 2/4, 12/20, 8/10.
    expect(find.text(AppStrings.scorePercent(50)), findsOneWidget);
    expect(find.text(AppStrings.scorePercent(60)), findsOneWidget);
    expect(find.text(AppStrings.scorePercent(80)), findsOneWidget);
    // Abandoned sessions say so, next to the date.
    final date = RecentActivityList.formatDate(daysAgo(1));
    expect(
      find.text('$date · ${AppStrings.activityAbandoned}'),
      findsOneWidget,
    );
  });

  testWidgets('bumping the progress version refreshes the dashboard', (
    tester,
  ) async {
    await pumpScreen(tester);
    expect(find.byType(ProgressEmptyState), findsOneWidget);

    await seedThreeFamilies();
    container.read(progressVersionProvider.notifier).bump();
    await tester.pumpAndSettle();
    expect(find.byType(ProgressEmptyState), findsNothing);
    expect(find.byType(ReadinessCard), findsOneWidget);
  });

  testWidgets('phone width at 1.3x does not overflow (light and dark)', (
    tester,
  ) async {
    await seedThreeFamilies();
    await fixture.exam(daysAgo: 1, correct: 7);
    await fixture.progress.saveProfile(
      UserProfile(locale: 'fr', examDate: now.add(const Duration(days: 40))),
    );
    for (final theme in [AppTheme.light(), AppTheme.dark()]) {
      await tester.binding.setSurfaceSize(const Size(360, 3000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpApp(
        UncontrolledProviderScope(
          container: container,
          child: const ProgressScreen(),
        ),
        theme: theme,
        textScale: 1.3,
        align: false,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(RadarChart), findsOneWidget);
    }
  });

  group('inside the app', () {
    Future<ProviderContainer> pumpTheApp(WidgetTester tester) async {
      // The router's guard sends fresh installs to onboarding (US-090).
      fixture.progress.storedProfile = completedAnswers.applyTo(null);
      final appContainer = ProviderContainer(
        overrides: [...fixture.overrides, contentReadyOverride()],
      );
      addTearDown(appContainer.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: appContainer,
          child: const PsyTrainerApp(),
        ),
      );
      appContainer.read(appRouterProvider).go(AppRoutes.progress);
      await tester.pumpAndSettle();
      return appContainer;
    }

    testWidgets('the empty state action opens the Train tab', (tester) async {
      await pumpTheApp(tester);
      expect(find.byType(ProgressScreen), findsOneWidget);
      await tester.tap(find.text(AppStrings.progressEmptyAction));
      await tester.pumpAndSettle();
      expect(find.byType(TrainScreen), findsOneWidget);
    });

    testWidgets('a "train next" family action opens its practice launcher', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await fixture.practice('memory_nback', daysAgo: 1, correct: 2);
      await pumpTheApp(tester);
      final button = find.widgetWithText(
        SecondaryButton,
        AppStrings.trainNextActionFamily,
      );
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(find.byType(PracticeLauncherScreen), findsOneWidget);
    });

    testWidgets('a family chip opens its score-over-time page in the tab', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await seedThreeFamilies();
      final appContainer = await pumpTheApp(tester);

      // One chip per practised family, labelled for screen readers.
      expect(find.byType(FamilyChip), findsNWidgets(3));
      expect(find.text(AppStrings.familyDetailsHint), findsOneWidget);
      final chip = find.bySemanticsLabel(
        AppStrings.familyTrendOpenSemantics('Dominos'),
      );
      expect(chip, findsOneWidget);
      await tester.tap(chip);
      await tester.pumpAndSettle();

      expect(find.byType(FamilyTrendScreen), findsOneWidget);
      expect(
        appContainer.read(appRouterProvider).state.uri.toString(),
        AppRoutes.progressFamily('logic_dominos'),
      );
      // Pushed inside the Progress tab: the dashboard stays below.
      expect(find.byType(ProgressScreen, skipOffstage: false), findsOneWidget);
      expect(find.text('Dominos'), findsOneWidget);
      expect(find.byType(LineChart), findsNWidgets(2));
      handle.dispose();
    });

    testWidgets('the exam chart appears once a simulation is completed', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 2400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await seedThreeFamilies();
      final appContainer = await pumpTheApp(tester);
      expect(find.byType(ExamScoreChart), findsNothing);
      expect(find.text(AppStrings.examChartTitle), findsNothing);

      await fixture.exam(daysAgo: 0, correct: 6);
      appContainer.read(progressVersionProvider.notifier).bump();
      await tester.pumpAndSettle();
      expect(find.byType(ExamScoreChart), findsOneWidget);
      expect(find.text(AppStrings.examChartTitle), findsOneWidget);
    });
  });
}
