import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_alphabet.dart';

/// Every orientation of a [RuneGlyph] a candidate cube could be drawn at:
/// its four 90° rotations, and the four rotations of its mirror image
/// (`CubeFaceTilePainter`/`P1CubeGlyphPainter` only ever rotate then,
/// optionally, mirror -- see `p1_cube_rotation_puzzle.dart`).
List<List<GlyphPoint>> _allOrientations(RuneGlyph glyph) => [
  for (final base in [glyph.points, glyph.mirroredPoints()])
    for (final degrees in [0, 90, 180, 270])
      [for (final p in base) p.rotated(degrees)],
];

void main() {
  group('runicGlyphPool', () {
    test('has at least 6 glyphs, all rune ids', () {
      expect(runicGlyphPool.length, greaterThanOrEqualTo(6));
      for (final g in runicGlyphPool) {
        expect(isRuneGlyphId(g.id), isTrue);
      }
    });

    test('ids are unique', () {
      final ids = runicGlyphPool.map((g) => g.id).toSet();
      expect(ids.length, runicGlyphPool.length);
    });

    test('every glyph is distinct from its own 90/180/270 rotations '
        '(orientation matters)', () {
      for (final glyph in runicGlyphPool) {
        for (final degrees in [90, 180, 270]) {
          expect(
            glyph.rotatedPoints(degrees),
            isNot(equals(glyph.points)),
            reason: '${glyph.id} looks the same rotated $degrees°',
          );
        }
      }
    });

    test('every glyph is distinct from every rotation of its own mirror', () {
      for (final glyph in runicGlyphPool) {
        for (final degrees in [0, 90, 180, 270]) {
          final mirroredRotated = [
            for (final p in glyph.mirroredPoints()) p.rotated(degrees),
          ];
          expect(
            mirroredRotated,
            isNot(equals(glyph.points)),
            reason:
                '${glyph.id} mirrored+rotated $degrees° matches the '
                'original -- a mirrored trap would look correct',
          );
        }
      }
    });

    test('no two distinct glyphs share any of their 8 orientations '
        '(rotated or mirrored) -- a candidate can never be ambiguous '
        'between two runes', () {
      for (var i = 0; i < runicGlyphPool.length; i++) {
        final orientationsI = _allOrientations(runicGlyphPool[i]).toSet();
        for (var j = i + 1; j < runicGlyphPool.length; j++) {
          final orientationsJ = _allOrientations(runicGlyphPool[j]);
          for (final o in orientationsJ) {
            expect(
              orientationsI.contains(o),
              isFalse,
              reason:
                  '${runicGlyphPool[i].id} and ${runicGlyphPool[j].id} '
                  'share an orientation',
            );
          }
        }
      }
    });
  });

  group('glyphPoolFor', () {
    test('latin returns letters, runic returns rune ids', () {
      expect(glyphPoolFor(CubeNetAlphabet.latin), latinGlyphPool);
      expect(
        glyphPoolFor(CubeNetAlphabet.runic),
        runicGlyphPool.map((g) => g.id).toList(),
      );
    });
  });
}
