import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/model/learning.dart';
import 'package:psy_trainer/features/learn/domain/leitner_scheduler.dart';

void main() {
  final now = DateTime.utc(2026, 9, 12, 10);
  final scheduler = LeitnerScheduler(clock: () => now);

  FlashcardReview reviewAt(int box, {int reviews = 0, int lapses = 0}) =>
      FlashcardReview(
        flashcardId: 'card-1',
        deckId: 'deck-1',
        box: box,
        reviews: reviews,
        lapses: lapses,
        nextReviewAt: now,
      );

  group('initial', () {
    test('starts at box 1, due immediately', () {
      final review = scheduler.initial(flashcardId: 'card-1', deckId: 'deck-1');
      expect(review.box, 1);
      expect(review.reviews, 0);
      expect(review.lapses, 0);
      expect(review.nextReviewAt, now);
    });
  });

  group('again', () {
    test('sends the card back to box 1, due in 10 minutes', () {
      final review = reviewAt(4, reviews: 3, lapses: 1);
      final next = scheduler.grade(review, FlashcardGrade.again);

      expect(next.box, 1);
      expect(next.reviews, 4);
      expect(next.lapses, 2);
      expect(next.lastReviewedAt, now);
      expect(next.nextReviewAt, now.add(const Duration(minutes: 10)));
    });
  });

  group('hard', () {
    test('keeps the same box, due in 1 day', () {
      final review = reviewAt(3, reviews: 2);
      final next = scheduler.grade(review, FlashcardGrade.hard);

      expect(next.box, 3);
      expect(next.reviews, 3);
      expect(next.lapses, 0);
      expect(next.nextReviewAt, now.add(const Duration(days: 1)));
    });
  });

  group('good', () {
    test('box 1 -> 2, due in 3 days', () {
      final next = scheduler.grade(reviewAt(1), FlashcardGrade.good);
      expect(next.box, 2);
      expect(next.nextReviewAt, now.add(const Duration(days: 3)));
    });

    test('box 2 -> 3, due in 7 days', () {
      final next = scheduler.grade(reviewAt(2), FlashcardGrade.good);
      expect(next.box, 3);
      expect(next.nextReviewAt, now.add(const Duration(days: 7)));
    });

    test('box 3 -> 4, due in 14 days', () {
      final next = scheduler.grade(reviewAt(3), FlashcardGrade.good);
      expect(next.box, 4);
      expect(next.nextReviewAt, now.add(const Duration(days: 14)));
    });

    test('box 4 -> 5, due in 30 days', () {
      final next = scheduler.grade(reviewAt(4), FlashcardGrade.good);
      expect(next.box, 5);
      expect(next.nextReviewAt, now.add(const Duration(days: 30)));
    });

    test('box 5 stays at 5 (max), due in 30 days again', () {
      final next = scheduler.grade(reviewAt(5), FlashcardGrade.good);
      expect(next.box, 5);
      expect(next.nextReviewAt, now.add(const Duration(days: 30)));
    });

    test('increments reviews without touching lapses', () {
      final next = scheduler.grade(
        reviewAt(1, reviews: 2, lapses: 1),
        FlashcardGrade.good,
      );
      expect(next.reviews, 3);
      expect(next.lapses, 1);
    });
  });
}
