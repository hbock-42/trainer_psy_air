import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/arithmetic_grid/domain/arithmetic_grid.dart';

void main() {
  const defaultParams = GeneratorParams.arithmeticGrid();

  ArithmeticGrid build({
    GeneratorParams params = defaultParams,
    int seed = 1,
    int difficulty = 3,
  }) => ArithmeticGridGenerator.build(
    params: params as ArithmeticGridParams,
    seed: seed,
    difficulty: difficulty,
  );

  test('is deterministic: same params/seed/difficulty, same grid', () {
    final a = build(seed: 42, difficulty: 4);
    final b = build(seed: 42, difficulty: 4);
    expect(
      a.cells.map((c) => c.label).toList(),
      b.cells.map((c) => c.label).toList(),
    );
    expect(a.wrongIndices, b.wrongIndices);
  });

  test('a different seed usually yields a different grid', () {
    final a = build();
    final b = build(seed: 2);
    expect(a.cells.map((c) => c.label), isNot(b.cells.map((c) => c.label)));
  });

  test('always builds the announced 3x3 = 9 cells by default', () {
    final grid = build();
    expect(grid.cells, hasLength(9));
    expect(grid.size, const GridSize(rows: 3, cols: 3));
  });

  test('respects a custom grid size', () {
    const params = GeneratorParams.arithmeticGrid(
      grid: GridSize(rows: 2, cols: 2),
      wrongMax: 2,
    );
    for (var seed = 0; seed < 50; seed++) {
      final grid = build(params: params, seed: seed);
      expect(grid.cells, hasLength(4));
      expect(grid.wrongIndices.length, inInclusiveRange(0, 2));
    }
  });

  test('the wrong-cell count always falls within wrongMin..wrongMax, over many '
      'seeds and difficulties', () {
    const params = GeneratorParams.arithmeticGrid(wrongMin: 1);
    for (var seed = 0; seed < 300; seed++) {
      for (
        var difficulty = minDifficulty;
        difficulty <= maxDifficulty;
        difficulty++
      ) {
        final grid = build(params: params, seed: seed, difficulty: difficulty);
        expect(
          grid.wrongIndices.length,
          inInclusiveRange(1, 4),
          reason: 'seed=$seed difficulty=$difficulty',
        );
      }
    }
  });

  test('wrongMin == wrongMax == 0 never marks a cell wrong', () {
    const params = GeneratorParams.arithmeticGrid(wrongMax: 0);
    for (var seed = 0; seed < 50; seed++) {
      final grid = build(params: params, seed: seed);
      expect(grid.wrongIndices, isEmpty);
      for (final cell in grid.cells) {
        expect(cell.displayedValue, cell.correctValue);
      }
    }
  });

  test('no item is ambiguous: a wrong cell always differs from its correct '
      'value, a correct cell always matches it, over many seeds', () {
    for (var seed = 0; seed < 500; seed++) {
      final grid = build(seed: seed, difficulty: 1 + seed % 5);
      final wrong = grid.wrongIndices;
      for (var i = 0; i < grid.cells.length; i++) {
        final cell = grid.cells[i];
        if (wrong.contains(i)) {
          expect(
            cell.displayedValue,
            isNot(cell.correctValue),
            reason: 'seed=$seed cell=$i (${cell.expression})',
          );
        } else {
          expect(
            cell.displayedValue,
            cell.correctValue,
            reason: 'seed=$seed cell=$i (${cell.expression})',
          );
        }
      }
    }
  });

  test('every equality actually evaluates to its correctValue', () {
    const params = GeneratorParams.arithmeticGrid(
      operations: [
        ArithmeticOperation.add,
        ArithmeticOperation.sub,
        ArithmeticOperation.mul,
        ArithmeticOperation.div,
        ArithmeticOperation.square,
        ArithmeticOperation.percent,
        ArithmeticOperation.priority,
      ],
    );
    for (var seed = 0; seed < 200; seed++) {
      final grid = build(params: params, seed: seed);
      for (final cell in grid.cells) {
        expect(
          cell.correctValue,
          _evaluate(cell.expression),
          reason: cell.expression,
        );
      }
    }
  });

  test('higher difficulty allows larger operands (add/sub)', () {
    const params = GeneratorParams.arithmeticGrid(
      operations: [ArithmeticOperation.add],
    );
    int maxTerm(ArithmeticGrid grid) => grid.cells
        .expand((c) => c.expression.split(' + '))
        .map(int.parse)
        .reduce((a, b) => a > b ? a : b);

    var sawLarge = false;
    for (var seed = 0; seed < 200; seed++) {
      final grid = build(params: params, seed: seed, difficulty: 5);
      if (maxTerm(grid) > 40) sawLarge = true;
    }
    expect(sawLarge, isTrue);
  });
}

/// Evaluates a rendered equality string back to an int, for a
/// belt-and-braces check that `correctValue` is not a lie. Supports the
/// operator set the generator prints: `+ - × ÷ ² % de`, and a leading
/// `a ± (b × c | b ÷ c)` priority combination.
int _evaluate(String expression) {
  if (expression.endsWith('²')) {
    final n = int.parse(expression.substring(0, expression.length - 1));
    return n * n;
  }
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
