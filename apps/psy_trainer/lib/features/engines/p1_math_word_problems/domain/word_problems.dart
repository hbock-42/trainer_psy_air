import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../_shared/arithmetic/arithmetic_equation.dart';

/// The seven templates `p1_math_word_problems` draws from (spec §2.3-1,
/// §4.1 row 1): speed/time/distance, fuel burn or endurance,
/// proportionality ("règle de trois"), percentages (discount, increase,
/// share), unit conversions, averages and time-zone arithmetic. One is
/// drawn uniformly per item from `Random(seed)`.
enum WordProblemTemplate {
  speedTimeDistance,
  fuelEndurance,
  proportionality,
  percentage,
  unitConversion,
  average,
  timeZone,
}

/// A materialised `p1_math_word_problems` recipe: the FR stem, the expected
/// numeric answer (always rounded to at most one decimal, spec §2.3-1: "the
/// answer is an integer or a one-decimal value") and the FR explanation
/// (method), plus MCQ choices when [P1MathWordProblemsParams.answerMode] is
/// `mcq`.
///
/// [variant] and [operands] expose the raw quantities the stem was built
/// from, in the fixed order each template's doc comment describes below --
/// not needed by the engine or renderer (both only read [stemFr]/
/// [expected]/[explanationFr]/[unit]), but what
/// `test/.../word_problems_generator_test.dart` uses to recompute [expected]
/// with its own copy of the formula, the same "independent solver" pattern
/// `p1_mental_arithmetic`'s test applies to its printed expression string
/// (see `mental_arithmetic_generator_test.dart`'s `_evaluate`) -- prose is
/// harder to parse reliably than a flat operand list once a template chains
/// a variable number of steps, so these problems expose the numbers
/// directly instead.
///
/// The engine never stores this on the item: both `NumericItem` and
/// `McqItem` are self-scoring (`Scorer.scoreItem`), so
/// `MathWordProblemsGenerator.build` only needs to run once, inside
/// `MathWordProblemsEngine.generate`.
class MathWordProblem {
  const MathWordProblem({
    required this.template,
    required this.variant,
    required this.steps,
    required this.operands,
    required this.stemFr,
    required this.expected,
    required this.explanationFr,
    this.unit,
    this.mcqOptions = const [],
    this.correctOptionIndex,
  });

  final WordProblemTemplate template;

  /// Which formula shape of [template] this is; see the template's builder
  /// doc comment for the exact meaning of [operands] under each variant.
  final String variant;

  /// 1..[P1MathWordProblemsParams.maxSteps]: how many chained operations the
  /// problem needs, scaled from `difficulty` by [stepsFor].
  final int steps;

  /// The raw numbers [expected] was computed from, in the order the
  /// template's builder doc comment lists for [variant].
  final List<num> operands;

  final String stemFr;

  /// The true answer; always the result of [roundToOneDecimal].
  final num expected;

  final String explanationFr;

  /// Unit suffix shown next to the numeric answer (`'km'`, `'h'`, `'%'`...),
  /// or null for a bare count (e.g. `average`).
  final String? unit;

  /// Populated only when [P1MathWordProblemsParams.answerMode] is `mcq`:
  /// four choices (the correct one plus three plausible distractors) in
  /// display order.
  final List<num> mcqOptions;

  /// Index of [expected] into [mcqOptions]; null in numeric mode.
  final int? correctOptionIndex;
}

/// Builds the deterministic [MathWordProblem] of one `p1_math_word_problems`
/// recipe from `(params, seed, difficulty)` (US-104, spec §2.3-1).
abstract final class MathWordProblemsGenerator {
  static MathWordProblem build({
    required P1MathWordProblemsParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final template = WordProblemTemplate
        .values[rng.nextInt(WordProblemTemplate.values.length)];
    final steps = stepsFor(difficulty, params.maxSteps);
    final cap = arithmeticOperandCap(params.maxOperand, difficulty);

    final problem = switch (template) {
      WordProblemTemplate.speedTimeDistance => _speedTimeDistance(
        rng,
        cap,
        steps,
      ),
      WordProblemTemplate.fuelEndurance => _fuelEndurance(rng, cap, steps),
      WordProblemTemplate.proportionality => _proportionality(rng, cap, steps),
      WordProblemTemplate.percentage => _percentage(rng, cap, steps),
      WordProblemTemplate.unitConversion => _unitConversion(rng, cap, steps),
      WordProblemTemplate.average => _average(rng, cap, steps),
      WordProblemTemplate.timeZone => _timeZone(rng, cap, steps),
    };

    if (params.answerMode != P1AnswerMode.mcq) return problem;
    return _withMcqOptions(rng, problem);
  }

  /// difficulty 1 -> 1 step, difficulty [maxDifficulty] -> [maxSteps] steps,
  /// linear in between (shared scaling idea with `arithmeticOperandCap`:
  /// magnitude and step count both grow with difficulty, never shrink below
  /// 1 or exceed the family's own [maxSteps] cap).
  static int stepsFor(int difficulty, int maxSteps) {
    final steps = maxSteps < 1 ? 1 : maxSteps;
    final level = difficulty.clamp(minDifficulty, maxDifficulty);
    final scaled =
        1 + ((level - 1) * (steps - 1) / (maxDifficulty - 1)).round();
    return scaled.clamp(1, steps);
  }

  // --- speed / time / distance ---------------------------------------
  //
  // variant 'distance': operands [speed, time] -> expected = speed * time.
  // variant 'speed':    operands [distance, time] -> expected = distance / time.
  // variant 'time':     operands [distance, speed] -> expected = distance / speed.
  // variant 'multileg': operands [speed1, time1, speed2, time2, ...]
  //                     (2 * steps entries) -> expected = sum(speed_i * time_i).
  // Every `expected` is [roundToOneDecimal].

  static MathWordProblem _speedTimeDistance(Random rng, int cap, int steps) {
    final aviation = rng.nextBool();
    final speedUnit = aviation ? 'kt' : 'km/h';
    final distUnit = aviation ? 'NM' : 'km';
    final vehicle = aviation ? 'Un avion' : 'Une voiture';

    final legSpeeds = <int>[];
    final legTimes = <double>[];
    for (var i = 0; i < steps; i++) {
      legSpeeds.add(80 + rng.nextInt(max(4, cap)) * 10);
      legTimes.add((1 + rng.nextInt(6)) / 2.0); // 0.5 .. 3.0 h
    }
    final legDistances = [
      for (var i = 0; i < steps; i++) legSpeeds[i] * legTimes[i],
    ];

    if (steps == 1) {
      final speed = legSpeeds[0];
      final time = legTimes[0];
      final distance = legDistances[0];
      final unknown = rng.nextInt(3);
      return switch (unknown) {
        0 => MathWordProblem(
          template: WordProblemTemplate.speedTimeDistance,
          variant: 'distance',
          steps: steps,
          operands: [speed, time],
          stemFr:
              '$vehicle vole à $speed $speedUnit pendant ${_frTimeSpan(time)}. '
              'Quelle distance parcourt-elle (en $distUnit) ?',
          expected: roundToOneDecimal(distance),
          unit: distUnit,
          explanationFr:
              'Distance = vitesse × temps = $speed × ${_frNum(time)} = '
              '${_frNum(roundToOneDecimal(distance))} $distUnit.',
        ),
        1 => MathWordProblem(
          template: WordProblemTemplate.speedTimeDistance,
          variant: 'speed',
          steps: steps,
          operands: [distance, time],
          stemFr:
              '$vehicle parcourt $distUnit ${_frNum(distance)} en '
              '${_frTimeSpan(time)}. Quelle est sa vitesse (en $speedUnit) ?',
          expected: roundToOneDecimal(distance / time),
          unit: speedUnit,
          explanationFr:
              'Vitesse = distance ÷ temps = ${_frNum(distance)} ÷ '
              '${_frNum(time)} = ${_frNum(roundToOneDecimal(distance / time))} '
              '$speedUnit.',
        ),
        _ => MathWordProblem(
          template: WordProblemTemplate.speedTimeDistance,
          variant: 'time',
          steps: steps,
          operands: [distance, speed],
          stemFr:
              '$vehicle parcourt $distUnit ${_frNum(distance)} à '
              '$speed $speedUnit. Combien de temps met-elle (en heures) ?',
          expected: roundToOneDecimal(distance / speed),
          unit: 'h',
          explanationFr:
              'Temps = distance ÷ vitesse = ${_frNum(distance)} ÷ $speed = '
              '${_frNum(roundToOneDecimal(distance / speed))} h.',
        ),
      };
    }

    final total = legDistances.fold<num>(0, (sum, d) => sum + d);
    final legLines = [
      for (var i = 0; i < steps; i++)
        'étape ${i + 1} : $speedUnit ${legSpeeds[i]} pendant '
            '${_frTimeSpan(legTimes[i])}',
    ].join(', puis ');
    final operands = [
      for (var i = 0; i < steps; i++) ...[legSpeeds[i], legTimes[i]],
    ];
    return MathWordProblem(
      template: WordProblemTemplate.speedTimeDistance,
      variant: 'multileg',
      steps: steps,
      operands: operands,
      stemFr:
          '$vehicle enchaîne $steps étapes : $legLines. Quelle distance '
          'totale a-t-elle parcourue (en $distUnit) ?',
      expected: roundToOneDecimal(total),
      unit: distUnit,
      explanationFr:
          'Distance totale = somme des vitesse × temps de chaque étape = '
          '${_frNum(roundToOneDecimal(total))} $distUnit.',
    );
  }

  // --- fuel burn / endurance ------------------------------------------
  //
  // variant 'consumption': operands [burnRate, duration1, duration2, ...]
  //                        (1 + steps entries) ->
  //                        expected = burnRate * sum(durations).
  // variant 'endurance':   operands [fuelAvailable, burnRate] ->
  //                        expected = fuelAvailable / burnRate.

  static MathWordProblem _fuelEndurance(Random rng, int cap, int steps) {
    final litres = rng.nextBool();
    final fuelUnit = litres ? 'L' : 'kg';
    final burnRate = 100 + rng.nextInt(max(4, cap)) * 10;

    if (rng.nextBool()) {
      final durations = [
        for (var i = 0; i < steps; i++) (1 + rng.nextInt(6)) / 2.0,
      ];
      final total = durations.fold<num>(0, (sum, h) => sum + burnRate * h);
      final legLines = steps == 1
          ? _frTimeSpan(durations[0])
          : [
              for (var i = 0; i < steps; i++)
                'étape ${i + 1} : ${_frTimeSpan(durations[i])}',
            ].join(', puis ');
      return MathWordProblem(
        template: WordProblemTemplate.fuelEndurance,
        variant: 'consumption',
        steps: steps,
        operands: [burnRate, ...durations],
        stemFr:
            'Un avion consomme $burnRate $fuelUnit/h. Il vole $legLines. '
            'Quelle quantité de carburant a-t-il consommée (en $fuelUnit) ?',
        expected: roundToOneDecimal(total),
        unit: fuelUnit,
        explanationFr:
            'Carburant = débit × temps (additionné sur chaque étape) = '
            '${_frNum(roundToOneDecimal(total))} $fuelUnit.',
      );
    }

    final hours = (1 + rng.nextInt(6)) / 2.0;
    final fuelAvailable = burnRate * hours;
    return MathWordProblem(
      template: WordProblemTemplate.fuelEndurance,
      variant: 'endurance',
      steps: steps,
      operands: [fuelAvailable, burnRate],
      stemFr:
          'Un avion a $fuelUnit ${_frNum(fuelAvailable)} de carburant à bord '
          'et consomme $burnRate $fuelUnit/h. Quelle est son autonomie '
          '(en heures) ?',
      expected: roundToOneDecimal(fuelAvailable / burnRate),
      unit: 'h',
      explanationFr:
          'Autonomie = carburant ÷ débit = ${_frNum(fuelAvailable)} ÷ '
          '$burnRate = ${_frNum(roundToOneDecimal(fuelAvailable / burnRate))} h.',
    );
  }

  // --- proportionality ("règle de trois") ------------------------------
  //
  // variant 'chain': operands [unitRate, askedQty, num1, den1, num2, den2,
  //                  ...] (2 + 2 * (steps - 1) entries) ->
  //                  expected = unitRate * askedQty * product(num_i / den_i).

  static MathWordProblem _proportionality(Random rng, int cap, int steps) {
    final unitRate = 1 + rng.nextInt(max(2, cap));
    final givenQty = 2 + rng.nextInt(max(2, cap));
    final givenTotal = unitRate * givenQty;
    final askedQty = 2 + rng.nextInt(max(2, cap));

    num value = unitRate * askedQty;
    final operands = <num>[unitRate, askedQty];
    final extraLines = <String>[];
    for (var i = 1; i < steps; i++) {
      final num_ = 1 + rng.nextInt(max(2, cap));
      final den_ = 1 + rng.nextInt(max(2, cap));
      operands.addAll([num_, den_]);
      value = value * num_ / den_;
      extraLines.add(
        'puis appliquer un facteur $num_/$den_ (ex. une remise ou un '
        'ajustement proportionnel)',
      );
    }

    final expected = roundToOneDecimal(value);
    final extraText = extraLines.isEmpty ? '' : ', ${extraLines.join(', ')}';
    return MathWordProblem(
      template: WordProblemTemplate.proportionality,
      variant: 'chain',
      steps: steps,
      operands: operands,
      stemFr:
          '$givenQty unités coûtent $givenTotal €. En gardant la même '
          'proportion, combien coûtent $askedQty unités (en €)$extraText ?',
      expected: expected,
      unit: '€',
      explanationFr:
          'Prix unitaire = $givenTotal ÷ $givenQty = $unitRate €. '
          '$askedQty unités = $unitRate × $askedQty = '
          '${_frNum(roundToOneDecimal(unitRate * askedQty))} €'
          '${extraLines.isEmpty ? '' : ', puis les facteurs supplémentaires'}'
          ' = ${_frNum(expected)} €.',
    );
  }

  // --- percentage (discount / increase / share) -------------------------
  //
  // variant 'share': operands [base, pct, parts] ->
  //                  expected = base * pct / 100 / parts.
  // variant 'chain': operands [base, pct1, sign1, pct2, sign2, ...]
  //                  (1 + 2 * steps entries; sign is +1 for a hausse, -1
  //                  for a remise) ->
  //                  value = base; for each (pct, sign):
  //                  value = value * (100 + sign * pct) / 100;
  //                  expected = value.

  static MathWordProblem _percentage(Random rng, int cap, int steps) {
    const pcts = [5, 10, 15, 20, 25, 30, 50];
    final base = 20 * (2 + rng.nextInt(max(2, cap)));

    // A share-split only ever stands alone (splitting a shared amount
    // further by a second percentage does not read as one natural
    // problem), so it is offered only when the run asked for a single
    // step; every other draw (and every steps > 1 draw) is a discount/
    // increase chain.
    if (steps == 1 && rng.nextBool()) {
      final pct = pcts[rng.nextInt(pcts.length)];
      final parts = 2 + rng.nextInt(4); // 2..5
      final expected = roundToOneDecimal(base * pct / 100 / parts);
      return MathWordProblem(
        template: WordProblemTemplate.percentage,
        variant: 'share',
        steps: steps,
        operands: [base, pct, parts],
        stemFr:
            '$pct % de $base € sont partagés en $parts parts égales. '
            'Quel est le montant d\'une part (en €) ?',
        expected: expected,
        unit: '€',
        explanationFr:
            'Part = ($base × $pct ÷ 100) ÷ $parts = ${_frNum(expected)} €.',
      );
    }

    num value = base.toDouble();
    final operands = <num>[base];
    final lines = <String>[];
    for (var i = 0; i < steps; i++) {
      final pct = pcts[rng.nextInt(pcts.length)];
      final isDiscount = rng.nextBool();
      final sign = isDiscount ? -1 : 1;
      operands.addAll([pct, sign]);
      final before = value;
      value = value * (100 + sign * pct) / 100;
      lines.add(
        i == 0
            ? (isDiscount
                  ? 'Remise de $pct % sur $base €'
                  : 'Hausse de $pct % sur $base €')
            : (isDiscount
                  ? 'puis une remise de $pct % sur '
                        '${_frNum(roundToOneDecimal(before))} €'
                  : 'puis une hausse de $pct % sur '
                        '${_frNum(roundToOneDecimal(before))} €'),
      );
    }

    final expected = roundToOneDecimal(value);
    return MathWordProblem(
      template: WordProblemTemplate.percentage,
      variant: 'chain',
      steps: steps,
      operands: operands,
      stemFr: '${lines.join(', ')}. Quel est le montant final (en €) ?',
      expected: expected,
      unit: '€',
      explanationFr: '${lines.join(' ; ')} = ${_frNum(expected)} €.',
    );
  }

  // --- unit conversion ---------------------------------------------------
  //
  // variant 'single':  operands [value1, factor] ->
  //                    expected = value1 * factor.
  // variant 'combine': operands [value1, factor, value2, sign] ->
  //                    expected = value1 * factor + sign * value2.
  // variant 'margin':  operands [value1, factor, value2, sign, marginPct] ->
  //                    expected = (value1 * factor + sign * value2)
  //                               * (100 + marginPct) / 100.

  static MathWordProblem _unitConversion(Random rng, int cap, int steps) {
    const pairs = [
      ('ft', 'm', 0.3048),
      ('NM', 'km', 1.852),
      ('kt', 'km/h', 1.852),
      ('lb', 'kg', 0.45359237),
    ];
    final (from, to, factor) = pairs[rng.nextInt(pairs.length)];
    final toFrom = rng.nextBool();
    final fromUnit = toFrom ? to : from;
    final toUnit = toFrom ? from : to;
    final effectiveFactor = toFrom ? 1 / factor : factor;

    final value1 = 10 + rng.nextInt(max(4, cap)) * 5;
    final converted = value1 * effectiveFactor;

    if (steps == 1) {
      final expected = roundToOneDecimal(converted);
      return MathWordProblem(
        template: WordProblemTemplate.unitConversion,
        variant: 'single',
        steps: steps,
        operands: [value1, effectiveFactor],
        stemFr:
            'Convertissez $value1 $fromUnit en $toUnit (arrondi au dixième).',
        expected: expected,
        unit: toUnit,
        explanationFr:
            '$value1 $fromUnit × ${_frNum(effectiveFactor)} = '
            '${_frNum(expected)} $toUnit.',
      );
    }

    final value2 = 10 + rng.nextInt(max(4, cap)) * 5;
    final combineAdd = rng.nextBool();
    final sign = combineAdd ? 1 : -1;
    final combined = converted + sign * value2;

    if (steps >= 3) {
      final marginPct = 5 + rng.nextInt(4) * 5; // 5,10,15,20
      final total = combined * (100 + marginPct) / 100;
      final expected = roundToOneDecimal(total);
      return MathWordProblem(
        template: WordProblemTemplate.unitConversion,
        variant: 'margin',
        steps: steps,
        operands: [value1, effectiveFactor, value2, sign, marginPct],
        stemFr:
            'Un premier segment mesure $value1 $fromUnit et un second '
            'mesure déjà $value2 $toUnit. Après conversion du premier en '
            '$toUnit et ${combineAdd ? 'addition' : 'soustraction'} du '
            'second, ajoutez une marge de sécurité de $marginPct %. Quel '
            'est le résultat (en $toUnit) ?',
        expected: expected,
        unit: toUnit,
        explanationFr:
            '$value1 $fromUnit -> ${_frNum(roundToOneDecimal(converted))} '
            '$toUnit, ${combineAdd ? '+' : '-'} $value2 $toUnit = '
            '${_frNum(roundToOneDecimal(combined))} $toUnit, + $marginPct % '
            '= ${_frNum(expected)} $toUnit.',
      );
    }

    final expected = roundToOneDecimal(combined);
    return MathWordProblem(
      template: WordProblemTemplate.unitConversion,
      variant: 'combine',
      steps: steps,
      operands: [value1, effectiveFactor, value2, sign],
      stemFr:
          'Un premier segment mesure $value1 $fromUnit et un second '
          'mesure déjà $value2 $toUnit. Une fois le premier converti en '
          '$toUnit, quelle est la ${combineAdd ? 'somme' : 'différence'} des '
          'deux segments (en $toUnit) ?',
      expected: expected,
      unit: toUnit,
      explanationFr:
          '$value1 $fromUnit -> ${_frNum(roundToOneDecimal(converted))} '
          '$toUnit, ${combineAdd ? '+' : '-'} $value2 $toUnit = '
          '${_frNum(expected)} $toUnit.',
    );
  }

  // --- averages -----------------------------------------------------------
  //
  // variant 'mean': operands = the n values themselves (n = steps + 2) ->
  //                 expected = sum(operands) / operands.length.

  static MathWordProblem _average(Random rng, int cap, int steps) {
    final n = 3 + (steps - 1); // 3, 4, 5
    final values = [for (var i = 0; i < n; i++) 10 + rng.nextInt(cap * 5)];
    final sum = values.fold<int>(0, (a, b) => a + b);
    final expected = roundToOneDecimal(sum / n);
    return MathWordProblem(
      template: WordProblemTemplate.average,
      variant: 'mean',
      steps: steps,
      operands: values,
      stemFr:
          'Un candidat obtient les notes suivantes : '
          '${values.join(', ')}. Quelle est sa moyenne ?',
      expected: expected,
      explanationFr:
          'Moyenne = somme ÷ effectif = $sum ÷ $n = ${_frNum(expected)}.',
    );
  }

  // --- time-zone arithmetic ----------------------------------------------
  //
  // variant 'chain': operands [startMinutes, offset0, duration1Minutes,
  //                  offset1, duration2Minutes, offset2, ...]
  //                  (1 + 1 + 2 * (steps - 1) entries; minutes are minutes
  //                  since local midnight, offsets are whole hours). The
  //                  independent solver replays, for each subsequent
  //                  (durationMinutes, offset) pair: minutes = (minutes +
  //                  durationMinutes - previousOffset * 60 + offset * 60)
  //                  mod 1440; expected = final minutes / 60.

  static MathWordProblem _timeZone(Random rng, int cap, int steps) {
    int offsetHours() => -6 + rng.nextInt(13); // UTC-6 .. UTC+6

    var minutes = 360 + rng.nextInt(720); // 06:00 .. 17:59
    var offset = offsetHours();
    final operands = <num>[minutes, offset];
    final lines = <String>[
      'départ à ${_frClock(minutes)} (heure locale, UTC${_frOffset(offset)})',
    ];

    for (var i = 1; i < steps; i++) {
      final durationMinutes = (1 + rng.nextInt(6)) * 30; // 0h30 .. 3h00
      final nextOffset = offsetHours();
      operands.addAll([durationMinutes, nextOffset]);
      minutes =
          ((minutes + durationMinutes - offset * 60 + nextOffset * 60) % 1440 +
              1440) %
          1440;
      offset = nextOffset;
      lines.add(
        'après un vol de ${_frTimeSpan(durationMinutes / 60.0)}, arrivée '
        'dans un fuseau UTC${_frOffset(offset)}',
      );
    }

    final expected = roundToOneDecimal(minutes / 60.0);
    return MathWordProblem(
      template: WordProblemTemplate.timeZone,
      variant: 'chain',
      steps: steps,
      operands: operands,
      stemFr:
          '${lines.join(', ')}. Quelle est l\'heure locale à l\'arrivée '
          '(en heures décimales) ?',
      expected: expected,
      unit: 'h',
      explanationFr:
          'Chaque étape ajoute la durée de vol puis corrige le décalage '
          'horaire (± heures d\'écart entre fuseaux). Heure finale = '
          '${_frClock(minutes)} soit ${_frNum(expected)} h.',
    );
  }

  // --- MCQ mode ------------------------------------------------------------

  static MathWordProblem _withMcqOptions(Random rng, MathWordProblem base) {
    final expected = base.expected;
    final distractors = <num>{};
    while (distractors.length < 3) {
      final magnitude = max(1, (expected.abs() * 0.1).round());
      final delta =
          (1 + rng.nextInt(magnitude + 4)) * (rng.nextBool() ? 1 : -1);
      final candidate = roundToOneDecimal(expected + delta);
      if (candidate != expected) distractors.add(candidate);
    }
    final options = [expected, ...distractors]..shuffle(rng);
    return MathWordProblem(
      template: base.template,
      variant: base.variant,
      steps: base.steps,
      operands: base.operands,
      stemFr: base.stemFr,
      expected: expected,
      explanationFr: base.explanationFr,
      unit: base.unit,
      mcqOptions: options,
      correctOptionIndex: options.indexOf(expected),
    );
  }
}

/// Rounds [value] to one decimal place: every template's answer (spec
/// §2.3-1, "an integer or a one-decimal value").
num roundToOneDecimal(num value) => (value * 10).round() / 10;

String _frNum(num value) {
  final rounded = roundToOneDecimal(value);
  if (rounded == rounded.roundToDouble()) return rounded.toInt().toString();
  return rounded.toStringAsFixed(1).replaceAll('.', ',');
}

/// `1.5` -> `'1 h 30'`, `2.0` -> `'2 h'` (half-hour multiples only, so the
/// minute part is always `00` or `30`).
String _frTimeSpan(double hours) {
  final wholeHours = hours.floor();
  final minutesPart = ((hours - wholeHours) * 60).round();
  return minutesPart == 0 ? '$wholeHours h' : '$wholeHours h $minutesPart';
}

/// `510` (minutes since midnight) -> `'08:30'`.
String _frClock(int minutesSinceMidnight) {
  final h = (minutesSinceMidnight ~/ 60) % 24;
  final m = minutesSinceMidnight % 60;
  return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

/// `2` -> `'+2'`, `-3` -> `'-3'`.
String _frOffset(int offsetHours) =>
    offsetHours >= 0 ? '+$offsetHours' : '$offsetHours';
