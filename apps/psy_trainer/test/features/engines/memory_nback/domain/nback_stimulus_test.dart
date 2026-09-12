import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_stimulus.dart';

void main() {
  group('NbackSequence.build', () {
    test('is deterministic: same (params, runSeed) gives the same stream', () {
      const params = NbackParams();
      final a = NbackSequence.build(params, 42);
      final b = NbackSequence.build(params, 42);
      expect(a.values, b.values);
      expect(a.roles, b.roles);
    });

    test('a different runSeed can give a different stream', () {
      const params = NbackParams();
      final streams = {
        for (var seed = 0; seed < 20; seed++)
          seed: NbackSequence.build(params, seed).values.join(','),
      };
      expect(streams.values.toSet().length, greaterThan(1));
    });

    test('the first n items are primers', () {
      const params = NbackParams(n: 3, count: 20);
      final sequence = NbackSequence.build(params, 7);
      expect(sequence.roles.take(3), everyElement(NbackRole.primer));
      expect(sequence.roles.skip(3), isNot(contains(NbackRole.primer)));
    });

    test(
      'building only up to a given position yields a prefix of the full run',
      () {
        const params = NbackParams(count: 40);
        final full = NbackSequence.build(params, 99);
        final partial = NbackSequence.build(params, 99, upTo: 10);
        expect(partial.values, full.values.take(10).toList());
        expect(partial.roles, full.roles.take(10).toList());
      },
    );

    test('continuity: every non-primer item k answers "yes" iff it truly '
        'equals the value the run showed at k-n', () {
      const params = NbackParams(count: 200);
      for (var runSeed = 0; runSeed < 30; runSeed++) {
        final sequence = NbackSequence.build(params, runSeed);
        for (var k = params.n; k < params.count; k++) {
          final expectsYes = sequence.roles[k] == NbackRole.target;
          final actuallyEqual =
              sequence.values[k] == sequence.values[k - params.n];
          expect(
            expectsYes,
            actuallyEqual,
            reason:
                'runSeed=$runSeed k=$k values=${sequence.values[k]} vs '
                '${sequence.values[k - params.n]}',
          );
        }
      }
    });

    test('a lure never equals its own n-back reference', () {
      const params = NbackParams(count: 300);
      final sequence = NbackSequence.build(params, 5);
      for (var k = params.n; k < params.count; k++) {
        if (sequence.roles[k] != NbackRole.lure) continue;
        expect(sequence.values[k], isNot(sequence.values[k - params.n]));
      }
    });

    test('a filler never equals its own n-back reference', () {
      const params = NbackParams(count: 300);
      final sequence = NbackSequence.build(params, 5);
      for (var k = params.n; k < params.count; k++) {
        if (sequence.roles[k] != NbackRole.filler) continue;
        expect(sequence.values[k], isNot(sequence.values[k - params.n]));
      }
    });

    test('role proportions roughly match targetRatio and lureRatio', () {
      const params = NbackParams(count: 4000);
      final sequence = NbackSequence.build(params, 123);
      final rest = sequence.roles.skip(params.n);
      final total = rest.length;
      final targetShare =
          rest.where((r) => r == NbackRole.target).length / total;
      final lureShare = rest.where((r) => r == NbackRole.lure).length / total;
      expect(targetShare, closeTo(params.targetRatio, 0.03));
      expect(lureShare, closeTo(params.lureRatio, 0.03));
    });
  });

  group('NbackStimulus.decode', () {
    test('is deterministic: same (params, runSeed, index) gives the same '
        'stimulus', () {
      const params = NbackParams();
      final a = NbackStimulus.decode(params, 42, 5);
      final b = NbackStimulus.decode(params, 42, 5);
      expect(a.role, b.role);
      expect(a.value, b.value);
      expect(a.history, b.history);
    });

    test('matches the position of NbackSequence.build', () {
      const params = NbackParams(count: 30);
      final sequence = NbackSequence.build(params, 8);
      for (var index = 0; index < params.count; index++) {
        final stimulus = NbackStimulus.decode(params, 8, index);
        expect(stimulus.role, sequence.roles[index]);
        expect(stimulus.value, sequence.values[index]);
      }
    });

    test('history has n entries for a non-primer item', () {
      const params = NbackParams(n: 3, count: 20);
      final stimulus = NbackStimulus.decode(params, 7, 5);
      expect(stimulus.history, hasLength(3));
    });

    test('a target equals its own n-back reference (history.first)', () {
      const params = NbackParams(count: 60);
      for (var runSeed = 0; runSeed < 20; runSeed++) {
        for (var index = params.n; index < params.count; index++) {
          final stimulus = NbackStimulus.decode(params, runSeed, index);
          if (stimulus.role != NbackRole.target) continue;
          expect(stimulus.value, stimulus.history.first);
          expect(stimulus.expectsYes, isTrue);
        }
      }
    });

    test('a primer is never counted as a target', () {
      const params = NbackParams(count: 10);
      final primer = NbackStimulus.decode(params, 1, 0);
      expect(primer.isPrimer, isTrue);
      expect(primer.expectsYes, isFalse);
    });
  });

  group('nbackSensitivity', () {
    test('is (close to) zero at chance level', () {
      final d = nbackSensitivity(
        hits: 10,
        misses: 10,
        falseAlarms: 10,
        correctRejections: 10,
      );
      expect(d, closeTo(0, 0.05));
    });

    test('is high when hits are common and false alarms rare', () {
      final good = nbackSensitivity(
        hits: 19,
        misses: 1,
        falseAlarms: 1,
        correctRejections: 19,
      );
      final poor = nbackSensitivity(
        hits: 10,
        misses: 10,
        falseAlarms: 10,
        correctRejections: 10,
      );
      expect(good, greaterThan(poor));
      expect(good, greaterThan(1));
    });

    test('is negative when false alarms outnumber hits', () {
      final d = nbackSensitivity(
        hits: 2,
        misses: 18,
        falseAlarms: 18,
        correctRejections: 2,
      );
      expect(d, lessThan(0));
    });

    test('stays finite with no signal or no noise trials', () {
      expect(
        nbackSensitivity(
          hits: 0,
          misses: 0,
          falseAlarms: 3,
          correctRejections: 7,
        ).isFinite,
        isTrue,
      );
      expect(
        nbackSensitivity(
          hits: 5,
          misses: 5,
          falseAlarms: 0,
          correctRejections: 0,
        ).isFinite,
        isTrue,
      );
    });
  });
}
