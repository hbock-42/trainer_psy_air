import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/spatial_overlay/domain/overlay_grid_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = OverlayGridEngine();
  const params = GeneratorParams.overlayGrid();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'spatial_overlay');
    expect(engine.generatorId, GeneratorId.overlayGrid);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe, not the materialised board', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.overlay_grid.42');
      expect(generated.familyId, 'spatial_overlay');
      expect(generated.generatorId, GeneratorId.overlayGrid);
      expect(generated.seed, 42);
      expect(generated.difficulty, 3);
      expect(generated.params, params);
      expect(
        generated.origin,
        const ItemOrigin(generatorId: GeneratorId.overlayGrid, seed: 42),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });
  });

  group('boardOf', () {
    test('recomputes the same board generate() proved unique', () {
      final item =
          engine.generate(params: params, seed: 5, difficulty: 3)
              as GeneratedItem;
      final board = OverlayGridEngine.boardOf(item);
      const overlayParams = params as OverlayGridParams;
      expect(board.gridRows, overlayParams.grid.rows);
      expect(board.gridCols, overlayParams.grid.cols);
    });
  });

  group('score', () {
    test('the solution positions score correct, with the reported move '
        'count as a metric', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = OverlayGridEngine.boardOf(item);
      final result = engine.score(
        item,
        Answer.raw({
          'tilePositions': [
            for (final p in board.solutionPositions) [p.$1, p.$2],
          ],
          'moves': 5,
        }),
      );
      expect(result.correct, isTrue);
      expect(result.metrics['moves'], 5);
    });

    test('the everyone-at-their-first-legal-position placement scores '
        'wrong (it is not the proven-unique solution), over many seeds', () {
      for (var seed = 0; seed < 30; seed++) {
        final item =
            engine.generate(params: params, seed: seed, difficulty: 3)
                as GeneratedItem;
        final board = OverlayGridEngine.boardOf(item);
        final firstLegal = [
          for (final tile in board.tiles)
            tile.positionsIn(board.gridRows, board.gridCols).first,
        ];
        if (firstLegal.asMap().entries.every(
          (e) => e.value == board.solutionPositions[e.key],
        )) {
          continue; // the rare board whose solution is that placement
        }
        final result = engine.score(
          item,
          Answer.raw({
            'tilePositions': [
              for (final p in firstLegal) [p.$1, p.$2],
            ],
            'moves': 1,
          }),
        );
        expect(result.correct, isFalse, reason: 'seed=$seed');
      }
    });

    test('leaving one tile in the tray (null) scores wrong', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final board = OverlayGridEngine.boardOf(item);
      final result = engine.score(
        item,
        Answer.raw({
          'tilePositions': [
            for (var i = 0; i < board.tiles.length; i++)
              if (i == 0)
                null
              else
                [board.solutionPositions[i].$1, board.solutionPositions[i].$2],
          ],
          'moves': 2,
        }),
      );
      expect(result.correct, isFalse);
    });

    test('a timeout answer scores as a timeout', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final result = engine.score(item, const Answer.timeout());
      expect(result.timedOut, isTrue);
      expect(result.correct, isFalse);
    });

    test('an answer of the wrong kind scores wrong', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 3)
              as GeneratedItem;
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
    });
  });
}
