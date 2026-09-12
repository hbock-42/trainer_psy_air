import '../../../core/repositories/model/learning.dart';

/// Self-graded outcome of one flashcard review (US-042).
enum FlashcardGrade { again, hard, good }

/// Leitner-box scheduler (5 boxes) for flashcard reviews.
///
/// Pure Dart, no Flutter/Riverpod/Drift dependency (`domain/` rule, see
/// `docs/ARCHITECTURE.md`). The wall clock is injected so tests are
/// deterministic.
///
/// Policy:
/// - `again`  -> box 1, due again in 10 minutes (short-term relearn).
/// - `hard`   -> same box, due in 1 day.
/// - `good`   -> box + 1 (capped at [maxBox]), due after [boxIntervals] of
///   the *new* box (1 / 3 / 7 / 14 / 30 days for box 1..5).
class LeitnerScheduler {
  const LeitnerScheduler({this.clock = DateTime.now});

  /// Returns the current instant; overridden in tests.
  final DateTime Function() clock;

  /// Lowest Leitner box.
  static const int minBox = 1;

  /// Highest Leitner box; a `good` grade at this box stays there.
  static const int maxBox = 5;

  /// Delay before a card graded `again` comes back.
  static const Duration againDelay = Duration(minutes: 10);

  /// Delay before a card graded `hard` comes back.
  static const Duration hardDelay = Duration(days: 1);

  /// Interval applied after a `good` grade moves a card into box `n`
  /// (1-indexed: `boxIntervals[n - 1]`).
  static const List<Duration> boxIntervals = [
    Duration(days: 1),
    Duration(days: 3),
    Duration(days: 7),
    Duration(days: 14),
    Duration(days: 30),
  ];

  /// The initial review state of a card that has never been graded: box 1,
  /// due immediately so it is picked up by the next session.
  FlashcardReview initial({
    required String flashcardId,
    required String deckId,
  }) {
    final now = clock().toUtc();
    return FlashcardReview(
      flashcardId: flashcardId,
      deckId: deckId,
      box: minBox,
      reviews: 0,
      lapses: 0,
      nextReviewAt: now,
    );
  }

  /// Applies [grade] to [review], returning the next review state. Does not
  /// persist anything; the caller saves it through `ProgressRepository`.
  FlashcardReview grade(FlashcardReview review, FlashcardGrade grade) {
    final now = clock().toUtc();
    switch (grade) {
      case FlashcardGrade.again:
        return review.copyWith(
          box: minBox,
          reviews: review.reviews + 1,
          lapses: review.lapses + 1,
          lastReviewedAt: now,
          nextReviewAt: now.add(againDelay),
        );
      case FlashcardGrade.hard:
        return review.copyWith(
          reviews: review.reviews + 1,
          lastReviewedAt: now,
          nextReviewAt: now.add(hardDelay),
        );
      case FlashcardGrade.good:
        final newBox = review.box + 1 > maxBox ? maxBox : review.box + 1;
        return review.copyWith(
          box: newBox,
          reviews: review.reviews + 1,
          lastReviewedAt: now,
          nextReviewAt: now.add(boxIntervals[newBox - 1]),
        );
    }
  }
}
