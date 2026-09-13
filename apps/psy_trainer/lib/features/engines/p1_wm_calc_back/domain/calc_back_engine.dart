import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';

/// `p1_wm_calc_back` (spec §2.3-10, "calcul memory back", US-106): a chain
/// of simple calculations where item *i*'s answer combines a freshly-shown
/// operand with the *result* of item `i - n`, `n` being the current stage
/// (1..4). Modelled as one continuous stream, exactly like `memory_nback`'s
/// `NbackSequence` (`docs/ARCHITECTURE.md#engine`, "runSeed/index"): the
/// whole chain of results is recomputed from `Random(runSeed)` up to the
/// item's own `index`, so item *i*'s back-reference is checked against the
/// value the run *actually* produced at `i - n`, not a private
/// per-item simulation. One `GeneratedItem` per calculation (80 items for
/// the real test's "4 stages x 20+ calcs", matching `family.json`'s
/// `defaultItemCount`); [CalcBackChain.stageOf] derives the stage of item
/// *i* from its position alone (`i ~/ calcsPerStage + 1`, clamped to
/// `stageCount`), so the family plays correctly whatever `count` an actual
/// run asks for (a shorter practice run just never reaches the later
/// stages).
///
/// The first `n` items of stage 1 (`n == 1`, so only item 0) have no real
/// back-reference yet; rather than a `memory_nback`-style "primer scored
/// neutrally" (this family has no natural "any answer is fine" moment --
/// the spec never mentions one), item 0's missing back-reference is treated
/// as a known baseline of 0: its calculation is simply "operand op 0", a
/// warm-up the candidate can answer without having memorised anything yet.
/// Every later item (stage 2 starts at index `calcsPerStage`, always well
/// past its own `n`) has a genuine, memorised back-reference.
class CalcBackEngine extends ActivityEngine {
  const CalcBackEngine();

  @override
  String get familyId => 'p1_wm_calc_back';

  @override
  GeneratorId? get generatorId => GeneratorId.p1WmCalcBack;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1WmCalcBackParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.p1WmCalcBack, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['memory', 'numerical'],
      generatorId: GeneratorId.p1WmCalcBack,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.p1WmCalcBack,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  /// The decoded chain step of a materialised `GeneratedItem` of this
  /// family; used by the renderer and by [score]. Reads `runSeed`/`index`
  /// off `origin` (always set by [generate]); a direct `generate()` call
  /// with neither (a unit test) falls back to `runSeed = seed`, `index = 0`
  /// -- the first item of its own single-item run.
  static CalcBackStep stepOf(GeneratedItem item) {
    final origin = item.origin;
    final chain = CalcBackChain.build(
      item.params as P1WmCalcBackParams,
      origin?.runSeed ?? item.seed,
      upTo: (origin?.index ?? 0) + 1,
    );
    return chain.steps.last;
  }

  /// Correct iff the numeric answer is exactly the chained result (the
  /// operand combined with the memorised back-reference, or with the
  /// baseline 0 for item 0). Metrics are per stage (spec: "scorer accuracy
  /// per stage").
  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final step = stepOf(generated);
    final correct = answer is NumericAnswer && answer.value == step.result;
    return ItemResult(
      correct: correct,
      metrics: {
        CalcBackMetrics.attemptsAtStage(step.stage): 1,
        if (correct) CalcBackMetrics.correctAtStage(step.stage): 1,
      },
    );
  }
}

/// `+` or `-` between the shown operand and the back-referenced result.
enum CalcBackOp {
  add,
  subtract;

  String get symbol => this == CalcBackOp.add ? '+' : '−';

  int apply(int left, int right) =>
      this == CalcBackOp.add ? left + right : left - right;
}

/// One decoded step of the chain: what to show and the expected answer.
class CalcBackStep {
  const CalcBackStep({
    required this.index,
    required this.stage,
    required this.operand,
    required this.op,
    required this.backIndex,
    required this.backValue,
    required this.result,
  });

  /// This step's position in the continuous run.
  final int index;

  /// 1-based stage this step belongs to (spec: "4 stages of increasing
  /// load", `n = stage`).
  final int stage;

  /// The freshly-drawn number shown this step.
  final int operand;

  final CalcBackOp op;

  /// The position `stage` steps back this result is chained from, or `-1`
  /// for the run's first step (no back-reference exists yet; [backValue] is
  /// the baseline 0).
  final int backIndex;

  /// The value referenced from `backIndex` (0 for the baseline case).
  final int backValue;

  /// `op.apply(operand, backValue)`, clamped to [CalcBackChain.resultFloor]
  /// / [CalcBackChain.resultCeiling] so the chain stays in a
  /// mental-arithmetic-friendly range over many steps.
  final int result;
}

/// The whole run's chain of chained calculations, derived once from
/// `(params, runSeed)` (US-037): every item of the run reads the same
/// chain, so item i's back-reference reflects the result *actually*
/// produced at `i - stage`, not a synthetic stand-in.
class CalcBackChain {
  const CalcBackChain({required this.steps});

  final List<CalcBackStep> steps;

  /// Keeps every chained result inside a comfortable mental-arithmetic
  /// range (single/double digit) instead of drifting unboundedly over a
  /// 20-calculation stage.
  static const int resultFloor = 0;
  static const int resultCeiling = 99;

  /// Builds the run's chain up to (not including) position [upTo]
  /// (defaults to the whole run, `stageCount * calcsPerStage`).
  /// [CalcBackEngine.stepOf] only needs up to its own `index`, but the
  /// result is identical whatever [upTo] is, because each step depends only
  /// on earlier ones.
  factory CalcBackChain.build(
    P1WmCalcBackParams params,
    int runSeed, {
    int? upTo,
  }) {
    final rng = Random(runSeed);
    final calcsPerStage = params.calcsPerStage < 1 ? 1 : params.calcsPerStage;
    final stageCount = params.stageCount < 1 ? 1 : params.stageCount;
    final count = upTo ?? (calcsPerStage * stageCount);
    final steps = <CalcBackStep>[];
    for (var i = 0; i < count; i++) {
      final stage = stageOf(
        i,
        calcsPerStage: calcsPerStage,
        stageCount: stageCount,
      );
      final operand = rng.nextInt(9) + 1;
      final op = rng.nextBool() ? CalcBackOp.add : CalcBackOp.subtract;
      final backIndex = i - stage;
      final backValue = backIndex >= 0 ? steps[backIndex].result : 0;
      final raw = op.apply(operand, backValue);
      final result = raw.clamp(resultFloor, resultCeiling);
      steps.add(
        CalcBackStep(
          index: i,
          stage: stage,
          operand: operand,
          op: op,
          backIndex: backIndex,
          backValue: backValue,
          result: result,
        ),
      );
    }
    return CalcBackChain(steps: steps);
  }

  /// The 1-based stage of position [index]: whole run divided into
  /// `calcsPerStage`-sized blocks, clamped to [stageCount] so a run longer
  /// than `stageCount * calcsPerStage` (a launcher's own item count) simply
  /// stays at the last stage's load instead of indexing past it.
  static int stageOf(
    int index, {
    required int calcsPerStage,
    required int stageCount,
  }) {
    final stage = index ~/ calcsPerStage + 1;
    return stage.clamp(1, stageCount);
  }
}

/// Metric key names summed into `SectionResult.metricTotals` by every
/// `ItemResult` [CalcBackEngine.score] returns, decomposed per stage (spec:
/// "scorer accuracy per stage").
abstract final class CalcBackMetrics {
  static String attemptsAtStage(int stage) => 'calcBackStage${stage}Attempts';
  static String correctAtStage(int stage) => 'calcBackStage${stage}Correct';
}
