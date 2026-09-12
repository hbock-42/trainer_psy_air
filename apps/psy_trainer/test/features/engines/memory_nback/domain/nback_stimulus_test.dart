import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_stimulus.dart';

void main() {
  group('NbackStimulus.decode', () {
    test('is deterministic: same (params, seed) gives the same stimulus', () {
      const params = NbackParams();
      final a = NbackStimulus.decode(params, 42);
      final b = NbackStimulus.decode(params, 42);
      expect(a.role, b.role);
      expect(a.value, b.value);
      expect(a.history, b.history);
    });

    test('a different seed can give a different stimulus', () {
      const params = NbackParams();
      final seeds = {
        for (var seed = 0; seed < 20; seed++)
          seed: NbackStimulus.decode(params, seed).value,
      };
      expect(seeds.values.toSet().length, greaterThan(1));
    });

    test('a target equals its own n-back reference', () {
      const params = NbackParams(primers: 0);
      final targets = [
        for (var seed = 0; seed < 500; seed++)
          NbackStimulus.decode(params, seed),
      ].where((s) => s.role == NbackRole.target);
      expect(targets, isNotEmpty);
      for (final target in targets) {
        expect(target.value, target.history.first);
        expect(target.expectsYes, isTrue);
      }
    });

    test('a lure and a filler never equal their own n-back reference', () {
      const params = NbackParams(primers: 0);
      final nonTargets = [
        for (var seed = 0; seed < 500; seed++)
          NbackStimulus.decode(params, seed),
      ].where((s) => s.role != NbackRole.target && s.role != NbackRole.primer);
      expect(nonTargets, isNotEmpty);
      for (final stimulus in nonTargets) {
        expect(stimulus.value, isNot(stimulus.history.first));
        expect(stimulus.expectsYes, isFalse);
      }
    });

    test('history has n entries', () {
      const params = NbackParams(n: 3, primers: 0);
      final stimulus = NbackStimulus.decode(params, 7);
      expect(stimulus.history, hasLength(3));
    });

    test('role proportions roughly match targetRatio and lureRatio', () {
      const params = NbackParams(primers: 0);
      final counts = <NbackRole, int>{};
      const trials = 4000;
      for (var seed = 0; seed < trials; seed++) {
        final role = NbackStimulus.decode(params, seed).role;
        counts[role] = (counts[role] ?? 0) + 1;
      }
      expect(counts[NbackRole.primer] ?? 0, 0);
      final targetShare = (counts[NbackRole.target] ?? 0) / trials;
      final lureShare = (counts[NbackRole.lure] ?? 0) / trials;
      expect(targetShare, closeTo(params.targetRatio, 0.03));
      expect(lureShare, closeTo(params.lureRatio, 0.03));
    });

    test('primer share roughly matches primers/count', () {
      const params = NbackParams(count: 10, primers: 5);
      var primers = 0;
      const trials = 4000;
      for (var seed = 0; seed < trials; seed++) {
        if (NbackStimulus.decode(params, seed).isPrimer) primers++;
      }
      expect(primers / trials, closeTo(0.5, 0.03));
    });

    test('a primer is never counted as a target', () {
      const params = NbackParams(count: 10, primers: 5);
      final primer = NbackStimulus.decode(params, 1);
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
