import 'dart:math' as math;

import 'multitask_simulation.dart';
import 'multitask_track.dart';

/// One period during which the candidate held [direction] (a single arrow
/// key), from [startMs] to [endMs]; built by the renderer from key
/// down/up events timestamped against the run's own clock (ms since the
/// simulation started). Intervals never overlap: holding a second arrow
/// closes the previous one (see `MultitaskRenderer`).
class HeldInterval {
  const HeldInterval({
    required this.startMs,
    required this.endMs,
    required this.direction,
  });

  final int startMs;
  final int endMs;
  final TrackDirection direction;
}

/// Raw counts the combined score and `ItemResult.metrics` are built from
/// (spec §2.4-M: tracking error (RMS), shape hit/miss/false-alarm,
/// calculation hit/miss/false-alarm). Everything here is a plain number so
/// it round-trips through `Answer.raw`'s JSON payload untouched.
class MultitaskMetrics {
  const MultitaskMetrics({
    required this.totalMs,
    required this.trackingErrorMs,
    required this.shapeHits,
    required this.shapeMisses,
    required this.shapeFalseAlarms,
    required this.calcHits,
    required this.calcMisses,
    required this.calcFalseAlarms,
  });

  /// Total duration scored (ms); 0 only for a degenerate (0 s) run.
  final int totalMs;

  /// Sum, over the whole run, of the milliseconds during which the held
  /// arrow did not match the target's current direction (no arrow held
  /// counts as a mismatch). `trackingRmsError` is the RMS of that binary
  /// (0/1) mismatch signal, time-weighted rather than sampled at a fixed
  /// tick rate, so it does not depend on the renderer's frame rate.
  final int trackingErrorMs;

  final int shapeHits;
  final int shapeMisses;
  final int shapeFalseAlarms;
  final int calcHits;
  final int calcMisses;
  final int calcFalseAlarms;

  /// RMS tracking error in `[0, 1]`: `sqrt(mismatchMs / totalMs)`, 0 when
  /// [totalMs] is 0.
  double get trackingRmsError =>
      totalMs <= 0 ? 0 : math.sqrt(trackingErrorMs / totalMs);

  double get trackingAccuracy {
    final v = 1 - trackingRmsError;
    return v < 0.0 ? 0.0 : (v > 1.0 ? 1.0 : v);
  }

  /// Hits over hits+misses+false-alarms; 1.0 when none of the three ever
  /// happened (no target shapes and no false alarms, which cannot happen
  /// with `shapeTargetRatio > 0` over a real run, but keeps the metric
  /// defined for a degenerate/test one).
  double get shapeAccuracy => _accuracy(shapeHits, shapeMisses, shapeFalseAlarms);

  double get calcAccuracy => _accuracy(calcHits, calcMisses, calcFalseAlarms);

  static double _accuracy(int hits, int misses, int falseAlarms) {
    final denom = hits + misses + falseAlarms;
    return denom == 0 ? 1.0 : hits / denom;
  }

  /// Equal-weight average of the three sub-scores (spec does not define a
  /// weighting; documented here and in the story's final report).
  double get combinedScore =>
      (trackingAccuracy + shapeAccuracy + calcAccuracy) / 3;

  /// `Answer.raw` payload (JSON-encodable values only).
  Map<String, Object?> toPayload() => {
    'totalMs': totalMs,
    'trackingErrorMs': trackingErrorMs,
    'shapeHits': shapeHits,
    'shapeMisses': shapeMisses,
    'shapeFalseAlarms': shapeFalseAlarms,
    'calcHits': calcHits,
    'calcMisses': calcMisses,
    'calcFalseAlarms': calcFalseAlarms,
  };

  factory MultitaskMetrics.fromPayload(Map<String, Object?> payload) =>
      MultitaskMetrics(
        totalMs: (payload['totalMs'] as num?)?.toInt() ?? 0,
        trackingErrorMs: (payload['trackingErrorMs'] as num?)?.toInt() ?? 0,
        shapeHits: (payload['shapeHits'] as num?)?.toInt() ?? 0,
        shapeMisses: (payload['shapeMisses'] as num?)?.toInt() ?? 0,
        shapeFalseAlarms: (payload['shapeFalseAlarms'] as num?)?.toInt() ?? 0,
        calcHits: (payload['calcHits'] as num?)?.toInt() ?? 0,
        calcMisses: (payload['calcMisses'] as num?)?.toInt() ?? 0,
        calcFalseAlarms: (payload['calcFalseAlarms'] as num?)?.toInt() ?? 0,
      );

  /// `ItemResult.metrics` (summed into `SectionResult.metricTotals`).
  Map<String, num> toItemMetrics() => {
    MultitaskMetricKeys.trackingRmsError: trackingRmsError,
    MultitaskMetricKeys.shapeHits: shapeHits,
    MultitaskMetricKeys.shapeMisses: shapeMisses,
    MultitaskMetricKeys.shapeFalseAlarms: shapeFalseAlarms,
    MultitaskMetricKeys.calcHits: calcHits,
    MultitaskMetricKeys.calcMisses: calcMisses,
    MultitaskMetricKeys.calcFalseAlarms: calcFalseAlarms,
    MultitaskMetricKeys.combinedScore: combinedScore,
  };
}

/// Names of the metrics in `ItemResult.metrics`/`SectionResult.metricTotals`.
abstract final class MultitaskMetricKeys {
  static const String trackingRmsError = 'trackingRmsError';
  static const String shapeHits = 'shapeHits';
  static const String shapeMisses = 'shapeMisses';
  static const String shapeFalseAlarms = 'shapeFalseAlarms';
  static const String calcHits = 'calcHits';
  static const String calcMisses = 'calcMisses';
  static const String calcFalseAlarms = 'calcFalseAlarms';
  static const String combinedScore = 'combinedScore';
}

/// Scores one run against its [MultitaskSimulation]: pure and independent of
/// how the input log was captured (a live keyboard, or -- in tests -- a
/// synthetic list of intervals/timestamps), so "does the scorer read the
/// event windows right" is testable without a widget.
abstract final class MultitaskScoring {
  /// Combined score at or above which the run counts as correct. Not a
  /// `MultitaskParams` field (params are the generator's contract,
  /// CONTRACT.md §3); kept here as the one place that defines "pass" for
  /// this activity. See the story's final report for whether this should
  /// move into params instead.
  static const double correctThreshold = 0.6;

  static bool isCorrect(MultitaskMetrics metrics) =>
      metrics.combinedScore >= correctThreshold;

  /// Builds the [MultitaskMetrics] of one run: [heldIntervals] the arrow
  /// held over time, [shapePressMs]/[calcPressMs] the SPACE/F key-down
  /// timestamps (ms since the run started).
  static MultitaskMetrics evaluate(
    MultitaskSimulation simulation, {
    List<HeldInterval> heldIntervals = const [],
    List<int> shapePressMs = const [],
    List<int> calcPressMs = const [],
  }) {
    final trackingErrorMs = _trackingErrorMs(simulation, heldIntervals);
    var shapeHits = 0, shapeMisses = 0, shapeFalseAlarms = 0;
    for (final event in simulation.shapeEvents) {
      final pressed = shapePressMs.any(
        (ms) => ms >= event.startMs && ms < event.endMs,
      );
      if (event.isTarget) {
        pressed ? shapeHits++ : shapeMisses++;
      } else if (pressed) {
        shapeFalseAlarms++;
      }
    }
    var calcHits = 0, calcMisses = 0, calcFalseAlarms = 0;
    for (final event in simulation.calcEvents) {
      final pressed = calcPressMs.any(
        (ms) => ms >= event.startMs && ms < event.endMs,
      );
      if (event.isWrong) {
        pressed ? calcHits++ : calcMisses++;
      } else if (pressed) {
        calcFalseAlarms++;
      }
    }
    return MultitaskMetrics(
      totalMs: simulation.durationMs,
      trackingErrorMs: trackingErrorMs,
      shapeHits: shapeHits,
      shapeMisses: shapeMisses,
      shapeFalseAlarms: shapeFalseAlarms,
      calcHits: calcHits,
      calcMisses: calcMisses,
      calcFalseAlarms: calcFalseAlarms,
    );
  }

  static int _trackingErrorMs(
    MultitaskSimulation simulation,
    List<HeldInterval> heldIntervals,
  ) {
    final boundaries = <int>{0, simulation.durationMs};
    for (final segment in simulation.directions) {
      boundaries..add(segment.startMs)..add(segment.endMs);
    }
    for (final held in heldIntervals) {
      boundaries..add(held.startMs)..add(held.endMs);
    }
    final sorted = boundaries.where((ms) => ms >= 0 && ms <= simulation.durationMs).toList()
      ..sort();
    var errorMs = 0;
    for (var i = 0; i + 1 < sorted.length; i++) {
      final start = sorted[i];
      final end = sorted[i + 1];
      if (end <= start) continue;
      final mid = start + (end - start) ~/ 2;
      final target = simulation.directionAt(mid);
      final held = _heldAt(heldIntervals, mid);
      if (held != target) errorMs += end - start;
    }
    return errorMs;
  }

  static TrackDirection? _heldAt(List<HeldInterval> heldIntervals, int ms) {
    for (final held in heldIntervals) {
      if (ms >= held.startMs && ms < held.endMs) return held.direction;
    }
    return null;
  }
}
