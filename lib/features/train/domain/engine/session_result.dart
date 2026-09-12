import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/content/content.dart';
import '../../../../core/repositories/model/session.dart';
import 'item_result.dart';

part 'session_result.freezed.dart';

/// Why a session reached `finished`.
enum FinishReason {
  /// Every item was played.
  completed,

  /// The user quit (practice "quitter", exam abort).
  aborted,

  /// The section time limit ran out before the last item.
  sectionTimeout,
}

/// Aggregates of one section (one activity), computed by `Scorer.section`
/// from its [ItemOutcome]s and the section's [ScoringPolicy].
///
/// Response-time statistics are over answered items only (timeouts
/// excluded); [accuracy] is over the items played (timeouts and skips count
/// as wrong, unplayed items are ignored); [points] applies the policy
/// (`correct` / `wrong` / `skip` per outcome, timeouts as wrong) and
/// [maxPoints] is `correct * itemCount`.
@freezed
abstract class SectionResult with _$SectionResult {
  const factory SectionResult({
    required int itemCount,
    required int played,
    required int correct,
    required int wrong,
    required int timeouts,
    required int skipped,
    required double accuracy,
    required double? meanResponseMs,
    required double? medianResponseMs,
    required num points,
    required num maxPoints,
    required ScoringPolicy scoringPolicy,
    @Default(<String, num>{}) Map<String, num> metricTotals,
  }) = _SectionResult;

  const SectionResult._();

  /// Items never reached (section timeout or abort).
  int get unplayed => itemCount - played;

  /// `points / maxPoints` clamped to 0..1 (0 when the policy has no
  /// positive points).
  double get pointsFraction =>
      maxPoints <= 0 ? 0 : (points / maxPoints).clamp(0.0, 1.0).toDouble();
}

/// What a finished `ActivitySession` hands back: the outcomes, the section
/// aggregates and the persisted session id ([sessionId] is null when the
/// session ended before `startSession` returned; `ActivitySession.sessionId`
/// is the authoritative value once `idle` completes).
@freezed
abstract class SessionResult with _$SessionResult {
  const factory SessionResult({
    required SessionMode mode,
    required String familyId,
    required FinishReason reason,
    required List<ItemOutcome> outcomes,
    required SectionResult section,
    String? sessionId,
    int? sectionIndex,
  }) = _SessionResult;

  const SessionResult._();

  bool get isAborted => reason == FinishReason.aborted;

  /// The score stored on the session: accuracy in 0..1.
  double get score => section.accuracy;
}
