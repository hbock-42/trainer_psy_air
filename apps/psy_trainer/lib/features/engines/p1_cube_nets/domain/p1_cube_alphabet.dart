import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../spatial_cubes/domain/cube_face.dart';

/// A point of a [RuneGlyph]'s outline, in a `[-1, 1]` square local frame
/// (pure data: no `dart:ui`, so this stays importable from `domain/`).
class GlyphPoint {
  const GlyphPoint(this.x, this.y);

  final double x;
  final double y;

  /// The point rotated by [degrees] (0/90/180/270) about the origin.
  GlyphPoint rotated(int degrees) {
    final steps = (degrees ~/ 90) % 4;
    var p = this;
    for (var i = 0; i < steps; i++) {
      p = GlyphPoint(p.y, -p.x);
    }
    return p;
  }

  /// The point mirrored across the vertical axis (`x -> -x`), the same
  /// transform `CubeFaceTilePainter`/`P1CubeGlyphPainter` apply on canvas
  /// for a "mirrored" trap tile.
  GlyphPoint mirrored() => GlyphPoint(-x, y);

  @override
  bool operator ==(Object other) =>
      other is GlyphPoint &&
      (other.x - x).abs() < 1e-9 &&
      (other.y - y).abs() < 1e-9;

  @override
  int get hashCode => Object.hash((x * 1e6).round(), (y * 1e6).round());

  @override
  String toString() => '(${x.toStringAsFixed(2)}, ${y.toStringAsFixed(2)})';
}

/// One invented "runic" glyph (spec §2.3/§4.1 row 8: "alphabet runique"):
/// a small asymmetric polygon, never memorisable as a letter, and -- unlike
/// a real letter -- guaranteed distinct from every one of its own 90°
/// rotations *and* from its mirror image (see
/// `p1_cube_alphabet_test.dart`), so a candidate cube that shows a mirrored
/// or misrotated rune is always visibly wrong, never a coincidental match.
class RuneGlyph {
  const RuneGlyph(this.id, this.points);

  final String id;
  final List<GlyphPoint> points;

  List<GlyphPoint> rotatedPoints(int degrees) => [
    for (final p in points) p.rotated(degrees),
  ];

  List<GlyphPoint> mirroredPoints() => [for (final p in points) p.mirrored()];
}

/// The eight invented runes drawn by `runic` sessions, each an asymmetric
/// closed polygon (no rotational or mirror symmetry) hand-drawn to look
/// like an invented script rather than a real letter or the `shapes` pool
/// PSY0's own `spatial_cubes` already uses.
const List<RuneGlyph> runicGlyphPool = [
  RuneGlyph('rune_zed', [
    GlyphPoint(-0.8, -0.8),
    GlyphPoint(0.8, -0.8),
    GlyphPoint(-0.2, -0.1),
    GlyphPoint(0.8, 0.2),
    GlyphPoint(0.8, 0.8),
    GlyphPoint(-0.8, 0.8),
    GlyphPoint(-0.1, 0.15),
  ]),
  RuneGlyph('rune_hook', [
    GlyphPoint(-0.7, -0.9),
    GlyphPoint(-0.1, -0.9),
    GlyphPoint(-0.1, 0.3),
    GlyphPoint(0.7, 0.3),
    GlyphPoint(0.7, 0.9),
    GlyphPoint(-0.7, 0.9),
    GlyphPoint(-0.7, 0.3),
  ]),
  RuneGlyph('rune_branch', [
    GlyphPoint(-0.15, -0.9),
    GlyphPoint(0.15, -0.9),
    GlyphPoint(0.15, 0.1),
    GlyphPoint(0.75, -0.4),
    GlyphPoint(0.9, -0.15),
    GlyphPoint(0.2, 0.4),
    GlyphPoint(0.2, 0.9),
    GlyphPoint(-0.15, 0.9),
    GlyphPoint(-0.15, 0.4),
    GlyphPoint(-0.6, 0.7),
    GlyphPoint(-0.8, 0.45),
  ]),
  RuneGlyph('rune_wedge', [
    GlyphPoint(-0.85, 0.85),
    GlyphPoint(-0.85, -0.35),
    GlyphPoint(-0.1, -0.85),
    GlyphPoint(0.55, -0.5),
    GlyphPoint(0.85, 0.6),
    GlyphPoint(0.1, 0.85),
  ]),
  RuneGlyph('rune_spiral', [
    GlyphPoint(0.0, -0.9),
    GlyphPoint(0.6, -0.6),
    GlyphPoint(0.75, 0.1),
    GlyphPoint(0.2, 0.55),
    GlyphPoint(-0.25, 0.3),
    GlyphPoint(-0.15, -0.05),
    GlyphPoint(0.15, 0.0),
    GlyphPoint(0.2, 0.2),
    GlyphPoint(-0.35, 0.5),
    GlyphPoint(-0.8, -0.2),
  ]),
  RuneGlyph('rune_fork', [
    GlyphPoint(-0.75, -0.85),
    GlyphPoint(-0.45, -0.85),
    GlyphPoint(-0.1, -0.15),
    GlyphPoint(0.25, -0.85),
    GlyphPoint(0.6, -0.85),
    GlyphPoint(0.1, 0.1),
    GlyphPoint(0.1, 0.85),
    GlyphPoint(-0.2, 0.85),
    GlyphPoint(-0.2, 0.15),
  ]),
  RuneGlyph('rune_flag', [
    GlyphPoint(-0.55, -0.9),
    GlyphPoint(-0.2, -0.9),
    GlyphPoint(-0.2, -0.15),
    GlyphPoint(0.6, -0.05),
    GlyphPoint(0.6, 0.35),
    GlyphPoint(-0.2, 0.25),
    GlyphPoint(-0.2, 0.9),
    GlyphPoint(-0.55, 0.9),
  ]),
  RuneGlyph('rune_anchor', [
    GlyphPoint(-0.1, -0.85),
    GlyphPoint(0.2, -0.85),
    GlyphPoint(0.2, 0.35),
    GlyphPoint(0.8, 0.55),
    GlyphPoint(0.65, 0.9),
    GlyphPoint(-0.05, 0.6),
    GlyphPoint(-0.05, 0.0),
    GlyphPoint(-0.4, 0.0),
    GlyphPoint(-0.4, -0.3),
    GlyphPoint(-0.1, -0.3),
  ]),
];

RuneGlyph runeGlyphById(String id) =>
    runicGlyphPool.firstWhere((g) => g.id == id);

bool isRuneGlyphId(String id) => id.startsWith('rune_');

/// Letter pool for [CubeNetAlphabet.latin]: same "no near-symmetric glyph"
/// criterion as PSY0's own `spatial_cubes` pool (`F,G,J,L,P,R,B,Q` -- no
/// `O`/`I`/`X`/`S`), kept as our own small data list rather than importing
/// `spatial_cubes`'s private pool.
const List<String> latinGlyphPool = ['F', 'G', 'J', 'L', 'P', 'R', 'B', 'Q'];

/// The glyph-id pool for [alphabet].
List<String> glyphPoolFor(CubeNetAlphabet alphabet) => switch (alphabet) {
  CubeNetAlphabet.latin => List<String>.of(latinGlyphPool),
  CubeNetAlphabet.runic => [for (final g in runicGlyphPool) g.id],
};

/// Assigns every [CubeFace] a distinct glyph (from [alphabet]'s pool) and a
/// random on-paper rotation, drawn from [rnd] -- the one labelling both the
/// net-folding puzzle (`p1_cube_net_puzzle.dart`) and the rotation-matching
/// puzzle (`p1_cube_rotation_puzzle.dart`) build a reference cube from.
/// Public (not `_`-private) so tests can reconstruct the same labelling
/// from a fresh `Random(seed)` independently of the puzzle builders.
CubeLabelling buildP1CubeLabelling(Random rnd, CubeNetAlphabet alphabet) {
  final pool = glyphPoolFor(alphabet)..shuffle(rnd);
  return {
    for (var i = 0; i < CubeFace.values.length; i++)
      CubeFace.values[i]: FaceGlyph(
        value: pool[i % pool.length],
        rotation: rnd.nextInt(4) * 90,
      ),
  };
}
