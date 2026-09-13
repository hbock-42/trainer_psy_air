import 'package:psy_content/psy_content.dart';
import '../../repositories/content_repository.dart';
import '../../repositories/model/learning.dart';
import '../app_database.dart';
import '../daos/content_dao.dart';

/// [ContentRepository] backed by the Drift content mirrors (`ContentDao`).
///
/// Rows carry the entity as the JSON blob written by the seeder; this class
/// decodes them with the US-010 `fromJson` factories, so the repository never
/// depends on individual content fields beyond the indexed columns.
class LocalContentRepository implements ContentRepository {
  LocalContentRepository(AppDatabase db) : _dao = db.contentDao;

  final ContentDao _dao;

  @override
  Future<ContentInfo?> contentInfo() async {
    final row = await _dao.meta();
    if (row == null) return null;
    return ContentInfo(
      schemaVersion: row.schemaVersion,
      contentVersion: row.contentVersion,
      seededAt: row.seededAt,
    );
  }

  @override
  Future<List<Module>> modules() async => [
    for (final row in await _dao.allModules()) Module.fromJson(row.json),
  ];

  @override
  Future<Module?> moduleById(ModuleId id) async {
    final row = await _dao.moduleById(_moduleKey(id));
    return row == null ? null : Module.fromJson(row.json);
  }

  @override
  Future<List<TestFamily>> families({ModuleId? moduleId}) async => [
    for (final row in await _dao.familiesOf(
      moduleId: moduleId == null ? null : _moduleKey(moduleId),
    ))
      TestFamily.fromJson(row.json),
  ];

  @override
  Future<TestFamily?> familyById(String id) async {
    final row = await _dao.familyById(id);
    return row == null ? null : TestFamily.fromJson(row.json);
  }

  @override
  Future<List<Item>> items({
    required String familyId,
    int? minDifficulty,
    int? maxDifficulty,
    int? count,
    Iterable<String> excludeIds = const [],
    bool shuffle = true,
  }) async {
    final rows = await _dao.itemsOf(
      familyId: familyId,
      minDifficulty: minDifficulty,
      maxDifficulty: maxDifficulty,
      limit: count,
      excludeIds: excludeIds,
      shuffle: shuffle,
    );
    return [for (final row in rows) Item.fromJson(row.json)];
  }

  @override
  Future<Item?> itemById(String id) async {
    final row = await _dao.itemById(id);
    return row == null ? null : Item.fromJson(row.json);
  }

  @override
  Future<List<Item>> itemsByIds(Iterable<String> ids) async {
    final wanted = ids.toList();
    final rows = await _dao.itemsByIds(wanted);
    final byId = {for (final row in rows) row.id: Item.fromJson(row.json)};
    return [for (final id in wanted) ?byId[id]];
  }

  @override
  Future<Passage?> passage(String id) async {
    final row = await _dao.passageById(id);
    return row == null ? null : Passage.fromJson(row.json);
  }

  @override
  Future<List<Passage>> passagesByIds(Iterable<String> ids) async {
    final wanted = ids.toList();
    final rows = await _dao.passagesByIds(wanted);
    final byId = {for (final row in rows) row.id: Passage.fromJson(row.json)};
    return [for (final id in wanted) ?byId[id]];
  }

  @override
  Future<List<Lesson>> lessons({ModuleId? moduleId, String? familyId}) async =>
      [
        for (final row in await _dao.lessonsOf(
          moduleId: moduleId == null ? null : _moduleKey(moduleId),
          familyId: familyId,
        ))
          Lesson.fromJson(row.json),
      ];

  @override
  Future<Lesson?> lessonById(String id) async {
    final row = await _dao.lessonById(id);
    return row == null ? null : Lesson.fromJson(row.json);
  }

  @override
  Future<List<Deck>> decks({String? familyId}) async {
    final rows = await _dao.decksOf(familyId: familyId);
    final cards = await _dao.flashcardsOfDecks([for (final r in rows) r.id]);
    return [for (final row in rows) _deck(row, cards[row.id] ?? const [])];
  }

  @override
  Future<Deck?> deckById(String id) async {
    final row = await _dao.deckById(id);
    if (row == null) return null;
    return _deck(row, await _dao.flashcardsOf(id));
  }

  @override
  Future<List<Flashcard>> flashcards({required String deckId}) async => [
    for (final row in await _dao.flashcardsOf(deckId))
      Flashcard.fromJson(row.json),
  ];

  @override
  Future<List<Flashcard>> flashcardsByIds(Iterable<String> ids) async {
    final wanted = ids.toList();
    final rows = await _dao.flashcardsByIds(wanted);
    final byId = {for (final row in rows) row.id: Flashcard.fromJson(row.json)};
    return [for (final id in wanted) ?byId[id]];
  }

  @override
  Future<List<ExamBlueprint>> blueprints({ModuleId? moduleId}) async => [
    for (final row in await _dao.blueprintsOf(
      moduleId: moduleId == null ? null : _moduleKey(moduleId),
    ))
      ExamBlueprint.fromJson(row.json),
  ];

  @override
  Future<ExamBlueprint?> blueprintById(String id) async {
    final row = await _dao.blueprintById(id);
    return row == null ? null : ExamBlueprint.fromJson(row.json);
  }

  @override
  Future<List<LexicalField>> lexicalFields({String? familyId}) async => [
    for (final row in await _dao.lexicalFieldsOf(familyId: familyId))
      LexicalField.fromJson(row.json),
  ];

  @override
  Future<LexicalField?> lexicalField(String id) async {
    final row = await _dao.lexicalFieldById(id);
    return row == null ? null : LexicalField.fromJson(row.json);
  }

  /// Deck rows are stored without their cards; the cards come from the
  /// `flashcards` table.
  static Deck _deck(DeckRow row, List<FlashcardRow> cards) => Deck.fromJson({
    ...row.json,
    'cards': [for (final card in cards) card.json],
  });

  @override
  Future<List<InterviewQuestion>> interviewQuestions({
    String? familyId,
  }) async => [
    for (final row in await _dao.interviewQuestionsOf(familyId: familyId))
      InterviewQuestion.fromJson(row.json),
  ];

  @override
  Future<InterviewQuestion?> interviewQuestion(String id) async {
    final row = await _dao.interviewQuestionById(id);
    return row == null ? null : InterviewQuestion.fromJson(row.json);
  }

  /// The `modules.id` / `*.moduleId` column holds the JSON value of
  /// [ModuleId] (`psy0`...), i.e. its enum name.
  static String _moduleKey(ModuleId id) => id.name;
}
