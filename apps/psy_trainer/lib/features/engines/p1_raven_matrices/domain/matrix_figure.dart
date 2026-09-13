/// The small figure drawn in one cell of a Raven-style 3x3 matrix (spec
/// §2.3 row 11, US-107): an outer shape, an optional inner shape, how many
/// times the outer shape repeats, its rotation, its fill pattern, its size
/// and where in the cell it sits.
///
/// Every field is one *attribute* a [MatrixRuleKind] (`matrix_rules.dart`)
/// can vary across a row or a column; a puzzle governs each of the 7
/// attributes with exactly one rule (most of them the trivial "constant"
/// rule), so [attributeCount] of them actually vary and the rest are the
/// same figure-part everywhere.
enum ShapeKind { circle, square, triangle, diamond, star, hexagon }

enum FillPattern { solid, hatched, outline, dotted }

/// Where the figure sits within its cell; also doubles as a rule dimension
/// (a puzzle can move the cluster clockwise across a row, say).
enum PositionSlot { center, topLeft, topRight, bottomLeft, bottomRight }

/// One dimension of a [MatrixFigure], in the fixed order used to index an
/// *attribute vector* (`List<int>` of length [values.length]) throughout
/// `matrix_rules.dart`/`matrix_board.dart`: `vector[MatrixAttribute.x.index]`
/// (`Enum.index`, not a separate lookup) is `x`'s raw domain value.
enum MatrixAttribute { outerShape, innerShape, count, rotation, fill, size, position }

/// Number of distinct values [attribute] can take, i.e. the modulus its
/// index arithmetic (`matrix_rules.dart`) wraps around. Every domain has at
/// least 3 values so "pick 3 distinct values" (distribution-of-three) and
/// "pick 2 distinct values" (alternation) always have room.
int matrixDomainSize(MatrixAttribute attribute) => switch (attribute) {
  MatrixAttribute.outerShape => ShapeKind.values.length,
  MatrixAttribute.innerShape => ShapeKind.values.length + 1, // 0 = none
  MatrixAttribute.count => 4, // 1..4
  MatrixAttribute.rotation => 8, // 0, 45, .., 315 degrees
  MatrixAttribute.fill => FillPattern.values.length,
  MatrixAttribute.size => 3, // small/medium/large
  MatrixAttribute.position => PositionSlot.values.length,
};

/// A figure's raw dimensions, one raw domain index per [MatrixAttribute], in
/// [MatrixAttribute.values] order. Equality is by value (`ListEquality`-style)
/// so the solver can compare candidates directly.
typedef AttributeVector = List<int>;

bool matrixVectorsEqual(AttributeVector a, AttributeVector b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

/// The concrete, drawable figure a candidate's [AttributeVector] describes.
class MatrixFigure {
  const MatrixFigure({
    required this.outerShape,
    required this.innerShape,
    required this.count,
    required this.rotationStep,
    required this.fill,
    required this.sizeStep,
    required this.position,
  });

  factory MatrixFigure.fromVector(AttributeVector vector) => MatrixFigure(
    outerShape: ShapeKind.values[vector[MatrixAttribute.outerShape.index]],
    innerShape: vector[MatrixAttribute.innerShape.index] == 0
        ? null
        : ShapeKind.values[vector[MatrixAttribute.innerShape.index] - 1],
    count: vector[MatrixAttribute.count.index] + 1,
    rotationStep: vector[MatrixAttribute.rotation.index],
    fill: FillPattern.values[vector[MatrixAttribute.fill.index]],
    sizeStep: vector[MatrixAttribute.size.index],
    position: PositionSlot.values[vector[MatrixAttribute.position.index]],
  );

  final ShapeKind outerShape;
  final ShapeKind? innerShape;

  /// 1..4 copies of [outerShape] drawn in the cell.
  final int count;

  /// 0..7, each step 45°.
  final int rotationStep;
  final FillPattern fill;

  /// 0 (small) .. 2 (large).
  final int sizeStep;
  final PositionSlot position;

  int get rotationDegrees => rotationStep * 45;

  @override
  bool operator ==(Object other) =>
      other is MatrixFigure &&
      other.outerShape == outerShape &&
      other.innerShape == innerShape &&
      other.count == count &&
      other.rotationStep == rotationStep &&
      other.fill == fill &&
      other.sizeStep == sizeStep &&
      other.position == position;

  @override
  int get hashCode => Object.hash(
    outerShape,
    innerShape,
    count,
    rotationStep,
    fill,
    sizeStep,
    position,
  );

  @override
  String toString() =>
      'MatrixFigure(outer: $outerShape, inner: $innerShape, count: $count, '
      'rotation: $rotationDegrees°, fill: $fill, size: $sizeStep, '
      'position: $position)';
}
