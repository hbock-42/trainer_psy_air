import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_explanation.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';

void main() {
  test('names the correct azimuth and the leftmost/rightmost objects', () {
    // Observer at azimuth 1 (north, facing south): east is on the left
    // (see viewpoint_geometry_test.dart), so an object due east (gx=1,
    // gy=0) is left of one due west (gx=-1, gy=0).
    const scene = ViewpointScene(
      objects: [
        ViewpointObject(gx: -1, gy: 0, kind: SolidKind.cube, colorIndex: 0),
        ViewpointObject(gx: 1, gy: 0, kind: SolidKind.cylinder, colorIndex: 1),
      ],
      correctAzimuth: 1,
    );
    final text = explanationFor(scene);
    expect(text, contains('position 1'));
    expect(text, contains('cylindre'));
    expect(text, contains('cube'));
    expect(
      text.indexOf('cylindre'),
      lessThan(text.indexOf('cube')),
      reason: 'the east object (cylindre) is on the left, named first',
    );
  });
}
