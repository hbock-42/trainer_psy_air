import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/fake_engine.dart';
import '../../../../helpers/fake_renderer.dart';
import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    int items = 2,
    TimingPolicy timing = TimingPolicy.none,
    LocalizedText? title,
    LocalizedText? briefing,
  }) => ActivitySessionConfig(
    familyId: 'fake_family',
    mode: mode,
    source: ItemSource.bank(fakeBank(items)),
    timing: timing,
    title: title,
    briefing: briefing,
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionRequest request, {
    FakeRenderer renderer = const FakeRenderer(),
  }) => pumpApp(
    tester,
    SessionHost(request: request, onFinished: finished.add),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(EngineRegistry([FakeEngine()])),
      rendererRegistryProvider.overrideWithValue(RendererRegistry([renderer])),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  testWidgets('briefing shows the title, count, placeholder and Start', (
    tester,
  ) async {
    await pumpHost(
      tester,
      ActivitySessionRequest.fresh(
        config(
          title: const LocalizedText(fr: 'Dominos'),
          briefing: const LocalizedText(fr: 'Trouvez le domino manquant.'),
        ),
      ),
    );
    expect(find.text('Dominos'), findsOneWidget);
    expect(find.text('Trouvez le domino manquant.'), findsOneWidget);
    expect(find.text(l10nFr.sessionItemCount(2)), findsOneWidget);
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsOneWidget);
    expect(find.byKey(SessionHost.startKey), findsOneWidget);
    expect(find.byType(ProgressDots), findsNothing);
    expect(repo.sessionsById, isEmpty);
  });

  testWidgets('briefing falls back to the family id and default text', (
    tester,
  ) async {
    await pumpHost(
      tester,
      ActivitySessionRequest.fresh(config()),
      renderer: const FakeRenderer(withExample: true),
    );
    expect(find.text('fake_family'), findsOneWidget);
    expect(find.text(l10nFr.sessionBriefingDefault), findsOneWidget);
    expect(find.byKey(FakeRenderer.exampleKey), findsOneWidget);
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
  });

  testWidgets('a practice session runs through feedback to the end', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.text('Question 1'), findsOneWidget);
    expect(find.text('phase:answer'), findsOneWidget);
    expect(find.byType(ProgressDots), findsOneWidget);
    expect(find.byKey(SessionHost.pauseKey), findsOneWidget);
    expect(find.byKey(SessionHost.quitKey), findsOneWidget);
    expect(find.byKey(SessionHost.nextKey), findsNothing);
    expect(find.byType(CountdownTimerBar), findsNothing);

    await tester.tap(find.byKey(FakeRenderer.optionKey(0)));
    await tester.pump();
    expect(find.text('phase:answered'), findsOneWidget);
    expect(find.text('feedback:true'), findsOneWidget);
    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    expect(find.byKey(SessionHost.nextKey), findsOneWidget);

    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
    expect(find.text('Question 2'), findsOneWidget);
    await tester.tap(find.byKey(FakeRenderer.optionKey(2)));
    await tester.pump();
    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
    expect(finished, hasLength(1));
    expect(finished.single.reason, FinishReason.completed);
    expect(finished.single.section.correct, 1);
    await tester.pump();
    expect(repo.attempts, hasLength(2));
    expect(repo.sessionsById.values.single.status, SessionStatus.completed);
  });

  testWidgets('an exam session is silent, timed and cannot pause', (
    tester,
  ) async {
    await pumpHost(
      tester,
      ActivitySessionRequest.fresh(
        config(
          mode: SessionMode.exam,
          timing: const TimingPolicy(perItemMs: 10000, sectionMs: 60000),
        ),
      ),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.byKey(SessionHost.pauseKey), findsNothing);
    expect(find.byKey(SessionHost.itemTimerKey), findsOneWidget);
    expect(find.byKey(SessionHost.sectionTimerKey), findsOneWidget);

    // The bars follow the engine clock.
    clock.elapse(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 100));
    final bar = tester.widget<CountdownTimerBar>(
      find.byKey(SessionHost.itemTimerKey),
    );
    expect(bar.remaining, const Duration(seconds: 6));
    expect(bar.total, const Duration(seconds: 10));

    await tester.tap(find.byKey(FakeRenderer.optionKey(1)));
    await tester.pump();
    // No feedback: straight to the next item.
    expect(find.text('Question 2'), findsOneWidget);
    expect(find.byKey(SessionHost.feedbackKey), findsNothing);
    expect(find.text('feedback:null'), findsOneWidget);

    clock.elapse(const Duration(seconds: 10));
    await tester.pump();
    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
    expect(finished.single.section.timeouts, 1);
  });

  testWidgets('pause hides the item and resume brings it back', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await tester.tap(find.byKey(SessionHost.pauseKey));
    await tester.pump();
    expect(find.text(l10nFr.sessionPausedTitle), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
    await tester.tap(find.byKey(SessionHost.resumeKey));
    await tester.pump();
    expect(find.text('Question 1'), findsOneWidget);
  });

  testWidgets('quit aborts the session', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(config()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    await tester.tap(find.byKey(SessionHost.quitKey));
    await tester.pump();
    expect(finished.single.reason, FinishReason.aborted);
    await tester.pump();
    expect(repo.sessionsById.values.single.status, SessionStatus.abandoned);
  });

  testWidgets('a resume request shows where it picks up', (tester) async {
    final session = await repo.startSession(
      mode: SessionMode.practice,
      familyId: 'fake_family',
      config: config(items: 3).toJson(),
    );
    await repo.recordAttempt(
      NewAttempt(
        sessionId: session.id,
        familyId: 'fake_family',
        isCorrect: true,
        responseMs: 800,
        position: 0,
        itemId: 'q1',
        answer: const Answer.choice(0).toJson(),
      ),
    );
    await pumpHost(
      tester,
      ActivitySessionRequest.resume(
        session: session,
        attempts: await repo.attemptsForSession(session.id),
      ),
    );
    expect(find.text(l10nFr.sessionResumeHint(2, 3)), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.text('Question 2'), findsOneWidget);
    expect(repo.sessionsById, hasLength(1));
  });

  testWidgets('a cadence item shows the stimulus phase then the answer phase', (
    tester,
  ) async {
    await pumpHost(
      tester,
      ActivitySessionRequest.fresh(
        config(
          mode: SessionMode.exam,
          timing: const TimingPolicy(
            cadence: Cadence(stimulusMs: 500, answerWindowMs: 1000),
          ),
        ),
      ),
    );
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
    expect(find.text('phase:stimulus'), findsOneWidget);
    clock.elapse(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('phase:answer'), findsOneWidget);
    // Cadence bars have no label.
    final bar = tester.widget<CountdownTimerBar>(
      find.byKey(SessionHost.itemTimerKey),
    );
    expect(bar.showLabel, isFalse);
  });

  testWidgets(
    'an adaptive source shows a discreet level indicator that moves after '
    '3 consecutive correct-and-fast answers (US-053)',
    (tester) async {
      const adaptive = ActivitySessionConfig(
        familyId: 'fake_family',
        mode: SessionMode.practice,
        source: ItemSource.adaptive(
          generatorId: GeneratorId.dominos,
          runSeed: 42,
          params: GeneratorParams.dominos(),
          count: 6,
          initialDifficulty: 2,
          fastThresholdMs: 60000,
        ),
      );
      await pumpHost(tester, const ActivitySessionRequest.fresh(adaptive));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(l10nFr.practiceDifficultyLevel(2)), findsOneWidget);
      expect(find.text(l10nFr.practiceDifficultyLevel(3)), findsNothing);

      for (var i = 0; i < 3; i++) {
        await tester.tap(find.byKey(FakeRenderer.optionKey(0)));
        await tester.pump();
        await tester.tap(find.byKey(SessionHost.nextKey));
        await tester.pumpAndSettle();
      }

      expect(find.text(l10nFr.practiceDifficultyLevel(3)), findsOneWidget);
      expect(find.text(l10nFr.practiceDifficultyLevel(2)), findsNothing);
    },
  );
}
