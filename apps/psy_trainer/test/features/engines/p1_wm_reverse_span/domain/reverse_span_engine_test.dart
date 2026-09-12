import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_wm_reverse_span/domain/reverse_span_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = ReverseSpanEngine();
  const params = P1WmReverseSpanParams();

  group('generate', () {
    test('is deterministic: same seed/difficulty/params, same digits', () {
      final a = engine.generate(
        params: params,
        seed: 42,
        difficulty: 3,
        runSeed: 42,
      );
      final b = engine.generate(
        params: params,
        seed: 42,
        difficulty: 3,
        runSeed: 42,
      );
      final sequenceA = ReverseSpanEngine.sequenceOf(a as GeneratedItem);
      final sequenceB = ReverseSpanEngine.sequenceOf(b as GeneratedItem);
      expect(sequenceA.digits, sequenceB.digits);
    });

    test('a different seed yields a different sequence (overwhelmingly)', () {
      final a =
          engine.generate(params: params, seed: 1, difficulty: 3)
              as GeneratedItem;
      final b =
          engine.generate(params: params, seed: 2, difficulty: 3)
              as GeneratedItem;
      expect(
        ReverseSpanEngine.sequenceOf(a).digits,
        isNot(ReverseSpanEngine.sequenceOf(b).digits),
      );
    });

    test('stores origin with runSeed/index, defaulting runSeed to seed', () {
      final withRun =
          engine.generate(
                params: params,
                seed: 7,
                difficulty: 2,
                index: 3,
                runSeed: 99,
              )
              as GeneratedItem;
      expect(withRun.origin?.runSeed, 99);
      expect(withRun.origin?.index, 3);

      final direct =
          engine.generate(params: params, seed: 7, difficulty: 2)
              as GeneratedItem;
      expect(direct.origin?.runSeed, 7);
      expect(direct.origin?.index, 0);
    });

    test('the item id follows the gen.<generatorId>.<seed> convention', () {
      final item =
          engine.generate(params: params, seed: 123, difficulty: 1)
              as GeneratedItem;
      expect(item.id, 'gen.p1_wm_reverse_span.123');
    });
  });

  group('lengthForDifficulty', () {
    test('maps the 1..5 adaptive level onto [minDigits, maxDigits]', () {
      expect(ReverseSpanEngine.lengthForDifficulty(1, params), 4);
      expect(ReverseSpanEngine.lengthForDifficulty(5, params), 9);
      // Monotonic and always within bounds across the whole range.
      var previous = 0;
      for (var level = 1; level <= 5; level++) {
        final length = ReverseSpanEngine.lengthForDifficulty(level, params);
        expect(length, inInclusiveRange(params.minDigits, params.maxDigits));
        expect(length, greaterThanOrEqualTo(previous));
        previous = length;
      }
    });

    test('clamps an out-of-1..5 difficulty instead of throwing', () {
      expect(ReverseSpanEngine.lengthForDifficulty(0, params), 4);
      expect(ReverseSpanEngine.lengthForDifficulty(9, params), 9);
    });

    test('collapses to minDigits when maxDigits <= minDigits', () {
      const degenerate = P1WmReverseSpanParams(minDigits: 5, maxDigits: 5);
      expect(ReverseSpanEngine.lengthForDifficulty(3, degenerate), 5);
    });
  });

  group('score', () {
    GeneratedItem itemAt({int seed = 5, int difficulty = 1}) =>
        engine.generate(params: params, seed: seed, difficulty: difficulty)
            as GeneratedItem;

    test('the exact reverse of the shown digits is correct', () {
      final item = itemAt();
      final digits = ReverseSpanEngine.sequenceOf(item).digits;
      final result = engine.score(
        item,
        Answer.sequence(ReverseSpanEngine.sequenceOf(item).expectedReverse),
      );
      expect(result.correct, isTrue);
      expect(
        result.metrics[ReverseSpanMetrics.correctAtLength(digits.length)],
        1,
      );
      expect(
        result.metrics[ReverseSpanMetrics.attemptsAtLength(digits.length)],
        1,
      );
    });

    test('the forward order (not reversed) is wrong', () {
      final item = itemAt();
      final forward = [
        for (final digit in ReverseSpanEngine.sequenceOf(item).digits) '$digit',
      ];
      // Only wrong when the sequence is not a palindrome.
      if (forward.length > 1) {
        final result = engine.score(item, Answer.sequence(forward));
        if (forward.reversed.toList().toString() != forward.toString()) {
          expect(result.correct, isFalse);
        }
      }
    });

    test('a wrong-length answer is wrong', () {
      final item = itemAt();
      final result = engine.score(item, const Answer.sequence(['1']));
      expect(result.correct, isFalse);
    });

    test('a non-sequence answer is wrong', () {
      final item = itemAt();
      final result = engine.score(item, const Answer.numeric(0));
      expect(result.correct, isFalse);
    });
  });

  group('reverseSpanMaxReached', () {
    test('picks the longest length with at least one correct recall', () {
      final totals = <String, num>{
        ReverseSpanMetrics.attemptsAtLength(4): 3,
        ReverseSpanMetrics.correctAtLength(4): 2,
        ReverseSpanMetrics.attemptsAtLength(6): 2,
        ReverseSpanMetrics.correctAtLength(6): 1,
        ReverseSpanMetrics.attemptsAtLength(7): 1,
        ReverseSpanMetrics.correctAtLength(7): 0,
      };
      expect(reverseSpanMaxReached(totals), 6);
    });

    test('is null when nothing was ever correct', () {
      final totals = <String, num>{
        ReverseSpanMetrics.attemptsAtLength(4): 2,
        ReverseSpanMetrics.correctAtLength(4): 0,
      };
      expect(reverseSpanMaxReached(totals), isNull);
    });

    test('is null on an empty map', () {
      expect(reverseSpanMaxReached(const {}), isNull);
    });
  });
}
