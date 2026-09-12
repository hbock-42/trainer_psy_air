import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_engine.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_scoring.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = MultitaskEngine();
  const params = MultitaskParams(durationSec: 10);

  test('familyId and generatorId', () {
    expect(engine.familyId, 'multitask_psychomotor');
    expect(engine.generatorId, GeneratorId.multitask);
  });

  test('generate is deterministic and stamps the recipe on the item', () {
    final a = engine.generate(params: params, seed: 7, difficulty: 3);
    final b = engine.generate(params: params, seed: 7, difficulty: 3);
    expect(a, isA<GeneratedItem>());
    final gen = a as GeneratedItem;
    expect(gen.id, 'gen.multitask.7');
    expect(gen.familyId, 'multitask_psychomotor');
    expect(gen.seed, 7);
    expect(gen.difficulty, 3);
    expect(gen.params, params);
    expect((b as GeneratedItem).id, gen.id);
  });

  test('a different seed yields a different item id', () {
    final a = engine.generate(params: params, seed: 1, difficulty: 3);
    final b = engine.generate(params: params, seed: 2, difficulty: 3);
    expect(a.id, isNot(b.id));
  });

  test('score: a raw answer with a correct combined score is right', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    const metrics = MultitaskMetrics(
      totalMs: 10000,
      trackingErrorMs: 0,
      shapeHits: 5,
      shapeMisses: 0,
      shapeFalseAlarms: 0,
      calcHits: 5,
      calcMisses: 0,
      calcFalseAlarms: 0,
    );
    final result = engine.score(item, Answer.raw(metrics.toPayload()));
    expect(result.correct, isTrue);
    expect(result.metrics[MultitaskMetricKeys.combinedScore], 1.0);
  });

  test('score: a raw answer below the threshold is wrong', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    const metrics = MultitaskMetrics(
      totalMs: 10000,
      trackingErrorMs: 10000,
      shapeHits: 0,
      shapeMisses: 5,
      shapeFalseAlarms: 0,
      calcHits: 0,
      calcMisses: 5,
      calcFalseAlarms: 0,
    );
    final result = engine.score(item, Answer.raw(metrics.toPayload()));
    expect(result.correct, isFalse);
  });

  test('score: a skip answer is a skip, not wrong', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    final result = engine.score(item, const Answer.skip());
    expect(result.correct, isFalse);
    expect(result.skipped, isTrue);
  });

  test('score: anything else is wrong', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    final result = engine.score(item, const Answer.choice(0));
    expect(result.correct, isFalse);
    expect(result.skipped, isFalse);
  });
}
