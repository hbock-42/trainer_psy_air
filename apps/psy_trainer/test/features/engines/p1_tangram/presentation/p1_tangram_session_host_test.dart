import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/p1_tangram_engine.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/tangram_board.dart';
import 'package:psy_trainer/features/engines/p1_tangram/presentation/p1_tangram_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `p1_tangram` through the real `SessionHost`, the real
/// engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file, and `spatial_overlay`'s own drag-driven session
/// host test for the drag-simulation technique this reuses).
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = TangramEngine();

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        // `Draggable`'s feedback needs an `Overlay` ancestor.
        Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) =>
                  SessionHost(request: request, onFinished: finished.add),
            ),
          ],
        ),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(EngineRegistry([engine])),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [TangramRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  group('compose mode', () {
    // A small, 3-piece board so the workspace geometry stays simple.
    const params = P1TangramParams(pieceCount: 3);

    Item itemAt(int seed) =>
        engine.generate(params: params, seed: seed, difficulty: 1);

    ActivitySessionConfig practiceConfig(int seed) => ActivitySessionConfig(
      familyId: 'p1_tangram',
      mode: SessionMode.practice,
      source: ItemSource.bank([itemAt(seed)]),
    );

    /// Rotates/flips the tray piece at [index] to match [placement], then
    /// drags it so its own vertex 0 lands exactly on the same vertex the
    /// generator's own solution placement puts there -- the renderer's
    /// nearest-vertex snap (`_TangramComposeBoardState._drop`) then finds an
    /// exact (distance-0) match and reproduces [placement] exactly.
    Future<void> placePiece(
      WidgetTester tester,
      TangramBoard board,
      int index,
      PlacedPiece placement,
    ) async {
      for (var i = 0; i < placement.rotationSteps; i++) {
        await tester.tap(find.byKey(TangramRenderer.trayPieceKey(index)));
        // A tap on a widget that also has `onDoubleTap` only resolves after
        // the double-tap disambiguation window elapses -- pump past it
        // (`kDoubleTapTimeout` is 300ms) so `_rotate` actually runs before
        // the next tap or the drag below.
        await tester.pump(const Duration(milliseconds: 400));
      }
      if (placement.flipped) {
        // `onLongPress` is the other flip trigger the renderer wires up
        // (alongside double-tap) -- more reliable to drive from a widget
        // test than timing two taps within the double-tap window.
        await tester.longPress(find.byKey(TangramRenderer.trayPieceKey(index)));
        await tester.pump();
      }

      final workspaceRect = tester.getRect(
        find.byKey(TangramRenderer.workspaceKey),
      );
      // The workspace box is drawn with a half-unit margin around the
      // figure's own bounding box (`_Workspace._margin`), so its width
      // spans `(maxX - minX) + 1.0` board units, origin at `minX - 0.5`.
      final scale = workspaceRect.width / (board.maxX - board.minX + 1.0);
      final vertex0 = placement.absoluteVertices(board.pieces[index]).first;
      final dest =
          workspaceRect.topLeft +
          Offset(
            (vertex0.$1 - board.minX + 0.5) * scale,
            (vertex0.$2 - board.minY + 0.5) * scale,
          );
      final start = tester.getCenter(
        find.byKey(TangramRenderer.trayPieceKey(index)),
      );
      await tester.drag(
        find.byKey(TangramRenderer.trayPieceKey(index)),
        dest - start,
      );
      await tester.pump();
    }

    Future<void> placeSolution(WidgetTester tester, TangramBoard board) async {
      for (var i = 0; i < board.pieces.length; i++) {
        await placePiece(tester, board, i, board.solutionPlacements[i]);
      }
    }

    testWidgets(
      'dragging every piece onto its solution placement auto-solves the '
      'board (practice: feedback shown, waits for Next)',
      (tester) async {
        await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
        await tester.tap(find.byKey(SessionHost.startKey));
        await tester.pump();

        final board = TangramEngine.boardOf(itemAt(1) as GeneratedItem);
        expect(find.byKey(TangramRenderer.trayPieceKey(0)), findsOneWidget);

        await placeSolution(tester, board);

        expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
        expect(find.text(l10nFr.tangramSolutionCaption), findsOneWidget);
        expect(find.byKey(SessionHost.nextKey), findsOneWidget);

        await tester.tap(find.byKey(SessionHost.nextKey));
        await tester.pump();

        expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
        expect(finished.single.section.correct, 1);
      },
    );

    testWidgets('an exam session auto-advances (no feedback) once solved', (
      tester,
    ) async {
      final config = ActivitySessionConfig(
        familyId: 'p1_tangram',
        mode: SessionMode.exam,
        source: ItemSource.bank([itemAt(1)]),
      );
      await pumpHost(tester, ActivitySessionRequest.fresh(config));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final board = TangramEngine.boardOf(itemAt(1) as GeneratedItem);
      await placeSolution(tester, board);

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
      expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
      expect(finished.single.section.correct, 1);
    });

    testWidgets('Réinitialiser sends every placed piece back to the tray', (
      tester,
    ) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final board = TangramEngine.boardOf(itemAt(1) as GeneratedItem);
      await placePiece(tester, board, 0, board.solutionPlacements[0]);

      expect(find.byKey(TangramRenderer.placedPieceKey(0)), findsOneWidget);
      expect(find.byKey(TangramRenderer.trayPieceKey(0)), findsNothing);

      await tester.tap(find.byKey(TangramRenderer.resetKey));
      await tester.pump();

      expect(find.byKey(TangramRenderer.trayPieceKey(0)), findsOneWidget);
    });

    testWidgets('the briefing shows the worked example', (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
      expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
      expect(find.text(l10nFr.tangramExampleCaption), findsOneWidget);
    });
  });

  group('count_occurrences mode', () {
    const params = P1TangramParams(mode: TangramMode.countOccurrences);

    Item itemAt(int seed) =>
        engine.generate(params: params, seed: seed, difficulty: 3);

    ActivitySessionConfig practiceConfig(int seed) => ActivitySessionConfig(
      familyId: 'p1_tangram',
      mode: SessionMode.practice,
      source: ItemSource.bank([itemAt(seed)]),
    );

    testWidgets('the stem, the figure and the keypad are shown', (
      tester,
    ) async {
      final item = itemAt(4) as NumericItem;
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(4)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(item.stem.fr), findsOneWidget);
      expect(
        find.byKey(const ValueKey('numeric_key_validate')),
        findsOneWidget,
      );
    });

    testWidgets('the exact expected count scores correct', (tester) async {
      final item = itemAt(4) as NumericItem;
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(4)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      for (final digit in item.expected.round().toString().split('')) {
        await tester.tap(find.byKey(ValueKey('numeric_key_$digit')));
        await tester.pump();
      }
      await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
    });

    testWidgets('a wrong count scores wrong', (tester) async {
      final item = itemAt(4) as NumericItem;
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(4)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final wrong = (item.expected + 1).round().toString();
      for (final digit in wrong.split('')) {
        await tester.tap(find.byKey(ValueKey('numeric_key_$digit')));
        await tester.pump();
      }
      await tester.tap(find.byKey(const ValueKey('numeric_key_validate')));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
    });
  });
}
