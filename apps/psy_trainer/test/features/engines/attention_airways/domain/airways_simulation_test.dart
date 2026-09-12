import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/features/engines/attention_airways/domain/airways_simulation.dart';

void main() {
  const params = AirwaysParams(spawnIntervalMs: 1200, durationSec: 20);

  AirwaysSimulation build({int seed = 1, int difficulty = 3}) =>
      AirwaysSimulation(params: params, difficulty: difficulty, seed: seed);

  test('effectiveZoneCount and effectiveRouteCount are clamped', () {
    expect(AirwaysSimulation.effectiveZoneCount(params), 2);
    expect(AirwaysSimulation.effectiveRouteCount(params, 2), 2);
    expect(AirwaysSimulation.effectiveRouteCount(params, 3), 3);
    expect(AirwaysSimulation.effectiveRouteCount(params, 4), 4);
    // Clamped even for an out-of-range difficulty.
    expect(AirwaysSimulation.effectiveRouteCount(params, 5), 4);
  });

  test('advancing in one big step matches many small steps', () {
    final coarse = build();
    final fine = build();
    coarse.advance(20000);
    for (var i = 0; i < 200; i++) {
      fine.advance(100);
    }
    expect(coarse.violations, fine.violations);
    expect(coarse.elapsedMs, fine.elapsedMs);
    expect(coarse.aircraft.length, fine.aircraft.length);
    for (final zone in coarse.zones.indexed) {
      expect(zone.$2.total, fine.zones[zone.$1].total);
      expect(zone.$2.blue, fine.zones[zone.$1].blue);
    }
  });

  test('same seed and same tick sequence reproduce the same run', () {
    final a = build(seed: 42);
    final b = build(seed: 42);
    for (var i = 0; i < 40; i++) {
      a.advance(500);
      b.advance(500);
      // Exercise a reroute at the same point in both runs.
      if (i == 10) {
        a.reroute(0);
        b.reroute(0);
      }
    }
    expect(a.violations, b.violations);
    expect(a.reroutesUsed, b.reroutesUsed);
    expect(a.elapsedMs, b.elapsedMs);
    final aircraftA = a.aircraft;
    final aircraftB = b.aircraft;
    expect(aircraftA.length, aircraftB.length);
    for (var i = 0; i < aircraftA.length; i++) {
      expect(aircraftA[i].id, aircraftB[i].id);
      expect(aircraftA[i].colour, aircraftB[i].colour);
      expect(aircraftA[i].targetZone, aircraftB[i].targetZone);
      expect(aircraftA[i].position.x, closeTo(aircraftB[i].position.x, 1e-9));
      expect(aircraftA[i].position.y, closeTo(aircraftB[i].position.y, 1e-9));
    }
  });

  test('different seeds produce different spawn schedules', () {
    final a = build();
    final b = build(seed: 2);
    a.advance(20000);
    b.advance(20000);
    // The spawn count is near-deterministic (it mostly follows the fixed
    // interval, not the RNG), so compare what the seed actually drives:
    // each aircraft's route/colour/target. Extremely unlikely to coincide
    // for two different seeds; if this ever flakes, the RNG derivation has
    // a bug worth investigating.
    final signatureA = [
      for (final craft in a.aircraft) (craft.colour, craft.routeId, craft.targetZone),
    ];
    final signatureB = [
      for (final craft in b.aircraft) (craft.colour, craft.routeId, craft.targetZone),
    ];
    expect(signatureA, isNot(signatureB));
  });

  test(
    'a zone that reaches capacity flags a violation on the next arrival',
    () {
      // Capacity 1 with a fast spawn rate: with a ~2.6 s dwell time, the
      // very next aircraft that lands in an occupied zone always crashes.
      const crowded = AirwaysParams(
        capacity: 1,
        blueCapacity: 1,
        routeCount: 2,
        spawnIntervalMs: 300,
        durationSec: 15,
      );
      final sim = AirwaysSimulation(params: crowded, difficulty: 4, seed: 7);
      sim.advance(15000);
      expect(sim.violations, greaterThan(0));
    },
  );

  test('rerouting an aircraft before it arrives changes its target zone', () {
    final sim = build(seed: 3);
    // A spawn is guaranteed within the first ~200 ms of any route; none of
    // them can have arrived yet (`_minTravelMs` is 1.8 s).
    sim.advance(300);
    final spawned = sim.aircraft;
    expect(spawned, isNotEmpty);
    final target = spawned.first;

    final rerouted = sim.reroute(target.routeId);
    expect(rerouted, isTrue);
    expect(sim.reroutesUsed, 1);
    final after = sim.aircraft.firstWhere((a) => a.id == target.id);
    expect(after.diverted, isTrue);
    expect(after.targetZone, isNot(target.targetZone));
  });

  test('rerouting a route with nothing left to divert is a no-op', () {
    final sim = build(seed: 9);
    // Nothing has spawned yet.
    expect(sim.reroute(0), isFalse);
    expect(sim.reroutesUsed, 0);
  });

  test('an aircraft can only be diverted once', () {
    final sim = build(seed: 11);
    sim.advance(300);
    final routeId = sim.aircraft.first.routeId;
    expect(sim.reroute(routeId), isTrue);
    expect(sim.reroutesUsed, 1);
    // The same (now diverted) aircraft is skipped on a second call to the
    // same route: with only one aircraft airborne this early, it is a
    // no-op rather than a double-count.
    expect(sim.reroute(routeId), isFalse);
    expect(sim.reroutesUsed, 1);
  });

  test('isComplete becomes true once the series duration is reached', () {
    final sim = build();
    expect(sim.isComplete, isFalse);
    sim.advance(20000);
    expect(sim.isComplete, isTrue);
    expect(sim.elapsedMs, 20000);
  });
}
