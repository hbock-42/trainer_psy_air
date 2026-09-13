import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/open_database.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(openInMemoryExecutor()));
  tearDown(() => db.close());

  test(
    'opens at schema version 4 with every table and index created',
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
        'interview_questions',
        'item_stats',
        'items',
        'lesson_progress',
        'lessons',
        'lexical_fields',
        'modules',
        'passages',
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
      expect(db.schemaVersion, 4);
    },
  );

  test('v1 -> v4 upgrade creates `passages`, `lexical_fields` and '
      '`interview_questions` on a v1 file without losing content', () async {
    final path = Directory.systemTemp
        .createTempSync('app_database_migration_test')
        .path;
    final file = '$path/db.sqlite';
    addTearDown(() => Directory(path).delete(recursive: true));

    // Simulate a v1 file: create the current schema, then drop the tables
    // v1 lacked (`passages`, `lexical_fields`, `interview_questions`) and
    // roll `user_version` back to 1.
    final v1 = AppDatabase(NativeDatabase(File(file)));
    await v1.customStatement('DROP TABLE passages');
    await v1.customStatement('DROP TABLE lexical_fields');
    await v1.customStatement('DROP TABLE interview_questions');
    await v1.customStatement('PRAGMA user_version = 1');
    await v1
        .into(v1.families)
        .insert(
          FamiliesCompanion.insert(
            id: 'f1',
            moduleId: 'psy0',
            sortOrder: 0,
            version: 1,
            json: const {'kept': true},
            createdAt: DateTime.utc(2026),
            updatedAt: DateTime.utc(2026),
          ),
        );
    await v1.close();

    final upgraded = AppDatabase(NativeDatabase(File(file)));
    addTearDown(upgraded.close);
    final families = await upgraded.contentDao.familiesOf();
    expect(families, hasLength(1), reason: 'user data must survive');
    expect(families.single.json, {'kept': true});

    final tables = await upgraded
        .customSelect(
          "SELECT name FROM sqlite_master WHERE type = 'table' "
          "AND name IN ('passages', 'lexical_fields', 'interview_questions')",
        )
        .get();
    expect(tables, hasLength(3));

    final version = await upgraded
        .customSelect('PRAGMA user_version')
        .map((row) => row.read<int>('user_version'))
        .getSingle();
    expect(version, 4);
  });

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
