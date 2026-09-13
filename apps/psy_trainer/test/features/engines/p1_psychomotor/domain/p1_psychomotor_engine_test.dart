import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_channels.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_engine.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_scoring.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = P1PsychomotorEngine();
  const params = P1PsychomotorParams();

  test('familyId and generatorId', () {
    expect(engine.familyId, 'p1_psychomotor');
    expect(engine.generatorId, GeneratorId.p1Psychomotor);
  });

  test('generate is deterministic and stamps runSeed/index on origin', () {
    final a = engine.generate(
      params: params,
      seed: 7,
      difficulty: 3,
      index: 2,
      runSeed: 42,
    );
    final b = engine.generate(
      params: params,
      seed: 7,
      difficulty: 3,
      index: 2,
      runSeed: 42,
    );
    expect(a, isA<GeneratedItem>());
    final gen = a as GeneratedItem;
    expect(gen.id, 'gen.p1_psychomotor.7');
    expect(gen.familyId, 'p1_psychomotor');
    expect(gen.origin?.runSeed, 42);
    expect(gen.origin?.index, 2);
    expect((b as GeneratedItem).id, gen.id);
  });

  test('runSeed defaults to seed when not supplied', () {
    final item =
        engine.generate(params: params, seed: 5, difficulty: 3)
            as GeneratedItem;
    expect(item.origin?.runSeed, 5);
    expect(item.origin?.index, 0);
  });

  test('simulationOf rebuilds the same timeline from the item alone', () {
    final item =
        engine.generate(params: params, seed: 1, difficulty: 3, runSeed: 99)
            as GeneratedItem;
    final a = P1PsychomotorEngine.simulationOf(item);
    final b = P1PsychomotorEngine.simulationOf(item);
    expect(a.durationMs, b.durationMs);
    expect(a.targetPositionAt(1000), b.targetPositionAt(1000));
  });

  test('score: a raw answer with no red zone is correct', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    const metrics = P1PsychomotorMetrics(
      gaugesScore: 80,
      trackingScore: 70,
      lettersScore: 90,
      arithmeticScore: 100,
      combinedScore: 85,
      letterHits: 3,
      letterMisses: 0,
      letterFalseAlarms: 0,
      arithmeticCorrect: 2,
      arithmeticIncorrect: 0,
      arithmeticMissed: 0,
    );
    final result = engine.score(item, Answer.raw(metrics.toPayload()));
    expect(result.correct, isTrue);
    expect(result.metrics['isZeroed'], 0);
  });

  test('score: a raw answer that has been red-zoned is wrong', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    const metrics = P1PsychomotorMetrics(
      gaugesScore: 0,
      trackingScore: 70,
      lettersScore: 90,
      arithmeticScore: 100,
      combinedScore: 0,
      letterHits: 0,
      letterMisses: 0,
      letterFalseAlarms: 0,
      arithmeticCorrect: 0,
      arithmeticIncorrect: 0,
      arithmeticMissed: 0,
      redZoneChannel: P1PsychomotorChannel.gauges,
      redZoneAtMs: 12000,
    );
    final result = engine.score(item, Answer.raw(metrics.toPayload()));
    expect(result.correct, isFalse);
    expect(result.metrics['isZeroed'], 1);
  });

  test('score: a skip answer is scored as a skip', () {
    final item = engine.generate(params: params, seed: 1, difficulty: 3);
    final result = engine.score(item, const Answer.skip());
    expect(result.skipped, isTrue);
    expect(result.correct, isFalse);
  });
}
