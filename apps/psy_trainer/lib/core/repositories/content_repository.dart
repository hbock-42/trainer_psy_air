import 'package:psy_content/psy_content.dart';
import 'model/learning.dart';

/// Read access to the seeded training content (US-010 models).
///
/// Features depend on this interface only; the local implementation
/// (`core/db/repositories/local_content_repository.dart`) reads the Drift
/// mirrors, and a remote-backed one can be swapped in later (EPIC-13).
/// Drafts are never seeded, so everything returned here is published.
abstract interface class ContentRepository {
  /// Version of the bundle currently mirrored, or null before first seeding.
  Future<ContentInfo?> contentInfo();

  /// Modules ordered by `order`.
  Future<List<Module>> modules();

  Future<Module?> moduleById(ModuleId id);

  /// Families ordered by `order`, optionally restricted to one module.
  Future<List<TestFamily>> families({ModuleId? moduleId});

  Future<TestFamily?> familyById(String id);

  /// Bank items of [familyId] whose difficulty is within
  /// `[minDifficulty, maxDifficulty]` (inclusive, both optional).
  ///
  /// With [count], at most that many items are returned, sampled at random
  /// (in SQL) unless [shuffle] is false, in which case the first items by id
  /// are returned (deterministic, for tests and previews). [excludeIds]
  /// removes items already used (e.g. by recent sessions).
  Future<List<Item>> items({
    required String familyId,
    int? minDifficulty,
    int? maxDifficulty,
    int? count,
    Iterable<String> excludeIds = const [],
    bool shuffle = true,
  });

  Future<Item?> itemById(String id);

  /// Items for the given ids, in the order of [ids]; unknown ids are skipped.
  Future<List<Item>> itemsByIds(Iterable<String> ids);

  /// Lessons ordered by `order`, optionally filtered by module and/or family.
  /// Passing `familyId: ''` is not supported; use null for "any".
  Future<List<Lesson>> lessons({ModuleId? moduleId, String? familyId});

  Future<Lesson?> lessonById(String id);

  /// Decks (with their cards) ordered by `order`.
  Future<List<Deck>> decks({String? familyId});

  Future<Deck?> deckById(String id);

  /// Cards of one deck in bundle order.
  Future<List<Flashcard>> flashcards({required String deckId});

  /// Cards for the given ids, in the order of [ids]; unknown ids are skipped.
  Future<List<Flashcard>> flashcardsByIds(Iterable<String> ids);

  /// Blueprints, optionally restricted to one module.
  Future<List<ExamBlueprint>> blueprints({ModuleId? moduleId});

  Future<ExamBlueprint?> blueprintById(String id);
}
