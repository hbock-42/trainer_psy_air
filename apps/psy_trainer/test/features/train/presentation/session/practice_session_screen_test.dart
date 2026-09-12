import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/session/practice_session_screen.dart';
import 'package:psy_trainer/features/train/presentation/summary/session_summary_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/fake_engine.dart';
import '../../../../helpers/fake_renderer.dart';
import '../../../../helpers/pump_app.dart';

void main() {
  final start = DateTime.utc(2026, 9, 12, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
  });

  ActivitySessionConfig config({int items = 3}) => ActivitySessionConfig(
    familyId: 'fake_family',
    mode: SessionMode.practice,
    source: ItemSource.bank(fakeBank(items)),
    title: const LocalizedText(fr: 'Activité'),
  );

  Future<void> pumpScreen(
    WidgetTester tester,
    ActivitySessionRequest request,
  ) => pumpApp(
    tester,
    PracticeSessionScreen(request: request),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      contentRepositoryProvider.overrideWithValue(
        InMemoryContentRepository(items: fakeBank(3)),
      ),
      engineRegistryProvider.overrideWithValue(EngineRegistry([FakeEngine()])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([const FakeRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  Future<void> answer(WidgetTester tester, int optionIndex) async {
    await tester.tap(find.byKey(FakeRenderer.optionKey(optionIndex)));
    await tester.pump();
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
  }

  testWidgets('a full 3-item session runs through feedback to the summary', (
    tester,
  ) async {
    await pumpScreen(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.text('Question 1'), findsOneWidget);
    await answer(tester, 0); // correct
    expect(find.text('Question 2'), findsOneWidget);
    await answer(tester, 2); // wrong
    expect(find.text('Question 3'), findsOneWidget);
    await answer(tester, 0); // correct
    await tester.pump();

    // Landed on the summary (US-052), the session runner gone.
    expect(find.byType(SessionHost), findsNothing);
    expect(find.text(AppStrings.summaryTitle), findsOneWidget);
    expect(find.text(AppStrings.summaryScoreFraction(2, 3)), findsOneWidget);
    await tester.pump();
    expect(repo.sessionsById.values.single.status, SessionStatus.completed);

    // The wrong item (index 1) reviews as text: stem, my answer, expected.
    await tester.tap(find.byKey(SessionSummaryScreen.itemKey(1)));
    await tester.pump();
    expect(find.text('Question 2'), findsWidgets);
    expect(find.text(AppStrings.summaryReviewMyAnswer), findsOneWidget);
    expect(find.text('C'), findsOneWidget); // my (wrong) answer
    expect(find.text('A'), findsOneWidget); // expected
    expect(find.text('Parce que.'), findsOneWidget); // explanation
  });

  testWidgets('Esc pauses a running session', (tester) async {
    await pumpScreen(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.text('Question 1'), findsOneWidget);

    await simulateKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.pump();

    expect(find.text(AppStrings.sessionPausedTitle), findsOneWidget);
  });

  testWidgets(
    'quitting from the top bar asks for confirmation before aborting',
    (tester) async {
      await pumpScreen(tester, ActivitySessionRequest.fresh(config()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      await tester.tap(find.byType(AppIconButton));
      await tester.pump();
      expect(find.text(AppStrings.sessionQuitConfirmTitle), findsOneWidget);

      // Cancel: the session keeps running.
      await tester.tap(find.byKey(PracticeSessionScreen.quitCancelKey));
      await tester.pump();
      expect(find.text(AppStrings.sessionQuitConfirmTitle), findsNothing);
      expect(find.text('Question 1'), findsOneWidget);

      await tester.tap(find.byType(AppIconButton));
      await tester.pump();
      await tester.tap(find.byKey(PracticeSessionScreen.quitConfirmKey));
      await tester.pump();
      await tester.pump();

      expect(find.text(AppStrings.summaryTitle), findsOneWidget);
      expect(repo.sessionsById.values.single.status, SessionStatus.abandoned);
    },
  );

  testWidgets('Recommencer starts a fresh request with the same config', (
    tester,
  ) async {
    await pumpScreen(tester, ActivitySessionRequest.fresh(config(items: 1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await tester.tap(find.byKey(FakeRenderer.optionKey(0)));
    await tester.pump();
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
    expect(find.text(AppStrings.summaryTitle), findsOneWidget);

    await tester.tap(find.byKey(SessionSummaryScreen.restartKey));
    await tester.pump();
    expect(find.byType(SessionHost), findsOneWidget);
    expect(find.byKey(SessionHost.startKey), findsOneWidget);
  });

  testWidgets(
    '"Refaire les erreurs" starts a fresh session over the wrong items only',
    (tester) async {
      await pumpScreen(tester, ActivitySessionRequest.fresh(config()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();
      await answer(tester, 0); // q1: correct
      await answer(tester, 2); // q2: wrong
      await answer(tester, 2); // q3: wrong
      await tester.pump();
      expect(find.text(AppStrings.summaryTitle), findsOneWidget);

      await tester.ensureVisible(
        find.byKey(SessionSummaryScreen.retryMistakesKey),
      );
      await tester.tap(find.byKey(SessionSummaryScreen.retryMistakesKey));
      await tester.pump();

      expect(find.byType(SessionHost), findsOneWidget);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();
      // Only the two wrong items (q2, q3) are played, not q1.
      expect(find.text('Question 2'), findsOneWidget);
      await answer(tester, 0);
      expect(find.text('Question 3'), findsOneWidget);
      await answer(tester, 0);
      await tester.pump();
      expect(find.text(AppStrings.summaryScoreFraction(2, 2)), findsOneWidget);
    },
  );
}
