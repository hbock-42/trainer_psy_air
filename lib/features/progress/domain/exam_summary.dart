import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/repositories/model/session.dart';

part 'exam_summary.freezed.dart';

/// Score of one section of an exam simulation. [weight] comes from the
/// blueprint (1 when unknown); [accuracy] is `correct / attempts`, with
/// unanswered (timed-out) stimuli counted as wrong, and 0 when the section
/// was never reached.
@freezed
abstract class SectionScore with _$SectionScore {
  const factory SectionScore({
    required int sectionIndex,
    required String familyId,
    required int attempts,
    required int correct,
    required int unanswered,
    required double weight,
    double? medianResponseMs,
  }) = _SectionScore;

  const SectionScore._();

  double get accuracy => attempts == 0 ? 0 : correct / attempts;
}

/// Result of one exam simulation: the weighted global score, each section,
/// and the change against the previous completed simulation of the same
/// blueprint (null for the first one).
@freezed
abstract class ExamSummary with _$ExamSummary {
  const factory ExamSummary({
    required String sessionId,
    required DateTime startedAt,
    required SessionStatus status,

    /// Weighted mean of section accuracies, 0..1.
    required double score,
    required List<SectionScore> sections,
    String? blueprintId,
    DateTime? endedAt,
    String? previousSessionId,

    /// `score - previous.score`, in the 0..1 scale.
    double? deltaVsPrevious,
  }) = _ExamSummary;

  const ExamSummary._();

  /// The score on a 0..100 scale, rounded.
  int get percent => (score * 100).round();

  int get attempts => sections.fold(0, (sum, s) => sum + s.attempts);

  int get correct => sections.fold(0, (sum, s) => sum + s.correct);
}
