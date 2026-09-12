import 'package:drift/drift.dart';

import 'package:psy_content/psy_content.dart';
import 'app_database.dart';

/// Builds content-mirror rows from the US-010 models. Used by the seeder
/// (US-013) and by tests; the inverse mapping lives in
/// `LocalContentRepository`.
///
/// Every row stores the entity's own JSON (`toJson()`), so anything the
/// contract adds later is carried along without a schema change.
abstract final class ContentRows {
  static ContentMetaTableCompanion meta(
    ContentManifest manifest, {
    required DateTime seededAt,
  }) => ContentMetaTableCompanion.insert(
    id: 'content',
    schemaVersion: manifest.schemaVersion,
    contentVersion: manifest.contentVersion,
    seededAt: seededAt,
    createdAt: seededAt,
    updatedAt: seededAt,
  );

  static ModulesCompanion module(Module module, {required DateTime seededAt}) =>
      ModulesCompanion.insert(
        id: module.id.name,
        sortOrder: module.order,
        version: module.version,
        json: module.toJson(),
        createdAt: seededAt,
        updatedAt: seededAt,
      );

  static FamiliesCompanion family(
    TestFamily family, {
    required DateTime seededAt,
  }) => FamiliesCompanion.insert(
    id: family.id,
    moduleId: family.moduleId.name,
    sortOrder: family.order,
    version: family.version,
    json: family.toJson(),
    createdAt: seededAt,
    updatedAt: seededAt,
  );

  static ItemsCompanion item(Item item, {required DateTime seededAt}) {
    final json = item.toJson();
    return ItemsCompanion.insert(
      id: item.id,
      familyId: item.familyId,
      difficulty: item.difficulty,
      type: json['type']! as String,
      version: item.version,
      json: json,
      createdAt: seededAt,
      updatedAt: seededAt,
    );
  }

  static PassagesCompanion passage(
    Passage passage, {
    required DateTime seededAt,
  }) => PassagesCompanion.insert(
    id: passage.id,
    json: passage.toJson(),
    createdAt: seededAt,
    updatedAt: seededAt,
  );

  static LessonsCompanion lesson(Lesson lesson, {required DateTime seededAt}) =>
      LessonsCompanion.insert(
        id: lesson.id,
        moduleId: lesson.moduleId.name,
        familyId: Value(lesson.familyId),
        sortOrder: lesson.order,
        version: lesson.version,
        json: lesson.toJson(),
        createdAt: seededAt,
        updatedAt: seededAt,
      );

  /// The deck row without its cards; pair it with [flashcards].
  static DecksCompanion deck(Deck deck, {required DateTime seededAt}) =>
      DecksCompanion.insert(
        id: deck.id,
        familyId: deck.familyId,
        sortOrder: deck.order,
        version: deck.version,
        json: deck.copyWith(cards: const []).toJson(),
        createdAt: seededAt,
        updatedAt: seededAt,
      );

  /// One row per card, `sortOrder` being the card's index in the deck.
  static List<FlashcardsCompanion> flashcards(
    Deck deck, {
    required DateTime seededAt,
  }) => [
    for (final (index, card) in deck.cards.indexed)
      FlashcardsCompanion.insert(
        id: card.id,
        deckId: deck.id,
        sortOrder: index,
        difficulty: card.difficulty,
        version: card.version,
        json: card.toJson(),
        createdAt: seededAt,
        updatedAt: seededAt,
      ),
  ];

  static LexicalFieldsCompanion lexicalField(
    LexicalField field, {
    required DateTime seededAt,
  }) => LexicalFieldsCompanion.insert(
    id: field.id,
    familyId: field.familyId,
    difficulty: field.difficulty,
    version: field.version,
    json: field.toJson(),
    createdAt: seededAt,
    updatedAt: seededAt,
  );

  static BlueprintsCompanion blueprint(
    ExamBlueprint blueprint, {
    required DateTime seededAt,
  }) => BlueprintsCompanion.insert(
    id: blueprint.id,
    moduleId: blueprint.moduleId.name,
    version: blueprint.version,
    json: blueprint.toJson(),
    createdAt: seededAt,
    updatedAt: seededAt,
  );
}
