import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'flashcard_reviews_dao.g.dart';

@DriftAccessor(tables: [FlashcardReviews])
class FlashcardReviewsDao extends DatabaseAccessor<AppDatabase>
    with _$FlashcardReviewsDaoMixin {
  FlashcardReviewsDao(super.db);

  /// Inserts the review state or, when the card already has one, updates it
  /// in place (keeping the existing `id`/`createdAt`).
  Future<void> upsert(FlashcardReviewsCompanion review) {
    return into(flashcardReviews).insert(
      review,
      onConflict: DoUpdate(
        (_) => review.copyWith(
          id: const Value.absent(),
          createdAt: const Value.absent(),
        ),
        target: [flashcardReviews.flashcardId],
      ),
    );
  }

  Future<FlashcardReviewRow?> byCard(String flashcardId) => (select(
    flashcardReviews,
  )..where((t) => t.flashcardId.equals(flashcardId))).getSingleOrNull();

  /// Reviews whose `nextReviewAt <= now`, soonest first. Uses the
  /// `(deck_id, next_review_at)` index when [deckId] is given.
  Future<List<FlashcardReviewRow>> due({
    required DateTime now,
    String? deckId,
    int? limit,
  }) {
    final query = select(flashcardReviews)
      ..where((t) => t.nextReviewAt.isSmallerOrEqualValue(now))
      ..orderBy([(t) => OrderingTerm.asc(t.nextReviewAt)]);
    if (deckId != null) query.where((t) => t.deckId.equals(deckId));
    if (limit != null) query.limit(limit);
    return query.get();
  }
}
