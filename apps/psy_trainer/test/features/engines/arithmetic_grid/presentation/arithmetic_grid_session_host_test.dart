import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/domain/arithmetic_grid_engine.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/presentation/arithmetic_grid_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `arithmetic_grid` through the real `SessionHost`, the
/// real engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file).
void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = ArithmeticGridEngine();
  const params = GeneratorParams.arithmeticGrid(wrongMin: 1, wrongMax: 1);

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  /// One generated item with exactly one wrong cell, so the test knows the
  /// answer up front.
  Item itemAt(int seed) =>
      engine.generate(params: params, seed: seed, difficulty: 3);

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [ArithmeticGridRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  ActivitySessionConfig practiceConfig() => ActivitySessionConfig(
    familyId: 'arithmetic_grid',
    mode: SessionMode.practice,
    source: ItemSource.bank([itemAt(1), itemAt(2)]),
  );

  testWidgets('tapping the wrong cell then Valider scores it correct', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final grid = ArithmeticGridEngine.gridOf(itemAt(1) as GeneratedItem);
    final wrongIndex = grid.wrongIndices.single;

    expect(
      find.byKey(ArithmeticGridRenderer.cellKey(wrongIndex)),
      findsOneWidget,
    );
    expect(find.text(grid.cells[wrongIndex].label), findsOneWidget);

    await tester.tap(find.byKey(ArithmeticGridRenderer.cellKey(wrongIndex)));
    await tester.pump();
    await tester.tap(find.byKey(ArithmeticGridRenderer.validateKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();

    // Second item: a fresh grid, no cell selected yet.
    final secondGrid = ArithmeticGridEngine.gridOf(itemAt(2) as GeneratedItem);
    expect(find.text(secondGrid.cells.first.label), findsOneWidget);
  });

  testWidgets('feedback shows the correct value of the wrong cell', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final grid = ArithmeticGridEngine.gridOf(itemAt(1) as GeneratedItem);
    final wrongIndex = grid.wrongIndices.single;

    // Validate without selecting anything: wrong answer, feedback shown.
    await tester.tap(find.byKey(ArithmeticGridRenderer.validateKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackWrong), findsOneWidget);
    expect(
      find.text(
        AppStrings.arithmeticGridCorrectValue(
          grid.cells[wrongIndex].correctValue,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('digit keys toggle cells and Enter validates', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final grid = ArithmeticGridEngine.gridOf(itemAt(1) as GeneratedItem);
    final wrongIndex = grid.wrongIndices.single;
    final digitKey = switch (wrongIndex) {
      0 => LogicalKeyboardKey.digit1,
      1 => LogicalKeyboardKey.digit2,
      2 => LogicalKeyboardKey.digit3,
      3 => LogicalKeyboardKey.digit4,
      4 => LogicalKeyboardKey.digit5,
      5 => LogicalKeyboardKey.digit6,
      6 => LogicalKeyboardKey.digit7,
      7 => LogicalKeyboardKey.digit8,
      _ => LogicalKeyboardKey.digit9,
    };

    await tester.sendKeyEvent(digitKey);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('an exam session is silent: no feedback text after Valider', (
    tester,
  ) async {
    final config = ActivitySessionConfig(
      familyId: 'arithmetic_grid',
      mode: SessionMode.exam,
      source: ItemSource.bank([itemAt(1)]),
    );
    await pumpHost(tester, ActivitySessionRequest.fresh(config));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(ArithmeticGridRenderer.validateKey));
    await tester.pump();

    expect(find.text(AppStrings.sessionFeedbackCorrect), findsNothing);
    expect(find.text(AppStrings.sessionFeedbackWrong), findsNothing);
    expect(find.text(AppStrings.sessionFinishedTitle), findsOneWidget);
  });

  testWidgets('the briefing shows the worked example', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    expect(find.text(AppStrings.sessionExamplePlaceholder), findsNothing);
    expect(find.text(AppStrings.arithmeticGridExampleCaption), findsOneWidget);
  });
}
