import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_geometry.dart';

void main() {
  group('viewDirection', () {
    test('azimuth 1 (north) faces south', () {
      final d = viewDirection(1);
      expect(d.east, closeTo(0, 1e-9));
      expect(d.north, closeTo(-1, 1e-9));
    });

    test('azimuth 3 (east) faces west', () {
      final d = viewDirection(3);
      expect(d.east, closeTo(-1, 1e-9));
      expect(d.north, closeTo(0, 1e-9));
    });

    test('azimuth 5 (south) faces north', () {
      final d = viewDirection(5);
      expect(d.east, closeTo(0, 1e-9));
      expect(d.north, closeTo(1, 1e-9));
    });

    test('azimuth 7 (west) faces east', () {
      final d = viewDirection(7);
      expect(d.east, closeTo(1, 1e-9));
      expect(d.north, closeTo(0, 1e-9));
    });
  });

  group('lateralOf: left/right, matching the lesson\'s own rule', () {
    // Lesson (`spatial_viewpoint/*.fr.md`): "face au nord, l'est est à
    // droite ; face au sud, l'est est à gauche ; face à l'est, le nord est
    // à gauche ; face à l'ouest, le nord est à droite."
    test('facing south (azimuth 1, north), east is on the left', () {
      // An object due east (gx=1, gy=0) must have negative lateral (left)
      // for the observer standing at the north position (facing south).
      expect(lateralOf(1, 0, 1), lessThan(0));
    });

    test('facing north (azimuth 5, south), east is on the right', () {
      expect(lateralOf(1, 0, 5), greaterThan(0));
    });

    test('standing east (azimuth 3, facing west), north is on the right', () {
      // Lesson: "face à l'ouest, le nord est à droite".
      expect(lateralOf(0, 1, 3), greaterThan(0));
    });

    test('standing west (azimuth 7, facing east), north is on the left', () {
      // Lesson: "face à l'est, le nord est à gauche".
      expect(lateralOf(0, 1, 7), lessThan(0));
    });
  });

  group('depthOf: near/far', () {
    test('an object on the observer\'s side of the scene is nearer', () {
      // Observer at azimuth 1 stands north; an object to the north (gy=2)
      // is nearer than one to the south (gy=-2).
      final near = depthOf(0, 2, 1);
      final far = depthOf(0, -2, 1);
      expect(near, lessThan(far));
    });
  });

  group('projection ordering across all 8 azimuths on a fixed layout', () {
    // Three points, one on each cardinal-ish axis, far enough apart that no
    // azimuth ties any pair (regression guard for the formulas above).
    const points = [(2, 0), (0, 2), (-2, -1)];

    for (var azimuth = 1; azimuth <= 8; azimuth++) {
      test('azimuth $azimuth: lateral and depth values are all distinct', () {
        final laterals = [
          for (final p in points) lateralOf(p.$1, p.$2, azimuth),
        ];
        final depths = [for (final p in points) depthOf(p.$1, p.$2, azimuth)];
        expect(laterals.toSet().length, laterals.length);
        expect(depths.toSet().length, depths.length);
      });
    }

    test('opposite azimuths (n, n+4) mirror both lateral and depth', () {
      for (var azimuth = 1; azimuth <= 4; azimuth++) {
        final opposite = azimuth + 4;
        for (final p in points) {
          expect(
            lateralOf(p.$1, p.$2, opposite),
            closeTo(-lateralOf(p.$1, p.$2, azimuth), 1e-9),
          );
          expect(
            depthOf(p.$1, p.$2, opposite),
            closeTo(-depthOf(p.$1, p.$2, azimuth), 1e-9),
          );
        }
      }
    });
  });
}
