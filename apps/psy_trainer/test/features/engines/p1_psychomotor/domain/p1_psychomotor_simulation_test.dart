import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/p1_psychomotor/domain/p1_psychomotor_simulation.dart';

void main() {
  const params = P1PsychomotorParams(phaseCount: 2, phaseDurationSec: 20);

  P1PsychomotorSimulation build({int runSeed = 1, int difficulty = 3}) =>
      P1PsychomotorSimulation.build(
        runSeed: runSeed,
        params: params,
        difficulty: difficulty,
      );

  group('determinism', () {
    test(
      'same (runSeed, params, difficulty) yields the exact same timeline',
      () {
        final a = build();
        final b = build();

        expect(a.durationMs, b.durationMs);
        for (var gauge = 0; gauge < p1PsychomotorGaugeCount; gauge++) {
          for (final ms in [0, 1234, 9999, 39999]) {
            expect(
              a.gaugeNaturalVelocityAt(gauge, ms),
              b.gaugeNaturalVelocityAt(gauge, ms),
            );
          }
        }
        for (final ms in [0, 1234, 9999, 39999]) {
          expect(a.targetPositionAt(ms), b.targetPositionAt(ms));
          expect(a.letterWaveAt(ms).letters, b.letterWaveAt(ms).letters);
          expect(
            a.letterWaveAt(ms).targetPositions,
            b.letterWaveAt(ms).targetPositions,
          );
          expect(a.arithmeticProblemAt(ms).a, b.arithmeticProblemAt(ms).a);
          expect(a.arithmeticProblemAt(ms).b, b.arithmeticProblemAt(ms).b);
          expect(a.arithmeticProblemAt(ms).op, b.arithmeticProblemAt(ms).op);
        }
      },
    );

    test('a different runSeed yields a different timeline', () {
      final a = build();
      final b = build(runSeed: 2);
      final differs =
          a.targetPositionAt(5000) != b.targetPositionAt(5000) ||
          a.letterWaveAt(5000).letters.join() !=
              b.letterWaveAt(5000).letters.join() ||
          a.arithmeticProblemAt(5000).a != b.arithmeticProblemAt(5000).a;
      expect(differs, isTrue);
    });

    test('difficulty scales the gauge drift rate (higher = faster drift)', () {
      final easy = build(difficulty: 1);
      final hard = build(difficulty: 5);
      double maxAbsVelocity(P1PsychomotorSimulation sim) {
        var max = 0.0;
        for (var g = 0; g < p1PsychomotorGaugeCount; g++) {
          for (var ms = 0; ms < sim.durationMs; ms += 500) {
            final v = sim.gaugeNaturalVelocityAt(g, ms).abs();
            if (v > max) max = v;
          }
        }
        return max;
      }

      expect(maxAbsVelocity(hard), greaterThan(maxAbsVelocity(easy)));
    });
  });

  group('letter waves', () {
    test('always show 9 letters with exactly 3 targets', () {
      final sim = build();
      for (var ms = 0; ms < sim.durationMs; ms += 750) {
        final wave = sim.letterWaveAt(ms);
        expect(wave.letters, hasLength(p1PsychomotorLetterCount));
        expect(wave.targetPositions, hasLength(p1PsychomotorTargetLetterCount));
        for (final position in wave.targetPositions) {
          expect(position, inInclusiveRange(0, p1PsychomotorLetterCount - 1));
        }
      }
    });
  });

  group('arithmetic stream', () {
    test('a new problem starts every calcIntervalSec', () {
      final sim = build();
      final first = sim.arithmeticProblemAt(0);
      expect(first.startMs, 0);
      expect(first.endMs, params.calcIntervalSec * 1000);
      final second = sim.arithmeticProblemAt(params.calcIntervalSec * 1000);
      expect(second.startMs, params.calcIntervalSec * 1000);
    });

    test('addition/subtraction answers are internally consistent', () {
      final sim = build();
      for (
        var ms = 0;
        ms < sim.durationMs;
        ms += params.calcIntervalSec * 1000
      ) {
        final problem = sim.arithmeticProblemAt(ms);
        expect(['+', '-'], contains(problem.op));
        final expected = problem.op == '+'
            ? problem.a + problem.b
            : problem.a - problem.b;
        expect(problem.answer, expected);
      }
    });
  });

  group('tracking target', () {
    test('the target path stays within the unit circle', () {
      final sim = build();
      for (var ms = 0; ms < sim.durationMs; ms += 250) {
        final (x, y) = sim.targetPositionAt(ms);
        expect(x * x + y * y, lessThanOrEqualTo(1.01));
      }
    });
  });
}
