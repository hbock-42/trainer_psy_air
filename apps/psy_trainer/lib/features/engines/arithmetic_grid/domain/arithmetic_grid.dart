import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../_shared/arithmetic/arithmetic_equation.dart';

/// One equality of an [ArithmeticGrid]: a fixed calculation ([expression],
/// [correctValue]) and the value actually printed next to it
/// ([displayedValue]), equal to [correctValue] on a correct cell and off by
/// a plausible error otherwise.
class ArithmeticGridCell {
  const ArithmeticGridCell({
    required this.expression,
    required this.correctValue,
    required this.displayedValue,
  });

  /// The calculation as printed, e.g. `'12 + 7'` or `'4²'`.
  final String expression;

  /// The true result of [expression].
  final int correctValue;

  /// The result printed next to [expression]; differs from [correctValue]
  /// exactly on the cells the candidate must flag.
  final int displayedValue;

  /// Whether this equality, as printed, is false.
  bool get isWrong => displayedValue != correctValue;

  /// `'12 + 7 = 20'`.
  String get label => '$expression = $displayedValue';
}

/// A materialised `arithmetic_grid` item (spec §2.4-J): [size] equalities,
/// 0..4 of them wrong. Purely a value: the engine, the scorer and the
/// renderer all derive it again from `(params, seed, difficulty)` through
/// [ArithmeticGridGenerator.build] rather than storing it on the item.
class ArithmeticGrid {
  const ArithmeticGrid({required this.size, required this.cells});

  final GridSize size;

  /// Row-major, length `size.rows * size.cols`.
  final List<ArithmeticGridCell> cells;

  /// Indices (row-major) of the cells that are actually wrong.
  Set<int> get wrongIndices => {
    for (var i = 0; i < cells.length; i++)
      if (cells[i].isWrong) i,
  };
}

/// Builds the deterministic [ArithmeticGrid] of one `arithmetic_grid` recipe.
///
/// `Random(seed)` only, consumed in a fixed order (wrong count, then one
/// equality per cell, then which cells are wrong, then their trap), so the
/// same `(params, seed, difficulty)` always yields the same grid.
abstract final class ArithmeticGridGenerator {
  static ArithmeticGrid build({
    required ArithmeticGridParams params,
    required int seed,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final cellCount = params.grid.rows * params.grid.cols;
    final wrongMin = params.wrongMin.clamp(0, cellCount);
    final wrongMax = params.wrongMax.clamp(wrongMin, cellCount);
    final wrongCount = wrongMin + rng.nextInt(wrongMax - wrongMin + 1);
    final operandCap = _operandCap(params.maxOperand, difficulty);
    final ops = params.operations.isEmpty
        ? ArithmeticOperation.values
        : params.operations;

    final used = <String>{};
    final built = <ArithmeticEquation>[];
    for (var i = 0; i < cellCount; i++) {
      var equality = ArithmeticEquationGenerator.build(rng, ops, operandCap);
      var attempts = 0;
      while (used.contains(equality.expression) && attempts < 20) {
        equality = ArithmeticEquationGenerator.build(rng, ops, operandCap);
        attempts++;
      }
      used.add(equality.expression);
      built.add(equality);
    }

    final wrongIndices = _pickWrongIndices(rng, cellCount, wrongCount);
    final cells = <ArithmeticGridCell>[
      for (var i = 0; i < cellCount; i++)
        _finalise(rng, built[i], wrongIndices.contains(i), difficulty),
    ];

    return ArithmeticGrid(size: params.grid, cells: cells);
  }

  static int _operandCap(int maxOperand, int difficulty) =>
      arithmeticOperandCap(maxOperand, difficulty);

  static Set<int> _pickWrongIndices(Random rng, int cellCount, int wrongCount) {
    final indices = List<int>.generate(cellCount, (i) => i)..shuffle(rng);
    return indices.take(wrongCount).toSet();
  }

  static ArithmeticGridCell _finalise(
    Random rng,
    ArithmeticEquation equality,
    bool shouldBeWrong,
    int difficulty,
  ) {
    final displayed = shouldBeWrong
        ? _applyTrap(rng, equality, difficulty)
        : equality.correctValue;
    return ArithmeticGridCell(
      expression: equality.expression,
      correctValue: equality.correctValue,
      displayedValue: displayed,
    );
  }

  /// Picks a plausible wrong value for [equality]: off by one, off by ten,
  /// sign-flipped, or (priority equalities only) computed left-to-right
  /// instead of respecting operator priority. Always differs from the
  /// correct value, so a wrong cell is never ambiguous. Low difficulty
  /// favours the obvious traps (sign flip, off by ten); high difficulty
  /// favours the subtle ones (off by one, swapped priority).
  static int _applyTrap(
    Random rng,
    ArithmeticEquation equality,
    int difficulty,
  ) {
    final subtle = <int>[];
    void addSubtle(int value) {
      if (value != equality.correctValue) subtle.add(value);
    }

    if (equality.leftToRightValue != null) {
      addSubtle(equality.leftToRightValue!);
    }
    addSubtle(equality.correctValue + 1);
    addSubtle(equality.correctValue - 1);

    final obvious = <int>[];
    void addObvious(int value) {
      if (value != equality.correctValue) obvious.add(value);
    }

    if (equality.correctValue != 0) addObvious(-equality.correctValue);
    addObvious(equality.correctValue + 10);
    addObvious(equality.correctValue - 10);

    final ordered = difficulty >= 4
        ? [...subtle, ...obvious]
        : difficulty <= 2
        ? [...obvious, ...subtle]
        : [...subtle, ...obvious];

    if (ordered.isEmpty) return equality.correctValue + 1;
    final window = min(2, ordered.length);
    return ordered[rng.nextInt(window)];
  }
}
