import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'overlay_algebra.dart';
import 'overlay_tile.dart';

/// A generated overlay-grid puzzle (spec §2.4-E, US-033): [tiles] dragged
/// onto a [gridRows] x [gridCols] grid must reproduce [target] -- and only
/// [solutionPositions] does, proven by brute-force search over every
/// placement of every tile.
///
/// Nothing here is stored on the `GeneratedItem` the engine returns: the
/// renderer and the scorer both call [buildOverlayBoard] again with the
/// same `(seed, params, difficulty)` and get back the same board
/// (ARCHITECTURE.md "Engine", "keep the stimulus in engine-owned data
/// derived again from the seed" -- the same approach as `DominosEngine` /
/// `buildDominoBoard`).
class OverlayBoard {
  const OverlayBoard({
    required this.gridRows,
    required this.gridCols,
    required this.tiles,
    required this.solutionPositions,
    required this.target,
    required this.overlapCellCount,
    required this.blackCellCount,
  });

  final int gridRows;
  final int gridCols;

  /// The 3-4 draggable tiles, in tray order.
  final List<TileShape> tiles;

  /// The generator's own placement -- one top-left offset per tile,
  /// parallel to [tiles] -- proven the *only* placement set that produces
  /// [target]. Exposed for the practice explanation ("shows the solution
  /// placement").
  final List<(int, int)> solutionPositions;

  /// Row-major, length `gridRows * gridCols`.
  final List<TargetCell> target;

  /// How many grid cells [solutionPositions] covers with 2+ tiles.
  final int overlapCellCount;
  final int blackCellCount;
}

/// The colour every cell of a [gridRows] x [gridCols] grid shows once
/// [tiles] are placed at [positions] (`null` for a tile still in the tray,
/// or dropped nowhere -- it contributes nothing). Shared by the generator's
/// solver, the scorer and the renderer's live preview.
List<CellColour> computeWorkingGrid({
  required int gridRows,
  required int gridCols,
  required List<TileShape> tiles,
  required List<(int, int)?> positions,
}) {
  final size = gridRows * gridCols;
  final coverCount = List<int>.filled(size, 0);
  final greyCount = List<int>.filled(size, 0);
  for (var i = 0; i < tiles.length; i++) {
    final pos = positions[i];
    if (pos == null) continue;
    final (baseRow, baseCol) = pos;
    for (final (dr, dc, colour) in tiles[i].offsets) {
      final idx = (baseRow + dr) * gridCols + (baseCol + dc);
      coverCount[idx]++;
      if (colour == CellColour.grey) greyCount[idx]++;
    }
  }
  return [
    for (var i = 0; i < size; i++)
      combineCoverage(coverCount: coverCount[i], greyCount: greyCount[i]),
  ];
}

/// Whether every cell of [working] satisfies the matching cell of [target].
bool matchesTarget(List<CellColour> working, List<TargetCell> target) {
  for (var i = 0; i < working.length; i++) {
    if (!target[i].matches(working[i])) return false;
  }
  return true;
}

int _clampInt(int value, int min, int max) =>
    value < min ? min : (value > max ? max : value);

/// Builds the board of the recipe `(seed, params, difficulty)`.
///
/// Deterministic: same inputs, same board (same `Random(seed)` sequence).
/// `difficulty` (1..5) scales the three levers the story calls out --
/// tile count, overlap amount, black-cell count -- and a brute-force
/// solver over every placement of every tile only accepts a board with
/// exactly one solution (the one just built); an accidental ambiguity
/// (rare, but possible with small grids) draws a fresh board from the same
/// seeded sequence instead of being shipped -- the same guarantee
/// `buildDominoBoard` gives `logic_dominos`.
OverlayBoard buildOverlayBoard({
  required int seed,
  required OverlayGridParams params,
  required int difficulty,
}) {
  final rng = Random(seed);
  final gridRows = params.grid.rows;
  final gridCols = params.grid.cols;

  // Version II is "3 to 4 tiles" (spec §2.4-E): the base count from params,
  // one more at the top of the difficulty range.
  final tileCount = _clampInt(
    params.tileCount + (difficulty >= 5 ? 1 : 0),
    2,
    6,
  );
  // How many grid cells the solution should cover twice or more.
  final targetOverlap = params.overlapping ? _clampInt(difficulty, 1, 5) : 0;
  // How many uncovered cells of the solution become black-cell constraints.
  final blackCellTarget = params.blackCells
      ? _clampInt((difficulty - 1) ~/ 2, 0, 4)
      : 0;

  const maxOuterAttempts = 60;
  const maxPositionAttempts = 200;

  for (var outer = 0; outer < maxOuterAttempts; outer++) {
    final tiles = _generateDistinctTiles(
      rng,
      count: tileCount,
      maxRows: gridRows,
      maxCols: gridCols,
    );
    final positionsPerTile = [
      for (final tile in tiles) tile.positionsIn(gridRows, gridCols),
    ];

    // `params.overlapping == false` asks for exactly zero overlapped cells
    // (the "closer to 0 is better" search below), not "at least 0" -- which
    // every attempt trivially satisfies.
    List<(int, int)>? bestPositions;
    var bestOverlap = params.overlapping ? -1 : 1 << 30;
    for (var attempt = 0; attempt < maxPositionAttempts; attempt++) {
      final positions = [
        for (final options in positionsPerTile)
          options[rng.nextInt(options.length)],
      ];
      final coverCount = List<int>.filled(gridRows * gridCols, 0);
      for (var i = 0; i < tiles.length; i++) {
        final (baseRow, baseCol) = positions[i];
        for (final (dr, dc, _) in tiles[i].offsets) {
          coverCount[(baseRow + dr) * gridCols + (baseCol + dc)]++;
        }
      }
      final overlap = coverCount.where((c) => c >= 2).length;
      if (params.overlapping) {
        if (overlap >= targetOverlap) {
          bestPositions = positions;
          bestOverlap = overlap;
          break;
        }
        if (overlap > bestOverlap) {
          bestOverlap = overlap;
          bestPositions = positions;
        }
      } else {
        if (overlap == 0) {
          bestPositions = positions;
          bestOverlap = 0;
          break;
        }
        if (overlap < bestOverlap) {
          bestOverlap = overlap;
          bestPositions = positions;
        }
      }
    }
    final positions = bestPositions!;

    final working = computeWorkingGrid(
      gridRows: gridRows,
      gridCols: gridCols,
      tiles: tiles,
      positions: positions,
    );

    final uncoveredIdx = [
      for (var i = 0; i < working.length; i++)
        if (working[i] == CellColour.none) i,
    ]..shuffle(rng);
    final chosenBlack = uncoveredIdx.take(blackCellTarget).toSet();

    final target = [
      for (var i = 0; i < working.length; i++)
        switch (working[i]) {
          CellColour.navy => TargetCell.navy,
          CellColour.grey => TargetCell.grey,
          CellColour.none =>
            chosenBlack.contains(i) ? TargetCell.black : TargetCell.empty,
        },
    ];

    final solutions = _countSolutions(
      tiles,
      positionsPerTile,
      gridRows,
      gridCols,
      target,
      cutoff: 2,
    );
    if (solutions == 1) {
      return OverlayBoard(
        gridRows: gridRows,
        gridCols: gridCols,
        tiles: tiles,
        solutionPositions: positions,
        target: target,
        overlapCellCount: bestOverlap,
        blackCellCount: chosenBlack.length,
      );
    }
  }
  throw StateError(
    'overlay_grid: no unique board found after $maxOuterAttempts attempts '
    '(seed=$seed, tileCount=$tileCount, difficulty=$difficulty)',
  );
}

/// Counts placement sets of [tiles] (one position per tile, drawn from
/// [positionsPerTile]) that reproduce [target], stopping as soon as
/// [cutoff] is reached (the generator only needs to know "exactly one" vs.
/// "more than one").
int _countSolutions(
  List<TileShape> tiles,
  List<List<(int, int)>> positionsPerTile,
  int gridRows,
  int gridCols,
  List<TargetCell> target, {
  required int cutoff,
}) {
  var count = 0;
  final chosen = List<(int, int)?>.filled(tiles.length, null);

  void recurse(int i) {
    if (count >= cutoff) return;
    if (i == tiles.length) {
      final working = computeWorkingGrid(
        gridRows: gridRows,
        gridCols: gridCols,
        tiles: tiles,
        positions: chosen,
      );
      if (matchesTarget(working, target)) count++;
      return;
    }
    for (final pos in positionsPerTile[i]) {
      if (count >= cutoff) return;
      chosen[i] = pos;
      recurse(i + 1);
    }
  }

  recurse(0);
  return count;
}

/// [count] tile shapes, no two structurally identical (identical tiles
/// would let the solver "solve" a board by swapping their positions,
/// defeating the uniqueness proof above).
List<TileShape> _generateDistinctTiles(
  Random rng, {
  required int count,
  required int maxRows,
  required int maxCols,
}) {
  final tiles = <TileShape>[];
  var guard = 0;
  while (tiles.length < count && guard < 1000) {
    guard++;
    final shape = _randomTileShape(rng, maxRows: maxRows, maxCols: maxCols);
    if (tiles.contains(shape)) continue;
    tiles.add(shape);
  }
  if (tiles.length < count) {
    throw StateError('overlay_grid: could not generate $count distinct tiles');
  }
  return tiles;
}

const _directions = [Point(0, 1), Point(0, -1), Point(1, 0), Point(-1, 0)];

/// A small (2-4 cell) connected polyomino, grown by a random walk and
/// bounded to fit inside [maxRows] x [maxCols], each cell coloured navy or
/// grey.
TileShape _randomTileShape(
  Random rng, {
  required int maxRows,
  required int maxCols,
}) {
  final targetCellCount = 2 + rng.nextInt(3); // 2..4 cells
  var cells = <Point<int>>{const Point(0, 0)};
  var guard = 0;
  while (cells.length < targetCellCount && guard < 200) {
    guard++;
    final base = cells.elementAt(rng.nextInt(cells.length));
    final dir = _directions[rng.nextInt(_directions.length)];
    final next = Point(base.x + dir.x, base.y + dir.y);
    final trial = {...cells, next};
    final minR = trial.map((p) => p.x).reduce(min);
    final maxR = trial.map((p) => p.x).reduce(max);
    final minC = trial.map((p) => p.y).reduce(min);
    final maxC = trial.map((p) => p.y).reduce(max);
    if (maxR - minR + 1 > maxRows || maxC - minC + 1 > maxCols) continue;
    cells = trial;
  }

  final minR = cells.map((p) => p.x).reduce(min);
  final minC = cells.map((p) => p.y).reduce(min);
  final normalized = {for (final p in cells) Point(p.x - minR, p.y - minC)};
  final rows = normalized.map((p) => p.x).reduce(max) + 1;
  final cols = normalized.map((p) => p.y).reduce(max) + 1;
  final grid = List.generate(rows, (_) => List<CellColour?>.filled(cols, null));
  for (final p in normalized) {
    grid[p.x][p.y] = rng.nextBool() ? CellColour.navy : CellColour.grey;
  }
  return TileShape(rows: rows, cols: cols, cells: grid);
}
