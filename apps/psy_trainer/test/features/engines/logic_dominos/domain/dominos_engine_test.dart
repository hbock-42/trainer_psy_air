import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/domino_board.dart';
import 'package:psy_trainer/features/engines/logic_dominos/domain/dominos_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = DominosEngine();
  const params = DominosParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'logic_dominos');
    expect(engine.generatorId, GeneratorId.dominos);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe, not the materialised puzzle', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.dominos.42');
      expect(generated.familyId, 'logic_dominos');
      expect(generated.generatorId, GeneratorId.dominos);
      expect(generated.seed, 42);
      expect(generated.difficulty, 3);
      expect(generated.params, params);
      expect(
        generated.origin,
        const ItemOrigin(generatorId: GeneratorId.dominos, seed: 42),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });

    test(
      'a too-short length is clamped up so the solver can pin down a board',
      () {
        // A 2-domino series can never be pinned down by the solver (see
        // domino_board_test.dart), so buildDominoBoard raises its own length
        // to at least 6; generate must not surface a shorter, unscoreable
        // board just because a section's params asked for one.
        final item = engine.generate(
          params: const DominosParams(length: 2),
          seed: 1,
          difficulty: 1,
        );
        final board = buildDominoBoard(
          seed: 1,
          params: const DominosParams(length: 2),
          difficulty: 1,
        );
        expect(board.dominoes.length, greaterThanOrEqualTo(6));
        expect(item, isA<GeneratedItem>());
      },
    );
  });

  group('score', () {
    test('the right two halves, in order, score correct', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final board = buildDominoBoard(seed: 99, params: params, difficulty: 2);
      final result = engine.score(
        item,
        Answer.sequence(['${board.answer.top}', '${board.answer.bottom}']),
      );
      expect(result.correct, isTrue);
    });

    test('the halves swapped score wrong', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final board = buildDominoBoard(seed: 99, params: params, difficulty: 2);
      if (board.answer.top == board.answer.bottom) return; // not a useful case
      final result = engine.score(
        item,
        Answer.sequence(['${board.answer.bottom}', '${board.answer.top}']),
      );
      expect(result.correct, isFalse);
    });

    test('a wrong pair scores wrong', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final board = buildDominoBoard(seed: 99, params: params, difficulty: 2);
      final wrongTop = (board.answer.top + 1) % 7;
      final result = engine.score(
        item,
        Answer.sequence(['$wrongTop', '${board.answer.bottom}']),
      );
      expect(result.correct, isFalse);
    });

    test('an answer of the wrong kind scores wrong', () {
      final item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
    });
  });
}
