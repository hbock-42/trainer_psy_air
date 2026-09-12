import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_engine.dart';
import 'package:psy_trainer/features/engines/planning_tubes/presentation/tubes_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `planning_tubes` through the real `SessionHost`, the real
/// engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file).
void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = TubesEngine();
  const params = TubesParams();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  NumericItem itemAt(int seed, {int difficulty = 3}) =>
      engine.generate(params: params, seed: seed, difficulty: difficulty)
          as NumericItem;

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [TubesRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  ActivitySessionConfig practiceConfig() => ActivitySessionConfig(
    familyId: 'planning_tubes',
    mode: SessionMode.practice,
    source: ItemSource.bank([itemAt(1), itemAt(2)]),
  );

  Future<void> tapDigits(WidgetTester tester, String digits) async {
    for (final char in digits.split('')) {
      await tester.tap(find.byKey(ValueKey('numeric_key_$char')));
      await tester.pump();
    }
  }

  testWidgets('typing the exact distance on the keypad scores correct', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final item = itemAt(1);
    await tapDigits(tester, '${item.expected.toInt()}');
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('a wrong number of moves scores wrong', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final item = itemAt(1);
    await tapDigits(tester, '${item.expected.toInt() + 1}');
    await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('physical keyboard digits and Enter also work', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final item = itemAt(1);
    for (final digit in '${item.expected.toInt()}'.split('')) {
      final key = switch (digit) {
        '0' => LogicalKeyboardKey.digit0,
        '1' => LogicalKeyboardKey.digit1,
        '2' => LogicalKeyboardKey.digit2,
        '3' => LogicalKeyboardKey.digit3,
        '4' => LogicalKeyboardKey.digit4,
        '5' => LogicalKeyboardKey.digit5,
        '6' => LogicalKeyboardKey.digit6,
        '7' => LogicalKeyboardKey.digit7,
        '8' => LogicalKeyboardKey.digit8,
        _ => LogicalKeyboardKey.digit9,
      };
      await tester.sendKeyEvent(key);
    }
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('the start and target tube diagrams are drawn', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    expect(find.text(AppStrings.tubesStartLabel), findsOneWidget);
    expect(find.text(AppStrings.tubesTargetLabel), findsOneWidget);
  });

  testWidgets(
    '"Voir la solution" reveals a step-through that reaches the target',
    (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final item = itemAt(1);
      await tapDigits(tester, '${item.expected.toInt()}');
      await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
      await tester.pump();

      expect(find.text(AppStrings.tubesShowSolutionAction), findsOneWidget);
      await tester.tap(find.text(AppStrings.tubesShowSolutionAction));
      await tester.pump();

      final distance = item.expected.toInt();
      expect(
        find.text(AppStrings.tubesSolutionStepLabel(0, distance)),
        findsOneWidget,
      );

      // Step through every move to the end: each "next" redraws the
      // tubes and updates the step label, landing on the target state.
      for (var step = 1; step <= distance; step++) {
        await tester.tap(
          find.byKey(const ValueKey('tubes_solution_next_step')),
        );
        await tester.pump();
        expect(
          find.text(AppStrings.tubesSolutionStepLabel(step, distance)),
          findsOneWidget,
        );
      }

      // At the last step, "next" is disabled (nothing left to reveal).
      final next = tester.widget<AppIconButton>(
        find.byKey(const ValueKey('tubes_solution_next_step')),
      );
      expect(next.onPressed, isNull);

      // Stepping back moves the label back down.
      await tester.tap(
        find.byKey(const ValueKey('tubes_solution_previous_step')),
      );
      await tester.pump();
      expect(
        find.text(AppStrings.tubesSolutionStepLabel(distance - 1, distance)),
        findsOneWidget,
      );
    },
  );

  testWidgets('the briefing shows a static tube diagram example', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    expect(find.text(AppStrings.sessionExamplePlaceholder), findsNothing);
    expect(find.text(AppStrings.tubesStartLabel), findsOneWidget);
    expect(find.text(AppStrings.tubesTargetLabel), findsOneWidget);
  });
}
