import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../spatial_cubes/domain/cube_face.dart';
import '../../spatial_cubes/domain/cube_net_puzzle.dart' show CubeNetCellFace;
import 'p1_cube_alphabet.dart';
import 'p1_cube_orientation.dart';

/// One `p1_cube_nets` rotation-matching item (spec §2.3/§4.1 row 8b): a
/// reference cube (its full 6-face labelling, drawn isometrically from
/// [CubeOrientation.identity] -- top/front/right visible) and ONE
/// candidate cube shown at some other orientation, which the candidate
/// must judge either "the same object, rotated" ([isSameCube] true) or
/// "altered" (two faces swapped, or one visible glyph mirrored --
/// [isSameCube] false).
///
/// One item per candidate judgement (not one item bundling several
/// candidates): this is the closest fit to the spec's "judge each
/// candidate as same-object-rotated vs altered" wording within the
/// existing one-`GeneratedItem`-per-call engine shape, and keeps the
/// scorer a plain yes/no -- see `p1_cube_nets_engine.dart`'s doc comment
/// for the alternative considered (`MultiSelectAnswer` over a whole set)
/// and why it was not picked.
class CubeRotationPuzzle {
  const CubeRotationPuzzle({
    required this.referenceVisible,
    required this.candidateVisible,
    required this.isSameCube,
  });

  /// The reference cube's top/front/right faces, keyed by the screen slot
  /// they are drawn at.
  final Map<CubeFace, CubeNetCellFace> referenceVisible;

  /// The candidate's top/front/right faces, keyed the same way.
  final Map<CubeFace, CubeNetCellFace> candidateVisible;

  /// Ground truth: true if the candidate is genuinely the reference cube
  /// under some rotation; false if it was altered (swapped faces or a
  /// mirrored glyph).
  final bool isSameCube;
}

/// Builds the deterministic rotation-matching puzzle of `(seed, alphabet)`:
/// same inputs, same puzzle. Called again, unchanged, by the renderer and
/// the scorer.
CubeRotationPuzzle buildP1CubeRotationPuzzle({
  required int seed,
  required CubeNetAlphabet alphabet,
}) {
  final rnd = Random(seed);
  final labelling = buildP1CubeLabelling(rnd, alphabet);

  CubeNetCellFace tileFor(CubeFace face, {bool mirrored = false}) =>
      CubeNetCellFace(
        face: face,
        value: labelling[face]!.value,
        rotation: labelling[face]!.rotation,
        mirrored: mirrored,
      );

  final referenceVisible = {
    for (final entry in CubeOrientation.identity.visibleSlots.entries)
      entry.key: tileFor(entry.value),
  };

  final isSame = rnd.nextBool();
  if (isSame) {
    final orientation = cubeOrientations[rnd.nextInt(cubeOrientations.length)];
    final candidateVisible = {
      for (final entry in orientation.visibleSlots.entries)
        entry.key: tileFor(entry.value),
    };
    return CubeRotationPuzzle(
      referenceVisible: referenceVisible,
      candidateVisible: candidateVisible,
      isSameCube: true,
    );
  }

  // Altered: either mirror one visible glyph, or swap the labelling of two
  // distinct faces before reading off the visible triple (a mismatch no
  // rotation of the *original* cube could ever reproduce, since the
  // candidate's six faces then no longer carry the reference's six glyphs
  // one-for-one).
  final orientation = cubeOrientations[rnd.nextInt(cubeOrientations.length)];
  final mirrorTrap = rnd.nextBool();
  Map<CubeFace, CubeNetCellFace> candidateVisible;
  if (mirrorTrap) {
    final slots = orientation.visibleSlots.entries.toList();
    final mirroredSlot = slots[rnd.nextInt(slots.length)].key;
    candidateVisible = {
      for (final entry in orientation.visibleSlots.entries)
        entry.key: tileFor(entry.value, mirrored: entry.key == mirroredSlot),
    };
  } else {
    // Swap the value of a *visible* face with another face's -- so the
    // alteration is always visible in the drawn triple, never a silent
    // no-op on faces the candidate never shows.
    final visibleFaces = orientation.visibleSlots.values.toList()..shuffle(rnd);
    final faceA = visibleFaces.first;
    final otherFaces = CubeFace.values.where((f) => f != faceA).toList()
      ..shuffle(rnd);
    final faceB = otherFaces.first;
    final swapped = Map<CubeFace, FaceGlyph>.of(labelling);
    swapped[faceA] = labelling[faceB]!;
    swapped[faceB] = labelling[faceA]!;
    candidateVisible = {
      for (final entry in orientation.visibleSlots.entries)
        entry.key: CubeNetCellFace(
          face: entry.value,
          value: swapped[entry.value]!.value,
          rotation: swapped[entry.value]!.rotation,
        ),
    };
  }
  return CubeRotationPuzzle(
    referenceVisible: referenceVisible,
    candidateVisible: candidateVisible,
    isSameCube: false,
  );
}
