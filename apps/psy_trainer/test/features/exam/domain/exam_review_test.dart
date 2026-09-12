import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/domain/exam_review.dart';
import 'package:psy_trainer/features/progress/domain/stats_service.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';

import '../../../helpers/fake_engine.dart';

void main() {
  late InMemoryProgressRepository progress;
  late ActivitySessionConfig configA;
  late ActivitySessionConfig configB;

  setUp(() {
    progress = InMemoryProgressRepository(clock: () => DateTime.utc(2026, 9));
    configA = ActivitySessionConfig(
      familyId: 'fam_a',
      mode: SessionMode.exam,
      source: ItemSource.bank(fakeBank(2, familyId: 'fam_a')),
      blueprintId: 'bp.test',
      sectionIndex: 0,
    );
    configB = ActivitySessionConfig(
      familyId: 'fam_b',
      mode: SessionMode.exam,
      source: ItemSource.bank(fakeBank(2, familyId: 'fam_b')),
      blueprintId: 'bp.test',
      sectionIndex: 1,
      positionOffset: 2,
    );
  });

  Future<TrainingSession> seedSession() async {
    final started = await progress.startSession(
      mode: SessionMode.exam,
      blueprintId: 'bp.test',
      config: {
        'sections': [configA.toJson(), configB.toJson()],
      },
    );
    await progress.recordAttempts([
      NewAttempt(
        sessionId: started.id,
        familyId: 'fam_a',
        isCorrect: true,
        responseMs: 500,
        position: 0,
        sectionIndex: 0,
        itemId: 'q1',
        answer: const Answer.choice(0).toJson(),
      ),
      NewAttempt(
        sessionId: started.id,
        familyId: 'fam_a',
        isCorrect: false,
        responseMs: 800,
        position: 1,
        sectionIndex: 0,
        itemId: 'q2',
        answer: const Answer.choice(1).toJson(),
      ),
      NewAttempt(
        sessionId: started.id,
        familyId: 'fam_b',
        isCorrect: true,
        responseMs: 300,
        position: 2,
        sectionIndex: 1,
        itemId: 'q1',
        answer: const Answer.choice(0).toJson(),
      ),
      NewAttempt(
        sessionId: started.id,
        familyId: 'fam_b',
        isCorrect: false,
        responseMs: 0,
        position: 3,
        sectionIndex: 1,
        itemId: 'q2',
      ),
    ]);
    await progress.finishSession(
      started.id,
      status: SessionStatus.completed,
      score: 0.5,
    );
    return (await progress.sessionById(started.id))!;
  }

  test('rebuilds the item-by-item review from persisted attempts', () async {
    final session = await seedSession();
    final attempts = await progress.attemptsForSession(session.id);
    final engines = EngineRegistry([
      FakeEngine(familyId: 'fam_a'),
      FakeEngine(familyId: 'fam_b', generatorId: GeneratorId.tubes),
    ]);

    final review = buildExamReview(
      session: session,
      attempts: attempts,
      engines: engines,
    );

    expect(review, hasLength(2));
    final sectionA = review.firstWhere((s) => s.sectionIndex == 0);
    expect(sectionA.familyId, 'fam_a');
    expect(sectionA.outcomes, hasLength(2));
    expect(sectionA.outcomes[0].item.id, 'q1');
    expect(sectionA.outcomes[0].isCorrect, isTrue);
    expect(sectionA.outcomes[0].answer, const Answer.choice(0));
    expect(sectionA.outcomes[0].responseMs, 500);
    expect(sectionA.outcomes[1].isCorrect, isFalse);
    expect(sectionA.outcomes[1].isTimeout, isFalse);

    final sectionB = review.firstWhere((s) => s.sectionIndex == 1);
    expect(sectionB.familyId, 'fam_b');
    // position 3 - positionOffset 2 = local index 1, the timed-out item.
    final timedOut = sectionB.outcomes.firstWhere((o) => o.index == 1);
    expect(timedOut.isTimeout, isTrue);
    expect(timedOut.answer, const Answer.timeout());
  });

  test('omits a section whose engine is no longer registered', () async {
    final session = await seedSession();
    final attempts = await progress.attemptsForSession(session.id);
    final review = buildExamReview(
      session: session,
      attempts: attempts,
      engines: EngineRegistry([FakeEngine(familyId: 'fam_a')]),
    );
    expect(review, hasLength(1));
    expect(review.single.familyId, 'fam_a');
  });

  test('per-section and global score match the fixture attempts', () async {
    final session = await seedSession();
    final rows = await progress.sessionFamilyStats(mode: SessionMode.exam);
    const blueprint = ExamBlueprint(
      id: 'bp.test',
      version: 1,
      moduleId: ModuleId.psy0,
      name: LocalizedText(fr: 'Test'),
      description: LocalizedText(fr: 'Test'),
      confidence: Confidence.assumed,
      tags: [],
      sections: [
        ExamSection(
          id: 's0',
          familyId: 'fam_a',
          itemCount: 2,
          itemSelection: ItemSelection.bank(),
          confidence: Confidence.assumed,
        ),
        ExamSection(
          id: 's1',
          familyId: 'fam_b',
          itemCount: 2,
          itemSelection: ItemSelection.bank(),
          confidence: Confidence.assumed,
        ),
      ],
    );

    final summary = const StatsService().examSummary(
      session: session,
      rows: rows,
      blueprint: blueprint,
    );

    expect(summary.sections, hasLength(2));
    final sectionA = summary.sections[0];
    expect(sectionA.attempts, 2);
    expect(sectionA.correct, 1);
    expect(sectionA.accuracy, 0.5);
    final sectionB = summary.sections[1];
    expect(sectionB.attempts, 2);
    expect(sectionB.correct, 1);
    expect(sectionB.unanswered, 1);
    expect(summary.score, 0.5);
    expect(summary.percent, 50);
  });
}
