import '../model/attempt.dart';
import '../model/backup.dart';
import '../model/learning.dart';
import '../model/session.dart';
import '../model/stats.dart';
import '../progress_repository.dart';

/// [ProgressRepository] over plain Dart collections, for widget tests.
///
/// Mirrors the semantics of the Drift implementation (UTC timestamps,
/// position ordering, item stats folded on every bank attempt, median of the
/// two middle values) so a feature tested against the fake behaves the same
/// against SQLite. Ids are sequential (`session-1`, `attempt-1`...) unless
/// [newId] is given; [clock] defaults to `DateTime.now()`.
class InMemoryProgressRepository implements ProgressRepository {
  InMemoryProgressRepository({
    String Function()? newId,
    DateTime Function()? clock,
  }) : _newId = newId,
       _clock = clock ?? DateTime.now;

  final String Function()? _newId;
  final DateTime Function() _clock;
  final Map<String, int> _counters = {};

  final Map<String, TrainingSession> sessionsById = {};
  final List<Attempt> attempts = [];
  final Map<String, ItemStat> itemStatsById = {};
  final Map<String, FlashcardReview> reviewsByCard = {};
  final Map<String, LessonRead> lessonsReadById = {};
  UserProfile? storedProfile;

  // Audit bookkeeping for the backup format (US-074): the public domain
  // models (`TrainingSession`, `ItemStat`...) do not carry `updatedAt`
  // (that is a Drift-row-only concern in the real app), so this fake tracks
  // it, and a synthetic row id for the tables keyed by a natural key
  // instead (`itemStats`, `flashcardReviews`, `lessonProgress`, `profile`),
  // purely to exercise `exportSnapshot`/`importSnapshot` the same way the
  // Drift-backed repository does.
  final Map<String, DateTime> _sessionUpdatedAt = {};
  final Map<String, DateTime> _attemptUpdatedAt = {};
  final Map<String, String> _itemStatId = {};
  final Map<String, DateTime> _itemStatUpdatedAt = {};
  final Map<String, String> _reviewId = {};
  final Map<String, DateTime> _reviewUpdatedAt = {};
  final Map<String, String> _lessonRowId = {};
  final Map<String, DateTime> _lessonUpdatedAt = {};
  String? _profileId;
  DateTime? _profileUpdatedAt;

  DateTime _now() => _clock().toUtc();

  String _id(String prefix) {
    final custom = _newId;
    if (custom != null) return custom();
    final n = (_counters[prefix] ?? 0) + 1;
    _counters[prefix] = n;
    return '$prefix-$n';
  }

  // --- Sessions -------------------------------------------------------------

  @override
  Future<TrainingSession> startSession({
    required SessionMode mode,
    String? familyId,
    String? blueprintId,
    Map<String, Object?> config = const {},
    DateTime? startedAt,
  }) async {
    final session = TrainingSession(
      id: _id('session'),
      mode: mode,
      familyId: familyId,
      blueprintId: blueprintId,
      startedAt: startedAt?.toUtc() ?? _now(),
      status: SessionStatus.inProgress,
      config: config,
    );
    sessionsById[session.id] = session;
    _sessionUpdatedAt[session.id] = _now();
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
    final session = sessionsById[sessionId];
    if (session == null) throw StateError('unknown session $sessionId');
    final finished = session.copyWith(
      status: status,
      score: score,
      endedAt: endedAt?.toUtc() ?? _now(),
    );
    sessionsById[sessionId] = finished;
    _sessionUpdatedAt[sessionId] = _now();
    return finished;
  }

  @override
  Future<TrainingSession?> sessionById(String id) async => sessionsById[id];

  @override
  Future<List<TrainingSession>> sessions({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
    SessionStatus? status,
    int? limit,
  }) async {
    final result =
        sessionsById.values
            .where(
              (s) =>
                  (from == null || !s.startedAt.isBefore(from.toUtc())) &&
                  (to == null || !s.startedAt.isAfter(to.toUtc())) &&
                  (mode == null || s.mode == mode) &&
                  (familyId == null || s.familyId == familyId) &&
                  (status == null || s.status == status),
            )
            .toList()
          ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return limit == null ? result : result.take(limit).toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    sessionsById.remove(sessionId);
    _sessionUpdatedAt.remove(sessionId);
    attempts.removeWhere((a) => a.sessionId == sessionId);
    _attemptUpdatedAt.removeWhere((id, _) => !attempts.any((a) => a.id == id));
  }

  // --- Attempts -------------------------------------------------------------

  @override
  Future<Attempt> recordAttempt(NewAttempt attempt) async =>
      (await recordAttempts([attempt])).single;

  @override
  Future<List<Attempt>> recordAttempts(List<NewAttempt> drafts) async {
    final now = _now();
    final stored = <Attempt>[];
    for (final draft in drafts) {
      final attempt = Attempt(
        id: _id('attempt'),
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
      );
      attempts.add(attempt);
      _attemptUpdatedAt[attempt.id] = now;
      stored.add(attempt);
      final itemId = attempt.itemId;
      if (itemId != null) {
        final old = itemStatsById[itemId];
        itemStatsById[itemId] = ItemStat(
          itemId: itemId,
          familyId: attempt.familyId,
          seen: (old?.seen ?? 0) + 1,
          correct: (old?.correct ?? 0) + (attempt.isCorrect ? 1 : 0),
          totalResponseMs: (old?.totalResponseMs ?? 0) + attempt.responseMs,
          lastCorrect: attempt.isCorrect,
          lastSeenAt: attempt.answeredAt,
        );
        _itemStatId.putIfAbsent(itemId, () => _id('itemstat'));
        _itemStatUpdatedAt[itemId] = now;
      }
    }
    return stored;
  }

  @override
  Future<List<Attempt>> attemptsForSession(String sessionId) async =>
      attempts.where((a) => a.sessionId == sessionId).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

  @override
  Future<List<Attempt>> allAttempts() async => List.of(attempts);

  @override
  Future<List<Attempt>> attemptsForFamily({
    required String familyId,
    DateTime? from,
    DateTime? to,
  }) async =>
      attempts
          .where(
            (a) =>
                a.familyId == familyId &&
                (from == null || !a.answeredAt.isBefore(from.toUtc())) &&
                (to == null || !a.answeredAt.isAfter(to.toUtc())),
          )
          .toList()
        ..sort((a, b) => a.answeredAt.compareTo(b.answeredAt));

  // --- Aggregates -----------------------------------------------------------

  @override
  Future<List<FamilyStats>> familyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
  }) async {
    final byFamily = <String, List<Attempt>>{};
    for (final a in attempts) {
      if (from != null && a.answeredAt.isBefore(from.toUtc())) continue;
      if (to != null && a.answeredAt.isAfter(to.toUtc())) continue;
      if (mode != null && sessionsById[a.sessionId]?.mode != mode) continue;
      byFamily.putIfAbsent(a.familyId, () => []).add(a);
    }
    final families = byFamily.keys.toList()..sort();
    return [
      for (final familyId in families)
        () {
          final rows = byFamily[familyId]!;
          return FamilyStats(
            familyId: familyId,
            attempts: rows.length,
            correct: rows.where((a) => a.isCorrect).length,
            meanResponseMs: _mean(rows),
            medianResponseMs: _median(rows),
          );
        }(),
    ];
  }

  @override
  Future<List<SessionFamilyStats>> sessionFamilyStats({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
  }) async {
    final byKey = <(String, int?, String), List<Attempt>>{};
    for (final a in attempts) {
      final session = sessionsById[a.sessionId];
      if (session == null) continue;
      if (from != null && session.startedAt.isBefore(from.toUtc())) continue;
      if (to != null && session.startedAt.isAfter(to.toUtc())) continue;
      if (mode != null && session.mode != mode) continue;
      if (familyId != null && a.familyId != familyId) continue;
      byKey
          .putIfAbsent((a.sessionId, a.sectionIndex, a.familyId), () => [])
          .add(a);
    }
    final rows = [
      for (final MapEntry(key: (sessionId, section, family), value: group)
          in byKey.entries)
        SessionFamilyStats(
          sessionId: sessionId,
          familyId: family,
          sectionIndex: section,
          mode: sessionsById[sessionId]!.mode,
          startedAt: sessionsById[sessionId]!.startedAt,
          attempts: group.length,
          correct: group.where((a) => a.isCorrect).length,
          unanswered: group.where((a) => a.answer == null).length,
          meanResponseMs: _mean(group),
          medianResponseMs: _median(group),
        ),
    ];
    return rows..sort((a, b) {
      final byDate = a.startedAt.compareTo(b.startedAt);
      if (byDate != 0) return byDate;
      final bySession = a.sessionId.compareTo(b.sessionId);
      if (bySession != 0) return bySession;
      final bySection = (a.sectionIndex ?? -1).compareTo(b.sectionIndex ?? -1);
      if (bySection != 0) return bySection;
      return a.familyId.compareTo(b.familyId);
    });
  }

  static double _mean(List<Attempt> rows) =>
      rows.fold<int>(0, (s, a) => s + a.responseMs) / rows.length;

  static double _median(List<Attempt> rows) {
    final times = rows.map((a) => a.responseMs).toList()..sort();
    final n = times.length;
    return n.isOdd
        ? times[n ~/ 2].toDouble()
        : (times[n ~/ 2 - 1] + times[n ~/ 2]) / 2;
  }

  @override
  Future<ItemStat?> itemStat(String itemId) async => itemStatsById[itemId];

  @override
  Future<List<ItemStat>> itemStats({
    String? familyId,
    bool failedOnly = false,
  }) async =>
      itemStatsById.values
          .where(
            (s) =>
                (familyId == null || s.familyId == familyId) &&
                (!failedOnly || !s.lastCorrect),
          )
          .toList()
        ..sort((a, b) => b.lastSeenAt.compareTo(a.lastSeenAt));

  // --- Flashcards -----------------------------------------------------------

  @override
  Future<FlashcardReview?> flashcardReview(String flashcardId) async =>
      reviewsByCard[flashcardId];

  @override
  Future<List<FlashcardReview>> dueFlashcardReviews({
    required DateTime now,
    String? deckId,
    int? limit,
  }) async {
    final due =
        reviewsByCard.values
            .where(
              (r) =>
                  !r.nextReviewAt.isAfter(now.toUtc()) &&
                  (deckId == null || r.deckId == deckId),
            )
            .toList()
          ..sort((a, b) => a.nextReviewAt.compareTo(b.nextReviewAt));
    return limit == null ? due : due.take(limit).toList();
  }

  @override
  Future<void> saveFlashcardReview(FlashcardReview review) async {
    reviewsByCard[review.flashcardId] = review.copyWith(
      nextReviewAt: review.nextReviewAt.toUtc(),
      lastReviewedAt: review.lastReviewedAt?.toUtc(),
    );
    _reviewId.putIfAbsent(review.flashcardId, () => _id('review'));
    _reviewUpdatedAt[review.flashcardId] = _now();
  }

  @override
  Future<List<FlashcardReview>> allFlashcardReviews() async =>
      reviewsByCard.values.toList();

  // --- Lessons --------------------------------------------------------------

  @override
  Future<void> markLessonRead(String lessonId, {DateTime? readAt}) async {
    lessonsReadById.putIfAbsent(
      lessonId,
      () => LessonRead(lessonId: lessonId, readAt: readAt?.toUtc() ?? _now()),
    );
    _lessonRowId.putIfAbsent(lessonId, () => _id('lesson'));
    _lessonUpdatedAt.putIfAbsent(lessonId, _now);
  }

  @override
  Future<List<LessonRead>> lessonsRead() async =>
      lessonsReadById.values.toList()
        ..sort((a, b) => a.readAt.compareTo(b.readAt));

  // --- Profile --------------------------------------------------------------

  @override
  Future<UserProfile?> profile() async => storedProfile;

  @override
  Future<void> saveProfile(UserProfile profile) async {
    storedProfile = profile.copyWith(examDate: profile.examDate?.toUtc());
    _profileId ??= 'me';
    _profileUpdatedAt = _now();
  }

  // --- Reset ------------------------------------------------------------

  @override
  Future<void> clearAll() async {
    sessionsById.clear();
    attempts.clear();
    itemStatsById.clear();
    reviewsByCard.clear();
    lessonsReadById.clear();
    storedProfile = null;
    _sessionUpdatedAt.clear();
    _attemptUpdatedAt.clear();
    _itemStatId.clear();
    _itemStatUpdatedAt.clear();
    _reviewId.clear();
    _reviewUpdatedAt.clear();
    _lessonRowId.clear();
    _lessonUpdatedAt.clear();
    _profileId = null;
    _profileUpdatedAt = null;
  }

  // --- Backup (US-074) -------------------------------------------------

  @override
  Future<BackupSnapshot> exportSnapshot() async {
    return BackupSnapshot(
      sessions: [
        for (final s in sessionsById.values)
          BackupRow(
            id: s.id,
            updatedAt: _sessionUpdatedAt[s.id] ?? _now(),
            fields: _sessionFields(s),
          ),
      ],
      attempts: [
        for (final a in attempts)
          BackupRow(
            id: a.id,
            updatedAt: _attemptUpdatedAt[a.id] ?? _now(),
            fields: _attemptFields(a),
          ),
      ],
      itemStats: [
        for (final entry in itemStatsById.entries)
          BackupRow(
            id: _itemStatId[entry.key] ?? entry.key,
            updatedAt: _itemStatUpdatedAt[entry.key] ?? _now(),
            fields: _itemStatFields(entry.value),
          ),
      ],
      flashcardReviews: [
        for (final entry in reviewsByCard.entries)
          BackupRow(
            id: _reviewId[entry.key] ?? entry.key,
            updatedAt: _reviewUpdatedAt[entry.key] ?? _now(),
            fields: _reviewFields(entry.value),
          ),
      ],
      lessonProgress: [
        for (final entry in lessonsReadById.entries)
          BackupRow(
            id: _lessonRowId[entry.key] ?? entry.key,
            updatedAt: _lessonUpdatedAt[entry.key] ?? _now(),
            fields: {
              'lessonId': entry.value.lessonId,
              'readAt': entry.value.readAt.toIso8601String(),
            },
          ),
      ],
      profile: storedProfile == null
          ? null
          : BackupRow(
              id: _profileId ?? 'me',
              updatedAt: _profileUpdatedAt ?? _now(),
              fields: _profileFields(storedProfile!),
            ),
    );
  }

  @override
  Future<BackupImportSummary> importSnapshot(BackupSnapshot snapshot) async {
    var inserted = 0;
    var updated = 0;
    var skipped = 0;

    for (final r in snapshot.sessions) {
      final session = _sessionFromFields(r.fields);
      final existingUpdatedAt = _sessionUpdatedAt[session.id];
      if (existingUpdatedAt == null) {
        sessionsById[session.id] = session;
        _sessionUpdatedAt[session.id] = r.updatedAt;
        inserted++;
      } else if (existingUpdatedAt.isBefore(r.updatedAt)) {
        sessionsById[session.id] = session;
        _sessionUpdatedAt[session.id] = r.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }
    for (final r in snapshot.attempts) {
      final attempt = _attemptFromFields(r.fields);
      final existingUpdatedAt = _attemptUpdatedAt[attempt.id];
      if (existingUpdatedAt == null) {
        attempts.add(attempt);
        _attemptUpdatedAt[attempt.id] = r.updatedAt;
        inserted++;
      } else if (existingUpdatedAt.isBefore(r.updatedAt)) {
        attempts
          ..removeWhere((a) => a.id == attempt.id)
          ..add(attempt);
        _attemptUpdatedAt[attempt.id] = r.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }
    for (final r in snapshot.itemStats) {
      final stat = _itemStatFromFields(r.fields);
      final existingUpdatedAt = _itemStatUpdatedAt[stat.itemId];
      if (existingUpdatedAt == null) {
        itemStatsById[stat.itemId] = stat;
        _itemStatId[stat.itemId] = r.id;
        _itemStatUpdatedAt[stat.itemId] = r.updatedAt;
        inserted++;
      } else if (existingUpdatedAt.isBefore(r.updatedAt)) {
        itemStatsById[stat.itemId] = stat;
        _itemStatUpdatedAt[stat.itemId] = r.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }
    for (final r in snapshot.flashcardReviews) {
      final review = _reviewFromFields(r.fields);
      final existingUpdatedAt = _reviewUpdatedAt[review.flashcardId];
      if (existingUpdatedAt == null) {
        reviewsByCard[review.flashcardId] = review;
        _reviewId[review.flashcardId] = r.id;
        _reviewUpdatedAt[review.flashcardId] = r.updatedAt;
        inserted++;
      } else if (existingUpdatedAt.isBefore(r.updatedAt)) {
        reviewsByCard[review.flashcardId] = review;
        _reviewUpdatedAt[review.flashcardId] = r.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }
    for (final r in snapshot.lessonProgress) {
      final lessonId = r.fields['lessonId']! as String;
      final readAt = DateTime.parse(r.fields['readAt']! as String).toUtc();
      final existingUpdatedAt = _lessonUpdatedAt[lessonId];
      if (existingUpdatedAt == null) {
        lessonsReadById[lessonId] = LessonRead(
          lessonId: lessonId,
          readAt: readAt,
        );
        _lessonRowId[lessonId] = r.id;
        _lessonUpdatedAt[lessonId] = r.updatedAt;
        inserted++;
      } else if (existingUpdatedAt.isBefore(r.updatedAt)) {
        lessonsReadById[lessonId] = LessonRead(
          lessonId: lessonId,
          readAt: readAt,
        );
        _lessonUpdatedAt[lessonId] = r.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }
    final profileBackup = snapshot.profile;
    if (profileBackup != null) {
      final profile = _profileFromFields(profileBackup.fields);
      if (_profileUpdatedAt == null) {
        storedProfile = profile;
        _profileId = profileBackup.id;
        _profileUpdatedAt = profileBackup.updatedAt;
        inserted++;
      } else if (_profileUpdatedAt!.isBefore(profileBackup.updatedAt)) {
        storedProfile = profile;
        _profileUpdatedAt = profileBackup.updatedAt;
        updated++;
      } else {
        skipped++;
      }
    }

    return BackupImportSummary(
      inserted: inserted,
      updated: updated,
      skipped: skipped,
    );
  }

  static Map<String, Object?> _sessionFields(TrainingSession s) => {
    'id': s.id,
    'mode': s.mode.name,
    'familyId': s.familyId,
    'blueprintId': s.blueprintId,
    'startedAt': s.startedAt.toIso8601String(),
    'endedAt': s.endedAt?.toIso8601String(),
    'status': s.status.name,
    'score': s.score,
    'config': s.config,
  };

  static TrainingSession _sessionFromFields(Map<String, Object?> f) =>
      TrainingSession(
        id: f['id']! as String,
        mode: SessionMode.values.byName(f['mode']! as String),
        familyId: f['familyId'] as String?,
        blueprintId: f['blueprintId'] as String?,
        startedAt: DateTime.parse(f['startedAt']! as String).toUtc(),
        endedAt: f['endedAt'] == null
            ? null
            : DateTime.parse(f['endedAt']! as String).toUtc(),
        status: SessionStatus.values.byName(f['status']! as String),
        score: (f['score'] as num?)?.toDouble(),
        config: (f['config'] as Map?)?.cast<String, Object?>() ?? const {},
      );

  static Map<String, Object?> _attemptFields(Attempt a) => {
    'id': a.id,
    'sessionId': a.sessionId,
    'familyId': a.familyId,
    'itemId': a.itemId,
    'origin': a.origin?.toJson(),
    'answer': a.answer,
    'isCorrect': a.isCorrect,
    'responseMs': a.responseMs,
    'position': a.position,
    'answeredAt': a.answeredAt.toIso8601String(),
    'sectionIndex': a.sectionIndex,
  };

  static Attempt _attemptFromFields(Map<String, Object?> f) => Attempt(
    id: f['id']! as String,
    sessionId: f['sessionId']! as String,
    familyId: f['familyId']! as String,
    itemId: f['itemId'] as String?,
    origin: f['origin'] == null
        ? null
        : AttemptOrigin.fromJson((f['origin']! as Map).cast<String, Object?>()),
    answer: (f['answer'] as Map?)?.cast<String, Object?>(),
    isCorrect: f['isCorrect']! as bool,
    responseMs: f['responseMs']! as int,
    position: f['position']! as int,
    answeredAt: DateTime.parse(f['answeredAt']! as String).toUtc(),
    sectionIndex: f['sectionIndex'] as int?,
  );

  static Map<String, Object?> _itemStatFields(ItemStat s) => {
    'itemId': s.itemId,
    'familyId': s.familyId,
    'seen': s.seen,
    'correct': s.correct,
    'totalResponseMs': s.totalResponseMs,
    'lastCorrect': s.lastCorrect,
    'lastSeenAt': s.lastSeenAt.toIso8601String(),
  };

  static ItemStat _itemStatFromFields(Map<String, Object?> f) => ItemStat(
    itemId: f['itemId']! as String,
    familyId: f['familyId']! as String,
    seen: f['seen']! as int,
    correct: f['correct']! as int,
    totalResponseMs: f['totalResponseMs']! as int,
    lastCorrect: f['lastCorrect']! as bool,
    lastSeenAt: DateTime.parse(f['lastSeenAt']! as String).toUtc(),
  );

  static Map<String, Object?> _reviewFields(FlashcardReview r) => {
    'flashcardId': r.flashcardId,
    'deckId': r.deckId,
    'box': r.box,
    'reviews': r.reviews,
    'lapses': r.lapses,
    'lastReviewedAt': r.lastReviewedAt?.toIso8601String(),
    'nextReviewAt': r.nextReviewAt.toIso8601String(),
  };

  static FlashcardReview _reviewFromFields(Map<String, Object?> f) =>
      FlashcardReview(
        flashcardId: f['flashcardId']! as String,
        deckId: f['deckId']! as String,
        box: f['box']! as int,
        reviews: f['reviews']! as int,
        lapses: f['lapses']! as int,
        lastReviewedAt: f['lastReviewedAt'] == null
            ? null
            : DateTime.parse(f['lastReviewedAt']! as String).toUtc(),
        nextReviewAt: DateTime.parse(f['nextReviewAt']! as String).toUtc(),
      );

  static Map<String, Object?> _profileFields(UserProfile p) => {
    'locale': p.locale,
    'settings': p.settings,
    'examDate': p.examDate?.toIso8601String(),
    'targetStage': p.targetStage,
  };

  static UserProfile _profileFromFields(Map<String, Object?> f) => UserProfile(
    locale: f['locale']! as String,
    settings: (f['settings'] as Map?)?.cast<String, Object?>() ?? const {},
    examDate: f['examDate'] == null
        ? null
        : DateTime.parse(f['examDate']! as String).toUtc(),
    targetStage: f['targetStage'] as String?,
  );
}
