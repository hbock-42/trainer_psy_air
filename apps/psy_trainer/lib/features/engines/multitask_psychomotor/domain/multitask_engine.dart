import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'multitask_scoring.dart';
import 'multitask_simulation.dart';

/// `multitask_psychomotor` (spec §2.4-M, US-036): 5 minutes of divided
/// attention -- hold the arrow key matching a moving circle's direction,
/// press SPACE when the shape inside it equals the reference shape, press F
/// when the framed calculation is wrong.
///
/// Unlike the cadence-driven engines (`attention_rules`, `memory_nback`),
/// the whole run is **one item** (`family.json`: `defaultItemCount: 1`,
/// the blueprint section: `itemCount: 1`, `sectionTimeSec: 300`): the
/// renderer runs its own 5-minute simulation and submits a single
/// `Answer.raw` when it ends, so `generate` does not need `runSeed`/`index`
/// (US-037) the way a continuous *stream of items* would -- there is only
/// ever one, at `index: 0`. [MultitaskSimulation.build] is called again
/// from the same `(seed, params, difficulty)` by the renderer and by
/// [score] (via the payload the renderer already computed), matching the
/// "engine-owned data derived again from the seed" pattern of
/// `dominos`/`attention_rules`.
class MultitaskEngine extends ActivityEngine {
  const MultitaskEngine();

  static const String engineFamilyId = 'multitask_psychomotor';

  @override
  String get familyId => engineFamilyId;

  @override
  GeneratorId? get generatorId => GeneratorId.multitask;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as MultitaskParams;
    // Built once so a malformed recipe (e.g. a 0 s run) fails fast instead
    // of surfacing only when the renderer starts.
    MultitaskSimulation.build(
      seed: seed,
      params: typed,
      difficulty: difficulty,
    );
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.multitask, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['multitask'],
      generatorId: GeneratorId.multitask,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.multitask,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  /// Rebuilds the deterministic simulation of a materialised item; used by
  /// the renderer and available to tests.
  static MultitaskSimulation simulationOf(GeneratedItem item) =>
      MultitaskSimulation.build(
        seed: item.seed,
        params: item.params as MultitaskParams,
        difficulty: item.difficulty,
      );

  /// The renderer sends the whole run's outcome as one [Answer.raw] payload
  /// (`MultitaskMetrics.toPayload`, computed live from the same
  /// [MultitaskSimulation] against the recorded key events) once the
  /// simulation reaches `params.durationSec`. A [SkipAnswer] is the touch
  /// fallback's "skip this activity" in exam mode (no representative input
  /// device); anything else (including a timeout, which the runtime scores
  /// itself) is wrong.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isSkip) return ItemResult.skip;
    if (answer is! RawAnswer) return ItemResult.wrong;
    final metrics = MultitaskMetrics.fromPayload(answer.payload);
    return ItemResult(
      correct: MultitaskScoring.isCorrect(metrics),
      metrics: metrics.toItemMetrics(),
    );
  }
}
