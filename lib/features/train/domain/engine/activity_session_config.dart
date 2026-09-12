import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/content/content.dart';
import '../../../../core/repositories/model/session.dart';
import 'item_source.dart';
import 'timing_policy.dart';

part 'activity_session_config.freezed.dart';
part 'activity_session_config.g.dart';

/// Everything an `ActivitySession` needs to run one activity: the family,
/// the mode, the items, the timing and the scoring.
///
/// Serialisable: the session stores `toJson()` in `TrainingSession.config`
/// so an interrupted session can be rebuilt (`ActivitySession.resume`).
@freezed
abstract class ActivitySessionConfig with _$ActivitySessionConfig {
  const factory ActivitySessionConfig({
    required String familyId,
    required SessionMode mode,
    required ItemSource source,
    @Default(TimingPolicy.none) TimingPolicy timing,
    @Default(ScoringPolicy()) ScoringPolicy scoringPolicy,

    /// Keep the engine's live right/wrong feedback in exam mode (rules S-R,
    /// parity restart): `TestFamily.liveFeedback` /
    /// `ExamSection.liveFeedback`. Practice always shows feedback.
    @Default(false) bool liveFeedback,

    /// Shown on the briefing screen (blueprint section briefing or family
    /// description).
    LocalizedText? briefing,
    LocalizedText? title,

    /// Exam runner: the blueprint and the section this run belongs to.
    String? blueprintId,
    int? sectionIndex,

    /// Attach attempts to this already-started session instead of starting
    /// one: set by the exam runner (which also finishes it, see
    /// [ownsSession]) and by `ActivitySession.resume`. Null for a fresh
    /// practice session.
    String? sessionId,

    /// Whether this run finishes the `TrainingSession` when it ends
    /// (practice, including a resumed one). The exam runner sets it to
    /// false: it finishes the session after its last section.
    @Default(true) bool ownsSession,

    /// Exam runner: position of this section's first item within the whole
    /// session, so `NewAttempt.position` stays unique across sections.
    @Default(0) int positionOffset,
  }) = _ActivitySessionConfig;

  const ActivitySessionConfig._();

  factory ActivitySessionConfig.fromJson(Map<String, Object?> json) =>
      _$ActivitySessionConfigFromJson(json);

  /// Practice shows feedback after every item; exam only when the activity
  /// itself does in the real test ([liveFeedback]).
  bool get showsFeedback => mode == SessionMode.practice || liveFeedback;

  /// Pause and quit-without-confirmation exist in practice only.
  bool get canPause => mode == SessionMode.practice;

  int get itemCount => source.itemCount;
}
