import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/p1_tangram_engine.dart';
import 'package:psy_trainer/features/engines/p1_tangram/domain/tangram_board.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = TangramEngine();

  group('compose mode', () {
    const params = P1TangramParams();

    test('generate is deterministic per seed', () {
      final a = engine.generate(params: params, seed: 5, difficulty: 3);
      final b = engine.generate(params: params, seed: 5, difficulty: 3);
      expect(a, isA<GeneratedItem>());
      expect((a as GeneratedItem).seed, (b as GeneratedItem).seed);
      expect(a.id, b.id);
      expect(
        TangramEngine.boardOf(a).targetCells,
        TangramEngine.boardOf(b).targetCells,
      );
    });

    test('scores correct when the submitted placements exactly reproduce '
        "the generator's own solution", () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = TangramEngine.boardOf(item);
      final answer = Answer.raw({
        'placements': [
          for (final p in board.solutionPlacements)
            {
              'dx': p.dx,
              'dy': p.dy,
              'rotationSteps': p.rotationSteps,
              'flipped': p.flipped,
            },
        ],
      });
      final result = engine.score(item, answer);
      expect(result.correct, isTrue);
    });

    test('scores wrong when a piece is left unplaced', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = TangramEngine.boardOf(item);
      final placements = <Map<String, Object?>?>[
        for (final p in board.solutionPlacements)
          {
            'dx': p.dx,
            'dy': p.dy,
            'rotationSteps': p.rotationSteps,
            'flipped': p.flipped,
          },
      ];
      placements[0] = null;
      final result = engine.score(item, Answer.raw({'placements': placements}));
      expect(result.correct, isFalse);
    });

    test('scores wrong when two pieces overlap instead of tiling', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = TangramEngine.boardOf(item);
      final placements = <Map<String, Object?>?>[
        for (final p in board.solutionPlacements)
          {
            'dx': p.dx,
            'dy': p.dy,
            'rotationSteps': p.rotationSteps,
            'flipped': p.flipped,
          },
      ];
      if (placements.length > 1) {
        // Drop piece 1 exactly on top of piece 0 instead of its own spot.
        placements[1] = placements[0];
      }
      final result = engine.score(item, Answer.raw({'placements': placements}));
      expect(result.correct, isFalse);
    });

    test('scores wrong when a placement leaves the target uncovered', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = TangramEngine.boardOf(item);
      final placements = [
        for (final p in board.solutionPlacements)
          {
            'dx': p.dx + 5,
            'dy': p.dy + 5,
            'rotationSteps': p.rotationSteps,
            'flipped': p.flipped,
          },
      ];
      final result = engine.score(item, Answer.raw({'placements': placements}));
      expect(result.correct, isFalse);
    });

    test('timeout and skip answers are handled without scoring geometry', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 1)
              as GeneratedItem;
      expect(engine.score(item, const Answer.timeout()).timedOut, isTrue);
      expect(engine.score(item, const Answer.skip()).skipped, isTrue);
    });
  });

  group('count_occurrences mode', () {
    const params = P1TangramParams(mode: TangramMode.countOccurrences);

    test('generate returns a NumericItem whose expected value is the '
        "board's smallTriangleUnitCount", () {
      final item = engine.generate(params: params, seed: 4, difficulty: 3);
      expect(item, isA<NumericItem>());
      final numeric = item as NumericItem;
      final board = buildTangramBoard(seed: 4, params: params, difficulty: 3);
      expect(numeric.expected, board.smallTriangleUnitCount);
    });

    test('the default scorer accepts the correct numeric answer', () {
      final item =
          engine.generate(params: params, seed: 4, difficulty: 3)
              as NumericItem;
      final result = engine.score(item, Answer.numeric(item.expected));
      expect(result.correct, isTrue);
    });

    test('the default scorer rejects a wrong numeric answer', () {
      final item =
          engine.generate(params: params, seed: 4, difficulty: 3)
              as NumericItem;
      final result = engine.score(item, Answer.numeric(item.expected + 1));
      expect(result.correct, isFalse);
    });

    test('recipeBoardOf rebuilds a board from the item origin', () {
      final item =
          engine.generate(params: params, seed: 4, difficulty: 3)
              as NumericItem;
      final board = TangramEngine.recipeBoardOf(item);
      expect(board.smallTriangleUnitCount, item.expected);
    });
  });

  test('familyId and generatorId match the content contract', () {
    expect(engine.familyId, 'p1_tangram');
    expect(engine.generatorId, GeneratorId.p1Tangram);
  });
}
