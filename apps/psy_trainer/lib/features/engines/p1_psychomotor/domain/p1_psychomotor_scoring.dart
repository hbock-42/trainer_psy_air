import 'p1_psychomotor_channels.dart';
import 'p1_psychomotor_run_state.dart';

/// One phase's outcome, extracted from a [P1PsychomotorRunState] at the
/// moment that phase ends: each channel's score at that instant, the
/// cumulative event counts, and whether the zeroing rule has fired by then
/// (spec §2.2: "record the time and channel"). Round-trips through
/// `Answer.raw`'s JSON payload (see `toPayload`/`fromPayload`), the same
/// pattern as `multitask_psychomotor`'s `MultitaskMetrics`.
class P1PsychomotorMetrics {
  const P1PsychomotorMetrics({
    required this.gaugesScore,
    required this.trackingScore,
    required this.lettersScore,
    required this.arithmeticScore,
    required this.combinedScore,
    required this.letterHits,
    required this.letterMisses,
    required this.letterFalseAlarms,
    required this.arithmeticCorrect,
    required this.arithmeticIncorrect,
    required this.arithmeticMissed,
    this.redZoneChannel,
    this.redZoneAtMs,
  });

  final double gaugesScore;
  final double trackingScore;
  final double lettersScore;
  final double arithmeticScore;
  final double combinedScore;

  final int letterHits;
  final int letterMisses;
  final int letterFalseAlarms;
  final int arithmeticCorrect;
  final int arithmeticIncorrect;
  final int arithmeticMissed;

  /// Null until the first channel ever drops into its red zone (in this
  /// run, not just this phase) — once set it stays set for every later
  /// phase of the same run (the zeroing rule is permanent).
  final P1PsychomotorChannel? redZoneChannel;
  final int? redZoneAtMs;

  bool get isZeroed => redZoneChannel != null;

  factory P1PsychomotorMetrics.fromRunState(P1PsychomotorRunState state) {
    final trigger = state.redZoneTrigger;
    return P1PsychomotorMetrics(
      gaugesScore: state.scoreOf(P1PsychomotorChannel.gauges),
      trackingScore: state.scoreOf(P1PsychomotorChannel.tracking),
      lettersScore: state.scoreOf(P1PsychomotorChannel.letters),
      arithmeticScore: state.scoreOf(P1PsychomotorChannel.arithmetic),
      combinedScore: state.combinedScore,
      letterHits: state.letterHits,
      letterMisses: state.letterMisses,
      letterFalseAlarms: state.letterFalseAlarms,
      arithmeticCorrect: state.arithmeticCorrect,
      arithmeticIncorrect: state.arithmeticIncorrect,
      arithmeticMissed: state.arithmeticMissed,
      redZoneChannel: trigger?.channel,
      redZoneAtMs: trigger?.atMs,
    );
  }

  Map<String, Object?> toPayload() => {
    'gaugesScore': gaugesScore,
    'trackingScore': trackingScore,
    'lettersScore': lettersScore,
    'arithmeticScore': arithmeticScore,
    'combinedScore': combinedScore,
    'letterHits': letterHits,
    'letterMisses': letterMisses,
    'letterFalseAlarms': letterFalseAlarms,
    'arithmeticCorrect': arithmeticCorrect,
    'arithmeticIncorrect': arithmeticIncorrect,
    'arithmeticMissed': arithmeticMissed,
    'redZoneChannel': redZoneChannel?.name,
    'redZoneAtMs': redZoneAtMs,
  };

  factory P1PsychomotorMetrics.fromPayload(Map<String, Object?> payload) {
    double d(String key) => (payload[key] as num?)?.toDouble() ?? 0;
    int i(String key) => (payload[key] as num?)?.toInt() ?? 0;
    final channelName = payload['redZoneChannel'] as String?;
    return P1PsychomotorMetrics(
      gaugesScore: d('gaugesScore'),
      trackingScore: d('trackingScore'),
      lettersScore: d('lettersScore'),
      arithmeticScore: d('arithmeticScore'),
      combinedScore: d('combinedScore'),
      letterHits: i('letterHits'),
      letterMisses: i('letterMisses'),
      letterFalseAlarms: i('letterFalseAlarms'),
      arithmeticCorrect: i('arithmeticCorrect'),
      arithmeticIncorrect: i('arithmeticIncorrect'),
      arithmeticMissed: i('arithmeticMissed'),
      redZoneChannel: channelName == null
          ? null
          : P1PsychomotorChannel.values.byName(channelName),
      redZoneAtMs: (payload['redZoneAtMs'] as num?)?.toInt(),
    );
  }

  /// `ItemResult.metrics` (summed into `SectionResult.metricTotals`).
  Map<String, num> toItemMetrics() => {
    'gaugesScore': gaugesScore,
    'trackingScore': trackingScore,
    'lettersScore': lettersScore,
    'arithmeticScore': arithmeticScore,
    'combinedScore': combinedScore,
    'letterHits': letterHits,
    'letterMisses': letterMisses,
    'letterFalseAlarms': letterFalseAlarms,
    'arithmeticCorrect': arithmeticCorrect,
    'arithmeticIncorrect': arithmeticIncorrect,
    'arithmeticMissed': arithmeticMissed,
    'isZeroed': isZeroed ? 1 : 0,
  };
}

/// Scores one phase: correct when the run has not been zeroed by the time
/// the phase ends (spec §2.2's zeroing rule *is* the pass/fail criterion —
/// there is no separate "score high enough" bar once the run is alive,
/// unlike `MultitaskScoring.correctThreshold`, since the spec's own framing
/// is binary — "keep all 4 balls in the air" — not graded).
abstract final class P1PsychomotorScorer {
  static bool isCorrect(P1PsychomotorMetrics metrics) => !metrics.isZeroed;
}
