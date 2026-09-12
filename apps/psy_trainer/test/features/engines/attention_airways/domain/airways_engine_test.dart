import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/attention_airways/domain/airways_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = AirwaysEngine();
  const params = AirwaysParams();

  test('familyId and generatorId match the family/blueprint', () {
    expect(engine.familyId, 'attention_airways');
    expect(engine.generatorId, GeneratorId.airways);
  });

  test('generate is deterministic: same inputs, same item', () {
    final a = engine.generate(
      params: params,
      seed: 123,
      difficulty: 3,
    ) as GeneratedItem;
    final b = engine.generate(
      params: params,
      seed: 123,
      difficulty: 3,
    ) as GeneratedItem;
    expect(a.id, b.id);
    expect(a.seed, b.seed);
    expect(a.difficulty, b.difficulty);
    expect(a.params, b.params);
    expect(a.id, ActivityEngine.generatedItemId(GeneratorId.airways, 123));
  });

  test('a different seed yields a different item id', () {
    final a = engine.generate(params: params, seed: 1, difficulty: 3);
    final b = engine.generate(params: params, seed: 2, difficulty: 3);
    expect(a.id, isNot(b.id));
  });

  test('score is correct iff violations == 0, and carries the metrics', () {
    final item = engine.generate(params: params, seed: 5, difficulty: 3);

    final clean = engine.score(
      item,
      const Answer.raw({'violations': 0, 'reroutes': 2, 'survivedMs': 30000}),
    );
    expect(clean.correct, isTrue);
    expect(clean.metrics, {
      'violations': 0,
      'reroutes': 2,
      'survivedMs': 30000,
    });

    final crashed = engine.score(
      item,
      const Answer.raw({'violations': 3, 'reroutes': 1, 'survivedMs': 30000}),
    );
    expect(crashed.correct, isFalse);
    expect(crashed.metrics['violations'], 3);
  });

  test('a skip answer scores as skipped', () {
    final item = engine.generate(params: params, seed: 5, difficulty: 3);
    final result = engine.score(item, const Answer.skip());
    expect(result.skipped, isTrue);
    expect(result.correct, isFalse);
  });

  test('an answer of the wrong kind is simply wrong', () {
    final item = engine.generate(params: params, seed: 5, difficulty: 3);
    final result = engine.score(item, const Answer.choice(0));
    expect(result.correct, isFalse);
  });
}
