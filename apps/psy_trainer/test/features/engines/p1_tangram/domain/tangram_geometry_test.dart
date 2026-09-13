import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/tangram_geometry.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/tangram_piece.dart';

void main() {
  group('polygonArea', () {
    test('unit square is 1', () {
      expect(
        polygonArea(const [(0, 0), (1, 0), (1, 1), (0, 1)]),
        closeTo(1, 1e-9),
      );
    });

    test('matches every catalogue piece\'s documented area', () {
      expect(TangramPieces.smallTriangle1.area, closeTo(0.5, 1e-9));
      expect(TangramPieces.mediumTriangle.area, closeTo(1.0, 1e-9));
      expect(TangramPieces.largeTriangle1.area, closeTo(2.0, 1e-9));
      expect(TangramPieces.square.area, closeTo(1.0, 1e-9));
      expect(TangramPieces.parallelogram.area, closeTo(1.0, 1e-9));
    });
  });

  group('transformPolygon', () {
    test('identity leaves vertices unchanged', () {
      const square = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)];
      final out = transformPolygon(square, dx: 0, dy: 0, rotationSteps: 0);
      for (var i = 0; i < square.length; i++) {
        expect(out[i].$1, closeTo(square[i].$1, 1e-9));
        expect(out[i].$2, closeTo(square[i].$2, 1e-9));
      }
    });

    test('rotating 8 steps (360°) returns to the original', () {
      const tri = [(0.0, 0.0), (2.0, 0.0), (0.0, 2.0)];
      final out = transformPolygon(tri, dx: 0, dy: 0, rotationSteps: 8);
      for (var i = 0; i < tri.length; i++) {
        expect(out[i].$1, closeTo(tri[i].$1, 1e-9));
        expect(out[i].$2, closeTo(tri[i].$2, 1e-9));
      }
    });

    test('rotating 90° (2 steps) maps (1,0) to (0,1)', () {
      final out = transformPolygon(
        const [(1.0, 0.0)],
        dx: 0,
        dy: 0,
        rotationSteps: 2,
      );
      expect(out.single.$1, closeTo(0, 1e-9));
      expect(out.single.$2, closeTo(1, 1e-9));
    });

    test('translation shifts every vertex', () {
      final out = transformPolygon(
        const [(0.0, 0.0), (1.0, 0.0)],
        dx: 3,
        dy: -2,
        rotationSteps: 0,
      );
      expect(out[0], (3.0, -2.0));
      expect(out[1], (4.0, -2.0));
    });

    test('flip mirrors across the local x-axis before rotation', () {
      final out = transformPolygon(
        const [(1.0, 1.0)],
        dx: 0,
        dy: 0,
        rotationSteps: 0,
        flipped: true,
      );
      expect(out.single.$1, closeTo(1, 1e-9));
      expect(out.single.$2, closeTo(-1, 1e-9));
    });

    test('area is preserved by rotation and translation', () {
      final base = TangramPieces.parallelogram.vertices;
      for (var steps = 0; steps < 8; steps++) {
        final out = transformPolygon(base, dx: 5, dy: -3, rotationSteps: steps);
        expect(polygonArea(out), closeTo(polygonArea(base), 1e-9));
      }
    });
  });

  group('pointInPolygon', () {
    const square = [(0.0, 0.0), (2.0, 0.0), (2.0, 2.0), (0.0, 2.0)];

    test('centre is inside', () {
      expect(pointInPolygon((1, 1), square), isTrue);
    });

    test('far outside is outside', () {
      expect(pointInPolygon((10, 10), square), isFalse);
    });

    test('a point just outside a corner is outside', () {
      expect(pointInPolygon((2.5, 2.5), square), isFalse);
    });
  });

  group('rasterisePolygon', () {
    test('a 1x1 square at the origin rasterises to 16 quarter-cells', () {
      const square = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)];
      final cells = rasterisePolygon(square);
      expect(cells.length, 16);
    });

    test('two squares placed edge-to-edge rasterise to disjoint cells', () {
      const left = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)];
      const right = [(1.0, 0.0), (2.0, 0.0), (2.0, 1.0), (1.0, 1.0)];
      final a = rasterisePolygon(left);
      final b = rasterisePolygon(right);
      expect(a.intersection(b), isEmpty);
      expect(a.union(b).length, 32);
    });

    test('two identical squares fully overlap', () {
      const square = [(0.0, 0.0), (1.0, 0.0), (1.0, 1.0), (0.0, 1.0)];
      final a = rasterisePolygon(square);
      final b = rasterisePolygon(square);
      expect(a, b);
    });
  });

  group('cellsShareEdge / cellsAreConnected', () {
    test('edge-adjacent cell sets share an edge', () {
      expect(cellsShareEdge({(0, 0)}, {(1, 0)}), isTrue);
    });

    test('corner-only touching cell sets do not share an edge', () {
      expect(cellsShareEdge({(0, 0)}, {(1, 1)}), isFalse);
    });

    test('a single connected blob is connected', () {
      expect(
        cellsAreConnected([
          {(0, 0), (1, 0), (1, 1)},
        ]),
        isTrue,
      );
    });

    test('two disjoint corner-touching blobs are not connected', () {
      expect(
        cellsAreConnected([
          {(0, 0)},
          {(1, 1)},
        ]),
        isFalse,
      );
    });
  });
}
