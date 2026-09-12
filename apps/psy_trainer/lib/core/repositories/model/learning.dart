import 'package:freezed_annotation/freezed_annotation.dart';

part 'learning.freezed.dart';

/// Leitner state of one flashcard. The scheduling policy (box intervals)
/// belongs to the learn feature (US-042); the repository only stores it.
@freezed
abstract class FlashcardReview with _$FlashcardReview {
  const factory FlashcardReview({
    required String flashcardId,
    required String deckId,
    required int box,
    required int reviews,
    required int lapses,
    required DateTime nextReviewAt,
    DateTime? lastReviewedAt,
  }) = _FlashcardReview;
}

/// A lesson the user has read.
@freezed
abstract class LessonRead with _$LessonRead {
  const factory LessonRead({
    required String lessonId,
    required DateTime readAt,
  }) = _LessonRead;
}

/// The single local user.
@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String locale,
    @Default(<String, Object?>{}) Map<String, Object?> settings,
    DateTime? examDate,

    /// `psy0` | `psy1` | `psy2`; null until onboarding (US-090).
    String? targetStage,
  }) = _UserProfile;
}

/// Which content bundle is mirrored in the database (null until seeded).
@freezed
abstract class ContentInfo with _$ContentInfo {
  const factory ContentInfo({
    required int schemaVersion,
    required int contentVersion,
    required DateTime seededAt,
  }) = _ContentInfo;
}
