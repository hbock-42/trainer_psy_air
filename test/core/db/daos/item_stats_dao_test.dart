import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';

import '../example_content.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  test(
    'recordOutcome inserts the first time, then increments in SQL',
    () async {
      final t1 = DateTime.utc(2026, 9, 1, 10);
      final t2 = DateTime.utc(2026, 9, 1, 11);
      final t3 = DateTime.utc(2026, 9, 1, 12);

      await db.itemStatsDao.recordOutcome(
        newId: 'st1',
        itemId: 'english.item.1',
        familyId: 'english',
        isCorrect: true,
        responseMs: 1000,
        at: t1,
      );
      var row = await db.itemStatsDao.byItem('english.item.1');
      expect(row!.id, 'st1');
      expect(row.seen, 1);
      expect(row.correct, 1);
      expect(row.totalResponseMs, 1000);
      expect(row.lastCorrect, isTrue);
      expect(row.lastSeenAt, t1);
      expect(row.createdAt, t1);

      await db.itemStatsDao.recordOutcome(
        newId: 'st2', // ignored: the row already exists
        itemId: 'english.item.1',
        familyId: 'english',
        isCorrect: false,
        responseMs: 3000,
        at: t2,
      );
      await db.itemStatsDao.recordOutcome(
        newId: 'st3',
        itemId: 'english.item.1',
        familyId: 'english',
        isCorrect: true,
        responseMs: 500,
        at: t3,
      );
      row = await db.itemStatsDao.byItem('english.item.1');
      expect(row!.id, 'st1');
      expect(row.seen, 3);
      expect(row.correct, 2);
      expect(row.totalResponseMs, 4500);
      expect(row.lastCorrect, isTrue);
      expect(row.lastSeenAt, t3);
      expect(row.createdAt, t1);
      expect(row.updatedAt, t3);

      expect(await db.itemStatsDao.byItem('other'), isNull);
    },
  );

  test('list filters by family and last outcome, most recent first', () async {
    Future<void> outcome(
      String item,
      String family,
      DateTime at, {
      required bool ok,
    }) => db.itemStatsDao.recordOutcome(
      newId: 'id-$item-${at.millisecondsSinceEpoch}',
      itemId: item,
      familyId: family,
      isCorrect: ok,
      responseMs: 100,
      at: at,
    );

    await outcome('e1', 'english', DateTime.utc(2026, 9), ok: false);
    await outcome('e2', 'english', DateTime.utc(2026, 9, 2), ok: true);
    await outcome('e3', 'english', DateTime.utc(2026, 9, 3), ok: false);
    await outcome('m1', 'memory', DateTime.utc(2026, 9, 4), ok: false);
    // e1 was later answered correctly: no longer a "mistake".
    await outcome('e1', 'english', DateTime.utc(2026, 9, 5), ok: true);

    expect((await db.itemStatsDao.list()).map((r) => r.itemId), [
      'e1',
      'm1',
      'e3',
      'e2',
    ]);
    expect(
      (await db.itemStatsDao.list(familyId: 'english')).map((r) => r.itemId),
      ['e1', 'e3', 'e2'],
    );
    expect(
      (await db.itemStatsDao.list(failedOnly: true)).map((r) => r.itemId),
      ['m1', 'e3'],
    );
    expect(
      (await db.itemStatsDao.list(
        familyId: 'english',
        failedOnly: true,
      )).map((r) => r.itemId),
      ['e3'],
    );
  });

  test('the upsert is atomic under concurrent writers', () async {
    await Future.wait([
      for (var i = 0; i < 50; i++)
        db.itemStatsDao.recordOutcome(
          newId: 'id$i',
          itemId: 'item',
          familyId: 'english',
          isCorrect: i.isEven,
          responseMs: 10,
          at: DateTime.utc(2026, 9, 1, 0, 0, i),
        ),
    ]);
    final row = await db.itemStatsDao.byItem('item');
    expect(row!.seen, 50);
    expect(row.correct, 25);
    expect(row.totalResponseMs, 500);
  });
}
