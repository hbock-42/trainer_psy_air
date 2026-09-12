import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_board.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_grid_engine.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/presentation/overlay_grid_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// Widget test of `spatial_overlay` through the real `SessionHost`, the
/// real engine and the real renderer (see
/// `test/features/train/presentation/engine/session_host_test.dart`, the
/// template for this file). Drags are driven with `WidgetTester.drag`,
/// which moves a real pointer -- exactly what `DragTarget.onAcceptWithDetails`
/// reads to snap onto a cell.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  const engine = OverlayGridEngine();
  // A small, non-overlapping board so the test can compute the solution
  // drop points directly and drive the drags deterministically.
  const params = GeneratorParams.overlayGrid(
    grid: GridSize(rows: 2, cols: 2),
    tileCount: 2,
    overlapping: false,
    blackCells: false,
  );

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  Item itemAt(int seed) =>
      engine.generate(params: params, seed: seed, difficulty: 1);

  Future<void> pumpHost(WidgetTester tester, ActivitySessionRequest request) =>
      pumpApp(
        tester,
        // `Draggable`'s feedback needs an `Overlay` ancestor; `pumpApp`'s
        // bare `WidgetsApp` (no routing config) does not create a
        // `Navigator`, so one is added locally, just for this renderer.
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
            RendererRegistry(const [OverlayGridRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  ActivitySessionConfig practiceConfig(int seed) => ActivitySessionConfig(
    familyId: 'spatial_overlay',
    mode: SessionMode.practice,
    source: ItemSource.bank([itemAt(seed)]),
  );

  /// Drags the tray tile at [tileIndex] onto the grid cell `(row, col)` of
  /// [board], reading real widget geometry so the drop lands where
  /// `DragTarget.onAcceptWithDetails` expects it.
  Future<void> dragTileToCell(
    WidgetTester tester,
    OverlayBoard board,
    int tileIndex,
    int row,
    int col,
  ) async {
    final gridRect = tester.getRect(find.byKey(OverlayGridRenderer.gridKey));
    final cellSize = gridRect.width / board.gridCols;
    final dest =
        gridRect.topLeft +
        Offset(col * cellSize + cellSize / 2, row * cellSize + cellSize / 2);
    final start = tester.getCenter(
      find.byKey(OverlayGridRenderer.trayTileKey(tileIndex)),
    );
    await tester.drag(
      find.byKey(OverlayGridRenderer.trayTileKey(tileIndex)),
      dest - start,
    );
    await tester.pump();
  }

  Future<void> dragAllTilesToSolution(
    WidgetTester tester,
    OverlayBoard board,
  ) async {
    for (var i = 0; i < board.tiles.length; i++) {
      final pos = board.solutionPositions[i];
      await dragTileToCell(tester, board, i, pos.$1, pos.$2);
    }
  }

  testWidgets(
    'dragging every tile onto its solution position auto-solves the board '
    '(practice: feedback shown, waits for Next)',
    (tester) async {
      await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final board = OverlayGridEngine.boardOf(itemAt(1) as GeneratedItem);
      expect(find.byKey(OverlayGridRenderer.trayTileKey(0)), findsOneWidget);

      await dragAllTilesToSolution(tester, board);

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
      expect(find.text(l10nFr.overlayGridSolutionCaption), findsOneWidget);
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
      familyId: 'spatial_overlay',
      mode: SessionMode.exam,
      source: ItemSource.bank([itemAt(1)]),
    );
    await pumpHost(tester, ActivitySessionRequest.fresh(config));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = OverlayGridEngine.boardOf(itemAt(1) as GeneratedItem);
    await dragAllTilesToSolution(tester, board);

    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
    expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
    expect(finished.single.section.correct, 1);
  });

  testWidgets('Réinitialiser sends every placed tile back to the tray', (
    tester,
  ) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final board = OverlayGridEngine.boardOf(itemAt(1) as GeneratedItem);
    // A position for tile 0 that is very unlikely to already solve the
    // board on its own (the other tile is still in the tray).
    final firstLegal = board.tiles[0].positionsIn(
      board.gridRows,
      board.gridCols,
    )[0];
    await dragTileToCell(tester, board, 0, firstLegal.$1, firstLegal.$2);

    expect(find.byKey(OverlayGridRenderer.placedTileKey(0)), findsOneWidget);
    expect(find.byKey(OverlayGridRenderer.trayTileKey(0)), findsNothing);

    await tester.tap(find.byKey(OverlayGridRenderer.resetKey));
    await tester.pump();

    expect(find.byKey(OverlayGridRenderer.trayTileKey(0)), findsOneWidget);
  });

  testWidgets('the briefing shows the worked example', (tester) async {
    await pumpHost(tester, ActivitySessionRequest.fresh(practiceConfig(1)));
    expect(find.text(l10nFr.sessionExamplePlaceholder), findsNothing);
    expect(find.text(l10nFr.overlayGridExampleCaption), findsOneWidget);
  });
}
