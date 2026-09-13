import '../../spatial_cubes/domain/cube_face.dart';

/// One of the 24 ways a physical cube can be picked up and set back down:
/// which [CubeFace] now occupies each of the six viewer-relative slots
/// (top/bottom/front/back/left/right).
///
/// This is a *view* rotation (spec §2.3/§4.1 row 8, rotation-matching
/// sub-variant: "the same object rotated -- possibly on a diagonal/combined
/// axis"), a different operation from `spatial_cubes`'s `foldNet` (which
/// rolls a cube across a 2D net's adjacency graph); the two share only the
/// underlying physical fact that a cube has 24 orientations, not any code,
/// so this is a small independent implementation rather than a fork of
/// `cube_folding.dart`.
class CubeOrientation {
  const CubeOrientation({
    required this.top,
    required this.bottom,
    required this.front,
    required this.back,
    required this.left,
    required this.right,
  });

  static const CubeOrientation identity = CubeOrientation(
    top: CubeFace.top,
    bottom: CubeFace.bottom,
    front: CubeFace.front,
    back: CubeFace.back,
    left: CubeFace.left,
    right: CubeFace.right,
  );

  final CubeFace top;
  final CubeFace bottom;
  final CubeFace front;
  final CubeFace back;
  final CubeFace left;
  final CubeFace right;

  /// Tips the cube towards the viewer about the left/right axis: the face
  /// that was on top swings down to front.
  CubeOrientation tipForward() => CubeOrientation(
    top: back,
    front: top,
    bottom: front,
    back: bottom,
    left: left,
    right: right,
  );

  /// Spins the cube clockwise (viewed from directly above) about the
  /// top/bottom axis.
  CubeOrientation spinCw() => CubeOrientation(
    top: top,
    bottom: bottom,
    front: left,
    right: front,
    back: right,
    left: back,
  );

  /// The three faces an isometric drawing shows (top, front, right), as a
  /// map keyed by *screen slot* to the [CubeFace] identity now sitting
  /// there.
  Map<CubeFace, CubeFace> get visibleSlots => {
    CubeFace.top: top,
    CubeFace.front: front,
    CubeFace.right: right,
  };

  List<CubeFace> get _all => [top, bottom, front, back, left, right];

  @override
  bool operator ==(Object other) =>
      other is CubeOrientation &&
      top == other.top &&
      bottom == other.bottom &&
      front == other.front &&
      back == other.back &&
      left == other.left &&
      right == other.right;

  @override
  int get hashCode => Object.hashAll(_all);

  @override
  String toString() =>
      'CubeOrientation(top=$top front=$front right=$right '
      'back=$back left=$left bottom=$bottom)';
}

/// The 24 distinct orientations of a cube, generated once by breadth-first
/// exploration from [CubeOrientation.identity] using [CubeOrientation
/// .tipForward] and [CubeOrientation.spinCw] (two 90° rotations about
/// perpendicular axes are a classic generating set of the cube's full
/// rotation group -- `p1_cube_orientation_test.dart` asserts the orbit is
/// exactly 24 and internally consistent).
final List<CubeOrientation> cubeOrientations = _buildOrbit();

List<CubeOrientation> _buildOrbit() {
  final seen = <CubeOrientation, void>{};
  final queue = <CubeOrientation>[CubeOrientation.identity];
  seen[CubeOrientation.identity] = null;
  var i = 0;
  while (i < queue.length) {
    final state = queue[i++];
    for (final next in [state.tipForward(), state.spinCw()]) {
      if (!seen.containsKey(next)) {
        seen[next] = null;
        queue.add(next);
      }
    }
  }
  return List.unmodifiable(queue);
}
