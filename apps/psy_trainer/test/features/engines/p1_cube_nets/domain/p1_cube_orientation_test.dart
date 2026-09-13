import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/p1_cube_nets/domain/p1_cube_orientation.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_face.dart';

void main() {
  group('cubeOrientations', () {
    test('has exactly 24 distinct orientations', () {
      expect(cubeOrientations.length, 24);
      expect(cubeOrientations.toSet().length, 24);
    });

    test('includes the identity', () {
      expect(cubeOrientations, contains(CubeOrientation.identity));
    });

    test('every orientation is a valid bijection onto CubeFace.values', () {
      for (final o in cubeOrientations) {
        final faces = {o.top, o.bottom, o.front, o.back, o.left, o.right};
        expect(faces, CubeFace.values.toSet());
      }
    });

    test('every orientation keeps opposite faces opposite', () {
      for (final o in cubeOrientations) {
        expect(o.bottom, oppositeFace(o.top));
        expect(o.back, oppositeFace(o.front));
        expect(o.left, oppositeFace(o.right));
      }
    });

    test('4 spins of the same orientation return to it (period 4)', () {
      for (final o in cubeOrientations.take(6)) {
        var s = o;
        for (var i = 0; i < 4; i++) {
          s = s.spinCw();
        }
        expect(s, o);
      }
    });

    test('4 forward tips of the same orientation return to it (period 4)', () {
      for (final o in cubeOrientations.take(6)) {
        var s = o;
        for (var i = 0; i < 4; i++) {
          s = s.tipForward();
        }
        expect(s, o);
      }
    });

    test('visibleSlots exposes exactly top/front/right', () {
      final slots = CubeOrientation.identity.visibleSlots;
      expect(slots.keys.toSet(), {
        CubeFace.top,
        CubeFace.front,
        CubeFace.right,
      });
      expect(slots[CubeFace.top], CubeFace.top);
      expect(slots[CubeFace.front], CubeFace.front);
      expect(slots[CubeFace.right], CubeFace.right);
    });

    test('every one of the 24 orientations shows a distinct (top, front, '
        'right) visible triple', () {
      final triples = cubeOrientations
          .map((o) => (o.top, o.front, o.right))
          .toSet();
      expect(triples.length, 24);
    });
  });
}
