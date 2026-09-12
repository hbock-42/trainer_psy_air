import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_engine.dart';
import 'package:psy_trainer/features/engines/spatial_cubes/domain/cube_net_puzzle.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

Map<String, Object?> _correctPayload(CubeNetPuzzle puzzle) => {
  for (final entry in puzzle.targetRequired.entries)
    'slot_${entry.key}': {
      'face': entry.value.face.name,
      'mirrored': false,
      'rotation': entry.value.rotation,
    },
};

void main() {
  const engine = CubeNetEngine();
  const params = CubeNetParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'spatial_cubes');
    expect(engine.generatorId, GeneratorId.cubeNet);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.cube_net.42');
      expect(generated.familyId, 'spatial_cubes');
      expect(generated.generatorId, GeneratorId.cubeNet);
      expect(generated.seed, 42);
      expect(generated.difficulty, 3);
      expect(
        generated.origin,
        const ItemOrigin(generatorId: GeneratorId.cubeNet, seed: 42),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });
  });

  group('score', () {
    test('every slot filled correctly scores correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 3)
              as GeneratedItem;
      final puzzle = buildCubeNetPuzzle(
        seed: 99,
        params: params,
        difficulty: 3,
      );
      final result = engine.score(item, Answer.raw(_correctPayload(puzzle)));
      expect(result.correct, isTrue);
      expect(result.metrics['correctFaces'], puzzle.missingCellIndices.length);
    });

    test('one wrong slot scores wrong overall but partial metrics', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 3)
              as GeneratedItem;
      final puzzle = buildCubeNetPuzzle(
        seed: 99,
        params: params,
        difficulty: 3,
      );
      final payload = _correctPayload(puzzle);
      final firstSlot = puzzle.missingCellIndices.first;
      payload['slot_$firstSlot'] = {
        'face': puzzle.targetRequired[firstSlot]!.face.name,
        'mirrored': false,
        'rotation': (puzzle.targetRequired[firstSlot]!.rotation + 90) % 360,
      };
      final result = engine.score(item, Answer.raw(payload));
      expect(result.correct, isFalse);
      expect(
        result.metrics['correctFaces'],
        puzzle.missingCellIndices.length - 1,
      );
    });

    test('a mirrored placement never scores correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final puzzle = buildCubeNetPuzzle(
        seed: 99,
        params: params,
        difficulty: 2,
      );
      final payload = _correctPayload(puzzle);
      final firstSlot = puzzle.missingCellIndices.first;
      (payload['slot_$firstSlot']! as Map)['mirrored'] = true;
      final result = engine.score(item, Answer.raw(payload));
      expect(result.correct, isFalse);
    });

    test('timeout and skip pass through', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 2)
              as GeneratedItem;
      expect(engine.score(item, const Answer.timeout()).timedOut, isTrue);
      expect(engine.score(item, const Answer.skip()).skipped, isTrue);
    });

    test('an answer of the wrong kind scores wrong', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 2)
              as GeneratedItem;
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
    });
  });
}
