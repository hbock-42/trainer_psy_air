import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'arithmetic_grid.dart';

/// US-023, spec §2.4-J: a 3×3 grid of nine equalities, 0..4 of them wrong;
/// the candidate taps the wrong ones then validates.
///
/// `generate` returns a [GeneratedItem]: the concrete grid is never stored
/// on the item, it is engine-owned data the scorer and the renderer both
/// recompute from `(params, seed, difficulty)` through [gridOf] /
/// [ArithmeticGridGenerator.build].
class ArithmeticGridEngine extends ActivityEngine {
  const ArithmeticGridEngine();

  @override
  String get familyId => 'arithmetic_grid';

  @override
  GeneratorId? get generatorId => GeneratorId.arithmeticGrid;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final gridParams = params as ArithmeticGridParams;
    return Item.generated(
      id: ActivityEngine.generatedItemId(generatorId!, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['arith'],
      generatorId: generatorId!,
      seed: seed,
      params: gridParams,
      origin: ItemOrigin(generatorId: generatorId!, seed: seed),
    );
  }

  /// Grid correct only if the selected set equals the wrong set;
  /// `precision`/`recall`/`selectedCount` metrics feed the section summary
  /// and analytics either way.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    if (item is! GeneratedItem || answer is! MultiSelectAnswer) {
      return ItemResult.wrong;
    }

    final wrong = gridOf(item).wrongIndices;
    final selected = answer.indices.toSet();
    final truePositives = selected.intersection(wrong).length;
    final precision = selected.isEmpty ? 1.0 : truePositives / selected.length;
    final recall = wrong.isEmpty ? 1.0 : truePositives / wrong.length;
    final isCorrect =
        selected.length == wrong.length && selected.containsAll(wrong);

    return ItemResult(
      correct: isCorrect,
      metrics: {
        'precision': precision,
        'recall': recall,
        'selectedCount': selected.length.toDouble(),
      },
    );
  }

  /// The concrete grid [item] describes, recomputed from its seed and
  /// params (never stored on the item itself).
  static ArithmeticGrid gridOf(GeneratedItem item) =>
      ArithmeticGridGenerator.build(
        params: item.params as ArithmeticGridParams,
        seed: item.seed,
        difficulty: item.difficulty,
      );
}
