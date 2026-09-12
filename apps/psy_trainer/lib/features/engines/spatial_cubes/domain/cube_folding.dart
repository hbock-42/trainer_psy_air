import 'cube_face.dart';
import 'cube_net.dart';

/// The result of folding one net cell: which physical face it becomes and
/// at what in-plane rotation (0/90/180/270) its glyph appears once folded,
/// relative to that face's intrinsic orientation (spin 0).
class FoldedFace {
  const FoldedFace(this.face, this.rotation);

  final CubeFace face;

  /// 0, 90, 180 or 270.
  final int rotation;

  @override
  String toString() => 'FoldedFace($face, $rotation°)';
}

/// A cube resting on the net, tracked by which [CubeFace] currently
/// occupies each of the six spatial slots (down = touching the net cell
/// under it; up = opposite; north/south/east/west = the four side slots).
///
/// This is the classic "rolling die across a grid" trick: moving to an
/// adjacent net cell in a 2D direction is simulated by tipping the cube
/// over the shared edge (a 90° roll). After a roll, [down] is the face
/// that lands on the new cell -- i.e. the face the net folds to there.
/// [north]/[south]/[east]/[west] additionally pin down the *rotation* of
/// that face once compared with the fixed canonical state for the same
/// [down] face (see [_canonicalStates] and [_RollState.spinRelativeTo]).
class _RollState {
  const _RollState({
    required this.down,
    required this.up,
    required this.north,
    required this.south,
    required this.east,
    required this.west,
  });

  /// The arbitrary but fixed starting orientation: face [CubeFace.top] is
  /// "down" (touching the very first net cell visited), with the other
  /// five in a fixed reading. Everything else (every other net cell's
  /// face + rotation) is derived from here by rolling, so this is the only
  /// hand-picked constant in the whole module.
  static const _RollState initial = _RollState(
    down: CubeFace.top,
    up: CubeFace.bottom,
    north: CubeFace.front,
    south: CubeFace.back,
    east: CubeFace.right,
    west: CubeFace.left,
  );

  final CubeFace down;
  final CubeFace up;
  final CubeFace north;
  final CubeFace south;
  final CubeFace east;
  final CubeFace west;

  _RollState rollNorth() => _RollState(
    down: north,
    up: south,
    north: up,
    south: down,
    east: east,
    west: west,
  );

  _RollState rollSouth() => _RollState(
    down: south,
    up: north,
    north: down,
    south: up,
    east: east,
    west: west,
  );

  _RollState rollEast() => _RollState(
    down: east,
    up: west,
    east: up,
    west: down,
    north: north,
    south: south,
  );

  _RollState rollWest() => _RollState(
    down: west,
    up: east,
    west: up,
    east: down,
    north: north,
    south: south,
  );

  /// Rotates the four side slots by [steps] quarter-turns about the
  /// down/up axis (clockwise viewed from "up"), [down]/[up] unchanged.
  /// Used both to build [_canonicalStates] (spin 0/90/180/270 of the same
  /// down face) and, in reverse (by trying all 4), to read the spin of a
  /// folded state back off.
  _RollState spinCw(int steps) {
    var s = this;
    for (var i = 0; i < steps % 4; i++) {
      s = _RollState(
        down: s.down,
        up: s.up,
        north: s.west,
        east: s.north,
        south: s.east,
        west: s.south,
      );
    }
    return s;
  }

  /// The rotation (0/90/180/270) that turns [_canonicalStates]`[down]`
  /// into this exact state; both states necessarily share the same [down]
  /// (and [up]), and differ only by a multiple of 90° about that axis
  /// (there are exactly 4 orientations of a cube with a given face down).
  int spinRelativeToCanonical() {
    final canonical = _canonicalStates[down]!;
    for (var k = 0; k < 4; k++) {
      final rotated = canonical.spinCw(k);
      if (rotated.north == north &&
          rotated.east == east &&
          rotated.south == south &&
          rotated.west == west) {
        return k * 90;
      }
    }
    // Unreachable: the 4 candidates exhaust every state sharing `down`.
    throw StateError('inconsistent roll state: $this');
  }

  @override
  String toString() =>
      'down=$down up=$up north=$north south=$south east=$east west=$west';
}

/// One fixed, spin-0 reference state per [CubeFace] (as the down face),
/// computed once from [_RollState.initial] by rolling -- not hand-picked --
/// so every canonical state is consistent with the very same roll rules
/// `foldNet` uses.
final Map<CubeFace, _RollState> _canonicalStates = _buildCanonicalStates();

Map<CubeFace, _RollState> _buildCanonicalStates() {
  const top = _RollState.initial;
  final front = top.rollNorth();
  final bottom = front.rollNorth();
  final right = top.rollEast();
  final left = top.rollWest();
  final back = top.rollSouth();
  return {
    CubeFace.top: top,
    CubeFace.front: front,
    CubeFace.bottom: bottom,
    CubeFace.right: right,
    CubeFace.left: left,
    CubeFace.back: back,
  };
}

/// Folds [net]: assigns every cell the [CubeFace] it becomes and the
/// rotation (relative to that face's intrinsic spin-0 orientation) its
/// glyph is shown at once folded, by rolling a cube across the net's
/// adjacency graph from [rootCellIndex] (default: the net's first cell).
///
/// [rootFace] is the face the root cell folds to (default [CubeFace.top])
/// and [rootSpin] its rotation (default 0). Calling `foldNet` twice with
/// the same `(net, rootFace, rootSpin)` always yields the same map
/// (determinism); calling it with a *different* net but the same root
/// gives the "inverse" mapping the generator needs: which face/rotation a
/// second net's cells must show to fold into the very same cube.
///
/// Every one of the 11 valid nets (`cube_net.dart`) maps its 6 cells onto
/// 6 *distinct* [CubeFace] values -- that is the definition of validity
/// used to build the list, and every generator net was filtered on it.
Map<int, FoldedFace> foldNet(
  CubeNet net, {
  int rootCellIndex = 0,
  CubeFace rootFace = CubeFace.top,
  int rootSpin = 0,
}) {
  final rootState = _canonicalStates[rootFace]!.spinCw(rootSpin ~/ 90);
  final states = <int, _RollState>{rootCellIndex: rootState};
  final queue = <int>[rootCellIndex];
  while (queue.isNotEmpty) {
    final parentIndex = queue.removeAt(0);
    final parent = net.cells[parentIndex];
    final parentState = states[parentIndex]!;
    for (final neighbourIndex in net.neighboursOf(parentIndex)) {
      if (states.containsKey(neighbourIndex)) continue;
      final neighbour = net.cells[neighbourIndex];
      final dRow = neighbour.row - parent.row;
      final dCol = neighbour.col - parent.col;
      final childState = switch ((dRow, dCol)) {
        (-1, 0) => parentState.rollNorth(),
        (1, 0) => parentState.rollSouth(),
        (0, 1) => parentState.rollEast(),
        (0, -1) => parentState.rollWest(),
        _ => throw StateError('non-adjacent neighbour: $parent -> $neighbour'),
      };
      states[neighbourIndex] = childState;
      queue.add(neighbourIndex);
    }
  }
  return {
    for (final entry in states.entries)
      entry.key: FoldedFace(
        entry.value.down,
        entry.value.spinRelativeToCanonical(),
      ),
  };
}

/// Builds the [CubeLabelling] a fully-labelled [net] folds into: [glyphs]
/// gives the glyph *as drawn on the paper net* for each cell index (its
/// value and its on-paper rotation), and this converts each into the
/// face's intrinsic (spin-0) glyph so it can be redrawn, unchanged, on any
/// other net via [foldNet] + [glyphOnNet].
CubeLabelling buildLabelling(CubeNet net, Map<int, FaceGlyph> glyphs) {
  final folded = foldNet(net);
  final labelling = <CubeFace, FaceGlyph>{};
  for (final entry in folded.entries) {
    final onPaper = glyphs[entry.key];
    if (onPaper == null) continue;
    final intrinsicRotation = (onPaper.rotation - entry.value.rotation) % 360;
    labelling[entry.value.face] = FaceGlyph(
      value: onPaper.value,
      rotation: intrinsicRotation,
    );
  }
  return labelling;
}

/// The glyph a [labelling] shows at [cellIndex] of [net] once folded (or
/// re-folded, for a second net of the same cube), with [rootFace]/
/// [rootSpin] identifying which physical face/rotation the net's root
/// cell (`rootCellIndex`) represents -- the two nets of one puzzle share
/// the same [rootFace]/[rootSpin] so they describe the very same cube.
FaceGlyph? glyphOnNet(
  CubeNet net,
  CubeLabelling labelling,
  int cellIndex, {
  int rootCellIndex = 0,
  CubeFace rootFace = CubeFace.top,
  int rootSpin = 0,
}) {
  final folded = foldNet(
    net,
    rootCellIndex: rootCellIndex,
    rootFace: rootFace,
    rootSpin: rootSpin,
  )[cellIndex];
  if (folded == null) return null;
  final intrinsic = labelling[folded.face];
  if (intrinsic == null) return null;
  return FaceGlyph(
    value: intrinsic.value,
    rotation: (intrinsic.rotation + folded.rotation) % 360,
  );
}
