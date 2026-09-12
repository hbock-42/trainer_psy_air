// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_dao.dart';

// ignore_for_file: type=lint
mixin _$ContentDaoMixin on DatabaseAccessor<AppDatabase> {
  $ContentMetaTableTable get contentMetaTable =>
      attachedDatabase.contentMetaTable;
  $ModulesTable get modules => attachedDatabase.modules;
  $FamiliesTable get families => attachedDatabase.families;
  $ItemsTable get items => attachedDatabase.items;
  $PassagesTable get passages => attachedDatabase.passages;
  $LessonsTable get lessons => attachedDatabase.lessons;
  $DecksTable get decks => attachedDatabase.decks;
  $FlashcardsTable get flashcards => attachedDatabase.flashcards;
  $BlueprintsTable get blueprints => attachedDatabase.blueprints;
  ContentDaoManager get managers => ContentDaoManager(this);
}

class ContentDaoManager {
  final _$ContentDaoMixin _db;
  ContentDaoManager(this._db);
  $$ContentMetaTableTableTableManager get contentMetaTable =>
      $$ContentMetaTableTableTableManager(
        _db.attachedDatabase,
        _db.contentMetaTable,
      );
  $$ModulesTableTableManager get modules =>
      $$ModulesTableTableManager(_db.attachedDatabase, _db.modules);
  $$FamiliesTableTableManager get families =>
      $$FamiliesTableTableManager(_db.attachedDatabase, _db.families);
  $$ItemsTableTableManager get items =>
      $$ItemsTableTableManager(_db.attachedDatabase, _db.items);
  $$PassagesTableTableManager get passages =>
      $$PassagesTableTableManager(_db.attachedDatabase, _db.passages);
  $$LessonsTableTableManager get lessons =>
      $$LessonsTableTableManager(_db.attachedDatabase, _db.lessons);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db.attachedDatabase, _db.decks);
  $$FlashcardsTableTableManager get flashcards =>
      $$FlashcardsTableTableManager(_db.attachedDatabase, _db.flashcards);
  $$BlueprintsTableTableManager get blueprints =>
      $$BlueprintsTableTableManager(_db.attachedDatabase, _db.blueprints);
}
