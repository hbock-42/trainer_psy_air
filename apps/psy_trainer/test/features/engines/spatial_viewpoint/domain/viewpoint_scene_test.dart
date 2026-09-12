import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';

void main() {
  const params = ViewpointParams();

  group('buildViewpointScene', () {
    test('is deterministic: same inputs, same scene', () {
      final a = buildViewpointScene(seed: 7, params: params, difficulty: 3);
      final b = buildViewpointScene(seed: 7, params: params, difficulty: 3);
      expect(a.correctAzimuth, b.correctAzimuth);
      expect(a.objects.length, b.objects.length);
      for (var i = 0; i < a.objects.length; i++) {
        expect(a.objects[i].gx, b.objects[i].gx);
        expect(a.objects[i].gy, b.objects[i].gy);
        expect(a.objects[i].kind, b.objects[i].kind);
        expect(a.objects[i].colorIndex, b.objects[i].colorIndex);
      }
    });

    test('a different seed generally yields a different scene', () {
      final a = buildViewpointScene(seed: 1, params: params, difficulty: 3);
      final b = buildViewpointScene(seed: 2, params: params, difficulty: 3);
      final same =
          a.correctAzimuth == b.correctAzimuth &&
          a.objects.length == b.objects.length &&
          List.generate(
            a.objects.length,
            (i) =>
                a.objects[i].gx == b.objects[i].gx &&
                a.objects[i].gy == b.objects[i].gy,
          ).every((x) => x);
      expect(same, isFalse);
    });

    test('object count follows difficulty, clamped to 3..6', () {
      final low = buildViewpointScene(seed: 3, params: params, difficulty: 1);
      final high = buildViewpointScene(seed: 3, params: params, difficulty: 5);
      expect(low.objects.length, greaterThanOrEqualTo(3));
      expect(high.objects.length, lessThanOrEqualTo(6));
    });

    test('objects sit on distinct grid cells', () {
      final scene = buildViewpointScene(
        seed: 11,
        params: params,
        difficulty: 4,
      );
      final cells = scene.objects.map((o) => (o.gx, o.gy)).toSet();
      expect(cells.length, scene.objects.length);
    });

    test('colours are distinct within one scene', () {
      final scene = buildViewpointScene(
        seed: 11,
        params: params,
        difficulty: 4,
      );
      final colors = scene.objects.map((o) => o.colorIndex).toSet();
      expect(colors.length, scene.objects.length);
    });

    test('correctAzimuth is always 1..8', () {
      for (var seed = 0; seed < 50; seed++) {
        final scene = buildViewpointScene(
          seed: seed,
          params: params,
          difficulty: 3,
        );
        expect(scene.correctAzimuth, inInclusiveRange(1, 8));
      }
    });

    test('every scene is unambiguous: no two azimuths share a projection '
        'signature, across many seeds and both allowSymmetric settings', () {
      for (final allowSymmetric in [false, true]) {
        final symParams = ViewpointParams(allowSymmetric: allowSymmetric);
        for (var seed = 0; seed < 200; seed++) {
          for (var difficulty = 1; difficulty <= 5; difficulty++) {
            final scene = buildViewpointScene(
              seed: seed,
              params: symParams,
              difficulty: difficulty,
            );
            final signatures = [
              for (var azimuth = 1; azimuth <= 8; azimuth++)
                projectionSignature(scene, azimuth),
            ];
            for (var i = 0; i < signatures.length; i++) {
              for (var j = i + 1; j < signatures.length; j++) {
                final same =
                    _sameOrder(
                      signatures[i].leftToRight,
                      signatures[j].leftToRight,
                    ) &&
                    _sameOrder(
                      signatures[i].nearToFar,
                      signatures[j].nearToFar,
                    );
                expect(
                  same,
                  isFalse,
                  reason:
                      'seed=$seed difficulty=$difficulty symmetric='
                      '$allowSymmetric azimuths ${i + 1} and ${j + 1} tie',
                );
              }
            }
          }
        }
      }
    });
  });
}

bool _sameOrder(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
