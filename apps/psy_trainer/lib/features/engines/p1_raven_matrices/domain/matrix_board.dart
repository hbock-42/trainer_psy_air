import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'matrix_figure.dart';
import 'matrix_rules.dart';

/// The four rule kinds a puzzle can pick for its *active* (varying)
/// attributes; [MatrixRuleKind.constant] is reserved for every attribute
/// not picked as active.
const List<MatrixRuleKind> _activeRuleKinds = [
  MatrixRuleKind.progression,
  MatrixRuleKind.distributionOfThree,
  MatrixRuleKind.alternation,
  MatrixRuleKind.xorOverlay,
];

/// A generated Raven-style matrix: the 3x3 grid of figures with the
/// bottom-right one hidden, the 8 candidate figures (answer + 7
/// distractors, already shuffled) and the rule(s) that produced it.
///
/// Nothing here is stored on the `GeneratedItem` the engine returns: the
/// renderer and the scorer both call [buildMatrixBoard] again with the same
/// `(seed, params, difficulty)` and get back the same board (US-020
/// "Engine", "keep the stimulus in engine-owned data derived again from the
/// seed").
class MatrixBoard {
  const MatrixBoard({
    required this.cells,
    required this.candidates,
    required this.correctIndex,
    required this.rules,
  });

  /// The full 3x3 grid; `cells[2][2]` is the answer, hidden by the renderer
  /// until the item is answered.
  final List<List<MatrixFigure>> cells;

  /// The 8 candidate tiles (already shuffled); `candidates[correctIndex]`
  /// equals `cells[2][2]`.
  final List<MatrixFigure> candidates;
  final int correctIndex;

  /// Every governed dimension, active ones first (see
  /// [MatrixRuleDescriptor.isActive]) -- the order the practice explanation
  /// lists them in.
  final List<MatrixRuleDescriptor> rules;

  MatrixFigure get answer => cells[2][2];

  /// The rules that actually vary something (excludes the "constant"
  /// filler every non-active attribute gets), used by the explanation.
  List<MatrixRuleDescriptor> get activeRules =>
      rules.where((r) => r.isActive).toList();
}

/// Builds the board of the recipe `(seed, params, difficulty)`.
///
/// Deterministic: same inputs, same board (same `Random(seed)` sequence).
/// `difficulty` (1..5) picks how many of the 7 figure attributes vary
/// (`attributeCount`, 2..4) and how many distinct rule kinds govern them
/// (`ruleKindCount`, 1..3) -- spec's "difficulty = simultaneous rules +
/// attribute count + distractor closeness". [inferExpectedValue] then
/// re-derives, from the 8 visible cells alone, the value every rule agrees
/// the missing one must take; a board where more (or fewer) than exactly
/// one of the 8 candidates matches on every attribute is rejected and a
/// fresh one drawn from the same seeded sequence instead of being shipped.
MatrixBoard buildMatrixBoard({
  required int seed,
  required P1RavenMatricesParams params,
  required int difficulty,
}) {
  final rng = Random(seed);
  final d = difficulty.clamp(1, 5);
  final attributeCount = d <= 2 ? 2 : (d <= 4 ? 3 : 4);
  final ruleKindCount = d.clamp(1, 3);
  final closeDistractors = d >= 4;

  const maxAttempts = 500;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final attributes = [...MatrixAttribute.values]..shuffle(rng);
    final active = attributes.take(attributeCount).toSet();

    final kindsPool = [..._activeRuleKinds]..shuffle(rng);
    final chosenKinds = kindsPool.take(min(ruleKindCount, kindsPool.length)).toList();

    final grids = <MatrixAttribute, List<List<int>>>{};
    final descriptors = <MatrixAttribute, MatrixRuleDescriptor>{};
    var activeSeen = 0;
    for (final attribute in MatrixAttribute.values) {
      final MatrixRuleKind kind;
      if (active.contains(attribute)) {
        kind = chosenKinds[activeSeen % chosenKinds.length];
        activeSeen++;
      } else {
        kind = MatrixRuleKind.constant;
      }
      final alongRows = rng.nextBool();
      final built = generateAttributeGrid(rng, attribute, kind, alongRows: alongRows);
      grids[attribute] = built.grid;
      descriptors[attribute] = built.descriptor;
    }

    // The value every rule independently derives for the hidden cell, read
    // only from the 8 visible ones -- the puzzle's unique solution.
    final expected = <int>[
      for (final attribute in MatrixAttribute.values)
        inferExpectedValue(
          descriptors[attribute]!,
          grids[attribute]!,
          matrixDomainSize(attribute),
        ),
    ];

    final cells = List.generate(
      3,
      (r) => List.generate(3, (c) {
        if (r == 2 && c == 2) return MatrixFigure.fromVector(expected);
        return MatrixFigure.fromVector([
          for (final attribute in MatrixAttribute.values) grids[attribute]![r][c],
        ]);
      }),
    );

    // 7 distractors, one per attribute: the expected vector with exactly
    // that one dimension changed to another valid value of its domain (a
    // "neighbour" at high difficulty, any other value otherwise).
    final candidateVectors = <AttributeVector>[expected];
    for (final attribute in MatrixAttribute.values) {
      final n = matrixDomainSize(attribute);
      final idx = attribute.index;
      final correctValue = expected[idx];
      int newValue;
      if (closeDistractors) {
        final delta = rng.nextBool() ? 1 : (n - 1);
        newValue = (correctValue + delta) % n;
      } else {
        do {
          newValue = rng.nextInt(n);
        } while (newValue == correctValue);
      }
      candidateVectors.add([...expected]..[idx] = newValue);
    }

    final order = List.generate(8, (i) => i)..shuffle(rng);
    final shuffledVectors = [for (final i in order) candidateVectors[i]];
    final correctIndex = order.indexOf(0);

    final solved = shuffledVectors
        .where((v) => matrixVectorsEqual(v, expected))
        .length;
    if (solved == 1) {
      return MatrixBoard(
        cells: cells,
        candidates: [for (final v in shuffledVectors) MatrixFigure.fromVector(v)],
        correctIndex: correctIndex,
        rules: MatrixAttribute.values.map((a) => descriptors[a]!).toList(),
      );
    }
    // else: an unlikely collision (a "close" distractor landed back on the
    // expected value some other way); the loop draws a fresh board from
    // the same seeded sequence.
  }
  throw StateError(
    'p1_raven_matrices: no unique board found after $maxAttempts attempts '
    '(seed=$seed, difficulty=$difficulty)',
  );
}
