import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/content_tables.dart';

part 'content_dao.g.dart';

/// Everything seeded from the content bundle. Pure SQL access; the mapping to
/// the US-010 models lives in `LocalContentRepository`, the mapping from
/// bundle files to rows in the seeder (US-013), which calls [replaceAll].
@DriftAccessor(
  tables: [
    ContentMetaTable,
    Modules,
    Families,
    Items,
    Passages,
    Lessons,
    Decks,
    Flashcards,
    Blueprints,
    LexicalFields,
  ],
)
class ContentDao extends DatabaseAccessor<AppDatabase> with _$ContentDaoMixin {
  ContentDao(super.db);

  Future<ContentMetaRow?> meta() => (select(
    contentMetaTable,
  )..where((t) => t.id.equals(ContentMetaTable.singletonId))).getSingleOrNull();

  /// Replaces the whole mirror atomically: deletes every content row, then
  /// inserts the given ones and the new [meta]. Never touches user tables.
  Future<void> replaceAll({
    required ContentMetaTableCompanion meta,
    List<ModulesCompanion> modules = const [],
    List<FamiliesCompanion> families = const [],
    List<ItemsCompanion> items = const [],
    List<PassagesCompanion> passages = const [],
    List<LessonsCompanion> lessons = const [],
    List<DecksCompanion> decks = const [],
    List<FlashcardsCompanion> flashcards = const [],
    List<BlueprintsCompanion> blueprints = const [],
    List<LexicalFieldsCompanion> lexicalFields = const [],
  }) {
    return transaction(() async {
      await clearContent();
      await batch((b) {
        b.insertAll(this.modules, modules);
        b.insertAll(this.families, families);
        b.insertAll(this.items, items);
        b.insertAll(this.passages, passages);
        b.insertAll(this.lessons, lessons);
        b.insertAll(this.decks, decks);
        b.insertAll(this.flashcards, flashcards);
        b.insertAll(this.blueprints, blueprints);
        b.insertAll(this.lexicalFields, lexicalFields);
        b.insert(
          contentMetaTable,
          meta.copyWith(id: const Value(ContentMetaTable.singletonId)),
        );
      });
    });
  }

  /// Deletes every content row (including `content_meta`).
  Future<void> clearContent() async {
    final tables = <TableInfo<Table, Object?>>[
      contentMetaTable,
      modules,
      families,
      items,
      passages,
      lessons,
      decks,
      flashcards,
      blueprints,
      lexicalFields,
    ];
    for (final table in tables) {
      await delete(table).go();
    }
  }

  // --- Modules / families --------------------------------------------------

  Future<List<ModuleRow>> allModules() =>
      (select(modules)..orderBy([(t) => OrderingTerm.asc(t.sortOrder)])).get();

  Future<ModuleRow?> moduleById(String id) =>
      (select(modules)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<FamilyRow>> familiesOf({String? moduleId}) {
    final query = select(families)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    if (moduleId != null) query.where((t) => t.moduleId.equals(moduleId));
    return query.get();
  }

  Future<FamilyRow?> familyById(String id) =>
      (select(families)..where((t) => t.id.equals(id))).getSingleOrNull();

  // --- Items ---------------------------------------------------------------

  /// Items of one family within an inclusive difficulty range. With [limit]
  /// the rows are sampled with `ORDER BY RANDOM()` unless [shuffle] is false
  /// (then ordered by id). Uses the `(family_id, difficulty)` index.
  Future<List<ItemRow>> itemsOf({
    required String familyId,
    int? minDifficulty,
    int? maxDifficulty,
    int? limit,
    Iterable<String> excludeIds = const [],
    bool shuffle = true,
  }) {
    final query = select(items)..where((t) => t.familyId.equals(familyId));
    if (minDifficulty != null) {
      query.where((t) => t.difficulty.isBiggerOrEqualValue(minDifficulty));
    }
    if (maxDifficulty != null) {
      query.where((t) => t.difficulty.isSmallerOrEqualValue(maxDifficulty));
    }
    final excluded = excludeIds.toList();
    if (excluded.isNotEmpty) query.where((t) => t.id.isNotIn(excluded));
    query.orderBy([
      if (shuffle)
        (t) => OrderingTerm(expression: const CustomExpression<int>('RANDOM()'))
      else
        (t) => OrderingTerm.asc(t.id),
    ]);
    if (limit != null) query.limit(limit);
    return query.get();
  }

  Future<ItemRow?> itemById(String id) =>
      (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<ItemRow>> itemsByIds(List<String> ids) => ids.isEmpty
      ? Future.value(const [])
      : (select(items)..where((t) => t.id.isIn(ids))).get();

  // --- Passages --------------------------------------------------------

  Future<PassageRow?> passageById(String id) =>
      (select(passages)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<PassageRow>> passagesByIds(List<String> ids) => ids.isEmpty
      ? Future.value(const [])
      : (select(passages)..where((t) => t.id.isIn(ids))).get();

  // --- Lessons -------------------------------------------------------------

  Future<List<LessonRow>> lessonsOf({String? moduleId, String? familyId}) {
    final query = select(lessons)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    if (moduleId != null) query.where((t) => t.moduleId.equals(moduleId));
    if (familyId != null) query.where((t) => t.familyId.equals(familyId));
    return query.get();
  }

  Future<LessonRow?> lessonById(String id) =>
      (select(lessons)..where((t) => t.id.equals(id))).getSingleOrNull();

  // --- Decks / flashcards ---------------------------------------------------

  Future<List<DeckRow>> decksOf({String? familyId}) {
    final query = select(decks)
      ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]);
    if (familyId != null) query.where((t) => t.familyId.equals(familyId));
    return query.get();
  }

  Future<DeckRow?> deckById(String id) =>
      (select(decks)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<FlashcardRow>> flashcardsOf(String deckId) =>
      (select(flashcards)
            ..where((t) => t.deckId.equals(deckId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  /// Cards of several decks in one query, grouped by deck, in deck order.
  Future<Map<String, List<FlashcardRow>>> flashcardsOfDecks(
    List<String> deckIds,
  ) async {
    if (deckIds.isEmpty) return const {};
    final rows =
        await (select(flashcards)
              ..where((t) => t.deckId.isIn(deckIds))
              ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
            .get();
    final byDeck = <String, List<FlashcardRow>>{};
    for (final row in rows) {
      byDeck.putIfAbsent(row.deckId, () => []).add(row);
    }
    return byDeck;
  }

  Future<List<FlashcardRow>> flashcardsByIds(List<String> ids) => ids.isEmpty
      ? Future.value(const [])
      : (select(flashcards)..where((t) => t.id.isIn(ids))).get();

  // --- Blueprints ----------------------------------------------------------

  Future<List<BlueprintRow>> blueprintsOf({String? moduleId}) {
    final query = select(blueprints)..orderBy([(t) => OrderingTerm.asc(t.id)]);
    if (moduleId != null) query.where((t) => t.moduleId.equals(moduleId));
    return query.get();
  }

  Future<BlueprintRow?> blueprintById(String id) =>
      (select(blueprints)..where((t) => t.id.equals(id))).getSingleOrNull();

  // --- Lexical fields --------------------------------------------------

  Future<List<LexicalFieldRow>> lexicalFieldsOf({String? familyId}) {
    final query = select(lexicalFields)
      ..orderBy([(t) => OrderingTerm.asc(t.id)]);
    if (familyId != null) query.where((t) => t.familyId.equals(familyId));
    return query.get();
  }

  Future<LexicalFieldRow?> lexicalFieldById(String id) =>
      (select(lexicalFields)..where((t) => t.id.equals(id))).getSingleOrNull();
}
