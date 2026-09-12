import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../../../core/repositories/repositories.dart';
import '../../domain/leitner_scheduler.dart';
import 'flashcards_queue_provider.dart';

/// A running (or finished) flashcard review session: a queue of due cards,
/// the current one (front shown first), tallies for the end-of-session
/// summary, and whether every due card has been graded.
class FlashcardsSessionState {
  const FlashcardsSessionState({
    required this.queue,
    required this.index,
    required this.flipped,
    required this.total,
    this.again = 0,
    this.hard = 0,
    this.good = 0,
  });

  /// Cards left to review, in order (already-graded cards are dropped).
  final List<FlashcardQueueEntry> queue;

  /// Index of the card currently shown, or -1 once the queue is empty.
  final int index;

  /// Whether the current card shows its back.
  final bool flipped;

  /// Total cards in the deck (for "N au total"); unrelated to grading.
  final int total;

  final int again;
  final int hard;
  final int good;

  bool get isLoading => index == -2;
  bool get isDone => index == -1;
  int get reviewed => again + hard + good;
  int get remaining => queue.length - reviewed;

  FlashcardQueueEntry? get current =>
      isDone || isLoading || index >= queue.length ? null : queue[index];

  FlashcardsSessionState copyWith({
    List<FlashcardQueueEntry>? queue,
    int? index,
    bool? flipped,
    int? total,
    int? again,
    int? hard,
    int? good,
  }) => FlashcardsSessionState(
    queue: queue ?? this.queue,
    index: index ?? this.index,
    flipped: flipped ?? this.flipped,
    total: total ?? this.total,
    again: again ?? this.again,
    hard: hard ?? this.hard,
    good: good ?? this.good,
  );

  static const FlashcardsSessionState loading = FlashcardsSessionState(
    queue: [],
    index: -2,
    flipped: false,
    total: 0,
  );
}

/// Drives one review session, scoped to a family's deck ([familyId]) or
/// every deck ([familyId] null, the Learn home "review today" entry).
///
/// Loads the due queue once (`build`), then flips/grades locally and saves
/// each graded review through [ProgressRepository]. Re-fetching the queue on
/// every grade would let a just-reviewed card reappear (its new
/// `nextReviewAt` might still be "now" for an `again`-heavy sequence run
/// quickly in tests), so the session works off the snapshot taken at start.
class FlashcardsSessionNotifier extends Notifier<FlashcardsSessionState> {
  FlashcardsSessionNotifier(this.familyId);

  /// Scope of this session: one family's deck, or every deck when null.
  final String? familyId;

  static const LeitnerScheduler _scheduler = LeitnerScheduler();

  @override
  FlashcardsSessionState build() {
    _load();
    return FlashcardsSessionState.loading;
  }

  Future<void> _load() async {
    final queue = await ref.read(flashcardsQueueProvider(familyId).future);
    state = FlashcardsSessionState(
      queue: queue.due,
      index: queue.due.isEmpty ? -1 : 0,
      flipped: false,
      total: queue.total,
    );
  }

  /// Reveals the back of the current card (or flips back to the front).
  void flip() {
    if (state.current == null) return;
    state = state.copyWith(flipped: !state.flipped);
  }

  /// Grades the current card, saves the new review state and advances.
  Future<void> grade(FlashcardGrade outcome) async {
    final entry = state.current;
    if (entry == null) return;
    final next = _scheduler.grade(entry.review, outcome);
    await ref.read(progressRepositoryProvider).saveFlashcardReview(next);

    final nextIndex = state.index + 1;
    state = state.copyWith(
      index: nextIndex >= state.queue.length ? -1 : nextIndex,
      flipped: false,
      again: state.again + (outcome == FlashcardGrade.again ? 1 : 0),
      hard: state.hard + (outcome == FlashcardGrade.hard ? 1 : 0),
      good: state.good + (outcome == FlashcardGrade.good ? 1 : 0),
    );
  }
}

/// Session provider, keyed by the scope's family id (`null` = all decks).
/// `autoDispose` so leaving the screen starts a fresh session next time.
final NotifierProviderFamily<
  FlashcardsSessionNotifier,
  FlashcardsSessionState,
  String?
>
flashcardsSessionProvider =
    NotifierProvider.family<
      FlashcardsSessionNotifier,
      FlashcardsSessionState,
      String?
    >(FlashcardsSessionNotifier.new, isAutoDispose: true);
