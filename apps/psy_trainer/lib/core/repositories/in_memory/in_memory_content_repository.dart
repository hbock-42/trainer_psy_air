import 'dart:math';

import 'package:psy_content/psy_content.dart';
import '../content_repository.dart';
import '../model/learning.dart';

/// [ContentRepository] over plain Dart lists, for widget tests and previews.
/// Override `contentRepositoryProvider` with an instance seeded through the
/// constructor or the `add*` methods.
class InMemoryContentRepository implements ContentRepository {
  InMemoryContentRepository({
    this.info,
    Iterable<Module> modules = const [],
    Iterable<TestFamily> families = const [],
    Iterable<Item> items = const [],
    Iterable<Passage> passages = const [],
    Iterable<Lesson> lessons = const [],
    Iterable<Deck> decks = const [],
    Iterable<ExamBlueprint> blueprints = const [],
    Random? random,
  }) : _random = random ?? Random() {
    _modules.addAll(modules);
    _families.addAll(families);
    _items.addAll(items);
    _passages.addAll(passages);
    _lessons.addAll(lessons);
    _decks.addAll(decks);
    _blueprints.addAll(blueprints);
  }

  ContentInfo? info;
  final List<Module> _modules = [];
  final List<TestFamily> _families = [];
  final List<Item> _items = [];
  final List<Passage> _passages = [];
  final List<Lesson> _lessons = [];
  final List<Deck> _decks = [];
  final List<ExamBlueprint> _blueprints = [];
  final Random _random;

  void addModule(Module module) => _modules.add(module);
  void addFamily(TestFamily family) => _families.add(family);
  void addItems(Iterable<Item> items) => _items.addAll(items);
  void addPassage(Passage passage) => _passages.add(passage);
  void addLesson(Lesson lesson) => _lessons.add(lesson);
  void addDeck(Deck deck) => _decks.add(deck);
  void addBlueprint(ExamBlueprint blueprint) => _blueprints.add(blueprint);

  @override
  Future<ContentInfo?> contentInfo() async => info;

  @override
  Future<List<Module>> modules() async => _sorted(_modules, (m) => m.order);

  @override
  Future<Module?> moduleById(ModuleId id) async =>
      _modules.where((m) => m.id == id).firstOrNull;

  @override
  Future<List<TestFamily>> families({ModuleId? moduleId}) async => _sorted(
    _families.where((f) => moduleId == null || f.moduleId == moduleId),
    (f) => f.order,
  );

  @override
  Future<TestFamily?> familyById(String id) async =>
      _families.where((f) => f.id == id).firstOrNull;

  @override
  Future<List<Item>> items({
    required String familyId,
    int? minDifficulty,
    int? maxDifficulty,
    int? count,
    Iterable<String> excludeIds = const [],
    bool shuffle = true,
  }) async {
    final excluded = excludeIds.toSet();
    final matching = _items
        .where(
          (i) =>
              i.familyId == familyId &&
              (minDifficulty == null || i.difficulty >= minDifficulty) &&
              (maxDifficulty == null || i.difficulty <= maxDifficulty) &&
              !excluded.contains(i.id),
        )
        .toList();
    if (shuffle) {
      matching.shuffle(_random);
    } else {
      matching.sort((a, b) => a.id.compareTo(b.id));
    }
    return count == null ? matching : matching.take(count).toList();
  }

  @override
  Future<Item?> itemById(String id) async =>
      _items.where((i) => i.id == id).firstOrNull;

  @override
  Future<List<Item>> itemsByIds(Iterable<String> ids) async {
    final byId = {for (final i in _items) i.id: i};
    return [for (final id in ids) ?byId[id]];
  }

  @override
  Future<Passage?> passage(String id) async =>
      _passages.where((p) => p.id == id).firstOrNull;

  @override
  Future<List<Passage>> passagesByIds(Iterable<String> ids) async {
    final byId = {for (final p in _passages) p.id: p};
    return [for (final id in ids) ?byId[id]];
  }

  @override
  Future<List<Lesson>> lessons({ModuleId? moduleId, String? familyId}) async =>
      _sorted(
        _lessons.where(
          (l) =>
              (moduleId == null || l.moduleId == moduleId) &&
              (familyId == null || l.familyId == familyId),
        ),
        (l) => l.order,
      );

  @override
  Future<Lesson?> lessonById(String id) async =>
      _lessons.where((l) => l.id == id).firstOrNull;

  @override
  Future<List<Deck>> decks({String? familyId}) async => _sorted(
    _decks.where((d) => familyId == null || d.familyId == familyId),
    (d) => d.order,
  );

  @override
  Future<Deck?> deckById(String id) async =>
      _decks.where((d) => d.id == id).firstOrNull;

  @override
  Future<List<Flashcard>> flashcards({required String deckId}) async =>
      (await deckById(deckId))?.cards ?? const [];

  @override
  Future<List<Flashcard>> flashcardsByIds(Iterable<String> ids) async {
    final byId = {
      for (final deck in _decks)
        for (final card in deck.cards) card.id: card,
    };
    return [for (final id in ids) ?byId[id]];
  }

  @override
  Future<List<ExamBlueprint>> blueprints({ModuleId? moduleId}) async =>
      _blueprints
          .where((b) => moduleId == null || b.moduleId == moduleId)
          .toList()
        ..sort((a, b) => a.id.compareTo(b.id));

  @override
  Future<ExamBlueprint?> blueprintById(String id) async =>
      _blueprints.where((b) => b.id == id).firstOrNull;

  static List<T> _sorted<T>(Iterable<T> source, int Function(T) key) =>
      source.toList()..sort((a, b) => key(a).compareTo(key(b)));
}
