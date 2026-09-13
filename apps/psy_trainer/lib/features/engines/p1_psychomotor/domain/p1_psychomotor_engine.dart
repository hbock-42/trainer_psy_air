import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'p1_psychomotor_scoring.dart';
import 'p1_psychomotor_simulation.dart';

/// `p1_psychomotor` (spec §2.3 row 13, §4.1 row 13, US-102): PSY1's final,
/// most demanding activity — 6 consecutive 3-minute phases of continuous
/// divided attention across 4 channels (gauges, tracking, letters,
/// arithmetic), any one of which entering its red zone zeroes the whole
/// test (spec §2.2).
///
/// Unlike `multitask_psychomotor` (US-036, a single 5-minute item), this
/// family's content (`family.json`, both blueprints) models the run as
/// **`phaseCount` items**, one per 3-minute phase — matching the runtime's
/// generic `ItemSource.generator` loop, which calls [generate] `count`
/// times. The underlying simulation is still built **once per run** from
/// `runSeed` (`P1PsychomotorSimulation.build`) and spans the *whole*
/// duration (`phaseCount * phaseDurationSec`): phase `index`'s item just
/// carries which `[phaseStart, phaseEnd)` window of that one continuous
/// timeline the renderer should play now. The renderer is responsible for
/// keeping the live, user-driven half of the simulation
/// (`P1PsychomotorRunState`) alive across the phase-to-phase item
/// transitions (each of which gets a fresh widget/State, per
/// `ActivityRenderer`'s `ValueKey(item.id)` convention) — see
/// `P1PsychomotorRenderer`'s run-state cache, keyed by `runSeed`.
class P1PsychomotorEngine extends ActivityEngine {
  const P1PsychomotorEngine();

  static const String engineFamilyId = 'p1_psychomotor';

  @override
  String get familyId => engineFamilyId;

  @override
  GeneratorId? get generatorId => GeneratorId.p1Psychomotor;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1PsychomotorParams;
    final resolvedRunSeed = runSeed ?? seed;
    // Built once per call so a malformed recipe (a 0 s phase) fails fast,
    // matching `MultitaskEngine.generate`'s eager-build convention.
    P1PsychomotorSimulation.build(
      runSeed: resolvedRunSeed,
      params: typed,
      difficulty: difficulty,
    );
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.p1Psychomotor, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: ['psychomotor', 'phase-$index'],
      generatorId: GeneratorId.p1Psychomotor,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.p1Psychomotor,
        seed: seed,
        runSeed: resolvedRunSeed,
        index: index,
      ),
    );
  }

  /// Rebuilds the deterministic autonomous timeline of a materialised
  /// item's whole run; used by the renderer and available to tests.
  static P1PsychomotorSimulation simulationOf(GeneratedItem item) =>
      P1PsychomotorSimulation.build(
        runSeed: item.origin?.runSeed ?? item.seed,
        params: item.params as P1PsychomotorParams,
        difficulty: item.difficulty,
      );

  /// The renderer submits one [Answer.raw] per phase, built from the
  /// run-state's metrics at that phase's end (`P1PsychomotorMetrics`). A
  /// [SkipAnswer] is the touch/no-input-device fallback (no representative
  /// device available); anything else (including a timeout, scored by the
  /// runtime itself) is wrong.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isSkip) return ItemResult.skip;
    if (answer is! RawAnswer) return ItemResult.wrong;
    final metrics = P1PsychomotorMetrics.fromPayload(answer.payload);
    return ItemResult(
      correct: P1PsychomotorScorer.isCorrect(metrics),
      metrics: metrics.toItemMetrics(),
    );
  }
}
