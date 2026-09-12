import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/summary/session_summary_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/fake_engine.dart';
import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  ItemOutcome outcome({
    required int index,
    required String stem,
    required bool correct,
    required int responseMs,
    int answerIndex = 0,
  }) => ItemOutcome(
    index: index,
    item: fakeMcq(id: 'q$index', stem: stem),
    answer: Answer.choice(answerIndex),
    result: correct ? ItemResult.right : ItemResult.wrong,
    responseMs: responseMs,
  );

  SessionResult resultOf(List<ItemOutcome> outcomes) => SessionResult(
    mode: SessionMode.practice,
    familyId: 'fake_family',
    reason: FinishReason.completed,
    outcomes: outcomes,
    section: Scorer.section(outcomes, itemCount: outcomes.length),
    sessionId: 'session-1',
  );

  const config = ActivitySessionConfig(
    familyId: 'fake_family',
    mode: SessionMode.practice,
    source: ItemSource.bank([]),
    title: LocalizedText(fr: 'Activité'),
  );

  testWidgets('shows score, accuracy, mean/median RT, timeouts', (
    tester,
  ) async {
    final outcomes = [
      outcome(index: 0, stem: 'Question 1', correct: true, responseMs: 100),
      outcome(
        index: 1,
        stem: 'Question 2',
        correct: false,
        responseMs: 1500,
        answerIndex: 2,
      ),
      outcome(index: 2, stem: 'Question 3', correct: true, responseMs: 200),
    ];

    await pumpApp(
      tester,
      SessionSummaryScreen(
        result: resultOf(outcomes),
        config: config,
        onRestart: () {},
        onBack: () {},
      ),
    );

    expect(find.text(l10nFr.summaryScoreFraction(2, 3)), findsOneWidget);
    expect(find.text('67 %'), findsOneWidget);
    expect(find.text('0.6 s'), findsOneWidget); // mean (100+1500+200)/3=600
    expect(find.text('0.2 s'), findsOneWidget); // median of [100,200,1500]
    expect(find.text('0'), findsOneWidget); // timeouts
    // Fastest correct (index 0) and the wrong one (index 1) are called out.
    expect(find.text(l10nFr.summaryBestItemLabel(1)), findsOneWidget);
    expect(find.text(l10nFr.summaryWorstItemLabel(2)), findsOneWidget);
  });

  testWidgets('tapping a wrong item reviews stem, my answer and expected', (
    tester,
  ) async {
    final outcomes = [
      outcome(
        index: 0,
        stem: 'Question 1',
        correct: false,
        responseMs: 900,
        answerIndex: 1,
      ),
    ];

    await pumpApp(
      tester,
      SessionSummaryScreen(
        result: resultOf(outcomes),
        config: config,
        onRestart: () {},
        onBack: () {},
      ),
    );

    await tester.tap(find.byKey(SessionSummaryScreen.itemKey(0)));
    await tester.pump();

    expect(find.text(l10nFr.summaryReviewMyAnswer), findsOneWidget);
    expect(find.text('B'), findsOneWidget); // chosen
    expect(find.text(l10nFr.summaryReviewExpected), findsOneWidget);
    expect(find.text('A'), findsOneWidget); // correct option
    expect(find.text('Parce que.'), findsOneWidget); // explanation
  });

  testWidgets('retry mistakes is disabled when nothing to retry', (
    tester,
  ) async {
    final outcomes = [
      outcome(index: 0, stem: 'Question 1', correct: true, responseMs: 500),
    ];

    await pumpApp(
      tester,
      SessionSummaryScreen(
        result: resultOf(outcomes),
        config: config,
        onRestart: () {},
        onBack: () {},
        // No wrong answers: the caller passes no callback.
      ),
    );

    final button = tester.widget<SecondaryButton>(
      find.byKey(SessionSummaryScreen.retryMistakesKey),
    );
    expect(button.onPressed, isNull);
  });
}
