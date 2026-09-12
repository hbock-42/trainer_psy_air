import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'viewpoint_geometry.dart';

/// Half-extent of the ground grid objects are placed on: coordinates range
/// over `-gridRadius..gridRadius` on both axes (a 5x5 grid holds up to 6
/// objects with room to spare).
const int gridRadius = 2;

/// One solid of a [ViewpointScene]: its ground position `(gx, gy)` (east,
/// north offsets from the scene's centre), its shape and a palette index
/// unique within the scene (`ViewpointPalette` in the presentation layer
/// resolves it to an actual colour, kept out of this pure-Dart file).
class ViewpointObject {
  const ViewpointObject({
    required this.gx,
    required this.gy,
    required this.kind,
    required this.colorIndex,
  });

  final int gx;
  final int gy;
  final SolidKind kind;
  final int colorIndex;
}

/// A generated `spatial_viewpoint` puzzle: the scene and the one azimuth
/// (1..8, see `viewpoint_geometry.dart`) it was "photographed" from.
///
/// Nothing here is stored on the `GeneratedItem` the engine returns: the
/// renderer and the scorer both call [buildViewpointScene] again with the
/// same `(seed, params, difficulty)` and get back the same scene
/// (ARCHITECTURE.md "Engine", "keep the stimulus in engine-owned data
/// derived again from the seed").
class ViewpointScene {
  const ViewpointScene({required this.objects, required this.correctAzimuth});

  final List<ViewpointObject> objects;

  /// 1..8, the viewpoint the rendered scene is seen from -- the answer.
  final int correctAzimuth;
}

/// The projection signature of [scene] from [azimuth]: the objects' indices
/// ordered left-to-right, and separately near-to-far. Two azimuths that
/// yield the same pair of orderings are indistinguishable from the
/// rendering alone -- see [buildViewpointScene].
({List<int> leftToRight, List<int> nearToFar}) projectionSignature(
  ViewpointScene scene,
  int azimuth,
) {
  final indices = List<int>.generate(scene.objects.length, (i) => i);
  List<int> sortedBy(double Function(ViewpointObject o) key) {
    final sorted = [...indices];
    sorted.sort(
      (a, b) => key(scene.objects[a]).compareTo(key(scene.objects[b])),
    );
    return sorted;
  }

  return (
    leftToRight: sortedBy((o) => lateralOf(o.gx, o.gy, azimuth)),
    nearToFar: sortedBy((o) => depthOf(o.gx, o.gy, azimuth)),
  );
}

/// Builds the scene of the recipe `(seed, params, difficulty)`.
///
/// Deterministic: same inputs, same scene (same `Random(seed)` sequence).
/// `difficulty` (1..5) scales `params.objectCount` by up to +/-2 around its
/// midpoint (3) and is clamped to 3..6 (acceptance criteria: "difficulty:
/// object count, symmetric arrangements"). Objects are placed on distinct
/// cells of a `(2*gridRadius+1)^2` grid; `params.allowSymmetric` lets the
/// picker prefer mirrored placements (plausible mirrored-azimuth
/// distractors), but every candidate scene is checked for ambiguity: if any
/// two of the 8 azimuths produce the same [projectionSignature] (the
/// candidate could not tell them apart from the rendering alone), the scene
/// is rejected and a fresh one is drawn from the same seeded sequence.
ViewpointScene buildViewpointScene({
  required int seed,
  required ViewpointParams params,
  required int difficulty,
}) {
  final rng = Random(seed);
  final rawObjectCount = params.objectCount + (difficulty - 3);
  final objectCount = rawObjectCount < 3
      ? 3
      : (rawObjectCount > 6 ? 6 : rawObjectCount);
  final kinds = params.objectKinds.isEmpty
      ? const [SolidKind.cube, SolidKind.cylinder, SolidKind.cone]
      : params.objectKinds;

  final cells = <(int, int)>[
    for (var gx = -gridRadius; gx <= gridRadius; gx++)
      for (var gy = -gridRadius; gy <= gridRadius; gy++) (gx, gy),
  ];

  const maxAttempts = 500;
  for (var attempt = 0; attempt < maxAttempts; attempt++) {
    final positions = _pickPositions(
      rng,
      cells,
      objectCount,
      symmetric: params.allowSymmetric,
    );
    final objects = [
      for (var i = 0; i < positions.length; i++)
        ViewpointObject(
          gx: positions[i].$1,
          gy: positions[i].$2,
          kind: kinds[rng.nextInt(kinds.length)],
          colorIndex: i,
        ),
    ];
    final correctAzimuth = 1 + rng.nextInt(8);
    final scene = ViewpointScene(
      objects: objects,
      correctAzimuth: correctAzimuth,
    );
    if (_isUnambiguous(scene)) return scene;
  }
  throw StateError(
    'buildViewpointScene: no unambiguous scene found in $maxAttempts '
    'attempts (seed=$seed, params=$params, difficulty=$difficulty)',
  );
}

/// Picks [count] distinct grid cells out of [cells]. When [symmetric], the
/// first half of the picks are mirrored across the north-south axis
/// (`(gx, gy) -> (-gx, gy)`) whenever the mirrored cell is still free, which
/// biases the scene toward layouts a mirrored azimuth could plausibly be
/// confused with -- the very case [buildViewpointScene]'s ambiguity check
/// exists to still rule out when it actually collides.
List<(int, int)> _pickPositions(
  Random rng,
  List<(int, int)> cells,
  int count, {
  required bool symmetric,
}) {
  final available = [...cells]..shuffle(rng);
  final chosen = <(int, int)>[];
  final used = <(int, int)>{};

  for (final cell in available) {
    if (chosen.length >= count) break;
    if (used.contains(cell)) continue;
    if (symmetric && chosen.length.isEven && chosen.length + 1 < count) {
      final mirror = (-cell.$1, cell.$2);
      if (mirror != cell && !used.contains(mirror) && cells.contains(mirror)) {
        chosen.add(cell);
        chosen.add(mirror);
        used.add(cell);
        used.add(mirror);
        continue;
      }
    }
    chosen.add(cell);
    used.add(cell);
  }
  return chosen.take(count).toList();
}

bool _isUnambiguous(ViewpointScene scene) {
  final signatures = [
    for (var azimuth = 1; azimuth <= 8; azimuth++)
      projectionSignature(scene, azimuth),
  ];
  for (var i = 0; i < signatures.length; i++) {
    for (var j = i + 1; j < signatures.length; j++) {
      if (_sameSignature(signatures[i], signatures[j])) return false;
    }
  }
  return true;
}

bool _sameSignature(
  ({List<int> leftToRight, List<int> nearToFar}) a,
  ({List<int> leftToRight, List<int> nearToFar}) b,
) {
  return _sameOrder(a.leftToRight, b.leftToRight) &&
      _sameOrder(a.nearToFar, b.nearToFar);
}

bool _sameOrder(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
