import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_wm_calc_back/domain/calc_back_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = CalcBackEngine();
  const params = P1WmCalcBackParams(calcsPerStage: 5);
  const runSeed = 2026;

  /// Materialises item [index] of one continuous run, the way
  /// `ItemSource.generator`/`ItemSource.adaptive` actually call `generate`
  /// (same `runSeed` every item, its own `index`).
  GeneratedItem itemAt(int index, {int difficulty = 3}) =>
      engine.generate(
            params: params,
            seed: runSeed + index,
            difficulty: difficulty,
            index: index,
            runSeed: runSeed,
          )
          as GeneratedItem;

  group('CalcBackChain.stageOf', () {
    test('groups the run into calcsPerStage-sized, 1-based stages', () {
      expect(CalcBackChain.stageOf(0, calcsPerStage: 5, stageCount: 4), 1);
      expect(CalcBackChain.stageOf(4, calcsPerStage: 5, stageCount: 4), 1);
      expect(CalcBackChain.stageOf(5, calcsPerStage: 5, stageCount: 4), 2);
      expect(CalcBackChain.stageOf(19, calcsPerStage: 5, stageCount: 4), 4);
    });

    test(
      'clamps to stageCount for a run longer than stageCount*calcsPerStage',
      () {
        expect(CalcBackChain.stageOf(100, calcsPerStage: 5, stageCount: 4), 4);
      },
    );
  });

  group('the chain', () {
    test('is deterministic: same params/runSeed, same chain up to index', () {
      final chainA = CalcBackChain.build(params, runSeed, upTo: 10);
      final chainB = CalcBackChain.build(params, runSeed, upTo: 10);
      for (var i = 0; i < 10; i++) {
        expect(chainA.steps[i].result, chainB.steps[i].result);
        expect(chainA.steps[i].operand, chainB.steps[i].operand);
        expect(chainA.steps[i].op, chainB.steps[i].op);
      }
    });

    test('a longer upTo does not change the results of earlier positions', () {
      final short = CalcBackChain.build(params, runSeed, upTo: 3);
      final long = CalcBackChain.build(params, runSeed, upTo: 12);
      for (var i = 0; i < 3; i++) {
        expect(long.steps[i].result, short.steps[i].result);
      }
    });

    test('item 0 (stage 1) has no back-reference: chained from baseline 0', () {
      final chain = CalcBackChain.build(params, runSeed, upTo: 1);
      final step0 = chain.steps[0];
      expect(step0.backIndex, -1);
      expect(step0.backValue, 0);
      expect(step0.result, step0.op.apply(step0.operand, 0));
    });

    test('a later step chains from the result stage positions back', () {
      final chain = CalcBackChain.build(params, runSeed, upTo: 10);
      for (final step in chain.steps) {
        if (step.backIndex < 0) continue;
        expect(step.backValue, chain.steps[step.backIndex].result);
        final expected = step.op
            .apply(step.operand, step.backValue)
            .clamp(CalcBackChain.resultFloor, CalcBackChain.resultCeiling);
        expect(step.result, expected);
      }
    });

    test('results stay within the clamped range over many steps', () {
      final chain = CalcBackChain.build(params, runSeed, upTo: 40);
      for (final step in chain.steps) {
        expect(
          step.result,
          inInclusiveRange(
            CalcBackChain.resultFloor,
            CalcBackChain.resultCeiling,
          ),
        );
      }
    });
  });

  group('generate + score', () {
    test('generate is deterministic for the same (seed, index, runSeed)', () {
      final a = itemAt(3);
      final b = itemAt(3);
      expect(CalcBackEngine.stepOf(a).result, CalcBackEngine.stepOf(b).result);
    });

    test('scores correct exactly when the answer is the chained result', () {
      for (var i = 0; i < 12; i++) {
        final item = itemAt(i);
        final step = CalcBackEngine.stepOf(item);
        final right = engine.score(item, Answer.numeric(step.result));
        expect(right.correct, isTrue, reason: 'index $i');
        final wrong = engine.score(item, Answer.numeric(step.result + 1));
        expect(wrong.correct, isFalse, reason: 'index $i');
      }
    });

    test('a non-numeric answer is wrong', () {
      final item = itemAt(0);
      final result = engine.score(item, const Answer.sequence(['1']));
      expect(result.correct, isFalse);
    });

    test('metrics are decomposed per stage', () {
      // index 0 -> stage 1, index 5 -> stage 2 (calcsPerStage: 5).
      final stage1Item = itemAt(0);
      final stage2Item = itemAt(5);
      final stage1Step = CalcBackEngine.stepOf(stage1Item);
      final stage2Step = CalcBackEngine.stepOf(stage2Item);
      expect(stage1Step.stage, 1);
      expect(stage2Step.stage, 2);

      final resultStage1 = engine.score(
        stage1Item,
        Answer.numeric(stage1Step.result),
      );
      expect(resultStage1.metrics[CalcBackMetrics.correctAtStage(1)], 1);
      expect(resultStage1.metrics[CalcBackMetrics.attemptsAtStage(1)], 1);

      final resultStage2 = engine.score(
        stage2Item,
        Answer.numeric(stage2Step.result + 1),
      );
      expect(resultStage2.metrics[CalcBackMetrics.correctAtStage(2)], isNull);
      expect(resultStage2.metrics[CalcBackMetrics.attemptsAtStage(2)], 1);
    });

    test('the item id follows the gen.<generatorId>.<seed> convention', () {
      final item = itemAt(0);
      expect(item.id, 'gen.p1_wm_calc_back.${runSeed + 0}');
    });
  });
}
