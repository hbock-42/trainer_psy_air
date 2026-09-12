import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:psy_content/psy_content.dart';
import 'item_result.dart';
import 'session_result.dart';

part 'activity_session_state.freezed.dart';

/// Where the current item is in its life.
enum ItemPhase {
  /// Cadence only: the stimulus is displayed (answers are accepted).
  stimulus,

  /// The item waits for an answer (the whole item life without cadence).
  answer,

  /// Answered or timed out. Without cadence the session waits for `next()`
  /// (when feedback is shown) or has already advanced; under a cadence it
  /// advances when the window ends.
  answered,
}

/// The observable state of an `ActivitySession`:
/// `briefing -> running(itemIndex) -> (paused <-> running) -> finished`.
@freezed
sealed class ActivitySessionState with _$ActivitySessionState {
  const ActivitySessionState._();

  /// Instructions and Start button; nothing is timed or persisted yet.
  /// [startIndex] is non-zero when resuming an interrupted session.
  const factory ActivitySessionState.briefing({
    required int itemCount,
    @Default(0) int startIndex,
  }) = ActivityBriefing;

  /// Item [itemIndex] (0-based) is on screen.
  ///
  /// [feedback] is the verdict once answered, only when the session shows
  /// feedback (practice, or exam with live feedback); otherwise null even
  /// after an answer. [awaitsNext] is true when the session waits for
  /// `next()` to move on. Deadlines are absolute clock times (null when the
  /// policy has no such limit).
  const factory ActivitySessionState.running({
    required int itemIndex,
    required int itemCount,
    required Item item,
    required ItemPhase phase,
    required DateTime itemStartedAt,
    DateTime? itemDeadline,
    DateTime? sectionDeadline,
    ItemResult? feedback,
    @Default(false) bool awaitsNext,
  }) = ActivityRunning;

  /// Practice only: timers are frozen with the time left on each limit.
  const factory ActivitySessionState.paused({
    required ActivityRunning snapshot,
    Duration? itemRemaining,
    Duration? sectionRemaining,
  }) = ActivityPaused;

  /// Terminal; [result] is persisted (or being persisted).
  const factory ActivitySessionState.finished({required SessionResult result}) =
      ActivityFinished;

  bool get isBriefing => this is ActivityBriefing;
  bool get isRunning => this is ActivityRunning;
  bool get isPaused => this is ActivityPaused;
  bool get isFinished => this is ActivityFinished;

  /// The running snapshot of a running or paused state; null otherwise.
  ActivityRunning? get running => switch (this) {
    ActivityRunning() => this as ActivityRunning,
    ActivityPaused(:final snapshot) => snapshot,
    _ => null,
  };
}

extension ActivityRunningTiming on ActivityRunning {
  /// Time left on the current item at [now], clamped at zero; null when
  /// untimed.
  Duration? itemRemaining(DateTime now) => _remaining(itemDeadline, now);

  /// Time left on the section at [now], clamped at zero; null when the
  /// policy has no section limit.
  Duration? sectionRemaining(DateTime now) => _remaining(sectionDeadline, now);

  /// The current item has been answered or timed out.
  bool get isAnswered => phase == ItemPhase.answered;

  static Duration? _remaining(DateTime? deadline, DateTime now) {
    if (deadline == null) return null;
    final left = deadline.difference(now);
    return left.isNegative ? Duration.zero : left;
  }
}
