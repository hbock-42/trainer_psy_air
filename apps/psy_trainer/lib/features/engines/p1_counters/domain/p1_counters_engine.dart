import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';
import 'counters_recipe.dart';
import 'gauge.dart';

/// `p1_counters` (US-113, spec §2.3 row 7 / §4.1 row 7): fast, accurate
/// reading of analog gauges/counters -- "closest PSY1 analogue to a
/// flight-instrument scan". Timing is undocumented (family.json flags
/// `confidence: assumed`); see the PR report for that caveat.
///
/// [generate] returns a real [NumericItem] or [McqItem] (never a
/// [GeneratedItem]): the question decides which. The panel itself (the
/// gauges [CountersRecipe.gauges] describes) is not carried by either item
/// -- neither has a field for it -- so it is deterministically recomputed
/// from `(origin.seed, difficulty)` and the family's default
/// [P1CountersParams] by [recipeOf] wherever it is needed again (the
/// renderer's painters). This assumes the generator always runs with the
/// shipped default `dialsPerItem` (true today: both blueprint entries only
/// restate `count`, see `planning_tubes`'s `TubesEngine` doc for the same
/// convention and caveat) -- a future blueprint overriding `dialsPerItem`
/// would still score correctly (the numeric/MCQ answer does not depend on
/// it) but would draw the wrong-sized panel; see the PR report.
class CountersEngine extends ActivityEngine {
  const CountersEngine();

  @override
  String get familyId => 'p1_counters';

  @override
  GeneratorId? get generatorId => GeneratorId.p1Counters;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1CountersParams;
    final recipe = CountersRecipe.build(
      params: typed,
      seed: seed,
      difficulty: difficulty,
    );
    final origin = ItemOrigin(
      generatorId: GeneratorId.p1Counters,
      seed: seed,
      runSeed: runSeed ?? seed,
      index: index,
    );
    final id = ActivityEngine.generatedItemId(GeneratorId.p1Counters, seed);
    final question = recipe.question;
    return switch (question) {
      GaugeValueQuestion() => _valueItem(
        id,
        difficulty,
        recipe.gauges,
        question,
        origin,
      ),
      GaugeCombineQuestion() => _combineItem(
        id,
        difficulty,
        recipe.gauges,
        question,
        origin,
      ),
      GaugeMatchQuestion() => _matchItem(
        id,
        difficulty,
        recipe.gauges,
        question,
        origin,
      ),
    };
  }

  /// The panel a materialised `p1_counters` item describes, recomputed from
  /// its `origin` and difficulty (never stored on the item itself); used by
  /// the renderer. See the class doc for the default-params assumption.
  static CountersRecipe recipeOf(Item item) {
    final (seed, difficulty) = switch (item) {
      NumericItem(:final origin, :final difficulty) => (
        origin?.seed ?? 0,
        difficulty,
      ),
      McqItem(:final origin, :final difficulty) => (
        origin?.seed ?? 0,
        difficulty,
      ),
      _ => (0, minDifficulty),
    };
    return CountersRecipe.build(
      params:
          GeneratorParams.defaultsFor(GeneratorId.p1Counters)
              as P1CountersParams,
      seed: seed,
      difficulty: difficulty,
    );
  }

  static Item _valueItem(
    String id,
    int difficulty,
    List<Gauge> gauges,
    GaugeValueQuestion q,
    ItemOrigin origin,
  ) {
    final gauge = gauges[q.gaugeIndex];
    final reading = _format(gauge.value, gauge.decimals);
    return Item.numeric(
      id: id,
      version: 1,
      familyId: 'p1_counters',
      difficulty: difficulty,
      tags: const ['p1_counters', 'value'],
      stem: LocalizedText(
        fr: 'Quelle valeur indique le cadran ${gauge.label} ?',
        en: 'What value does gauge ${gauge.label} show?',
      ),
      expected: gauge.value,
      explanation: LocalizedText(
        fr:
            'Le cadran ${gauge.label} indique '
            '$reading${gauge.unit == null ? '' : ' ${gauge.unit}'}.',
        en:
            'Gauge ${gauge.label} reads '
            '$reading${gauge.unit == null ? '' : ' ${gauge.unit}'}.',
      ),
      origin: origin,
      tolerance: Tolerance(
        mode: ToleranceMode.absolute,
        value: gauge.tolerance,
      ),
      unit: gauge.unit,
      inputFormat: gauge.kind == GaugeKind.drum
          ? InputFormat.integer
          : InputFormat.decimal,
      decimals: gauge.decimals,
    );
  }

  static Item _combineItem(
    String id,
    int difficulty,
    List<Gauge> gauges,
    GaugeCombineQuestion q,
    ItemOrigin origin,
  ) {
    final a = gauges[q.aIndex];
    final b = gauges[q.bIndex];
    final expected = q.isSum ? a.value + b.value : a.value - b.value;
    final tolerance = a.tolerance + b.tolerance;
    final decimals = a.decimals > b.decimals ? a.decimals : b.decimals;
    final op = q.isSum ? '+' : '-';
    return Item.numeric(
      id: id,
      version: 1,
      familyId: 'p1_counters',
      difficulty: difficulty,
      tags: const ['p1_counters', 'combine'],
      stem: LocalizedText(
        fr:
            'Quelle est la ${q.isSum ? 'somme' : 'différence'} des valeurs '
            'des cadrans ${a.label} et ${b.label} (${a.label} $op ${b.label}) ?',
        en:
            'What is the ${q.isSum ? 'sum' : 'difference'} of gauges '
            '${a.label} and ${b.label} (${a.label} $op ${b.label})?',
      ),
      expected: expected,
      explanation: LocalizedText(
        fr:
            '${a.label} = ${_format(a.value, a.decimals)}, '
            '${b.label} = ${_format(b.value, b.decimals)} '
            '=> ${_format(expected, decimals)}.',
        en:
            '${a.label} = ${_format(a.value, a.decimals)}, '
            '${b.label} = ${_format(b.value, b.decimals)} '
            '=> ${_format(expected, decimals)}.',
      ),
      origin: origin,
      tolerance: Tolerance(mode: ToleranceMode.absolute, value: tolerance),
      decimals: decimals,
    );
  }

  static Item _matchItem(
    String id,
    int difficulty,
    List<Gauge> gauges,
    GaugeMatchQuestion q,
    ItemOrigin origin,
  ) {
    final targetGauge = gauges[q.optionOrder[q.correctOption]];
    final options = [
      for (final gaugeIndex in q.optionOrder)
        McqOption(
          text: LocalizedText(
            fr: 'Cadran ${gauges[gaugeIndex].label}',
            en: 'Gauge ${gauges[gaugeIndex].label}',
          ),
        ),
    ];
    return Item.mcq(
      id: id,
      version: 1,
      familyId: 'p1_counters',
      difficulty: difficulty,
      tags: const ['p1_counters', 'match'],
      stem: LocalizedText(
        fr:
            'Quel cadran affiche environ '
            '${_format(q.target, targetGauge.decimals)}'
            '${targetGauge.unit == null ? '' : ' ${targetGauge.unit}'} ?',
        en:
            'Which gauge shows about '
            '${_format(q.target, targetGauge.decimals)}'
            '${targetGauge.unit == null ? '' : ' ${targetGauge.unit}'}?',
      ),
      options: options,
      correctIndex: q.correctOption,
      explanation: LocalizedText(
        fr:
            'Le cadran ${targetGauge.label} indique '
            '${_format(targetGauge.value, targetGauge.decimals)}'
            '${targetGauge.unit == null ? '' : ' ${targetGauge.unit}'}.',
        en:
            'Gauge ${targetGauge.label} reads '
            '${_format(targetGauge.value, targetGauge.decimals)}'
            '${targetGauge.unit == null ? '' : ' ${targetGauge.unit}'}.',
      ),
      origin: origin,
      shuffleOptions: false, // already shuffled deterministically (rng-seeded)
    );
  }

  static String _format(num value, int decimals) =>
      value.toStringAsFixed(decimals);
}
