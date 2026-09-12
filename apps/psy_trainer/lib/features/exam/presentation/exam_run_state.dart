import 'package:freezed_annotation/freezed_annotation.dart';

import '../../train/presentation/engine/activity_session_controller.dart';

part 'exam_run_state.freezed.dart';

/// State machine `ExamRunController` exposes to the runner screen.
///
/// ```
/// loading -> running(0) -> [onBreak ->] running(1) -> ... -> finishing -> done
///                \                                              \
///                 -> aborted <---------------------------------- (quit / section aborted)
/// ```
/// [ExamRunUnavailable] replaces `loading` when the blueprint has no
/// section whose engine is registered yet.
@freezed
sealed class ExamRunState with _$ExamRunState {
  const factory ExamRunState.loading() = ExamRunLoading;

  /// Running the section at [planIndex] of [totalSections] planned
  /// (available) sections; [request] is what the screen hands `SessionHost`.
  const factory ExamRunState.running({
    required int planIndex,
    required int totalSections,
    required ActivitySessionRequest request,
  }) = ExamRunRunning;

  /// Between two sections (`ExamSection.breakAfterSec` > 0 on the section
  /// just finished); [nextPlanIndex] is about to start.
  const factory ExamRunState.onBreak({
    required int nextPlanIndex,
    required int totalSections,
  }) = ExamRunOnBreak;

  const factory ExamRunState.finishing() = ExamRunFinishing;

  const factory ExamRunState.done({required String sessionId}) = ExamRunDone;

  /// The candidate quit, or a section ended aborted: the whole exam is
  /// abandoned, nothing to review.
  const factory ExamRunState.aborted() = ExamRunAborted;

  /// No section of the blueprint has a registered engine.
  const factory ExamRunState.unavailable() = ExamRunUnavailable;

  const factory ExamRunState.error(String message) = ExamRunError;
}
