import 'dart:math';

import 'matrix_figure.dart';

/// The rule families of spec §2.3 row 11 / US-107. Every [MatrixAttribute]
/// is governed by exactly one of these across the 3x3 grid; most attributes
/// get [constant] (the same value everywhere, i.e. that dimension does not
/// vary in this puzzle) and [attributeCount] of them (`matrix_board.dart`)
/// get one of the other four instead.
enum MatrixRuleKind {
  /// Same value in every cell.
  constant,

  /// `+step mod n` along the axis (row: left to right; column: top to
  /// bottom), the starting value free to differ per row/column.
  progression,

  /// Each row (or column) is a permutation of the same 3 distinct values;
  /// implemented as the cyclic Latin square `value(r, c) = s[(r + c) % 3]`,
  /// which is simultaneously a valid row rule and column rule.
  distributionOfThree,

  /// The axis alternates between 2 distinct values every other cell.
  alternation,

  /// The third cell of the axis is a deterministic combination
  /// (`(a ^ b) % n`) of the first two -- the matrix analogue of the overlay
  /// engine's XOR rule (`spatial_overlay`).
  xorOverlay,
}

/// One governed dimension of a puzzle, kept for the practice explanation
/// (`matrix_explanation.dart`) and, for [xorOverlay]/[alternation]/
/// [progression], for [alongRows] (ignored by [MatrixRuleKind.constant] and
/// [MatrixRuleKind.distributionOfThree], which are direction-agnostic).
class MatrixRuleDescriptor {
  const MatrixRuleDescriptor({
    required this.attribute,
    required this.kind,
    required this.alongRows,
    this.step = 0,
  });

  final MatrixAttribute attribute;
  final MatrixRuleKind kind;
  final bool alongRows;

  /// Progression step, in the attribute's own raw index units (e.g. a
  /// rotation step of 2 is `+90°`).
  final int step;

  /// Whether this rule actually varies the attribute across the grid --
  /// false only for [MatrixRuleKind.constant], the "inert" default every
  /// attribute not picked as one of the puzzle's active dimensions gets.
  bool get isActive => kind != MatrixRuleKind.constant;
}

/// Picks [count] distinct indices in `0..n-1`.
List<int> _pickDistinct(Random rng, int n, int count) {
  assert(
    count <= n,
    'cannot pick $count distinct values out of a $n-value domain',
  );
  final pool = [for (var i = 0; i < n; i++) i]..shuffle(rng);
  return pool.take(count).toList();
}

/// Builds the 3x3 grid of raw domain indices [attribute] takes under [kind]
/// (direction [alongRows]), drawing from [rng]. Returns the grid alongside
/// the [MatrixRuleDescriptor] the puzzle explanation and the solver need.
({List<List<int>> grid, MatrixRuleDescriptor descriptor}) generateAttributeGrid(
  Random rng,
  MatrixAttribute attribute,
  MatrixRuleKind kind, {
  required bool alongRows,
}) {
  final n = matrixDomainSize(attribute);
  final grid = List.generate(3, (_) => List.filled(3, 0));

  var step = 0;

  switch (kind) {
    case MatrixRuleKind.constant:
      final v = rng.nextInt(n);
      for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
          grid[r][c] = v;
        }
      }
      break;

    case MatrixRuleKind.progression:
      step = 1 + rng.nextInt(n - 1); // never 0: a real progression
      if (alongRows) {
        for (var r = 0; r < 3; r++) {
          final base = rng.nextInt(n);
          for (var c = 0; c < 3; c++) {
            grid[r][c] = (base + step * c) % n;
          }
        }
      } else {
        for (var c = 0; c < 3; c++) {
          final base = rng.nextInt(n);
          for (var r = 0; r < 3; r++) {
            grid[r][c] = (base + step * r) % n;
          }
        }
      }
      break;

    case MatrixRuleKind.distributionOfThree:
      final s = _pickDistinct(rng, n, 3);
      for (var r = 0; r < 3; r++) {
        for (var c = 0; c < 3; c++) {
          grid[r][c] = s[(r + c) % 3];
        }
      }
      break;

    case MatrixRuleKind.alternation:
      final pair = _pickDistinct(rng, n, 2);
      if (alongRows) {
        for (var r = 0; r < 3; r++) {
          final phase = rng.nextInt(2);
          for (var c = 0; c < 3; c++) {
            grid[r][c] = pair[(c + phase) % 2];
          }
        }
      } else {
        for (var c = 0; c < 3; c++) {
          final phase = rng.nextInt(2);
          for (var r = 0; r < 3; r++) {
            grid[r][c] = pair[(r + phase) % 2];
          }
        }
      }
      break;

    case MatrixRuleKind.xorOverlay:
      if (alongRows) {
        for (var r = 0; r < 3; r++) {
          final a = rng.nextInt(n);
          final b = rng.nextInt(n);
          grid[r][0] = a;
          grid[r][1] = b;
          grid[r][2] = (a ^ b) % n;
        }
      } else {
        for (var c = 0; c < 3; c++) {
          final a = rng.nextInt(n);
          final b = rng.nextInt(n);
          grid[0][c] = a;
          grid[1][c] = b;
          grid[2][c] = (a ^ b) % n;
        }
      }
  }

  return (
    grid: grid,
    descriptor: MatrixRuleDescriptor(
      attribute: attribute,
      kind: kind,
      alongRows: alongRows,
      step: step,
    ),
  );
}

/// Recomputes the value the bottom-right cell of [grid] *must* take under
/// [descriptor], reading only the 8 visible cells (never `grid[2][2]`,
/// which a generated board never actually fills with a meaningful value
/// for an active rule -- see `matrix_board.dart`). This is the puzzle's
/// solver: independent of however the grid was built, it derives the one
/// answer every rule agrees on, so the generator can verify exactly one of
/// its 8 candidates matches on every attribute before shipping a board.
int inferExpectedValue(
  MatrixRuleDescriptor descriptor,
  List<List<int>> grid,
  int n,
) {
  switch (descriptor.kind) {
    case MatrixRuleKind.constant:
      // Any of the 8 visible cells carries the (shared) value.
      return grid[0][0];

    case MatrixRuleKind.progression:
      return descriptor.alongRows
          ? (grid[2][0] + descriptor.step * 2) % n
          : (grid[0][2] + descriptor.step * 2) % n;

    case MatrixRuleKind.distributionOfThree:
      // grid[r][c] = s[(r+c)%3] and column 0 already reads out `s` in
      // order (s[r] = grid[r][0]); the missing cell is s[(2+2)%3] = s[1].
      return grid[1][0];

    case MatrixRuleKind.alternation:
      // Column parity repeats every 2 steps, so column 2 always mirrors
      // column 0 (row rule) / row 2 always mirrors row 0 (column rule).
      return descriptor.alongRows ? grid[2][0] : grid[0][2];

    case MatrixRuleKind.xorOverlay:
      return descriptor.alongRows
          ? (grid[2][0] ^ grid[2][1]) % n
          : (grid[0][2] ^ grid[1][2]) % n;
  }
}
