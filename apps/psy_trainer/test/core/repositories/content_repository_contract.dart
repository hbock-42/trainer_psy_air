import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../db/example_content.dart';

/// Behaviour every [ContentRepository] must have, checked against the
/// example bundle (`assets/content/examples/`). [create] receives the parsed
/// fixture and must return a repository containing exactly that content,
/// seeded at [seededAt].
void runContentRepositoryContract({
  required Future<ContentRepository> Function(ExampleContent content) create,
  required Future<void> Function() dispose,
}) {
  final content = ExampleContent.load();
  late ContentRepository repo;

  setUp(() async => repo = await create(content));
  tearDown(dispose);

  test('contentInfo reflects the seeded manifest', () async {
    final info = await repo.contentInfo();
    expect(
      info,
      ContentInfo(
        schemaVersion: content.manifest.schemaVersion,
        contentVersion: content.manifest.contentVersion,
        seededAt: seededAt,
      ),
    );
  });

  test('modules and families round-trip and are ordered', () async {
    expect(await repo.modules(), content.modules);
    expect(await repo.moduleById(ModuleId.psy0), content.modules.single);
    expect(await repo.moduleById(ModuleId.psy2), isNull);

    final families = await repo.families();
    expect(families, content.families);
    expect(families.map((f) => f.order), isSorted);
    expect(await repo.families(moduleId: ModuleId.psy0), content.families);
    expect(await repo.families(moduleId: ModuleId.psy1), isEmpty);
    expect(await repo.familyById('memory_nback'), content.families.single);
    expect(await repo.familyById('nope'), isNull);
  });

  test('items of every type round-trip through the store', () async {
    for (final family in {for (final i in content.items) i.familyId}) {
      final expected = content.items.where((i) => i.familyId == family).toList()
        ..sort((a, b) => a.id.compareTo(b.id));
      final actual = await repo.items(familyId: family, shuffle: false);
      expect(actual, expected, reason: family);
    }
    expect(
      (await repo.items(
        familyId: 'memory_nback',
      )).any((i) => i is GeneratedItem),
      isTrue,
    );
    expect(await repo.items(familyId: 'unknown'), isEmpty);
  });

  test('items are filtered by difficulty, count and exclusions', () async {
    final all = await repo.items(familyId: 'english', shuffle: false);
    final min = all.map((i) => i.difficulty).reduce((a, b) => a < b ? a : b);
    final max = all.map((i) => i.difficulty).reduce((a, b) => a > b ? a : b);
    expect(min, lessThan(max), reason: 'fixture must span difficulties');

    final hard = await repo.items(familyId: 'english', minDifficulty: max);
    expect(hard, isNotEmpty);
    expect(hard.every((i) => i.difficulty == max), isTrue);

    final easy = await repo.items(familyId: 'english', maxDifficulty: min);
    expect(easy, isNotEmpty);
    expect(easy.every((i) => i.difficulty == min), isTrue);

    final two = await repo.items(familyId: 'english', count: 2);
    expect(two, hasLength(2));
    expect(all, containsAll(two));

    final rest = await repo.items(
      familyId: 'english',
      excludeIds: [all.first.id],
      shuffle: false,
    );
    expect(rest, all.skip(1));

    expect(await repo.items(familyId: 'english', count: 1, shuffle: false), [
      all.first,
    ]);
  });

  test('items by id keep the requested order and skip unknown ids', () async {
    final a = content.items.first;
    final b = content.items.last;
    expect(await repo.itemById(a.id), a);
    expect(await repo.itemById('nope'), isNull);
    expect(await repo.itemsByIds([b.id, 'nope', a.id]), [b, a]);
    expect(await repo.itemsByIds([]), isEmpty);
  });

  test('passages round-trip and are found by id', () async {
    expect(content.passages, isNotEmpty, reason: 'fixture must carry one');
    final passage = content.passages.single;
    expect(await repo.passage(passage.id), passage);
    expect(await repo.passage('nope'), isNull);
    expect(await repo.passagesByIds([passage.id, 'nope']), [passage]);
    expect(await repo.passagesByIds([]), isEmpty);

    final reading = (await repo.items(
      familyId: 'english',
      shuffle: false,
    )).whereType<McqItem>().where((i) => i.passageId != null);
    expect(reading, isNotEmpty, reason: 'fixture must link an item to it');
    for (final item in reading) {
      expect(item.passageId, passage.id);
    }
  });

  test('lessons filter by module and family', () async {
    final lesson = content.lessons.single;
    expect(await repo.lessons(), [lesson]);
    expect(await repo.lessons(moduleId: ModuleId.psy0), [lesson]);
    expect(await repo.lessons(moduleId: ModuleId.psy1), isEmpty);
    expect(await repo.lessons(familyId: lesson.familyId), [lesson]);
    expect(await repo.lessons(familyId: 'english'), isEmpty);
    expect(await repo.lessonById(lesson.id), lesson);
    expect(await repo.lessonById('nope'), isNull);
  });

  test('decks come back with their cards in order', () async {
    final deck = content.decks.single;
    expect(await repo.decks(), [deck]);
    expect(await repo.decks(familyId: deck.familyId), [deck]);
    expect(await repo.decks(familyId: 'english'), isEmpty);
    expect(await repo.deckById(deck.id), deck);
    expect(await repo.deckById('nope'), isNull);
    expect(await repo.flashcards(deckId: deck.id), deck.cards);
    expect(await repo.flashcards(deckId: 'nope'), isEmpty);
    expect(
      await repo.flashcardsByIds([deck.cards.last.id, deck.cards.first.id]),
      [deck.cards.last, deck.cards.first],
    );
  });

  test('blueprints filter by module', () async {
    final blueprint = content.blueprints.single;
    expect(await repo.blueprints(), [blueprint]);
    expect(await repo.blueprints(moduleId: ModuleId.psy0), [blueprint]);
    expect(await repo.blueprints(moduleId: ModuleId.psy1), isEmpty);
    expect(await repo.blueprintById(blueprint.id), blueprint);
    expect(await repo.blueprintById('nope'), isNull);
  });
}

/// Seeding time used by the contract.
final DateTime seededAt = DateTime.utc(2026, 9);

/// Matches an iterable of comparable values in non-decreasing order.
final Matcher isSorted = predicate<Iterable<int>>((values) {
  final list = values.toList();
  for (var i = 1; i < list.length; i++) {
    if (list[i] < list[i - 1]) return false;
  }
  return true;
}, 'is sorted');
