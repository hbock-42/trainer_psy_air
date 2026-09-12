import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_algebra.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_board.dart';

void main() {
  const defaultParams = GeneratorParams.overlayGrid();

  OverlayBoard build({
    GeneratorParams params = defaultParams,
    int seed = 1,
    int difficulty = 3,
  }) => buildOverlayBoard(
    seed: seed,
    params: params as OverlayGridParams,
    difficulty: difficulty,
  );

  /// Every placement in [board.solutionPositions] paired with its tile;
  /// re-derived so tests never assume the internal search order.
  bool solutionMatchesTarget(OverlayBoard board) {
    final working = computeWorkingGrid(
      gridRows: board.gridRows,
      gridCols: board.gridCols,
      tiles: board.tiles,
      positions: board.solutionPositions,
    );
    return matchesTarget(working, board.target);
  }

  group('buildOverlayBoard', () {
    test('is deterministic: same params/seed/difficulty, same board', () {
      final a = build(seed: 42, difficulty: 4);
      final b = build(seed: 42, difficulty: 4);
      expect(a.target, b.target);
      expect(a.solutionPositions, b.solutionPositions);
      expect(a.tiles.length, b.tiles.length);
      for (var i = 0; i < a.tiles.length; i++) {
        expect(a.tiles[i], b.tiles[i]);
      }
    });

    test('a different seed usually yields a different board', () {
      final a = build();
      final b = build(seed: 2);
      expect(a.target, isNot(b.target));
    });

    test('the generator-s own solution actually reproduces the target', () {
      for (var seed = 0; seed < 100; seed++) {
        final board = build(seed: seed);
        expect(solutionMatchesTarget(board), isTrue, reason: 'seed=$seed');
      }
    });

    test('the solution placement is unique: no other combination of '
        'positions also reproduces the target, over many seeds', () {
      for (var seed = 0; seed < 150; seed++) {
        final board = build(seed: seed, difficulty: 1 + seed % 5);
        final positionsPerTile = [
          for (final tile in board.tiles)
            tile.positionsIn(board.gridRows, board.gridCols),
        ];
        var solutions = 0;
        void recurse(int i, List<(int, int)?> chosen) {
          if (solutions > 1) return;
          if (i == board.tiles.length) {
            final working = computeWorkingGrid(
              gridRows: board.gridRows,
              gridCols: board.gridCols,
              tiles: board.tiles,
              positions: chosen,
            );
            if (matchesTarget(working, board.target)) solutions++;
            return;
          }
          for (final pos in positionsPerTile[i]) {
            if (solutions > 1) return;
            recurse(i + 1, [...chosen, pos]);
          }
        }

        recurse(0, []);
        expect(solutions, 1, reason: 'seed=$seed difficulty=${board.target}');
      }
    });

    test('respects a custom grid size and tile count', () {
      // tileCount left at its default (3): this test is about the grid
      // size, not the tile count.
      const params = GeneratorParams.overlayGrid(
        grid: GridSize(rows: 4, cols: 4),
      );
      for (var seed = 0; seed < 20; seed++) {
        final board = build(params: params, seed: seed, difficulty: 1);
        expect(board.gridRows, 4);
        expect(board.gridCols, 4);
        expect(board.target, hasLength(16));
        expect(board.tiles.length, inInclusiveRange(3, 4));
      }
    });

    test('difficulty 5 adds a tile: tile count is 3 below it, 4 at it', () {
      // tileCount left at its default (3), the base this test scales from.
      for (var seed = 0; seed < 15; seed++) {
        final low = build(seed: seed, difficulty: 4);
        final high = build(seed: seed, difficulty: 5);
        expect(low.tiles.length, 3);
        expect(high.tiles.length, 4);
      }
    });

    test('overlapping: false never produces an overlapped cell', () {
      const params = GeneratorParams.overlayGrid(overlapping: false);
      for (var seed = 0; seed < 30; seed++) {
        final board = build(params: params, seed: seed, difficulty: 5);
        expect(board.overlapCellCount, 0);
      }
    });

    test('blackCells: false never marks a black cell', () {
      const params = GeneratorParams.overlayGrid(blackCells: false);
      for (var seed = 0; seed < 30; seed++) {
        final board = build(params: params, seed: seed, difficulty: 5);
        expect(board.blackCellCount, 0);
        expect(board.target, isNot(contains(TargetCell.black)));
      }
    });

    test('tiles never rotate: every tile keeps its own bounding box within '
        'the grid bounds used to build positionsIn', () {
      final board = build(seed: 3);
      for (final tile in board.tiles) {
        expect(tile.rows, greaterThan(0));
        expect(tile.cols, greaterThan(0));
        expect(tile.rows, lessThanOrEqualTo(board.gridRows));
        expect(tile.cols, lessThanOrEqualTo(board.gridCols));
      }
    });

    test('no two tiles of the same board are structurally identical '
        '(would make the "unique placement" solution ambiguous by swap)', () {
      for (var seed = 0; seed < 100; seed++) {
        final board = build(seed: seed, difficulty: 5);
        for (var i = 0; i < board.tiles.length; i++) {
          for (var j = i + 1; j < board.tiles.length; j++) {
            expect(
              board.tiles[i] == board.tiles[j],
              isFalse,
              reason: 'seed=$seed tiles $i,$j',
            );
          }
        }
      }
    });
  });

  group('computeWorkingGrid / matchesTarget', () {
    test('an unplaced tile (null position) contributes nothing', () {
      final board = build(seed: 5);
      final positions = List<(int, int)?>.filled(board.tiles.length, null);
      final working = computeWorkingGrid(
        gridRows: board.gridRows,
        gridCols: board.gridCols,
        tiles: board.tiles,
        positions: positions,
      );
      expect(working, everyElement(CellColour.none));
      expect(matchesTarget(working, board.target), isFalse);
    });
  });
}
