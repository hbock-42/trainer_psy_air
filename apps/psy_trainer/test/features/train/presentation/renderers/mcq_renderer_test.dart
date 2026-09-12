import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/features/train/presentation/renderers/mcq_renderer.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../../helpers/pump_app.dart';

/// A minimal bank-only engine (US-021/022 renderers do not register in the
/// runtime's registries; US-027/028 will). The default `Scorer.scoreItem`
/// handles `McqItem` / `NumericItem` on its own.
class _BankEngine extends ActivityEngine {
  _BankEngine({this.familyId = 'mcq_family'});

  @override
  final String familyId;
}

McqItem _mcq({
  String id = 'q1',
  String stem = 'Question 1',
  List<String> options = const ['A', 'B', 'C'],
  int correctIndex = 0,
  bool allowSkip = false,
  String? passageId,
  MediaRef? media,
}) => McqItem(
  id: id,
  version: 1,
  familyId: 'mcq_family',
  difficulty: 3,
  tags: const ['test'],
  stem: LocalizedText(fr: stem),
  options: [for (final o in options) McqOption(text: LocalizedText(fr: o))],
  correctIndex: correctIndex,
  explanation: const LocalizedText(fr: 'Parce que voilà.'),
  allowSkip: allowSkip,
  passageId: passageId,
  media: media,
);

void main() {
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(DateTime.utc(2026, 9, 5, 9));
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config({
    required List<Item> items,
    SessionMode mode = SessionMode.practice,
    bool liveFeedback = false,
  }) => ActivitySessionConfig(
    familyId: 'mcq_family',
    mode: mode,
    source: ItemSource.bank(items),
    timing: TimingPolicy.none,
    liveFeedback: liveFeedback,
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig config, {
    PassageResolver? passageResolver,
    double textScale = 1.0,
  }) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config),
      onFinished: finished.add,
    ),
    textScale: textScale,
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry([_BankEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry([
          McqRenderer(
            familyId: 'mcq_family',
            passageResolver: passageResolver,
          ),
        ]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  Future<void> start(WidgetTester tester) async {
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();
  }

  testWidgets('briefing example shows a static illustrative question', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [_mcq()]));
    expect(find.text(AppStrings.mcqExampleStem), findsOneWidget);
    expect(find.text(AppStrings.mcqExampleOptionCorrect), findsOneWidget);
  });

  testWidgets('practice: tapping an option answers immediately and shows '
      'correct feedback plus the explanation', (tester) async {
    await pumpHost(tester, config(items: [_mcq(stem: 'Question 1')]));
    await start(tester);

    expect(find.text('Question 1', findRichText: true), findsOneWidget);
    expect(find.text('A'), findsOneWidget);
    expect(find.byKey(const ValueKey('mcq_validate')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('mcq_option_0')));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
    expect(
      find.text('Parce que voilà.', findRichText: true),
      findsOneWidget,
    );
    final tile = tester.widget<AnswerOptionTile>(
      find.byKey(const ValueKey('mcq_option_0')),
    );
    expect(tile.state, AnswerOptionState.correct);
    expect(find.byKey(SessionHost.nextKey), findsOneWidget);
  });

  testWidgets('practice: a wrong pick highlights both the pick and the '
      'correct option', (tester) async {
    await pumpHost(tester, config(items: [_mcq(correctIndex: 2)]));
    await start(tester);

    await tester.tap(find.byKey(const ValueKey('mcq_option_0')));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
    expect(
      tester
          .widget<AnswerOptionTile>(
            find.byKey(const ValueKey('mcq_option_0')),
          )
          .state,
      AnswerOptionState.wrong,
    );
    expect(
      tester
          .widget<AnswerOptionTile>(
            find.byKey(const ValueKey('mcq_option_2')),
          )
          .state,
      AnswerOptionState.correct,
    );
  });

  testWidgets('exam: tapping only selects, Valider submits, no feedback '
      'shown', (tester) async {
    await pumpHost(
      tester,
      config(items: [_mcq(), _mcq(id: 'q2')], mode: SessionMode.exam),
    );
    await start(tester);

    expect(find.byKey(const ValueKey('mcq_validate')), findsOneWidget);
    var validate = tester.widget<PrimaryButton>(
      find.byKey(const ValueKey('mcq_validate')),
    );
    expect(validate.onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey('mcq_option_1')));
    await tester.pump();
    expect(
      tester
          .widget<AnswerOptionTile>(
            find.byKey(const ValueKey('mcq_option_1')),
          )
          .state,
      AnswerOptionState.selected,
    );
    // No answer sent yet: still on the same item.
    expect(find.byKey(SessionHost.feedbackKey), findsNothing);

    validate = tester.widget<PrimaryButton>(
      find.byKey(const ValueKey('mcq_validate')),
    );
    expect(validate.onPressed, isNotNull);
    await tester.tap(find.byKey(const ValueKey('mcq_validate')));
    await tester.pump();

    // Silent exam: straight to the next item, no feedback panel.
    expect(find.byKey(SessionHost.feedbackKey), findsNothing);
    await tester.pump();
    expect(repo.attempts, hasLength(1));
  });

  testWidgets('allowSkip renders a skip option that sends SkipAnswer', (
    tester,
  ) async {
    await pumpHost(tester, config(items: [_mcq(allowSkip: true)]));
    await start(tester);

    expect(find.text(AppStrings.mcqSkipOption), findsOneWidget);
    await tester.tap(find.text(AppStrings.mcqSkipOption));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackSkipped), findsOneWidget);
  });

  testWidgets('keyboard: digit 1 answers in practice, digit + Enter '
      'validates in exam', (tester) async {
    await pumpHost(tester, config(items: [_mcq()]));
    await start(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pump();
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('keyboard: exam mode selects with a digit then Enter '
      'validates', (tester) async {
    await pumpHost(
      tester,
      config(items: [_mcq(correctIndex: 1)], mode: SessionMode.exam),
    );
    await start(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pump();
    expect(
      tester
          .widget<AnswerOptionTile>(
            find.byKey(const ValueKey('mcq_option_1')),
          )
          .state,
      AnswerOptionState.selected,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.pump();
    expect(repo.attempts, hasLength(1));
    expect(repo.attempts.single.isCorrect, isTrue);
  });

  testWidgets('a passage panel shows the resolved passage and can collapse', (
    tester,
  ) async {
    const passage = Passage(
      id: 'p1',
      title: LocalizedText(fr: 'Un texte'),
      body: LocalizedText(fr: 'Corps du texte de référence.'),
    );
    await pumpHost(
      tester,
      config(items: [_mcq(passageId: 'p1')]),
      passageResolver: (id) => id == 'p1' ? passage : null,
    );
    await start(tester);

    expect(find.text('Un texte'), findsOneWidget);
    expect(
      find.text('Corps du texte de référence.', findRichText: true),
      findsOneWidget,
    );

    await tester.tap(find.text(AppStrings.mcqPassageHide));
    await tester.pump();
    expect(
      find.text('Corps du texte de référence.', findRichText: true),
      findsNothing,
    );
    expect(find.text(AppStrings.mcqPassageShow), findsOneWidget);
  });

  testWidgets('no passage panel is shown when the resolver has none', (
    tester,
  ) async {
    await pumpHost(
      tester,
      config(items: [_mcq(passageId: 'missing')]),
      passageResolver: (_) => null,
    );
    await start(tester);
    expect(find.text('Question 1', findRichText: true), findsOneWidget);
    expect(find.byType(SecondaryButton), findsNothing);
  });

  testWidgets('survives a 1.3x text scale without overflow', (tester) async {
    await pumpHost(
      tester,
      config(items: [_mcq(allowSkip: true)]),
      textScale: 1.3,
    );
    await start(tester);
    expect(tester.takeException(), isNull);
  });
}
