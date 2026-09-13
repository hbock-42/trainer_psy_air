import 'dart:math';

import 'package:flutter/widgets.dart' show Locale, Size, ValueKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_math_word_problems/domain/word_problems_engine.dart';
import 'package:psy_trainer/features/engines/p1_math_word_problems/presentation/word_problems_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_math_word_problems` through the real `SessionHost`,
/// the real engine and the real renderer (US-104) -- see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template this mirrors, and
/// `p1_mental_arithmetic/presentation/mental_arithmetic_session_host_test.dart`
/// for the sibling pattern (a family whose item shape also depends on
/// `answerMode`).
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 13, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = MathWordProblemsEngine();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  /// Replays `ItemSource.generator`'s own per-item draw for a single-item
  /// run, so the test can predict the exact item `SessionHost` will show
  /// without duplicating any runtime code (see the sibling
  /// `mental_arithmetic_session_host_test.dart`).
  Item firstGeneratedItem(int seed, GeneratorParams params) {
    final rng = Random(seed);
    final itemSeed = rng.nextInt(1 << 31);
    final level = 3 + rng.nextInt(1); // DifficultyRange(min: 3, max: 3)
    return engine.generate(params: params, seed: itemSeed, difficulty: level);
  }

  ActivitySessionConfig configOf(int seed, GeneratorParams params) =>
      ActivitySessionConfig(
        familyId: 'p1_math_word_problems',
        mode: SessionMode.practice,
        source: ItemSource.generator(
          generatorId: GeneratorId.p1MathWordProblems,
          seed: seed,
          params: params,
          count: 1,
        ),
      );

  Future<void> pumpHost(
    WidgetTester tester,
    ActivitySessionConfig config, {
    Size size = const Size(800, 1600),
  }) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    return pumpApp(
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
          RendererRegistry(const [MathWordProblemsRenderer()]),
        ),
        engineClockProvider.overrideWithValue(clock),
      ],
    );
  }

  Future<void> tapNumericValue(WidgetTester tester, num value) async {
    final wholePart = value.truncate();
    for (final digit in wholePart.abs().toString().split('')) {
      await tester.tap(find.byKey(ValueKey('numeric_key_$digit')));
      await tester.pump();
    }
    final fractional = ((value.abs() - wholePart.abs()) * 10).round();
    if (fractional != 0) {
      await tester.tap(find.byKey(const ValueKey('numeric_key_decimal')));
      await tester.pump();
      await tester.tap(find.byKey(ValueKey('numeric_key_$fractional')));
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();
  }

  testWidgets('numeric mode: typing the exact expected value scores correct', (
    tester,
  ) async {
    const params = GeneratorParams.p1MathWordProblems(
      answerMode: P1AnswerMode.numeric,
    );
    final item = firstGeneratedItem(1, params) as NumericItem;

    await pumpHost(tester, configOf(1, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tapNumericValue(tester, item.expected);

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('mcq mode: tapping the correct option scores correct', (
    tester,
  ) async {
    const params = GeneratorParams.p1MathWordProblems(); // default: mcq
    final item = firstGeneratedItem(2, params) as McqItem;

    await pumpHost(tester, configOf(2, params));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(ValueKey('mcq_option_${item.correctIndex}')));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets(
    'at 360x780 the stem wraps and the keypad stays visible, no overflow',
    (tester) async {
      const params = GeneratorParams.p1MathWordProblems(
        answerMode: P1AnswerMode.numeric,
      );
      await pumpHost(tester, configOf(9, params), size: const Size(360, 780));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(
        find.byKey(const ValueKey('numeric_answer_field')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('numeric_key_validate')),
        findsOneWidget,
      );
      expect(
        tester
            .getBottomLeft(find.byKey(const ValueKey('numeric_key_validate')))
            .dy,
        lessThanOrEqualTo(780),
      );
    },
  );
}
