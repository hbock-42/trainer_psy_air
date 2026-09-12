/// One cell of a cube net, at ([row], [col]) of its 2D layout (row grows
/// downward, col grows rightward -- screen/grid convention).
class NetCell {
  const NetCell(this.row, this.col);

  final int row;
  final int col;

  @override
  bool operator ==(Object other) =>
      other is NetCell && other.row == row && other.col == col;

  @override
  int get hashCode => Object.hash(row, col);

  @override
  String toString() => '($row,$col)';
}

/// A hexomino laid out on a grid: 6 edge-connected [cells], one net shape
/// of the 11 that fold into a cube (`cube_nets.dart`).
///
/// [id] is stable across app versions (used in generated item recipes
/// indirectly, through the seed -- see `cube_net_puzzle.dart`); do not
/// renumber existing entries in `cube_nets.dart`.
class CubeNet {
  CubeNet({required this.id, required List<NetCell> cells})
    : cells = List.unmodifiable(cells) {
    if (cells.length != 6) {
      throw ArgumentError.value(cells, 'cells', 'a cube net has 6 cells');
    }
  }

  final String id;
  final List<NetCell> cells;

  int get width => cells.map((c) => c.col).reduce((a, b) => a > b ? a : b) + 1;
  int get height => cells.map((c) => c.row).reduce((a, b) => a > b ? a : b) + 1;

  /// Indices of the cells edge-adjacent (grid distance 1) to
  /// `cells[cellIndex]`.
  List<int> neighboursOf(int cellIndex) {
    final cell = cells[cellIndex];
    final result = <int>[];
    for (var i = 0; i < cells.length; i++) {
      if (i == cellIndex) continue;
      final other = cells[i];
      final dRow = (other.row - cell.row).abs();
      final dCol = (other.col - cell.col).abs();
      if (dRow + dCol == 1) result.add(i);
    }
    return result;
  }

  @override
  String toString() => 'CubeNet($id, $cells)';
}
