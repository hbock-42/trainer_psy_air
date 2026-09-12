import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/domain/exam_resume.dart';

void main() {
  final now = DateTime.utc(2026, 9, 12, 12);
  late InMemoryProgressRepository progress;

  setUp(() {
    progress = InMemoryProgressRepository(clock: () => now);
  });

  group('isExamResumable', () {
    test('true within 10 minutes of the last attempt', () async {
      final session = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: now.subtract(const Duration(hours: 1)),
      );
      final attempt = await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
          answeredAt: now.subtract(const Duration(minutes: 9)),
        ),
      );

      expect(isExamResumable(session, [attempt], now), isTrue);
    });

    test('false past 10 minutes since the last attempt', () async {
      final session = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: now.subtract(const Duration(hours: 1)),
      );
      final attempt = await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
          answeredAt: now.subtract(const Duration(minutes: 11)),
        ),
      );

      expect(isExamResumable(session, [attempt], now), isFalse);
    });

    test(
      'falls back to the session start when nothing was answered yet',
      () async {
        final fresh = await progress.startSession(
          mode: SessionMode.exam,
          blueprintId: 'bp.test',
          startedAt: now.subtract(const Duration(minutes: 5)),
        );
        final stale = await progress.startSession(
          mode: SessionMode.exam,
          blueprintId: 'bp.test',
          startedAt: now.subtract(const Duration(minutes: 15)),
        );

        expect(isExamResumable(fresh, const [], now), isTrue);
        expect(isExamResumable(stale, const [], now), isFalse);
      },
    );
  });

  group('examResumeSectionIndex', () {
    test('0 with no attempts', () {
      expect(examResumeSectionIndex(const []), 0);
    });

    test('the highest sectionIndex among the attempts', () async {
      final session = await progress.startSession(mode: SessionMode.exam);
      final a = await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 100,
          position: 0,
          sectionIndex: 0,
          itemId: 'q1',
        ),
      );
      final b = await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_b',
          isCorrect: true,
          responseMs: 100,
          position: 1,
          sectionIndex: 2,
          itemId: 'q2',
        ),
      );
      expect(examResumeSectionIndex([a, b]), 2);
    });
  });

  group('findResumableExamSession', () {
    test('picks the newest resumable session and abandons the rest', () async {
      final stale = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.a',
        startedAt: now.subtract(const Duration(minutes: 30)),
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: stale.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 100,
          position: 0,
          itemId: 'q1',
          answeredAt: now.subtract(const Duration(minutes: 20)),
        ),
      );
      final recent = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.b',
        startedAt: now.subtract(const Duration(minutes: 4)),
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: recent.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 100,
          position: 0,
          sectionIndex: 1,
          itemId: 'q2',
          answeredAt: now.subtract(const Duration(minutes: 2)),
        ),
      );

      // `sessions()` returns newest first.
      final sessions = await progress.sessions(mode: SessionMode.exam);
      final candidate = await findResumableExamSession(
        sessions: sessions,
        progress: progress,
        now: now,
      );

      expect(candidate, isNotNull);
      expect(candidate!.session.id, recent.id);
      expect(candidate.sectionIndex, 1);
      expect(candidate.attempts, hasLength(1));
      expect(progress.sessionsById[stale.id]!.status, SessionStatus.abandoned);
      expect(
        progress.sessionsById[recent.id]!.status,
        SessionStatus.inProgress,
      );
    });

    test('null and every session abandoned when none is resumable', () async {
      final stale = await progress.startSession(
        mode: SessionMode.exam,
        startedAt: now.subtract(const Duration(hours: 1)),
      );

      final sessions = await progress.sessions(mode: SessionMode.exam);
      final candidate = await findResumableExamSession(
        sessions: sessions,
        progress: progress,
        now: now,
      );

      expect(candidate, isNull);
      expect(progress.sessionsById[stale.id]!.status, SessionStatus.abandoned);
    });
  });
}
