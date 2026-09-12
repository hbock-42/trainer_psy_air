import '../../../../core/content/content.dart';
import 'answer.dart';
import 'item_result.dart';
import 'session_result.dart';

/// Default per-item scoring for the self-scoring bank items and the section
/// aggregation every engine shares.
abstract final class Scorer {
  /// Scores [answer] against a self-scoring item (CONTRACT.md §2). A
  /// [SkipAnswer] is a skip on any item; a [TimeoutAnswer] a timeout; an
  /// answer of the wrong kind is simply wrong. [GeneratedItem]s are recipes,
  /// not questions: engines score their materialised items themselves.
  static ItemResult scoreItem(Item item, Answer answer) {
    if (answer.isTimeout) return ItemResult.timeout;
    if (answer.isSkip) return ItemResult.skip;
    return switch (item) {
      McqItem(:final correctIndex) => _bool(
        answer is ChoiceAnswer && answer.index == correctIndex,
      ),
      NumericItem(:final expected, :final tolerance) => _bool(
        answer is NumericAnswer &&
            numericMatches(answer.value, expected, tolerance),
      ),
      SequenceItem(:final stimulus, :final recallMode) => _bool(
        answer is SequenceAnswer &&
            sequenceMatches(answer.values, stimulus, recallMode),
      ),
      GeneratedItem() => ItemResult.wrong,
    };
  }

  /// `value` equals `expected` within [tolerance] (exact when null).
  static bool numericMatches(num value, num expected, Tolerance? tolerance) {
    if (tolerance == null) return value == expected;
    final delta = (value - expected).abs();
    return switch (tolerance.mode) {
      ToleranceMode.absolute => delta <= tolerance.value,
      ToleranceMode.relative => delta <= expected.abs() * tolerance.value,
    };
  }

  /// [recalled] reproduces [stimulus] under [mode].
  static bool sequenceMatches(
    List<String> recalled,
    List<String> stimulus,
    RecallMode mode,
  ) {
    if (recalled.length != stimulus.length) return false;
    switch (mode) {
      case RecallMode.forward:
        return _sameOrder(recalled, stimulus);
      case RecallMode.backward:
        return _sameOrder(recalled, stimulus.reversed.toList());
      case RecallMode.anyOrder:
        final a = [...recalled]..sort();
        final b = [...stimulus]..sort();
        return _sameOrder(a, b);
    }
  }

  static bool _sameOrder(List<String> a, List<String> b) {
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static ItemResult _bool(bool correct) =>
      correct ? ItemResult.right : ItemResult.wrong;

  /// Aggregates [outcomes] of a section of [itemCount] items under [policy].
  static SectionResult section(
    List<ItemOutcome> outcomes, {
    required int itemCount,
    ScoringPolicy policy = const ScoringPolicy(),
  }) {
    var correct = 0;
    var wrong = 0;
    var timeouts = 0;
    var skipped = 0;
    num points = 0;
    final answeredMs = <int>[];
    final totals = <String, num>{};
    for (final outcome in outcomes) {
      final result = outcome.result;
      if (result.correct) {
        correct++;
        points += policy.correct;
      } else if (result.timedOut) {
        timeouts++;
        points += policy.wrong;
      } else if (result.skipped) {
        skipped++;
        points += policy.skip;
      } else {
        wrong++;
        points += policy.wrong;
      }
      if (!result.timedOut) answeredMs.add(outcome.responseMs);
      result.metrics.forEach((key, value) {
        totals[key] = (totals[key] ?? 0) + value;
      });
    }
    final played = outcomes.length;
    return SectionResult(
      itemCount: itemCount,
      played: played,
      correct: correct,
      wrong: wrong,
      timeouts: timeouts,
      skipped: skipped,
      accuracy: played == 0 ? 0 : correct / played,
      meanResponseMs: _mean(answeredMs),
      medianResponseMs: _median(answeredMs),
      points: points,
      maxPoints: policy.correct * itemCount,
      scoringPolicy: policy,
      metricTotals: totals,
    );
  }

  static double? _mean(List<int> values) =>
      values.isEmpty ? null : values.reduce((a, b) => a + b) / values.length;

  /// Average of the two middle values, as the SQL aggregates do.
  static double? _median(List<int> values) {
    if (values.isEmpty) return null;
    final sorted = [...values]..sort();
    final mid = sorted.length ~/ 2;
    return sorted.length.isOdd
        ? sorted[mid].toDouble()
        : (sorted[mid - 1] + sorted[mid]) / 2;
  }
}
