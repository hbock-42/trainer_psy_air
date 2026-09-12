import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'cube_face.dart';
import 'cube_folding.dart';
import 'cube_net.dart';
import 'cube_nets.dart';

/// Letter pool for [CubeSymbolKind.letters]: visibly different under every
/// 90° rotation (no `O`/`I`/`X`/`S`-like near-symmetric glyphs), so a
/// mis-rotated face is always obviously wrong.
const List<String> _letterPool = ['F', 'G', 'J', 'L', 'P', 'R', 'B', 'Q'];

/// Shape-id pool for [CubeSymbolKind.shapes]; drawn by
/// `cube_net_painter.dart`, each asymmetric under rotation (an arrow, a
/// flag, a hook...).
const List<String> _shapePool = [
  'arrow',
  'flag',
  'hook',
  'wedge',
  'chevron',
  'pin',
  'bolt',
  'comb',
];

/// One face's glyph as it must appear drawn in a specific net cell: which
/// [face] the cell folds to, the glyph [value] and the [rotation]
/// (0/90/180/270) it must be drawn at, and whether it is a [mirrored]
/// trap (never correct, regardless of rotation -- a mirror image of an
/// asymmetric glyph is not reachable by any planar rotation).
class CubeNetCellFace {
  const CubeNetCellFace({
    required this.face,
    required this.value,
    required this.rotation,
    this.mirrored = false,
  });

  final CubeFace face;
  final String value;
  final int rotation;
  final bool mirrored;

  /// True iff placing `this` (the candidate's tile, in its current
  /// orientation) at the slot [other] describes would be correct: same
  /// face, not mirrored, same rotation -- computed from the geometry (the
  /// folded [face] identity), not by comparing drawn glyph strings.
  bool matches(CubeNetCellFace other) =>
      !mirrored && face == other.face && rotation == other.rotation;

  @override
  String toString() =>
      'CubeNetCellFace($face, $value, $rotation°${mirrored ? ', mirrored' : ''})';
}

/// A face tile offered in the tray: the candidate drags it onto a target
/// slot and taps it to rotate 90° at a time (spec §2.4-L: "flippable by
/// tapping"). [initialRotation] is only the rotation it is first drawn at;
/// the renderer tracks the live rotation as the candidate taps.
class CubeFaceTile {
  const CubeFaceTile({
    required this.face,
    required this.value,
    required this.initialRotation,
    this.mirrored = false,
  });

  final CubeFace face;
  final String value;
  final int initialRotation;
  final bool mirrored;

  @override
  String toString() =>
      'CubeFaceTile($face, $value, $initialRotation°${mirrored ? ', mirrored' : ''})';
}

/// One `cube_net` item (spec §2.4-L, US-025), rebuilt by the renderer and
/// the scorer from `(seed, params, difficulty)` -- see
/// [buildCubeNetPuzzle].
class CubeNetPuzzle {
  const CubeNetPuzzle({
    required this.referenceNet,
    required this.targetNet,
    required this.referenceCells,
    required this.targetGiven,
    required this.targetRequired,
    required this.trayTiles,
  });

  /// Fully-filled net drawn on the left: every cell has its
  /// [CubeNetCellFace].
  final CubeNet referenceNet;

  /// The net to complete, drawn on the right; a different shape from
  /// [referenceNet] (same cube).
  final CubeNet targetNet;

  final Map<int, CubeNetCellFace> referenceCells;

  /// [targetNet] cells already filled in (shown as a hint, not editable).
  final Map<int, CubeNetCellFace> targetGiven;

  /// [targetNet] cells the candidate must fill; the correct answer.
  final Map<int, CubeNetCellFace> targetRequired;

  /// Tiles offered to fill [targetRequired]'s slots: exactly one correct,
  /// non-mirrored tile per required slot, plus distractors (a mirrored
  /// twin of a required face, or an unrelated face already shown
  /// elsewhere on the target net) -- never more than one tile can
  /// correctly fill any given slot.
  final List<CubeFaceTile> trayTiles;

  /// Indices of [targetNet].cells that must be filled, in a stable order.
  List<int> get missingCellIndices => targetRequired.keys.toList()..sort();
}

/// Builds the deterministic puzzle of `(seed, params, difficulty)`: same
/// inputs, same puzzle (`ActivityEngine.generate`'s contract). Called
/// again, unchanged, by the renderer and the scorer -- the item itself
/// stores only the recipe (`CubeNetEngine.generate`).
CubeNetPuzzle buildCubeNetPuzzle({
  required int seed,
  required CubeNetParams params,
  required int difficulty,
}) {
  final rnd = Random(seed);
  final sourceIndex = rnd.nextInt(cubeNets.length);
  var targetIndex = rnd.nextInt(cubeNets.length);
  while (targetIndex == sourceIndex) {
    targetIndex = rnd.nextInt(cubeNets.length);
  }
  final referenceNet = cubeNets[sourceIndex];
  final targetNet = cubeNets[targetIndex];

  final labelling = _buildLabelling(rnd, params.symbolKind);
  final referenceFolded = foldNet(referenceNet);
  final targetFolded = foldNet(targetNet);

  CubeNetCellFace cellFaceOf(FoldedFace folded) {
    final glyph = labelling[folded.face]!;
    return CubeNetCellFace(
      face: folded.face,
      value: glyph.value,
      rotation: (glyph.rotation + folded.rotation) % 360,
    );
  }

  final referenceCells = {
    for (final entry in referenceFolded.entries)
      entry.key: cellFaceOf(entry.value),
  };
  final targetAll = {
    for (final entry in targetFolded.entries)
      entry.key: cellFaceOf(entry.value),
  };

  final missingCount = difficulty.clamp(2, 5);
  final shuffledCells = List<int>.generate(6, (i) => i)..shuffle(rnd);
  final missing = shuffledCells.take(missingCount).toSet();

  final targetGiven = <int, CubeNetCellFace>{};
  final targetRequired = <int, CubeNetCellFace>{};
  for (final entry in targetAll.entries) {
    if (missing.contains(entry.key)) {
      targetRequired[entry.key] = entry.value;
    } else {
      targetGiven[entry.key] = entry.value;
    }
  }

  final trayTiles = _buildTray(
    rnd: rnd,
    params: params,
    targetRequired: targetRequired,
    targetGiven: targetGiven,
  );

  return CubeNetPuzzle(
    referenceNet: referenceNet,
    targetNet: targetNet,
    referenceCells: referenceCells,
    targetGiven: targetGiven,
    targetRequired: targetRequired,
    trayTiles: trayTiles,
  );
}

CubeLabelling _buildLabelling(Random rnd, CubeSymbolKind symbolKind) {
  final pool = switch (symbolKind) {
    CubeSymbolKind.letters => List<String>.of(_letterPool),
    CubeSymbolKind.shapes => List<String>.of(_shapePool),
    CubeSymbolKind.mixed => [
      for (var i = 0; i < CubeFace.values.length; i++)
        i.isEven ? _letterPool[i] : _shapePool[i],
    ],
  }..shuffle(rnd);
  return {
    for (var i = 0; i < CubeFace.values.length; i++)
      CubeFace.values[i]: FaceGlyph(
        value: pool[i % pool.length],
        rotation: rnd.nextInt(4) * 90,
      ),
  };
}

List<CubeFaceTile> _buildTray({
  required Random rnd,
  required CubeNetParams params,
  required Map<int, CubeNetCellFace> targetRequired,
  required Map<int, CubeNetCellFace> targetGiven,
}) {
  final tiles = [
    for (final required
        in targetRequired.values.toList()
          ..sort((a, b) => a.face.index.compareTo(b.face.index)))
      CubeFaceTile(
        face: required.face,
        value: required.value,
        initialRotation: rnd.nextInt(4) * 90,
      ),
  ];

  final requiredList = targetRequired.values.toList();
  final givenList = targetGiven.values.toList();
  final distractorCount = params.distractorFaces.clamp(0, 4);
  for (var i = 0; i < distractorCount; i++) {
    final mirroredTrap = requiredList.isNotEmpty && rnd.nextBool();
    if (mirroredTrap) {
      final source = requiredList[rnd.nextInt(requiredList.length)];
      tiles.add(
        CubeFaceTile(
          face: source.face,
          value: source.value,
          initialRotation: rnd.nextInt(4) * 90,
          mirrored: true,
        ),
      );
    } else if (givenList.isNotEmpty) {
      final source = givenList[rnd.nextInt(givenList.length)];
      tiles.add(
        CubeFaceTile(
          face: source.face,
          value: source.value,
          initialRotation: rnd.nextInt(4) * 90,
        ),
      );
    } else if (requiredList.isNotEmpty) {
      // No given face left (all 6 missing): fall back to a mirrored
      // duplicate of a required face rather than skip the distractor.
      final source = requiredList[rnd.nextInt(requiredList.length)];
      tiles.add(
        CubeFaceTile(
          face: source.face,
          value: source.value,
          initialRotation: rnd.nextInt(4) * 90,
          mirrored: true,
        ),
      );
    }
  }
  tiles.shuffle(rnd);
  return tiles;
}
