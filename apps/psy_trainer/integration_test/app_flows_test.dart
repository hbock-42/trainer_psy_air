import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/app_database_provider.dart';
import 'package:psy_trainer/core/db/open_database.dart';
import 'package:psy_trainer/core/db/seed/content_ready_provider.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/presentation/arithmetic_grid_renderer.dart';
import 'package:psy_trainer/features/exam/presentation/exam_run_controller.dart';
import 'package:psy_trainer/features/exam/presentation/exam_run_screen.dart';
import 'package:psy_trainer/features/exam/presentation/exam_run_state.dart';
import 'package:psy_trainer/features/exam/presentation/exam_screen.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_report_provider.dart';
import 'package:psy_trainer/features/learn/presentation/family_screen.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/learn/presentation/lesson_screen.dart';
import 'package:psy_trainer/features/learn/presentation/providers/family_lessons_provider.dart';
import 'package:psy_trainer/features/learn/presentation/providers/psy0_families_provider.dart';
import 'package:psy_trainer/features/learn/presentation/widgets/family_card.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/accept_toggle.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_snapshot_provider.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/summary/session_summary_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../test/helpers/file_asset_reader.dart';

// US-121: one end-to-end pass over the real seeded content (real
// `contentReadyProvider` seeding the bundle on disk into an in-memory Drift
// database, via `FileAssetReader`) and the real engines (no fakes): fresh
// install -> onboarding -> Learn (families, a lesson marked read) -> Train
// (Quick 5 on `arithmetic_grid`, answered through its real grid UI) -> Exam
// (the `psy0_short` blueprint, every section run through `ManualClock` so
// cadences and countdowns resolve instantly) -> its report -> the Progress
// dashboard -> Settings (switch to English).
//
// Deliberately asserts on structure (family/section counts read back from
// the seeded content, not hard-coded numbers) rather than on exact content,
// so a future content edit does not make this test flaky.
//
// Runs headlessly:
// - locally, `flutter test integration_test` (flutter_tester, no device, no
//   window) -- see `make integration`;
// - in CI, the `integration` job (`.github/workflows/ci.yml`) runs the same
//   command on `ubuntu-latest`. `IntegrationTestWidgetsFlutterBinding` works
//   the same without a device for a widgets-only app like this one (no
//   platform channel beyond the asset bundle, which `FileAssetReader`
//   bypasses here anyway); driving a real Linux/Chrome device added little
//   beyond the same assertions for a much heavier, more brittle CI job.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final l10nFr = lookupAppLocalizations(const Locale('fr'));
  final l10nEn = lookupAppLocalizations(const Locale('en'));

  testWidgets('fresh install: onboarding, a lesson, a practice drill, an exam '
      'simulation, the dashboard and a language switch', (tester) async {
    // A phone-sized surface: deterministic layout (bottom tab bar, one
    // family-card column) whatever the host screen. Wider than the 390 px
    // golden surface (`test/helpers/golden_config.dart`): at 390 the real
    // (non-fixture) family/blueprint names overflow a couple of rows by a
    // few pixels, which is a real, pre-existing layout issue (out of scope
    // for this story) rather than anything this test does.
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    // The engine clock, shared by every activity this test runs: elapsed
    // by hand so cadences, per-item limits and section timeouts resolve
    // without the test waiting on real timers.
    final clock = ManualClock(DateTime.utc(2026, 9, 12, 8));

    // A fresh, private in-memory database (US-013's Drift mirror), seeded
    // from the real `assets/content/` bundle on disk (`FileAssetReader`,
    // not `rootBundle`: see `test/helpers/file_asset_reader.dart`) rather
    // than from any in-memory content fixture. Repositories are left at
    // their real (`LocalContentRepository`/`LocalProgressRepository`)
    // bindings.
    final db = AppDatabase(openInMemoryExecutor());
    addTearDown(db.close);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        assetReaderProvider.overrideWithValue(FileAssetReader()),
        engineClockProvider.overrideWithValue(clock),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PsyTrainerApp(),
      ),
    );
    // Real seeding (file reads + a database transaction): let it settle
    // rather than pump a fixed number of frames.
    await tester.pumpAndSettle();

    // ---- Onboarding: accept, skip the exam date, keep PSY0 -------------

    expect(find.text(l10nFr.onboardingWelcomeHeadline), findsOneWidget);
    await tester.ensureVisible(find.byType(AcceptToggle));
    await tester.tap(find.byType(AcceptToggle));
    await tester.pump();
    await tester.ensureVisible(find.text(l10nFr.actionContinue));
    await tester.tap(find.text(l10nFr.actionContinue));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l10nFr.onboardingExamDateUnknown));
    await tester.pumpAndSettle();

    // PSY0 is already selected and available by default.
    await tester.tap(find.text(l10nFr.actionFinish));
    await tester.pumpAndSettle();

    expect(find.byType(LearnScreen), findsOneWidget);

    // ---- Learn: every seeded PSY0 family, a lesson marked read ---------

    final families = await container.read(psy0FamiliesProvider.future);
    expect(families, isNotEmpty);
    expect(find.byType(FamilyCard), findsNWidgets(families.length));

    final memoryCard = find.byKey(const ValueKey('family-card-memory_nback'));
    await tester.scrollUntilVisible(memoryCard, 300);
    await tester.tap(
      find
          .descendant(of: memoryCard, matching: find.byType(AppPressable))
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.byType(FamilyScreen), findsOneWidget);

    final lessons = await container.read(
      familyLessonsProvider('memory_nback').future,
    );
    expect(lessons, isNotEmpty);
    final firstLessonTitle = lessons.first.title.resolve('fr');
    await tester.tap(find.text(firstLessonTitle));
    await tester.pumpAndSettle();
    expect(find.byType(LessonScreen), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(l10nFr.lessonMarkRead));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel(l10nFr.lessonMarkedRead), findsWidgets);

    // ---- Train: Quick 5 on arithmetic_grid, answered on the grid -------

    await tester.tap(find.text(l10nFr.tabTrain));
    await tester.pumpAndSettle();
    expect(find.byType(TrainScreen), findsOneWidget);

    final arithmeticFamily =
        (await container
                .read(contentRepositoryProvider)
                .families(moduleId: ModuleId.psy0))
            .firstWhere((f) => f.id == 'arithmetic_grid');
    final arithmeticTile = find
        .ancestor(
          of: find.text(arithmeticFamily.name.resolve('fr')),
          matching: find.byType(AppCard),
        )
        .first;
    await tester.scrollUntilVisible(arithmeticTile, 300);
    await tester.tap(
      find.descendant(
        of: arithmeticTile,
        matching: find.text(l10nFr.trainQuick5Label),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      expect(find.byKey(ArithmeticGridRenderer.validateKey), findsOneWidget);
      await tester.tap(find.byKey(ArithmeticGridRenderer.validateKey));
      await tester.pump();
      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
    }
    expect(find.byType(SessionSummaryScreen), findsOneWidget);
    for (var i = 0; i < 5; i++) {
      expect(find.byKey(SessionSummaryScreen.itemKey(i)), findsOneWidget);
    }
    expect(find.byKey(SessionSummaryScreen.itemKey(5)), findsNothing);

    await tester.ensureVisible(find.byKey(SessionSummaryScreen.backKey));
    await tester.tap(find.byKey(SessionSummaryScreen.backKey));
    await tester.pumpAndSettle();

    // ---- Exam: the short PSY0 blueprint end to end ----------------------

    await tester.tap(find.text(l10nFr.tabExam));
    await tester.pumpAndSettle();
    expect(find.byType(ExamScreen), findsOneWidget);

    const blueprintId = 'psy0.blueprint.short';
    const examStartKey = Key('exam_home.start.$blueprintId');
    await tester.scrollUntilVisible(find.byKey(examStartKey), 300);
    await tester.tap(find.byKey(examStartKey));
    await tester.pumpAndSettle();
    expect(find.byType(ExamRunScreen), findsOneWidget);

    final sessionId = await _runExamToCompletion(
      tester,
      container,
      blueprintId,
      clock,
    );
    await tester.pumpAndSettle();

    final report = await container.read(examReportProvider(sessionId).future);
    expect(report, isNotNull);
    expect(report!.summary.sections, isNotEmpty);
    expect(find.text(l10nFr.examReportSectionsTitle), findsOneWidget);

    // ---- Progress: readiness above zero, recent activity recorded ------

    await tester.tap(find.text(l10nFr.tabProgress));
    await tester.pumpAndSettle();

    final snapshot = await container.read(progressSnapshotProvider.future);
    expect(snapshot.readiness.value, greaterThan(0));
    expect(snapshot.exams, isNotEmpty);
    expect(find.text(l10nFr.recentActivityNone), findsNothing);

    // ---- Settings: switch to English, a label changes ------------------

    await tester.tap(find.text(l10nFr.tabSettings));
    await tester.pumpAndSettle();
    expect(find.text(l10nFr.settingsSectionAppearance), findsOneWidget);

    await tester.tap(find.text(l10nFr.settingsLanguageEn));
    await tester.pumpAndSettle();

    expect(find.text(l10nEn.settingsSectionAppearance), findsOneWidget);
    expect(find.text(l10nFr.settingsSectionAppearance), findsNothing);
    expect(find.byType(SettingsScreen), findsOneWidget);
  }, timeout: const Timeout(Duration(minutes: 5)));
}

/// Drives the exam runner to completion without knowing anything about the
/// families involved: taps "Start" on every section's briefing, taps "Next"
/// when an item's feedback is waiting for it (a live-feedback section whose
/// per-item limit expired), and otherwise elapses [clock] so cadences,
/// per-item limits and section timeouts resolve on their own. Returns the
/// finished session id.
Future<String> _runExamToCompletion(
  WidgetTester tester,
  ProviderContainer container,
  String blueprintId,
  ManualClock clock,
) async {
  final provider = examRunControllerProvider(blueprintId);
  for (var i = 0; i < 1000; i++) {
    final state = container.read(provider);
    switch (state) {
      case ExamRunDone(:final sessionId):
        return sessionId;
      case ExamRunAborted() || ExamRunUnavailable() || ExamRunError():
        fail('exam run ended unexpectedly: $state');
      default:
        break;
    }
    if (find.byKey(SessionHost.startKey).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();
    } else if (find.byKey(SessionHost.nextKey).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
    } else if (find.byKey(ExamRunScreen.skipBreakKey).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(ExamRunScreen.skipBreakKey));
      await tester.pump();
    } else {
      clock.elapse(const Duration(seconds: 5));
      await tester.pump();
    }
  }
  fail('exam run did not finish within the step budget');
}
