import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'overlay_board.dart';

/// `spatial_overlay` (spec §2.4-E, US-033): drag 3-4 tile-shapes onto a
/// central grid so that, under the overlay rules, it reproduces the target
/// grid ("Formes glissées II").
///
/// [generate] does not bake the board into the returned item: it returns
/// the `GeneratedItem` recipe itself (generatorId + seed + params), and
/// [score] (and the renderer) call [buildOverlayBoard] again with that same
/// `(seed, params, difficulty)` to get the tiles, the target and the
/// solution -- "engine-owned data derived again from the seed"
/// (ARCHITECTURE.md "Engine", step 1; the same pattern as `DominosEngine`).
///
/// The answer is `Answer.raw({'tilePositions': [...], 'moves': n})`:
/// `tilePositions` is a JSON array parallel to the board's tiles, each
/// entry either `[row, col]` (the tile's dragged top-left offset) or `null`
/// (still in the tray). `RawAnswer` is the only `Answer` case flexible
/// enough for a drag placement set -- see `answer.dart`.
class OverlayGridEngine extends ActivityEngine {
  const OverlayGridEngine();

  @override
  String get familyId => 'spatial_overlay';

  @override
  GeneratorId get generatorId => GeneratorId.overlayGrid;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final overlayParams = params as OverlayGridParams;
    // Built once so a malformed recipe (no unique solution) fails fast
    // instead of surfacing only when the item is displayed or scored.
    buildOverlayBoard(
      seed: seed,
      params: overlayParams,
      difficulty: difficulty,
    );
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.overlayGrid, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['overlay'],
      generatorId: GeneratorId.overlayGrid,
      seed: seed,
      params: overlayParams,
      origin: ItemOrigin(generatorId: GeneratorId.overlayGrid, seed: seed),
    );
  }

  /// Correct iff the tiles at `tilePositions` combine (overlay algebra) into
  /// the board's target grid; `moves` (drag count) is always reported as a
  /// metric, win or lose.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    if (item is! GeneratedItem || answer is! RawAnswer) {
      return ItemResult.wrong;
    }

    final board = boardOf(item);
    final positions = _positionsFromPayload(answer.payload, board.tiles.length);
    final working = computeWorkingGrid(
      gridRows: board.gridRows,
      gridCols: board.gridCols,
      tiles: board.tiles,
      positions: positions,
    );
    final correct = matchesTarget(working, board.target);
    final moves = (answer.payload['moves'] as num?)?.toDouble() ?? 0;
    return ItemResult(correct: correct, metrics: {'moves': moves});
  }

  /// The concrete board [item] describes, recomputed from its seed, params
  /// and difficulty (never stored on the item itself).
  static OverlayBoard boardOf(GeneratedItem item) => buildOverlayBoard(
    seed: item.seed,
    params: item.params as OverlayGridParams,
    difficulty: item.difficulty,
  );
}

/// Reads `payload['tilePositions']` back into a positions list parallel to
/// the board's tiles; anything malformed (wrong length, wrong shape) reads
/// as "not placed" rather than throwing, since a stray drag payload should
/// score wrong, not crash the session.
List<(int, int)?> _positionsFromPayload(
  Map<String, Object?> payload,
  int tileCount,
) {
  final result = List<(int, int)?>.filled(tileCount, null);
  final raw = payload['tilePositions'];
  if (raw is! List) return result;
  for (var i = 0; i < tileCount && i < raw.length; i++) {
    final entry = raw[i];
    if (entry is List && entry.length == 2) {
      final row = entry[0];
      final col = entry[1];
      if (row is num && col is num) {
        result[i] = (row.toInt(), col.toInt());
      }
    }
  }
  return result;
}
