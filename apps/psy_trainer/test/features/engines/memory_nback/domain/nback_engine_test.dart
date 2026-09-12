import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_engine.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_stimulus.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

void main() {
  const engine = NbackEngine();
  const params = NbackParams(count: 60);
  const runSeed = 123;

  /// The engine only ever sees the run through `(runSeed, index)`
  /// (US-037): find one index of each role once, from the same run every
  /// test in this file plays, and reuse it -- exactly what
  /// `ItemSource.generator` does when it calls `generate` for every
  /// position of a section.
  final sequence = NbackSequence.build(params, runSeed);
  final targetIndex = sequence.roles.indexOf(NbackRole.target, params.n);
  final lureIndex = sequence.roles.indexOf(NbackRole.lure, params.n);
  final fillerIndex = sequence.roles.indexOf(NbackRole.filler, params.n);

  GeneratedItem itemAt(int index) =>
      engine.generate(
            params: params,
            seed: 1000 + index,
            difficulty: 3,
            index: index,
            runSeed: runSeed,
          )
          as GeneratedItem;

  group('generate', () {
    test('familyId and generatorId', () {
      expect(engine.familyId, 'memory_nback');
      expect(engine.generatorId, GeneratorId.nback);
    });

    test('is deterministic: same (params, seed, index, runSeed) gives the '
        'same item', () {
      final a = engine.generate(
        params: params,
        seed: 55,
        difficulty: 3,
        index: 4,
        runSeed: runSeed,
      );
      final b = engine.generate(
        params: params,
        seed: 55,
        difficulty: 3,
        index: 4,
        runSeed: runSeed,
      );
      expect(a, b);
    });

    test('returns a GeneratedItem with the conventional id and origin', () {
      final item = itemAt(targetIndex);
      expect(item.id, 'gen.nback.${1000 + targetIndex}');
      expect(item.generatorId, GeneratorId.nback);
      expect(item.seed, 1000 + targetIndex);
      expect(item.origin!.runSeed, runSeed);
      expect(item.origin!.index, targetIndex);
      expect(item.params, params);
    });

    test('a direct call with no runSeed/index falls back to its own seed, '
        'index 0', () {
      final item =
          engine.generate(params: params, seed: 7, difficulty: 3)
              as GeneratedItem;
      expect(item.origin!.runSeed, 7);
      expect(item.origin!.index, 0);
      expect(NbackEngine.stimulusOf(item).isPrimer, isTrue);
    });
  });

  group('score', () {
    test('a primer is always correct, whatever the answer', () {
      final item = itemAt(0);
      expect(NbackEngine.stimulusOf(item).isPrimer, isTrue);

      final onYes = engine.score(item, NbackAnswer.yes);
      final onNo = engine.score(item, NbackAnswer.no);
      expect(onYes.correct, isTrue);
      expect(onNo.correct, isTrue);
      expect(onYes.metrics[NbackMetrics.primers], 1);
    });

    test('answering yes on a target is a hit', () {
      final item = itemAt(targetIndex);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.target);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.hits], 1);
      expect(result.metrics[NbackMetrics.misses], 0);
    });

    test('answering no on a target is a miss', () {
      final item = itemAt(targetIndex);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.misses], 1);
      expect(result.metrics[NbackMetrics.hits], 0);
    });

    test('answering yes on a filler is a false alarm', () {
      final item = itemAt(fillerIndex);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.filler);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.falseAlarms], 1);
    });

    test('answering no on a filler is a correct rejection', () {
      final item = itemAt(fillerIndex);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.correctRejections], 1);
    });

    test('answering no on a lure is a correct rejection', () {
      final item = itemAt(lureIndex);
      expect(NbackEngine.stimulusOf(item).role, NbackRole.lure);
      final result = engine.score(item, NbackAnswer.no);
      expect(result.correct, isTrue);
      expect(result.metrics[NbackMetrics.correctRejections], 1);
    });

    test('answering yes on a lure is a false alarm', () {
      final item = itemAt(lureIndex);
      final result = engine.score(item, NbackAnswer.yes);
      expect(result.correct, isFalse);
      expect(result.metrics[NbackMetrics.falseAlarms], 1);
    });

    test('an answer of the wrong kind is wrong, not a crash', () {
      final item = itemAt(fillerIndex);
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
