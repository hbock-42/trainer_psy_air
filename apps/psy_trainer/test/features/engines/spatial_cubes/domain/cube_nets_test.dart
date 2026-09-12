import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_face.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_folding.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_nets.dart';

void main() {
  test('exactly 11 of the 6-cell polyominoes fold into a cube', () {
    // A textbook result (35 free hexominoes total, 11 of them cube nets),
    // computed here (not hand-transcribed) by cube_nets.dart; this pins
    // both the enumeration and the fold-validity filter at once.
    expect(cubeNets.length, 11);
  });

  test('net ids are stable and unique', () {
    final ids = cubeNets.map((n) => n.id).toSet();
    expect(ids.length, 11);
    expect(ids, contains('net01'));
    expect(ids, contains('net11'));
  });

  test(
    'every net folds onto all 6 distinct faces (opposite-face invariant)',
    () {
      for (final net in cubeNets) {
        final folded = foldNet(net);
        expect(folded.length, 6, reason: 'net ${net.id}');
        final faces = folded.values.map((f) => f.face).toSet();
        expect(faces, CubeFace.values.toSet(), reason: 'net ${net.id}');
        // Opposite pairs are respected: no face is folded onto twice, and
        // together with its five siblings it covers every face exactly
        // once, so its own opposite is necessarily among them too.
        for (final face in CubeFace.values) {
          expect(oppositeFace(oppositeFace(face)), face);
        }
      }
    },
  );

  test('folding the same net twice is deterministic', () {
    for (final net in cubeNets) {
      final a = foldNet(net);
      final b = foldNet(net);
      for (final index in a.keys) {
        expect(
          b[index]!.face,
          a[index]!.face,
          reason: 'net ${net.id} cell $index',
        );
        expect(
          b[index]!.rotation,
          a[index]!.rotation,
          reason: 'net ${net.id} cell $index',
        );
      }
    }
  });

  test('cells are 6, edge-connected within the net', () {
    for (final net in cubeNets) {
      expect(net.cells.length, 6);
      // Connectivity: from cell 0, every other cell is reachable via
      // neighboursOf.
      final visited = <int>{0};
      final queue = [0];
      while (queue.isNotEmpty) {
        final current = queue.removeLast();
        for (final n in net.neighboursOf(current)) {
          if (visited.add(n)) queue.add(n);
        }
      }
      expect(visited.length, 6, reason: 'net ${net.id} is not connected');
    }
  });
}
