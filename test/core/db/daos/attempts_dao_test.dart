import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/db/app_database.dart';
import 'package:psy_trainer/core/repositories/model/session.dart';
import 'package:psy_trainer/core/repositories/model/stats.dart';

import '../example_content.dart';

void main() {
  late AppDatabase db;
  var nextId = 0;

  setUp(() {
    db = openTestDatabase();
    nextId = 0;
  });
  tearDown(() => db.close());

  Future<void> session(
    String id, {
    SessionMode mode = SessionMode.practice,
    DateTime? startedAt,
  }) {
    final at = startedAt ?? DateTime.utc(2026, 9);
    return db.sessionsDao.insertSession(
      SessionsCompanion.insert(
        id: id,
        mode: mode,
        startedAt: at,
        status: SessionStatus.completed,
        config: const {},
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  AttemptsCompanion attempt({
    required String sessionId,
    required String familyId,
    required bool correct,
    required int ms,
    required int position,
    String? itemId,
    Map<String, Object?>? origin,
    DateTime? at,
  }) {
    final answeredAt = at ?? DateTime.utc(2026, 9, 1, 10);
    return AttemptsCompanion.insert(
      id: 'a${nextId++}',
      sessionId: sessionId,
      familyId: familyId,
      itemId: Value(itemId),
      origin: Value(origin),
      answer: Value(correct ? const {'index': 1} : null),
      isCorrect: correct,
      responseMs: ms,
      position: position,
      answeredAt: answeredAt,
      createdAt: answeredAt,
      updatedAt: answeredAt,
    );
  }

  group('familyAggregates', () {
    test('computes count, correct, mean and median per family', () async {
      await session('s1');
      await db.attemptsDao.insertAttempts([
        // english: 4 attempts, 3 correct, RTs 100 200 300 1000
        // -> mean 400, median (200+300)/2 = 250
        attempt(
          sessionId: 's1',
          familyId: 'english',
          correct: true,
          ms: 1000,
          position: 0,
        ),
        attempt(
          sessionId: 's1',
          familyId: 'english',
          correct: true,
          ms: 100,
          position: 1,
        ),
        attempt(
          sessionId: 's1',
          familyId: 'english',
          correct: false,
          ms: 300,
          position: 2,
        ),
        attempt(
          sessionId: 's1',
          familyId: 'english',
          correct: true,
          ms: 200,
          position: 3,
        ),
        // logic: 3 attempts, 1 correct, RTs 50 70 900 -> mean 340, median 70
        attempt(
          sessionId: 's1',
          familyId: 'logic',
          correct: false,
          ms: 900,
          position: 4,
        ),
        attempt(
          sessionId: 's1',
          familyId: 'logic',
          correct: true,
          ms: 50,
          position: 5,
        ),
        attempt(
          sessionId: 's1',
          familyId: 'logic',
          correct: false,
          ms: 70,
          position: 6,
        ),
        // memory: single attempt -> median == mean == the value
        attempt(
          sessionId: 's1',
          familyId: 'memory',
          correct: true,
          ms: 1234,
          position: 7,
        ),
      ]);

      final stats = await db.attemptsDao.familyAggregates();
      expect(stats, [
        const FamilyStats(
          familyId: 'english',
          attempts: 4,
          correct: 3,
          meanResponseMs: 400,
          medianResponseMs: 250,
        ),
        const FamilyStats(
          familyId: 'logic',
          attempts: 3,
          correct: 1,
          meanResponseMs: 340,
          medianResponseMs: 70,
        ),
        const FamilyStats(
          familyId: 'memory',
          attempts: 1,
          correct: 1,
          meanResponseMs: 1234,
          medianResponseMs: 1234,
        ),
      ]);
      expect(stats.first.accuracy, 0.75);
    });

    test('is empty without attempts', () async {
      expect(await db.attemptsDao.familyAggregates(), isEmpty);
    });

    test('filters by date range and session mode', () async {
      await session('practice', startedAt: DateTime.utc(2026, 9));
      await session(
        'exam',
        mode: SessionMode.exam,
        startedAt: DateTime.utc(2026, 9, 5),
      );
      await db.attemptsDao.insertAttempts([
        attempt(
          sessionId: 'practice',
          familyId: 'english',
          correct: true,
          ms: 100,
          position: 0,
          at: DateTime.utc(2026, 9, 1, 10),
        ),
        attempt(
          sessionId: 'practice',
          familyId: 'english',
          correct: false,
          ms: 300,
          position: 1,
          at: DateTime.utc(2026, 9, 2, 10),
        ),
        attempt(
          sessionId: 'exam',
          familyId: 'english',
          correct: true,
          ms: 500,
          position: 0,
          at: DateTime.utc(2026, 9, 5, 10),
        ),
      ]);

      final examOnly = await db.attemptsDao.familyAggregates(
        mode: SessionMode.exam,
      );
      expect(examOnly.single.attempts, 1);
      expect(examOnly.single.medianResponseMs, 500);

      final firstDayOnly = await db.attemptsDao.familyAggregates(
        from: DateTime.utc(2026, 9),
        to: DateTime.utc(2026, 9, 1, 23, 59, 59),
      );
      expect(firstDayOnly.single.attempts, 1);
      expect(firstDayOnly.single.meanResponseMs, 100);

      // Inclusive lower bound, exact match, non-UTC input normalised.
      final fromExact = await db.attemptsDao.familyAggregates(
        from: DateTime.utc(2026, 9, 2, 10).toLocal(),
      );
      expect(fromExact.single.attempts, 2);
      expect(fromExact.single.correct, 1);

      final nothing = await db.attemptsDao.familyAggregates(
        from: DateTime.utc(2027),
      );
      expect(nothing, isEmpty);
    });
  });

  group('many attempts per second (n-back, rules S-R)', () {
    test(
      'stores hundreds of attempts sharing a timestamp, ordered by position',
      () async {
        await session('nback');
        final tick = DateTime.utc(2026, 9, 1, 10, 0, 0, 500);
        // A 2-back run: 42 stimuli, then a rules S-R burst of 200 in the same
        // second. Every attempt has the same answeredAt.
        final rows = [
          for (var i = 0; i < 242; i++)
            attempt(
              sessionId: 'nback',
              familyId: i < 42 ? 'memory' : 'attention',
              correct: i % 3 != 0,
              ms: 400 + (i % 7) * 100,
              position: i,
              origin: {'generatorId': 'nback2', 'seed': i, 'params': {}},
              at: tick,
            ),
        ];
        // Insert in a scrambled order to prove ordering comes from position.
        final scrambled = [...rows.reversed];
        await db.attemptsDao.insertAttempts(scrambled);

        final stored = await db.attemptsDao.bySession('nback');
        expect(stored, hasLength(242));
        expect(stored.map((a) => a.position), List.generate(242, (i) => i));
        expect(stored.every((a) => a.answeredAt == tick), isTrue);
        expect(stored.every((a) => a.itemId == null), isTrue);
        expect(stored.first.origin, {
          'generatorId': 'nback2',
          'seed': 0,
          'params': <String, Object?>{},
        });
        expect(await db.attemptsDao.countBySession('nback'), 242);

        final stats = await db.attemptsDao.familyAggregates(
          from: tick,
          to: tick,
        );
        expect(stats.map((s) => s.familyId), ['attention', 'memory']);
        expect(stats.map((s) => s.attempts), [200, 42]);
        expect(
          stats.map((s) => s.correct).fold<int>(0, (a, b) => a + b),
          rows.where((r) => r.isCorrect.value).length,
        );
        // RTs cycle over 400..1000 step 100; the median of a full cycle is 700.
        expect(
          stats.firstWhere((s) => s.familyId == 'memory').medianResponseMs,
          700,
        );
      },
    );

    test('a single attempt at a time is also fine (no batching)', () async {
      await session('s');
      for (var i = 0; i < 20; i++) {
        await db.attemptsDao.insertAttempt(
          attempt(
            sessionId: 's',
            familyId: 'memory',
            correct: true,
            ms: 10,
            position: i,
            itemId: 'memory.item.$i',
          ),
        );
      }
      expect(await db.attemptsDao.countBySession('s'), 20);
      expect(await db.attemptsDao.countBySession('none'), 0);
    });
  });

  group('sessionFamilyAggregates', () {
    test('groups by session and family, oldest session first', () async {
      await session('late', startedAt: DateTime.utc(2026, 9, 3));
      await session('early', startedAt: DateTime.utc(2026, 9, 1));
      await session(
        'exam',
        mode: SessionMode.exam,
        startedAt: DateTime.utc(2026, 9, 2),
      );
      await db.attemptsDao.insertAttempts([
        // early/english: RTs 100 300 200 (one unanswered) -> median 200
        attempt(
          sessionId: 'early',
          familyId: 'english',
          correct: true,
          ms: 100,
          position: 0,
        ),
        attempt(
          sessionId: 'early',
          familyId: 'english',
          correct: false,
          ms: 300,
          position: 1,
        ),
        attempt(
          sessionId: 'early',
          familyId: 'english',
          correct: true,
          ms: 200,
          position: 2,
        ),
        // exam: two families in one session
        attempt(
          sessionId: 'exam',
          familyId: 'english',
          correct: false,
          ms: 5000,
          position: 0,
        ),
        attempt(
          sessionId: 'exam',
          familyId: 'logic',
          correct: true,
          ms: 700,
          position: 1,
        ),
        attempt(
          sessionId: 'exam',
          familyId: 'logic',
          correct: true,
          ms: 900,
          position: 2,
        ),
        // late/english: single attempt
        attempt(
          sessionId: 'late',
          familyId: 'english',
          correct: true,
          ms: 1000,
          position: 0,
        ),
      ]);

      final points = await db.attemptsDao.sessionFamilyAggregates();
      expect(points, [
        SessionFamilyStats(
          sessionId: 'early',
          familyId: 'english',
          mode: SessionMode.practice,
          startedAt: DateTime.utc(2026, 9, 1),
          attempts: 3,
          correct: 2,
          unanswered: 1,
          meanResponseMs: 200,
          medianResponseMs: 200,
        ),
        SessionFamilyStats(
          sessionId: 'exam',
          familyId: 'english',
          mode: SessionMode.exam,
          startedAt: DateTime.utc(2026, 9, 2),
          attempts: 1,
          correct: 0,
          unanswered: 1,
          meanResponseMs: 5000,
          medianResponseMs: 5000,
        ),
        SessionFamilyStats(
          sessionId: 'exam',
          familyId: 'logic',
          mode: SessionMode.exam,
          startedAt: DateTime.utc(2026, 9, 2),
          attempts: 2,
          correct: 2,
          unanswered: 0,
          meanResponseMs: 800,
          medianResponseMs: 800,
        ),
        SessionFamilyStats(
          sessionId: 'late',
          familyId: 'english',
          mode: SessionMode.practice,
          startedAt: DateTime.utc(2026, 9, 3),
          attempts: 1,
          correct: 1,
          unanswered: 0,
          meanResponseMs: 1000,
          medianResponseMs: 1000,
        ),
      ]);
      expect(points.first.startedAt.isUtc, isTrue);

      expect(
        (await db.attemptsDao.sessionFamilyAggregates(
          familyId: 'logic',
        )).map((p) => p.sessionId),
        ['exam'],
      );
      expect(
        (await db.attemptsDao.sessionFamilyAggregates(
          mode: SessionMode.practice,
        )).map((p) => p.sessionId),
        ['early', 'late'],
      );
      expect(
        (await db.attemptsDao.sessionFamilyAggregates(
          from: DateTime.utc(2026, 9, 2),
          to: DateTime.utc(2026, 9, 2, 23),
        )).map((p) => p.familyId),
        ['english', 'logic'],
      );
      expect(
        await db.attemptsDao.sessionFamilyAggregates(
          from: DateTime.utc(2026, 9, 4),
        ),
        isEmpty,
      );
    });

    test('is empty without attempts', () async {
      await session('s');
      expect(await db.attemptsDao.sessionFamilyAggregates(), isEmpty);
    });
  });
}
