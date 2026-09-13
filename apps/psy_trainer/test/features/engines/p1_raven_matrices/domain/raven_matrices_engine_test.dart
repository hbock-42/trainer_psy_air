import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/matrix_board.dart';
import 'package:psy_trainer/features/engines/p1_raven_matrices/domain/raven_matrices_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = RavenMatricesEngine();
  const params = P1RavenMatricesParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_raven_matrices');
    expect(engine.generatorId, GeneratorId.p1RavenMatrices);
  });

  group('generate', () {
    test('returns a GeneratedItem recipe, not the materialised puzzle', () {
      final item = engine.generate(params: params, seed: 42, difficulty: 3);
      expect(item, isA<GeneratedItem>());
      final generated = item as GeneratedItem;
      expect(generated.id, 'gen.p1_raven_matrices.42');
      expect(generated.familyId, 'p1_raven_matrices');
      expect(generated.generatorId, GeneratorId.p1RavenMatrices);
      expect(generated.seed, 42);
      expect(generated.difficulty, 3);
      expect(generated.params, params);
      expect(
        generated.origin,
        const ItemOrigin(generatorId: GeneratorId.p1RavenMatrices, seed: 42),
      );
    });

    test('is deterministic: same inputs, same item', () {
      final a = engine.generate(params: params, seed: 7, difficulty: 2);
      final b = engine.generate(params: params, seed: 7, difficulty: 2);
      expect(a, b);
    });
  });

  group('score', () {
    late GeneratedItem item;
    late MatrixBoard board;

    setUp(() {
      item =
          engine.generate(params: params, seed: 99, difficulty: 2)
              as GeneratedItem;
      board = RavenMatricesEngine.boardOf(item);
    });

    test('the correct candidate index scores correct', () {
      final result = engine.score(item, Answer.choice(board.correctIndex));
      expect(result.correct, isTrue);
    });

    test('any other candidate index scores wrong', () {
      for (var i = 0; i < board.candidates.length; i++) {
        if (i == board.correctIndex) continue;
        final result = engine.score(item, Answer.choice(i));
        expect(result.correct, isFalse, reason: 'index $i');
      }
    });

    test('an answer of the wrong kind scores wrong', () {
      final result = engine.score(item, const Answer.skip());
      expect(result.correct, isFalse);
    });
  });
}
