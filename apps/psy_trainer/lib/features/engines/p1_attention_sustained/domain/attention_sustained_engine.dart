import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'attention_sustained_stimulus.dart';

/// `p1_attention_sustained` (spec §2.3-3/§4.1 row 3, US-115): a
/// cadence-driven target-detection stream. One `GeneratedItem` per flashed
/// stimulus (not one per series), so the runtime's own cadence
/// (`TimingPolicy.cadence`, `render.phase`) and per-item attempt recording
/// apply exactly as for `attention_rules`/`memory_nback`; the item carries
/// no extra data of its own -- `generate` reads `runSeed` + `index` (the
/// whole run's stream, series and rule, is recomputed from them by
/// [AttentionStimulus.decode]/[AttentionSeries.build], never stored on the
/// item, per `docs/ARCHITECTURE.md`).
///
/// **Timeout scoring deviation (documented per the card's own caveat).**
/// `ActivityEngine.score` is never called with a `TimeoutAnswer` --
/// `ActivitySession` always records it as `ItemResult.timeout` itself
/// (`Scorer` skill, `activity_engine.dart`), so a genuine timeout cannot be
/// reinterpreted here as a correct rejection no matter what the stimulus
/// was. Non-targets therefore require an explicit "not target" answer (a
/// second key/button, not silence) to be scored as a correct rejection; a
/// candidate who simply lets a non-target time out is recorded as a
/// timeout, not a hit on either side. This is the fallback the card
/// anticipated when a timeout can't be reinterpreted.
class AttentionSustainedEngine extends ActivityEngine {
  const AttentionSustainedEngine();

  static const String engineFamilyId = 'p1_attention_sustained';

  @override
  String get familyId => engineFamilyId;

  @override
  GeneratorId? get generatorId => GeneratorId.p1AttentionSustained;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1AttentionSustainedParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(
        GeneratorId.p1AttentionSustained,
        seed,
      ),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['attention'],
      generatorId: GeneratorId.p1AttentionSustained,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.p1AttentionSustained,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  /// The decoded stimulus of a materialised `GeneratedItem` of this family;
  /// used by the renderer and by [score].
  static AttentionStimulus stimulusOf(GeneratedItem item) {
    final origin = item.origin;
    return AttentionStimulus.decode(
      item.params as P1AttentionSustainedParams,
      origin?.runSeed ?? item.seed,
      origin?.index ?? 0,
    );
  }

  /// The series (rule + stream) a materialised item belongs to; used by the
  /// renderer to show the currently-active rule.
  static AttentionSeries seriesOf(GeneratedItem item) {
    final params = item.params as P1AttentionSustainedParams;
    final origin = item.origin;
    final runSeed = origin?.runSeed ?? item.seed;
    final index = origin?.index ?? 0;
    final itemsPerSeries = params.itemsPerSeries < 1
        ? 1
        : params.itemsPerSeries;
    return AttentionSeries.build(params, runSeed, index ~/ itemsPerSeries);
  }

  /// The answer must be `Answer.key(AttentionAnswer.target|notTarget)`
  /// (renderer buttons and keyboard both funnel through it, see
  /// [AttentionAnswer]); anything else is wrong (no partial metrics, same
  /// as an unrecognised `memory_nback` answer). Metrics name the four
  /// signal-detection outcomes (`AttentionMetrics`), plus a first-/last-
  /// third-of-series correctness split the summary uses to compute the
  /// vigilance decrement ([attentionVigilanceDecrement]); both are summed
  /// by `Scorer.section` into `SectionResult.metricTotals`.
  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final params = generated.params as P1AttentionSustainedParams;
    final stimulus = stimulusOf(generated);
    final answeredTarget = AttentionAnswer.isTarget(answer);
    if (answeredTarget == null) {
      return ItemResult(
        correct: false,
        metrics: _thirdMetrics(generated, params, correct: false),
      );
    }
    final expectsTarget = stimulus.isTarget;
    final correct = answeredTarget == expectsTarget;
    return ItemResult(
      correct: correct,
      metrics: {
        AttentionMetrics.hits: expectsTarget && answeredTarget ? 1 : 0,
        AttentionMetrics.misses: expectsTarget && !answeredTarget ? 1 : 0,
        AttentionMetrics.falseAlarms: !expectsTarget && answeredTarget ? 1 : 0,
        AttentionMetrics.correctRejections: !expectsTarget && !answeredTarget
            ? 1
            : 0,
        ..._thirdMetrics(generated, params, correct: correct),
      },
    );
  }

  /// Buckets [item] into the first/middle/last third of its series (by
  /// position within the series, `index * 3 ~/ itemsPerSeries`) and counts
  /// it towards that bucket's total/correct metrics -- the middle bucket is
  /// only there to keep the split exhaustive and contributes no metric of
  /// its own, since [attentionVigilanceDecrement] only compares first vs.
  /// last.
  static Map<String, num> _thirdMetrics(
    GeneratedItem item,
    P1AttentionSustainedParams params, {
    required bool correct,
  }) {
    final itemsPerSeries = params.itemsPerSeries < 1
        ? 1
        : params.itemsPerSeries;
    final indexInSeries = (item.origin?.index ?? 0) % itemsPerSeries;
    final bucket = (indexInSeries * 3) ~/ itemsPerSeries;
    return switch (bucket) {
      0 => {
        AttentionMetrics.firstThirdTotal: 1,
        AttentionMetrics.firstThirdCorrect: correct ? 1 : 0,
      },
      2 => {
        AttentionMetrics.lastThirdTotal: 1,
        AttentionMetrics.lastThirdCorrect: correct ? 1 : 0,
      },
      _ => const <String, num>{},
    };
  }
}

/// The target/not-target answer shape the renderer sends (`Answer.key`,
/// per `family.json`'s `answerFormat: key_press`): not a raw keyboard key
/// name but the engine's own two tokens, so a touch tap and a keyboard
/// press score identically (mirrors `NbackAnswer`).
abstract final class AttentionAnswer {
  static const Answer target = Answer.key('target');
  static const Answer notTarget = Answer.key('notTarget');

  /// `true`/`false` for a target/not-target answer, null for anything else.
  static bool? isTarget(Answer answer) => switch (answer) {
    KeyAnswer(key: 'target') => true,
    KeyAnswer(key: 'notTarget') => false,
    _ => null,
  };
}

/// Signal-detection + vigilance metric names summed into
/// `SectionResult.metricTotals` by every `ItemResult` [AttentionSustainedEngine
/// .score] returns.
abstract final class AttentionMetrics {
  static const String hits = 'attentionHits';
  static const String misses = 'attentionMisses';
  static const String falseAlarms = 'attentionFalseAlarms';
  static const String correctRejections = 'attentionCorrectRejections';
  static const String firstThirdTotal = 'attentionFirstThirdTotal';
  static const String firstThirdCorrect = 'attentionFirstThirdCorrect';
  static const String lastThirdTotal = 'attentionLastThirdTotal';
  static const String lastThirdCorrect = 'attentionLastThirdCorrect';
}

/// The vigilance decrement (spec §2.3-3's "sustained" framing, US-115):
/// accuracy on each series' first third minus accuracy on its last third,
/// summed across every series played (`SectionResult.metricTotals`).
/// Positive means performance dropped over the series (the expected
/// vigilance-task pattern); null when either third has no items yet (e.g.
/// a run cut short before either window completed).
double? attentionVigilanceDecrement({
  required int firstThirdTotal,
  required int firstThirdCorrect,
  required int lastThirdTotal,
  required int lastThirdCorrect,
}) {
  if (firstThirdTotal == 0 || lastThirdTotal == 0) return null;
  final firstAccuracy = firstThirdCorrect / firstThirdTotal;
  final lastAccuracy = lastThirdCorrect / lastThirdTotal;
  return firstAccuracy - lastAccuracy;
}
