import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/db/tables/progress_tables.dart';

import '../example_content.dart';

void main() {
  late AppDatabase db;

  setUp(() => db = openTestDatabase());
  tearDown(() => db.close());

  group('FlashcardReviewsDao', () {
    FlashcardReviewsCompanion review(
      String card, {
      required DateTime next,
      String deck = 'deck-a',
      int box = 1,
      DateTime? at,
      String id = 'r',
    }) {
      final now = at ?? DateTime.utc(2026, 9);
      return FlashcardReviewsCompanion.insert(
        id: '$id-$card',
        flashcardId: card,
        deckId: deck,
        box: box,
        reviews: 1,
        lapses: 0,
        nextReviewAt: next,
        createdAt: now,
        updatedAt: now,
      );
    }

    test(
      'due returns cards whose nextReviewAt <= now, soonest first',
      () async {
        await db.flashcardReviewsDao.upsert(
          review('c1', next: DateTime.utc(2026, 9, 3)),
        );
        await db.flashcardReviewsDao.upsert(
          review('c2', next: DateTime.utc(2026, 9)),
        );
        await db.flashcardReviewsDao.upsert(
          review('c3', next: DateTime.utc(2026, 9, 2), deck: 'deck-b'),
        );
        await db.flashcardReviewsDao.upsert(
          review('c4', next: DateTime.utc(2026, 9, 10)),
        );

        final now = DateTime.utc(2026, 9, 3);
        expect(
          (await db.flashcardReviewsDao.due(
            now: now,
          )).map((r) => r.flashcardId),
          ['c2', 'c3', 'c1'],
        );
        expect(
          (await db.flashcardReviewsDao.due(
            now: now,
            deckId: 'deck-a',
          )).map((r) => r.flashcardId),
          ['c2', 'c1'],
        );
        expect(
          (await db.flashcardReviewsDao.due(
            now: now,
            limit: 1,
          )).map((r) => r.flashcardId),
          ['c2'],
        );
        expect(
          await db.flashcardReviewsDao.due(now: DateTime.utc(2026, 8, 31)),
          isEmpty,
        );
      },
    );

    test(
      'upsert updates an existing card in place, keeping id/createdAt',
      () async {
        await db.flashcardReviewsDao.upsert(
          review('c1', next: DateTime.utc(2026, 9), id: 'first'),
        );
        await db.flashcardReviewsDao.upsert(
          review(
            'c1',
            next: DateTime.utc(2026, 9, 8),
            box: 2,
            at: DateTime.utc(2026, 9, 2),
            id: 'second',
          ),
        );
        final row = await db.flashcardReviewsDao.byCard('c1');
        expect(row!.id, 'first-c1');
        expect(row.createdAt, DateTime.utc(2026, 9));
        expect(row.updatedAt, DateTime.utc(2026, 9, 2));
        expect(row.box, 2);
        expect(row.nextReviewAt, DateTime.utc(2026, 9, 8));
        expect(
          await db.flashcardReviewsDao.due(now: DateTime.utc(2026, 9, 3)),
          isEmpty,
        );
      },
    );
  });

  group('LessonProgressDao', () {
    test('markRead is idempotent and keeps the first readAt', () async {
      final first = DateTime.utc(2026, 9);
      final later = DateTime.utc(2026, 9, 5);
      await db.lessonProgressDao.markRead(
        LessonProgressCompanion.insert(
          id: 'p1',
          lessonId: 'l1',
          readAt: first,
          createdAt: first,
          updatedAt: first,
        ),
      );
      await db.lessonProgressDao.markRead(
        LessonProgressCompanion.insert(
          id: 'p2',
          lessonId: 'l1',
          readAt: later,
          createdAt: later,
          updatedAt: later,
        ),
      );
      await db.lessonProgressDao.markRead(
        LessonProgressCompanion.insert(
          id: 'p3',
          lessonId: 'l2',
          readAt: later,
          createdAt: later,
          updatedAt: later,
        ),
      );
      final all = await db.lessonProgressDao.all();
      expect(all.map((r) => r.lessonId), ['l1', 'l2']);
      expect(all.first.id, 'p1');
      expect(all.first.readAt, first);
      expect(await db.lessonProgressDao.byLesson('l3'), isNull);
    });
  });

  group('UserProfileDao', () {
    test('save creates then updates the single row', () async {
      expect(await db.userProfileDao.get(), isNull);
      final t1 = DateTime.utc(2026, 9);
      await db.userProfileDao.save(
        UserProfilesCompanion.insert(
          id: 'whatever',
          locale: 'fr',
          settings: const {'sound': true},
          createdAt: t1,
          updatedAt: t1,
        ),
      );
      var row = await db.userProfileDao.get();
      expect(row!.id, UserProfiles.singletonId);
      expect(row.locale, 'fr');
      expect(row.examDate, isNull);
      expect(row.settings, {'sound': true});

      final t2 = DateTime.utc(2026, 9, 2);
      await db.userProfileDao.save(
        UserProfilesCompanion.insert(
          id: 'me',
          locale: 'en',
          examDate: Value(DateTime.utc(2027, 1, 15)),
          targetStage: const Value('psy0'),
          settings: const {},
          createdAt: t2,
          updatedAt: t2,
        ),
      );
      row = await db.userProfileDao.get();
      expect(row!.locale, 'en');
      expect(row.examDate, DateTime.utc(2027, 1, 15));
      expect(row.targetStage, 'psy0');
      expect(row.settings, isEmpty);
      expect(row.createdAt, t1);
      expect(row.updatedAt, t2);
      final count = await db
          .customSelect('SELECT COUNT(*) AS n FROM user_profile')
          .map((r) => r.read<int>('n'))
          .getSingle();
      expect(count, 1);
    });
  });
}
