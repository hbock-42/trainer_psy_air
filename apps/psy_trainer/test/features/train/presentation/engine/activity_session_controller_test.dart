import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_version_provider.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../../helpers/fake_engine.dart';

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository repo;
  late ProviderContainer container;

  setUp(() {
    clock = ManualClock(start);
    repo = InMemoryProgressRepository(clock: clock.now);
    container = ProviderContainer.test(
      overrides: [
        progressRepositoryProvider.overrideWithValue(repo),
        engineRegistryProvider.overrideWithValue(
          EngineRegistry([FakeEngine()]),
        ),
        engineClockProvider.overrideWithValue(clock),
      ],
    );
  });

  ActivitySessionConfig config({
    SessionMode mode = SessionMode.practice,
    int items = 2,
    TimingPolicy timing = TimingPolicy.none,
  }) => ActivitySessionConfig(
    familyId: 'fake_family',
    mode: mode,
    source: ItemSource.bank(fakeBank(items)),
    timing: timing,
  );

  test(
    'runs a practice session end to end and bumps the progress version',
    () async {
      final request = ActivitySessionRequest.fresh(config());
      final provider = activitySessionControllerProvider(request);
      final states = <ActivitySessionState>[];
      container.listen(
        provider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      final controller = container.read(provider.notifier);
      expect(controller.config, config());
      expect(controller.session.items, hasLength(2));
      expect(states.single, isA<ActivityBriefing>());
      expect(container.read(progressVersionProvider), 0);

      controller.start();
      expect(container.read(provider), isA<ActivityRunning>());
      controller.answer(const Answer.choice(0));
      expect((container.read(provider) as ActivityRunning).awaitsNext, isTrue);
      controller.next();
      controller.answer(const Answer.choice(2));
      controller.next();
      final finished = container.read(provider) as ActivityFinished;
      expect(finished.result.reason, FinishReason.completed);
      expect(finished.result.section.correct, 1);

      await controller.idle;
      await Future<void>.delayed(Duration.zero);
      expect(container.read(progressVersionProvider), 1);
      expect(repo.sessionsById.values.single.status, SessionStatus.completed);
      expect(repo.attempts, hasLength(2));
      expect(states, hasLength(6));
    },
  );

  test('pause, resume and abort are forwarded', () async {
    final provider = activitySessionControllerProvider(
      ActivitySessionRequest.fresh(
        config(timing: const TimingPolicy(perItemMs: 5000)),
      ),
    );
    final controller = container.read(provider.notifier);
    controller.start();
    controller.pause();
    expect(container.read(provider), isA<ActivityPaused>());
    controller.resume();
    expect(container.read(provider), isA<ActivityRunning>());
    controller.abort();
    expect(
      (container.read(provider) as ActivityFinished).result.reason,
      FinishReason.aborted,
    );
    await controller.idle;
    expect(repo.sessionsById.values.single.status, SessionStatus.abandoned);
  });

  test('timers run against the injected clock', () {
    final provider = activitySessionControllerProvider(
      ActivitySessionRequest.fresh(
        config(
          mode: SessionMode.exam,
          timing: const TimingPolicy(perItemMs: 3000),
        ),
      ),
    );
    final controller = container.read(provider.notifier);
    controller.start();
    clock.elapse(const Duration(seconds: 3));
    expect((container.read(provider) as ActivityRunning).itemIndex, 1);
    clock.elapse(const Duration(seconds: 3));
    expect(container.read(provider), isA<ActivityFinished>());
    expect(controller.session.outcomes.every((o) => o.isTimeout), isTrue);
  });

  test(
    'disposing a running controller aborts and abandons the session',
    () async {
      final provider = activitySessionControllerProvider(
        ActivitySessionRequest.fresh(config()),
      );
      final sub = container.listen(provider, (_, _) {});
      final controller = container.read(provider.notifier);
      controller.start();
      controller.answer(const Answer.choice(0));
      final session = controller.session;
      sub.close();
      await Future<void>.delayed(Duration.zero);
      await session.idle;
      await Future<void>.delayed(Duration.zero);
      expect(session.state.isFinished, isTrue);
      expect(repo.sessionsById.values.single.status, SessionStatus.abandoned);
      expect(repo.attempts, hasLength(1));
      expect(container.read(progressVersionProvider), 1);
    },
  );

  test('resumes an interrupted session from the repository', () async {
    final first = activitySessionControllerProvider(
      ActivitySessionRequest.fresh(config(items: 3)),
    );
    final sub = container.listen(first, (_, _) {});
    final controller = container.read(first.notifier);
    controller.start();
    controller.answer(const Answer.choice(0));
    controller.next();
    await controller.idle;
    // Simulate a crash: the session object goes away without abort().
    controller.session.dispose();
    sub.close();

    final stored = repo.sessionsById.values.single;
    expect(stored.status, SessionStatus.inProgress);
    final resumed = activitySessionControllerProvider(
      ActivitySessionRequest.resume(
        session: stored,
        attempts: await repo.attemptsForSession(stored.id),
      ),
    );
    container.listen(resumed, (_, _) {});
    final resumedController = container.read(resumed.notifier);
    expect(
      container.read(resumed),
      const ActivitySessionState.briefing(itemCount: 3, startIndex: 1),
    );
    resumedController.start();
    expect((container.read(resumed) as ActivityRunning).itemIndex, 1);
    resumedController.answer(const Answer.choice(0));
    resumedController.next();
    resumedController.answer(const Answer.choice(0));
    resumedController.next();
    await resumedController.idle;
    expect(repo.sessionsById.values.single.status, SessionStatus.completed);
    expect(repo.attempts.map((a) => a.position), [0, 1, 2]);
  });

  test(
    'the default providers build over a system clock, unregistered families '
    'unknown',
    () {
      // Not asserted empty: `engineRegistryProvider` /
      // `rendererRegistryProvider` accumulate one line per EPIC-03 engine
      // story (ARCHITECTURE.md "Engine", step 4), so this only checks that
      // building the real registries doesn't throw and that a family nobody
      // registered still reports as such.
      final fresh = ProviderContainer.test();
      expect(
        fresh.read(rendererRegistryProvider).hasFamily('no-such-family'),
        isFalse,
      );
      expect(
        fresh.read(engineRegistryProvider).hasFamily('no-such-family'),
        isFalse,
      );
      expect(fresh.read(engineClockProvider), isA<SystemClock>());
    },
  );
}
