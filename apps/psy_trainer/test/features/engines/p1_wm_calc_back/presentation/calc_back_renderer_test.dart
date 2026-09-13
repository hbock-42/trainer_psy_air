import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_wm_calc_back/domain/calc_back_engine.dart';
import 'package:psy_trainer/features/engines/p1_wm_calc_back/presentation/calc_back_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  const engine = CalcBackEngine();
  final start = DateTime.utc(2026, 9, 5, 9);
  const params = P1WmCalcBackParams(calcsPerStage: 5);
  const sectionSeed = 3;

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
    int count = 2,
  }) => ActivitySessionConfig(
    familyId: 'p1_wm_calc_back',
    mode: mode,
    source: ItemSource.generator(
      generatorId: GeneratorId.p1WmCalcBack,
      seed: sectionSeed,
      params: params,
      count: count,
    ),
  );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig sessionConfig,
  ) => pumpApp(
    tester,
    SessionHost(
      request: ActivitySessionRequest.fresh(sessionConfig),
      onFinished: finished.add,
    ),
    overrides: [
      progressRepositoryProvider.overrideWithValue(repo),
      engineRegistryProvider.overrideWithValue(EngineRegistry(const [engine])),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [CalcBackRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  /// Types [value] on the numeric keypad then validates.
  Future<void> typeAndValidate(WidgetTester tester, int value) async {
    for (final digit in '$value'.split('')) {
      await tester.tap(
        find.byKey(CalcBackRenderer.keypadDigitKey(int.parse(digit))),
      );
      await tester.pump();
    }
    await tester.tap(find.byKey(CalcBackRenderer.validateKey));
    await tester.pump();
  }

  testWidgets('shows the operand/operator stem and stage label', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final chain = CalcBackChain.build(params, sectionSeed, upTo: 1);
    final step0 = chain.steps[0];
    expect(find.text('${step0.operand} ${step0.op.symbol} ?'), findsOneWidget);
    expect(find.byKey(CalcBackRenderer.stageKey), findsOneWidget);
  });

  testWidgets('typing the chained result on the keypad scores correct', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final chain = CalcBackChain.build(params, sectionSeed, upTo: 1);
    await typeAndValidate(tester, chain.steps[0].result);

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('typing the wrong value scores wrong', (tester) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final chain = CalcBackChain.build(params, sectionSeed, upTo: 1);
    await typeAndValidate(tester, chain.steps[0].result + 1);

    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('the physical numeric keys type, exactly like the buttons', (
    tester,
  ) async {
    await pumpHost(tester, config());
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final chain = CalcBackChain.build(params, sectionSeed, upTo: 1);
    const digitKeys = [
      LogicalKeyboardKey.digit0,
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
      LogicalKeyboardKey.digit9,
    ];
    for (final digit in '${chain.steps[0].result}'.split('')) {
      await tester.sendKeyEvent(digitKeys[int.parse(digit)]);
      await tester.pump();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('exam mode: silent, but scores and advances', (tester) async {
    await pumpHost(tester, config(mode: SessionMode.exam));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final chain = CalcBackChain.build(params, sectionSeed, upTo: 2);
    await typeAndValidate(tester, chain.steps[0].result);
    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);

    await typeAndValidate(tester, chain.steps[1].result);
    expect(finished.single.section.correct, 2);
  });
}
