// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flashcard_reviews_dao.dart';

// ignore_for_file: type=lint
mixin _$FlashcardReviewsDaoMixin on DatabaseAccessor<AppDatabase> {
  $FlashcardReviewsTable get flashcardReviews =>
      attachedDatabase.flashcardReviews;
  FlashcardReviewsDaoManager get managers => FlashcardReviewsDaoManager(this);
}

class FlashcardReviewsDaoManager {
  final _$FlashcardReviewsDaoMixin _db;
  FlashcardReviewsDaoManager(this._db);
  $$FlashcardReviewsTableTableManager get flashcardReviews =>
      $$FlashcardReviewsTableTableManager(
        _db.attachedDatabase,
        _db.flashcardReviews,
      );
}
