import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/domain/mental_arithmetic.dart';
import 'package:psy_trainer/features/engines/p1_mental_arithmetic/domain/mental_arithmetic_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = MentalArithmeticEngine();
  const params = GeneratorParams.p1MentalArithmetic();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_mental_arithmetic');
    expect(engine.generatorId, GeneratorId.p1MentalArithmetic);
  });

  test('generate is deterministic', () {
    final a = engine.generate(
      params: params,
      seed: 7,
      difficulty: 3,
      index: 5,
    );
    final b = engine.generate(
      params: params,
      seed: 7,
      difficulty: 3,
      index: 5,
    );
    expect(a, b);
  });

  group('freeNumeric (index 0..9)', () {
    test('returns a NumericItem, expected == the true value, exact match', () {
      final item =
          engine.generate(params: params, seed: 3, difficulty: 3, index: 2)
              as NumericItem;
      final problem = MentalArithmeticGenerator.build(
        params: params as P1MentalArithmeticParams,
        seed: 3,
        difficulty: 3,
        index: 2,
      );
      expect(item.expected, problem.trueValue);

      final right = engine.score(item, Answer.numeric(problem.trueValue));
      expect(right.correct, isTrue);
      final wrong = engine.score(
        item,
        Answer.numeric(problem.trueValue + 1),
      );
      expect(wrong.correct, isFalse);
    });
  });

  group('equation (index 10..19)', () {
    test('returns a NumericItem whose expected is x', () {
      final item =
          engine.generate(params: params, seed: 4, difficulty: 3, index: 12)
              as NumericItem;
      final problem = MentalArithmeticGenerator.build(
        params: params as P1MentalArithmeticParams,
        seed: 4,
        difficulty: 3,
        index: 12,
      );
      expect(item.expected, problem.trueValue);
      expect(engine.score(item, Answer.numeric(problem.trueValue)).correct, isTrue);
    });
  });

  group('smallestInterval (index 20..29)', () {
    test('returns an McqItem whose correctIndex is the tightest interval', () {
      final item =
          engine.generate(params: params, seed: 5, difficulty: 3, index: 22)
              as McqItem;
      final problem = MentalArithmeticGenerator.build(
        params: params as P1MentalArithmeticParams,
        seed: 5,
        difficulty: 3,
        index: 22,
      );
      expect(item.options.length, problem.intervals.length);
      expect(item.correctIndex, problem.tightestIndex);

      final right = engine.score(item, Answer.choice(item.correctIndex));
      expect(right.correct, isTrue);
      final wrongIndex = (item.correctIndex + 1) % item.options.length;
      final wrong = engine.score(item, Answer.choice(wrongIndex));
      expect(wrong.correct, isFalse);
    });
  });

  group('allIntervals (index 30..39)', () {
    test('returns a GeneratedItem', () {
      final item = engine.generate(
        params: params,
        seed: 6,
        difficulty: 3,
        index: 32,
      );
      expect(item, isA<GeneratedItem>());
      expect(
        (item as GeneratedItem).origin,
        ItemOrigin(
          generatorId: GeneratorId.p1MentalArithmetic,
          seed: 6,
          runSeed: 6,
          index: 32,
        ),
      );
    });

    test('selecting exactly the containing set scores correct', () {
      final item =
          engine.generate(params: params, seed: 6, difficulty: 3, index: 32)
              as GeneratedItem;
      final containing =
          MentalArithmeticEngine.problemOf(item).containingIndices.toList()
            ..sort();

      final result = engine.score(item, Answer.multiSelect(containing));

      expect(result.correct, isTrue);
      expect(result.metrics['precision'], 1.0);
      expect(result.metrics['recall'], 1.0);
    });

    test('a wrong selection scores incorrect with partial metrics', () {
      final item =
          engine.generate(params: params, seed: 6, difficulty: 3, index: 32)
              as GeneratedItem;
      final problem = MentalArithmeticEngine.problemOf(item);
      final containing = problem.containingIndices;
      if (containing.isEmpty) return; // guarded by the generator invariant
      final allIndices = List<int>.generate(problem.intervals.length, (i) => i);
      final excluded = allIndices.firstWhere((i) => !containing.contains(i));
      final selection = [containing.first, excluded];

      final result = engine.score(item, Answer.multiSelect(selection));

      expect(result.correct, isFalse);
      expect(result.metrics['selectedCount'], 2.0);
    });

    test('a timeout answer is a timeout, never scored', () {
      final item =
          engine.generate(params: params, seed: 6, difficulty: 3, index: 32)
              as GeneratedItem;
      final result = engine.score(item, const Answer.timeout());
      expect(result.timedOut, isTrue);
    });

    test('an answer of the wrong kind is simply wrong', () {
      final item =
          engine.generate(params: params, seed: 6, difficulty: 3, index: 32)
              as GeneratedItem;
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
    });
  });
}
