import 'cube_face.dart';
import 'cube_folding.dart';
import 'cube_net.dart';

/// The 11 hexominoes that fold into a cube (out of the 35 free hexominoes;
/// a textbook result -- see e.g. Wikipedia "Net (polyhedron)"), computed
/// here rather than hand-transcribed from a picture: [_freeHexominoes]
/// enumerates every free (translation/rotation/reflection-independent)
/// 6-cell polyomino by growing them cell by cell, and [cubeNets] keeps
/// exactly the ones [foldNet] maps onto 6 *distinct* [CubeFace] values --
/// which is the definition of a valid cube net. `cube_nets_test.dart`
/// pins both counts (35, then 11) so a change to the growth or folding
/// code that silently breaks either is caught immediately.
final List<CubeNet> cubeNets = _buildCubeNets();

List<CubeNet> _buildCubeNets() {
  final hexominoes = _freeHexominoes();
  final nets = <CubeNet>[];
  for (final cells in hexominoes) {
    final sorted = cells.toList()
      ..sort((a, b) {
        final rowCmp = a.row.compareTo(b.row);
        return rowCmp != 0 ? rowCmp : a.col.compareTo(b.col);
      });
    final candidate = CubeNet(id: 'pending', cells: sorted);
    final folded = foldNet(candidate);
    final distinctFaces = folded.values.map((f) => f.face).toSet();
    if (distinctFaces.length == 6) nets.add(candidate);
  }
  // Deterministic, stable order: by height, width, then reading order of
  // cells -- independent of the enumeration's own (canonical-key) order.
  nets.sort((a, b) {
    final byHeight = a.height.compareTo(b.height);
    if (byHeight != 0) return byHeight;
    final byWidth = a.width.compareTo(b.width);
    if (byWidth != 0) return byWidth;
    return a.cells.toString().compareTo(b.cells.toString());
  });
  return [
    for (var i = 0; i < nets.length; i++)
      CubeNet(
        id: 'net${(i + 1).toString().padLeft(2, '0')}',
        cells: nets[i].cells,
      ),
  ];
}

/// Every free hexomino (6-cell polyomino, up to translation, rotation and
/// reflection), as one representative cell set each, grown from single
/// cells: every polyomino of size n+1 has a cell whose removal leaves a
/// valid polyomino of size n, so growing every size-n representative by
/// every possible adjacent cell and de-duplicating by canonical form
/// reaches every size-(n+1) shape. Known counts: 1, 1, 2, 5, 12, 35 for
/// sizes 1..6 (OEIS A000105) -- asserted in `cube_nets_test.dart`.
List<Set<NetCell>> _freeHexominoes() {
  var generation = <String, Set<NetCell>>{
    _canonicalKey({const NetCell(0, 0)}): {const NetCell(0, 0)},
  };
  for (var size = 1; size < 6; size++) {
    final next = <String, Set<NetCell>>{};
    for (final shape in generation.values) {
      for (final cell in shape) {
        for (final neighbour in _gridNeighbours(cell)) {
          if (shape.contains(neighbour)) continue;
          final grown = {...shape, neighbour};
          final key = _canonicalKey(grown);
          next.putIfAbsent(key, () => _normalize(grown));
        }
      }
    }
    generation = next;
  }
  return generation.values.toList();
}

Iterable<NetCell> _gridNeighbours(NetCell cell) => [
  NetCell(cell.row - 1, cell.col),
  NetCell(cell.row + 1, cell.col),
  NetCell(cell.row, cell.col - 1),
  NetCell(cell.row, cell.col + 1),
];

Set<NetCell> _normalize(Set<NetCell> cells) {
  final minRow = cells.map((c) => c.row).reduce((a, b) => a < b ? a : b);
  final minCol = cells.map((c) => c.col).reduce((a, b) => a < b ? a : b);
  return cells.map((c) => NetCell(c.row - minRow, c.col - minCol)).toSet();
}

/// The 8 dihedral images of [cells] (4 rotations x optional mirror),
/// each translation-normalized.
List<Set<NetCell>> _dihedralImages(Set<NetCell> cells) {
  final images = <Set<NetCell>>[];
  var rotated = cells;
  for (var i = 0; i < 4; i++) {
    images.add(_normalize(rotated));
    rotated = rotated.map((c) => NetCell(c.col, -c.row)).toSet();
  }
  var mirrored = cells.map((c) => NetCell(c.row, -c.col)).toSet();
  for (var i = 0; i < 4; i++) {
    images.add(_normalize(mirrored));
    mirrored = mirrored.map((c) => NetCell(c.col, -c.row)).toSet();
  }
  return images;
}

String _serialize(Set<NetCell> cells) {
  final sorted = cells.toList()
    ..sort((a, b) {
      final rowCmp = a.row.compareTo(b.row);
      return rowCmp != 0 ? rowCmp : a.col.compareTo(b.col);
    });
  return sorted.map((c) => '${c.row},${c.col}').join(';');
}

/// The lexicographically smallest serialization among the 8 dihedral
/// images: identifies the free polyomino [cells] belongs to, independent
/// of how it is currently rotated/reflected/placed.
String _canonicalKey(Set<NetCell> cells) => _dihedralImages(
  cells,
).map(_serialize).reduce((a, b) => a.compareTo(b) <= 0 ? a : b);
