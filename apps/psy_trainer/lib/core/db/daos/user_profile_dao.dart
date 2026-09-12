import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'user_profile_dao.g.dart';

@DriftAccessor(tables: [UserProfiles])
class UserProfileDao extends DatabaseAccessor<AppDatabase>
    with _$UserProfileDaoMixin {
  UserProfileDao(super.db);

  Future<UserProfileRow?> get() => (select(
    userProfiles,
  )..where((t) => t.id.equals(UserProfiles.singletonId))).getSingleOrNull();

  /// Creates the single profile row or updates it (keeping `createdAt`).
  Future<void> save(UserProfilesCompanion profile) {
    final row = profile.copyWith(id: const Value(UserProfiles.singletonId));
    return into(userProfiles).insert(
      row,
      onConflict: DoUpdate(
        (_) => row.copyWith(
          id: const Value.absent(),
          createdAt: const Value.absent(),
        ),
      ),
    );
  }
}
