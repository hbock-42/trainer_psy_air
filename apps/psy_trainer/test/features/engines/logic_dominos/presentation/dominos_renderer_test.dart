import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_board.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_explanation.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/dominos_engine.dart';
import 'package:psy_trainer/features/engines/logic_dominos/presentation/dominos_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// `ItemSource.generator` draws one seed per item from `Random(sessionSeed)`
/// (see `item_source.dart`); replicated here so the test knows the exact
/// puzzle -- and so the exact right answer -- a session with
/// `sessionSeed`/`difficulty` will show as its first item.
int _firstItemSeed(int sessionSeed) => Random(sessionSeed).nextInt(1 << 31);

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const sessionSeed = 1;
  const difficulty = 1;
  const params = DominosParams();
  final itemSeed = _firstItemSeed(sessionSeed);
  final board = buildDominoBoard(
    seed: itemSeed,
    params: params,
    difficulty: difficulty,
  );

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config() => const ActivitySessionConfig(
    familyId: 'logic_dominos',
    mode: SessionMode.practice,
    source: ItemSource.generator(
      generatorId: GeneratorId.dominos,
      seed: sessionSeed,
      params: params,
      count: 1,
      difficulty: DifficultyRange(min: difficulty, max: difficulty),
    ),
  );

  Future<void> pumpHost(WidgetTester tester) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(config()),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(
        EngineRegistry(const [DominosEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [DominosRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  testWidgets('tapping the two selectors and Valider answers correctly', (
    tester,
  ) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('domino-top-${board.answer.top}')));
    await tester.pump();
    await tester.tap(
      find.byKey(ValueKey('domino-bottom-${board.answer.bottom}')),
    );
    await tester.pump();
    await tester.tap(find.text(AppStrings.actionValidate));
    await tester.pump();

    expect(
      find.text(
        AppStrings.dominoAnswerSummary(board.answer.top, board.answer.bottom),
      ),
      findsOneWidget,
    );
    expect(find.text(explanationFor(board.ruleKinds)), findsOneWidget);
    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);

    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
    expect(finished, hasLength(1));
    expect(finished.single.section.correct, 1);
  });

  testWidgets('a wrong pick scores wrong', (tester) async {
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final wrongTop = (board.answer.top + 1) % 7;
    await tester.tap(find.byKey(ValueKey('domino-top-$wrongTop')));
    await tester.pump();
    await tester.tap(
      find.byKey(ValueKey('domino-bottom-${board.answer.bottom}')),
    );
    await tester.pump();
    await tester.tap(find.text(AppStrings.actionValidate));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets(
    'keyboard digits answer the item: first digit top, second bottom, Enter validates',
    (tester) async {
      await pumpHost(tester);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      await tester.sendKeyEvent(_digitKey(board.answer.top));
      await tester.pump();
      await tester.sendKeyEvent(_digitKey(board.answer.bottom));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
    },
  );
}

LogicalKeyboardKey _digitKey(int digit) => const [
  LogicalKeyboardKey.digit0,
  LogicalKeyboardKey.digit1,
  LogicalKeyboardKey.digit2,
  LogicalKeyboardKey.digit3,
  LogicalKeyboardKey.digit4,
  LogicalKeyboardKey.digit5,
  LogicalKeyboardKey.digit6,
][digit];
