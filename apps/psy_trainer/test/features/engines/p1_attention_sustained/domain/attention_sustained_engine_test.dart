import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/domain/attention_sustained_engine.dart';
import 'package:psy_trainer/features/engines/p1_attention_sustained/domain/attention_sustained_stimulus.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = AttentionSustainedEngine();

  // Found by scanning `AttentionSeries.build(params, runSeed, 0)` with
  // `itemsPerSeries: 5`: runSeed 13 draws the `conjunction` rule (target
  // circle/yellow) and its series (a single, self-contained stream -- see
  // `AttentionSeries`'s doc) rolls filler, lure, target, filler, filler, in
  // that order.
  const params = P1AttentionSustainedParams();
  const runSeed = 13;

  GeneratedItem itemAt(int index) =>
      engine.generate(
            params: params,
            seed: 1000 + index,
            difficulty: 2,
            index: index,
            runSeed: runSeed,
          )
          as GeneratedItem;

  group('generate', () {
    test('familyId and generatorId', () {
      expect(engine.familyId, 'p1_attention_sustained');
      expect(engine.generatorId, GeneratorId.p1AttentionSustained);
    });

    test('is deterministic: same (params, seed, index, runSeed) gives the '
        'same item', () {
      final a = engine.generate(
        params: params,
        seed: 7,
        difficulty: 2,
        index: 2,
        runSeed: runSeed,
      );
      final b = engine.generate(
        params: params,
        seed: 7,
        difficulty: 2,
        index: 2,
        runSeed: runSeed,
      );
      expect(a, b);
    });

    test('returns a GeneratedItem with the conventional id and origin', () {
      final item = itemAt(2);
      expect(item.id, 'gen.p1_attention_sustained.1002');
      expect(item.generatorId, GeneratorId.p1AttentionSustained);
      expect(
        item.origin,
        const ItemOrigin(
          generatorId: GeneratorId.p1AttentionSustained,
          seed: 1002,
          runSeed: runSeed,
          index: 2,
        ),
      );
    });

    test('a direct call with no runSeed defaults it to seed, index to 0', () {
      final item =
          engine.generate(params: params, seed: 9, difficulty: 2)
              as GeneratedItem;
      expect(item.origin!.runSeed, 9);
      expect(item.origin!.index, 0);
    });
  });

  group('the series stream (found for runSeed 13)', () {
    test('rolls filler, lure, target, filler, filler', () {
      final roles = [
        for (var i = 0; i < 5; i++)
          AttentionSustainedEngine.stimulusOf(itemAt(i)).role,
      ];
      expect(roles, [
        AttentionRole.filler,
        AttentionRole.lure,
        AttentionRole.target,
        AttentionRole.filler,
        AttentionRole.filler,
      ]);
    });

    test('a lure shares exactly one attribute with the target', () {
      final target = AttentionSustainedEngine.stimulusOf(itemAt(2));
      final lure = AttentionSustainedEngine.stimulusOf(itemAt(1));
      final matchesShape = lure.shape == target.shape;
      final matchesColour = lure.colour == target.colour;
      expect(matchesShape ^ matchesColour, isTrue);
      expect(lure.isTarget, isFalse);
    });

    test('a filler shares neither attribute with the target', () {
      final target = AttentionSustainedEngine.stimulusOf(itemAt(2));
      final filler = AttentionSustainedEngine.stimulusOf(itemAt(0));
      expect(filler.shape, isNot(target.shape));
      expect(filler.colour, isNot(target.colour));
    });

    test('the rule is fixed across every item of the series', () {
      final seriesOfEachItem = [
        for (var i = 0; i < 5; i++)
          AttentionSustainedEngine.seriesOf(itemAt(i)),
      ];
      for (final oneItemsSeries in seriesOfEachItem) {
        expect(oneItemsSeries.ruleKind, series0.ruleKind);
        expect(oneItemsSeries.targetShape, series0.targetShape);
        expect(oneItemsSeries.targetColour, series0.targetColour);
      }
    });

    test('a different series of the same run draws its own rule', () {
      final nextSeries = AttentionSeries.build(params, runSeed, 1);
      final thisSeries = series0;
      expect(
        nextSeries.targetShape != thisSeries.targetShape ||
            nextSeries.targetColour != thisSeries.targetColour ||
            nextSeries.ruleKind != thisSeries.ruleKind,
        isTrue,
        reason: 'series 1 should not always echo series 0\'s rule',
      );
    });
  });

  group('score', () {
    test('a hit: target item, answered target', () {
      final result = engine.score(itemAt(2), AttentionAnswer.target);
      expect(result.correct, isTrue);
      expect(result.metrics[AttentionMetrics.hits], 1);
      expect(result.metrics[AttentionMetrics.misses], 0);
      expect(result.metrics[AttentionMetrics.falseAlarms], 0);
      expect(result.metrics[AttentionMetrics.correctRejections], 0);
    });

    test('a miss: target item, answered not-target', () {
      final result = engine.score(itemAt(2), AttentionAnswer.notTarget);
      expect(result.correct, isFalse);
      expect(result.metrics[AttentionMetrics.misses], 1);
      expect(result.metrics[AttentionMetrics.hits], 0);
    });

    test('a false alarm: non-target item, answered target', () {
      final result = engine.score(itemAt(0), AttentionAnswer.target);
      expect(result.correct, isFalse);
      expect(result.metrics[AttentionMetrics.falseAlarms], 1);
    });

    test('a correct rejection: non-target item, answered not-target', () {
      final result = engine.score(itemAt(0), AttentionAnswer.notTarget);
      expect(result.correct, isTrue);
      expect(result.metrics[AttentionMetrics.correctRejections], 1);
    });

    test('an unrecognised answer kind is simply wrong', () {
      final result = engine.score(itemAt(0), const Answer.skip());
      expect(result.correct, isFalse);
      expect(result.metrics[AttentionMetrics.hits], isNull);
    });

    test('buckets items into the first/last third of their series', () {
      // itemsPerSeries: 5 -> bucket = indexInSeries * 3 ~/ 5: 0,0,1,1,2.
      final first = engine.score(itemAt(0), AttentionAnswer.notTarget);
      expect(first.metrics[AttentionMetrics.firstThirdTotal], 1);
      expect(first.metrics[AttentionMetrics.firstThirdCorrect], 1);
      expect(
        first.metrics.containsKey(AttentionMetrics.lastThirdTotal),
        isFalse,
      );

      final middle = engine.score(itemAt(2), AttentionAnswer.notTarget);
      expect(
        middle.metrics.containsKey(AttentionMetrics.firstThirdTotal),
        isFalse,
      );
      expect(
        middle.metrics.containsKey(AttentionMetrics.lastThirdTotal),
        isFalse,
      );

      // Item 4 is a filler (see the series stream above): "not target" is
      // correct.
      final last = engine.score(itemAt(4), AttentionAnswer.notTarget);
      expect(last.metrics[AttentionMetrics.lastThirdTotal], 1);
      expect(last.metrics[AttentionMetrics.lastThirdCorrect], 1);
    });
  });

  group('attentionVigilanceDecrement', () {
    test('positive when the last third scored worse than the first', () {
      final decrement = attentionVigilanceDecrement(
        firstThirdTotal: 4,
        firstThirdCorrect: 4,
        lastThirdTotal: 4,
        lastThirdCorrect: 2,
      );
      expect(decrement, closeTo(0.5, 1e-9));
    });

    test('null when either third has no items', () {
      expect(
        attentionVigilanceDecrement(
          firstThirdTotal: 0,
          firstThirdCorrect: 0,
          lastThirdTotal: 4,
          lastThirdCorrect: 2,
        ),
        isNull,
      );
    });
  });
}

final AttentionSeries series0 = AttentionSeries.build(
  const P1AttentionSustainedParams(),
  13,
  0,
);
