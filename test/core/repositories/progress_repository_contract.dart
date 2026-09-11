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
}

/// "Now" as seen by the repositories under test.
final DateTime fixedNow = DateTime.utc(2026, 9, 11, 10);
