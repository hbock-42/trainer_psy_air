import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../spatial_cubes/domain/cube_folding.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart'
    show CubeNetCellFace, CubeFaceTile, CubeNetPuzzle;
import '../../spatial_cubes/domain/cube_nets.dart';
import 'p1_cube_alphabet.dart';

/// Builds one `p1_cube_nets` net-folding puzzle (spec §2.3/§4.1 row 8a):
/// the same reference/target/tray shape as PSY0's `spatial_cubes`, reusing
/// its geometry core (`foldNet`, `CubeNet`, `cubeNets`) and its generic
/// tile/puzzle value types (`CubeNetCellFace`, `CubeFaceTile`,
/// `CubeNetPuzzle`), extended only with a [CubeNetAlphabet] instead of
/// PSY0's `CubeSymbolKind` -- `latin` reuses PSY0's letter pool, `runic`
/// draws from [runicGlyphPool]'s invented, non-memorisable glyphs.
///
/// [missingFaces] and the distractor count both come from
/// [P1CubeNetsParams] directly (unlike PSY0's `buildCubeNetPuzzle`, which
/// clamps `difficulty` instead and never reads its own `missingFaces`
/// field -- see the PR description for that deviation).
CubeNetPuzzle buildP1CubeNetPuzzle({
  required int seed,
  required CubeNetAlphabet alphabet,
  required int missingFaces,
}) {
  final rnd = Random(seed);
  final sourceIndex = rnd.nextInt(cubeNets.length);
  var targetIndex = rnd.nextInt(cubeNets.length);
  while (targetIndex == sourceIndex) {
    targetIndex = rnd.nextInt(cubeNets.length);
  }
  final referenceNet = cubeNets[sourceIndex];
  final targetNet = cubeNets[targetIndex];

  final labelling = buildP1CubeLabelling(rnd, alphabet);
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

  final missingCount = missingFaces.clamp(2, 5);
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
    distractorCount: missingCount.clamp(0, 4),
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

List<CubeFaceTile> _buildTray({
  required Random rnd,
  required int distractorCount,
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
