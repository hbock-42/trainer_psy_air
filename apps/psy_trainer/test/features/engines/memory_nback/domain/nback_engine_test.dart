import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_engine.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_stimulus.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = NbackEngine();
  const params = NbackParams(primers: 0);

  // Found by scanning seeds 0..N against `NbackStimulus.decode` with these
  // params (see the story's report): stable as long as the generator's
  // logic does not change the roll thresholds.
  const fillerSeed = 0;
  const targetSeed = 1;
  const lureSeed = 11;
  const primerSeed = 1; // with `NbackParams(count: 10, primers: 5)` below.

  group('generate', () {
    test('familyId and generatorId', () {
      expect(engine.familyId, 'memory_nback');
      expect(engine.generatorId, GeneratorId.nback);
    });

    test(
      'is deterministic: same (params, seed, difficulty) gives the same item',
      () {
        final a = engine.generate(params: params, seed: 123, difficulty: 3);
        final b = engine.generate(params: params, seed: 123, difficulty: 3);
        expect(a, b);
      },
    );

    test('returns a GeneratedItem with the conventional id and origin', () {
      final item =
          engine.generate(params: params, seed: 55, difficulty: 3)
              as GeneratedItem;
      expect(item.id, 'gen.nback.55');
      expect(item.generatorId, GeneratorId.nback);
      expect(item.seed, 55);
      expect(
        item.origin,
        const ItemOrigin(generatorId: GeneratorId.nback, seed: 55),
      );
      expect(item.params, params);
    });
  });

  group('score', () {
    GeneratedItem itemFor(int seed) =>
        engine.generate(params: params, seed: seed, difficulty: 3)
            as GeneratedItem;

    test('a primer is always correct, whatever the answer', () {
      const primerParams = NbackParams(count: 10, primers: 5);
      final item =
          engine.generate(params: primerParams, seed: primerSeed, difficulty: 3)
              as GeneratedItem;
      expect(NbackEngine.stimulusOf(item).isPrimer, isTrue);

      final onYes = engine.score(item, NbackAnswer.yes);
      final onNo = engine.score(item, NbackAnswer.no);
      expect(onYes.correct, isTrue);
      expect(onNo.correct, isTrue);
      expect(onYes.metrics[NbackMetrics.primers], 1);
    });

    test('answering yes on a target is a hit', () {
      final item = itemFor(targetSeed);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.target);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.hits], 1);
      expect(result.metrics[NbackMetrics.misses], 0);
    });

    test('answering no on a target is a miss', () {
      final item = itemFor(targetSeed);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.misses], 1);
      expect(result.metrics[NbackMetrics.hits], 0);
    });

    test('answering yes on a filler is a false alarm', () {
      final item = itemFor(fillerSeed);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.filler);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.falseAlarms], 1);
    });

    test('answering no on a filler is a correct rejection', () {
      final item = itemFor(fillerSeed);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.correctRejections], 1);
    });

    test('answering no on a lure is a correct rejection', () {
      final item = itemFor(lureSeed);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.lure);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.correctRejections], 1);
    });

    test('answering yes on a lure is a false alarm', () {
      final item = itemFor(lureSeed);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.falseAlarms], 1);
    });

    test('an answer of the wrong kind is wrong, not a crash', () {
      final item = itemFor(fillerSeed);
      final result = engine.score(item, const Answer.choice(0));
      expect(result.correct, isFalse);
    });
  });

  group('NbackAnswer.isYes', () {
    test('reads the engine key tokens', () {
      expect(NbackAnswer.isYes(NbackAnswer.yes), isTrue);
      expect(NbackAnswer.isYes(NbackAnswer.no), isFalse);
      expect(NbackAnswer.isYes(const Answer.key('maybe')), isNull);
      expect(NbackAnswer.isYes(const Answer.choice(0)), isNull);
    });
  });
}
