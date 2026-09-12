import 'dart:math';

import 'package:psy_content/psy_content.dart';

/// The role US-026 assigns to one materialised n-back stimulus.
enum NbackRole {
  /// One of the run's early items: not enough history to judge yet, scored
  /// neutrally regardless of the answer (spec §2.4-A: "42 stimuli incl. 2
  /// primers").
  primer,

  /// Truly equals the stimulus shown `n` steps earlier: the correct
  /// answer is "yes".
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
/// Deterministic from `(params, seed)` alone, exactly like
/// `ActivityEngine.generate`'s contract requires: [NbackEngine.generate]
/// (`nback_engine.dart`) returns a thin `GeneratedItem` echo — the same
/// pattern `AttentionParityEngine.layoutOf` uses for `parity_sequence` — and
/// both the renderer and the scorer call [decode] again to read it; nothing
/// engine-specific is stored on the item itself.
///
/// ## Why each item is self-contained (read before changing this)
///
/// `ItemSource.generator` (`features/train/domain/engine/item_source.dart`,
/// part of the US-020 runtime, not owned by this engine) draws one
/// **independent** seed per item from `Random(sectionSeed)` and calls
/// `ActivityEngine.generate` once per item with that seed alone; it does
/// not pass the item's ordinal position in the run, nor a seed shared
/// across the whole 42-item run. A byte-for-byte faithful n-back needs
/// exactly that (item k is a target iff it equals the stimulus *actually
/// displayed* at position k-n), so with the current runtime contract a
/// generator cannot reconstruct one continuous, globally consistent
/// stream: each `generate`/`decode` call has no way to see what any other
/// call produced, and `ActivityEngine.generate` must stay a pure function
/// of its inputs (same `(params, seed)` ⇒ same item — required for replay
/// and unit-tested here).
///
/// [decode] works around this the only way that stays pure: it simulates a
/// private length-`n` "history" window from the item's own seed and
/// chooses this item's role and displayed value against *that* window. So
/// every item is internally consistent (its own declared correctness
/// matches its own synthetic window) and the run-level statistics (target
/// ratio, lure ratio, primer share) match `params`, but the colour a player
/// remembers from their own previous real turn is not literally what this
/// item's ground truth compares against. That is a genuine gap in the
/// runtime for stateful/sequential generators (also relevant to
/// `parity_sequence`'s restart-on-error and `stimulus_response`'s rule
/// history); the real fix is for `ItemSource.generator` to pass either the
/// loop index or a shared run seed to `ActivityEngine.generate`. See the
/// story's final report for the recommendation.
class NbackStimulus {
  const NbackStimulus({
    required this.role,
    required this.value,
    required this.history,
  });

  final NbackRole role;

  /// Index into the active palette (`0..paletteSize-1`).
  final int value;

  /// The `n` synthetic values immediately preceding [value], oldest first;
  /// `history.first` is the n-back reference this stimulus was checked
  /// against. Exposed so the practice UI can show a reference window next
  /// to the current stimulus (spec: "practice option ... history strip").
  final List<int> history;

  bool get isPrimer => role == NbackRole.primer;

  /// The correct answer is "yes" (ignored when [isPrimer]: primers are
  /// scored neutrally).
  bool get expectsYes => role == NbackRole.target;

  /// Decodes the stimulus of a `GeneratedItem(seed: seed, params: params)`
  /// of `memory_nback`. Pure function of its inputs: same `(params, seed)`,
  /// same result (unit-tested).
  static NbackStimulus decode(NbackParams params, int seed) {
    final rng = Random(seed);
    final paletteSize = params.paletteSize < 1 ? 1 : params.paletteSize;
    final n = params.n < 1 ? 1 : params.n;
    final primerProb = params.count <= 0 ? 0.0 : params.primers / params.count;
    final history = List<int>.generate(n, (_) => rng.nextInt(paletteSize));
    final roll = rng.nextDouble();

    final NbackRole role;
    final int value;
    if (roll < primerProb) {
      role = NbackRole.primer;
      value = rng.nextInt(paletteSize);
    } else if (roll < primerProb + params.targetRatio) {
      role = NbackRole.target;
      value = history.first;
    } else if (roll < primerProb + params.targetRatio + params.lureRatio) {
      role = NbackRole.lure;
      value = _nearMiss(rng, paletteSize, history);
    } else {
      role = NbackRole.filler;
      value = _differentFrom(rng, paletteSize, history.first);
    }
    return NbackStimulus(role: role, value: value, history: history);
  }

  /// Repeats the most recent stimulus (an `n-1` match) instead of the true
  /// `n`-back one, unless that coincides with it (short histories, `n==1`),
  /// in which case it falls back to any other value.
  static int _nearMiss(Random rng, int paletteSize, List<int> history) {
    final recent = history.last;
    if (recent != history.first || paletteSize <= 1) return recent;
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
