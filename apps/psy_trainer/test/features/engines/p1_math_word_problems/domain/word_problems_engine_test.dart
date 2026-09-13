import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_math_word_problems/domain/word_problems_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = MathWordProblemsEngine();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_math_word_problems');
    expect(engine.generatorId, GeneratorId.p1MathWordProblems);
  });

  test('generate is deterministic', () {
    const params = GeneratorParams.p1MathWordProblems();
    final a = engine.generate(params: params, seed: 7, difficulty: 3);
    final b = engine.generate(params: params, seed: 7, difficulty: 3);
    expect(a, b);
  });

  group('numeric mode', () {
    const params = GeneratorParams.p1MathWordProblems(
      answerMode: P1AnswerMode.numeric,
    );

    test('returns a NumericItem with the origin/id contract', () {
      final item = engine.generate(params: params, seed: 3, difficulty: 3);
      expect(item, isA<NumericItem>());
      final numeric = item as NumericItem;
      expect(numeric.id, 'gen.p1_math_word_problems.3');
      expect(numeric.familyId, 'p1_math_word_problems');
      expect(
        numeric.origin,
        const ItemOrigin(
          generatorId: GeneratorId.p1MathWordProblems,
          seed: 3,
          runSeed: 3,
          index: 0,
        ),
      );
      expect(numeric.explanation.fr, isNotEmpty);
      expect(numeric.stem.fr, isNotEmpty);
    });

    test('scores correct on the exact expected value, wrong otherwise', () {
      for (var seed = 0; seed < 100; seed++) {
        final item =
            engine.generate(params: params, seed: seed, difficulty: 3)
                as NumericItem;
        final right = engine.score(item, Answer.numeric(item.expected));
        expect(right.correct, isTrue, reason: 'seed=$seed');
        final wrong = engine.score(item, Answer.numeric(item.expected + 1000));
        expect(wrong.correct, isFalse, reason: 'seed=$seed');
      }
    });

    test('a timeout is never scored right or wrong', () {
      final item =
          engine.generate(params: params, seed: 1, difficulty: 3)
              as NumericItem;
      expect(engine.score(item, const Answer.timeout()).timedOut, isTrue);
    });
  });

  group('mcq mode', () {
    const params = GeneratorParams.p1MathWordProblems(); // default: mcq

    test('returns an McqItem with 4 options', () {
      final item = engine.generate(params: params, seed: 4, difficulty: 3);
      expect(item, isA<McqItem>());
      final mcq = item as McqItem;
      expect(mcq.options.length, 4);
      expect(mcq.correctIndex, inInclusiveRange(0, 3));
    });

    test('scores correct on the correct index, wrong otherwise', () {
      for (var seed = 0; seed < 100; seed++) {
        final item =
            engine.generate(params: params, seed: seed, difficulty: 3)
                as McqItem;
        final right = engine.score(item, Answer.choice(item.correctIndex));
        expect(right.correct, isTrue, reason: 'seed=$seed');
        final wrongIndex = (item.correctIndex + 1) % item.options.length;
        final wrong = engine.score(item, Answer.choice(wrongIndex));
        expect(wrong.correct, isFalse, reason: 'seed=$seed');
      }
    });
  });

  test('difficulty scaling never produces an invalid item (1..5)', () {
    const params = GeneratorParams.p1MathWordProblems();
    for (
      var difficulty = minDifficulty;
      difficulty <= maxDifficulty;
      difficulty++
    ) {
      for (var seed = 0; seed < 30; seed++) {
        final item = engine.generate(
          params: params,
          seed: seed,
          difficulty: difficulty,
        );
        expect(item.difficulty, difficulty);
      }
    }
  });
}
