import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_alphabet.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_net_puzzle.dart';

void main() {
  group('buildP1CubeNetPuzzle', () {
    test('is deterministic: same inputs, same puzzle', () {
      final a = buildP1CubeNetPuzzle(
        seed: 42,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 2,
      );
      final b = buildP1CubeNetPuzzle(
        seed: 42,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 2,
      );
      expect(a.referenceNet.id, b.referenceNet.id);
      expect(a.targetNet.id, b.targetNet.id);
      expect(a.targetRequired.keys.toSet(), b.targetRequired.keys.toSet());
      for (final entry in a.targetRequired.entries) {
        final other = b.targetRequired[entry.key]!;
        expect(entry.value.face, other.face);
        expect(entry.value.value, other.value);
        expect(entry.value.rotation, other.rotation);
      }
    });

    test('reference and target are different net shapes', () {
      final puzzle = buildP1CubeNetPuzzle(
        seed: 7,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 2,
      );
      expect(puzzle.referenceNet.id, isNot(puzzle.targetNet.id));
    });

    test('missingFaces controls how many target slots must be filled', () {
      for (final missing in [2, 3, 4, 5]) {
        final puzzle = buildP1CubeNetPuzzle(
          seed: 1,
          alphabet: CubeNetAlphabet.latin,
          missingFaces: missing,
        );
        expect(puzzle.missingCellIndices.length, missing);
      }
    });

    test('runic sessions draw glyphs from the rune pool only', () {
      final puzzle = buildP1CubeNetPuzzle(
        seed: 3,
        alphabet: CubeNetAlphabet.runic,
        missingFaces: 3,
      );
      final runeIds = runicGlyphPool.map((g) => g.id).toSet();
      for (final cell in puzzle.referenceCells.values) {
        expect(runeIds, contains(cell.value));
      }
    });

    test('latin sessions draw glyphs from the letter pool only', () {
      final puzzle = buildP1CubeNetPuzzle(
        seed: 3,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 3,
      );
      for (final cell in puzzle.referenceCells.values) {
        expect(latinGlyphPool, contains(cell.value));
      }
    });

    test('the tray offers exactly one correct, non-mirrored tile per slot', () {
      final puzzle = buildP1CubeNetPuzzle(
        seed: 55,
        alphabet: CubeNetAlphabet.runic,
        missingFaces: 3,
      );
      for (final required in puzzle.targetRequired.values) {
        final matches = puzzle.trayTiles.where(
          (t) => !t.mirrored && t.face == required.face,
        );
        expect(matches.length, 1);
      }
    });

    test('missingFaces is clamped to [2, 5]', () {
      final puzzle = buildP1CubeNetPuzzle(
        seed: 1,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 99,
      );
      expect(puzzle.missingCellIndices.length, 5);
      final puzzleLow = buildP1CubeNetPuzzle(
        seed: 1,
        alphabet: CubeNetAlphabet.latin,
        missingFaces: 0,
      );
      expect(puzzleLow.missingCellIndices.length, 2);
    });
  });
}
