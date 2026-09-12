import 'model/attempt.dart';
import 'model/learning.dart';
import 'model/session.dart';
import 'model/stats.dart';

/// Read/write access to everything the user produces: sessions, attempts,
/// per-item stats, flashcard reviews, lesson progress and the profile.
///
/// Features depend on this interface only; the local implementation
/// (`core/db/repositories/local_progress_repository.dart`) is backed by
/// Drift. Every timestamp is stored in UTC and returned in UTC.
abstract interface class ProgressRepository {
  // --- Sessions -------------------------------------------------------------

  /// Creates an in-progress session and returns it (with its uuid).
  Future<TrainingSession> startSession({
    required SessionMode mode,
    String? familyId,
    String? blueprintId,
    Map<String, Object?> config = const {},
    DateTime? startedAt,
  });

  /// Marks a session finished ([SessionStatus.completed] or
  /// [SessionStatus.abandoned]) with its final [score]. Throws
  /// [StateError] when the session does not exist.
  Future<TrainingSession> finishSession(
    String sessionId, {
    required SessionStatus status,
    double? score,
    DateTime? endedAt,
  });

  Future<TrainingSession?> sessionById(String id);

  /// Sessions started within `[from, to]` (inclusive, both optional), newest
  /// first, optionally filtered by mode, family and status.
  Future<List<TrainingSession>> sessions({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
    SessionStatus? status,
    int? limit,
  });

  // --- Attempts -------------------------------------------------------------

  /// Stores one attempt and, for bank items, updates its [ItemStat].
  Future<Attempt> recordAttempt(NewAttempt attempt);

  /// Stores many attempts in one transaction (for engines that buffer a
  /// cadence-driven activity and flush at the end).
  Future<List<Attempt>> recordAttempts(List<NewAttempt> attempts);

  /// Attempts of one session ordered by position.
  Future<List<Attempt>> attemptsForSession(String sessionId);

  /// Attempts of one family answered within `[from, to]` (inclusive, both
  /// optional), oldest first: the raw material "retry my mistakes" (US-054)
  /// folds into per-item streaks (an `ItemStat` only remembers the *last*
  /// answer, not how many were correct in a row since the last mistake).
  Future<List<Attempt>> attemptsForFamily({
    required String familyId,
    DateTime? from,
    DateTime? to,
  });

  // --- Aggregates -----------------------------------------------------------

  /// Accuracy and response-time aggregates per family over the attempts
  /// answered within `[from, to]` (optional) and, optionally, one session
  /// mode. Families without attempts are absent. Computed in SQL.
  Future<List<FamilyStats>> familyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
  });

  /// One row per (session, family, section) over the sessions started
  /// within `[from, to]` (optional), oldest session first (then section,
  /// then family): the score-over-time series of US-071 and the per-section
  /// scores of an exam. Optionally restricted to one mode and/or one family.
  /// Sessions without attempts are absent. Computed in SQL.
  Future<List<SessionFamilyStats>> sessionFamilyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
  });

  Future<ItemStat?> itemStat(String itemId);

  /// Stats of bank items, optionally restricted to one family and to items
  /// whose last attempt was wrong ("retry my mistakes").
  Future<List<ItemStat>> itemStats({String? familyId, bool failedOnly = false});

  // --- Flashcards -----------------------------------------------------------

  Future<FlashcardReview?> flashcardReview(String flashcardId);

  /// Reviews due at [now] (`nextReviewAt <= now`), soonest first.
  Future<List<FlashcardReview>> dueFlashcardReviews({
    required DateTime now,
    String? deckId,
    int? limit,
  });

  /// Inserts or replaces the review state of a card.
  Future<void> saveFlashcardReview(FlashcardReview review);

  // --- Lessons --------------------------------------------------------------

  /// Records that a lesson was read (idempotent; keeps the first `readAt`).
  Future<void> markLessonRead(String lessonId, {DateTime? readAt});

  Future<List<LessonRead>> lessonsRead();

  // --- Profile --------------------------------------------------------------

  /// The profile, or null before onboarding created one.
  Future<UserProfile?> profile();

  Future<void> saveProfile(UserProfile profile);
}
