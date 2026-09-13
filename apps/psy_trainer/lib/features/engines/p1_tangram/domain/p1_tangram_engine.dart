import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'tangram_board.dart';
import 'tangram_geometry.dart';

/// `p1_tangram` (US-109, spec §2.3-2 / §4.1 row 2): compose a target
/// silhouette from the 7 classic tangram pieces (`TangramMode.compose`),
/// or -- the 2024-only variant -- count how many small-triangle units tile
/// a shown compound figure (`TangramMode.countOccurrences`).
///
/// `compose` returns a `GeneratedItem` (the workspace/target board is
/// rebuilt by [boardOf] from `(seed, difficulty, params)`, never stored on
/// the item -- same convention as `OverlayGridEngine`/`buildOverlayBoard`);
/// its answer is `Answer.raw({'placements': [...]})`, one entry per
/// `TangramBoard.pieces` slot (`null` while still in the tray, otherwise
/// `{'rotationSteps': int, 'flipped': bool, 'dx': num, 'dy': num}`), scored
/// by rasterising the *submitted* placement and comparing it to
/// `TangramBoard.targetCells` -- any arrangement that covers exactly the
/// target counts, not just the generator's own [TangramBoard
/// .solutionPlacements].
///
/// `count_occurrences` returns a real `NumericItem` (default `Scorer
/// .scoreItem` numeric handling applies) whose board is rebuilt by
/// [recipeBoardOf] from `(origin.seed, difficulty)` and the family's
/// default `P1TangramParams` -- the same "params not carried by a bank
/// item" assumption `CountersEngine.recipeOf` documents (a blueprint
/// overriding `pieceCount` would still score correctly but draw a
/// different-sized figure than the one the item's own generation used;
/// flagged in the PR report).
class TangramEngine extends ActivityEngine {
  const TangramEngine();

  @override
  String get familyId => 'p1_tangram';

  @override
  GeneratorId get generatorId => GeneratorId.p1Tangram;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1TangramParams;
    final board = buildTangramBoard(
      seed: seed,
      params: typed,
      difficulty: difficulty,
    );
    final origin = ItemOrigin(
      generatorId: GeneratorId.p1Tangram,
      seed: seed,
      runSeed: runSeed ?? seed,
      index: index,
    );
    final id = ActivityEngine.generatedItemId(GeneratorId.p1Tangram, seed);
    return switch (typed.mode) {
      TangramMode.compose => Item.generated(
        id: id,
        version: 1,
        familyId: familyId,
        difficulty: difficulty,
        tags: const ['p1_tangram', 'compose'],
        generatorId: GeneratorId.p1Tangram,
        seed: seed,
        params: typed,
        origin: origin,
      ),
      TangramMode.countOccurrences => _countItem(id, difficulty, board, origin),
    };
  }

  static Item _countItem(
    String id,
    int difficulty,
    TangramBoard board,
    ItemOrigin origin,
  ) {
    final expected = board.smallTriangleUnitCount;
    return Item.numeric(
      id: id,
      version: 1,
      familyId: 'p1_tangram',
      difficulty: difficulty,
      tags: const ['p1_tangram', 'count_occurrences'],
      stem: const LocalizedText(
        fr:
            'Combien de fois le plus petit triangle du tangram (la moitié '
            "d'un carré) tient-il exactement dans cette figure ?",
        en:
            'How many times does the smallest tangram triangle (half a '
            'square) exactly tile this figure?',
      ),
      expected: expected,
      explanation: LocalizedText(
        fr:
            'La figure est composée de ${board.pieces.length} pièces, pour '
            'un total de $expected petits triangles.',
        en:
            'The figure is made of ${board.pieces.length} pieces, for a '
            'total of $expected small triangles.',
      ),
      origin: origin,
      tolerance: const Tolerance(mode: ToleranceMode.absolute, value: 0),
      inputFormat: InputFormat.integer,
      decimals: 0,
    );
  }

  /// `count_occurrences` (a real `NumericItem`) uses the default numeric
  /// scorer unchanged; `compose` (a `GeneratedItem`) is correct iff every
  /// board slot got an answered placement and the submitted placements'
  /// union rasterises to exactly [TangramBoard.targetCells] (no overlaps,
  /// no gaps) -- see the class doc.
  @override
  ItemResult score(Item item, Answer answer) {
    if (item is! GeneratedItem) return Scorer.scoreItem(item, answer);
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    if (answer is! RawAnswer) return ItemResult.wrong;
    final board = boardOf(item);
    final raw = answer.payload['placements'];
    if (raw is! List || raw.length != board.pieces.length) {
      return ItemResult.wrong;
    }
    final cellSets = <Set<CellIndex>>[];
    for (var i = 0; i < board.pieces.length; i++) {
      final entry = raw[i];
      if (entry is! Map) return ItemResult.wrong;
      final rotationSteps = entry['rotationSteps'];
      final flipped = entry['flipped'];
      final dx = entry['dx'];
      final dy = entry['dy'];
      if (rotationSteps is! num ||
          flipped is! bool ||
          dx is! num ||
          dy is! num) {
        return ItemResult.wrong;
      }
      final placement = PlacedPiece(
        dx: dx.toDouble(),
        dy: dy.toDouble(),
        rotationSteps: rotationSteps.toInt(),
        flipped: flipped,
      );
      cellSets.add(
        rasterisePolygon(placement.absoluteVertices(board.pieces[i])),
      );
    }
    for (var i = 0; i < cellSets.length; i++) {
      for (var j = i + 1; j < cellSets.length; j++) {
        if (cellSets[i].intersection(cellSets[j]).isNotEmpty) {
          return ItemResult.wrong;
        }
      }
    }
    final union = <CellIndex>{for (final c in cellSets) ...c};
    final correct =
        union.length == board.targetCells.length &&
        union.difference(board.targetCells).isEmpty;
    return ItemResult(correct: correct);
  }

  /// The `compose`-mode board [item] describes, recomputed from its seed,
  /// params and difficulty (never stored on the item itself).
  static TangramBoard boardOf(GeneratedItem item) => buildTangramBoard(
    seed: item.seed,
    params: item.params as P1TangramParams,
    difficulty: item.difficulty,
  );

  /// The `count_occurrences`-mode board [item] describes, recomputed from
  /// its origin's seed and the family's default params (see class doc).
  static TangramBoard recipeBoardOf(NumericItem item) => buildTangramBoard(
    seed: item.origin?.seed ?? 0,
    params:
        GeneratorParams.defaultsFor(GeneratorId.p1Tangram) as P1TangramParams,
    difficulty: item.difficulty,
  );
}
