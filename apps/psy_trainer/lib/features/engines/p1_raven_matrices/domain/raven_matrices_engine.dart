import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'matrix_board.dart';

/// `p1_raven_matrices` (spec §2.3 row 11, US-107): find the missing tile of
/// a Raven-style 3x3 figure matrix.
///
/// [generate] does not bake the puzzle into the returned item: it returns
/// the `GeneratedItem` recipe itself (generatorId + seed + params), and
/// [score] (and the renderer) call [buildMatrixBoard] again with that same
/// `(seed, params, difficulty)` to get the grid, the 8 candidates and the
/// correct index -- "engine-owned data derived again from the seed"
/// (ARCHITECTURE.md "Engine", step 1). The candidate the candidate picks is
/// scored as an `Answer.choice(index)` into `MatrixBoard.candidates`.
class RavenMatricesEngine extends ActivityEngine {
  const RavenMatricesEngine();

  @override
  String get familyId => 'p1_raven_matrices';

  @override
  GeneratorId get generatorId => GeneratorId.p1RavenMatrices;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final matrixParams = params as P1RavenMatricesParams;
    // Built once so a malformed recipe fails fast (uniqueness check) instead
    // of surfacing only when the item is displayed or scored.
    buildMatrixBoard(seed: seed, params: matrixParams, difficulty: difficulty);
    return Item.generated(
      id: ActivityEngine.generatedItemId(GeneratorId.p1RavenMatrices, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['reasoning', 'matrices'],
      generatorId: GeneratorId.p1RavenMatrices,
      seed: seed,
      params: matrixParams,
      origin: ItemOrigin(generatorId: GeneratorId.p1RavenMatrices, seed: seed),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final board = buildMatrixBoard(
      seed: generated.seed,
      params: generated.params as P1RavenMatricesParams,
      difficulty: generated.difficulty,
    );
    final correct = answer is ChoiceAnswer && answer.index == board.correctIndex;
    return ItemResult(correct: correct);
  }

  /// The board of [item], for the renderer (avoids importing
  /// `matrix_board.dart` from two different call sites out of sync).
  static MatrixBoard boardOf(GeneratedItem item) => buildMatrixBoard(
    seed: item.seed,
    params: item.params as P1RavenMatricesParams,
    difficulty: item.difficulty,
  );
}
