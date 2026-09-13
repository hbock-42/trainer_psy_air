import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_alphabet.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_orientation.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_rotation_puzzle.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_face.dart';

/// Rebuilds the reference's full 6-face labelling from a fresh
/// `Random(seed)` -- the very first thing `buildP1CubeRotationPuzzle` does
/// with its own `Random(seed)`, so this reproduces it independently of the
/// function under test.
Map<CubeFace, String> _referenceValues(int seed, CubeNetAlphabet alphabet) {
  final labelling = buildP1CubeLabelling(Random(seed), alphabet);
  return {for (final entry in labelling.entries) entry.key: entry.value.value};
}

void main() {
  group('buildP1CubeRotationPuzzle', () {
    test('is deterministic: same seed, same puzzle', () {
      final a = buildP1CubeRotationPuzzle(
        seed: 123,
        alphabet: CubeNetAlphabet.latin,
      );
      final b = buildP1CubeRotationPuzzle(
        seed: 123,
        alphabet: CubeNetAlphabet.latin,
      );
      expect(a.isSameCube, b.isSameCube);
      for (final face in [CubeFace.top, CubeFace.front, CubeFace.right]) {
        expect(
          a.referenceVisible[face]!.value,
          b.referenceVisible[face]!.value,
        );
        expect(
          a.candidateVisible[face]!.value,
          b.candidateVisible[face]!.value,
        );
        expect(
          a.candidateVisible[face]!.mirrored,
          b.candidateVisible[face]!.mirrored,
        );
      }
    });

    test('reference is always shown at the identity orientation', () {
      final puzzle = buildP1CubeRotationPuzzle(
        seed: 1,
        alphabet: CubeNetAlphabet.latin,
      );
      expect(puzzle.referenceVisible[CubeFace.top]!.face, CubeFace.top);
      expect(puzzle.referenceVisible[CubeFace.front]!.face, CubeFace.front);
      expect(puzzle.referenceVisible[CubeFace.right]!.face, CubeFace.right);
      expect(puzzle.referenceVisible.values.every((f) => !f.mirrored), isTrue);
    });

    test('a "same cube" candidate\'s visible triple is one of the 24 '
        'genuine rotations of the reference labelling', () {
      var sawSame = false;
      for (var seed = 0; seed < 200; seed++) {
        final puzzle = buildP1CubeRotationPuzzle(
          seed: seed,
          alphabet: CubeNetAlphabet.runic,
        );
        if (!puzzle.isSameCube) continue;
        sawSame = true;
        final refValues = _referenceValues(seed, CubeNetAlphabet.runic);
        final genuineTriples = cubeOrientations
            .map(
              (o) => {
                CubeFace.top: refValues[o.top],
                CubeFace.front: refValues[o.front],
                CubeFace.right: refValues[o.right],
              },
            )
            .toList();
        final candidateTriple = {
          for (final face in [CubeFace.top, CubeFace.front, CubeFace.right])
            face: puzzle.candidateVisible[face]!.value,
        };
        expect(
          genuineTriples.any((t) => _mapEquals(t, candidateTriple)),
          isTrue,
          reason: 'seed $seed: "same" candidate is not a real rotation',
        );
        expect(
          puzzle.candidateVisible.values.every((f) => !f.mirrored),
          isTrue,
        );
      }
      expect(sawSame, isTrue);
    });

    test('an "altered" candidate never has the same visible triple as a '
        'genuine rotation of the reference, and every wrong candidate is '
        'either mirrored or a face-value swap', () {
      var sawAltered = false;
      var sawMirrorTrap = false;
      var sawSwapTrap = false;
      for (var seed = 0; seed < 200; seed++) {
        final puzzle = buildP1CubeRotationPuzzle(
          seed: seed,
          alphabet: CubeNetAlphabet.latin,
        );
        if (puzzle.isSameCube) continue;
        sawAltered = true;
        final anyMirrored = puzzle.candidateVisible.values.any(
          (f) => f.mirrored,
        );
        if (anyMirrored) {
          sawMirrorTrap = true;
          continue;
        }
        sawSwapTrap = true;
        final refValues = _referenceValues(seed, CubeNetAlphabet.latin);
        final genuineTriples = cubeOrientations
            .map(
              (o) => {
                CubeFace.top: refValues[o.top],
                CubeFace.front: refValues[o.front],
                CubeFace.right: refValues[o.right],
              },
            )
            .toList();
        final candidateTriple = {
          for (final face in [CubeFace.top, CubeFace.front, CubeFace.right])
            face: puzzle.candidateVisible[face]!.value,
        };
        expect(
          genuineTriples.any((t) => _mapEquals(t, candidateTriple)),
          isFalse,
          reason:
              'seed $seed: swapped candidate accidentally matches a '
              'real rotation',
        );
      }
      expect(sawAltered, isTrue);
      expect(sawMirrorTrap, isTrue);
      expect(sawSwapTrap, isTrue);
    });

    test('both latin and runic alphabets are usable', () {
      for (final alphabet in CubeNetAlphabet.values) {
        final puzzle = buildP1CubeRotationPuzzle(seed: 5, alphabet: alphabet);
        expect(puzzle.referenceVisible.length, 3);
        expect(puzzle.candidateVisible.length, 3);
      }
    });
  });
}

bool _mapEquals(Map<CubeFace, String?> a, Map<CubeFace, String?> b) {
  if (a.length != b.length) return false;
  for (final key in a.keys) {
    if (!b.containsKey(key) || a[key] != b[key]) return false;
  }
  return true;
}
