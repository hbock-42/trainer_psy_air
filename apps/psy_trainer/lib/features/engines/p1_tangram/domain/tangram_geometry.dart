import 'dart:math' as math;

/// A 2D point in piece/board units (doubles): `(x, y)`.
typedef Point2 = (double, double);

/// One rasterised cell index (see [rasterisePolygon]).
typedef CellIndex = (int, int);

/// Area of a simple polygon (shoelace formula), always non-negative
/// regardless of winding.
double polygonArea(List<Point2> vertices) {
  var sum = 0.0;
  for (var i = 0; i < vertices.length; i++) {
    final (x0, y0) = vertices[i];
    final (x1, y1) = vertices[(i + 1) % vertices.length];
    sum += x0 * y1 - x1 * y0;
  }
  return sum.abs() / 2;
}

/// Translates, rotates (by `steps * 45°`, counter-clockwise) and optionally
/// flips (mirrors across the local x-axis, applied *before* rotation)
/// [vertices] -- the one placement transform every tangram piece uses
/// (`TangramPiece` base vertices -> absolute board coordinates).
///
/// `steps` is taken mod 8 so any int is a valid rotation; the trig terms
/// are evaluated once per call with `dart:math`, which is exact enough at
/// double precision for the 1/4-cell rasterisation this module's checks
/// run at (see [rasterisePolygon]'s doc comment for why that margin is
/// generous).
List<Point2> transformPolygon(
  List<Point2> vertices, {
  required double dx,
  required double dy,
  required int rotationSteps,
  bool flipped = false,
}) {
  final steps = rotationSteps % 8;
  final angle = steps * math.pi / 4;
  final cosA = math.cos(angle);
  final sinA = math.sin(angle);
  return [
    for (final (x0, y0) in vertices)
      () {
        final (x, y) = flipped ? (x0, -y0) : (x0, y0);
        final rx = x * cosA - y * sinA;
        final ry = x * sinA + y * cosA;
        return (rx + dx, ry + dy);
      }(),
  ];
}

/// Standard even-odd ray-casting point-in-polygon test, boundary points
/// counted as inside (a cell-centre exactly on an edge -- vanishingly rare
/// at 1/4-cell resolution given our pieces' vertex coordinates, but never
/// ambiguous either way for the exact-cover check: both neighbours of a
/// shared edge rasterise that edge's cells as covered by whichever piece's
/// half-open test claims them first, and a target built by the same
/// rasteriser is compared against candidates built by it too, so any such
/// boundary bias is applied identically to target and candidate).
bool pointInPolygon(Point2 point, List<Point2> polygon) {
  final (px, py) = point;
  var inside = false;
  for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
    final (xi, yi) = polygon[i];
    final (xj, yj) = polygon[j];
    final onSegment =
        (py - yi) * (xj - xi) == (yj - yi) * (px - xi) &&
        px >= math.min(xi, xj) &&
        px <= math.max(xi, xj) &&
        py >= math.min(yi, yj) &&
        py <= math.max(yi, yj);
    if (onSegment) return true;
    final crosses =
        (yi > py) != (yj > py) && px < (xj - xi) * (py - yi) / (yj - yi) + xi;
    if (crosses) inside = !inside;
  }
  return inside;
}

/// Default rasterisation resolution: one cell is `1/4` of a board unit
/// (the "1/4-cell" grid the spec calls for) -- fine enough that no genuine
/// tangram piece (whose own vertices, at any of the 8 `rotationSteps` and
/// either flip, land at worst on multiples of `1/2` after the 45° trig
/// above) can straddle a cell in a way that changes whether two polygons
/// exactly cover the same region, yet coarse enough that a whole board
/// (7 pieces, bounding box a handful of units) rasterises to at most a few
/// hundred cells -- cheap for both the generator's assembly search and the
/// scorer's exact-cover check.
const double defaultCellSize = 0.25;

/// Rasterises [polygon] into the set of cells (of side [cellSize], indexed
/// from the origin) whose *centre* falls inside it.
///
/// This is a deliberate approximation, not an exact-area computation: it
/// treats "this cell is part of the shape" as "this cell's centre point is
/// inside the polygon". At [defaultCellSize] (1/4 of a piece unit) this
/// reproduces every piece boundary to a visually and geometrically
/// unambiguous precision for tangram-scale figures (a handful of units
/// across) -- two pieces placed edge-to-edge share no cell (their shared
/// edge falls exactly between two rows/columns of cell centres), and a
/// candidate placement that is off by any amount coarser than half a cell
/// rasterises differently from the target, which is exactly the
/// sensitivity an "exact cover" check needs. It is *not* meant to resolve
/// sub-cell slivers -- that is not a concern here since every legal
/// placement (translation is snapped to the same [defaultCellSize] grid
/// by the renderer, see `p1_tangram_renderer.dart`) always lands piece
/// edges on this grid's lines.
Set<CellIndex> rasterisePolygon(
  List<Point2> polygon, {
  double cellSize = defaultCellSize,
}) {
  if (polygon.isEmpty) return {};
  var minX = polygon.first.$1, maxX = polygon.first.$1;
  var minY = polygon.first.$2, maxY = polygon.first.$2;
  for (final (x, y) in polygon) {
    if (x < minX) minX = x;
    if (x > maxX) maxX = x;
    if (y < minY) minY = y;
    if (y > maxY) maxY = y;
  }
  final iMin = (minX / cellSize).floor();
  final iMax = (maxX / cellSize).ceil();
  final jMin = (minY / cellSize).floor();
  final jMax = (maxY / cellSize).ceil();
  final cells = <CellIndex>{};
  for (var i = iMin; i <= iMax; i++) {
    final cx = (i + 0.5) * cellSize;
    for (var j = jMin; j <= jMax; j++) {
      final cy = (j + 0.5) * cellSize;
      if (pointInPolygon((cx, cy), polygon)) cells.add((i, j));
    }
  }
  return cells;
}

/// Whether [a] and [b] (both rasterised cell sets) touch along a shared
/// edge -- not merely a shared corner -- so an assembled tangram figure is
/// a single connected shape rather than pieces meeting point-to-point.
bool cellsShareEdge(Set<CellIndex> a, Set<CellIndex> b) {
  for (final (i, j) in a) {
    if (b.contains((i + 1, j)) ||
        b.contains((i - 1, j)) ||
        b.contains((i, j + 1)) ||
        b.contains((i, j - 1))) {
      return true;
    }
  }
  return false;
}

/// Whether the union of [cellSets] forms one 4-connected region (every
/// cell reachable from every other through shared edges) -- the
/// "connected figure" requirement for a generated tangram target.
bool cellsAreConnected(List<Set<CellIndex>> cellSets) {
  final all = <CellIndex>{for (final s in cellSets) ...s};
  if (all.isEmpty) return true;
  final visited = <CellIndex>{};
  final stack = [all.first];
  visited.add(all.first);
  while (stack.isNotEmpty) {
    final (i, j) = stack.removeLast();
    for (final n in [(i + 1, j), (i - 1, j), (i, j + 1), (i, j - 1)]) {
      if (all.contains(n) && visited.add(n)) stack.add(n);
    }
  }
  return visited.length == all.length;
}
