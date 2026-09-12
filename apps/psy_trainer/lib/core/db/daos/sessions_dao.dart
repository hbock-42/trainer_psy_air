import 'package:drift/drift.dart';

import '../../repositories/model/session.dart';
import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'sessions_dao.g.dart';

@DriftAccessor(tables: [Sessions])
class SessionsDao extends DatabaseAccessor<AppDatabase>
    with _$SessionsDaoMixin {
  SessionsDao(super.db);

  Future<void> insertSession(SessionsCompanion session) =>
      into(sessions).insert(session);

  Future<SessionRow?> byId(String id) =>
      (select(sessions)..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Deletes one session row (US-064 "delete a simulation"). Returns the
  /// number of rows removed (0 when unknown).
  Future<int> deleteById(String id) =>
      (delete(sessions)..where((t) => t.id.equals(id))).go();

  /// Sets the terminal [status], [score] and [endedAt]. Returns the number
  /// of rows changed (0 when the session does not exist).
  Future<int> finish(
    String id, {
    required SessionStatus status,
    required DateTime endedAt,
    required DateTime updatedAt,
    double? score,
  }) {
    return (update(sessions)..where((t) => t.id.equals(id))).write(
      SessionsCompanion(
        status: Value(status),
        score: Value(score),
        endedAt: Value(endedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  /// Sessions started within `[from, to]` (inclusive), newest first. Uses
  /// the `sessions_started_at` / `sessions_family_started_at` indexes.
  Future<List<SessionRow>> inRange({
    DateTime? from,
    DateTime? to,
    SessionMode? mode,
    String? familyId,
    SessionStatus? status,
    int? limit,
  }) {
    final query = select(sessions)
      ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]);
    if (from != null) {
      query.where((t) => t.startedAt.isBiggerOrEqualValue(from));
    }
    if (to != null) query.where((t) => t.startedAt.isSmallerOrEqualValue(to));
    if (mode != null) query.where((t) => t.mode.equalsValue(mode));
    if (familyId != null) query.where((t) => t.familyId.equals(familyId));
    if (status != null) query.where((t) => t.status.equalsValue(status));
    if (limit != null) query.limit(limit);
    return query.get();
  }
}
