import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart';

void main() {
  const params = CubeNetParams();

  test(
    'determinism: same (seed, params, difficulty) yields the same puzzle',
    () {
      for (final seed in [1, 2, 42, 12345]) {
        for (final difficulty in [2, 3, 4, 5]) {
          final a = buildCubeNetPuzzle(
            seed: seed,
            params: params,
            difficulty: difficulty,
          );
          final b = buildCubeNetPuzzle(
            seed: seed,
            params: params,
            difficulty: difficulty,
          );
          expect(b.referenceNet.id, a.referenceNet.id);
          expect(b.targetNet.id, a.targetNet.id);
          expect(b.missingCellIndices, a.missingCellIndices);
          expect(b.trayTiles.length, a.trayTiles.length);
          for (var i = 0; i < a.trayTiles.length; i++) {
            expect(b.trayTiles[i].face, a.trayTiles[i].face);
            expect(b.trayTiles[i].value, a.trayTiles[i].value);
            expect(b.trayTiles[i].mirrored, a.trayTiles[i].mirrored);
            expect(
              b.trayTiles[i].initialRotation,
              a.trayTiles[i].initialRotation,
            );
          }
        }
      }
    },
  );

  test('difficulty controls the number of missing faces (clamped 2..5)', () {
    for (final difficulty in [1, 2, 3, 4, 5]) {
      final puzzle = buildCubeNetPuzzle(
        seed: 7,
        params: params,
        difficulty: difficulty,
      );
      expect(puzzle.missingCellIndices.length, difficulty.clamp(2, 5));
    }
  });

  test('reference net and target net are two different shapes', () {
    for (final seed in List.generate(50, (i) => i)) {
      final puzzle = buildCubeNetPuzzle(
        seed: seed,
        params: params,
        difficulty: 3,
      );
      expect(puzzle.referenceNet.id, isNot(puzzle.targetNet.id));
    }
  });

  test(
    'solvability and uniqueness: exactly one correct tile per missing slot',
    () {
      for (final seed in List.generate(50, (i) => i)) {
        for (final difficulty in [2, 3, 4, 5]) {
          final puzzle = buildCubeNetPuzzle(
            seed: seed,
            params: const CubeNetParams(),
            difficulty: difficulty,
          );
          for (final slot in puzzle.missingCellIndices) {
            final required = puzzle.targetRequired[slot]!;
            final matches = puzzle.trayTiles.where(
              (t) => t.face == required.face && !t.mirrored,
            );
            expect(
              matches.length,
              1,
              reason: 'slot $slot of net ${puzzle.targetNet.id} (seed $seed)',
            );
          }
        }
      }
    },
  );

  test(
    'mirrored tiles never match any required slot regardless of rotation',
    () {
      for (final seed in List.generate(20, (i) => i)) {
        final puzzle = buildCubeNetPuzzle(
          seed: seed,
          params: const CubeNetParams(),
          difficulty: 4,
        );
        final mirroredTiles = puzzle.trayTiles.where((t) => t.mirrored);
        for (final tile in mirroredTiles) {
          for (final required in puzzle.targetRequired.values) {
            if (required.face != tile.face) continue;
            // Even at the exact required rotation, a mirrored tile must
            // never satisfy CubeNetCellFace.matches.
            final asGuess = CubeNetCellFace(
              face: tile.face,
              value: tile.value,
              rotation: required.rotation,
              mirrored: true,
            );
            expect(asGuess.matches(required), isFalse);
          }
        }
      }
    },
  );

  test('every reference net cell shows a real face exactly once', () {
    final puzzle = buildCubeNetPuzzle(seed: 99, params: params, difficulty: 3);
    expect(puzzle.referenceCells.length, 6);
    final faces = puzzle.referenceCells.values.map((c) => c.face).toSet();
    expect(faces.length, 6);
  });

  test(
    'shape and mixed symbol kinds also produce a valid, solvable puzzle',
    () {
      for (final kind in CubeSymbolKind.values) {
        final puzzle = buildCubeNetPuzzle(
          seed: 3,
          params: CubeNetParams(symbolKind: kind),
          difficulty: 3,
        );
        expect(puzzle.missingCellIndices.length, 3);
        for (final slot in puzzle.missingCellIndices) {
          final required = puzzle.targetRequired[slot]!;
          expect(
            puzzle.trayTiles
                .where((t) => t.face == required.face && !t.mirrored)
                .length,
            1,
          );
        }
      }
    },
  );
}
