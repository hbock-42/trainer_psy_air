import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import 'stimulus_rule_set.dart';

/// *Formes et couleurs* (spec §2.4-C, US-029, US-037): a shape flashes
/// every 3 s (the cadence is the family's, `defaultCadence`/
/// `ExamSection.cadence`), and the candidate presses the key the run's rule
/// set assigns to it -- see [StimulusRuleSet] for how that rule set is
/// derived from the run seed and stays identical for every item of a run.
///
/// `generate` returns the recipe unchanged (`GeneratedItem(seed, params)`):
/// per `docs/ARCHITECTURE.md` ("interactive activities... keep the stimulus
/// in engine-owned data derived again from the seed"), the renderer and the
/// scorer both call [StimulusRuleSet.fromRunSeed] and [StimulusRuleSet.trial]
/// again from `(runSeed, params)`/`seed` rather than have the item carry
/// extra, schema-less fields; `runSeed` (identical for the whole run) is
/// stored on `origin` so it survives materialisation.
class AttentionRulesEngine extends ActivityEngine {
  const AttentionRulesEngine();

  static const String engineFamilyId = 'attention_rules';

  @override
  String get familyId => engineFamilyId;

  @override
  GeneratorId? get generatorId => GeneratorId.stimulusResponse;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as StimulusResponseParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.stimulusResponse, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['attention'],
      generatorId: GeneratorId.stimulusResponse,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.stimulusResponse,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  @override
  ItemResult score(Item item, Answer answer) {
    if (answer.isSkip) return ItemResult.skip;
    final trial = StimulusTrial.forItem(item as GeneratedItem);
    final pressed = answer is KeyAnswer ? answer.key.toLowerCase() : null;
    final correct =
        pressed != null && pressed == trial.correctKey.toLowerCase();
    return correct ? ItemResult.right : ItemResult.wrong;
  }
}
