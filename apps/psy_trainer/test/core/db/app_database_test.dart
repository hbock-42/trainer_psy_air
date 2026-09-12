import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/open_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(openInMemoryExecutor()));
  tearDown(() => db.close());

  test(
    'opens at schema version 1 with every table and index created',
    () async {
      final tables = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'table' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .map((row) => row.read<String>('name'))
          .get();
      expect(tables, [
        'attempts',
        'blueprints',
        'content_meta',
        'decks',
        'families',
        'flashcard_reviews',
        'flashcards',
        'item_stats',
        'items',
        'lesson_progress',
        'lessons',
        'modules',
        'sessions',
        'user_profile',
      ]);

      final indexes = await db
          .customSelect(
            "SELECT name FROM sqlite_master WHERE type = 'index' "
            "AND name NOT LIKE 'sqlite_%' ORDER BY name",
          )
          .map((row) => row.read<String>('name'))
          .get();
      expect(
        indexes,
        containsAll([
          'sessions_started_at',
          'attempts_session_position',
          'items_family_difficulty',
        ]),
      );

      final version = await db
          .customSelect('PRAGMA user_version')
          .map((row) => row.read<int>('user_version'))
          .getSingle();
      expect(version, db.schemaVersion);
      expect(db.schemaVersion, 1);
    },
  );

  test('enforces foreign keys (attempts need an existing session)', () async {
    final now = DateTime.utc(2026, 9, 11);
    await expectLater(
      db.attemptsDao.insertAttempt(
        AttemptsCompanion.insert(
          id: 'a1',
          sessionId: 'missing',
          familyId: 'f',
          isCorrect: true,
          responseMs: 1,
          position: 0,
          answeredAt: now,
          createdAt: now,
          updatedAt: now,
        ),
      ),
      throwsA(anything),
    );
  });

  test(
    'stores datetimes as UTC ISO-8601 text with millisecond precision',
    () async {
      final at = DateTime.utc(2026, 9, 11, 10, 30, 15, 123);
      await db.lessonProgressDao.markRead(
        LessonProgressCompanion.insert(
          id: 'lp1',
          lessonId: 'l1',
          readAt: at,
          createdAt: at,
          updatedAt: at,
        ),
      );
      final raw = await db
          .customSelect('SELECT read_at FROM lesson_progress')
          .map((row) => row.read<String>('read_at'))
          .getSingle();
      expect(raw, '2026-09-11T10:30:15.123Z');
      final row = await db.lessonProgressDao.byLesson('l1');
      expect(row!.readAt, at);
      expect(row.readAt.isUtc, isTrue);
    },
  );
}
