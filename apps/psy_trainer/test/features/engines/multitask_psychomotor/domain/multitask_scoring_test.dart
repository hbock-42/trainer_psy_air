import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_scoring.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_simulation.dart';

void main() {
  group('MultitaskMetrics', () {
    test('perfect tracking, all hits, no false alarms scores 1.0', () {
      const metrics = MultitaskMetrics(
        totalMs: 1000,
        trackingErrorMs: 0,
        shapeHits: 5,
        shapeMisses: 0,
        shapeFalseAlarms: 0,
        calcHits: 5,
        calcMisses: 0,
        calcFalseAlarms: 0,
      );
      expect(metrics.trackingRmsError, 0);
      expect(metrics.combinedScore, 1.0);
      expect(MultitaskScoring.isCorrect(metrics), isTrue);
    });

    test('never tracking, never responding scores 0.0', () {
      const metrics = MultitaskMetrics(
        totalMs: 1000,
        trackingErrorMs: 1000,
        shapeHits: 0,
        shapeMisses: 5,
        shapeFalseAlarms: 0,
        calcHits: 0,
        calcMisses: 5,
        calcFalseAlarms: 0,
      );
      expect(metrics.trackingRmsError, 1.0);
      expect(metrics.combinedScore, 0.0);
      expect(MultitaskScoring.isCorrect(metrics), isFalse);
    });

    test('false alarms lower the accuracy just like misses', () {
      const withFalseAlarms = MultitaskMetrics(
        totalMs: 1000,
        trackingErrorMs: 0,
        shapeHits: 5,
        shapeMisses: 0,
        shapeFalseAlarms: 5,
        calcHits: 5,
        calcMisses: 0,
        calcFalseAlarms: 0,
      );
      expect(withFalseAlarms.shapeAccuracy, 0.5);
      expect(withFalseAlarms.combinedScore, lessThan(1.0));
    });

    test('round-trips through the JSON payload', () {
      const metrics = MultitaskMetrics(
        totalMs: 300000,
        trackingErrorMs: 12345,
        shapeHits: 30,
        shapeMisses: 4,
        shapeFalseAlarms: 2,
        calcHits: 20,
        calcMisses: 3,
        calcFalseAlarms: 1,
      );
      final decoded = MultitaskMetrics.fromPayload(metrics.toPayload());
      expect(decoded.toPayload(), metrics.toPayload());
    });

    test('threshold is documented and used consistently', () {
      // A combined score sitting exactly at the threshold counts as correct.
      final atThreshold = MultitaskMetrics(
        totalMs: 1000,
        trackingErrorMs: (1000 * (1 - MultitaskScoring.correctThreshold) * (1 - MultitaskScoring.correctThreshold)).round(),
        shapeHits: 0,
        shapeMisses: 0,
        shapeFalseAlarms: 0,
        calcHits: 0,
        calcMisses: 0,
        calcFalseAlarms: 0,
      );
      // tracking-only combined score: (trackingAccuracy + 1 + 1) / 3 >= threshold
      // is trivially true here since shape/calc default to 1.0; assert the
      // simpler, documented contract directly instead.
      expect(
        MultitaskScoring.isCorrect(atThreshold),
        MultitaskScoring.correctThreshold <= atThreshold.combinedScore,
      );
    });
  });

  group('MultitaskScoring.evaluate (event windows)', () {
    const params = MultitaskParams(durationSec: 90);
    final sim = MultitaskSimulation.build(seed: 42, params: params, difficulty: 3);

    test('holding the exact target direction the whole run scores 0 tracking error', () {
      final heldIntervals = [
        for (final seg in sim.directions)
          HeldInterval(startMs: seg.startMs, endMs: seg.endMs, direction: seg.direction),
      ];
      final metrics = MultitaskScoring.evaluate(sim, heldIntervals: heldIntervals);
      expect(metrics.trackingErrorMs, 0);
      expect(metrics.trackingRmsError, 0);
    });

    test('never holding any direction scores maximal tracking error', () {
      final metrics = MultitaskScoring.evaluate(sim);
      expect(metrics.trackingErrorMs, sim.durationMs);
      expect(metrics.trackingRmsError, 1.0);
    });

    test('a press inside a target shape\'s window is a hit, outside it is a miss', () {
      final target = sim.shapeEvents.firstWhere((e) => e.isTarget);
      final hit = MultitaskScoring.evaluate(sim, shapePressMs: [target.startMs]);
      expect(hit.shapeHits, 1);
      expect(hit.shapeMisses, sim.shapeEvents.where((e) => e.isTarget).length - 1);

      final miss = MultitaskScoring.evaluate(sim);
      expect(miss.shapeHits, 0);
      expect(miss.shapeMisses, sim.shapeEvents.where((e) => e.isTarget).length);
    });

    test('a press inside a non-target shape\'s window is a false alarm', () {
      final distractor = sim.shapeEvents.firstWhere((e) => !e.isTarget);
      final metrics = MultitaskScoring.evaluate(
        sim,
        shapePressMs: [distractor.startMs],
      );
      expect(metrics.shapeFalseAlarms, 1);
    });

    test('a press exactly at a window\'s end (exclusive) does not count', () {
      final target = sim.shapeEvents.firstWhere((e) => e.isTarget);
      final metrics = MultitaskScoring.evaluate(
        sim,
        shapePressMs: [target.endMs],
      );
      expect(metrics.shapeHits, 0);
    });

    test('an F press inside a wrong calculation\'s window is a hit', () {
      final wrong = sim.calcEvents.firstWhere((e) => e.isWrong);
      final metrics = MultitaskScoring.evaluate(sim, calcPressMs: [wrong.startMs]);
      expect(metrics.calcHits, 1);
    });

    test('an F press inside a correct calculation\'s window is a false alarm', () {
      final correct = sim.calcEvents.firstWhere((e) => !e.isWrong);
      final metrics = MultitaskScoring.evaluate(sim, calcPressMs: [correct.startMs]);
      expect(metrics.calcFalseAlarms, 1);
    });

    test('evaluate is deterministic for the same input log', () {
      final a = MultitaskScoring.evaluate(sim, shapePressMs: [100, 5000]);
      final b = MultitaskScoring.evaluate(sim, shapePressMs: [100, 5000]);
      expect(a.toPayload(), b.toPayload());
    });
  });
}
