import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_engine.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/presentation/cube_net_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// `ItemSource.generator` draws one seed per item from `Random(sessionSeed)`
/// (see `item_source.dart`); replicated here (as `dominos_renderer_test.dart`
/// does) so the test knows the exact puzzle a session with `sessionSeed`
/// will show as its first item.
int _firstItemSeed(int sessionSeed) => Random(sessionSeed).nextInt(1 << 31);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const sessionSeed = 1;
  const difficulty = 2;
  // No distractors: the tray holds exactly the two correct tiles, one per
  // missing slot, which keeps the drag choreography unambiguous.
  const params = CubeNetParams(distractorFaces: 0);
  final itemSeed = _firstItemSeed(sessionSeed);
  final puzzle = buildCubeNetPuzzle(
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
    familyId: 'spatial_cubes',
    mode: SessionMode.practice,
    source: ItemSource.generator(
      generatorId: GeneratorId.cubeNet,
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
        EngineRegistry(const [CubeNetEngine()]),
      ),
      rendererRegistryProvider.overrideWithValue(
        RendererRegistry(const [CubeNetRenderer()]),
      ),
      engineClockProvider.overrideWithValue(clock),
    ],
  );

  /// Drags the tray tile that belongs to [slot] into that slot, rotating
  /// it first (by tapping, spec: "flippable by tapping") to the required
  /// orientation.
  Future<void> placeCorrectTile(WidgetTester tester, int slot) async {
    final required = puzzle.targetRequired[slot]!;
    final tileIndex = puzzle.trayTiles.indexWhere(
      (t) => t.face == required.face && !t.mirrored,
    );
    expect(tileIndex, greaterThanOrEqualTo(0));
    final tile = puzzle.trayTiles[tileIndex];

    final taps = ((required.rotation - tile.initialRotation) % 360) ~/ 90;
    final trayKey = ValueKey('cube_net.tray.$tileIndex');
    for (var i = 0; i < taps; i++) {
      await tester.tap(find.byKey(trayKey));
      await tester.pump();
    }

    final source = tester.getCenter(find.byKey(trayKey));
    final target = tester.getCenter(
      find.byKey(ValueKey('cube_net.slot.$slot')),
    );
    await tester.drag(find.byKey(trayKey), target - source);
    await tester.pump();
  }

  /// The net grids + tray overflow the default 800x600 test surface;
  /// give the tree enough room so every tile hit-tests correctly (the
  /// content itself already scrolls in the real app's viewport).
  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  testWidgets(
    'dragging the correct faces into place, rotated, scores correct',
    (tester) async {
      useTallSurface(tester);
      await pumpHost(tester);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      for (final slot in puzzle.missingCellIndices) {
        await placeCorrectTile(tester, slot);
      }

      expect(find.byKey(const Key('cube_net.validate')), findsOneWidget);
      await tester.tap(find.text(l10nFr.actionValidate));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);
      expect(
        find.text(
          l10nFr.cubeNetCorrectFaces(
            puzzle.missingCellIndices.length,
            puzzle.missingCellIndices.length,
          ),
        ),
        findsOneWidget,
      );

      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
      expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
      expect(finished, hasLength(1));
      expect(finished.single.section.correct, 1);
    },
  );

  testWidgets('a face left at the wrong rotation scores wrong', (tester) async {
    useTallSurface(tester);
    await pumpHost(tester);
    await tester.tap(find.byKey(SessionHost.startKey));
    await tester.pump();

    final slots = puzzle.missingCellIndices;
    // Place the first slot's tile without rotating it (almost certainly
    // wrong: only a 1-in-4 chance the untouched initial rotation happens
    // to already match).
    final required0 = puzzle.targetRequired[slots.first]!;
    final tileIndex0 = puzzle.trayTiles.indexWhere(
      (t) => t.face == required0.face && !t.mirrored,
    );
    final needsNoRotation =
        puzzle.trayTiles[tileIndex0].initialRotation == required0.rotation;

    final trayKey0 = ValueKey('cube_net.tray.$tileIndex0');
    final source0 = tester.getCenter(find.byKey(trayKey0));
    final target0 = tester.getCenter(
      find.byKey(ValueKey('cube_net.slot.${slots.first}')),
    );
    await tester.drag(find.byKey(trayKey0), target0 - source0);
    await tester.pump();
    if (needsNoRotation) {
      // Force it wrong by rotating once, so the assertion is meaningful
      // regardless of the puzzle's random initial rotation.
      await tester.tap(find.byKey(ValueKey('cube_net.slot.${slots.first}')));
      await tester.pump();
    }

    for (final slot in slots.skip(1)) {
      await placeCorrectTile(tester, slot);
    }

    await tester.tap(find.text(l10nFr.actionValidate));
    await tester.pump();
    expect(find.text(l10nFr.sessionFeedbackCorrect), findsNothing);
  });
}
