import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../repositories/model/attempt.dart';
import '../../repositories/model/learning.dart';
import '../../repositories/model/session.dart';
import '../../repositories/model/stats.dart';
import '../../repositories/progress_repository.dart';
import '../app_database.dart';
import '../tables/progress_tables.dart';

/// Generates row ids; defaults to uuid v4.
typedef IdGenerator = String Function();

/// Supplies "now"; defaults to `DateTime.now()`. Injected in tests.
typedef Clock = DateTime Function();

/// [ProgressRepository] backed by Drift (US-011 DAOs).
///
/// Ids and timestamps are produced here, never by SQLite, so the same rows
/// can be created offline and merged later (EPIC-13). All timestamps are
/// normalised to UTC before being written.
class LocalProgressRepository implements ProgressRepository {
  LocalProgressRepository(this._db, {IdGenerator? newId, Clock? clock})
    : _newId = newId ?? const Uuid().v4,
      _clock = clock ?? DateTime.now;

  final AppDatabase _db;
  final IdGenerator _newId;
  final Clock _clock;

  DateTime _now() => _clock().toUtc();

  // --- Sessions -------------------------------------------------------------

  @override
  Future<TrainingSession> startSession({
    required SessionMode mode,
    String? familyId,
    String? blueprintId,
    Map<String, Object?> config = const {},
    DateTime? startedAt,
  }) async {
    final now = _now();
    final session = TrainingSession(
      id: _newId(),
      mode: mode,
      familyId: familyId,
      blueprintId: blueprintId,
      startedAt: startedAt?.toUtc() ?? now,
      status: SessionStatus.inProgress,
      config: config,
    );
    await _db.sessionsDao.insertSession(
      SessionsCompanion.insert(
        id: session.id,
        mode: session.mode,
        familyId: Value(session.familyId),
        blueprintId: Value(session.blueprintId),
        startedAt: session.startedAt,
        status: session.status,
        config: session.config,
        createdAt: now,
        updatedAt: now,
      ),
    );
    return session;
  }

  @override
  Future<TrainingSession> finishSession(
    String sessionId, {
    required SessionStatus status,
    double? score,
    DateTime? endedAt,
  }) async {
    if (status == SessionStatus.inProgress) {
      throw ArgumentError.value(status, 'status', 'must be a terminal status');
    }
    final now = _now();
    final changed = await _db.sessionsDao.finish(
      sessionId,
      status: status,
      score: score,
      endedAt: endedAt?.toUtc() ?? now,
      updatedAt: now,
    );
    if (changed == 0) throw StateError('unknown session $sessionId');
    return (await sessionById(sessionId))!;
  }

  @override
  Future<TrainingSession?> sessionById(String id) async {
    final row = await _db.sessionsDao.byId(id);
    return row == null ? null : _session(row);
  }

  @override
  Future<List<TrainingSession>> sessions({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
    SessionStatus? status,
    int? limit,
  }) async {
    final rows = await _db.sessionsDao.inRange(
      from: from?.toUtc(),
      to: to?.toUtc(),
      mode: mode,
      familyId: familyId,
      status: status,
      limit: limit,
    );
    return [for (final row in rows) _session(row)];
  }

  @override
  Future<void> deleteSession(String sessionId) => _db.transaction(() async {
    await _db.attemptsDao.deleteBySession(sessionId);
    await _db.sessionsDao.deleteById(sessionId);
  });

  // --- Attempts -------------------------------------------------------------

  @override
  Future<Attempt> recordAttempt(NewAttempt attempt) async =>
      (await recordAttempts([attempt])).single;

  @override
  Future<List<Attempt>> recordAttempts(List<NewAttempt> attempts) async {
    if (attempts.isEmpty) return const [];
    final now = _now();
    final stored = [
      for (final draft in attempts)
        Attempt(
          id: _newId(),
          sessionId: draft.sessionId,
          familyId: draft.familyId,
          itemId: draft.itemId,
          origin: draft.origin,
          answer: draft.answer,
          isCorrect: draft.isCorrect,
          responseMs: draft.responseMs,
          position: draft.position,
          sectionIndex: draft.sectionIndex,
          answeredAt: draft.answeredAt?.toUtc() ?? now,
        ),
    ];
    await _db.transaction(() async {
      await _db.attemptsDao.insertAttempts([
        for (final a in stored)
          AttemptsCompanion.insert(
            id: a.id,
            sessionId: a.sessionId,
            familyId: a.familyId,
            itemId: Value(a.itemId),
            origin: Value(a.origin?.toJson()),
            answer: Value(a.answer),
            isCorrect: a.isCorrect,
            responseMs: a.responseMs,
            position: a.position,
            sectionIndex: Value(a.sectionIndex),
            answeredAt: a.answeredAt,
            createdAt: now,
            updatedAt: now,
          ),
      ]);
      for (final a in stored) {
        final itemId = a.itemId;
        if (itemId == null) continue;
        await _db.itemStatsDao.recordOutcome(
          newId: _newId(),
          itemId: itemId,
          familyId: a.familyId,
          isCorrect: a.isCorrect,
          responseMs: a.responseMs,
          at: a.answeredAt,
        );
      }
    });
    return stored;
  }

  @override
  Future<List<Attempt>> attemptsForSession(String sessionId) async => [
    for (final row in await _db.attemptsDao.bySession(sessionId)) _attempt(row),
  ];

  @override
  Future<List<Attempt>> attemptsForFamily({
    required String familyId,
    DateTime? from,
    DateTime? to,
  }) async => [
    for (final row in await _db.attemptsDao.byFamily(
      familyId: familyId,
      from: from?.toUtc(),
      to: to?.toUtc(),
    ))
      _attempt(row),
  ];

  // --- Aggregates -----------------------------------------------------------

  @override
  Future<List<FamilyStats>> familyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
  }) => _db.attemptsDao.familyAggregates(from: from, to: to, mode: mode);

  @override
  Future<List<SessionFamilyStats>> sessionFamilyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
  }) => _db.attemptsDao.sessionFamilyAggregates(
    from: from,
    to: to,
    mode: mode,
    familyId: familyId,
  );

  @override
  Future<ItemStat?> itemStat(String itemId) async {
    final row = await _db.itemStatsDao.byItem(itemId);
    return row == null ? null : _itemStat(row);
  }

  @override
  Future<List<ItemStat>> itemStats({
    String? familyId,
    bool failedOnly = false,
  }) async => [
    for (final row in await _db.itemStatsDao.list(
      familyId: familyId,
      failedOnly: failedOnly,
    ))
      _itemStat(row),
  ];

  // --- Flashcards -----------------------------------------------------------

  @override
  Future<FlashcardReview?> flashcardReview(String flashcardId) async {
    final row = await _db.flashcardReviewsDao.byCard(flashcardId);
    return row == null ? null : _review(row);
  }

  @override
  Future<List<FlashcardReview>> dueFlashcardReviews({
    required DateTime now,
    String? deckId,
    int? limit,
  }) async => [
    for (final row in await _db.flashcardReviewsDao.due(
      now: now.toUtc(),
      deckId: deckId,
      limit: limit,
    ))
      _review(row),
  ];

  @override
  Future<void> saveFlashcardReview(FlashcardReview review) {
    final now = _now();
    return _db.flashcardReviewsDao.upsert(
      FlashcardReviewsCompanion.insert(
        id: _newId(),
        flashcardId: review.flashcardId,
        deckId: review.deckId,
        box: review.box,
        reviews: review.reviews,
        lapses: review.lapses,
        lastReviewedAt: Value(review.lastReviewedAt?.toUtc()),
        nextReviewAt: review.nextReviewAt.toUtc(),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  // --- Lessons --------------------------------------------------------------

  @override
  Future<void> markLessonRead(String lessonId, {DateTime? readAt}) {
    final now = _now();
    return _db.lessonProgressDao.markRead(
      LessonProgressCompanion.insert(
        id: _newId(),
        lessonId: lessonId,
        readAt: readAt?.toUtc() ?? now,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  @override
  Future<List<LessonRead>> lessonsRead() async => [
    for (final row in await _db.lessonProgressDao.all())
      LessonRead(lessonId: row.lessonId, readAt: row.readAt),
  ];

  // --- Profile --------------------------------------------------------------

  @override
  Future<UserProfile?> profile() async {
    final row = await _db.userProfileDao.get();
    if (row == null) return null;
    return UserProfile(
      locale: row.locale,
      settings: row.settings,
      examDate: row.examDate,
      targetStage: row.targetStage,
    );
  }

  @override
  Future<void> saveProfile(UserProfile profile) {
    final now = _now();
    return _db.userProfileDao.save(
      UserProfilesCompanion.insert(
        id: UserProfiles.singletonId,
        examDate: Value(profile.examDate?.toUtc()),
        targetStage: Value(profile.targetStage),
        locale: profile.locale,
        settings: profile.settings,
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  // --- Mapping --------------------------------------------------------------

  static TrainingSession _session(SessionRow row) => TrainingSession(
    id: row.id,
    mode: row.mode,
    familyId: row.familyId,
    blueprintId: row.blueprintId,
    startedAt: row.startedAt,
    endedAt: row.endedAt,
    status: row.status,
    score: row.score,
    config: row.config,
  );

  static Attempt _attempt(AttemptRow row) => Attempt(
    id: row.id,
    sessionId: row.sessionId,
    familyId: row.familyId,
    itemId: row.itemId,
    origin: row.origin == null ? null : AttemptOrigin.fromJson(row.origin!),
    answer: row.answer,
    isCorrect: row.isCorrect,
    responseMs: row.responseMs,
    position: row.position,
    sectionIndex: row.sectionIndex,
    answeredAt: row.answeredAt,
  );

  static ItemStat _itemStat(ItemStatRow row) => ItemStat(
    itemId: row.itemId,
    familyId: row.familyId,
    seen: row.seen,
    correct: row.correct,
    totalResponseMs: row.totalResponseMs,
    lastCorrect: row.lastCorrect,
    lastSeenAt: row.lastSeenAt,
  );

  static FlashcardReview _review(FlashcardReviewRow row) => FlashcardReview(
    flashcardId: row.flashcardId,
    deckId: row.deckId,
    box: row.box,
    reviews: row.reviews,
    lapses: row.lapses,
    lastReviewedAt: row.lastReviewedAt,
    nextReviewAt: row.nextReviewAt,
  );
}
