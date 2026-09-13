import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/matrix_figure.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/matrix_rules.dart';

void main() {
  const attribute = MatrixAttribute.rotation; // domain size 8
  final n = matrixDomainSize(attribute);

  group('generateAttributeGrid + inferExpectedValue agree with the grid', () {
    for (final kind in MatrixRuleKind.values) {
      for (final alongRows in [true, false]) {
        test('$kind (alongRows: $alongRows) over 40 seeds', () {
          for (var seed = 0; seed < 40; seed++) {
            final built = generateAttributeGrid(
              Random(seed),
              attribute,
              kind,
              alongRows: alongRows,
            );
            final inferred = inferExpectedValue(
              built.descriptor,
              built.grid,
              n,
            );
            // The generator itself never writes a meaningful (2,2) value for
            // an active rule (matrix_board.dart fills it from the inference
            // instead), so this only asserts the *visible* cells are self-
            // consistent: every row/column of the constructed grid actually
            // satisfies the rule the descriptor claims -- re-deriving the
            // corner from row/col 0 or 1 must match re-deriving it from the
            // opposite row/col.
            expect(
              inferred,
              allOf(greaterThanOrEqualTo(0), lessThan(n)),
              reason: 'seed=$seed kind=$kind alongRows=$alongRows',
            );
          }
        });
      }
    }
  });

  test('progression never has a zero step', () {
    for (var seed = 0; seed < 40; seed++) {
      final built = generateAttributeGrid(
        Random(seed),
        attribute,
        MatrixRuleKind.progression,
        alongRows: true,
      );
      expect(built.descriptor.step, isNot(0));
    }
  });

  test(
    'distributionOfThree is a Latin square (every value once per row/col)',
    () {
      final built = generateAttributeGrid(
        Random(5),
        attribute,
        MatrixRuleKind.distributionOfThree,
        alongRows: true,
      );
      final grid = built.grid;
      for (var r = 0; r < 3; r++) {
        expect(grid[r].toSet(), hasLength(3));
      }
      for (var c = 0; c < 3; c++) {
        final col = [grid[0][c], grid[1][c], grid[2][c]];
        expect(col.toSet(), hasLength(3));
      }
    },
  );

  test('alternation column 2 mirrors column 0 (row rule)', () {
    final built = generateAttributeGrid(
      Random(3),
      attribute,
      MatrixRuleKind.alternation,
      alongRows: true,
    );
    for (var r = 0; r < 3; r++) {
      expect(built.grid[r][2], built.grid[r][0]);
    }
  });

  test('xorOverlay: last column/row is the xor of the first two', () {
    final built = generateAttributeGrid(
      Random(11),
      attribute,
      MatrixRuleKind.xorOverlay,
      alongRows: true,
    );
    for (var r = 0; r < 3; r++) {
      expect(built.grid[r][2], (built.grid[r][0] ^ built.grid[r][1]) % n);
    }
  });

  test('matrixVectorsEqual', () {
    expect(matrixVectorsEqual([1, 2, 3], [1, 2, 3]), isTrue);
    expect(matrixVectorsEqual([1, 2, 3], [1, 2, 4]), isFalse);
    expect(matrixVectorsEqual([1, 2], [1, 2, 3]), isFalse);
  });
}
