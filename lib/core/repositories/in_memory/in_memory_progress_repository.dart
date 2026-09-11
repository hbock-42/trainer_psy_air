import '../model/attempt.dart';
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
      }
    }
    return stored;
  }

  @override
  Future<List<Attempt>> attemptsForSession(String sessionId) async =>
      attempts.where((a) => a.sessionId == sessionId).toList()
        ..sort((a, b) => a.position.compareTo(b.position));

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
  }

  // --- Lessons --------------------------------------------------------------

  @override
  Future<void> markLessonRead(String lessonId, {DateTime? readAt}) async {
    lessonsReadById.putIfAbsent(
      lessonId,
      () => LessonRead(lessonId: lessonId, readAt: readAt?.toUtc() ?? _now()),
    );
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
  }
}
