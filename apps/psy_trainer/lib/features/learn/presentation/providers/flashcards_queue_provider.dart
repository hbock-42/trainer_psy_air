import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repositories.dart';
import '../../domain/leitner_scheduler.dart';

/// One flashcard paired with its (possibly never-saved) review state.
class FlashcardQueueEntry {
  const FlashcardQueueEntry({required this.card, required this.review});

  final Flashcard card;
  final FlashcardReview review;
}

/// Due cards + total cards of a scope: one family's deck ([familyId] given)
/// or every deck ("review today" from the Learn home, [familyId] null).
class FlashcardsQueue {
  const FlashcardsQueue({required this.due, required this.total});

  /// Cards due now (or never reviewed), soonest-due first.
  final List<FlashcardQueueEntry> due;

  /// Every card in scope, reviewed or not.
  final int total;
}

/// Loads the cards of [familyId]'s deck (or every deck when null), pairs
/// each with its stored [FlashcardReview] (a card never reviewed gets the
/// scheduler's `initial()` state, due immediately), and reports which are
/// due at the current instant.
///
/// A card is "due" when `nextReviewAt` is not after now, matching
/// `ProgressRepository.dueFlashcardReviews` semantics but also covering
/// cards that have no stored review yet (new cards are due on first sight).
final FutureProviderFamily<FlashcardsQueue, String?> flashcardsQueueProvider =
    FutureProvider.family<FlashcardsQueue, String?>((ref, familyId) async {
      final content = ref.watch(contentRepositoryProvider);
      final progress = ref.watch(progressRepositoryProvider);

      final decks = await content.decks(familyId: familyId);
      final cards = [for (final deck in decks) ...deck.cards];

      // One instant for the whole scan: a card with no stored review is
      // `initial()`ised as due "now", so it must be compared against the
      // very same `now`, never a later `DateTime.now()` call (which would
      // make it due-in-the-future by a few microseconds and drop it).
      final now = DateTime.now().toUtc();
      final scheduler = LeitnerScheduler(clock: () => now);
      final due = <FlashcardQueueEntry>[];
      for (final card in cards) {
        final stored = await progress.flashcardReview(card.id);
        final review =
            stored ??
            scheduler.initial(flashcardId: card.id, deckId: card.deckId);
        if (!review.nextReviewAt.isAfter(now)) {
          due.add(FlashcardQueueEntry(card: card, review: review));
        }
      }
      due.sort(
        (a, b) => a.review.nextReviewAt.compareTo(b.review.nextReviewAt),
      );

      return FlashcardsQueue(due: due, total: cards.length);
    });

/// Cards due today across every deck, for the Learn home's "À réviser
/// aujourd'hui" entry.
final FutureProvider<int> flashcardsDueTodayProvider = FutureProvider<int>((
  ref,
) async {
  final queue = await ref.watch(flashcardsQueueProvider(null).future);
  return queue.due.length;
});
