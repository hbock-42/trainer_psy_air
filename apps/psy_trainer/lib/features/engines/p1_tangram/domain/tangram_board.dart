import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'tangram_geometry.dart';
import 'tangram_piece.dart';

/// One piece's placement on the board: `rotationSteps * 45°` CCW rotation
/// (applied after an optional flip), then a translation. See
/// `transformPolygon` for the exact order.
class PlacedPiece {
  const PlacedPiece({
    required this.dx,
    required this.dy,
    required this.rotationSteps,
    this.flipped = false,
  });

  final double dx;
  final double dy;
  final int rotationSteps;
  final bool flipped;

  List<Point2> absoluteVertices(TangramPiece piece) => transformPolygon(
    piece.vertices,
    dx: dx,
    dy: dy,
    rotationSteps: rotationSteps,
    flipped: flipped,
  );
}

/// A generated tangram figure (spec §2.3-2, US-109): [pieces] (a subset of
/// [TangramPieces.all], 3 to 7 of them per difficulty) assembled by
/// [solutionPlacements] into one connected shape, [targetCells] the
/// rasterised union that shape covers.
///
/// Nothing here is stored on the `Item` the engine returns for `compose`
/// mode (a `GeneratedItem`, `params`/`seed`/`difficulty` only) or for
/// `count_occurrences` mode (a plain `NumericItem`): both the renderer and
/// the scorer rebuild the same board from `(seed, difficulty, params)` via
/// `TangramEngine.boardOf` / `.recipeBoardOf` -- same "engine-owned data
/// derived again from the seed" convention as `OverlayGridEngine` /
/// `CountersEngine`.
///
/// `compose` mode's target position is fixed in *board coordinates*: the
/// renderer draws the workspace grid in the same coordinate system as
/// [targetCells], so a correct answer is any placement set whose own
/// rasterised union exactly equals [targetCells] -- not a match against
/// [solutionPlacements] itself (any piece that is its own mirror/rotation
/// twin, or either of the 2 congruent small/large triangles swapped, is
/// just as correct). See `p1_tangram_engine.dart`'s `score`.
class TangramBoard {
  const TangramBoard({
    required this.pieces,
    required this.solutionPlacements,
    required this.targetCells,
    required this.hideInternalEdges,
    required this.minX,
    required this.minY,
    required this.maxX,
    required this.maxY,
  });

  /// The pieces used by this board, in tray order.
  final List<TangramPiece> pieces;

  /// The generator's own placement, parallel to [pieces].
  final List<PlacedPiece> solutionPlacements;

  /// The rasterised union [solutionPlacements] covers (board coordinates,
  /// `rasterisePolygon` cells).
  final Set<CellIndex> targetCells;

  /// Whether the renderer should hide the boundaries between pieces inside
  /// the silhouette (higher difficulty: only the outer outline is a hint;
  /// see `TangramRecipe.build`'s difficulty mapping).
  final bool hideInternalEdges;

  /// Board-coordinate bounding box (a small margin around every placed
  /// piece), for the renderer's canvas scale.
  final double minX;
  final double minY;
  final double maxX;
  final double maxY;

  /// How many `smallTriangleArea` units the whole figure is made of --
  /// always a whole number since every piece's own area is (see
  /// `TangramPieces` doc). `count_occurrences` mode's expected answer.
  int get smallTriangleUnitCount {
    final totalArea = pieces.fold(0.0, (sum, p) => sum + p.area);
    return (totalArea / TangramPieces.smallTriangleArea).round();
  }

  /// How many of [pieces] are a small triangle (0, 1 or 2) -- the
  /// alternative `count_occurrences` question ("how many of the small
  /// triangle piece itself did we use"), kept alongside
  /// [smallTriangleUnitCount] for `TangramRecipe` to pick from.
  int get smallTriangleCount =>
      pieces.where((p) => p.kind.isSmallTriangle).length;
}

/// Builds the [TangramBoard] of the recipe `(seed, difficulty, params)`:
/// deterministic (same inputs, same board), 3-7 of the 7 classic pieces
/// (whichever [P1TangramParams.pieceCount] and `difficulty` allow)
/// assembled into one connected, non-overlapping figure.
///
/// The assembly is a rejection-sampling walk: each new piece tries every
/// `(rotationSteps, flipped)` orientation and every pair of (its own
/// vertex, an already-placed vertex) as a candidate translation -- the
/// translation that makes those two vertices coincide -- and accepts the
/// first candidate whose rasterised cells neither overlap the figure so
/// far nor touch it only at a corner (`cellsShareEdge`). Real tangram
/// pieces tile edge-to-edge at 45°-compatible angles readily enough that
/// this almost always succeeds on the first piece or two; a piece that
/// exhausts every candidate is simply skipped (the board then uses fewer
/// pieces than requested) rather than restarting the whole draw, so
/// [TangramBoard.pieces] can be shorter than `pieceCount` in rare cases --
/// documented in the PR report as a known, bounded deviation.
TangramBoard buildTangramBoard({
  required int seed,
  required P1TangramParams params,
  required int difficulty,
}) {
  final rng = Random(seed);
  final level = difficulty.clamp(minDifficulty, maxDifficulty);
  // Difficulty maps to piece count (spec: "3 to 7 pieces"), capped by the
  // family's own `pieceCount` param.
  final requestedCount = (level + 2).clamp(3, params.pieceCount.clamp(3, 7));

  final pool = List<TangramPiece>.of(TangramPieces.all)..shuffle(rng);
  final chosen = pool.take(requestedCount).toList();

  final placedPieces = <TangramPiece>[];
  final placements = <PlacedPiece>[];
  final cellSets = <Set<CellIndex>>[];
  final placedVertices = <Point2>[];

  for (final piece in chosen) {
    final placement = placedPieces.isEmpty
        ? PlacedPiece(dx: 0, dy: 0, rotationSteps: rng.nextInt(8))
        : _attach(rng, piece, placedVertices, cellSets);
    if (placement == null) continue; // see doc comment: skip, don't restart.
    final cells = rasterisePolygon(placement.absoluteVertices(piece));
    placedPieces.add(piece);
    placements.add(placement);
    cellSets.add(cells);
    placedVertices.addAll(placement.absoluteVertices(piece));
  }

  final targetCells = <CellIndex>{for (final c in cellSets) ...c};
  var minX = 0.0, minY = 0.0, maxX = 0.0, maxY = 0.0;
  if (placedVertices.isNotEmpty) {
    minX = placedVertices.map((p) => p.$1).reduce(min);
    minY = placedVertices.map((p) => p.$2).reduce(min);
    maxX = placedVertices.map((p) => p.$1).reduce(max);
    maxY = placedVertices.map((p) => p.$2).reduce(max);
  }

  return TangramBoard(
    pieces: placedPieces,
    solutionPlacements: placements,
    targetCells: targetCells,
    hideInternalEdges: level >= 4,
    minX: minX,
    minY: minY,
    maxX: maxX,
    maxY: maxY,
  );
}

/// Tries to attach [piece] to the figure described by [placedVertices] (all
/// vertices placed so far) / [cellSets] (their rasterised cells, one set
/// per already-placed piece); returns null when no orientation/vertex pair
/// attaches without overlapping or corner-only touching.
PlacedPiece? _attach(
  Random rng,
  TangramPiece piece,
  List<Point2> placedVertices,
  List<Set<CellIndex>> cellSets,
) {
  final existingCells = <CellIndex>{for (final c in cellSets) ...c};
  final rotations = List<int>.generate(8, (i) => i)..shuffle(rng);
  final flips = piece.canFlip ? ([false, true]..shuffle(rng)) : [false];
  final anchors = List<Point2>.of(placedVertices)..shuffle(rng);

  for (final flip in flips) {
    for (final rotationSteps in rotations) {
      final oriented = transformPolygon(
        piece.vertices,
        dx: 0,
        dy: 0,
        rotationSteps: rotationSteps,
        flipped: flip,
      );
      final ownVertices = List<Point2>.of(oriented)..shuffle(rng);
      for (final ownVertex in ownVertices) {
        for (final anchor in anchors) {
          final dx = anchor.$1 - ownVertex.$1;
          final dy = anchor.$2 - ownVertex.$2;
          final candidate = [for (final (x, y) in oriented) (x + dx, y + dy)];
          final candidateCells = rasterisePolygon(candidate);
          if (candidateCells.intersection(existingCells).isNotEmpty) continue;
          if (!cellsShareEdge(candidateCells, existingCells)) continue;
          return PlacedPiece(
            dx: dx,
            dy: dy,
            rotationSteps: rotationSteps,
            flipped: flip,
          );
        }
      }
    }
  }
  return null;
}
