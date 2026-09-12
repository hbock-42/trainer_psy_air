import 'package:freezed_annotation/freezed_annotation.dart';

part 'session.freezed.dart';

/// What kind of session the user ran.
enum SessionMode { practice, exam }

/// Lifecycle of a [TrainingSession].
enum SessionStatus { inProgress, completed, abandoned }

/// One practice or exam session, as seen by features.
@freezed
abstract class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    required String id,
    required SessionMode mode,
    required DateTime startedAt,
    required SessionStatus status,
    required Map<String, Object?> config,

    /// One family for practice sessions; null for exams.
    String? familyId,

    /// The blueprint of an exam session; null for practice.
    String? blueprintId,
    DateTime? endedAt,

    /// Final score in the engine's own unit; null while in progress.
    double? score,
  }) = _TrainingSession;

  const TrainingSession._();

  bool get isFinished => status != SessionStatus.inProgress;
}
