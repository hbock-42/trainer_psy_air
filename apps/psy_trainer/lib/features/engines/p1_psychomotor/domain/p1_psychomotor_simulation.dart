import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// Number of gauges the left stick/thumb buttons manage (spec §2.3 row 13:
/// "4 randomly-drifting gauges").
const int p1PsychomotorGaugeCount = 4;

/// Letters shown per wave and how many of them are targets (spec: "3 target
/// letters ... among a 9-letter display").
const int p1PsychomotorLetterCount = 9;
const int p1PsychomotorTargetLetterCount = 3;

/// One interval during which gauge [index]'s autonomous (no-user-input)
/// drift velocity is [velocity] (units of normalised displacement per
/// second; positive drifts toward `+1`, negative toward `-1`).
class GaugeDriftSegment {
  const GaugeDriftSegment({
    required this.startMs,
    required this.endMs,
    required this.velocity,
  });

  final int startMs;
  final int endMs;
  final double velocity;
}

/// One waypoint of the crosshair's autonomous target path (the object the
/// candidate must keep the stick-controlled cursor aligned with), in a
/// normalised `[-1, 1] x [-1, 1]` arena (the tracking circle).
class TargetWaypoint {
  const TargetWaypoint(this.ms, this.x, this.y);

  final int ms;
  final double x;
  final double y;
}

/// One "wave" of the letter-cancellation channel: [letters] (length
/// [p1PsychomotorLetterCount]) is shown for `[startMs, endMs)`;
/// [targetPositions] (size [p1PsychomotorTargetLetterCount], 0-indexed into
/// [letters]) are the ones F1-F9 should cancel this wave.
class LetterWave {
  const LetterWave({
    required this.startMs,
    required this.endMs,
    required this.letters,
    required this.targetPositions,
  });

  final int startMs;
  final int endMs;
  final List<String> letters;
  final Set<int> targetPositions;

  bool isTarget(int position) => targetPositions.contains(position);
}

/// One arithmetic problem shown for `[startMs, endMs)` (spec: "a fresh
/// addition/subtraction problem every 12 s").
class ArithmeticProblem {
  const ArithmeticProblem({
    required this.startMs,
    required this.endMs,
    required this.a,
    required this.op,
    required this.b,
  });

  final int startMs;
  final int endMs;
  final int a;
  final String op;
  final int b;

  int get answer => op == '+' ? a + b : a - b;
}

/// The whole run's autonomous timeline (US-102, spec §2.3 row 13), built
/// once, deterministically, from `(runSeed, params, difficulty)` — the
/// "engine-owned data derived again from the seed" pattern of
/// `dominos`/`attention_rules`/`MultitaskSimulation`. Only the pieces that
/// do **not** depend on live user input live here: each gauge's natural
/// drift velocity, the tracking target's path, the letter waves and the
/// arithmetic stream. Live, user-driven state (gauge displacement after
/// correction, the cursor position, hit/miss counts) is
/// [P1PsychomotorRunState]'s job, built from this timeline.
///
/// Built once for the **whole** run (every phase shares one instance,
/// queried at `phaseIndex * phaseDurationMs + localElapsedMs`): a phase
/// boundary is a scoring/UI checkpoint, not a reset of the underlying
/// simulation (spec: the six phases are one continuous 18-minute test).
///
/// Difficulty (1-5, blueprint plays 2-4) scales event rate/noise:
/// `scale(difficulty) = 1 + 0.15 * (difficulty - 3)`, mirroring
/// `MultitaskSimulation.scaleFor` — not spec'd more precisely than "harder
/// difficulty, more demanding channels", flagged in the story's report.
class P1PsychomotorSimulation {
  P1PsychomotorSimulation._({
    required this.durationMs,
    required List<List<GaugeDriftSegment>> gaugeDrift,
    required List<TargetWaypoint> targetWaypoints,
    required this.letterWaves,
    required this.arithmeticProblems,
  }) : _gaugeDrift = gaugeDrift,
       _targetWaypoints = targetWaypoints;

  final int durationMs;
  final List<List<GaugeDriftSegment>> _gaugeDrift;
  final List<TargetWaypoint> _targetWaypoints;
  final List<LetterWave> letterWaves;
  final List<ArithmeticProblem> arithmeticProblems;

  static double scaleFor(int difficulty) => 1 + 0.15 * (difficulty - 3);

  factory P1PsychomotorSimulation.build({
    required int runSeed,
    required P1PsychomotorParams params,
    required int difficulty,
  }) {
    final rng = Random(runSeed);
    final scale = scaleFor(difficulty);
    final durationMs = params.phaseCount * params.phaseDurationSec * 1000;

    final gaugeDrift = List.generate(
      p1PsychomotorGaugeCount,
      (_) => _buildGaugeDrift(rng, durationMs, noiseScale: scale),
    );
    final targetWaypoints = _buildTargetWaypoints(
      rng,
      durationMs,
      speedScale: scale,
    );
    final letterWaves = _buildLetterWaves(rng, durationMs, rateScale: scale);
    final arithmeticProblems = _buildArithmeticProblems(
      rng,
      durationMs,
      intervalMs: params.calcIntervalSec * 1000,
    );

    return P1PsychomotorSimulation._(
      durationMs: durationMs,
      gaugeDrift: gaugeDrift,
      targetWaypoints: targetWaypoints,
      letterWaves: letterWaves,
      arithmeticProblems: arithmeticProblems,
    );
  }

  double gaugeNaturalVelocityAt(int gaugeIndex, int ms) =>
      _slotAt(_gaugeDrift[gaugeIndex], ms, (s) => s.startMs).velocity;

  /// Normalised `(x, y)` of the tracking target at [ms], linearly
  /// interpolated between direction-change waypoints (same technique as
  /// `MultitaskSimulation.positionAt`).
  (double, double) targetPositionAt(int ms) {
    final t = ms.clamp(0, durationMs);
    var i = 0;
    while (i + 1 < _targetWaypoints.length && _targetWaypoints[i + 1].ms <= t) {
      i++;
    }
    final a = _targetWaypoints[i];
    final b = i + 1 < _targetWaypoints.length ? _targetWaypoints[i + 1] : a;
    if (b.ms == a.ms) return (a.x, a.y);
    final f = (t - a.ms) / (b.ms - a.ms);
    return (a.x + (b.x - a.x) * f, a.y + (b.y - a.y) * f);
  }

  LetterWave letterWaveAt(int ms) => _slotAt(letterWaves, ms, (w) => w.startMs);

  ArithmeticProblem arithmeticProblemAt(int ms) =>
      _slotAt(arithmeticProblems, ms, (p) => p.startMs);

  static T _slotAt<T>(List<T> slots, int ms, int Function(T) startOf) {
    for (var i = slots.length - 1; i >= 0; i--) {
      if (ms >= startOf(slots[i])) return slots[i];
    }
    return slots.first;
  }

  static List<GaugeDriftSegment> _buildGaugeDrift(
    Random rng,
    int durationMs, {
    required double noiseScale,
  }) {
    final segments = <GaugeDriftSegment>[];
    var t = 0;
    const baseDwellMs = 1400;
    while (t < durationMs) {
      final maxDwell = durationMs == 0 ? 150 : durationMs;
      var dwell = (baseDwellMs * (0.6 + rng.nextDouble() * 0.8)).round();
      if (dwell < 200) dwell = 200;
      if (dwell > maxDwell) dwell = maxDwell;
      final end = min(durationMs, t + dwell);
      // Velocity in [-0.35, 0.35] normalised units/sec at scale 1, so an
      // unattended gauge reaches the red zone in a handful of seconds
      // (spec: gauges must be actively managed, not "set and forget").
      final velocity = (rng.nextDouble() * 2 - 1) * 0.35 * noiseScale;
      segments.add(
        GaugeDriftSegment(startMs: t, endMs: end, velocity: velocity),
      );
      t = end;
    }
    if (segments.isEmpty) {
      segments.add(
        GaugeDriftSegment(startMs: 0, endMs: durationMs, velocity: 0),
      );
    }
    return segments;
  }

  static List<TargetWaypoint> _buildTargetWaypoints(
    Random rng,
    int durationMs, {
    required double speedScale,
  }) {
    final waypoints = <TargetWaypoint>[const TargetWaypoint(0, 0, 0)];
    var t = 0;
    const baseDwellMs = 1500;
    var x = 0.0, y = 0.0;
    while (t < durationMs) {
      final maxDwell = durationMs == 0 ? 150 : durationMs;
      var dwell = (baseDwellMs * (0.5 + rng.nextDouble())).round();
      if (dwell < 200) dwell = 200;
      if (dwell > maxDwell) dwell = maxDwell;
      final end = min(durationMs, t + dwell);
      final angle = rng.nextDouble() * 2 * pi;
      // Stay within the tracking circle (radius 1): pick a point at 30-85%
      // of the radius from the origin so the target never needs the
      // cursor to sit exactly on the boundary.
      final radius = 0.3 + rng.nextDouble() * 0.55;
      x = cos(angle) * radius;
      y = sin(angle) * radius;
      waypoints.add(TargetWaypoint(end, x, y));
      t = end;
    }
    return waypoints;
  }

  static List<LetterWave> _buildLetterWaves(
    Random rng,
    int durationMs, {
    required double rateScale,
  }) {
    const alphabet = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z',
    ];
    final waves = <LetterWave>[];
    var t = 0;
    final averageIntervalMs = (2600 / rateScale).round();
    final minIntervalMs = max(900, (averageIntervalMs * 0.5).round());
    while (t < durationMs) {
      final len = max(
        minIntervalMs,
        (averageIntervalMs * (0.75 + 0.5 * rng.nextDouble())).round(),
      );
      final end = min(durationMs, t + len);
      final letters = List.generate(
        p1PsychomotorLetterCount,
        (_) => alphabet[rng.nextInt(alphabet.length)],
      );
      final targets = <int>{};
      while (targets.length < p1PsychomotorTargetLetterCount) {
        targets.add(rng.nextInt(p1PsychomotorLetterCount));
      }
      waves.add(
        LetterWave(
          startMs: t,
          endMs: end,
          letters: letters,
          targetPositions: targets,
        ),
      );
      t = end;
    }
    if (waves.isEmpty) {
      waves.add(
        LetterWave(
          startMs: 0,
          endMs: durationMs,
          letters: List.filled(p1PsychomotorLetterCount, 'A'),
          targetPositions: const {0, 1, 2},
        ),
      );
    }
    return waves;
  }

  static List<ArithmeticProblem> _buildArithmeticProblems(
    Random rng,
    int durationMs, {
    required int intervalMs,
  }) {
    final problems = <ArithmeticProblem>[];
    final step = intervalMs <= 0 ? 12000 : intervalMs;
    var t = 0;
    while (t < durationMs || problems.isEmpty) {
      final end = min(durationMs, t + step);
      final op = rng.nextBool() ? '+' : '-';
      final a = 10 + rng.nextInt(80);
      final b = 1 + rng.nextInt(op == '-' ? a - 1 : 89).clamp(1, 89);
      problems.add(
        ArithmeticProblem(startMs: t, endMs: end, a: a, op: op, b: b),
      );
      if (end >= durationMs) break;
      t = end;
    }
    return problems;
  }
}
