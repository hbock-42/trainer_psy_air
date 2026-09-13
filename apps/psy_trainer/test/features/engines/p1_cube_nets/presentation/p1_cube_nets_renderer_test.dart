import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_net_puzzle.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_nets_engine.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_rotation_puzzle.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/presentation/p1_cube_nets_renderer.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/pump_app.dart';

/// `ItemSource.generator` draws one seed per item from `Random(sessionSeed)`
/// (see `item_source.dart`); replicated here (as `cube_net_renderer_test`
/// and `dominos_renderer_test` do) so the test knows exactly which puzzle a
/// session with `sessionSeed` will show as its first item.
int _firstItemSeed(int sessionSeed) => Random(sessionSeed).nextInt(1 << 31);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const sessionSeed = 1;
  const difficulty = 2;
  final itemSeed = _firstItemSeed(sessionSeed);

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late List<SessionResult> finished;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    finished = [];
  });

  ActivitySessionConfig config(P1CubeNetsParams params) =>
      ActivitySessionConfig(
        familyId: 'p1_cube_nets',
        mode: SessionMode.practice,
        source: ItemSource.generator(
          generatorId: GeneratorId.p1CubeNets,
          seed: sessionSeed,
          params: params,
          count: 1,
          difficulty: const DifficultyRange(min: difficulty, max: difficulty),
        ),
      );

  Future<void> pumpHost(WidgetTester tester, P1CubeNetsParams params) =>
      pumpApp(
        tester,
        SessionHost(
          request: ActivitySessionRequest.fresh(config(params)),
          onFinished: finished.add,
        ),
        overrides: [
          progressRepositoryProvider.overrideWithValue(repo),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry(const [P1CubeNetsEngine()]),
          ),
          rendererRegistryProvider.overrideWithValue(
            RendererRegistry(const [P1CubeNetsRenderer()]),
          ),
          engineClockProvider.overrideWithValue(clock),
        ],
      );

  void useTallSurface(WidgetTester tester) {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
  }

  group('net mode', () {
    // No distractors beyond the required faces: keeps the drag choreography
    // unambiguous, same trick `cube_net_renderer_test` uses.
    const params = P1CubeNetsParams(phaseCount: 1, netsPerPhase: 5);
    final puzzle = buildP1CubeNetPuzzle(
      seed: itemSeed,
      alphabet: params.alphabet,
      missingFaces: params.missingFaces,
    );

    Future<void> placeCorrectTile(WidgetTester tester, int slot) async {
      final required = puzzle.targetRequired[slot]!;
      final tileIndex = puzzle.trayTiles.indexWhere(
        (t) => t.face == required.face && !t.mirrored,
      );
      expect(tileIndex, greaterThanOrEqualTo(0));
      final tile = puzzle.trayTiles[tileIndex];

      final taps = ((required.rotation - tile.initialRotation) % 360) ~/ 90;
      final trayKey = ValueKey('p1_cube_net.tray.$tileIndex');
      for (var i = 0; i < taps; i++) {
        await tester.tap(find.byKey(trayKey));
        await tester.pump();
      }

      final source = tester.getCenter(find.byKey(trayKey));
      final target = tester.getCenter(
        find.byKey(ValueKey('p1_cube_net.slot.$slot')),
      );
      await tester.drag(find.byKey(trayKey), target - source);
      await tester.pump();
    }

    testWidgets('placing every face correctly scores correct', (tester) async {
      useTallSurface(tester);
      await pumpHost(tester, params);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      for (final slot in puzzle.missingCellIndices) {
        await placeCorrectTile(tester, slot);
      }

      expect(find.byKey(const Key('p1_cube_net.validate')), findsOneWidget);
      await tester.tap(find.text(l10nFr.actionValidate));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);

      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
      expect(find.text(l10nFr.sessionFinishedTitle), findsOneWidget);
      expect(finished, hasLength(1));
      expect(finished.single.section.correct, 1);
    });
  });

  group('rotation mode', () {
    const params = P1CubeNetsParams(
      phaseCount: 1,
      netsPerPhase: 25,
      includeRotationMatching: true,
    );
    final puzzle = buildP1CubeRotationPuzzle(
      seed: itemSeed,
      alphabet: params.alphabet,
    );

    testWidgets('shows the reference/candidate cubes and the two answers', (
      tester,
    ) async {
      await pumpHost(tester, params);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      expect(find.text(l10nFr.p1CubeRotationQuestion), findsOneWidget);
      expect(find.byKey(const Key('p1_cube_rotation.same')), findsOneWidget);
      expect(find.byKey(const Key('p1_cube_rotation.altered')), findsOneWidget);
    });

    testWidgets('answering according to the ground truth scores correct', (
      tester,
    ) async {
      await pumpHost(tester, params);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final rightKey = puzzle.isSameCube
          ? const Key('p1_cube_rotation.same')
          : const Key('p1_cube_rotation.altered');
      await tester.tap(find.byKey(rightKey));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackCorrect), findsOneWidget);

      await tester.tap(find.byKey(SessionHost.nextKey));
      await tester.pump();
      expect(finished, hasLength(1));
      expect(finished.single.section.correct, 1);
    });

    testWidgets('answering against the ground truth scores wrong', (
      tester,
    ) async {
      await pumpHost(tester, params);
      await tester.tap(find.byKey(SessionHost.startKey));
      await tester.pump();

      final wrongKey = puzzle.isSameCube
          ? const Key('p1_cube_rotation.altered')
          : const Key('p1_cube_rotation.same');
      await tester.tap(find.byKey(wrongKey));
      await tester.pump();

      expect(find.text(l10nFr.sessionFeedbackWrong), findsOneWidget);
    });
  });
}
