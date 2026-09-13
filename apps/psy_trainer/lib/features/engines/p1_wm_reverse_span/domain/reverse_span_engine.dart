import 'dart:math';

import 'package:psy_content/psy_content.dart';

import '../../../train/domain/engine/engine.dart';

/// `p1_wm_reverse_span` (spec §2.3-9, US-106): a sequence of
/// `minDigits`..`maxDigits` digits is shown one at a time, then the
/// candidate types it back in reverse order on the keypad, within
/// `answerWindowMs`. One `GeneratedItem` per sequence (unlike `memory_nback`,
/// each sequence is independent -- item k does not need to know what item
/// k-n showed), so `generate` does not need to read `runSeed`/`index` for its
/// own logic; both are still stored on `origin` (US-037 convention) purely
/// for replay/id bookkeeping.
///
/// **Span length comes from `difficulty`, not from live in-run streaks.**
/// The spec's "+1 after 2 correct, -1 after a miss" describes a reactive
/// staircase, but `ItemSource.generator`/`ItemSource.adaptive` (the only two
/// ways items reach `ActivitySession`, see `docs/ARCHITECTURE.md#engine`)
/// both materialise -- or, for `adaptive`, decide the difficulty of -- an
/// item from `(params, seed, difficulty)` alone; `generate` has no way to
/// see how earlier items in *this* run were actually answered. Practice
/// sessions of a generator-backed family always run over `ItemSource
/// .adaptive` (`practice_session_builder.dart`), whose shared
/// `AdaptiveDifficultyPolicy` already *is* an in-run reactive staircase (3
/// consecutive correct-and-fast to level up, 2 consecutive wrong to level
/// down, level clamped 1..5) -- just with the app's own thresholds and a
/// 1..5 level, not this family's own "+1/2 correct, -1/miss, 4..9" numbers,
/// and that policy is shared runtime code this story must not fork
/// per-family. [lengthForDifficulty] maps that level onto
/// `[minDigits, maxDigits]` linearly, so the span *does* adapt within a
/// practice series, just on the shared policy's cadence rather than the
/// spec's literal one; exam sections (`ItemSource.generator`, a fixed
/// `difficulty` range per blueprint) get a fixed-but-varied span per the
/// blueprint's own `difficulty: {min, max}`. Documented deviation -- see the
/// PR description.
class ReverseSpanEngine extends ActivityEngine {
  const ReverseSpanEngine();

  @override
  String get familyId => 'p1_wm_reverse_span';

  @override
  GeneratorId? get generatorId => GeneratorId.p1WmReverseSpan;

  @override
  Item generate({
    required GeneratorParams params,
    required int seed,
    required int difficulty,
    int index = 0,
    int? runSeed,
  }) {
    final typed = params as P1WmReverseSpanParams;
    return GeneratedItem(
      id: ActivityEngine.generatedItemId(GeneratorId.p1WmReverseSpan, seed),
      version: 1,
      familyId: familyId,
      difficulty: difficulty,
      tags: const ['memory'],
      generatorId: GeneratorId.p1WmReverseSpan,
      seed: seed,
      params: typed,
      origin: ItemOrigin(
        generatorId: GeneratorId.p1WmReverseSpan,
        seed: seed,
        runSeed: runSeed ?? seed,
        index: index,
      ),
    );
  }

  /// The decoded sequence of a materialised `GeneratedItem` of this family;
  /// used by the renderer and by [score]. Pure function of the item's own
  /// `(seed, difficulty, params)` -- no `runSeed`/`index` needed (see class
  /// doc).
  static ReverseSpanSequence sequenceOf(GeneratedItem item) {
    final typed = item.params as P1WmReverseSpanParams;
    final length = lengthForDifficulty(item.difficulty, typed);
    final rng = Random(item.seed);
    final digits = List<int>.generate(length, (_) => rng.nextInt(10));
    return ReverseSpanSequence(digits: digits);
  }

  /// The app-wide adaptive level runs 1..5 (`AdaptiveDifficultyPolicy`); this
  /// maps it linearly onto `[params.minDigits, params.maxDigits]`. Out of
  /// range `difficulty` (an exam blueprint's own `min`/`max`, or a direct
  /// unit-test call) is clamped to 1..5 first, so the result always stays
  /// within the params' own bounds.
  static int lengthForDifficulty(int difficulty, P1WmReverseSpanParams p) {
    const minLevel = 1;
    const maxLevel = 5;
    final clamped = difficulty.clamp(minLevel, maxLevel);
    final minDigits = p.minDigits;
    final maxDigits = p.maxDigits;
    if (maxDigits <= minDigits) return minDigits;
    final span = maxDigits - minDigits;
    const levelSpan = maxLevel - minLevel;
    final length =
        minDigits + (span * (clamped - minLevel) / levelSpan).round();
    return length.clamp(minDigits, maxDigits);
  }

  /// Correct iff the candidate typed every digit, in the exact reverse
  /// order of the shown sequence (`Scorer.sequenceMatches` with
  /// `RecallMode.backward`, reused rather than reimplemented). Metrics
  /// decompose accuracy by the span length actually played this item (see
  /// [ReverseSpanMetrics] / [reverseSpanMaxReached]: `SectionResult
  /// .metricTotals` only sums, so "the longest span reached" is derived
  /// post-hoc from the per-length breakdown, exactly like `memory_nback`'s
  /// `nbackSensitivity` derives d' from its own decomposed totals).
  @override
  ItemResult score(Item item, Answer answer) {
    final generated = item as GeneratedItem;
    final sequence = sequenceOf(generated);
    final length = sequence.digits.length;
    final stimulus = [for (final digit in sequence.digits) '$digit'];
    final correct =
        answer is SequenceAnswer &&
        Scorer.sequenceMatches(answer.values, stimulus, RecallMode.backward);
    return ItemResult(
      correct: correct,
      metrics: {
        ReverseSpanMetrics.attemptsAtLength(length): 1,
        if (correct) ReverseSpanMetrics.correctAtLength(length): 1,
      },
    );
  }
}

/// One decoded reverse-span sequence: the digits as shown, forward order.
class ReverseSpanSequence {
  const ReverseSpanSequence({required this.digits});

  final List<int> digits;

  /// The candidate's expected keystrokes: the digits, reversed, as the
  /// single-character tokens `Answer.sequence` carries.
  List<String> get expectedReverse => [
    for (final digit in digits.reversed) '$digit',
  ];
}

/// Metric key names summed into `SectionResult.metricTotals` by every
/// `ItemResult` [ReverseSpanEngine.score] returns, decomposed by the span
/// length actually played (see [reverseSpanMaxReached]).
abstract final class ReverseSpanMetrics {
  static String attemptsAtLength(int length) =>
      'reverseSpanLen${length}Attempts';
  static String correctAtLength(int length) => 'reverseSpanLen${length}Correct';
}

/// The longest span length with at least one correct recall in
/// [metricTotals] (`SectionResult.metricTotals`), or null when none was
/// correct (or the map holds no reverse-span metrics at all). A section's
/// "max span reached", derived post-hoc since `Scorer.section` only sums
/// per-item metrics rather than tracking a running maximum.
int? reverseSpanMaxReached(Map<String, num> metricTotals) {
  final pattern = RegExp(r'^reverseSpanLen(\d+)Correct$');
  int? maxLength;
  for (final entry in metricTotals.entries) {
    if (entry.value <= 0) continue;
    final match = pattern.firstMatch(entry.key);
    if (match == null) continue;
    final length = int.parse(match.group(1)!);
    if (maxLength == null || length > maxLength) maxLength = length;
  }
  return maxLength;
}
