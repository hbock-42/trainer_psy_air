import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'mental_arithmetic.dart';

/// `p1_mental_arithmetic` ("Calcul mental 1-4", spec §2.3/§4.1 row 12,
/// US-105): the same underlying mental-arithmetic generator as PSY0's
/// `arithmetic_grid`, graded over four answer-format modes that get
/// progressively more demanding — free numeric response, solve-for-x
/// equations, pick the tightest interval containing the value, select
/// every interval that contains it.
///
/// Three of the four modes are plain self-scoring items (`NumericItem` for
/// `freeNumeric`/`equation`, `McqItem` for `smallestInterval`) so the
/// default [Scorer.scoreItem] handles them; only `allIntervals` needs a
/// [GeneratedItem] (its answer is a [MultiSelectAnswer], which no concrete
/// `Item` case models) — the same reason `arithmetic_grid` always returns
/// a `GeneratedItem`. [problemOf] recomputes it from `origin` the same way
/// `NbackEngine.stimulusOf` does (ARCHITECTURE.md "Engine", step 1).
class MentalArithmeticEngine extends ActivityEngine {
  const MentalArithmeticEngine();

  @override
  String get familyId => 'p1_mental_arithmetic';

  @override
  GeneratorId? get generatorId => GeneratorId.p1MentalArithmetic;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1MentalArithmeticParams;
    final problem = MentalArithmeticGenerator.build(
      params: typed,
      seed: seed,
      difficulty: difficulty,
      index: index,
    );
    final origin = ItemOrigin(
      generatorId: GeneratorId.p1MentalArithmetic,
      seed: seed,
      runSeed: runSeed ?? seed,
      index: index,
    );
    final id = ActivityEngine.generatedItemId(
      GeneratorId.p1MentalArithmetic,
      seed,
    );

    return switch (problem.mode) {
      MentalArithmeticAnswerMode.freeNumeric ||
      MentalArithmeticAnswerMode.equation => _numericItem(
        id: id,
        difficulty: difficulty,
        problem: problem,
        origin: origin,
      ),
      MentalArithmeticAnswerMode.smallestInterval => _mcqItem(
        id: id,
        difficulty: difficulty,
        problem: problem,
        origin: origin,
      ),
      MentalArithmeticAnswerMode.allIntervals => Item.generated(
        id: id,
        version: 1,
        familyId: familyId,
        difficulty: difficulty,
        tags: const ['mental_arithmetic', 'all_intervals'],
        generatorId: GeneratorId.p1MentalArithmetic,
        seed: seed,
        params: typed,
        origin: origin,
      ),
    };
  }

  Item _numericItem({
    required String id,
    required int difficulty,
    required MentalArithmeticProblem problem,
    required ItemOrigin origin,
  }) {
    final isEquation = problem.mode == MentalArithmeticAnswerMode.equation;
    final stem = isEquation
        ? LocalizedText(
            fr: '${problem.expression}\nx = ?',
            en: '${problem.expression}\nx = ?',
          )
        : LocalizedText(
            fr: '${problem.expression} = ?',
            en: '${problem.expression} = ?',
          );
    final explanation = LocalizedText(
      fr: isEquation
          ? 'x = ${problem.trueValue}.'
          : '${problem.expression} = ${problem.trueValue}.',
      en: isEquation
          ? 'x = ${problem.trueValue}.'
          : '${problem.expression} = ${problem.trueValue}.',
    );
    return Item.numeric(
      id: id,
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['mental_arithmetic'],
      stem: stem,
      expected: problem.trueValue,
      explanation: explanation,
      origin: origin,
      inputFormat: InputFormat.integer,
      decimals: 0,
    );
  }

  Item _mcqItem({
    required String id,
    required int difficulty,
    required MentalArithmeticProblem problem,
    required ItemOrigin origin,
  }) {
    final options = [
      for (final interval in problem.intervals)
        McqOption(
          text: LocalizedText(fr: interval.label, en: interval.label),
        ),
    ];
    return Item.mcq(
      id: id,
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['mental_arithmetic', 'smallest_interval'],
      stem: LocalizedText(
        fr:
            '${problem.expression} = ?\nQuel est l\'intervalle le plus '
            'étroit contenant la valeur exacte ?',
        en:
            '${problem.expression} = ?\nWhich is the tightest interval '
            'containing the exact value?',
      ),
      options: options,
      correctIndex: problem.tightestIndex!,
      explanation: LocalizedText(
        fr: 'La valeur exacte est ${problem.trueValue}.',
        en: 'The exact value is ${problem.trueValue}.',
      ),
      origin: origin,
      shuffleOptions: false,
    );
  }

  /// The [MentalArithmeticProblem] a materialised `allIntervals`
  /// [GeneratedItem] describes, recomputed from its `origin` (never stored
  /// on the item itself); used by the renderer and by [score]. Falls back
  /// to `index = 0` when `origin` carries none (a direct `generate()` call
  /// in a unit test).
  static MentalArithmeticProblem problemOf(GeneratedItem item) =>
      MentalArithmeticGenerator.build(
        params: item.params as P1MentalArithmeticParams,
        seed: item.seed,
        difficulty: item.difficulty,
        index: item.origin?.index ?? 0,
      );

  /// Only the `allIntervals` mode reaches this (a [GeneratedItem]); the
  /// other three modes are concrete `McqItem`/`NumericItem`s scored by the
  /// default [Scorer.scoreItem]. Correct only if the selected set equals
  /// exactly the set of intervals that contain the true value;
  /// `precision`/`recall`/`selectedCount` metrics mirror
  /// `ArithmeticGridEngine.score`.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    if (item is! GeneratedItem || answer is! MultiSelectAnswer) {
      return Scorer.scoreItem(item, answer);
    }

    final problem = problemOf(item);
    final containing = problem.containingIndices;
    final selected = answer.indices.toSet();
    final truePositives = selected.intersection(containing).length;
    final precision = selected.isEmpty ? 1.0 : truePositives / selected.length;
    final recall = containing.isEmpty ? 1.0 : truePositives / containing.length;
    final isCorrect =
        selected.length == containing.length &&
        selected.containsAll(containing);

    return ItemResult(
      correct: isCorrect,
      metrics: {
        'precision': precision,
        'recall': recall,
        'selectedCount': selected.length.toDouble(),
      },
    );
  }
}
