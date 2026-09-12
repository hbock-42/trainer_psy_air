import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// A single arithmetic calculation, generated from a `Random` in a fixed
/// consumption order.
///
/// Shared core of `arithmetic_grid` (PSY0, US-023) and `p1_mental_arithmetic`
/// (PSY1, US-105): both families ask a candidate to work out simple
/// calculations under time pressure, and draw their equalities from the
/// same operand/operation generator so the two engines cannot silently
/// drift apart. [ArithmeticEquationGenerator.build] is called with a
/// `Random` the caller owns (not a seed): `arithmetic_grid` and
/// `p1_mental_arithmetic` each consume it in their own order alongside
/// their own extra draws (wrong-cell selection, trap values, interval
/// widths, equation coefficients), so moving this code here changes
/// nothing about either engine's determinism.
class ArithmeticEquation {
  const ArithmeticEquation({
    required this.expression,
    required this.correctValue,
    this.leftToRightValue,
  });

  /// The calculation as printed, e.g. `'12 + 7'` or `'4²'`.
  final String expression;

  /// The true result of [expression].
  final int correctValue;

  /// Only set for priority equalities (`a ± b × c`): the left-to-right
  /// (wrong) alternative to the priority-respecting [correctValue], used by
  /// `arithmetic_grid`'s trap generator.
  final int? leftToRightValue;
}

/// Builds one [ArithmeticEquation] at a time from a caller-owned `Random`,
/// drawn from [ArithmeticOperation]s capped at a magnitude the caller picks.
///
/// Consumes `rng` in the same fixed order regardless of caller: one draw for
/// the operation, then the operands, so a caller that always asks for one
/// equality per `Random` draw round gets a reproducible sequence.
abstract final class ArithmeticEquationGenerator {
  static ArithmeticEquation build(
    Random rng,
    List<ArithmeticOperation> ops,
    int cap,
  ) {
    final op = ops[rng.nextInt(ops.length)];
    return switch (op) {
      ArithmeticOperation.add => _buildAdd(rng, cap),
      ArithmeticOperation.sub => _buildSub(rng, cap),
      ArithmeticOperation.mul => _buildMul(rng, cap),
      ArithmeticOperation.div => _buildDiv(rng, cap),
      ArithmeticOperation.square => _buildSquare(rng, cap),
      ArithmeticOperation.percent => _buildPercent(rng, cap),
      ArithmeticOperation.priority => _buildPriority(rng, cap),
    };
  }

  static ArithmeticEquation _buildAdd(Random rng, int cap) {
    final a = 1 + rng.nextInt(cap);
    final b = 1 + rng.nextInt(cap);
    return ArithmeticEquation(expression: '$a + $b', correctValue: a + b);
  }

  static ArithmeticEquation _buildSub(Random rng, int cap) {
    final a = 1 + rng.nextInt(cap);
    final b = 1 + rng.nextInt(a);
    return ArithmeticEquation(expression: '$a - $b', correctValue: a - b);
  }

  static ArithmeticEquation _buildMul(Random rng, int cap) {
    final bound = max(2, min(12, cap));
    final a = 2 + rng.nextInt(bound - 1);
    final b = 2 + rng.nextInt(bound - 1);
    return ArithmeticEquation(expression: '$a × $b', correctValue: a * b);
  }

  static ArithmeticEquation _buildDiv(Random rng, int cap) {
    final bound = max(2, min(12, cap));
    final b = 2 + rng.nextInt(bound - 1);
    final q = 2 + rng.nextInt(bound - 1);
    return ArithmeticEquation(expression: '${b * q} ÷ $b', correctValue: q);
  }

  static ArithmeticEquation _buildSquare(Random rng, int cap) {
    final bound = max(2, min(20, cap));
    final n = 2 + rng.nextInt(bound - 1);
    return ArithmeticEquation(expression: '$n²', correctValue: n * n);
  }

  static ArithmeticEquation _buildPercent(Random rng, int cap) {
    const percents = [10, 20, 25, 50];
    final pct = percents[rng.nextInt(percents.length)];
    final unit = 100 ~/ pct;
    final bound = max(1, min(12, cap ~/ unit));
    final k = 1 + rng.nextInt(bound);
    final base = k * unit;
    // base = k * (100 / pct), so pct % of base is exactly k.
    return ArithmeticEquation(expression: '$pct % de $base', correctValue: k);
  }

  static ArithmeticEquation _buildPriority(Random rng, int cap) {
    final bound = max(2, min(10, cap));
    final a = 1 + rng.nextInt(bound);
    final c = 2 + rng.nextInt(bound - 1);
    final isAdd = rng.nextBool();
    if (rng.nextBool()) {
      // a ± (q × c) ÷ c : keep the division operand-only, no swap trap.
      final q = 1 + rng.nextInt(bound);
      final b = q * c;
      final correct = isAdd ? a + q : a - q;
      final expr = '$a ${isAdd ? '+' : '-'} $b ÷ $c';
      return ArithmeticEquation(expression: expr, correctValue: correct);
    }
    final b = 1 + rng.nextInt(bound);
    final correct = isAdd ? a + b * c : a - b * c;
    final altValue = isAdd ? (a + b) * c : (a - b) * c;
    final expr = '$a ${isAdd ? '+' : '-'} $b × $c';
    return ArithmeticEquation(
      expression: expr,
      correctValue: correct,
      leftToRightValue: altValue,
    );
  }
}

/// Scales a raw `maxOperand` param to the actual operand cap used at
/// [difficulty] (1..5): shared by `arithmetic_grid` and
/// `p1_mental_arithmetic` so both scale magnitude the same way.
int arithmeticOperandCap(int maxOperand, int difficulty) {
  final cap = maxOperand < 4 ? 4 : maxOperand;
  final level = difficulty.clamp(minDifficulty, maxDifficulty);
  final scaled = (cap * level / maxDifficulty).round();
  return scaled.clamp(4, cap);
}
