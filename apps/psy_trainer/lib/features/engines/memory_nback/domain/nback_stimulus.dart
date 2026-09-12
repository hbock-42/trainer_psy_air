import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// The role US-026 assigns to one materialised n-back stimulus.
enum NbackRole {
  /// One of the run's first `n` items: no real n-back reference exists yet
  /// (there is nothing at k-n), scored neutrally regardless of the answer
  /// (spec §2.4-A: "42 stimuli incl. 2 primers").
  primer,

  /// Truly equals the stimulus actually shown `n` steps earlier: the
  /// correct answer is "yes".
  target,

  /// A near miss (repeats the most recent stimulus, an `n-1` match, instead
  /// of the true `n`-back one): the correct answer is "no", but a
  /// plausible source of a false alarm (spec: "controlled lures, n±1
  /// matches").
  lure,

  /// Anything else: the correct answer is "no".
  filler,
}

/// One decoded n-back stimulus: what to display and the correct answer.
///
/// US-037 rework: the whole run is one continuous stream derived from the
/// shared `runSeed` ([NbackSequence]), so item k's target/lure/filler role
/// is checked against the value the run *actually* showed at `k-n`, not a
/// private per-item simulation (the US-026 workaround this class used to
/// carry a long doc-comment about; the runtime now passes every engine
/// `runSeed` + `index`, see `ActivityEngine.generate` and
/// `docs/ARCHITECTURE.md#engine`). [decode] recomputes the run from
/// `runSeed` and reads position [NbackSequence.values]`[index]`: still a
/// pure function of its inputs (same `(params, runSeed, index)`, same
/// result, unit-tested), still nothing stored on the item itself besides
/// `origin.runSeed`/`origin.index` (`NbackEngine.stimulusOf`).
class NbackStimulus {
  const NbackStimulus({
    required this.role,
    required this.value,
    required this.history,
  });

  final NbackRole role;

  /// Index into the active palette (`0..paletteSize-1`).
  final int value;

  /// The stream values immediately preceding this one, oldest first, up to
  /// `n` of them (fewer for a primer, which has no full `n`-item history
  /// yet); `history.first` is the n-back reference this stimulus was
  /// checked against once the history is exactly `n` long (every
  /// non-primer item), `history.last` the most recent one. Exposed so the
  /// practice UI can show a reference window next to the current stimulus
  /// (spec: "practice option ... history strip").
  final List<int> history;

  bool get isPrimer => role == NbackRole.primer;

  /// The correct answer is "yes" (ignored when [isPrimer]: primers are
  /// scored neutrally).
  bool get expectsYes => role == NbackRole.target;

  /// Decodes the stimulus at [index] of the run `(params, runSeed)`: same
  /// inputs, same result.
  static NbackStimulus decode(NbackParams params, int runSeed, int index) {
    final sequence = NbackSequence.build(params, runSeed, upTo: index + 1);
    final n = _clampN(params.n);
    final historyStart = (index - n).clamp(0, index);
    return NbackStimulus(
      role: sequence.roles[index],
      value: sequence.values[index],
      history: sequence.values.sublist(historyStart, index),
    );
  }

  static int _clampN(int n) => n < 1 ? 1 : n;
}

/// The whole run's stream of stimuli, derived once from `(params, runSeed)`
/// (US-037): every item of the run reads the same sequence, so item k's
/// target/lure/filler status reflects the value *actually* shown at
/// `k - n`, not a synthetic stand-in.
///
/// The first `n` items are primers (`params.primers` no longer drives how
/// many: the run needs at least `n` real values before a k-n reference
/// exists at all, so "first n items" is the only faithful choice -- kept
/// as the family's own "2 primers" default only insofar as the real-test
/// `n` is 2, spec §2.4-A). From item `n` on, each position rolls a role
/// against `targetRatio`/`lureRatio` (the remainder is a filler) and
/// derives its value from the stream already built:
/// - **target**: repeats `values[i - n]` exactly.
/// - **lure**: repeats the most recent value (`values[i - 1]`, an `n-1`
///   match), unless that coincides with the target value, in which case it
///   falls back to any other value.
/// - **filler**: any value other than `values[i - n]`.
class NbackSequence {
  const NbackSequence({required this.values, required this.roles});

  /// The stimulus shown at each position, in play order.
  final List<int> values;

  /// The role assigned at each position, in play order.
  final List<NbackRole> roles;

  /// Builds the run's stream from `(params, runSeed)`. [upTo] limits how
  /// many positions are computed (defaults to the whole run,
  /// `params.count`); [NbackStimulus.decode] only needs up to its own
  /// `index`, but the result is identical whatever [upTo] is, because each
  /// position depends only on earlier ones.
  factory NbackSequence.build(NbackParams params, int runSeed, {int? upTo}) {
    final rng = Random(runSeed);
    final paletteSize = params.paletteSize < 1 ? 1 : params.paletteSize;
    final n = NbackStimulus._clampN(params.n);
    final count = upTo ?? (params.count < 1 ? 1 : params.count);
    final values = <int>[];
    final roles = <NbackRole>[];
    for (var i = 0; i < count; i++) {
      if (i < n) {
        roles.add(NbackRole.primer);
        values.add(rng.nextInt(paletteSize));
        continue;
      }
      final target = values[i - n];
      final roll = rng.nextDouble();
      if (roll < params.targetRatio) {
        roles.add(NbackRole.target);
        values.add(target);
      } else if (roll < params.targetRatio + params.lureRatio) {
        roles.add(NbackRole.lure);
        values.add(_nearMiss(rng, paletteSize, values[i - 1], target));
      } else {
        roles.add(NbackRole.filler);
        values.add(_differentFrom(rng, paletteSize, target));
      }
    }
    return NbackSequence(values: values, roles: roles);
  }

  /// Repeats the most recent stimulus ([recent], an `n-1` match) unless it
  /// coincides with the true n-back [target] (short runs, `n == 1`), in
  /// which case it falls back to any other value.
  static int _nearMiss(Random rng, int paletteSize, int recent, int target) {
    if (recent != target || paletteSize <= 1) return recent;
    return _differentFrom(rng, paletteSize, recent);
  }

  static int _differentFrom(Random rng, int paletteSize, int excluded) {
    if (paletteSize <= 1) return 0;
    var candidate = rng.nextInt(paletteSize);
    while (candidate == excluded) {
      candidate = rng.nextInt(paletteSize);
    }
    return candidate;
  }
}

/// Signal-detection metric names summed into `SectionResult.metricTotals`
/// by every `ItemResult` `NbackEngine.score` returns (spec: "hits, misses,
/// false alarms" + timeouts the runtime already counts separately).
abstract final class NbackMetrics {
  static const String hits = 'nbackHits';
  static const String misses = 'nbackMisses';
  static const String falseAlarms = 'nbackFalseAlarms';
  static const String correctRejections = 'nbackCorrectRejections';
  static const String primers = 'nbackPrimers';
}

/// d'-like sensitivity (Stanislaw & Todorov 1999; the `+0.5`/`+1` correction
/// keeps 0 %/100 % rates finite): `z(hit rate) - z(false-alarm rate)`.
/// Higher means the player discriminates targets from non-targets better;
/// a session summary reads it from `SectionResult.metricTotals`
/// (`NbackMetrics.hits`, etc.) once US-052 wires the practice summary.
double nbackSensitivity({
  required int hits,
  required int misses,
  required int falseAlarms,
  required int correctRejections,
}) {
  final signalCount = hits + misses;
  final noiseCount = falseAlarms + correctRejections;
  final hitRate = signalCount == 0 ? 0.5 : (hits + 0.5) / (signalCount + 1);
  final falseAlarmRate = noiseCount == 0
      ? 0.5
      : (falseAlarms + 0.5) / (noiseCount + 1);
  return _zScore(hitRate) - _zScore(falseAlarmRate);
}

/// Inverse standard-normal CDF, Abramowitz & Stegun 26.2.23: accurate to
/// about 4.5e-4, plenty for a d' figure shown to one decimal place.
double _zScore(double p) {
  final clamped = p.clamp(1e-9, 1 - 1e-9);
  final upperHalf = clamped > 0.5;
  final q = upperHalf ? 1 - clamped : clamped;
  final t = sqrt(-2 * log(q));
  const c0 = 2.515517;
  const c1 = 0.802853;
  const c2 = 0.010328;
  const d1 = 1.432788;
  const d2 = 0.189269;
  const d3 = 0.001308;
  final numerator = c0 + c1 * t + c2 * t * t;
  final denominator = 1 + d1 * t + d2 * t * t + d3 * t * t * t;
  final z = t - numerator / denominator;
  return upperHalf ? z : -z;
}
