import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/psy2/domain/interview_rubric.dart';
import 'package:psy_trainer/features/psy2/domain/psy2_sessions.dart';
import 'package:psy_trainer/features/psy2/presentation/interview_screen.dart';
import 'package:psy_trainer/features/psy2/presentation/providers/psy2_clock_provider.dart';
import 'package:psy_trainer/features/train/domain/engine/engine_clock.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/psy2_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late ManualClock clock;
  late InMemoryProgressRepository progress;

  setUp(() {
    clock = ManualClock(DateTime.utc(2026, 9, 13, 9));
    progress = InMemoryProgressRepository(clock: clock.now);
  });

  Future<void> pumpInterview(WidgetTester tester) => pumpApp(
    tester,
    const InterviewScreen(),
    overrides: [
      contentRepositoryProvider.overrideWithValue(psy2ContentRepository()),
      progressRepositoryProvider.overrideWithValue(progress),
      psy2ClockProvider.overrideWithValue(clock),
    ],
  );

  testWidgets('theme picker lists every theme and starts the prep timer', (
    tester,
  ) async {
    await pumpInterview(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('interview.theme_picker')), findsOneWidget);

    final startButton = find.byType(PrimaryButton);
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pump();

    expect(find.byKey(const Key('interview.timer')), findsOneWidget);
    expect(
      find.text(CountdownTimerBar.format(InterviewScreen.prepDuration)),
      findsOneWidget,
    );
  });

  testWidgets('the prep countdown auto-advances to the answer countdown '
      '(ManualClock)', (tester) async {
    await pumpInterview(tester);
    await tester.pumpAndSettle();
    final startButton = find.byType(PrimaryButton);
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pump();

    // Elapse the whole prep duration; the 100ms ticker (a real Timer,
    // advanced by `tester.pump`) notices the clock is past `_phaseEndsAt`
    // and flips to the answer phase on its own.
    clock.elapse(InterviewScreen.prepDuration);
    await tester.pump(const Duration(milliseconds: 100));

    expect(
      find.text(CountdownTimerBar.format(InterviewScreen.answerDuration)),
      findsOneWidget,
    );
  });

  testWidgets('finishing the answer, then saving the rubric persists a '
      'psy2_interview session', (tester) async {
    await pumpInterview(tester);
    await tester.pumpAndSettle();
    final startButton = find.byType(PrimaryButton);
    await tester.ensureVisible(startButton);
    await tester.tap(startButton);
    await tester.pump();

    // Skip straight to answering, then finish it.
    final skipButton = find.byKey(const Key('interview.skip'));
    await tester.ensureVisible(skipButton);
    await tester.tap(skipButton);
    await tester.pump();
    await tester.ensureVisible(skipButton);
    await tester.tap(skipButton);
    await tester.pump();

    final saveButton = find.byKey(const Key('interview.save'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final sessions = await progress.sessions(
      familyId: Psy2SessionFamily.interview,
    );
    expect(sessions, hasLength(1));
    final session = sessions.single;
    expect(session.mode, SessionMode.practice);
    expect(session.status, SessionStatus.completed);
    expect(session.config['questionId'], isNotNull);
    final scores = interviewRubricScoresFromJson(session.config['scores']);
    expect(scores.values, everyElement(interviewRubricDefaultScore));
    expect(
      session.score,
      interviewRubricDefaultScore / interviewRubricMaxScore,
    );
  });
}
