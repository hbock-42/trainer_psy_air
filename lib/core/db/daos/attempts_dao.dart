import 'package:drift/drift.dart';

import '../../repositories/model/session.dart';
import '../../repositories/model/stats.dart';
import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'attempts_dao.g.dart';

@DriftAccessor(tables: [Attempts, Sessions])
class AttemptsDao extends DatabaseAccessor<AppDatabase>
    with _$AttemptsDaoMixin {
  AttemptsDao(super.db);

  Future<void> insertAttempt(AttemptsCompanion attempt) =>
      into(attempts).insert(attempt);

  /// Inserts many attempts in one batch (single transaction, prepared
  /// statement reused), for cadence-driven activities flushing at the end.
  Future<void> insertAttempts(List<AttemptsCompanion> rows) =>
      batch((b) => b.insertAll(attempts, rows));

  /// Attempts of one session in stimulus order (`position`, not time: many
  /// attempts can share a timestamp).
  Future<List<AttemptRow>> bySession(String sessionId) =>
      (select(attempts)
            ..where((t) => t.sessionId.equals(sessionId))
            ..orderBy([(t) => OrderingTerm.asc(t.position)]))
          .get();

  Future<int> countBySession(String sessionId) async {
    final count = attempts.id.count();
    final query = selectOnly(attempts)
      ..addColumns([count])
      ..where(attempts.sessionId.equals(sessionId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  /// Per-family attempt count, correct count, mean and median response time
  /// over the attempts answered within `[from, to]` (inclusive, optional)
  /// and, optionally, sessions of one [mode]. Entirely in SQL: the median
  /// uses window functions (`ROW_NUMBER`/`COUNT` partitioned by family,
  /// SQLite >= 3.25) and averages the two middle values for even counts.
  Future<List<FamilyStats>> familyAggregates({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
  }) async {
    final where = <String>[];
    final variables = <Variable<Object>>[];
    if (from != null) {
      where.add('a.answered_at >= ?');
      variables.add(Variable<DateTime>(from.toUtc()));
    }
    if (to != null) {
      where.add('a.answered_at <= ?');
      variables.add(Variable<DateTime>(to.toUtc()));
    }
    if (mode != null) {
      where.add('s.mode = ?');
      variables.add(Variable<String>(mode.name));
    }
    final filter = where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}';

    final rows = await customSelect(
      '''
      WITH filtered AS (
        SELECT a.family_id, a.is_correct, a.response_ms
        FROM attempts a
        JOIN sessions s ON s.id = a.session_id
        $filter
      ),
      ranked AS (
        SELECT family_id, response_ms,
               ROW_NUMBER() OVER (
                 PARTITION BY family_id ORDER BY response_ms
               ) AS rn,
               COUNT(*) OVER (PARTITION BY family_id) AS cnt
        FROM filtered
      ),
      medians AS (
        SELECT family_id, AVG(response_ms) AS median_ms
        FROM ranked
        WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
        GROUP BY family_id
      ),
      totals AS (
        SELECT family_id,
               COUNT(*) AS attempts,
               SUM(is_correct) AS correct,
               AVG(response_ms) AS mean_ms
        FROM filtered
        GROUP BY family_id
      )
      SELECT t.family_id, t.attempts, t.correct, t.mean_ms, m.median_ms
      FROM totals t
      JOIN medians m ON m.family_id = t.family_id
      ORDER BY t.family_id
      ''',
      variables: variables,
      readsFrom: {attempts, sessions},
    ).get();

    return [
      for (final row in rows)
        FamilyStats(
          familyId: row.read<String>('family_id'),
          attempts: row.read<int>('attempts'),
          correct: row.read<int>('correct'),
          meanResponseMs: row.read<double>('mean_ms'),
          medianResponseMs: row.read<double>('median_ms'),
        ),
    ];
  }

  /// One row per (session, family) for the sessions started within
  /// `[from, to]` (inclusive, optional), oldest session first, optionally
  /// restricted to one [mode] and/or [familyId]: the score-over-time series
  /// (US-071). Same window-function median as [familyAggregates], partitioned
  /// by session and family; `unanswered` counts attempts without an answer
  /// payload (timeouts). Uses the `sessions_started_at` index.
  Future<List<SessionFamilyStats>> sessionFamilyAggregates({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
  }) async {
    final where = <String>[];
    final variables = <Variable<Object>>[];
    if (from != null) {
      where.add('s.started_at >= ?');
      variables.add(Variable<DateTime>(from.toUtc()));
    }
    if (to != null) {
      where.add('s.started_at <= ?');
      variables.add(Variable<DateTime>(to.toUtc()));
    }
    if (mode != null) {
      where.add('s.mode = ?');
      variables.add(Variable<String>(mode.name));
    }
    if (familyId != null) {
      where.add('a.family_id = ?');
      variables.add(Variable<String>(familyId));
    }
    final filter = where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}';

    final rows = await customSelect(
      '''
      WITH filtered AS (
        SELECT a.session_id, a.family_id, a.is_correct, a.response_ms,
               (a.answer IS NULL) AS unanswered,
               s.mode, s.started_at
        FROM attempts a
        JOIN sessions s ON s.id = a.session_id
        $filter
      ),
      ranked AS (
        SELECT session_id, family_id, response_ms,
               ROW_NUMBER() OVER (
                 PARTITION BY session_id, family_id ORDER BY response_ms
               ) AS rn,
               COUNT(*) OVER (PARTITION BY session_id, family_id) AS cnt
        FROM filtered
      ),
      medians AS (
        SELECT session_id, family_id, AVG(response_ms) AS median_ms
        FROM ranked
        WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
        GROUP BY session_id, family_id
      ),
      totals AS (
        SELECT session_id, family_id, mode, started_at,
               COUNT(*) AS attempts,
               SUM(is_correct) AS correct,
               SUM(unanswered) AS unanswered,
               AVG(response_ms) AS mean_ms
        FROM filtered
        GROUP BY session_id, family_id
      )
      SELECT t.session_id, t.family_id, t.mode, t.started_at, t.attempts,
             t.correct, t.unanswered, t.mean_ms, m.median_ms
      FROM totals t
      JOIN medians m
        ON m.session_id = t.session_id AND m.family_id = t.family_id
      ORDER BY t.started_at, t.session_id, t.family_id
      ''',
      variables: variables,
      readsFrom: {attempts, sessions},
    ).get();

    return [
      for (final row in rows)
        SessionFamilyStats(
          sessionId: row.read<String>('session_id'),
          familyId: row.read<String>('family_id'),
          mode: SessionMode.values.byName(row.read<String>('mode')),
          startedAt: row.read<DateTime>('started_at'),
          attempts: row.read<int>('attempts'),
          correct: row.read<int>('correct'),
          unanswered: row.read<int>('unanswered'),
          meanResponseMs: row.read<double>('mean_ms'),
          medianResponseMs: row.read<double>('median_ms'),
        ),
    ];
  }
}
