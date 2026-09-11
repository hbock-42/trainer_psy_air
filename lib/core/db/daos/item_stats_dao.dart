import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'item_stats_dao.g.dart';

@DriftAccessor(tables: [ItemStats])
class ItemStatsDao extends DatabaseAccessor<AppDatabase>
    with _$ItemStatsDaoMixin {
  ItemStatsDao(super.db);

  /// Folds one outcome into the item's counters with a single
  /// `INSERT ... ON CONFLICT (item_id) DO UPDATE` (increments happen in SQL,
  /// so concurrent writers never lose an update). [newId] is only used when
  /// the row does not exist yet.
  Future<void> recordOutcome({
    required String newId,
    required String itemId,
    required String familyId,
    required bool isCorrect,
    required int responseMs,
    required DateTime at,
  }) {
    return into(itemStats).insert(
      ItemStatsCompanion.insert(
        id: newId,
        itemId: itemId,
        familyId: familyId,
        seen: 1,
        correct: isCorrect ? 1 : 0,
        totalResponseMs: responseMs,
        lastCorrect: isCorrect,
        lastSeenAt: at,
        createdAt: at,
        updatedAt: at,
      ),
      onConflict: DoUpdate(
        (old) => ItemStatsCompanion.custom(
          seen: old.seen + const Constant(1),
          correct: old.correct + Constant(isCorrect ? 1 : 0),
          totalResponseMs: old.totalResponseMs + Constant(responseMs),
          lastCorrect: Constant(isCorrect),
          lastSeenAt: Variable<DateTime>(at),
          updatedAt: Variable<DateTime>(at),
        ),
        target: [itemStats.itemId],
      ),
    );
  }

  Future<ItemStatRow?> byItem(String itemId) => (select(
    itemStats,
  )..where((t) => t.itemId.equals(itemId))).getSingleOrNull();

  /// Stats ordered by most recently seen. [failedOnly] keeps items whose last
  /// attempt was wrong (uses the `(family_id, last_correct)` index).
  Future<List<ItemStatRow>> list({String? familyId, bool failedOnly = false}) {
    final query = select(itemStats)
      ..orderBy([(t) => OrderingTerm.desc(t.lastSeenAt)]);
    if (familyId != null) query.where((t) => t.familyId.equals(familyId));
    if (failedOnly) query.where((t) => t.lastCorrect.equals(false));
    return query.get();
  }
}
