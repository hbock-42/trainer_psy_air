import 'dart:math';

import 'package:flutter/widgets.dart' show Locale, ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/domain/mental_arithmetic_engine.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/presentation/mental_arithmetic_intervals_view.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/presentation/mental_arithmetic_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_mental_arithmetic` through the real `SessionHost`, the
/// real engine and the real renderer, one item per answer mode -- see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file, and
/// `test/features/engines/arithmetic_grid/presentation/arithmetic_grid_session_host_test.dart`
/// for the sibling pattern this mirrors.
///
/// Uses `ItemSource.generator` (not `.bank`): the family's mode depends on
/// the item's `index` (`MentalArithmeticGenerator.modeAt`), and
/// `ActivityEngine.materialise` (used by `ItemSource.bank` to replay an
/// already-built `GeneratedItem`) calls `generate` again without the
/// original `index`, which would silently reset an `allIntervals` item back
/// to `freeNumeric` -- the same reason `memory_nback`'s widget tests use
/// `ItemSource.generator` (see `nback_renderer_test.dart`). A single-item,
/// single-mode run (`count: 1`) starting at each
/// `MentalArithmeticAnswerMode` in turn (via `answerMode`) exercises every
/// mode without needing to play through the 30 items ahead of it in a full
/// 4-series run.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 13, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = MentalArithmeticEngine();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  /// Replays `ItemSource.generator`'s own per-item draw
  /// (`ItemSource._generate`, private) for a single-item, single-difficulty
  /// run, so the test can predict the exact item `SessionHost` will show
  /// without duplicating any runtime code.
  Item firstGeneratedItem(int seed, GeneratorParams params) {
    final rng = Random(seed);
    final itemSeed = rng.nextInt(1 << 31);
    final level = 3 + rng.nextInt(1); // DifficultyRange(min: 3, max: 3)
    return engine.generate(
      params: params,
      seed: itemSeed,
      difficulty: level,
      runSeed: seed,
    );
  }

  ActivitySessionConfig configOf(int seed, GeneratorParams params) =>
      ActivitySessionConfig(
        familyId: 'p1_mental_arithmetic',
        mode: SessionMode.practice,
        source: ItemSource.generator(
          generatorId: GeneratorId.p1MentalArithmetic,
          seed: seed,
          params: params,
          count: 1,
        ),
      );

  Future<void> pumpHost(WidgetTester tester, ActivitySessionConfig config) =>
      pumpApp(
        tester,
        SessionHost(
          request: ActivitySessionRequest.fresh(config),
          onFinished: finished.add,
        ),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [engine]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [MentalArithmeticRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  Future<void> tapNumericDigits(WidgetTester tester, int value) async {
    for (final digit in value.toString().split('')) {
      await tester.tap(find.byKey(ValueKey('numeric_key_$digit')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();
  }

  testWidgets('freeNumeric: typing the exact value scores correct', (
    tester,
  ) async {
    const params = GeneratorParams.p1MentalArithmetic();
    final item = firstGeneratedItem(1, params) as NumericItem;

    await pumpHost(tester, configOf(1, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tapNumericDigits(tester, item.expected.toInt());

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('equation: typing x scores correct', (tester) async {
    const params = GeneratorParams.p1MentalArithmetic(
      answerMode: MentalArithmeticAnswerMode.equation,
    );
    final item = firstGeneratedItem(2, params) as NumericItem;

    await pumpHost(tester, configOf(2, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tapNumericDigits(tester, item.expected.toInt());

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('smallestInterval: tapping the tightest bracket scores correct', (
    tester,
  ) async {
    const params = GeneratorParams.p1MentalArithmetic(
      answerMode: MentalArithmeticAnswerMode.smallestInterval,
    );
    final item = firstGeneratedItem(3, params) as McqItem;

    await pumpHost(tester, configOf(3, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('mcq_option_${item.correctIndex}')));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('allIntervals: selecting exactly the containing brackets scores '
      'correct', (tester) async {
    const params = GeneratorParams.p1MentalArithmetic(
      answerMode: MentalArithmeticAnswerMode.allIntervals,
    );
    final item = firstGeneratedItem(4, params) as GeneratedItem;
    final containing = MentalArithmeticEngine.problemOf(
      item,
    ).containingIndices.toList()..sort();

    await pumpHost(tester, configOf(4, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    for (final index in containing) {
      await tester.tap(
        find.byKey(MentalArithmeticIntervalsView.tileKey(index)),
      );
      await tester.pump();
    }
    await tester.tap(find.byKey(MentalArithmeticIntervalsView.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('an exam session is silent: no feedback after Valider', (
    tester,
  ) async {
    const params = GeneratorParams.p1MentalArithmetic();
    final item = firstGeneratedItem(1, params) as NumericItem;
    const config = ActivitySessionConfig(
      familyId: 'p1_mental_arithmetic',
      mode: SessionMode.exam,
      source: ItemSource.generator(
        generatorId: GeneratorId.p1MentalArithmetic,
        seed: 1,
        params: params,
        count: 1,
      ),
    );

    await pumpHost(tester, config);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tapNumericDigits(tester, item.expected.toInt());

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(find.text(l10nFr.sessionFeedbackWrong), findsNothing);
    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
  });
}
