import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'gauge.dart';

/// What a `p1_counters` item asks about its [CountersRecipe.gauges] (US-113,
/// spec §2.3 row 7 / §4.1 row 7). Always recomputed from the same `(seed,
/// difficulty, params)` that built the panel, so the engine, the default
/// scorer (`Scorer.scoreItem`, no override needed) and the renderer never
/// disagree about which gauges the question means.
sealed class CountersQuestion {
  const CountersQuestion();
}

/// "What does gauge X read?" -- materialised as a [NumericItem].
class GaugeValueQuestion extends CountersQuestion {
  const GaugeValueQuestion(this.gaugeIndex);

  final int gaugeIndex;
}

/// "Sum/difference of gauges A and B?" -- materialised as a [NumericItem].
class GaugeCombineQuestion extends CountersQuestion {
  const GaugeCombineQuestion({
    required this.aIndex,
    required this.bIndex,
    required this.isSum,
  });

  final int aIndex;
  final int bIndex;
  final bool isSum;
}

/// "Which gauge shows about X?" -- materialised as an [McqItem].
/// [optionOrder] is the (shuffled) gauge index shown at each option
/// position; [correctOption] indexes into it.
class GaugeMatchQuestion extends CountersQuestion {
  const GaugeMatchQuestion({
    required this.target,
    required this.optionOrder,
    required this.correctOption,
  });

  final num target;
  final List<int> optionOrder;
  final int correctOption;
}

/// One deterministic `p1_counters` recipe: the instrument panel (1-4
/// gauges) plus the question asked about it, both a pure function of
/// `(seed, difficulty, params)` -- `Random(seed)` only, consumed in a fixed
/// order (one gauge at a time, then the question), so the same recipe
/// replays exactly (determinism, US-113 unit tests).
class CountersRecipe {
  const CountersRecipe({required this.gauges, required this.question});

  final List<Gauge> gauges;
  final CountersQuestion question;

  static CountersRecipe build({
    required P1CountersParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final level = difficulty.clamp(minDifficulty, maxDifficulty);
    final gaugeCount = params.dialsPerItem.clamp(1, 4);
    final gauges = <Gauge>[
      for (var i = 0; i < gaugeCount; i++) _buildGauge(rng, level, _label(i)),
    ];
    final question = _buildQuestion(rng, gauges);
    return CountersRecipe(gauges: gauges, question: question);
  }

  static String _label(int i) => String.fromCharCode('A'.codeUnitAt(0) + i);

  static Gauge _buildGauge(Random rng, int level, String label) {
    final kind = GaugeKind.values[rng.nextInt(GaugeKind.values.length)];
    return switch (kind) {
      GaugeKind.circular => _buildCircular(rng, level, label),
      GaugeKind.linear => _buildLinear(rng, level, label),
      GaugeKind.multiNeedle => _buildMultiNeedle(rng, level, label),
      GaugeKind.drum => _buildDrum(rng, level, label),
    };
  }

  /// Fuel/pressure-style dial: a labelled 0..rangeMax scale, non-round at
  /// higher difficulty (a non-zero, non-multiple-of-10 [Gauge.rangeMin]).
  static Gauge _buildCircular(Random rng, int level, String label) {
    const bases = [10, 20, 25, 50];
    final base = bases[rng.nextInt(bases.length)];
    // Non-round step at higher difficulty: e.g. 10 -> 8 at level 5.
    final majorStep = level <= 2 ? base : (base - (level - 2)).clamp(4, base);
    final majorCount = 4 + rng.nextInt(3); // 4..6 labelled ticks
    final rangeMin = level >= 4 ? 1 + rng.nextInt(5) : 0;
    final rangeMax = rangeMin + majorStep * majorCount;
    final minorPerMajor = 2 + (level - 1); // density: 2..6
    final gauge0 = Gauge(
      kind: GaugeKind.circular,
      label: label,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
      majorStep: majorStep,
      minorPerMajor: minorPerMajor,
      value: 0,
      unit: 'bar',
    );
    return _withPickedValue(rng, gauge0, level);
  }

  /// Straight scale (a thermometer/level-style instrument).
  static Gauge _buildLinear(Random rng, int level, String label) {
    const bases = [10, 20, 25];
    final base = bases[rng.nextInt(bases.length)];
    final majorStep = level <= 2 ? base : (base - (level - 2)).clamp(4, base);
    final majorCount = 4 + rng.nextInt(2); // 4..5
    final rangeMin = level >= 4 ? rng.nextInt(4) : 0;
    final rangeMax = rangeMin + majorStep * majorCount;
    final minorPerMajor = 2 + (level - 1);
    final gauge0 = Gauge(
      kind: GaugeKind.linear,
      label: label,
      rangeMin: rangeMin,
      rangeMax: rangeMax,
      majorStep: majorStep,
      minorPerMajor: minorPerMajor,
      value: 0,
      unit: '%',
    );
    return _withPickedValue(rng, gauge0, level);
  }

  /// Altimeter-style two-needle dial: a fast needle turning once every
  /// [minorCycle] units (the difficulty-scaled fine subdivisions) plus a
  /// slow needle turning once over the whole range (the "thousands"
  /// needle) -- the needle-count difficulty axis.
  static Gauge _buildMultiNeedle(Random rng, int level, String label) {
    const minorCycle = 1000;
    final bracketCount = 6 + level; // range grows with difficulty
    final rangeMax = minorCycle * bracketCount;
    final minorPerMajor = 2 + (level - 1);
    final gauge0 = Gauge(
      kind: GaugeKind.multiNeedle,
      label: label,
      rangeMin: 0,
      rangeMax: rangeMax,
      majorStep: minorCycle,
      minorPerMajor: minorPerMajor,
      value: 0,
      unit: 'ft',
    );
    return _withPickedValue(rng, gauge0, level);
  }

  /// Odometer/drum counter: read exactly, digit by digit -- no needle
  /// interpolation, so [Gauge.tolerance] collapses to "exact integer".
  static Gauge _buildDrum(Random rng, int level, String label) {
    final digitCount = level <= 2
        ? 2
        : level <= 4
        ? 3
        : 4;
    final rangeMax = _pow10(digitCount) - 1;
    final value = rng.nextInt(rangeMax + 1);
    return Gauge(
      kind: GaugeKind.drum,
      label: label,
      rangeMin: 0,
      rangeMax: rangeMax,
      majorStep: 1,
      minorPerMajor: 1,
      value: value,
      digitCount: digitCount,
    );
  }

  static int _pow10(int n) {
    var v = 1;
    for (var i = 0; i < n; i++) {
      v *= 10;
    }
    return v;
  }

  /// Picks the gauge's true reading -- a random minor-tick multiple of
  /// [Gauge.minorStep] from [Gauge.rangeMin], plus (at [level] >= 3) a
  /// small offset well inside half a division so the value is "non-round"
  /// without ever becoming ambiguous between two adjacent ticks (spec:
  /// "values chosen so the reading is unambiguous at the drawn
  /// resolution"). Rounded to 2 decimals for display only: the rounding
  /// error (<= 0.005) is always far smaller than [Gauge.tolerance] (every
  /// gauge here has `minorStep >= 0.6`), so it never risks moving the value
  /// closer to a neighbouring tick than the one it was drawn on.
  static Gauge _withPickedValue(Random rng, Gauge gauge0, int level) {
    final minorStep = gauge0.minorStep;
    final totalTicks = ((gauge0.rangeMax - gauge0.rangeMin) / minorStep)
        .round();
    final tick = rng.nextInt(totalTicks + 1);
    final base = gauge0.rangeMin + tick * minorStep;
    var offset = 0.0;
    if (level >= 3) {
      // Stay within 35% of half a division either side of the tick, so it
      // reads unambiguously closer to `tick` than to a neighbour.
      offset = (rng.nextDouble() * 2 - 1) * 0.35 * gauge0.tolerance;
    }
    const decimals = 2;
    final raw = (base + offset).clamp(gauge0.rangeMin, gauge0.rangeMax);
    final value = _roundTo(raw, decimals);
    return Gauge(
      kind: gauge0.kind,
      label: gauge0.label,
      rangeMin: gauge0.rangeMin,
      rangeMax: gauge0.rangeMax,
      majorStep: gauge0.majorStep,
      minorPerMajor: gauge0.minorPerMajor,
      value: value,
      decimals: decimals,
      unit: gauge0.unit,
      digitCount: gauge0.digitCount,
    );
  }

  static double _roundTo(num value, int decimals) {
    final factor = _pow10(decimals);
    return (value * factor).round() / factor;
  }

  static CountersQuestion _buildQuestion(Random rng, List<Gauge> gauges) {
    final availableTypes = gauges.length >= 2 ? 3 : 1;
    final type = rng.nextInt(availableTypes);
    return switch (type) {
      0 => GaugeValueQuestion(rng.nextInt(gauges.length)),
      1 => _buildCombineQuestion(rng, gauges),
      _ => _buildMatchQuestion(rng, gauges),
    };
  }

  static CountersQuestion _buildCombineQuestion(
    Random rng,
    List<Gauge> gauges,
  ) {
    final aIndex = rng.nextInt(gauges.length);
    var bIndex = rng.nextInt(gauges.length);
    var guard = 0;
    while (bIndex == aIndex && guard < 10) {
      bIndex = rng.nextInt(gauges.length);
      guard++;
    }
    if (bIndex == aIndex) bIndex = (aIndex + 1) % gauges.length;
    return GaugeCombineQuestion(
      aIndex: aIndex,
      bIndex: bIndex,
      isSum: rng.nextBool(),
    );
  }

  /// Picks a target gauge (up to `gauges.length` attempts, redrawing if the
  /// target's value would be ambiguous with another gauge's) and shuffles
  /// the option order.
  static CountersQuestion _buildMatchQuestion(Random rng, List<Gauge> gauges) {
    var targetIndex = rng.nextInt(gauges.length);
    for (var attempt = 0; attempt < gauges.length; attempt++) {
      if (_isUnambiguousTarget(gauges, targetIndex)) break;
      targetIndex = (targetIndex + 1) % gauges.length;
    }
    final optionOrder = List<int>.generate(gauges.length, (i) => i)
      ..shuffle(rng);
    return GaugeMatchQuestion(
      target: gauges[targetIndex].value,
      optionOrder: optionOrder,
      correctOption: optionOrder.indexOf(targetIndex),
    );
  }

  static bool _isUnambiguousTarget(List<Gauge> gauges, int targetIndex) {
    final target = gauges[targetIndex];
    for (var i = 0; i < gauges.length; i++) {
      if (i == targetIndex) continue;
      final other = gauges[i];
      final matchTolerance = target.tolerance + other.tolerance;
      if ((other.value - target.value).abs() <= matchTolerance) return false;
    }
    return true;
  }
}
