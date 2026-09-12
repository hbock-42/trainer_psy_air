/// The six faces of a physical cube (`spatial_cubes`, US-025).
///
/// These are spatial identities, not net positions: a folded net always maps
/// its 6 cells onto exactly these 6 values, one each (see `cube_folding.dart`
/// -- `foldNet`). Opposite pairs are fixed: [opposite].
enum CubeFace { top, bottom, front, back, left, right }

/// The face opposite [face] on any cube.
CubeFace oppositeFace(CubeFace face) => switch (face) {
  CubeFace.top => CubeFace.bottom,
  CubeFace.bottom => CubeFace.top,
  CubeFace.front => CubeFace.back,
  CubeFace.back => CubeFace.front,
  CubeFace.left => CubeFace.right,
  CubeFace.right => CubeFace.left,
};

/// An oriented glyph drawn on one face: a letter or a small asymmetric
/// shape (spec §2.4-L: "letters or shapes; orientation matters"), so
/// mis-rotating (or mirroring) it is visibly wrong, not just a bookkeeping
/// error.
///
/// [rotation] is the glyph's *intrinsic* orientation (0/90/180/270),
/// measured when the face is folded with spin 0 (see `cube_folding.dart`):
/// it is a property of the cube, not of any particular net drawing. A
/// drawing of this face at fold-spin `s` shows the glyph rotated by
/// `(rotation + s) % 360` (`CubeNetCellFace.rotation` in
/// `cube_net_puzzle.dart`).
class FaceGlyph {
  const FaceGlyph({required this.value, required this.rotation});

  /// A single letter (`"F"`) or a shape id (`"arrow"`, `"hook"`, ...).
  final String value;

  /// 0, 90, 180 or 270.
  final int rotation;

  @override
  String toString() => 'FaceGlyph($value, $rotation°)';
}

/// A full assignment of a [FaceGlyph] to every [CubeFace]: one concrete
/// cube. Built by [buildLabelling] from a net's fully-filled cells.
typedef CubeLabelling = Map<CubeFace, FaceGlyph>;
