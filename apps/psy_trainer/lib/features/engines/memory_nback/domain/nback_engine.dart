import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'nback_stimulus.dart';

/// `memory_nback` (spec §2.4-A, US-026, US-037): "Deux rangs avant" /
/// M2/M3-back. A stimulus (colour, or digit) is shown for `stimulusMs`; the
/// candidate answers yes/no whether it equals the one shown `n` steps
/// earlier, within `answerWindowMs`. Modelled as one `GeneratedItem` per
/// stimulus (not one item for the whole run) so the runtime's cadence
/// (`TimingPolicy.cadence`, `render.phase`) and per-item attempt recording
/// apply exactly as they do for any other cadence-driven activity; the
/// item carries no engine-specific data of its own -- `generate` reads
/// `runSeed` + `index` (US-037: `ItemSource.generator` passes them to
/// every call, identical `runSeed` for the whole run) and stores them on
/// `origin` so the renderer and the scorer can recompute the exact same
/// position of the same continuous stream (`NbackStimulus.decode`,
/// `NbackSequence`) instead of a private per-item simulation.
class NbackEngine extends ActivityEngine {
  const NbackEngine();

  @override
  String get familyId => 'memory_nback';

  @override
  GeneratorId? get generatorId => GeneratorId.nback;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as NbackParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.nback, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['memory', 'nback'],
      generatorId: GeneratorId.nback,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.nback,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  /// The decoded stimulus of a materialised `GeneratedItem` of this family;
  /// used by the renderer and by [score]. Reads `runSeed`/`index` off
  /// `origin` (always set by [generate]); a direct `generate()` call with
  /// neither (a unit test) falls back to `runSeed = seed`, `index = 0` --
  /// the first item of its own single-item run.
  static NbackStimulus stimulusOf(GeneratedItem item) {
    final origin = item.origin;
    return NbackStimulus.decode(
      item.params as NbackParams,
      origin?.runSeed ?? item.seed,
      origin?.index ?? 0,
    );
  }

  /// Primers (no valid n-back reference yet) are scored neutrally: always
  /// correct, whatever the candidate answers (or doesn't). Otherwise the
  /// answer must be `Answer.key(NbackAnswer.yes|no)` (renderer buttons and
  /// keyboard both funnel through it); anything else is wrong. Metrics
  /// name the four signal-detection outcomes (`NbackMetrics`), summed by
  /// `Scorer.section` into `SectionResult.metricTotals` for
  /// `nbackSensitivity`.
  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final stimulus = stimulusOf(generated);
    if (stimulus.isPrimer) {
      return const ItemResult(
        correct: true,
        metrics: {NbackMetrics.primers: 1},
      );
    }
    final answeredYes = NbackAnswer.isYes(answer);
    if (answeredYes == null) return ItemResult.wrong;
    final expectsYes = stimulus.expectsYes;
    final correct = answeredYes == expectsYes;
    return ItemResult(
      correct: correct,
      metrics: {
        NbackMetrics.hits: expectsYes && answeredYes ? 1 : 0,
        NbackMetrics.misses: expectsYes && !answeredYes ? 1 : 0,
        NbackMetrics.falseAlarms: !expectsYes && answeredYes ? 1 : 0,
        NbackMetrics.correctRejections: !expectsYes && !answeredYes ? 1 : 0,
      },
    );
  }
}

/// The yes/no answer shape the renderer sends (`Answer.key`, per
/// `family.json`'s `answerFormat: key_press`): not a raw keyboard key name
/// but the engine's own two tokens, so a touch tap and a keyboard press
/// score identically.
abstract final class NbackAnswer {
  static const Answer yes = Answer.key('yes');
  static const Answer no = Answer.key('no');

  /// `true`/`false` for a `yes`/`no` answer, null for anything else
  /// (including a stray `ChoiceAnswer`, which this activity never sends).
  static bool? isYes(Answer answer) => switch (answer) {
    KeyAnswer(key: 'yes') => true,
    KeyAnswer(key: 'no') => false,
    _ => null,
  };
}
