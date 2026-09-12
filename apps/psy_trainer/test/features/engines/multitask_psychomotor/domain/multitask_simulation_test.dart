import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/multitask_psychomotor/domain/multitask_simulation.dart';

void main() {
  const params = MultitaskParams(durationSec: 20);

  MultitaskSimulation build({int seed = 1, int difficulty = 3}) =>
      MultitaskSimulation.build(
        seed: seed,
        params: params,
        difficulty: difficulty,
      );

  group('determinism', () {
    test('same (seed, params, difficulty) yields the exact same timeline', () {
      final a = build();
      final b = build();

      expect(a.durationMs, b.durationMs);
      expect(a.referenceShape, b.referenceShape);
      expect(a.directions.length, b.directions.length);
      for (var i = 0; i < a.directions.length; i++) {
        expect(a.directions[i].startMs, b.directions[i].startMs);
        expect(a.directions[i].endMs, b.directions[i].endMs);
        expect(a.directions[i].direction, b.directions[i].direction);
      }
      expect(a.shapeEvents.length, b.shapeEvents.length);
      for (var i = 0; i < a.shapeEvents.length; i++) {
        expect(a.shapeEvents[i].shape, b.shapeEvents[i].shape);
        expect(a.shapeEvents[i].isTarget, b.shapeEvents[i].isTarget);
      }
      expect(a.calcEvents.length, b.calcEvents.length);
      for (var i = 0; i < a.calcEvents.length; i++) {
        expect(a.calcEvents[i].shown, b.calcEvents[i].shown);
        expect(a.calcEvents[i].isWrong, b.calcEvents[i].isWrong);
      }
      // Sampled continuous outputs agree too.
      for (final ms in [0, 1234, 9999, 19999]) {
        expect(a.positionAt(ms), b.positionAt(ms));
        expect(a.directionAt(ms), b.directionAt(ms));
      }
    });

    test('a different seed yields a different timeline', () {
      final a = build();
      final b = build(seed: 2);
      final differs =
          a.referenceShape != b.referenceShape ||
          a.directions.length != b.directions.length ||
          a.directions.first.direction != b.directions.first.direction ||
          a.shapeEvents.first.shape != b.shapeEvents.first.shape;
      expect(differs, isTrue);
    });

    test('difficulty scales the event rate (higher = more events)', () {
      final easy = build(difficulty: 1);
      final hard = build(difficulty: 5);
      expect(hard.shapeEvents.length, greaterThan(easy.shapeEvents.length));
      expect(hard.calcEvents.length, greaterThan(easy.calcEvents.length));
    });
  });

  group('event windows', () {
    test('direction segments tile [0, durationMs) exactly once', () {
      final sim = build();
      expect(sim.directions.first.startMs, 0);
      expect(sim.directions.last.endMs, sim.durationMs);
      for (var i = 0; i + 1 < sim.directions.length; i++) {
        expect(sim.directions[i].endMs, sim.directions[i + 1].startMs);
        expect(sim.directions[i].endMs, greaterThan(sim.directions[i].startMs));
      }
    });

    test('shape events tile [0, durationMs) exactly once', () {
      final sim = build();
      expect(sim.shapeEvents.first.startMs, 0);
      expect(sim.shapeEvents.last.endMs, sim.durationMs);
      for (var i = 0; i + 1 < sim.shapeEvents.length; i++) {
        expect(sim.shapeEvents[i].endMs, sim.shapeEvents[i + 1].startMs);
      }
    });

    test('calc events tile [0, durationMs) exactly once', () {
      final sim = build();
      expect(sim.calcEvents.first.startMs, 0);
      expect(sim.calcEvents.last.endMs, sim.durationMs);
      for (var i = 0; i + 1 < sim.calcEvents.length; i++) {
        expect(sim.calcEvents[i].endMs, sim.calcEvents[i + 1].startMs);
      }
    });

    test('directionAt/shapeAt/calcAt agree with the segment covering ms', () {
      final sim = build();
      for (final segment in sim.directions) {
        expect(sim.directionAt(segment.startMs), segment.direction);
      }
      for (final event in sim.shapeEvents) {
        expect(sim.shapeAt(event.startMs).shape, event.shape);
      }
      for (final event in sim.calcEvents) {
        expect(sim.calcAt(event.startMs).shown, event.shown);
      }
    });

    test('shape target ratio is roughly params.shapeTargetRatio over a '
        'long run', () {
      final sim = MultitaskSimulation.build(
        seed: 7,
        params: const MultitaskParams(durationSec: 3000),
        difficulty: 3,
      );
      final targets = sim.shapeEvents.where((e) => e.isTarget).length;
      final ratio = targets / sim.shapeEvents.length;
      expect(ratio, closeTo(0.3, 0.1));
    });

    test(
      'calc wrong ratio is roughly params.calcWrongRatio over a long run',
      () {
        final sim = MultitaskSimulation.build(
          seed: 7,
          params: const MultitaskParams(durationSec: 3000),
          difficulty: 3,
        );
        final wrong = sim.calcEvents.where((e) => e.isWrong).length;
        final ratio = wrong / sim.calcEvents.length;
        expect(ratio, closeTo(0.4, 0.1));
      },
    );

    test('a wrong calc event shows a different result than the real one', () {
      final sim = build();
      for (final event in sim.calcEvents) {
        expect(event.isWrong, event.shown != event.realResult);
      }
    });

    test('positionAt stays within the [0,1] arena', () {
      final sim = build();
      for (var ms = 0; ms <= sim.durationMs; ms += 250) {
        final (x, y) = sim.positionAt(ms);
        expect(x, inInclusiveRange(0.0, 1.0));
        expect(y, inInclusiveRange(0.0, 1.0));
      }
    });
  });
}
