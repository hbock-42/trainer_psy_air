import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/repositories/model/session.dart';

import '../example_content.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  Future<void> insert(
    String id,
    DateTime startedAt, {
    SessionMode mode = SessionMode.practice,
    String? familyId = 'english',
    SessionStatus status = SessionStatus.completed,
  }) {
    return db.sessionsDao.insertSession(
      SessionsCompanion.insert(
        id: id,
        mode: mode,
        familyId: Value(familyId),
        startedAt: startedAt,
        status: status,
        config: const {},
        createdAt: startedAt,
        updatedAt: startedAt,
      ),
    );
  }

  test('inRange returns sessions within the bounds, newest first', () async {
    await insert('s1', DateTime.utc(2026, 9, 1, 8));
    await insert('s2', DateTime.utc(2026, 9, 2, 8));
    await insert('s3', DateTime.utc(2026, 9, 3, 8));
    await insert('s4', DateTime.utc(2026, 9, 4, 8));

    final all = await db.sessionsDao.inRange();
    expect(all.map((s) => s.id), ['s4', 's3', 's2', 's1']);

    final middle = await db.sessionsDao.inRange(
      from: DateTime.utc(2026, 9, 2),
      to: DateTime.utc(2026, 9, 3, 23, 59),
    );
    expect(middle.map((s) => s.id), ['s3', 's2']);

    // Inclusive bounds.
    final exact = await db.sessionsDao.inRange(
      from: DateTime.utc(2026, 9, 2, 8),
      to: DateTime.utc(2026, 9, 2, 8),
    );
    expect(exact.map((s) => s.id), ['s2']);

    final limited = await db.sessionsDao.inRange(limit: 2);
    expect(limited.map((s) => s.id), ['s4', 's3']);
  });

  test('inRange filters by mode, family and status', () async {
    await insert('p1', DateTime.utc(2026, 9));
    await insert('p2', DateTime.utc(2026, 9, 2), familyId: 'memory');
    await insert(
      'e1',
      DateTime.utc(2026, 9, 3),
      mode: SessionMode.exam,
      familyId: null,
      status: SessionStatus.inProgress,
    );

    expect(
      (await db.sessionsDao.inRange(mode: SessionMode.exam)).map((s) => s.id),
      ['e1'],
    );
    expect(
      (await db.sessionsDao.inRange(familyId: 'memory')).map((s) => s.id),
      ['p2'],
    );
    expect(
      (await db.sessionsDao.inRange(
        status: SessionStatus.inProgress,
      )).map((s) => s.id),
      ['e1'],
    );
    expect(
      (await db.sessionsDao.inRange(
        mode: SessionMode.practice,
        status: SessionStatus.completed,
      )).map((s) => s.id),
      ['p2', 'p1'],
    );
  });

  test('finish sets status, score and endedAt', () async {
    await insert('s1', DateTime.utc(2026, 9), status: SessionStatus.inProgress);
    final changed = await db.sessionsDao.finish(
      's1',
      status: SessionStatus.completed,
      score: 0.75,
      endedAt: DateTime.utc(2026, 9, 1, 0, 10),
      updatedAt: DateTime.utc(2026, 9, 1, 0, 10),
    );
    expect(changed, 1);
    final row = await db.sessionsDao.byId('s1');
    expect(row!.status, SessionStatus.completed);
    expect(row.score, 0.75);
    expect(row.endedAt, DateTime.utc(2026, 9, 1, 0, 10));
    expect(row.updatedAt, DateTime.utc(2026, 9, 1, 0, 10));
    expect(row.createdAt, DateTime.utc(2026, 9));

    expect(
      await db.sessionsDao.finish(
        'missing',
        status: SessionStatus.abandoned,
        endedAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
      0,
    );
  });

  test('config round-trips as JSON', () async {
    await db.sessionsDao.insertSession(
      SessionsCompanion.insert(
        id: 's1',
        mode: SessionMode.exam,
        blueprintId: const Value('psy0.blueprint.short'),
        startedAt: DateTime.utc(2026),
        status: SessionStatus.inProgress,
        config: const {
          'realism': {'silent': true, 'noPause': true},
          'sections': [0, 1, 2],
        },
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );
    final row = await db.sessionsDao.byId('s1');
    expect(row!.config, {
      'realism': {'silent': true, 'noPause': true},
      'sections': [0, 1, 2],
    });
    expect(row.blueprintId, 'psy0.blueprint.short');
    expect(row.familyId, isNull);
  });
}
