import 'model/attempt.dart';
import 'model/backup.dart';
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

  /// Permanently deletes a session and every attempt recorded under it
  /// (US-064 "delete a simulation"). A no-op when the session is unknown.
  /// Per-item [ItemStat] aggregates are left as they are: rolling them back
  /// would need to replay every other attempt of the item.
  Future<void> deleteSession(String sessionId);

  // --- Attempts -------------------------------------------------------------

  /// Stores one attempt and, for bank items, updates its [ItemStat].
  Future<Attempt> recordAttempt(NewAttempt attempt);

  /// Stores many attempts in one transaction (for engines that buffer a
  /// cadence-driven activity and flush at the end).
  Future<List<Attempt>> recordAttempts(List<NewAttempt> attempts);

  /// Attempts of one session ordered by position.
  Future<List<Attempt>> attemptsForSession(String sessionId);

  /// Every attempt ever recorded (practice and exam sections alike),
  /// unordered no particular way is guaranteed. The engagement history
  /// behind streaks and the activity heat-map (US-073): unlike
  /// [attemptsForFamily] it is not scoped to one family, and unlike
  /// [sessionFamilyStats] it hands back the raw `answeredAt`/`responseMs` of
  /// every row (no SQL aggregation) so the pure-Dart `StreakService` buckets
  /// them into local-midnight days itself.
  Future<List<Attempt>> allAttempts();

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

  /// Every card's current review state (US-073: the flashcard contribution
  /// to the activity heat-map — only the latest review per card is stored,
  /// not a full history, see `docs/ARCHITECTURE.md`).
  Future<List<FlashcardReview>> allFlashcardReviews();

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

  // --- Reset ------------------------------------------------------------

  /// "Réinitialiser toutes les données" (US-091): permanently deletes every
  /// user row — sessions, attempts, item stats, flashcard reviews, lesson
  /// progress and the profile — in one transaction. Content mirrors
  /// (`content_meta`, `items`, `lessons`...) are untouched, so the app does
  /// not need to re-seed; onboarding runs again because [profile] becomes
  /// null.
  Future<void> clearAll();

  // --- Backup (US-074) -------------------------------------------------

  /// Every user row (sessions, attempts, item stats, flashcard reviews,
  /// lesson progress, profile) as [BackupRow]s, id and `updatedAt` included,
  /// for `BackupService` to wrap in the versioned JSON envelope. Content
  /// tables are never part of it (see "Backup format" in
  /// `docs/ARCHITECTURE.md`).
  Future<BackupSnapshot> exportSnapshot();

  /// Merges [snapshot] into local storage, table by table. A row wins over
  /// the existing one at the same key when its `updatedAt` is strictly
  /// newer (or there is no existing row); a tie or an older row is left
  /// alone. The key is the row id for `sessions`/`attempts` (no other
  /// column identifies "the same row"); for `itemStats`/`flashcardReviews`/
  /// `lessonProgress`/`profile` it is their natural unique key (`itemId`,
  /// `flashcardId`, `lessonId`, the single profile row) since two exports
  /// can legitimately assign different row ids to what is the same item.
  /// Content tables are never touched.
  Future<BackupImportSummary> importSnapshot(BackupSnapshot snapshot);
}
