import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_angles/domain/p1_angles_engine.dart';
import 'package:psy_trainer/features/engines/p1_angles/presentation/p1_angles_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_angles` through the real `SessionHost`, the real
/// engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file).
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = P1AnglesEngine();
  const params = GeneratorParams.p1Angles();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

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
            RendererRegistry(const [P1AnglesRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  ActivitySessionConfig practiceConfig() => ActivitySessionConfig(
    familyId: 'p1_angles',
    mode: SessionMode.practice,
    source: ItemSource.bank([itemAt(1), itemAt(2)]),
  );

  testWidgets('selecting the correct candidates then Valider scores it '
      'correct', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = P1AnglesEngine.boardOf(itemAt(1) as GeneratedItem);
    for (final index in board.correctIndices) {
      await tester.tap(find.byKey(P1AnglesRenderer.candidateKey(index)));
      await tester.pump();
    }
    await tester.tap(find.byKey(P1AnglesRenderer.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    await tester.tap(find.byKey(SessionHost.nextKey));
    await tester.pump();
  });

  testWidgets('an empty submission is wrong when at least one angle is drawn', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(P1AnglesRenderer.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
  });

  testWidgets('digit keys toggle candidates and Enter validates', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = P1AnglesEngine.boardOf(itemAt(1) as GeneratedItem);
    const digits = [
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
    for (final index in board.correctIndices) {
      await tester.sendKeyEvent(digits[index]);
      await tester.pump();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('an exam session is silent: no feedback text after Valider', (
    tester,
  ) async {
    final config = ActivitySessionConfig(
      familyId: 'p1_angles',
      mode: SessionMode.exam,
      source: ItemSource.bank([itemAt(1)]),
    );
    await pumpHost(tester, ActivitySessionRequest.fresh(config));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    await tester.tap(find.byKey(P1AnglesRenderer.validateKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(find.text(l10nFr.sessionFeedbackWrong), findsNothing);
    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
  });

  testWidgets('the briefing shows the worked example', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig()));
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
    expect(find.text(l10nFr.p1AnglesExampleCaption), findsOneWidget);
  });
}
