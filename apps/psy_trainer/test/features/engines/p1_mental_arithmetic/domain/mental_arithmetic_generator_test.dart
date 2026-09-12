import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/domain/mental_arithmetic.dart';

void main() {
  const defaultParams = GeneratorParams.p1MentalArithmetic();

  MentalArithmeticProblem build({
    GeneratorParams params = defaultParams,
    int seed = 1,
    int difficulty = 3,
    int index = 0,
  }) => MentalArithmeticGenerator.build(
    params: params as P1MentalArithmeticParams,
    seed: seed,
    difficulty: difficulty,
    index: index,
  );

  group('modeAt / series structure', () {
    test('a run starting at the default freeNumeric cycles every 10 items', () {
      for (var i = 0; i < 10; i++) {
        expect(
          MentalArithmeticGenerator.modeAt(defaultParams, i),
          MentalArithmeticAnswerMode.freeNumeric,
        );
      }
      for (var i = 10; i < 20; i++) {
        expect(
          MentalArithmeticGenerator.modeAt(defaultParams, i),
          MentalArithmeticAnswerMode.equation,
        );
      }
      for (var i = 20; i < 30; i++) {
        expect(
          MentalArithmeticGenerator.modeAt(defaultParams, i),
          MentalArithmeticAnswerMode.smallestInterval,
        );
      }
      for (var i = 30; i < 40; i++) {
        expect(
          MentalArithmeticGenerator.modeAt(defaultParams, i),
          MentalArithmeticAnswerMode.allIntervals,
        );
      }
    });

    test('a run starting at a non-default mode cycles from there', () {
      const params = GeneratorParams.p1MentalArithmetic(
        answerMode: MentalArithmeticAnswerMode.smallestInterval,
      );
      expect(
        MentalArithmeticGenerator.modeAt(params, 0),
        MentalArithmeticAnswerMode.smallestInterval,
      );
      expect(
        MentalArithmeticGenerator.modeAt(params, 10),
        MentalArithmeticAnswerMode.allIntervals,
      );
      expect(
        MentalArithmeticGenerator.modeAt(params, 20),
        MentalArithmeticAnswerMode.freeNumeric,
      );
      expect(
        MentalArithmeticGenerator.modeAt(params, 30),
        MentalArithmeticAnswerMode.equation,
      );
    });

    test('a 10-item short run stays in a single mode', () {
      for (var i = 0; i < 10; i++) {
        expect(
          MentalArithmeticGenerator.modeAt(defaultParams, i),
          MentalArithmeticAnswerMode.freeNumeric,
        );
      }
    });
  });

  test('is deterministic: same params/seed/difficulty/index, same problem', () {
    final a = build(seed: 42, difficulty: 4, index: 3);
    final b = build(seed: 42, difficulty: 4, index: 3);
    expect(a.mode, b.mode);
    expect(a.expression, b.expression);
    expect(a.trueValue, b.trueValue);
    expect(
      a.intervals.map((i) => i.label).toList(),
      b.intervals.map((i) => i.label).toList(),
    );
  });

  test('a different seed usually yields a different problem', () {
    final a = build();
    final b = build(seed: 2);
    expect(a.expression, isNot(b.expression));
  });

  group('freeNumeric', () {
    test('trueValue matches the printed expression', () {
      for (var seed = 0; seed < 200; seed++) {
        final problem = build(seed: seed);
        expect(problem.mode, MentalArithmeticAnswerMode.freeNumeric);
        expect(problem.trueValue, _evaluate(problem.expression));
      }
    });
  });

  group('equation', () {
    test('trueValue (x) actually solves the printed equation', () {
      for (var seed = 0; seed < 200; seed++) {
        final problem = build(seed: seed, index: 10);
        expect(problem.mode, MentalArithmeticAnswerMode.equation);
        expect(_solveEquation(problem.expression), problem.trueValue);
      }
    });
  });

  group('smallestInterval', () {
    test('4 or 5 options, every option contains the true value', () {
      for (var seed = 0; seed < 300; seed++) {
        final problem = build(seed: seed, index: 20);
        expect(problem.mode, MentalArithmeticAnswerMode.smallestInterval);
        expect(problem.intervals.length, inInclusiveRange(4, 5));
        for (final interval in problem.intervals) {
          expect(interval.contains(problem.trueValue), isTrue);
        }
      }
    });

    test('the tightest interval is unique: no tie in width', () {
      for (var seed = 0; seed < 300; seed++) {
        for (
          var difficulty = minDifficulty;
          difficulty <= maxDifficulty;
          difficulty++
        ) {
          final problem = build(seed: seed, difficulty: difficulty, index: 20);
          final widths = problem.intervals.map((i) => i.width).toList();
          final minWidth = widths.reduce((a, b) => a < b ? a : b);
          expect(
            widths.where((w) => w == minWidth).length,
            1,
            reason: 'seed=$seed difficulty=$difficulty widths=$widths',
          );
          expect(problem.intervals[problem.tightestIndex!].width, minWidth);
        }
      }
    });
  });

  group('allIntervals', () {
    test('5 or 6 options, 1 to 4 of them contain the true value', () {
      for (var seed = 0; seed < 300; seed++) {
        final problem = build(seed: seed, index: 30);
        expect(problem.mode, MentalArithmeticAnswerMode.allIntervals);
        expect(problem.intervals.length, inInclusiveRange(5, 6));
        expect(problem.containingIndices.length, inInclusiveRange(1, 4));
        expect(
          problem.containingIndices.length,
          lessThan(problem.intervals.length),
        );
      }
    });

    test('non-containing intervals really exclude the true value', () {
      for (var seed = 0; seed < 300; seed++) {
        final problem = build(seed: seed, index: 30);
        final containing = problem.containingIndices;
        for (var i = 0; i < problem.intervals.length; i++) {
          expect(
            problem.intervals[i].contains(problem.trueValue),
            containing.contains(i),
          );
        }
      }
    });
  });
}

/// Evaluates a `freeNumeric`-mode expression string
/// (`+ - × ÷ % de`, `arithmetic_grid`-style), independently of the
/// generator, as a belt-and-braces check on `trueValue`.
int _evaluate(String expression) {
  if (expression.contains(' % de ')) {
    final parts = expression.split(' % de ');
    final pct = int.parse(parts[0]);
    final base = int.parse(parts[1]);
    return base * pct ~/ 100;
  }
  final signIndex = _topLevelSignIndex(expression);
  if (signIndex != null) {
    final a = int.parse(expression.substring(0, signIndex).trim());
    final isAdd = expression[signIndex] == '+';
    final rest = expression.substring(signIndex + 1).trim();
    final restValue = _evalTerm(rest);
    return isAdd ? a + restValue : a - restValue;
  }
  return _evalTerm(expression);
}

int _evalTerm(String expression) {
  if (expression.contains(' × ')) {
    final parts = expression.split(' × ');
    return int.parse(parts[0]) * int.parse(parts[1]);
  }
  if (expression.contains(' ÷ ')) {
    final parts = expression.split(' ÷ ');
    return int.parse(parts[0]) ~/ int.parse(parts[1]);
  }
  return int.parse(expression);
}

int? _topLevelSignIndex(String expression) {
  for (var i = 1; i < expression.length; i++) {
    if (expression[i] == '+' || expression[i] == '-') return i;
  }
  return null;
}

/// Solves an `'ax + b = c'` / `'ax - b = c'` equation string, independently
/// of the generator, as a belt-and-braces check on `trueValue`.
int _solveEquation(String expression) {
  final parts = expression.split(' = ');
  final c = int.parse(parts[1]);
  final left = parts[0];
  final xIndex = left.indexOf('x');
  final a = int.parse(left.substring(0, xIndex));
  final rest = left.substring(xIndex + 1).trim();
  final isAdd = rest.startsWith('+');
  final b = int.parse(rest.substring(1).trim());
  return isAdd ? (c - b) ~/ a : (c + b) ~/ a;
}
