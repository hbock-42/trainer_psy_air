import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/content/content.dart';
import 'answer.dart';

part 'item_result.freezed.dart';

/// Verdict of an engine on one answer.
///
/// [correct] is what analytics count; [metrics] carries engine-specific
/// partial scores (precision/recall of a grid, restarts of a parity series,
/// hit/miss/false-alarm flags of an n-back stimulus) that the session sums
/// into `SectionResult.metricTotals` and the engine's own summary reads.
@freezed
abstract class ItemResult with _$ItemResult {
  const factory ItemResult({
    required bool correct,
    @Default(false) bool timedOut,
    @Default(false) bool skipped,
    @Default(<String, num>{}) Map<String, num> metrics,
  }) = _ItemResult;

  const ItemResult._();

  static const ItemResult right = ItemResult(correct: true);
  static const ItemResult wrong = ItemResult(correct: false);
  static const ItemResult timeout = ItemResult(correct: false, timedOut: true);
  static const ItemResult skip = ItemResult(correct: false, skipped: true);

  /// Wrong, timed out or skipped.
  bool get isError => !correct;
}

/// One item as it was played: the item, the answer, the verdict and the
/// response time (pause time excluded).
@freezed
abstract class ItemOutcome with _$ItemOutcome {
  const factory ItemOutcome({
    required int index,
    required Item item,
    required Answer answer,
    required ItemResult result,
    required int responseMs,
  }) = _ItemOutcome;

  const ItemOutcome._();

  bool get isCorrect => result.correct;
  bool get isTimeout => result.timedOut;
  bool get isSkipped => result.skipped;
}
