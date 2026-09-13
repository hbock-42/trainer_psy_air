import 'dart:math';

import 'p1_psychomotor_channels.dart';
import 'p1_psychomotor_control.dart';
import 'p1_psychomotor_input.dart';
import 'p1_psychomotor_simulation.dart';

/// The first channel a red-zone drop was recorded on, and when (spec §2.2:
/// "record the time and channel").
class P1PsychomotorRedZoneTrigger {
  const P1PsychomotorRedZoneTrigger({
    required this.channel,
    required this.atMs,
  });

  final P1PsychomotorChannel channel;
  final int atMs;
}

/// The live, user-driven half of one run: everything [P1PsychomotorSimulation]
/// cannot precompute because it depends on what the candidate actually did
/// (gauge displacement after correction, the tracking cursor, hit/miss
/// counts). One instance is built per run (keyed by `runSeed` — see the
/// renderer, which must survive the widget being torn down and rebuilt
/// between the run's 6 phase-items) and [tick] is called every animation
/// frame with that frame's [P1PsychomotorTickInput] and the phase's active
/// channel set (`P1PsychomotorPhaseSchedule`).
///
/// Exponential smoothing (time constant [_scoreSmoothingSec]) is applied to
/// the two continuous channels (gauges, tracking) before their score is
/// compared to the red zone, so a single noisy frame cannot trigger the
/// zeroing rule — only a *sustained* drop does, matching the spec's framing
/// of "keep all 4 balls in the air" rather than a hair-trigger. Letters and
/// arithmetic are already event-quantised (a hit either happened or it
/// didn't) so their accuracy is a plain cumulative ratio, not smoothed.
class P1PsychomotorRunState {
  P1PsychomotorRunState(this.simulation);

  final P1PsychomotorSimulation simulation;

  static const double _scoreSmoothingSec = 0.5;

  /// Distance beyond which the tracking channel scores 0 (the tracking
  /// arena is a unit circle; the target itself never sits further than
  /// ~0.85 from the origin, so a cursor left untouched at the origin still
  /// only scores ~30, not 0 — enough slack that a brief lapse is
  /// recoverable, per the "no channel can be perfectly ignored, but a
  /// glance away is not instant death" reading of the spec).
  static const double _trackingFullScaleDistance = 1.2;

  final List<double> gaugeDisplacement = List<double>.filled(
    p1PsychomotorGaugeCount,
    0,
  );
  int selectedGauge = 0;

  double cursorX = 0;
  double cursorY = 0;

  int _lastMs = 0;

  final Map<P1PsychomotorChannel, double> _score = {
    for (final c in P1PsychomotorChannel.values) c: 100,
  };

  P1PsychomotorRedZoneTrigger? redZoneTrigger;

  // Letters.
  int letterHits = 0;
  int letterMisses = 0;
  int letterFalseAlarms = 0;
  int? _letterWaveActivatedStartMs;
  int _currentWaveStartMs = -1;
  final Set<int> _letterRespondedPositions = {};

  // Arithmetic.
  int arithmeticCorrect = 0;
  int arithmeticIncorrect = 0;
  int arithmeticMissed = 0;
  int? _arithmeticActivatedStartMs;
  int _currentProblemStartMs = -1;
  bool _currentProblemAnswered = false;

  double scoreOf(P1PsychomotorChannel channel) => _score[channel]!;

  /// `null` when no channel has ever dropped into its red zone; otherwise
  /// 0 (spec §2.2's zeroing rule, permanent for the rest of the run once
  /// tripped — "keep all 4 balls in the air, permanently").
  double get combinedScore {
    if (redZoneTrigger != null) return 0;
    const active = P1PsychomotorChannel.values;
    final sum = active.fold<double>(0, (s, c) => s + _score[c]!);
    return sum / active.length;
  }

  bool get isAlive => redZoneTrigger == null;

  /// Advances the simulation by one frame to [nowMs] (ms since the run —
  /// not the phase — started) with [input] and the phase's
  /// [activeChannels]. Idempotent-safe to call with the same [nowMs] twice
  /// (a 0-length step does nothing).
  void tick({
    required int nowMs,
    required P1PsychomotorTickInput input,
    required Set<P1PsychomotorChannel> activeChannels,
  }) {
    final dtSec = (nowMs - _lastMs) / 1000.0;
    _lastMs = nowMs;
    if (dtSec <= 0) return;

    if (activeChannels.contains(P1PsychomotorChannel.gauges)) {
      _tickGauges(nowMs: nowMs, input: input, dtSec: dtSec);
    }
    if (activeChannels.contains(P1PsychomotorChannel.tracking)) {
      _tickTracking(nowMs: nowMs, input: input, dtSec: dtSec);
    }
    if (activeChannels.contains(P1PsychomotorChannel.letters)) {
      _tickLetters(nowMs);
    }
    if (activeChannels.contains(P1PsychomotorChannel.arithmetic)) {
      _tickArithmetic(nowMs);
    }

    for (final channel in activeChannels) {
      if (_score[channel]! < P1PsychomotorScoring.redZoneThreshold) {
        redZoneTrigger ??= P1PsychomotorRedZoneTrigger(
          channel: channel,
          atMs: nowMs,
        );
      }
    }
  }

  void _tickGauges({
    required int nowMs,
    required P1PsychomotorTickInput input,
    required double dtSec,
  }) {
    if (input.selectNextGauge) {
      selectedGauge = (selectedGauge + 1) % p1PsychomotorGaugeCount;
    } else if (input.selectPrevGauge) {
      selectedGauge =
          (selectedGauge - 1 + p1PsychomotorGaugeCount) %
          p1PsychomotorGaugeCount;
    }
    for (var i = 0; i < p1PsychomotorGaugeCount; i++) {
      final natural = simulation.gaugeNaturalVelocityAt(i, nowMs);
      gaugeDisplacement[i] = P1PsychomotorControl.gaugeStep(
        displacement: gaugeDisplacement[i],
        naturalVelocity: natural,
        selected: i == selectedGauge,
        stickY: input.leftStickY,
        dtSec: dtSec,
      );
    }
    final worst = gaugeDisplacement.map((d) => d.abs()).reduce(max);
    _smooth(
      P1PsychomotorChannel.gauges,
      100 * (1 - worst).clamp(0.0, 1.0),
      dtSec,
    );
  }

  void _tickTracking({
    required int nowMs,
    required P1PsychomotorTickInput input,
    required double dtSec,
  }) {
    final (nx, ny) = P1PsychomotorControl.crosshairStep(
      x: cursorX,
      y: cursorY,
      stickX: input.rightStickX,
      stickY: input.rightStickY,
      dtSec: dtSec,
    );
    cursorX = nx;
    cursorY = ny;
    final (tx, ty) = simulation.targetPositionAt(nowMs);
    final distance = sqrt(pow(cursorX - tx, 2) + pow(cursorY - ty, 2));
    final instant =
        100 * (1 - (distance / _trackingFullScaleDistance)).clamp(0.0, 1.0);
    _smooth(P1PsychomotorChannel.tracking, instant, dtSec);
  }

  void _smooth(P1PsychomotorChannel channel, double instant, double dtSec) {
    final prev = _score[channel]!;
    final alpha = (dtSec / _scoreSmoothingSec).clamp(0.0, 1.0);
    _score[channel] = prev + (instant - prev) * alpha;
  }

  void _tickLetters(int nowMs) {
    _letterWaveActivatedStartMs ??= simulation.letterWaveAt(nowMs).startMs;
    final wave = simulation.letterWaveAt(nowMs);
    if (wave.startMs != _currentWaveStartMs) {
      if (_currentWaveStartMs >= (_letterWaveActivatedStartMs ?? 0)) {
        _finalizeLetterWave();
      }
      _currentWaveStartMs = wave.startMs;
      _letterRespondedPositions.clear();
    }
    _score[P1PsychomotorChannel.letters] =
        100 * _accuracy(letterHits, letterMisses, letterFalseAlarms);
  }

  void _finalizeLetterWave() {
    final wave = simulation.letterWaveAt(_currentWaveStartMs);
    for (final position in wave.targetPositions) {
      if (!_letterRespondedPositions.contains(position)) {
        letterMisses++;
      }
    }
  }

  /// The renderer calls this on an F-key press; [position] is 0-8 (F1..F9).
  void registerLetterPress(int position, int nowMs) {
    if (_letterWaveActivatedStartMs == null) return;
    final wave = simulation.letterWaveAt(nowMs);
    if (wave.startMs != _currentWaveStartMs) return; // stale/late input
    if (_letterRespondedPositions.contains(position)) return;
    _letterRespondedPositions.add(position);
    if (wave.isTarget(position)) {
      letterHits++;
    } else {
      letterFalseAlarms++;
    }
    _score[P1PsychomotorChannel.letters] =
        100 * _accuracy(letterHits, letterMisses, letterFalseAlarms);
  }

  void _tickArithmetic(int nowMs) {
    _arithmeticActivatedStartMs ??= simulation
        .arithmeticProblemAt(nowMs)
        .startMs;
    final problem = simulation.arithmeticProblemAt(nowMs);
    if (problem.startMs != _currentProblemStartMs) {
      if (_currentProblemStartMs >= (_arithmeticActivatedStartMs ?? 0) &&
          !_currentProblemAnswered) {
        arithmeticMissed++;
      }
      _currentProblemStartMs = problem.startMs;
      _currentProblemAnswered = false;
    }
    _score[P1PsychomotorChannel.arithmetic] =
        100 *
        _accuracy(arithmeticCorrect, arithmeticIncorrect + arithmeticMissed, 0);
  }

  /// The renderer calls this once the candidate presses Enter on the
  /// numpad; ignored once the current problem already has an answer.
  void submitArithmeticAnswer(int value, int nowMs) {
    if (_arithmeticActivatedStartMs == null) return;
    final problem = simulation.arithmeticProblemAt(nowMs);
    if (problem.startMs != _currentProblemStartMs || _currentProblemAnswered) {
      return;
    }
    _currentProblemAnswered = true;
    if (value == problem.answer) {
      arithmeticCorrect++;
    } else {
      arithmeticIncorrect++;
    }
    _score[P1PsychomotorChannel.arithmetic] =
        100 *
        _accuracy(arithmeticCorrect, arithmeticIncorrect + arithmeticMissed, 0);
  }

  static double _accuracy(int hits, int misses, int falseAlarms) {
    final denom = hits + misses + falseAlarms;
    return denom == 0 ? 1.0 : hits / denom;
  }
}
