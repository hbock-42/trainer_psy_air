import 'dart:math';

import 'package:psy_content/psy_content.dart';

import 'multitask_track.dart';

/// One slot of the tracking target's direction: it holds [direction] for
/// `[startMs, endMs)`.
class DirectionSegment {
  const DirectionSegment({
    required this.startMs,
    required this.endMs,
    required this.direction,
  });

  final int startMs;
  final int endMs;
  final TrackDirection direction;
}

/// One slot of the shape stream: the circle shows [shape] for
/// `[startMs, endMs)`; [isTarget] is whether it equals the run's reference
/// shape (spec §2.4-M: "press SPACE when the shape ... equals the reference
/// shape").
class ShapeEvent {
  const ShapeEvent({
    required this.startMs,
    required this.endMs,
    required this.shape,
    required this.isTarget,
  });

  final int startMs;
  final int endMs;
  final StimulusShape shape;
  final bool isTarget;
}

/// One slot of the framed-calculation stream: `$a $op $b = $shown` is
/// displayed for `[startMs, endMs)`; [isWrong] is whether [shown] differs
/// from the real result (spec: "press F when the framed calculation is
/// wrong").
class CalcEvent {
  const CalcEvent({
    required this.startMs,
    required this.endMs,
    required this.a,
    required this.op,
    required this.b,
    required this.shown,
    required this.isWrong,
  });

  final int startMs;
  final int endMs;
  final int a;
  final String op;
  final int b;
  final int shown;
  final bool isWrong;

  int get realResult => switch (op) {
    '+' => a + b,
    '-' => a - b,
    '×' => a * b,
    _ => throw StateError('unknown op $op'),
  };
}

/// A point of the tracking circle's on-screen path, in a normalised
/// `[0, 1] x [0, 1]` arena; interpolated between consecutive waypoints by
/// [MultitaskSimulation.positionAt].
class _Waypoint {
  const _Waypoint(this.ms, this.x, this.y);

  final int ms;
  final double x;
  final double y;
}

/// The whole 5-minute run (spec §2.4-M, US-036), built once, deterministically,
/// from `(seed, params, difficulty)` -- the "engine-owned data derived again
/// from the seed" pattern of `dominos`/`attention_rules`
/// (`docs/ARCHITECTURE.md`, "Engine" step 1). Neither the renderer nor the
/// scorer keep any random state of their own: everything they need (the
/// target's direction and position at any instant, which shape/calculation
/// is shown) comes from querying this timeline.
///
/// Difficulty (1-5, blueprint always plays 3) scales speed/noise/event rate:
/// `scale(difficulty) = 1 + 0.15 * (difficulty - 3)`, so difficulty 3 is
/// exactly the family's documented defaults (`MultitaskParams`) and 1/5 are
/// +/-30% softer/harder. Not spec'd (the real test's difficulty curve is
/// undocumented); flagged in the story's final report.
class MultitaskSimulation {
  MultitaskSimulation._({
    required this.durationMs,
    required this.referenceShape,
    required this.directions,
    required this.shapeEvents,
    required this.calcEvents,
    required List<_Waypoint> waypoints,
  }) : _waypoints = waypoints;

  final int durationMs;
  final StimulusShape referenceShape;
  final List<DirectionSegment> directions;
  final List<ShapeEvent> shapeEvents;
  final List<CalcEvent> calcEvents;
  final List<_Waypoint> _waypoints;

  static double scaleFor(int difficulty) => 1 + 0.15 * (difficulty - 3);

  factory MultitaskSimulation.build({
    required int seed,
    required MultitaskParams params,
    required int difficulty,
  }) {
    final rng = Random(seed);
    final scale = scaleFor(difficulty);
    final durationMs = params.durationSec * 1000;

    final directions = _buildDirections(
      rng,
      durationMs,
      noiseScale: params.trackingNoise * scale,
    );
    final waypoints = _buildWaypoints(
      directions,
      speedScale: params.trackingSpeed * scale,
    );

    final referenceShape =
        StimulusShape.values[rng.nextInt(StimulusShape.values.length)];
    final shapeEvents = _buildShapeEvents(
      rng,
      durationMs,
      referenceShape: referenceShape,
      targetRatio: params.shapeTargetRatio,
      averageIntervalMs: (params.shapeIntervalMs / scale).round(),
    );
    final calcEvents = _buildCalcEvents(
      rng,
      durationMs,
      wrongRatio: params.calcWrongRatio,
      averageIntervalMs: (params.calcIntervalMs / scale).round(),
    );

    return MultitaskSimulation._(
      durationMs: durationMs,
      referenceShape: referenceShape,
      directions: directions,
      shapeEvents: shapeEvents,
      calcEvents: calcEvents,
      waypoints: waypoints,
    );
  }

  /// The direction the target is moving in at [ms] (clamped to the run).
  TrackDirection directionAt(int ms) =>
      _slotAt(directions, ms, (s) => s.startMs).direction;

  /// The shape event covering [ms] (clamped to the run).
  ShapeEvent shapeAt(int ms) => _slotAt(shapeEvents, ms, (s) => s.startMs);

  /// The calculation event covering [ms] (clamped to the run).
  CalcEvent calcAt(int ms) => _slotAt(calcEvents, ms, (s) => s.startMs);

  /// Normalised `(x, y)` position of the tracking circle at [ms], linearly
  /// interpolated between the direction-change waypoints.
  (double, double) positionAt(int ms) {
    final t = ms.clamp(0, durationMs);
    var i = 0;
    while (i + 1 < _waypoints.length && _waypoints[i + 1].ms <= t) {
      i++;
    }
    final a = _waypoints[i];
    final b = i + 1 < _waypoints.length ? _waypoints[i + 1] : a;
    if (b.ms == a.ms) return (a.x, a.y);
    final f = (t - a.ms) / (b.ms - a.ms);
    return (a.x + (b.x - a.x) * f, a.y + (b.y - a.y) * f);
  }

  /// The last of [slots] (built in increasing, contiguous, non-overlapping
  /// order) whose [startOf] is at or before [ms]; the first one if [ms] is
  /// before all of them (never happens: every timeline starts at 0).
  static T _slotAt<T>(List<T> slots, int ms, int Function(T) startOf) {
    for (var i = slots.length - 1; i >= 0; i--) {
      if (ms >= startOf(slots[i])) return slots[i];
    }
    return slots.first;
  }

  static List<DirectionSegment> _buildDirections(
    Random rng,
    int durationMs, {
    required double noiseScale,
  }) {
    final segments = <DirectionSegment>[];
    var t = 0;
    var dir = TrackDirection.values[rng.nextInt(TrackDirection.values.length)];
    const baseDwellMs = 1100;
    final effectiveNoise = noiseScale <= 0 ? 0.01 : noiseScale;
    while (t < durationMs) {
      final maxDwell = durationMs == 0 ? 150 : durationMs;
      var dwell = ((baseDwellMs / effectiveNoise) * (0.5 + rng.nextDouble()))
          .round();
      if (dwell < 150) dwell = 150;
      if (dwell > maxDwell) dwell = maxDwell;
      final end = min(durationMs, t + dwell);
      segments.add(DirectionSegment(startMs: t, endMs: end, direction: dir));
      t = end;
      if (t >= durationMs) break;
      // ~35% of direction changes are a straight reversal ("erratic"
      // target, spec §2.4-M), the rest turn to one of the other two axes.
      dir = rng.nextDouble() < 0.35
          ? dir.opposite
          : dir.others()[rng.nextInt(3)];
    }
    if (segments.isEmpty) {
      segments.add(
        DirectionSegment(startMs: 0, endMs: durationMs, direction: dir),
      );
    }
    return segments;
  }

  static List<_Waypoint> _buildWaypoints(
    List<DirectionSegment> directions, {
    required double speedScale,
  }) {
    // Fraction of the [0,1] arena crossed per millisecond at speedScale 1.
    const baseSpeedPerMs = 1 / 4000;
    final speed = baseSpeedPerMs * (speedScale <= 0 ? 0.01 : speedScale);
    var x = 0.5, y = 0.5;
    final waypoints = <_Waypoint>[_Waypoint(0, x, y)];
    for (final segment in directions) {
      final (dx, dy) = segment.direction.delta;
      final dt = segment.endMs - segment.startMs;
      final dist = speed * dt;
      x = _clampUnit(x + dx * dist);
      y = _clampUnit(y + dy * dist);
      waypoints.add(_Waypoint(segment.endMs, x, y));
    }
    return waypoints;
  }

  static List<ShapeEvent> _buildShapeEvents(
    Random rng,
    int durationMs, {
    required StimulusShape referenceShape,
    required double targetRatio,
    required int averageIntervalMs,
  }) {
    final events = <ShapeEvent>[];
    final others = StimulusShape.values
        .where((s) => s != referenceShape)
        .toList(growable: false);
    var t = 0;
    final minIntervalMs = max(300, (averageIntervalMs * 0.5).round());
    while (t < durationMs) {
      final len = _jitter(rng, averageIntervalMs, minIntervalMs);
      final end = min(durationMs, t + len);
      final isTarget = rng.nextDouble() < targetRatio;
      final shape = isTarget
          ? referenceShape
          : others[rng.nextInt(others.length)];
      events.add(
        ShapeEvent(startMs: t, endMs: end, shape: shape, isTarget: isTarget),
      );
      t = end;
    }
    if (events.isEmpty) {
      events.add(
        ShapeEvent(
          startMs: 0,
          endMs: durationMs,
          shape: referenceShape,
          isTarget: true,
        ),
      );
    }
    return events;
  }

  static List<CalcEvent> _buildCalcEvents(
    Random rng,
    int durationMs, {
    required double wrongRatio,
    required int averageIntervalMs,
  }) {
    const ops = ['+', '-', '×'];
    final events = <CalcEvent>[];
    var t = 0;
    final minIntervalMs = max(500, (averageIntervalMs * 0.5).round());
    while (t < durationMs) {
      final len = _jitter(rng, averageIntervalMs, minIntervalMs);
      final end = min(durationMs, t + len);
      final op = ops[rng.nextInt(ops.length)];
      final a = 1 + rng.nextInt(9);
      final b = 1 + rng.nextInt(9);
      final real = switch (op) {
        '+' => a + b,
        '-' => a - b,
        _ => a * b,
      };
      final isWrong = rng.nextDouble() < wrongRatio;
      final delta = isWrong
          ? (1 + rng.nextInt(3)) * (rng.nextBool() ? 1 : -1)
          : 0;
      events.add(
        CalcEvent(
          startMs: t,
          endMs: end,
          a: a,
          op: op,
          b: b,
          shown: real + delta,
          isWrong: isWrong,
        ),
      );
      t = end;
    }
    if (events.isEmpty) {
      events.add(
        const CalcEvent(
          startMs: 0,
          endMs: 0,
          a: 1,
          op: '+',
          b: 1,
          shown: 2,
          isWrong: false,
        ),
      );
    }
    return events;
  }

  /// +/-25% jitter around [averageMs], never under [minMs].
  static int _jitter(Random rng, int averageMs, int minMs) =>
      max(minMs, (averageMs * (0.75 + 0.5 * rng.nextDouble())).round());

  static double _clampUnit(double v) => v < 0.0 ? 0.0 : (v > 1.0 ? 1.0 : v);
}
