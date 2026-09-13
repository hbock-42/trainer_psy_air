import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../_shared/arithmetic/arithmetic_equation.dart';

/// The default operation mix `p1_mental_arithmetic` draws its underlying
/// calculations from: `arithmetic_grid`'s square/priority traps are about
/// spotting a *wrong printed value*, which this family never shows, so
/// they are left out here and only the four operations plus percentages
/// (which read naturally as "what's the value?") are used.
const List<ArithmeticOperation> _mentalArithmeticOperations = [
  ArithmeticOperation.add,
  ArithmeticOperation.sub,
  ArithmeticOperation.mul,
  ArithmeticOperation.div,
  ArithmeticOperation.percent,
];

/// One bracket option of the `smallest_interval` / `all_intervals` modes.
class MentalArithmeticInterval {
  const MentalArithmeticInterval({required this.low, required this.high});

  final int low;
  final int high;

  bool contains(int value) => value >= low && value <= high;

  /// `high - low`: smaller is "tighter".
  int get width => high - low;

  /// `'[12 ; 18]'`.
  String get label => '[$low ; $high]';
}

/// A materialised `p1_mental_arithmetic` problem (spec §2.3/§4.1 row 12,
/// US-105): the underlying arithmetic value plus whatever the current
/// [MentalArithmeticAnswerMode] needs to ask for it. The engine, the
/// scorer and the renderer all derive it again from
/// `(params, seed, difficulty, index)` through
/// [MentalArithmeticGenerator.build] rather than storing it on the item
/// (only the `all_intervals` mode needs to: the other three modes are
/// concrete self-scoring items).
class MentalArithmeticProblem {
  const MentalArithmeticProblem({
    required this.mode,
    required this.expression,
    required this.trueValue,
    this.intervals = const [],
    this.tightestIndex,
  });

  final MentalArithmeticAnswerMode mode;

  /// The calculation/equation as printed, e.g. `'12 + 7'` or
  /// `'3x + 7 = 22'`.
  final String expression;

  /// `freeNumeric`/`equation`: the expected answer. `smallestInterval` /
  /// `allIntervals`: the true value the intervals are built around.
  final int trueValue;

  /// `smallestInterval` / `allIntervals` only: the bracket options, in the
  /// order they should be displayed.
  final List<MentalArithmeticInterval> intervals;

  /// `smallestInterval` only: the index into [intervals] of the unique
  /// tightest one containing [trueValue].
  final int? tightestIndex;

  /// `allIntervals` only: indices into [intervals] that actually contain
  /// [trueValue] (1..4 of them, spec §2.3 row 12).
  Set<int> get containingIndices => {
    for (var i = 0; i < intervals.length; i++)
      if (intervals[i].contains(trueValue)) i,
  };
}

/// Builds the deterministic [MentalArithmeticProblem] of one
/// `p1_mental_arithmetic` recipe.
///
/// The series structure (10 items per answer mode, 4 series in a row) is
/// derived from [index] alone: `modeAt` cycles through the four
/// [MentalArithmeticAnswerMode] values every 10 items, starting from
/// [P1MentalArithmeticParams.answerMode] (so a 10-item run using the
/// family's default params plays entirely in that one mode, matching both
/// the `psy1_short` single-series warm-up and a stand-alone practice run
/// of one mode; the `psy1_full` 40-item section cycles through all four in
/// order because it always starts from the default `freeNumeric`).
/// `Random(seed)` only, consumed in a fixed order per mode, so the same
/// `(params, seed, difficulty, index)` always yields the same problem.
abstract final class MentalArithmeticGenerator {
  static const int itemsPerSeries = 10;

  /// The answer mode of item [index] of a `p1_mental_arithmetic` run whose
  /// first series starts at [P1MentalArithmeticParams.answerMode].
  static MentalArithmeticAnswerMode modeAt(GeneratorParams params, int index) {
    const modes = MentalArithmeticAnswerMode.values;
    final typed = params as P1MentalArithmeticParams;
    final start = modes.indexOf(typed.answerMode);
    final series = index < 0 ? 0 : index ~/ itemsPerSeries;
    return modes[(start + series) % modes.length];
  }

  static MentalArithmeticProblem build({
    required P1MentalArithmeticParams params,
    required int seed,
    required int difficulty,
    required int index,
  }) {
    final rng = Random(seed);
    final mode = modeAt(params, index);
    final cap = arithmeticOperandCap(params.maxOperand, difficulty);

    return switch (mode) {
      MentalArithmeticAnswerMode.freeNumeric => _buildFreeNumeric(rng, cap),
      MentalArithmeticAnswerMode.equation => _buildEquation(rng, cap),
      MentalArithmeticAnswerMode.smallestInterval => _buildSmallestInterval(
        rng,
        cap,
        difficulty,
      ),
      MentalArithmeticAnswerMode.allIntervals => _buildAllIntervals(
        rng,
        cap,
        difficulty,
      ),
    };
  }

  static MentalArithmeticProblem _buildFreeNumeric(Random rng, int cap) {
    final equation = ArithmeticEquationGenerator.build(
      rng,
      _mentalArithmeticOperations,
      cap,
    );
    return MentalArithmeticProblem(
      mode: MentalArithmeticAnswerMode.freeNumeric,
      expression: equation.expression,
      trueValue: equation.correctValue,
    );
  }

  /// `ax + b = c` (or `ax - b = c`): solve for `x`, e.g. `'3x + 7 = 22'`.
  static MentalArithmeticProblem _buildEquation(Random rng, int cap) {
    final coefficientBound = max(2, min(9, cap));
    final a = 2 + rng.nextInt(coefficientBound - 1);
    final xBound = max(1, min(12, cap));
    final x = 1 + rng.nextInt(xBound);
    final bBound = max(1, cap);
    final b = 1 + rng.nextInt(bBound);
    final isAdd = rng.nextBool();
    final c = isAdd ? a * x + b : a * x - b;
    final expression = '${a}x ${isAdd ? '+' : '-'} $b = $c';
    return MentalArithmeticProblem(
      mode: MentalArithmeticAnswerMode.equation,
      expression: expression,
      trueValue: x,
    );
  }

  static MentalArithmeticProblem _buildSmallestInterval(
    Random rng,
    int cap,
    int difficulty,
  ) {
    final equation = ArithmeticEquationGenerator.build(
      rng,
      _mentalArithmeticOperations,
      cap,
    );
    final value = equation.correctValue;
    final count = 4 + rng.nextInt(2); // 4..5
    final scale = max(count, _intervalScale(cap, difficulty));
    final widths = <int>{};
    while (widths.length < count) {
      widths.add(1 + rng.nextInt(scale));
    }
    final ordered = widths.toList()..sort();
    final built = <MentalArithmeticInterval>[
      for (final width in ordered) _splitAround(rng, value, width),
    ];
    // Unique by construction (distinct total widths): the first of `ordered`
    // is the tightest, but track it by identity through the shuffle below
    // rather than assuming position.
    final tightest = built[0];
    final display = [...built]..shuffle(rng);
    return MentalArithmeticProblem(
      mode: MentalArithmeticAnswerMode.smallestInterval,
      expression: equation.expression,
      trueValue: value,
      intervals: display,
      tightestIndex: display.indexOf(tightest),
    );
  }

  static MentalArithmeticProblem _buildAllIntervals(
    Random rng,
    int cap,
    int difficulty,
  ) {
    final equation = ArithmeticEquationGenerator.build(
      rng,
      _mentalArithmeticOperations,
      cap,
    );
    final value = equation.correctValue;
    final total = 5 + rng.nextInt(2); // 5..6
    final containingCount = min(total - 1, 1 + rng.nextInt(4)); // 1..4
    final scale = max(containingCount, _intervalScale(cap, difficulty));

    final widths = <int>{};
    while (widths.length < containingCount) {
      widths.add(1 + rng.nextInt(scale));
    }
    final containing = [
      for (final width in widths) _splitAround(rng, value, width),
    ];

    final excluding = <MentalArithmeticInterval>[];
    while (excluding.length < total - containingCount) {
      final gap = 1 + rng.nextInt(scale);
      final width = 1 + rng.nextInt(scale);
      final above = rng.nextBool();
      final low = above ? value + gap : value - gap - width;
      final high = low + width;
      excluding.add(MentalArithmeticInterval(low: low, high: high));
    }

    final display = [...containing, ...excluding]..shuffle(rng);
    return MentalArithmeticProblem(
      mode: MentalArithmeticAnswerMode.allIntervals,
      expression: equation.expression,
      trueValue: value,
      intervals: display,
    );
  }

  /// Splits a total [width] into a low/high half around [value] so that
  /// the interval is not always centred (`low = value - left`,
  /// `high = value + right`, `left + right == width`).
  static MentalArithmeticInterval _splitAround(
    Random rng,
    int value,
    int width,
  ) {
    final left = rng.nextInt(width + 1);
    final right = width - left;
    return MentalArithmeticInterval(low: value - left, high: value + right);
  }

  /// Half-width scale of the interval options: wider at higher difficulty
  /// (harder to eyeball) but always at least a few units so distinct
  /// widths are possible.
  static int _intervalScale(int cap, int difficulty) {
    final base = max(3, cap ~/ 4);
    final level = difficulty.clamp(minDifficulty, maxDifficulty);
    return max(3, (base * level / maxDifficulty).round());
  }
}
