import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'airways_simulation.dart';

/// `attention_airways` (spec §2.4-H, US-032): triangles ("aircraft") move
/// along lines; colour buttons re-route them; keep at most `capacity`
/// aircraft and `blueCapacity` blue aircraft in each grey zone.
///
/// [generate] returns the recipe unchanged (`GeneratedItem(seed, params)`,
/// same convention as `logic_dominos`/`attention_rules`): the renderer
/// rebuilds an [AirwaysSimulation] from `(seed, params, difficulty)` and
/// plays it live for the item's whole `durationSec` -- one item is one
/// series (spec: "10 successive series, ~5 min"). Unlike a puzzle engine,
/// the outcome is not re-derivable from the seed alone once play starts (it
/// depends on the candidate's own reroutes in real time), so [score] does
/// not replay the simulation: it reads the metrics the renderer already
/// computed off its own (equally deterministic, given the same reroute
/// calls) `AirwaysSimulation` instance, carried in the [RawAnswer] payload.
class AirwaysEngine extends ActivityEngine {
  const AirwaysEngine();

  static const String engineFamilyId = 'attention_airways';

  @override
  String get familyId => engineFamilyId;

  @override
  GeneratorId? get generatorId => GeneratorId.airways;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as AirwaysParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.airways, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['attention'],
      generatorId: GeneratorId.airways,
      seed: seed,
      params: typed,
      origin: ItemOrigin(generatorId: GeneratorId.airways, seed: seed),
    );
  }

  /// Correct iff the whole series ran with zero violations
  /// (`AirwaysSimulation.violations == 0`); `metrics` carries `violations`,
  /// `reroutes` and `survivedMs` for the section summary and analytics.
  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isSkip) return ItemResult.skip;
    if (answer is! RawAnswer) return ItemResult.wrong;
    final payload = answer.payload;
    final violations = (payload['violations'] as num?)?.toInt() ?? 0;
    final reroutes = (payload['reroutes'] as num?)?.toInt() ?? 0;
    final survivedMs = (payload['survivedMs'] as num?)?.toInt() ?? 0;
    return ItemResult(
      correct: violations == 0,
      metrics: {
        'violations': violations,
        'reroutes': reroutes,
        'survivedMs': survivedMs,
      },
    );
  }
}
