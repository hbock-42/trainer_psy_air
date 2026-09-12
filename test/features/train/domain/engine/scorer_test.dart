import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../../helpers/fake_engine.dart';

void main() {
  final mcq = fakeMcq(id: 'm', correctIndex: 1);

  NumericItem numeric({Tolerance? tolerance}) => NumericItem(
    id: 'n',
    version: 1,
    familyId: 'planning_tubes',
    difficulty: 2,
    tags: const ['tubes'],
    stem: const LocalizedText(fr: 'Combien ?'),
    expected: 10,
    tolerance: tolerance,
    explanation: const LocalizedText(fr: 'Dix.'),
  );

  SequenceItem sequence(RecallMode mode) => SequenceItem(
    id: 's',
    version: 1,
    familyId: 'memory',
    difficulty: 2,
    tags: const ['seq'],
    stimulusKind: StimulusKind.digits,
    stimulus: const ['3', '1', '4'],
    recallMode: mode,
  );

  ItemOutcome outcome(int i, ItemResult result, {int ms = 1000}) => ItemOutcome(
    index: i,
    item: mcq,
    answer: result.timedOut ? const Answer.timeout() : const Answer.choice(0),
    result: result,
    responseMs: ms,
  );

  group('Scorer.scoreItem', () {
    test('MCQ: the correct index is right, another index wrong', () {
      expect(Scorer.scoreItem(mcq, const Answer.choice(1)), ItemResult.right);
      expect(Scorer.scoreItem(mcq, const Answer.choice(0)), ItemResult.wrong);
    });

    test('an answer of the wrong kind is wrong', () {
      expect(Scorer.scoreItem(mcq, const Answer.numeric(1)), ItemResult.wrong);
      expect(
        Scorer.scoreItem(numeric(), const Answer.choice(1)),
        ItemResult.wrong,
      );
    });

    test('skip and timeout are flagged on any item', () {
      expect(Scorer.scoreItem(mcq, const Answer.skip()), ItemResult.skip);
      expect(outcome(0, ItemResult.skip).isSkipped, isTrue);
      expect(outcome(0, ItemResult.right).isSkipped, isFalse);
      expect(Scorer.scoreItem(mcq, const Answer.timeout()), ItemResult.timeout);
      expect(Scorer.scoreItem(mcq, const Answer.skip()).isError, isTrue);
    });

    test('numeric: exact without tolerance', () {
      expect(
        Scorer.scoreItem(numeric(), const Answer.numeric(10)),
        ItemResult.right,
      );
      expect(
        Scorer.scoreItem(numeric(), const Answer.numeric(10.5)),
        ItemResult.wrong,
      );
    });

    test('numeric: absolute and relative tolerance', () {
      final abs = numeric(
        tolerance: const Tolerance(mode: ToleranceMode.absolute, value: 1),
      );
      expect(Scorer.scoreItem(abs, const Answer.numeric(11)), ItemResult.right);
      expect(
        Scorer.scoreItem(abs, const Answer.numeric(11.5)),
        ItemResult.wrong,
      );
      final rel = numeric(
        tolerance: const Tolerance(mode: ToleranceMode.relative, value: 0.1),
      );
      expect(Scorer.scoreItem(rel, const Answer.numeric(9)), ItemResult.right);
      expect(Scorer.scoreItem(rel, const Answer.numeric(8)), ItemResult.wrong);
    });

    test('sequence: forward, backward and any order', () {
      expect(
        Scorer.scoreItem(
          sequence(RecallMode.forward),
          const Answer.sequence(['3', '1', '4']),
        ),
        ItemResult.right,
      );
      expect(
        Scorer.scoreItem(
          sequence(RecallMode.forward),
          const Answer.sequence(['4', '1', '3']),
        ),
        ItemResult.wrong,
      );
      expect(
        Scorer.scoreItem(
          sequence(RecallMode.backward),
          const Answer.sequence(['4', '1', '3']),
        ),
        ItemResult.right,
      );
      expect(
        Scorer.scoreItem(
          sequence(RecallMode.anyOrder),
          const Answer.sequence(['1', '4', '3']),
        ),
        ItemResult.right,
      );
      expect(
        Scorer.scoreItem(
          sequence(RecallMode.anyOrder),
          const Answer.sequence(['1', '4']),
        ),
        ItemResult.wrong,
      );
    });

    test('a generated recipe is never right by default', () {
      const recipe = GeneratedItem(
        id: 'g',
        version: 1,
        familyId: 'logic_dominos',
        difficulty: 3,
        tags: ['dominos'],
        generatorId: GeneratorId.dominos,
        seed: 7,
        params: GeneratorParams.dominos(),
      );
      expect(
        Scorer.scoreItem(recipe, const Answer.choice(0)),
        ItemResult.wrong,
      );
    });
  });

  group('Scorer.section', () {
    test('an empty section has zero accuracy and null response times', () {
      final result = Scorer.section(const [], itemCount: 5);
      expect(result.itemCount, 5);
      expect(result.played, 0);
      expect(result.unplayed, 5);
      expect(result.accuracy, 0);
      expect(result.meanResponseMs, isNull);
      expect(result.medianResponseMs, isNull);
      expect(result.points, 0);
      expect(result.maxPoints, 5);
      expect(result.pointsFraction, 0);
    });

    test('counts outcomes and averages answered response times', () {
      final result = Scorer.section([
        outcome(0, ItemResult.right),
        outcome(1, ItemResult.wrong, ms: 3000),
        outcome(2, ItemResult.timeout, ms: 5000),
        outcome(3, ItemResult.skip, ms: 2000),
        outcome(4, ItemResult.right, ms: 4000),
      ], itemCount: 6);
      expect(result.played, 5);
      expect(result.unplayed, 1);
      expect(result.correct, 2);
      expect(result.wrong, 1);
      expect(result.timeouts, 1);
      expect(result.skipped, 1);
      expect(result.accuracy, 0.4);
      // Timeouts are excluded from RT: 1000, 3000, 2000, 4000.
      expect(result.meanResponseMs, 2500);
      expect(result.medianResponseMs, 2500);
    });

    test('the median of an odd count is the middle value', () {
      final result = Scorer.section([
        outcome(0, ItemResult.right, ms: 100),
        outcome(1, ItemResult.right, ms: 900),
        outcome(2, ItemResult.right, ms: 300),
      ], itemCount: 3);
      expect(result.medianResponseMs, 300);
    });

    test('applies the scoring policy with negative marking', () {
      const policy = ScoringPolicy(correct: 3, wrong: -1);
      final result = Scorer.section(
        [
          outcome(0, ItemResult.right),
          outcome(1, ItemResult.wrong),
          outcome(2, ItemResult.timeout),
          outcome(3, ItemResult.skip),
        ],
        itemCount: 4,
        policy: policy,
      );
      expect(result.points, 3 - 1 - 1 + 0);
      expect(result.maxPoints, 12);
      expect(result.scoringPolicy, policy);
      expect(result.pointsFraction, closeTo(1 / 12, 1e-9));
    });

    test('negative totals clamp the points fraction at zero', () {
      final result = Scorer.section(
        [outcome(0, ItemResult.wrong), outcome(1, ItemResult.wrong)],
        itemCount: 2,
        policy: const ScoringPolicy(correct: 3, wrong: -1),
      );
      expect(result.points, -2);
      expect(result.pointsFraction, 0);
    });

    test('sums engine metrics across outcomes', () {
      final result = Scorer.section([
        outcome(
          0,
          const ItemResult(correct: true, metrics: {'hits': 1, 'rt': 200}),
        ),
        outcome(
          1,
          const ItemResult(correct: false, metrics: {'misses': 1, 'rt': 100}),
        ),
      ], itemCount: 2);
      expect(result.metricTotals, {'hits': 1, 'misses': 1, 'rt': 300});
    });
  });
}
