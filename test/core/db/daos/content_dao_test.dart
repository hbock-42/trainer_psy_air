import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/content_rows.dart';

import '../example_content.dart';

void main() {
  final content = ExampleContent.load();
  late AppDatabase db;

  setUp(() async {
    db = openTestDatabase();
    await content.seed(db);
  });
  tearDown(() => db.close());

  test('replaceAll mirrors every entity and records the manifest', () async {
    final meta = await db.contentDao.meta();
    expect(meta!.contentVersion, content.manifest.contentVersion);
    expect(meta.schemaVersion, content.manifest.schemaVersion);
    expect(meta.seededAt, DateTime.utc(2026, 9));

    expect(await db.contentDao.allModules(), hasLength(content.modules.length));
    expect(
      await db.contentDao.familiesOf(),
      hasLength(content.families.length),
    );
    expect(
      await db.contentDao.itemsOf(familyId: 'arithmetic_grid'),
      hasLength(
        content.items.where((i) => i.familyId == 'arithmetic_grid').length,
      ),
    );
    expect(await db.contentDao.lessonsOf(), hasLength(content.lessons.length));
    expect(await db.contentDao.decksOf(), hasLength(content.decks.length));
    expect(
      await db.contentDao.flashcardsOf(content.decks.single.id),
      hasLength(content.decks.single.cards.length),
    );
    expect(
      await db.contentDao.blueprintsOf(),
      hasLength(content.blueprints.length),
    );
  });

  test('replaceAll is a full replacement (old rows disappear)', () async {
    await content.seed(db, seededAt: DateTime.utc(2026, 10));
    final meta = await db.contentDao.meta();
    expect(meta!.seededAt, DateTime.utc(2026, 10));
    // Same counts: nothing was duplicated by the second seeding.
    expect(
      await db.contentDao.itemsOf(familyId: 'english'),
      hasLength(content.items.where((i) => i.familyId == 'english').length),
    );

    await db.contentDao.replaceAll(
      meta: ContentRows.meta(content.manifest, seededAt: DateTime.utc(2026)),
    );
    expect(await db.contentDao.itemsOf(familyId: 'english'), isEmpty);
    expect(await db.contentDao.allModules(), isEmpty);
  });

  test('items are filtered by family and difficulty range', () async {
    final all = await db.contentDao.itemsOf(familyId: 'english');
    final difficulties = all.map((r) => r.difficulty).toSet();
    expect(difficulties.length, greaterThan(1), reason: 'fixture too flat');

    final min = difficulties.reduce((a, b) => a < b ? a : b);
    final atLeastMinPlusOne = await db.contentDao.itemsOf(
      familyId: 'english',
      minDifficulty: min + 1,
    );
    expect(atLeastMinPlusOne, everyElement(_difficultyAtLeast(min + 1)));
    expect(atLeastMinPlusOne.length, lessThan(all.length));

    final exactlyMin = await db.contentDao.itemsOf(
      familyId: 'english',
      minDifficulty: min,
      maxDifficulty: min,
    );
    expect(exactlyMin, isNotEmpty);
    expect(exactlyMin.every((r) => r.difficulty == min), isTrue);

    for (final row in all) {
      expect(row.familyId, 'english');
      expect(row.type, 'mcq');
      expect(row.json['id'], row.id);
    }
  });

  test('items honour limit, exclusions and deterministic order', () async {
    final ordered = await db.contentDao.itemsOf(
      familyId: 'arithmetic_grid',
      shuffle: false,
    );
    final ids = ordered.map((r) => r.id).toList();
    expect(ids, ids.toList()..sort());

    final limited = await db.contentDao.itemsOf(
      familyId: 'arithmetic_grid',
      limit: 2,
      shuffle: false,
    );
    expect(limited.map((r) => r.id), ids.take(2));

    final without = await db.contentDao.itemsOf(
      familyId: 'arithmetic_grid',
      excludeIds: [ids.first],
      shuffle: false,
    );
    expect(without.map((r) => r.id), ids.skip(1));

    final sampled = await db.contentDao.itemsOf(
      familyId: 'arithmetic_grid',
      limit: 2,
    );
    expect(sampled, hasLength(2));
    expect(ids, containsAll(sampled.map((r) => r.id)));
  });

  test('lookups by id and by ids', () async {
    final item = content.items.first;
    expect((await db.contentDao.itemById(item.id))!.json['id'], item.id);
    expect(await db.contentDao.itemById('nope'), isNull);
    expect(await db.contentDao.itemsByIds([]), isEmpty);
    expect(await db.contentDao.itemsByIds([item.id, 'nope']), hasLength(1));
    expect((await db.contentDao.familyById('memory_nback'))!.moduleId, 'psy0');
    expect((await db.contentDao.moduleById('psy0'))!.sortOrder, isNotNull);
    expect(
      (await db.contentDao.blueprintById(
        'psy0.blueprint.example-custom',
      ))!.moduleId,
      'psy0',
    );
    expect(await db.contentDao.lessonById(content.lessons.first.id), isNotNull);
  });

  test('lessons filter by module and family', () async {
    expect(await db.contentDao.lessonsOf(moduleId: 'psy1'), isEmpty);
    expect(
      await db.contentDao.lessonsOf(familyId: 'arithmetic_grid'),
      hasLength(1),
    );
    expect(await db.contentDao.lessonsOf(familyId: 'english'), isEmpty);
  });

  test(
    'flashcards keep deck order and can be fetched for many decks',
    () async {
      final deck = content.decks.single;
      final rows = await db.contentDao.flashcardsOf(deck.id);
      expect(rows.map((r) => r.id), deck.cards.map((c) => c.id));

      final grouped = await db.contentDao.flashcardsOfDecks([deck.id, 'other']);
      expect(grouped.keys, [deck.id]);
      expect(grouped[deck.id], hasLength(deck.cards.length));

      final byIds = await db.contentDao.flashcardsByIds([deck.cards.last.id]);
      expect(byIds.single.sortOrder, deck.cards.length - 1);
    },
  );

  test('a seeded row has audit columns', () async {
    final row = (await db.contentDao.allModules()).single;
    expect(row.createdAt, DateTime.utc(2026, 9));
    expect(row.updatedAt, DateTime.utc(2026, 9));
    // Companions are plain drift values, usable by the seeder as-is.
    expect(
      ContentRows.module(
        content.modules.single,
        seededAt: DateTime.utc(2026),
      ).sortOrder,
      const Value(0),
    );
  });
}

Matcher _difficultyAtLeast(int min) =>
    predicate<ItemRow>((r) => r.difficulty >= min, 'difficulty >= $min');
