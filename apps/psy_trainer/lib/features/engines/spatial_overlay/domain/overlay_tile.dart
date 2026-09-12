import 'overlay_algebra.dart';

/// A polyomino-like tile: a small set of contiguous navy/grey cells inside a
/// [rows] x [cols] bounding box, glissée (dragged) onto the grid but never
/// rotated -- the lesson notes rotation is "non signalée par les candidats"
/// and our simulation's tiles slide without turning.
class TileShape {
  TileShape({
    required this.rows,
    required this.cols,
    required List<List<CellColour?>> cells,
  }) : cells = List.unmodifiable(cells.map(List<CellColour?>.unmodifiable));

  final int rows;
  final int cols;

  /// `cells[r][c]` is the tile's colour at its local `(r, c)`, or null when
  /// that cell of the bounding box is not part of the shape.
  final List<List<CellColour?>> cells;

  /// The tile's own cells as `(row, col, colour)` offsets from its
  /// top-left, in row-major order.
  late final List<(int, int, CellColour)> offsets = [
    for (var r = 0; r < rows; r++)
      for (var c = 0; c < cols; c++)
        if (cells[r][c] != null) (r, c, cells[r][c]!),
  ];

  int get cellCount => offsets.length;

  /// Every top-left offset at which the tile fits inside a [gridRows] x
  /// [gridCols] grid (empty when the tile is bigger than the grid).
  List<(int, int)> positionsIn(int gridRows, int gridCols) => [
    for (var r = 0; r <= gridRows - rows; r++)
      for (var c = 0; c <= gridCols - cols; c++) (r, c),
  ];

  /// Structural equality (same footprint and colours), used by the
  /// generator to reject two identical tiles in one board -- an ambiguity
  /// the solver's "unique placement" guarantee would not otherwise catch,
  /// since swapping two identical tiles' positions yields the same grid.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TileShape || rows != other.rows || cols != other.cols) {
      return false;
    }
    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        if (cells[r][c] != other.cells[r][c]) return false;
      }
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(rows, cols, Object.hashAll(offsets));
}
