import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

/// Behaviour every [ProgressRepository] must have. Run against the Drift
/// implementation (`LocalProgressRepository`) and the in-memory fake so that a
/// feature tested with the fake behaves the same on SQLite.
///
/// [create] must return a repository whose clock is [fixedNow] (UTC) so that
/// "now" defaults are predictable.
void runProgressRepositoryContract({
  required Future<ProgressRepository> Function() create,
  required Future<void> Function() dispose,
}) {
  late ProgressRepository repo;

  setUp(() async => repo = await create());
  tearDown(dispose);

  group('sessions', () {
    test(
      'startSession creates an in-progress session with a fresh id',
      () async {
        final a = await repo.startSession(
          mode: SessionMode.practice,
          familyId: 'english',
          config: const {'count': 20},
        );
        final b = await repo.startSession(
          mode: SessionMode.exam,
          blueprintId: 'psy0.blueprint.short',
        );
        expect(a.id, isNot(b.id));
        expect(a.status, SessionStatus.inProgress);
        expect(a.isFinished, isFalse);
        expect(a.startedAt, fixedNow);
        expect(a.startedAt.isUtc, isTrue);
        expect(a.config, {'count': 20});
        expect(a.familyId, 'english');
        expect(b.blueprintId, 'psy0.blueprint.short');
        expect(b.familyId, isNull);
        expect(await repo.sessionById(a.id), a);
        expect(await repo.sessionById('nope'), isNull);
      },
    );

    test('finishSession stores status, score and endedAt', () async {
      final s = await repo.startSession(mode: SessionMode.practice);
      final done = await repo.finishSession(
        s.id,
        status: SessionStatus.completed,
        score: 0.8,
        endedAt: fixedNow.add(const Duration(minutes: 5)).toLocal(),
      );
      expect(done.status, SessionStatus.completed);
      expect(done.isFinished, isTrue);
      expect(done.score, 0.8);
      expect(done.endedAt, fixedNow.add(const Duration(minutes: 5)));
      expect(done.endedAt!.isUtc, isTrue);
      expect(await repo.sessionById(s.id), done);

      final abandoned = await repo.startSession(mode: SessionMode.exam);
      final left = await repo.finishSession(
        abandoned.id,
        status: SessionStatus.abandoned,
      );
      expect(left.endedAt, fixedNow);
      expect(left.score, isNull);
    });

    test('finishSession rejects unknown sessions and inProgress', () async {
      await expectLater(
        repo.finishSession('missing', status: SessionStatus.completed),
        throwsStateError,
      );
      final s = await repo.startSession(mode: SessionMode.practice);
      await expectLater(
        repo.finishSession(s.id, status: SessionStatus.inProgress),
        throwsArgumentError,
      );
    });

    test('sessions lists by date range, newest first, with filters', () async {
      final day1 = DateTime.utc(2026, 9, 1, 9);
      final day2 = DateTime.utc(2026, 9, 2, 9);
      final day3 = DateTime.utc(2026, 9, 3, 9);
      final s1 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
        startedAt: day1,
      );
      final s2 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'memory',
        startedAt: day2,
      );
      final s3 = await repo.startSession(
        mode: SessionMode.exam,
        startedAt: day3,
      );
      await repo.finishSession(s2.id, status: SessionStatus.completed);

      expect((await repo.sessions()).map((s) => s.id), [s3.id, s2.id, s1.id]);
      expect((await repo.sessions(from: day2, to: day2)).map((s) => s.id), [
        s2.id,
      ]);
      expect((await repo.sessions(from: day2.toLocal())).map((s) => s.id), [
        s3.id,
        s2.id,
      ]);
      expect((await repo.sessions(mode: SessionMode.exam)).map((s) => s.id), [
        s3.id,
      ]);
      expect((await repo.sessions(familyId: 'english')).map((s) => s.id), [
        s1.id,
      ]);
      expect(
        (await repo.sessions(status: SessionStatus.completed)).map((s) => s.id),
        [s2.id],
      );
      expect((await repo.sessions(limit: 1)).map((s) => s.id), [s3.id]);
    });
  });

  group('attempts', () {
    test('recordAttempt stores bank and generated attempts', () async {
      final s = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      final bank = await repo.recordAttempt(
        NewAttempt(
          sessionId: s.id,
          familyId: 'english',
          itemId: 'english.item.1',
          answer: const {'index': 2},
          isCorrect: true,
          responseMs: 1500,
          position: 0,
        ),
      );
      final generated = await repo.recordAttempt(
        NewAttempt(
          sessionId: s.id,
          familyId: 'mental_arithmetic',
          origin: const AttemptOrigin(
            generatorId: 'mental_arithmetic.v1',
            seed: 42,
            params: {'kind': 'two_step', 'length': 6},
          ),
          isCorrect: false,
          responseMs: 3200,
          position: 1,
          sectionIndex: 2,
          answeredAt: DateTime.utc(2026, 9, 11, 10, 0, 0, 250).toLocal(),
        ),
      );
      expect(bank.id, isNot(generated.id));
      expect(bank.answeredAt, fixedNow);
      expect(bank.isGenerated, isFalse);
      expect(generated.isGenerated, isTrue);
      expect(generated.answeredAt, DateTime.utc(2026, 9, 11, 10, 0, 0, 250));
      expect(generated.answer, isNull);

      final stored = await repo.attemptsForSession(s.id);
      expect(stored, [bank, generated]);
      expect(stored[1].origin, generated.origin);
      expect(stored[1].sectionIndex, 2);
      expect(await repo.attemptsForSession('nope'), isEmpty);
    });

    test('a NewAttempt needs exactly one of itemId/origin', () {
      expect(
        () => NewAttempt(
          sessionId: 's',
          familyId: 'f',
          isCorrect: true,
          responseMs: 1,
          position: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => NewAttempt(
          sessionId: 's',
          familyId: 'f',
          itemId: 'i',
          origin: const AttemptOrigin(generatorId: 'g', seed: 1),
          isCorrect: true,
          responseMs: 1,
          position: 0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test(
      'recordAttempts stores a cadence burst in one call, in order',
      () async {
        final s = await repo.startSession(
          mode: SessionMode.practice,
          familyId: 'memory',
        );
        final tick = DateTime.utc(2026, 9, 11, 10, 0, 0, 100);
        final burst = [
          for (var i = 0; i < 42; i++)
            NewAttempt(
              sessionId: s.id,
              familyId: 'memory',
              origin: AttemptOrigin(generatorId: 'nback2', seed: i),
              isCorrect: i % 4 != 0,
              responseMs: 900 + i,
              position: i,
              answeredAt: tick,
            ),
        ];
        final stored = await repo.recordAttempts(burst);
        expect(stored, hasLength(42));
        expect(stored.map((a) => a.id).toSet(), hasLength(42));
        final read = await repo.attemptsForSession(s.id);
        expect(read.map((a) => a.position), List.generate(42, (i) => i));
        expect(read.every((a) => a.answeredAt == tick), isTrue);
        expect(await repo.recordAttempts([]), isEmpty);
      },
    );

    test('bank attempts fold into item stats; generated ones do not', () async {
      final s = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      Future<void> answer(String item, {required bool ok, required int ms}) =>
          repo.recordAttempt(
            NewAttempt(
              sessionId: s.id,
              familyId: 'english',
              itemId: item,
              isCorrect: ok,
              responseMs: ms,
              position: 0,
            ),
          );
      await answer('e1', ok: true, ms: 1000);
      await answer('e1', ok: false, ms: 2000);
      await answer('e2', ok: false, ms: 500);
      await repo.recordAttempt(
        NewAttempt(
          sessionId: s.id,
          familyId: 'english',
          origin: const AttemptOrigin(generatorId: 'g', seed: 1),
          isCorrect: true,
          responseMs: 1,
          position: 3,
        ),
      );

      final e1 = await repo.itemStat('e1');
      expect(e1!.seen, 2);
      expect(e1.correct, 1);
      expect(e1.totalResponseMs, 3000);
      expect(e1.meanResponseMs, 1500);
      expect(e1.accuracy, 0.5);
      expect(e1.lastCorrect, isFalse);
      expect(e1.lastSeenAt, fixedNow);
      expect(await repo.itemStat('nope'), isNull);

      final failed = await repo.itemStats(
        familyId: 'english',
        failedOnly: true,
      );
      expect(failed.map((st) => st.itemId).toSet(), {'e1', 'e2'});
      expect(await repo.itemStats(familyId: 'memory'), isEmpty);
      expect(await repo.itemStats(), hasLength(2));

      await answer('e1', ok: true, ms: 100);
      expect((await repo.itemStats(failedOnly: true)).map((st) => st.itemId), [
        'e2',
      ]);
    });
  });

  group('familyStats', () {
    test('aggregates per family with median of response times', () async {
      final practice = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      final exam = await repo.startSession(mode: SessionMode.exam);
      NewAttempt at(
        TrainingSession s,
        String family,
        int ms, {
        required bool ok,
        DateTime? when,
      }) => NewAttempt(
        sessionId: s.id,
        familyId: family,
        itemId: '$family.$ms',
        isCorrect: ok,
        responseMs: ms,
        position: ms,
        answeredAt: when,
      );
      await repo.recordAttempts([
        at(practice, 'english', 100, ok: true),
        at(practice, 'english', 300, ok: false),
        at(practice, 'english', 200, ok: true),
        at(practice, 'english', 1000, ok: true),
        at(exam, 'english', 5000, ok: false, when: DateTime.utc(2026, 9, 12)),
        at(exam, 'logic', 700, ok: true, when: DateTime.utc(2026, 9, 12)),
      ]);

      final all = await repo.familyStats();
      expect(all.map((f) => f.familyId), ['english', 'logic']);
      final english = all.first;
      expect(english.attempts, 5);
      expect(english.correct, 3);
      expect(english.accuracy, 0.6);
      expect(english.meanResponseMs, 1320);
      expect(english.medianResponseMs, 300);
      expect(all.last.medianResponseMs, 700);

      final practiceOnly = await repo.familyStats(mode: SessionMode.practice);
      expect(practiceOnly.single.attempts, 4);
      expect(practiceOnly.single.medianResponseMs, 250);

      final later = await repo.familyStats(from: DateTime.utc(2026, 9, 12));
      expect(later.map((f) => f.attempts), [1, 1]);
      expect(await repo.familyStats(from: DateTime.utc(2027)), isEmpty);
    });
  });

  group('sessionFamilyStats', () {
    test('one point per session, section and family, oldest first', () async {
      final day1 = DateTime.utc(2026, 9, 1, 9);
      final day2 = DateTime.utc(2026, 9, 2, 9);
      final day3 = DateTime.utc(2026, 9, 3, 9);
      final s1 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
        startedAt: day1,
      );
      final s2 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
        startedAt: day2,
      );
      final exam = await repo.startSession(
        mode: SessionMode.exam,
        startedAt: day3,
      );
      final empty = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'logic',
        startedAt: day3,
      );
      NewAttempt at(
        TrainingSession s,
        String family,
        int ms, {
        required bool ok,
        bool answered = true,
        int? section,
      }) => NewAttempt(
        sessionId: s.id,
        familyId: family,
        origin: AttemptOrigin(generatorId: 'g', seed: ms),
        answer: answered ? const {'index': 0} : null,
        isCorrect: ok,
        responseMs: ms,
        position: ms,
        sectionIndex: section,
      );
      await repo.recordAttempts([
        at(s1, 'english', 100, ok: true),
        at(s1, 'english', 300, ok: false, answered: false),
        at(s1, 'english', 200, ok: true),
        at(s2, 'english', 1000, ok: true),
        at(exam, 'logic', 700, ok: true, section: 0),
        at(exam, 'logic', 900, ok: true, section: 0),
        at(exam, 'english', 5000, ok: false, section: 1),
        at(exam, 'logic', 400, ok: false, section: 2),
      ]);

      final all = await repo.sessionFamilyStats();
      expect(all.map((p) => (p.sessionId, p.sectionIndex, p.familyId)), [
        (s1.id, null, 'english'),
        (s2.id, null, 'english'),
        (exam.id, 0, 'logic'),
        (exam.id, 1, 'english'),
        (exam.id, 2, 'logic'),
      ]);
      expect(all.map((p) => p.sessionId), isNot(contains(empty.id)));
      final first = all.first;
      expect(first.mode, SessionMode.practice);
      expect(first.startedAt, day1);
      expect(first.startedAt.isUtc, isTrue);
      expect(first.attempts, 3);
      expect(first.correct, 2);
      expect(first.unanswered, 1);
      expect(first.accuracy, closeTo(2 / 3, 1e-9));
      expect(first.meanResponseMs, 200);
      expect(first.medianResponseMs, 200);
      final logic = all[2];
      expect(logic.mode, SessionMode.exam);
      expect(logic.medianResponseMs, 800);
      expect(logic.unanswered, 0);
      expect(all.last.attempts, 1);
      expect(all.last.correct, 0);

      expect(
        (await repo.sessionFamilyStats(
          familyId: 'english',
        )).map((p) => p.sessionId),
        [s1.id, s2.id, exam.id],
      );
      expect(
        (await repo.sessionFamilyStats(
          mode: SessionMode.exam,
        )).map((p) => p.familyId),
        ['logic', 'english', 'logic'],
      );
      expect(
        (await repo.sessionFamilyStats(
          from: day2.toLocal(),
          to: day2,
        )).map((p) => p.sessionId),
        [s2.id],
      );
      expect(await repo.sessionFamilyStats(from: DateTime.utc(2027)), isEmpty);
    });
  });

  group('flashcards', () {
    test(
      'saveFlashcardReview upserts and dueFlashcardReviews filters',
      () async {
        final now = DateTime.utc(2026, 9, 11, 12);
        FlashcardReview review(String card, DateTime next, {int box = 1}) =>
            FlashcardReview(
              flashcardId: card,
              deckId: 'deck',
              box: box,
              reviews: 1,
              lapses: 0,
              nextReviewAt: next,
              lastReviewedAt: now.subtract(const Duration(days: 1)),
            );
        await repo.saveFlashcardReview(review('c1', now));
        await repo.saveFlashcardReview(
          review('c2', now.subtract(const Duration(hours: 1)).toLocal()),
        );
        await repo.saveFlashcardReview(
          review('c3', now.add(const Duration(days: 3))),
        );

        expect(
          (await repo.dueFlashcardReviews(now: now)).map((r) => r.flashcardId),
          ['c2', 'c1'],
        );
        expect(
          (await repo.dueFlashcardReviews(
            now: now,
            limit: 1,
          )).map((r) => r.flashcardId),
          ['c2'],
        );
        expect(
          await repo.dueFlashcardReviews(now: now, deckId: 'other'),
          isEmpty,
        );

        await repo.saveFlashcardReview(
          review('c1', now.add(const Duration(days: 7)), box: 2),
        );
        final c1 = await repo.flashcardReview('c1');
        expect(c1!.box, 2);
        expect(c1.nextReviewAt, now.add(const Duration(days: 7)));
        expect(c1.nextReviewAt.isUtc, isTrue);
        expect(
          (await repo.dueFlashcardReviews(now: now)).map((r) => r.flashcardId),
          ['c2'],
        );
        expect(await repo.flashcardReview('nope'), isNull);
      },
    );
  });

  group('lessons', () {
    test('markLessonRead is idempotent and keeps the first date', () async {
      await repo.markLessonRead('l1', readAt: DateTime.utc(2026, 9, 1, 8));
      await repo.markLessonRead('l1');
      await repo.markLessonRead('l2');
      final read = await repo.lessonsRead();
      expect(read, [
        LessonRead(lessonId: 'l1', readAt: DateTime.utc(2026, 9, 1, 8)),
        LessonRead(lessonId: 'l2', readAt: fixedNow),
      ]);
    });
  });

  group('profile', () {
    test('is null until saved, then round-trips', () async {
      expect(await repo.profile(), isNull);
      const profile = UserProfile(
        locale: 'fr',
        targetStage: 'psy0',
        settings: {'sound': false, 'dailyGoal': 3},
      );
      await repo.saveProfile(profile);
      expect(await repo.profile(), profile);

      final updated = profile.copyWith(
        locale: 'en',
        examDate: DateTime.utc(2027, 1, 15).toLocal(),
      );
      await repo.saveProfile(updated);
      final stored = await repo.profile();
      expect(stored!.locale, 'en');
      expect(stored.examDate, DateTime.utc(2027, 1, 15));
      expect(stored.settings, profile.settings);
    });
  });

  group('clearAll', () {
    test('wipes every user table (US-091 "reset all data")', () async {
      final session = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      await repo.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'english',
          itemId: 'item-1',
          answer: const {'value': 1},
          isCorrect: true,
          responseMs: 800,
          position: 0,
        ),
      );
      await repo.saveFlashcardReview(
        FlashcardReview(
          flashcardId: 'card-1',
          deckId: 'deck-1',
          box: 1,
          reviews: 1,
          lapses: 0,
          nextReviewAt: fixedNow,
        ),
      );
      await repo.markLessonRead('lesson-1');
      await repo.saveProfile(const UserProfile(locale: 'fr'));

      await repo.clearAll();

      expect(await repo.sessions(), isEmpty);
      expect(await repo.attemptsForSession(session.id), isEmpty);
      expect(await repo.itemStats(), isEmpty);
      expect(await repo.dueFlashcardReviews(now: fixedNow), isEmpty);
      expect(await repo.lessonsRead(), isEmpty);
      expect(await repo.profile(), isNull);
    });
  });

  group('backup (US-074)', () {
    test('allAttempts returns every attempt, any family', () async {
      final s1 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'english',
      );
      final s2 = await repo.startSession(
        mode: SessionMode.practice,
        familyId: 'memory_nback',
      );
      await repo.recordAttempt(
        NewAttempt(
          sessionId: s1.id,
          familyId: 'english',
          itemId: 'item-1',
          isCorrect: true,
          responseMs: 500,
          position: 0,
        ),
      );
      await repo.recordAttempt(
        NewAttempt(
          sessionId: s2.id,
          familyId: 'memory_nback',
          origin: const AttemptOrigin(generatorId: 'nback', seed: 1),
          isCorrect: false,
          responseMs: 700,
          position: 0,
        ),
      );
      final all = await repo.allAttempts();
      expect(all, hasLength(2));
      expect(
        all.map((a) => a.familyId),
        containsAll(['english', 'memory_nback']),
      );
    });

    test('allFlashcardReviews returns every card review', () async {
      await repo.saveFlashcardReview(
        FlashcardReview(
          flashcardId: 'card-1',
          deckId: 'deck-1',
          box: 1,
          reviews: 1,
          lapses: 0,
          nextReviewAt: fixedNow,
        ),
      );
      await repo.saveFlashcardReview(
        FlashcardReview(
          flashcardId: 'card-2',
          deckId: 'deck-1',
          box: 2,
          reviews: 3,
          lapses: 1,
          nextReviewAt: fixedNow,
        ),
      );
      final all = await repo.allFlashcardReviews();
      expect(all.map((r) => r.flashcardId), containsAll(['card-1', 'card-2']));
    });

    test(
      'exportSnapshot -> importSnapshot round-trips into a fresh repository',
      () async {
        final session = await repo.startSession(
          mode: SessionMode.practice,
          familyId: 'english',
        );
        await repo.recordAttempt(
          NewAttempt(
            sessionId: session.id,
            familyId: 'english',
            itemId: 'item-1',
            isCorrect: true,
            responseMs: 900,
            position: 0,
          ),
        );
        await repo.saveFlashcardReview(
          FlashcardReview(
            flashcardId: 'card-1',
            deckId: 'deck-1',
            box: 1,
            reviews: 1,
            lapses: 0,
            nextReviewAt: fixedNow,
          ),
        );
        await repo.markLessonRead('lesson-1');
        await repo.saveProfile(const UserProfile(locale: 'fr'));

        final snapshot = await repo.exportSnapshot();
        expect(snapshot.sessions, hasLength(1));
        expect(snapshot.attempts, hasLength(1));
        expect(snapshot.itemStats, hasLength(1));
        expect(snapshot.flashcardReviews, hasLength(1));
        expect(snapshot.lessonProgress, hasLength(1));
        expect(snapshot.profile, isNotNull);

        await repo.clearAll();
        expect(await repo.sessions(), isEmpty);

        final summary = await repo.importSnapshot(snapshot);
        expect(
          summary.inserted,
          snapshot.sessions.length +
              snapshot.attempts.length +
              snapshot.itemStats.length +
              snapshot.flashcardReviews.length +
              snapshot.lessonProgress.length +
              (snapshot.profile == null ? 0 : 1),
        );
        expect(summary.updated, 0);

        expect(await repo.sessionById(session.id), isNotNull);
        expect(await repo.allAttempts(), hasLength(1));
        expect(await repo.itemStat('item-1'), isNotNull);
        expect(await repo.allFlashcardReviews(), hasLength(1));
        expect(await repo.lessonsRead(), hasLength(1));
        expect((await repo.profile())?.locale, 'fr');
      },
    );

    test('importSnapshot: a newer row wins over the existing one', () async {
      await repo.recordAttempt(
        NewAttempt(
          sessionId: (await repo.startSession(mode: SessionMode.practice)).id,
          familyId: 'english',
          itemId: 'item-1',
          isCorrect: false,
          responseMs: 1000,
          position: 0,
        ),
      );
      final before = await repo.exportSnapshot();
      final oldRow = before.itemStats.singleWhere(
        (r) => r.fields['itemId'] == 'item-1',
      );
      final newerRow = BackupRow(
        id: oldRow.id,
        updatedAt: oldRow.updatedAt.add(const Duration(minutes: 1)),
        fields: {...oldRow.fields, 'seen': 99, 'correct': 99},
      );

      final summary = await repo.importSnapshot(
        BackupSnapshot(
          sessions: const [],
          attempts: const [],
          itemStats: [newerRow],
          flashcardReviews: const [],
          lessonProgress: const [],
        ),
      );
      expect(summary.updated, 1);
      expect((await repo.itemStat('item-1'))?.seen, 99);
    });

    test('importSnapshot: an older (or equal) row is skipped', () async {
      await repo.recordAttempt(
        NewAttempt(
          sessionId: (await repo.startSession(mode: SessionMode.practice)).id,
          familyId: 'english',
          itemId: 'item-1',
          isCorrect: true,
          responseMs: 500,
          position: 0,
        ),
      );
      final before = await repo.exportSnapshot();
      final oldRow = before.itemStats.singleWhere(
        (r) => r.fields['itemId'] == 'item-1',
      );
      final staleRow = BackupRow(
        id: oldRow.id,
        updatedAt: oldRow.updatedAt.subtract(const Duration(minutes: 1)),
        fields: {...oldRow.fields, 'seen': 99},
      );

      final summary = await repo.importSnapshot(
        BackupSnapshot(
          sessions: const [],
          attempts: const [],
          itemStats: [staleRow],
          flashcardReviews: const [],
          lessonProgress: const [],
        ),
      );
      expect(summary.skipped, 1);
      expect(summary.updated, 0);
      expect((await repo.itemStat('item-1'))?.seen, 1);
    });
  });
}

/// "Now" as seen by the repositories under test.
final DateTime fixedNow = DateTime.utc(2026, 9, 11, 10);
