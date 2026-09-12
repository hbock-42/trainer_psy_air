import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/presentation/exam_run_controller.dart';
import 'package:psy_trainer/features/exam/presentation/exam_run_state.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_ui.dart';

import '../../../helpers/fake_engine.dart';

extension on ActivitySessionRequest {
  ActivitySessionConfig get config => switch (this) {
    FreshSessionRequest(:final config) => config,
    ResumeSessionRequest() => throw StateError(
      'unexpected resume request in this test',
    ),
  };
}

ExamSection _section({
  required String id,
  required String familyId,
  required GeneratorId generatorId,
  int itemCount = 2,
  int breakAfterSec = 0,
}) => ExamSection(
  id: id,
  familyId: familyId,
  itemCount: itemCount,
  itemSelection: ItemSelection.generated(
    generatorId: generatorId,
    difficulty: const DifficultyRange(min: 3, max: 3),
    params: GeneratorParams.defaultsFor(generatorId),
  ),
  confidence: Confidence.assumed,
  breakAfterSec: breakAfterSec,
);

ExamBlueprint _blueprint(List<ExamSection> sections, {String id = 'bp.test'}) =>
    ExamBlueprint(
      id: id,
      version: 1,
      moduleId: ModuleId.psy0,
      name: const LocalizedText(fr: 'Test'),
      description: const LocalizedText(fr: 'Test'),
      confidence: Confidence.assumed,
      tags: const [],
      sections: sections,
    );

Future<void> _pump() async {
  for (var i = 0; i < 20; i++) {
    await Future<void>.delayed(Duration.zero);
  }
}

void main() {
  final start = DateTime.utc(2026, 9, 5, 9);
  late ManualClock clock;
  late InMemoryProgressRepository progress;
  late ProviderContainer container;

  ProviderContainer buildContainer(
    ExamBlueprint blueprint, {
    List<ActivityEngine>? engineList,
  }) {
    clock = ManualClock(start);
    progress = InMemoryProgressRepository(clock: clock.now);
    return ProviderContainer.test(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          InMemoryContentRepository(blueprints: [blueprint]),
        ),
        progressRepositoryProvider.overrideWithValue(progress),
        engineRegistryProvider.overrideWithValue(
          EngineRegistry(
            engineList ??
                [
                  FakeEngine(familyId: 'fam_a'),
                  FakeEngine(familyId: 'fam_b', generatorId: GeneratorId.tubes),
                ],
          ),
        ),
        engineClockProvider.overrideWithValue(clock),
      ],
    );
  }

  /// Drives the currently-running section to completion (every answer
  /// correct) exactly as `ExamRunScreen` does: run `SessionHost`'s
  /// controller, then hand its result to the exam controller.
  Future<void> completeRunningSection(String blueprintId) async {
    final examProvider = examRunControllerProvider(blueprintId);
    final running = container.read(examProvider) as ExamRunRunning;
    final sessionProvider = activitySessionControllerProvider(running.request);
    final sessionController = container.read(sessionProvider.notifier);
    sessionController.start();
    final itemCount =
        (container.read(sessionProvider) as ActivityRunning).itemCount;
    for (var i = 0; i < itemCount; i++) {
      sessionController.answer(const Answer.choice(0));
    }
    final finished = container.read(sessionProvider) as ActivityFinished;
    await container
        .read(examProvider.notifier)
        .handleSectionFinished(finished.result);
    await _pump();
  }

  test('briefing -> section -> break -> section -> done, persisting every '
      'attempt with the right position and section index', () async {
    final blueprint = _blueprint([
      _section(
        id: 's0',
        familyId: 'fam_a',
        generatorId: GeneratorId.dominos,
        breakAfterSec: 5,
      ),
      _section(id: 's1', familyId: 'fam_b', generatorId: GeneratorId.tubes),
    ]);
    container = buildContainer(blueprint);
    final provider = examRunControllerProvider(blueprint.id);
    final states = <ExamRunState>[];
    container.listen(
      provider,
      (_, next) => states.add(next),
      fireImmediately: true,
    );
    await _pump();

    final running0 = container.read(provider) as ExamRunRunning;
    expect(running0.planIndex, 0);
    expect(running0.totalSections, 2);

    await completeRunningSection(blueprint.id);
    expect(container.read(provider), isA<ExamRunOnBreak>());
    final onBreak = container.read(provider) as ExamRunOnBreak;
    expect(onBreak.nextPlanIndex, 1);

    clock.elapse(const Duration(seconds: 5));
    final running1 = container.read(provider) as ExamRunRunning;
    expect(running1.planIndex, 1);

    await completeRunningSection(blueprint.id);
    expect(container.read(provider), isA<ExamRunDone>());

    final session = progress.sessionsById.values.single;
    expect(session.status, SessionStatus.completed);
    expect(session.score, 1.0);
    expect(progress.attempts, hasLength(4));
    final bySection = <int, List<Attempt>>{};
    for (final a in progress.attempts) {
      bySection.putIfAbsent(a.sectionIndex!, () => []).add(a);
    }
    expect(bySection[0]!.map((a) => a.position).toList(), [0, 1]);
    expect(bySection[1]!.map((a) => a.position).toList(), [2, 3]);
  });

  test('a section ending aborted abandons the whole exam', () async {
    final blueprint = _blueprint([
      _section(id: 's0', familyId: 'fam_a', generatorId: GeneratorId.dominos),
      _section(id: 's1', familyId: 'fam_b', generatorId: GeneratorId.tubes),
    ]);
    container = buildContainer(blueprint);
    final provider = examRunControllerProvider(blueprint.id);
    container.listen(provider, (_, _) {}, fireImmediately: true);
    await _pump();

    final running = container.read(provider) as ExamRunRunning;
    final sessionProvider = activitySessionControllerProvider(running.request);
    final sessionController = container.read(sessionProvider.notifier);
    sessionController.start();
    sessionController.answer(const Answer.choice(0));
    sessionController.abort();
    final finished = container.read(sessionProvider) as ActivityFinished;
    expect(finished.result.reason, FinishReason.aborted);

    await container
        .read(provider.notifier)
        .handleSectionFinished(finished.result);
    expect(container.read(provider), isA<ExamRunAborted>());
    expect(progress.sessionsById.values.single.status, SessionStatus.abandoned);
  });

  test('a section whose engine is not registered is skipped', () async {
    final blueprint = _blueprint([
      _section(id: 's0', familyId: 'fam_a', generatorId: GeneratorId.dominos),
      _section(
        id: 's1',
        familyId: 'missing_family',
        generatorId: GeneratorId.paritySequence,
      ),
      _section(id: 's2', familyId: 'fam_b', generatorId: GeneratorId.tubes),
    ]);
    container = buildContainer(blueprint);
    final provider = examRunControllerProvider(blueprint.id);
    container.listen(provider, (_, _) {}, fireImmediately: true);
    await _pump();

    final running0 = container.read(provider) as ExamRunRunning;
    expect(running0.totalSections, 2);
    expect(running0.request.config.familyId, 'fam_a');

    await completeRunningSection(blueprint.id);
    final running1 = container.read(provider) as ExamRunRunning;
    expect(running1.planIndex, 1);
    expect(running1.request.config.familyId, 'fam_b');
    expect(running1.request.config.sectionIndex, 2);

    await completeRunningSection(blueprint.id);
    expect(container.read(provider), isA<ExamRunDone>());
  });

  test(
    'a blueprint with no available section is reported unavailable',
    () async {
      final blueprint = _blueprint([
        _section(
          id: 's0',
          familyId: 'missing_family',
          generatorId: GeneratorId.dominos,
        ),
      ]);
      container = buildContainer(
        blueprint,
        engineList: [FakeEngine(familyId: 'fam_a')],
      );
      final provider = examRunControllerProvider(blueprint.id);
      container.listen(provider, (_, _) {}, fireImmediately: true);
      await _pump();
      expect(container.read(provider), isA<ExamRunUnavailable>());
    },
  );
}
