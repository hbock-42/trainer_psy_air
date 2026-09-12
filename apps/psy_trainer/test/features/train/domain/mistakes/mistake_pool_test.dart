import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/model/attempt.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/domain/mistakes/mistake_pool.dart';

import '../../../../helpers/fake_engine.dart';

void main() {
  ItemOutcome outcomeOf({
    required int index,
    required Item item,
    required ItemResult result,
  }) => ItemOutcome(
    index: index,
    item: item,
    answer: const Answer.choice(0),
    result: result,
    responseMs: 500,
  );

  Attempt attemptOf({
    required int position,
    required bool isCorrect,
    String? itemId,
    AttemptOrigin? origin,
    DateTime? at,
  }) => Attempt(
    id: 'attempt-$position',
    sessionId: 'session-1',
    familyId: 'fake_family',
    itemId: itemId,
    origin: origin,
    isCorrect: isCorrect,
    responseMs: 500,
    position: position,
    answeredAt: at ?? DateTime.utc(2026, 9).add(Duration(minutes: position)),
  );

  group('MistakePool.fromSessionOutcomes', () {
    test(
      'keeps wrong, timed-out and skipped bank items; drops correct ones',
      () {
        final outcomes = [
          outcomeOf(
            index: 0,
            item: fakeMcq(id: 'q1'),
            result: ItemResult.right,
          ),
          outcomeOf(
            index: 1,
            item: fakeMcq(id: 'q2'),
            result: ItemResult.wrong,
          ),
          outcomeOf(
            index: 2,
            item: fakeMcq(id: 'q3'),
            result: ItemResult.timeout,
          ),
          outcomeOf(
            index: 3,
            item: fakeMcq(id: 'q4'),
            result: ItemResult.skip,
          ),
        ];

        final pool = MistakePool.fromSessionOutcomes(outcomes);

        expect(pool.bankItemIds, ['q2', 'q3', 'q4']);
        expect(pool.generatedOrigins, isEmpty);
      },
    );

    test('builds a replayable origin for a wrong generated item', () {
      final item = fakeMcq(
        id: 'gen.dominos.42',
        difficulty: 4,
        origin: const ItemOrigin(generatorId: GeneratorId.dominos, seed: 42),
      );
      final outcomes = [
        outcomeOf(index: 0, item: item, result: ItemResult.wrong),
      ];

      final pool = MistakePool.fromSessionOutcomes(
        outcomes,
        sessionParams: const GeneratorParams.dominos(length: 5),
      );

      expect(pool.bankItemIds, isEmpty);
      expect(pool.generatedOrigins, [
        AttemptOrigin(
          generatorId: 'dominos',
          seed: 42,
          params: generatorParamsToJson(
            const GeneratorParams.dominos(length: 5),
          ),
          difficulty: 4,
        ),
      ]);
    });

    test('dedupes repeated items (same key kept once)', () {
      final outcomes = [
        outcomeOf(
          index: 0,
          item: fakeMcq(id: 'q1'),
          result: ItemResult.wrong,
        ),
        outcomeOf(
          index: 1,
          item: fakeMcq(id: 'q1'),
          result: ItemResult.wrong,
        ),
      ];

      expect(MistakePool.fromSessionOutcomes(outcomes).length, 1);
    });
  });

  group('MistakePool.fromFamilyHistory', () {
    test('an item never failed is not in the pool', () {
      final attempts = [
        attemptOf(position: 0, itemId: 'q1', isCorrect: true),
        attemptOf(position: 1, itemId: 'q1', isCorrect: true),
      ];

      expect(MistakePool.fromFamilyHistory(attempts).isEmpty, isTrue);
    });

    test('a failed item with fewer than 2 trailing corrects stays in', () {
      final onlyWrong = [
        attemptOf(position: 0, itemId: 'q1', isCorrect: false),
      ];
      expect(MistakePool.fromFamilyHistory(onlyWrong).bankItemIds, ['q1']);

      final oneCorrectSince = [
        attemptOf(position: 0, itemId: 'q1', isCorrect: false),
        attemptOf(position: 1, itemId: 'q1', isCorrect: true),
      ];
      expect(MistakePool.fromFamilyHistory(oneCorrectSince).bankItemIds, [
        'q1',
      ]);
    });

    test('2 consecutive correct answers clear the item from the pool', () {
      final attempts = [
        attemptOf(position: 0, itemId: 'q1', isCorrect: false),
        attemptOf(position: 1, itemId: 'q1', isCorrect: true),
        attemptOf(position: 2, itemId: 'q1', isCorrect: true),
      ];

      expect(MistakePool.fromFamilyHistory(attempts).isEmpty, isTrue);
    });

    test('a wrong answer resets the streak: 1 correct, 1 wrong, 1 correct '
        'is still in the pool', () {
      final attempts = [
        attemptOf(position: 0, itemId: 'q1', isCorrect: false),
        attemptOf(position: 1, itemId: 'q1', isCorrect: true),
        attemptOf(position: 2, itemId: 'q1', isCorrect: false),
        attemptOf(position: 3, itemId: 'q1', isCorrect: true),
      ];

      expect(MistakePool.fromFamilyHistory(attempts).bankItemIds, ['q1']);
    });

    test('keeps a generated item by its origin, difficulty included', () {
      const origin = AttemptOrigin(
        generatorId: 'dominos',
        seed: 7,
        params: {'length': 5},
        difficulty: 2,
      );
      final attempts = [
        attemptOf(position: 0, origin: origin, isCorrect: false),
      ];

      final pool = MistakePool.fromFamilyHistory(attempts);
      expect(pool.generatedOrigins, [origin]);
    });

    test('orders entries by most recent activity first', () {
      final attempts = [
        attemptOf(position: 0, itemId: 'old', isCorrect: false),
        attemptOf(position: 1, itemId: 'new', isCorrect: false),
      ];

      expect(MistakePool.fromFamilyHistory(attempts).bankItemIds, [
        'new',
        'old',
      ]);
    });
  });

  group('MistakePool.capped', () {
    test('keeps at most count entries, in order', () {
      const pool = MistakePool([
        MistakeEntry.bank('a'),
        MistakeEntry.bank('b'),
        MistakeEntry.bank('c'),
      ]);

      expect(pool.capped(2).bankItemIds, ['a', 'b']);
      expect(pool.capped(10).bankItemIds, ['a', 'b', 'c']);
    });
  });
}
