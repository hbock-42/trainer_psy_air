import 'tangram_geometry.dart';

/// Which of the 7 classic tangram pieces (spec §2.3-2 / §4.1 row 2). The 2
/// small and 2 large triangles are geometrically identical pairs -- kept as
/// distinct enum values (rather than one value with a multiplicity) so a
/// board's piece list can carry one [TangramPiece] per physical piece, the
/// same way a real tangram set has 7 separate cut-out pieces.
enum TangramPieceKind {
  smallTriangle1,
  smallTriangle2,
  mediumTriangle,
  largeTriangle1,
  largeTriangle2,
  square,
  parallelogram,
}

/// One of the 7 physical tangram pieces: a fixed polygon (in its own base
/// orientation, at [TangramPieces.unit] scale) that a [PlacedPiece]
/// translates, rotates in 45° steps and (parallelogram only) flips onto
/// the board.
///
/// Vertex coordinates are the classic "half-square-triangle" construction:
/// every piece is built from whole copies of the smallest right-isosceles
/// triangle (legs 1, area 0.5, itself exactly half of a unit square cut
/// along its diagonal) -- 2 units make the square and the parallelogram, 2
/// make the medium triangle, 4 make each large triangle, 1 alone is the
/// small triangle -- 16 half-square-triangle units in total (2*1 + 1*2 +
/// 2*4 + 1*2 + 1*2 = 16), the textbook fact about a tangram set. Every
/// vertex below is therefore an integer point of the plain unit grid *in
/// the piece's own base orientation* -- rotating a piece by 45° moves it
/// off that grid (no 2D lattice is invariant under a 45° rotation), which
/// is exactly why placement/exact-cover checks below work on a
/// [rasterisePolygon] grid rather than on exact vertex coordinates.
class TangramPiece {
  TangramPiece({
    required this.kind,
    required this.vertices,
    this.canFlip = false,
  });

  final TangramPieceKind kind;

  /// CCW, base orientation (`rotationSteps: 0`, `flipped: false`).
  final List<Point2> vertices;

  /// Whether flipping this piece (mirroring it) produces an orientation no
  /// rotation alone reaches. True only for [TangramPieceKind.parallelogram]
  /// -- every triangle and the square have a reflection symmetry, so
  /// flipping them is always equal to one of their 8 rotations and the
  /// renderer's flip gesture is a no-op distraction for those; the
  /// parallelogram is the one chiral piece, exactly as on a real tangram
  /// set.
  final bool canFlip;

  late final double area = polygonArea(vertices);
}

/// The 7-piece catalogue, at `unit = 1` (the small triangle's leg).
abstract final class TangramPieces {
  const TangramPieces._();

  static final TangramPiece smallTriangle1 = TangramPiece(
    kind: TangramPieceKind.smallTriangle1,
    vertices: const [(0, 0), (1, 0), (0, 1)],
  );

  static final TangramPiece smallTriangle2 = TangramPiece(
    kind: TangramPieceKind.smallTriangle2,
    vertices: const [(0, 0), (1, 0), (0, 1)],
  );

  static final TangramPiece mediumTriangle = TangramPiece(
    kind: TangramPieceKind.mediumTriangle,
    vertices: const [(0, 0), (2, 0), (1, 1)],
  );

  static final TangramPiece largeTriangle1 = TangramPiece(
    kind: TangramPieceKind.largeTriangle1,
    vertices: const [(0, 0), (2, 0), (0, 2)],
  );

  static final TangramPiece largeTriangle2 = TangramPiece(
    kind: TangramPieceKind.largeTriangle2,
    vertices: const [(0, 0), (2, 0), (0, 2)],
  );

  static final TangramPiece square = TangramPiece(
    kind: TangramPieceKind.square,
    vertices: const [(0, 0), (1, 0), (1, 1), (0, 1)],
  );

  static final TangramPiece parallelogram = TangramPiece(
    kind: TangramPieceKind.parallelogram,
    vertices: const [(0, 0), (1, 0), (2, 1), (1, 1)],
    canFlip: true,
  );

  /// All 7, in the fixed order the generator draws its subset from.
  static final List<TangramPiece> all = [
    smallTriangle1,
    smallTriangle2,
    mediumTriangle,
    largeTriangle1,
    largeTriangle2,
    square,
    parallelogram,
  ];

  /// The area (in half-square-triangle units of 0.5) every piece is a
  /// whole multiple of -- used by the `count_occurrences` mode to ask "how
  /// many of the smallest triangle would exactly tile this figure".
  static const double smallTriangleArea = 0.5;
}

extension TangramPieceKindLabel on TangramPieceKind {
  /// Whether this piece is one of the 2 small triangles (the fixed
  /// "target shape" `count_occurrences` asks about, see
  /// `tangram_recipe.dart`).
  bool get isSmallTriangle =>
      this == TangramPieceKind.smallTriangle1 ||
      this == TangramPieceKind.smallTriangle2;
}
