import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_engine.dart';
import 'package:psy_trainer/features/engines/planning_tubes/domain/tubes_puzzle.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = TubesEngine();
  const params = TubesParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'planning_tubes');
    expect(engine.generatorId, GeneratorId.tubes);
  });

  group('generate', () {
    test('returns a NumericItem whose expected value is the BFS distance', () {
      final item =
          engine.generate(params: params, seed: 42, difficulty: 3)
              as NumericItem;
      final puzzle = TubesPuzzleGenerator.build(
        params: params,
        seed: 42,
        difficulty: 3,
      );
      expect(item.expected, puzzle.distance);
      expect(item.id, 'gen.tubes.42');
      expect(item.familyId, 'planning_tubes');
      expect(item.inputFormat, InputFormat.integer);
      expect(item.decimals, 0);
      expect(
        item.origin,
        const ItemOrigin(
          generatorId: GeneratorId.tubes,
          seed: 42,
          runSeed: 42,
          index: 0,
        ),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });

    test('threads runSeed and index onto origin (US-037)', () {
      final item =
          engine.generate(
                params: params,
                seed: 5,
                difficulty: 1,
                index: 3,
                runSeed: 999,
              )
              as NumericItem;
      expect(
        item.origin,
        const ItemOrigin(
          generatorId: GeneratorId.tubes,
          seed: 5,
          runSeed: 999,
          index: 3,
        ),
      );
    });

    test('the explanation names the same distance as expected', () {
      for (var seed = 0; seed < 5; seed++) {
        final item =
            engine.generate(params: params, seed: seed, difficulty: 3)
                as NumericItem;
        expect(item.explanation.fr, contains('${item.expected.toInt()}'));
        expect(item.explanation.fr, contains('coup'));
      }
    });
  });

  group('score (default Scorer.scoreItem, no override)', () {
    test('the exact distance scores correct', () {
      final item =
          engine.generate(params: params, seed: 42, difficulty: 3)
              as NumericItem;
      final result = engine.score(item, Answer.numeric(item.expected));
      expect(result.correct, isTrue);
    });

    test('an off-by-one answer scores wrong (tolerance 0)', () {
      final item =
          engine.generate(params: params, seed: 42, difficulty: 3)
              as NumericItem;
      final result = engine.score(item, Answer.numeric(item.expected + 1));
      expect(result.correct, isFalse);
    });
  });

  group('TubesEngine.puzzleOf', () {
    test('recomputes the same puzzle the item was generated from', () {
      final item =
          engine.generate(params: params, seed: 15, difficulty: 4)
              as NumericItem;
      final puzzle = TubesEngine.puzzleOf(item);
      expect(puzzle.distance, item.expected.toInt());
      expect(puzzle.capacities, params.capacities);
    });
  });
}
