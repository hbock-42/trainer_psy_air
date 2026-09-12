import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'angle_board.dart';

/// `p1_angles` ("Angles à saisir", US-114, spec §2.3 row 5 / §4.1 row 5):
/// among `optionCount` candidate angle values (9 by default), select the
/// (up to `maxCorrect`) ones that match a drawn angle.
///
/// [generate] does not bake the board into the returned item: it returns
/// the `GeneratedItem` recipe itself (generatorId + seed + params), and
/// [score] (and the renderer) call [boardOf] again with that same
/// `(seed, params, difficulty)` to get the angles and candidates --
/// "engine-owned data derived again from the seed" (ARCHITECTURE.md
/// "Engine", step 1).
class P1AnglesEngine extends ActivityEngine {
  const P1AnglesEngine();

  @override
  String get familyId => 'p1_angles';

  @override
  GeneratorId? get generatorId => GeneratorId.p1Angles;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final anglesParams = params as P1AnglesParams;
    // Built once so a malformed recipe fails fast instead of surfacing only
    // when the item is displayed or scored.
    AngleBoardGenerator.build(
      params: anglesParams,
      seed: seed,
      difficulty: difficulty,
    );
    return Item.generated(
      id: ActivityEngine.generatedItemId(generatorId!, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['spatial'],
      generatorId: generatorId!,
      seed: seed,
      params: anglesParams,
      origin: ItemOrigin(generatorId: generatorId!, seed: seed),
    );
  }

  /// Correct only if the selected candidate set equals the true set;
  /// `precision`/`recall`/`selectedCount` metrics feed the section summary
  /// and analytics either way (same shape as `arithmetic_grid`'s
  /// multi-select scoring).
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    if (item is! GeneratedItem || answer is! MultiSelectAnswer) {
      return ItemResult.wrong;
    }

    final correct = boardOf(item).correctIndices;
    final selected = answer.indices.toSet();
    final truePositives = selected.intersection(correct).length;
    final precision = selected.isEmpty ? 1.0 : truePositives / selected.length;
    final recall = correct.isEmpty ? 1.0 : truePositives / correct.length;
    final isCorrect =
        selected.length == correct.length && selected.containsAll(correct);

    return ItemResult(
      correct: isCorrect,
      metrics: {
        'precision': precision,
        'recall': recall,
        'selectedCount': selected.length.toDouble(),
      },
    );
  }

  /// The concrete board [item] describes, recomputed from its seed and
  /// params (never stored on the item itself).
  static AngleBoard boardOf(GeneratedItem item) => AngleBoardGenerator.build(
    params: item.params as P1AnglesParams,
    seed: item.seed,
    difficulty: item.difficulty,
  );
}
