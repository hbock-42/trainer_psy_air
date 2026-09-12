import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_engine.dart';
import 'package:psy_trainer/features/engines/spatial_viewpoint/domain/viewpoint_scene.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = ViewpointEngine();
  const params = ViewpointParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'spatial_viewpoint');
    expect(engine.generatorId, GeneratorId.viewpoint);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe, not the materialised scene', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.viewpoint.42');
      expect(generated.familyId, 'spatial_viewpoint');
      expect(generated.generatorId, GeneratorId.viewpoint);
      expect(generated.seed, 42);
      expect(generated.difficulty, 3);
      expect(generated.params, params);
      expect(
        generated.origin,
        const ItemOrigin(generatorId: GeneratorId.viewpoint, seed: 42),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });
  });

  group('score', () {
    test('the correct azimuth (0-based) scores correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final scene = buildViewpointScene(
        seed: 99,
        params: params,
        difficulty: 2,
      );
      final result = engine.score(
        item,
        Answer.choice(scene.correctAzimuth - 1),
      );
      expect(result.correct, isTrue);
    });

    test('any other azimuth scores wrong', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final scene = buildViewpointScene(
        seed: 99,
        params: params,
        difficulty: 2,
      );
      final wrongAzimuth = (scene.correctAzimuth % 8) + 1;
      final result = engine.score(item, Answer.choice(wrongAzimuth - 1));
      expect(result.correct, isFalse);
    });

    test('an answer of the wrong kind scores wrong', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final result = engine.score(item, const Answer.sequence(['1']));
      expect(result.correct, isFalse);
    });
  });
}
