import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'airways_geometry.dart';

/// Colour of one aircraft. Only [blue] carries the tighter capacity rule
/// (spec §2.4-H: "at most 2 blue aircraft" per zone, on top of the 4 total).
enum AircraftColour { grey, blue }

enum AirwaysAircraftState { traveling, inZone }

/// Read-only snapshot of one aircraft, for the renderer.
class AirwaysAircraftSnapshot {
  const AirwaysAircraftSnapshot({
    required this.id,
    required this.colour,
    required this.routeId,
    required this.targetZone,
    required this.diverted,
    required this.state,
    required this.position,
  });

  final int id;
  final AircraftColour colour;
  final int routeId;

  /// The zone it is currently heading to (or sitting in): [routeId]'s
  /// `defaultZone`, or its `altZone` once [diverted].
  final int targetZone;
  final bool diverted;
  final AirwaysAircraftState state;
  final AirwaysPoint position;
}

/// Read-only snapshot of one zone's occupancy, for the renderer.
class AirwaysZoneSnapshot {
  const AirwaysZoneSnapshot({
    required this.id,
    required this.center,
    required this.total,
    required this.blue,
    required this.capacity,
    required this.blueCapacity,
  });

  final int id;
  final AirwaysPoint center;
  final int total;
  final int blue;
  final int capacity;
  final int blueCapacity;

  bool get isOverCapacity => total > capacity;
  bool get isOverBlueCapacity => blue > blueCapacity;
  bool get isAtRisk => isOverCapacity || isOverBlueCapacity;
}

class _ScheduledSpawn {
  const _ScheduledSpawn({
    required this.id,
    required this.spawnAtMs,
    required this.routeId,
    required this.colour,
    required this.travelMs,
  });

  final int id;
  final int spawnAtMs;
  final int routeId;
  final AircraftColour colour;
  final int travelMs;
}

class _Aircraft {
  _Aircraft({
    required this.id,
    required this.colour,
    required this.routeId,
    required this.targetZone,
    required this.entryPoint,
    required this.spawnAtMs,
    required this.travelMs,
  });

  final int id;
  final AircraftColour colour;
  final int routeId;
  int targetZone;
  final AirwaysPoint entryPoint;
  final int spawnAtMs;
  final int travelMs;
  bool diverted = false;
  AirwaysAircraftState state = AirwaysAircraftState.traveling;
  int? exitAtMs;

  int get arrivalMs => spawnAtMs + travelMs;
}

/// A deterministic, tick-based traffic simulation: aircraft spawn on one of
/// a few lines and fly toward a grey zone; [reroute] diverts the next
/// eligible aircraft of a line to its alternate zone; [advance] moves time
/// forward, spawning, arriving and clearing aircraft and counting a
/// [violations] every time an arrival pushes a zone over [AirwaysParams
/// .capacity] or [AirwaysParams.blueCapacity].
///
/// Everything randomised (the whole spawn schedule: timing, line, colour,
/// speed) is drawn once from `Random(seed)` at construction (US-032); from
/// then on [advance] and [reroute] are pure state transitions, so the same
/// sequence of calls on two simulations built with the same `(params, seed,
/// difficulty)` always ends in the same state, whatever the size of the
/// individual `advance` steps (each call replays every pending event in
/// timestamp order, not just the ones that happen to land on a tick).
class AirwaysSimulation {
  AirwaysSimulation({
    required this.params,
    required this.difficulty,
    required int seed,
  }) : zoneCount = effectiveZoneCount(params),
       routeCount = effectiveRouteCount(params, difficulty),
       totalMs = params.durationSec * 1000 {
    graph = AirwaysGraph.build(zoneCount: zoneCount, routeCount: routeCount);
    _totals = List.filled(zoneCount, 0);
    _blues = List.filled(zoneCount, 0);
    _schedule = _buildSchedule(Random(seed));
  }

  final AirwaysParams params;
  final int difficulty;
  final int zoneCount;
  final int routeCount;

  /// Length of the series in milliseconds (`AirwaysParams.durationSec`).
  final int totalMs;

  late final AirwaysGraph graph;
  late final List<_ScheduledSpawn> _schedule;
  late final List<int> _totals;
  late final List<int> _blues;
  final List<_Aircraft> _active = [];

  int _elapsedMs = 0;
  int _nextSpawnIndex = 0;
  int _violations = 0;
  int _reroutes = 0;

  /// Zone ids that crossed a capacity limit during the last [advance] call
  /// (for the renderer's crash flash); empty otherwise.
  List<int> lastViolationZones = const [];

  static const int _dwellMs = 2600;
  static const int _minTravelMs = 1800;
  static const int _travelJitterMs = 1600;
  static const double _blueProbability = 0.35;
  static const int _spawnJitterMs = 200;

  /// Total grey zones of the scene: [AirwaysParams.zoneCount] clamped to the
  /// "2 or 3 zones" the spec and lesson describe.
  static int effectiveZoneCount(AirwaysParams params) =>
      params.zoneCount.clamp(2, 3);

  /// Lines of the scene: [AirwaysParams.routeCount] widened by [difficulty]
  /// (spec: "difficulty = spawn rate / graph complexity"), clamped to 2..4
  /// so every line always has its own colour button (1-4 on the keyboard).
  static int effectiveRouteCount(AirwaysParams params, int difficulty) =>
      (params.routeCount + (difficulty - 3)).clamp(2, 4);

  int get elapsedMs => _elapsedMs;
  int get violations => _violations;
  int get reroutesUsed => _reroutes;
  bool get isComplete => _elapsedMs >= totalMs;

  List<AirwaysAircraftSnapshot> get aircraft => [
    for (final a in _active)
      AirwaysAircraftSnapshot(
        id: a.id,
        colour: a.colour,
        routeId: a.routeId,
        targetZone: a.targetZone,
        diverted: a.diverted,
        state: a.state,
        position: _positionOf(a),
      ),
  ];

  List<AirwaysZoneSnapshot> get zones => [
    for (final z in graph.zones)
      AirwaysZoneSnapshot(
        id: z.id,
        center: z.center,
        total: _totals[z.id],
        blue: _blues[z.id],
        capacity: params.capacity,
        blueCapacity: params.blueCapacity,
      ),
  ];

  /// Moves the simulation forward by [deltaMs] (a widget-layer `Ticker`'s
  /// elapsed delta, or a test's fixed step). No-op for a non-positive delta.
  void advance(int deltaMs) {
    if (deltaMs <= 0) return;
    final target = _elapsedMs + deltaMs;
    final violated = <int>[];
    while (_elapsedMs < target) {
      final next = _nextEventTime(target);
      _elapsedMs = next;
      _processExits();
      _processSpawns();
      violated.addAll(_processArrivals());
      if (next >= target) break;
    }
    _elapsedMs = target;
    lastViolationZones = violated;
  }

  /// Diverts the earliest still-travelling, not-yet-diverted aircraft of
  /// [routeId] to its alternate zone. Returns whether one was found (a
  /// no-op reroute -- nothing left to divert -- is not counted, so the
  /// candidate is free to "not act" without spending a reroute).
  bool reroute(int routeId) {
    if (routeId < 0 || routeId >= routeCount) return false;
    final route = graph.routes[routeId];
    if (route.altZone == route.defaultZone) return false;
    _Aircraft? best;
    for (final a in _active) {
      if (a.routeId != routeId ||
          a.state != AirwaysAircraftState.traveling ||
          a.diverted ||
          a.arrivalMs <= _elapsedMs) {
        continue;
      }
      if (best == null ||
          a.arrivalMs < best.arrivalMs ||
          (a.arrivalMs == best.arrivalMs && a.id < best.id)) {
        best = a;
      }
    }
    if (best == null) return false;
    best.targetZone = route.altZone;
    best.diverted = true;
    _reroutes++;
    return true;
  }

  List<_ScheduledSpawn> _buildSchedule(Random rng) {
    final schedule = <_ScheduledSpawn>[];
    final baseInterval = (params.spawnIntervalMs - (difficulty - 3) * 400)
        .clamp(900, 4000);
    var t = 0;
    var id = 0;
    while (t < totalMs) {
      final jitter = rng.nextInt(_spawnJitterMs * 2 + 1) - _spawnJitterMs;
      final spawnAt = (t + jitter).clamp(0, totalMs - 1);
      final routeId = rng.nextInt(routeCount);
      final colour = rng.nextDouble() < _blueProbability
          ? AircraftColour.blue
          : AircraftColour.grey;
      final travelMs = _minTravelMs + rng.nextInt(_travelJitterMs + 1);
      schedule.add(
        _ScheduledSpawn(
          id: id,
          spawnAtMs: spawnAt,
          routeId: routeId,
          colour: colour,
          travelMs: travelMs,
        ),
      );
      id++;
      t += baseInterval;
    }
    schedule.sort((a, b) => a.spawnAtMs.compareTo(b.spawnAtMs));
    return schedule;
  }

  int _nextEventTime(int target) {
    var next = target;
    if (_nextSpawnIndex < _schedule.length) {
      final s = _schedule[_nextSpawnIndex].spawnAtMs;
      if (s < next) next = s;
    }
    for (final a in _active) {
      if (a.state == AirwaysAircraftState.traveling) {
        if (a.arrivalMs < next) next = a.arrivalMs;
      } else if (a.exitAtMs! < next) {
        next = a.exitAtMs!;
      }
    }
    return next < _elapsedMs ? _elapsedMs : next;
  }

  void _processSpawns() {
    while (_nextSpawnIndex < _schedule.length &&
        _schedule[_nextSpawnIndex].spawnAtMs <= _elapsedMs) {
      final s = _schedule[_nextSpawnIndex];
      final route = graph.routes[s.routeId];
      _active.add(
        _Aircraft(
          id: s.id,
          colour: s.colour,
          routeId: s.routeId,
          targetZone: route.defaultZone,
          entryPoint: route.entryPoint,
          spawnAtMs: s.spawnAtMs,
          travelMs: s.travelMs,
        ),
      );
      _nextSpawnIndex++;
    }
  }

  void _processExits() {
    _active.removeWhere((a) {
      if (a.state == AirwaysAircraftState.inZone && a.exitAtMs! <= _elapsedMs) {
        _totals[a.targetZone]--;
        if (a.colour == AircraftColour.blue) _blues[a.targetZone]--;
        return true;
      }
      return false;
    });
  }

  List<int> _processArrivals() {
    final arrivals =
        _active
            .where(
              (a) =>
                  a.state == AirwaysAircraftState.traveling &&
                  a.arrivalMs <= _elapsedMs,
            )
            .toList()
          ..sort((a, b) {
            final c = a.arrivalMs.compareTo(b.arrivalMs);
            return c != 0 ? c : a.id.compareTo(b.id);
          });
    final violated = <int>[];
    for (final a in arrivals) {
      final zone = a.targetZone;
      _totals[zone]++;
      if (a.colour == AircraftColour.blue) _blues[zone]++;
      final over =
          _totals[zone] > params.capacity || _blues[zone] > params.blueCapacity;
      if (over) {
        _violations++;
        violated.add(zone);
      }
      a.state = AirwaysAircraftState.inZone;
      a.exitAtMs = _elapsedMs + _dwellMs;
    }
    return violated;
  }

  AirwaysPoint _positionOf(_Aircraft a) {
    final dest = graph.zones[a.targetZone].center;
    if (a.state == AirwaysAircraftState.inZone) return dest;
    final t = ((_elapsedMs - a.spawnAtMs) / a.travelMs).clamp(0.0, 1.0);
    return a.entryPoint.lerp(dest, t);
  }
}
