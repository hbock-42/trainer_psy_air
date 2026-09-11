import 'package:drift/drift.dart';

import '../converters.dart';
import 'base_tables.dart';

// Content mirrors: one row per seeded entity, keyed by the content id from the
// bundle (a stable slug, not a uuid). The full entity is kept as a JSON blob
// decoded through the US-010 models; only the fields needed to filter or order
// in SQL are denormalised into columns. This keeps the schema stable while the
// content contract evolves (US-015).
//
// Rows are replaced wholesale by the seeder (US-013), so `createdAt` is the
// seeding time.

/// Single-row table (`id == ContentMetaTable.singletonId`) recording which
/// content bundle version is mirrored in the database.
@DataClassName('ContentMetaRow')
class ContentMetaTable extends Table with AuditedTable {
  static const String singletonId = 'content';

  @override
  String get tableName => 'content_meta';

  IntColumn get schemaVersion => integer()();
  IntColumn get contentVersion => integer()();
  DateTimeColumn get seededAt => dateTime()();
}

/// Mirror of `<module>/module.json`.
@DataClassName('ModuleRow')
class Modules extends Table with AuditedTable {
  IntColumn get sortOrder => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// Mirror of `<module>/<family>/family.json`.
@DataClassName('FamilyRow')
@TableIndex(name: 'families_module', columns: {#moduleId, #sortOrder})
class Families extends Table with AuditedTable {
  TextColumn get moduleId => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// Mirror of every item of every bank file (`<family>/items/*.json`).
@DataClassName('ItemRow')
@TableIndex(name: 'items_family_difficulty', columns: {#familyId, #difficulty})
class Items extends Table with AuditedTable {
  TextColumn get familyId => text()();
  IntColumn get difficulty => integer()();

  /// `mcq` | `numeric` | `sequence` | `generated` (the JSON `type` key).
  TextColumn get type => text()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// Mirror of `<module>/(<family>/)lessons/*.json`. Inline bodies are kept in
/// the blob; `file`-based bodies stay in the asset bundle (path in the blob).
@DataClassName('LessonRow')
@TableIndex(name: 'lessons_module_family', columns: {#moduleId, #familyId})
class Lessons extends Table with AuditedTable {
  TextColumn get moduleId => text()();
  TextColumn get familyId => text().nullable()();
  IntColumn get sortOrder => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// Mirror of `<family>/decks/*.json` without its cards (see [Flashcards]).
@DataClassName('DeckRow')
@TableIndex(name: 'decks_family', columns: {#familyId, #sortOrder})
class Decks extends Table with AuditedTable {
  TextColumn get familyId => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// One row per card of every deck; `sortOrder` is the card's index in the
/// deck file.
@DataClassName('FlashcardRow')
@TableIndex(name: 'flashcards_deck_difficulty', columns: {#deckId, #difficulty})
class Flashcards extends Table with AuditedTable {
  TextColumn get deckId => text()();
  IntColumn get sortOrder => integer()();
  IntColumn get difficulty => integer()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}

/// Mirror of `<module>/blueprints/*.json`.
@DataClassName('BlueprintRow')
@TableIndex(name: 'blueprints_module', columns: {#moduleId})
class Blueprints extends Table with AuditedTable {
  TextColumn get moduleId => text()();
  IntColumn get version => integer()();
  TextColumn get json => text().map(const JsonMapConverter())();
}
