// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_stats_dao.dart';

// ignore_for_file: type=lint
mixin _$ItemStatsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ItemStatsTable get itemStats => attachedDatabase.itemStats;
  ItemStatsDaoManager get managers => ItemStatsDaoManager(this);
}

class ItemStatsDaoManager {
  final _$ItemStatsDaoMixin _db;
  ItemStatsDaoManager(this._db);
  $$ItemStatsTableTableManager get itemStats =>
      $$ItemStatsTableTableManager(_db.attachedDatabase, _db.itemStats);
}
