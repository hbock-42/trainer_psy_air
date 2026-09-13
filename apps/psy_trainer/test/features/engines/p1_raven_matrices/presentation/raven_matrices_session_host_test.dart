import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/raven_matrices_engine.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/presentation/raven_matrices_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_raven_matrices` through the real `SessionHost`, the
/// real engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file).
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 13, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = RavenMatricesEngine();
  const params = P1RavenMatricesParams();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  Item itemAt(int seed, {int difficulty = 2}) =>
      engine.generate(params: params, seed: seed, difficulty: difficulty);

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        SessionHost(request: request, onFinished: finished.add),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [RavenMatricesRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  ActivitySessionConfig practiceConfig(int seed) => ActivitySessionConfig(
    familyId: 'p1_raven_matrices',
    mode: SessionMode.practice,
    source: ItemSource.bank([itemAt(seed)]),
  );

  testWidgets(
    'practice: tapping the correct candidate answers directly and shows '
    'the rule explanation',
    (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final board = RavenMatricesEngine.boardOf(itemAt(1) as GeneratedItem);
      expect(
        find.byKey(RavenMatricesRenderer.candidateKey(0)),
        findsOneWidget,
      );

      final correctKey = RavenMatricesRenderer.candidateKey(board.correctIndex);
      await tester.ensureVisible(find.byKey(correctKey));
      await tester.pump();
      await tester.tap(find.byKey(correctKey));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
      expect(find.text(l10nFr.activityExplanationTitle), findsOneWidget);
      expect(find.byKey(SessionHost.nextKey), findsOneWidget);

      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();

      expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
      expect(finished.single.section.correct, 1);
    },
  );

  testWidgets('practice: tapping a wrong candidate shows the wrong feedback', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = RavenMatricesEngine.boardOf(itemAt(1) as GeneratedItem);
    final wrongIndex = (board.correctIndex + 1) % board.candidates.length;

    final wrongKey = RavenMatricesRenderer.candidateKey(wrongIndex);
    await tester.ensureVisible(find.byKey(wrongKey));
    await tester.pump();
    await tester.tap(find.byKey(wrongKey));
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(finished, isEmpty);
  });

  testWidgets(
    'exam: selecting a candidate needs Valider before it counts as an answer',
    (tester) async {
      final config = ActivitySessionConfig(
        familyId: 'p1_raven_matrices',
        mode: SessionMode.exam,
        source: ItemSource.bank([itemAt(1)]),
      );
      await pumpHost(tester, ActivitySessionRequest.fresh(config));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final board = RavenMatricesEngine.boardOf(itemAt(1) as GeneratedItem);
      final correctKey = RavenMatricesRenderer.candidateKey(board.correctIndex);
      await tester.ensureVisible(find.byKey(correctKey));
      await tester.pump();
      await tester.tap(find.byKey(correctKey));
      await tester.pump();

      // No feedback in exam mode, and the session has not advanced yet: the
      // candidate is only selected, `Valider` still has to be pressed.
      expect(find.text(l10nFr.sessionFinishedTitle), findsNothing);
      expect(find.byKey(const ValueKey('raven_matrices_validate')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('raven_matrices_validate')));
      await tester.pump();

      expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
      expect(finished.single.section.correct, 1);
    },
  );

  testWidgets('keyboard digit 1-8 answers directly in practice', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = RavenMatricesEngine.boardOf(itemAt(1) as GeneratedItem);
    final digitKeys = [
      LogicalKeyboardKey.digit1,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit5,
      LogicalKeyboardKey.digit6,
      LogicalKeyboardKey.digit7,
      LogicalKeyboardKey.digit8,
    ];
    await tester.sendKeyEvent(digitKeys[board.correctIndex]);
    await tester.pump();

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
  });

  testWidgets('the briefing shows the worked example', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
    expect(find.text(l10nFr.matrixExampleCaption), findsOneWidget);
  });
}
