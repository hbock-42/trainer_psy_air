import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/engines/memory_nback/domain/nback_engine.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../../helpers/fake_engine.dart';

class _FailingRepository extends InMemoryProgressRepository {
  _FailingRepository({super.clock});

  @override
  Future<Attempt> recordAttempt(NewAttempt attempt) async =>
      throw StateError('disk full');
}

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  const cadence = Cadence(stimulusMs: 1000, answerWindowMs: 1500);
  const right = Answer.choice(0);
  const wrong = Answer.choice(2);

  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late FakeEngine engine;
  late EngineRegistry registry;
  late List<ActivitySessionState> log;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    engine = FakeEngine();
    registry = EngineRegistry([engine]);
    log = [];
  });

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    int items = 3,
    ItemSource? source,
    TimingPolicy timing = TimingPolicy.none,
    bool liveFeedback = false,
    ScoringPolicy scoringPolicy = const ScoringPolicy(),
    String? sessionId,
    bool ownsSession = true,
    int? sectionIndex,
    int positionOffset = 0,
  }) => ActivitySessionConfig(
    familyId: 'fake_family',
    mode: mode,
    source: source ?? ItemSource.bank(fakeBank(items)),
    timing: timing,
    liveFeedback: liveFeedback,
    scoringPolicy: scoringPolicy,
    sessionId: sessionId,
    ownsSession: ownsSession,
    sectionIndex: sectionIndex,
    positionOffset: positionOffset,
    blueprintId: mode == SessionMode.exam ? 'psy0_short' : null,
  );

  ActivitySession session(
    ActivitySessionConfig config, {
    ProgressRepository? repository,
    EngineClock? withClock,
    PersistenceErrorHandler? onPersistenceError,
  }) {
    final s = ActivitySession(
      config: config,
      registry: registry,
      repository: repository ?? repo,
      clock: withClock ?? clock,
      onPersistenceError: onPersistenceError,
    );
    s.states.listen(log.add);
    addTearDown(s.dispose);
    return s;
  }

  ActivityRunning running(ActivitySession s) => s.state as ActivityRunning;
  ActivityFinished finished(ActivitySession s) => s.state as ActivityFinished;

  group('briefing and start', () {
    test('starts in briefing with the item count', () {
      final s = session(config(items: 4));
      expect(s.state, const ActivitySessionState.briefing(itemCount: 4));
      expect(s.config.itemCount, 4);
      expect(s.items, hasLength(4));
      expect(s.outcomes, isEmpty);
      expect(s.sessionId, isNull);
      expect(s.showsFeedback, isTrue);
      expect(s.canPause, isTrue);
    });

    test('start shows the first item, untimed, and opens a session', () async {
      final s = session(config());
      s.start();
      final r = running(s);
      expect(r.itemIndex, 0);
      expect(r.itemCount, 3);
      expect(r.item.id, 'q1');
      expect(r.phase, ItemPhase.answer);
      expect(r.itemStartedAt, start);
      expect(r.itemDeadline, isNull);
      expect(r.sectionDeadline, isNull);
      expect(r.feedback, isNull);
      expect(r.awaitsNext, isFalse);
      expect(r.itemRemaining(start), isNull);

      await s.idle;
      expect(s.sessionId, 'session-1');
      final stored = repo.sessionsById['session-1']!;
      expect(stored.mode, SessionMode.practice);
      expect(stored.familyId, 'fake_family');
      expect(stored.status, SessionStatus.inProgress);
      expect(stored.startedAt, start);
      expect(ActivitySessionConfig.fromJson(stored.config), config());
    });

    test('start is ignored once running; answer is ignored in briefing', () {
      final s = session(config());
      s.answer(right);
      expect(s.state.isBriefing, isTrue);
      s.start();
      s.start();
      expect(running(s).itemIndex, 0);
      expect(log, hasLength(1));
    });

    test('a timeout answer is rejected', () {
      final s = session(config());
      s.start();
      expect(() => s.answer(const Answer.timeout()), throwsArgumentError);
    });
  });

  group('practice flow (feedback, next)', () {
    test('answers stay on screen with feedback until next()', () async {
      final s = session(config());
      s.start();
      clock.elapse(const Duration(milliseconds: 700));
      s.answer(right);
      var r = running(s);
      expect(r.phase, ItemPhase.answered);
      expect(r.feedback, ItemResult.right);
      expect(r.awaitsNext, isTrue);
      expect(r.isAnswered, isTrue);
      expect(s.outcomes.single.responseMs, 700);
      expect(engine.calls, [('q1', right)]);

      // A second answer on the same item is ignored.
      s.answer(wrong);
      expect(s.outcomes, hasLength(1));

      s.next();
      r = running(s);
      expect(r.itemIndex, 1);
      expect(r.phase, ItemPhase.answer);
      expect(r.feedback, isNull);
      expect(r.awaitsNext, isFalse);

      // next() without an answer is ignored.
      s.next();
      expect(running(s).itemIndex, 1);

      s.answer(wrong);
      s.next();
      s.answer(right);
      expect(s.state.isRunning, isTrue);
      s.next();

      final f = finished(s);
      expect(f.result.reason, FinishReason.completed);
      expect(f.result.mode, SessionMode.practice);
      expect(f.result.familyId, 'fake_family');
      expect(f.result.isAborted, isFalse);
      expect(f.result.outcomes.map((o) => o.isCorrect), [true, false, true]);
      expect(f.result.section.correct, 2);
      expect(f.result.section.wrong, 1);
      expect(f.result.section.played, 3);
      expect(f.result.score, closeTo(2 / 3, 1e-9));

      // The id is only known once startSession returned.
      expect(f.result.sessionId, isNull);
      await s.idle;
      expect(s.sessionId, 'session-1');
      final stored = repo.sessionsById['session-1']!;
      expect(stored.status, SessionStatus.completed);
      expect(stored.score, closeTo(2 / 3, 1e-9));
      expect(stored.endedAt, clock.now());
      final attempts = repo.attempts;
      expect(attempts, hasLength(3));
      expect(attempts.map((a) => a.position), [0, 1, 2]);
      expect(attempts.map((a) => a.itemId), ['q1', 'q2', 'q3']);
      expect(attempts.map((a) => a.isCorrect), [true, false, true]);
      expect(attempts.first.responseMs, 700);
      expect(attempts.first.answer, {'kind': 'choice', 'index': 0});
      expect(attempts.first.origin, isNull);
      expect(attempts.first.sectionIndex, isNull);
      expect(
        attempts.first.answeredAt,
        start.add(const Duration(milliseconds: 700)),
      );
    });

    test('emits every state on the stream', () {
      final s = session(config(items: 1));
      s.start();
      s.answer(right);
      s.next();
      expect(log.map((st) => st.runtimeType.toString()), [
        'ActivityRunning',
        'ActivityRunning',
        'ActivityFinished',
      ]);
      expect(log[0].running!.phase, ItemPhase.answer);
      expect(log[1].running!.phase, ItemPhase.answered);
      expect(log[2].running, isNull);
    });
  });

  group('exam flow (silent, no pause)', () {
    test('advances right after an answer and hides the verdict', () async {
      final s = session(config(mode: SessionMode.exam));
      expect(s.showsFeedback, isFalse);
      expect(s.canPause, isFalse);
      s.start();
      s.answer(wrong);
      final r = running(s);
      expect(r.itemIndex, 1);
      expect(r.feedback, isNull);
      expect(log.every((st) => st.running?.feedback == null), isTrue);
      expect(s.pause, throwsStateError);

      s.answer(right);
      s.answer(right);
      expect(finished(s).result.reason, FinishReason.completed);
      await s.idle;
      expect(repo.sessionsById['session-1']!.blueprintId, 'psy0_short');
      expect(repo.sessionsById['session-1']!.mode, SessionMode.exam);
    });

    test('liveFeedback keeps the verdict visible in exam mode', () {
      final s = session(config(mode: SessionMode.exam, liveFeedback: true));
      expect(s.showsFeedback, isTrue);
      s.start();
      s.answer(wrong);
      final r = running(s);
      expect(r.itemIndex, 0);
      expect(r.feedback, ItemResult.wrong);
      expect(r.awaitsNext, isTrue);
      expect(s.pause, throwsStateError);
      s.next();
      expect(running(s).itemIndex, 1);
    });

    test(
      'attaches to the runner session without starting or finishing it',
      () async {
        final owner = await repo.startSession(mode: SessionMode.exam);
        final s = session(
          config(
            mode: SessionMode.exam,
            items: 2,
            sessionId: owner.id,
            ownsSession: false,
            sectionIndex: 1,
            positionOffset: 5,
          ),
        );
        expect(s.config.ownsSession, isFalse);
        s.start();
        expect(s.sessionId, owner.id);
        s.answer(right);
        s.answer(wrong);
        await s.idle;
        expect(repo.sessionsById, hasLength(1));
        expect(repo.sessionsById[owner.id]!.status, SessionStatus.inProgress);
        expect(repo.attempts.map((a) => a.position), [5, 6]);
        expect(repo.attempts.map((a) => a.sectionIndex), [1, 1]);
        expect(finished(s).result.sectionIndex, 1);
        expect(finished(s).result.sessionId, owner.id);
      },
    );
  });

  group('per-item limit', () {
    const timing = TimingPolicy(perItemMs: 10000);

    test(
      'sets the deadline and records a timeout when it expires (practice)',
      () async {
        final s = session(config(timing: timing));
        s.start();
        final r = running(s);
        expect(r.itemDeadline, start.add(const Duration(seconds: 10)));
        expect(
          r.itemRemaining(start.add(const Duration(seconds: 4))),
          const Duration(seconds: 6),
        );
        expect(
          r.itemRemaining(start.add(const Duration(seconds: 40))),
          Duration.zero,
        );

        clock.elapse(const Duration(seconds: 10));
        final t = running(s);
        expect(t.itemIndex, 0);
        expect(t.phase, ItemPhase.answered);
        expect(t.feedback, ItemResult.timeout);
        expect(t.awaitsNext, isTrue);
        expect(t.itemDeadline, isNull);
        expect(s.outcomes.single.answer, const Answer.timeout());
        expect(s.outcomes.single.isTimeout, isTrue);
        expect(s.outcomes.single.responseMs, 10000);
        expect(engine.calls, isEmpty);

        // Late answers are ignored; next moves on.
        s.answer(right);
        expect(s.outcomes, hasLength(1));
        s.next();
        expect(running(s).itemIndex, 1);
        expect(
          running(s).itemDeadline,
          clock.now().add(const Duration(seconds: 10)),
        );

        await s.idle;
        expect(repo.attempts.single.answer, isNull);
        expect(repo.attempts.single.isCorrect, isFalse);
      },
    );

    test('advances straight away on timeout in exam mode', () {
      final s = session(config(mode: SessionMode.exam, timing: timing));
      s.start();
      clock.elapse(const Duration(seconds: 10));
      expect(running(s).itemIndex, 1);
      clock.elapse(const Duration(seconds: 10));
      clock.elapse(const Duration(seconds: 10));
      final f = finished(s);
      expect(f.result.section.timeouts, 3);
      expect(f.result.section.accuracy, 0);
      expect(f.result.section.meanResponseMs, isNull);
    });

    test('answering cancels the item timer', () {
      final s = session(config(timing: timing));
      s.start();
      clock.elapse(const Duration(seconds: 3));
      s.answer(right);
      expect(running(s).itemDeadline, isNull);
      clock.elapse(const Duration(seconds: 30));
      expect(s.outcomes, hasLength(1));
      expect(running(s).awaitsNext, isTrue);
      expect(clock.pendingTasks, 0);
    });
  });

  group('fixed cadence', () {
    const timing = TimingPolicy(cadence: cadence);

    test('stimulus then answer phase, then advances at the window end', () {
      final s = session(config(mode: SessionMode.exam, timing: timing));
      s.start();
      var r = running(s);
      expect(r.phase, ItemPhase.stimulus);
      expect(r.itemDeadline, start.add(const Duration(milliseconds: 2500)));

      clock.elapse(const Duration(milliseconds: 1000));
      r = running(s);
      expect(r.itemIndex, 0);
      expect(r.phase, ItemPhase.answer);

      clock.elapse(const Duration(milliseconds: 500));
      s.answer(right);
      r = running(s);
      expect(r.itemIndex, 0);
      expect(r.phase, ItemPhase.answered);
      expect(r.awaitsNext, isFalse);
      expect(r.feedback, isNull);
      expect(s.outcomes.single.responseMs, 1500);

      // next() has no effect under a cadence; the window does.
      s.next();
      expect(running(s).itemIndex, 0);
      clock.elapse(const Duration(milliseconds: 999));
      expect(running(s).itemIndex, 0);
      clock.elapse(const Duration(milliseconds: 1));
      r = running(s);
      expect(r.itemIndex, 1);
      expect(r.phase, ItemPhase.stimulus);
      expect(r.itemStartedAt, start.add(const Duration(milliseconds: 2500)));
    });

    test('a missing answer is a timeout and the rhythm never slips', () {
      final s = session(config(mode: SessionMode.exam, timing: timing));
      s.start();
      clock.elapse(const Duration(milliseconds: 2500));
      expect(running(s).itemIndex, 1);
      expect(s.outcomes.single.isTimeout, isTrue);
      expect(s.outcomes.single.responseMs, 2500);
      clock.elapse(const Duration(milliseconds: 5000));
      final f = finished(s);
      expect(f.result.section.timeouts, 3);
      expect(clock.now(), start.add(const Duration(milliseconds: 7500)));
    });

    test('answers during the stimulus are accepted and shown in practice', () {
      final s = session(config(timing: timing));
      s.start();
      clock.elapse(const Duration(milliseconds: 300));
      s.answer(wrong);
      var r = running(s);
      expect(r.phase, ItemPhase.answered);
      expect(r.feedback, ItemResult.wrong);
      expect(r.awaitsNext, isFalse);
      // The stimulus timer no longer flips the phase back.
      clock.elapse(const Duration(milliseconds: 1000));
      r = running(s);
      expect(r.itemIndex, 0);
      expect(r.phase, ItemPhase.answered);
      clock.elapse(const Duration(milliseconds: 1200));
      expect(running(s).itemIndex, 1);
    });

    test('runs under fakeAsync with the system clock', () {
      fakeAsync((async) {
        final sysClock = SystemClock(now: async.getClock(start).now);
        final memory = InMemoryProgressRepository(clock: sysClock.now);
        final s = session(
          config(mode: SessionMode.exam, timing: timing, items: 2),
          repository: memory,
          withClock: sysClock,
        );
        s.start();
        expect(running(s).phase, ItemPhase.stimulus);
        async.elapse(const Duration(milliseconds: 1000));
        expect(running(s).phase, ItemPhase.answer);
        async.elapse(const Duration(milliseconds: 200));
        s.answer(right);
        expect(s.outcomes.single.responseMs, 1200);
        async.elapse(const Duration(milliseconds: 1300));
        expect(running(s).itemIndex, 1);
        async.elapse(const Duration(milliseconds: 2500));
        expect(finished(s).result.section.correct, 1);
        expect(finished(s).result.section.timeouts, 1);
        async.flushMicrotasks();
        expect(memory.attempts, hasLength(2));
        expect(
          memory.sessionsById.values.single.status,
          SessionStatus.completed,
        );
      });
    });
  });

  group('section limit', () {
    test('ends the section, recording the open item as a timeout', () async {
      final s = session(
        config(
          mode: SessionMode.exam,
          items: 5,
          timing: const TimingPolicy(sectionMs: 10000),
        ),
      );
      s.start();
      expect(
        running(s).sectionDeadline,
        start.add(const Duration(seconds: 10)),
      );
      expect(
        running(s).sectionRemaining(start.add(const Duration(seconds: 1))),
        const Duration(seconds: 9),
      );
      clock.elapse(const Duration(seconds: 3));
      s.answer(right);
      clock.elapse(const Duration(seconds: 7));
      final f = finished(s);
      expect(f.result.reason, FinishReason.sectionTimeout);
      expect(f.result.section.played, 2);
      expect(f.result.section.unplayed, 3);
      expect(f.result.section.timeouts, 1);
      expect(s.outcomes.last.responseMs, 7000);
      await s.idle;
      expect(repo.sessionsById['session-1']!.status, SessionStatus.completed);
      expect(repo.attempts, hasLength(2));
    });

    test('an answered item awaiting next is not recorded twice', () {
      final s = session(
        config(items: 2, timing: const TimingPolicy(sectionMs: 5000)),
      );
      s.start();
      s.answer(right);
      clock.elapse(const Duration(seconds: 5));
      expect(finished(s).result.reason, FinishReason.sectionTimeout);
      expect(s.outcomes, hasLength(1));
    });
  });

  group('pause and resume', () {
    const timing = TimingPolicy(perItemMs: 10000, sectionMs: 60000);

    test('freezes the timers and excludes paused time from response times', () {
      final s = session(config(timing: timing));
      s.start();
      clock.elapse(const Duration(seconds: 3));
      s.pause();
      final p = s.state as ActivityPaused;
      expect(p.itemRemaining, const Duration(seconds: 7));
      expect(p.sectionRemaining, const Duration(seconds: 57));
      expect(p.snapshot.itemIndex, 0);
      expect(s.state.running, same(p.snapshot));
      expect(s.state.isPaused, isTrue);

      // Nothing fires while paused; answers and pause are ignored.
      clock.elapse(const Duration(seconds: 30));
      expect(s.state.isPaused, isTrue);
      s.answer(right);
      expect(s.outcomes, isEmpty);
      s.pause();
      expect(s.state.isPaused, isTrue);

      s.resume();
      final r = running(s);
      expect(r.itemDeadline, clock.now().add(const Duration(seconds: 7)));
      expect(r.sectionDeadline, clock.now().add(const Duration(seconds: 57)));
      s.resume();
      expect(s.state.isRunning, isTrue);

      clock.elapse(const Duration(seconds: 2));
      s.answer(right);
      expect(s.outcomes.single.responseMs, 5000);
    });

    test('a paused item times out after its remaining time', () {
      final s = session(config(timing: timing));
      s.start();
      clock.elapse(const Duration(seconds: 3));
      s.pause();
      clock.elapse(const Duration(hours: 1));
      s.resume();
      clock.elapse(const Duration(seconds: 6));
      expect(s.outcomes, isEmpty);
      clock.elapse(const Duration(seconds: 1));
      expect(s.outcomes.single.isTimeout, isTrue);
      expect(s.outcomes.single.responseMs, 10000);
    });

    test('pausing during a stimulus keeps the cadence phases', () {
      final s = session(config(timing: const TimingPolicy(cadence: cadence)));
      s.start();
      clock.elapse(const Duration(milliseconds: 400));
      s.pause();
      clock.elapse(const Duration(seconds: 10));
      s.resume();
      expect(running(s).phase, ItemPhase.stimulus);
      clock.elapse(const Duration(milliseconds: 600));
      expect(running(s).phase, ItemPhase.answer);
      clock.elapse(const Duration(milliseconds: 1500));
      expect(running(s).itemIndex, 1);
      expect(s.outcomes.single.isTimeout, isTrue);
    });

    test('pausing on feedback resumes without an item timer', () {
      final s = session(config(timing: timing));
      s.start();
      s.answer(right);
      s.pause();
      s.resume();
      expect(running(s).awaitsNext, isTrue);
      expect(running(s).itemDeadline, isNull);
      clock.elapse(const Duration(seconds: 20));
      expect(s.outcomes, hasLength(1));
      s.next();
      expect(running(s).itemIndex, 1);
    });

    test('pause is ignored in briefing and once finished', () {
      final s = session(config(items: 1));
      s.pause();
      expect(s.state.isBriefing, isTrue);
      s.start();
      s.answer(right);
      s.next();
      s.pause();
      expect(s.state.isFinished, isTrue);
      s.resume();
      expect(s.state.isFinished, isTrue);
    });
  });

  group('abort', () {
    test('finishes as aborted and abandons the stored session', () async {
      final s = session(config(timing: const TimingPolicy(perItemMs: 5000)));
      s.start();
      s.answer(right);
      s.next();
      s.abort();
      final f = finished(s);
      expect(f.result.reason, FinishReason.aborted);
      expect(f.result.isAborted, isTrue);
      expect(f.result.section.played, 1);
      expect(clock.pendingTasks, 0);
      await s.idle;
      expect(repo.sessionsById['session-1']!.status, SessionStatus.abandoned);
      expect(repo.attempts, hasLength(1));

      // Terminal: further commands are ignored.
      s.abort();
      s.answer(right);
      s.next();
      expect(s.state, same(f));
    });

    test('aborting the briefing never touches the repository', () async {
      final s = session(config());
      s.abort();
      expect(finished(s).result.section.played, 0);
      await s.idle;
      expect(repo.sessionsById, isEmpty);
    });

    test('works while paused', () async {
      final s = session(config());
      s.start();
      s.pause();
      s.abort();
      expect(finished(s).result.reason, FinishReason.aborted);
      await s.idle;
      expect(repo.sessionsById['session-1']!.status, SessionStatus.abandoned);
    });
  });

  group('generator source', () {
    test('records origins instead of item ids', () async {
      final s = session(
        config(
          mode: SessionMode.exam,
          source: const ItemSource.generator(
            generatorId: GeneratorId.dominos,
            seed: 99,
            params: GeneratorParams.dominos(),
            count: 2,
          ),
        ),
      );
      s.start();
      s.answer(right);
      s.answer(right);
      await s.idle;
      for (final attempt in repo.attempts) {
        expect(attempt.itemId, isNull);
        expect(attempt.origin!.generatorId, 'dominos');
        expect(attempt.isGenerated, isTrue);
      }
      expect(repo.itemStatsById, isEmpty);
    });
  });

  group('scoring policy', () {
    test('is applied to the section result', () {
      final s = session(
        config(
          mode: SessionMode.exam,
          scoringPolicy: const ScoringPolicy(correct: 3, wrong: -1),
        ),
      );
      s.start();
      s.answer(right);
      s.answer(wrong);
      s.answer(const Answer.skip());
      final section = finished(s).result.section;
      expect(section.points, 2);
      expect(section.maxPoints, 9);
      expect(section.skipped, 1);
    });
  });

  group('resume after a crash', () {
    test('restores the outcomes and continues at the next item', () async {
      final first = session(
        config(items: 4, timing: const TimingPolicy(sectionMs: 20000)),
      );
      first.start();
      clock.elapse(const Duration(seconds: 2));
      first.answer(right);
      first.next();
      clock.elapse(const Duration(seconds: 1));
      first.answer(wrong);
      first.next();
      await first.idle;
      first.dispose(); // the app died here

      final stored = repo.sessionsById['session-1']!;
      final attempts = await repo.attemptsForSession(stored.id);
      final resumed = ActivitySession.resume(
        session: stored,
        attempts: attempts,
        registry: registry,
        repository: repo,
        clock: clock,
      );
      addTearDown(resumed.dispose);
      expect(
        resumed.state,
        const ActivitySessionState.briefing(itemCount: 4, startIndex: 2),
      );
      expect(resumed.sessionId, 'session-1');
      expect(resumed.config.ownsSession, isTrue);
      expect(resumed.outcomes.map((o) => o.isCorrect), [true, false]);
      expect(resumed.outcomes.map((o) => o.responseMs), [2000, 1000]);
      expect(resumed.outcomes.map((o) => o.item.id), ['q1', 'q2']);

      resumed.start();
      final r = running(resumed);
      expect(r.itemIndex, 2);
      expect(r.sectionDeadline, clock.now().add(const Duration(seconds: 17)));
      resumed.answer(right);
      resumed.next();
      resumed.answer(right);
      resumed.next();
      final f = finished(resumed);
      expect(f.result.section.played, 4);
      expect(f.result.section.correct, 3);
      await resumed.idle;
      expect(repo.sessionsById, hasLength(1));
      expect(repo.sessionsById['session-1']!.status, SessionStatus.completed);
      expect(repo.attempts.map((a) => a.position), [0, 1, 2, 3]);
    });

    test('restores a timeout attempt as a timeout outcome', () async {
      final first = session(
        config(
          mode: SessionMode.exam,
          items: 2,
          timing: const TimingPolicy(perItemMs: 1000),
        ),
      );
      first.start();
      clock.elapse(const Duration(seconds: 1));
      await first.idle;
      final stored = repo.sessionsById['session-1']!;
      final resumed = ActivitySession.resume(
        session: stored,
        attempts: await repo.attemptsForSession(stored.id),
        registry: registry,
        repository: repo,
        clock: clock,
      );
      addTearDown(resumed.dispose);
      expect(resumed.outcomes.single.isTimeout, isTrue);
      expect(resumed.outcomes.single.answer, const Answer.timeout());
    });

    test(
      'only restores the attempts of its own exam section, in order',
      () async {
        final owner = await repo.startSession(mode: SessionMode.exam);
        await repo.recordAttempts([
          NewAttempt(
            sessionId: owner.id,
            familyId: 'other',
            isCorrect: true,
            responseMs: 1,
            position: 0,
            itemId: 'o1',
            sectionIndex: 0,
          ),
          NewAttempt(
            sessionId: owner.id,
            familyId: 'fake_family',
            isCorrect: false,
            responseMs: 1,
            position: 2,
            itemId: 'q2',
            sectionIndex: 1,
          ),
          NewAttempt(
            sessionId: owner.id,
            familyId: 'fake_family',
            isCorrect: true,
            responseMs: 1,
            position: 1,
            itemId: 'q1',
            sectionIndex: 1,
          ),
          NewAttempt(
            sessionId: owner.id,
            familyId: 'fake_family',
            isCorrect: true,
            responseMs: 1,
            position: 9,
            itemId: 'zz',
            sectionIndex: 1,
          ),
        ]);
        final cfg = config(
          mode: SessionMode.exam,
          sectionIndex: 1,
          positionOffset: 1,
          ownsSession: false,
        );
        final stored = owner.copyWith(config: cfg.toJson());
        final resumed = ActivitySession.resume(
          session: stored,
          attempts: await repo.attemptsForSession(owner.id),
          registry: registry,
          repository: repo,
          clock: clock,
        );
        addTearDown(resumed.dispose);
        expect(resumed.outcomes.map((o) => o.index), [0, 1]);
        expect(resumed.outcomes.map((o) => o.isCorrect), [true, false]);
        resumed.start();
        expect(running(resumed).itemIndex, 2);
      },
    );

    test('a fully played session finishes on start', () async {
      final first = session(config(mode: SessionMode.exam, items: 1));
      first.start();
      first.answer(right);
      await first.idle;
      final stored = repo.sessionsById['session-1']!;
      final resumed = ActivitySession.resume(
        session: stored,
        attempts: await repo.attemptsForSession(stored.id),
        registry: registry,
        repository: repo,
        clock: clock,
      );
      addTearDown(resumed.dispose);
      resumed.start();
      expect(finished(resumed).result.reason, FinishReason.completed);
    });

    test('rejects a session without a stored config', () async {
      final bare = await repo.startSession(mode: SessionMode.practice);
      expect(
        () => ActivitySession.resume(
          session: bare,
          attempts: const [],
          registry: registry,
          repository: repo,
        ),
        throwsArgumentError,
      );
    });
  });

  group('persistence', () {
    test('reports write failures and keeps running', () async {
      final errors = <Object>[];
      final failing = _FailingRepository(clock: clock.now);
      final s = session(
        config(mode: SessionMode.exam, items: 2),
        repository: failing,
        onPersistenceError: (e, _) => errors.add(e),
      );
      s.start();
      s.answer(right);
      s.answer(right);
      await s.idle;
      expect(errors, hasLength(2));
      expect(s.state.isFinished, isTrue);
      expect(
        failing.sessionsById.values.single.status,
        SessionStatus.completed,
      );
    });

    test('an unknown family fails fast', () {
      expect(
        () => ActivitySession(
          config: config().copyWith(familyId: 'unknown'),
          registry: registry,
          repository: repo,
        ),
        throwsA(isA<EngineNotFoundError>()),
      );
    });

    test('dispose closes the stream and cancels timers', () async {
      final s = session(config(timing: const TimingPolicy(perItemMs: 1000)));
      s.start();
      s.dispose();
      expect(clock.pendingTasks, 0);
      s.answer(right);
      expect(s.outcomes, isEmpty);
      s.dispose();
      await expectLater(s.states, emitsDone);
    });
  });

  group('run-scoped generation (US-037)', () {
    ActivitySessionConfig nbackConfig({int count = 4, int seed = 555}) =>
        ActivitySessionConfig(
          familyId: 'memory_nback',
          mode: SessionMode.practice,
          source: ItemSource.generator(
            generatorId: GeneratorId.nback,
            seed: seed,
            params: const NbackParams(n: 1, count: 4),
            count: count,
          ),
        );

    ActivitySession nbackSession(ActivitySessionConfig config) {
      final s = ActivitySession(
        config: config,
        registry: EngineRegistry(const [NbackEngine()]),
        repository: repo,
        clock: clock,
      );
      addTearDown(s.dispose);
      return s;
    }

    test('runSeed is identical for every item and index matches position', () {
      final s = nbackSession(nbackConfig());
      final origins = [
        for (final item in s.items) (item.item as GeneratedItem).origin!,
      ];
      expect(origins.map((o) => o.runSeed).toSet(), {555});
      expect(origins.map((o) => o.index), [0, 1, 2, 3]);
    });

    test('the same runSeed reproduces identical items across a fresh session '
        'and a resumed one', () async {
      final generatorConfig = nbackConfig();
      final fresh = nbackSession(generatorConfig);
      final freshItems = fresh.items.map((s) => s.item).toList();

      // A resumed session rebuilds its config from what the runtime
      // stored (`ActivitySessionConfig.toJson()`), exactly as a real
      // crash recovery does (see `ActivitySession.resume`).
      final stored = await repo.startSession(
        mode: generatorConfig.mode,
        familyId: generatorConfig.familyId,
        config: generatorConfig.toJson(),
        startedAt: clock.now(),
      );
      final resumed = ActivitySession.resume(
        session: stored,
        attempts: const [],
        registry: EngineRegistry(const [NbackEngine()]),
        repository: repo,
        clock: clock,
      );
      addTearDown(resumed.dispose);

      expect(resumed.items.map((s) => s.item).toList(), freshItems);
    });
  });
}
