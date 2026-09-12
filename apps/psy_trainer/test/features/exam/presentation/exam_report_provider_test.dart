import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_report_provider.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';

import '../../../helpers/fake_engine.dart';

void main() {
  test('computes global and per-section score, and the delta against the '
      'previous completed simulation of the same blueprint', () async {
    final progress = InMemoryProgressRepository(
      clock: () => DateTime.utc(2026, 9, 10),
    );
    final content = InMemoryContentRepository();

    final configA = ActivitySessionConfig(
      familyId: 'fam_a',
      mode: SessionMode.exam,
      source: ItemSource.bank(fakeBank(2, familyId: 'fam_a')),
      blueprintId: 'bp.test',
      sectionIndex: 0,
    );

    Future<String> runExam({
      required DateTime startedAt,
      required bool firstCorrect,
      required bool secondCorrect,
    }) async {
      final started = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: startedAt,
        config: {
          'sections': [configA.toJson()],
        },
      );
      await progress.recordAttempts([
        NewAttempt(
          sessionId: started.id,
          familyId: 'fam_a',
          isCorrect: firstCorrect,
          responseMs: 500,
          position: 0,
          sectionIndex: 0,
          itemId: 'q1',
          answer: const Answer.choice(0).toJson(),
        ),
        NewAttempt(
          sessionId: started.id,
          familyId: 'fam_a',
          isCorrect: secondCorrect,
          responseMs: 500,
          position: 1,
          sectionIndex: 0,
          itemId: 'q2',
          answer: const Answer.choice(0).toJson(),
        ),
      ]);
      await progress.finishSession(
        started.id,
        status: SessionStatus.completed,
        endedAt: startedAt.add(const Duration(minutes: 5)),
      );
      return started.id;
    }

    // First simulation: 0/2 correct.
    await runExam(
      startedAt: DateTime.utc(2026, 9),
      firstCorrect: false,
      secondCorrect: false,
    );
    // Second (latest) simulation: 2/2 correct.
    final latestId = await runExam(
      startedAt: DateTime.utc(2026, 9, 5),
      firstCorrect: true,
      secondCorrect: true,
    );

    final container = ProviderContainer.test(
      overrides: [
        contentRepositoryProvider.overrideWithValue(content),
        progressRepositoryProvider.overrideWithValue(progress),
        engineRegistryProvider.overrideWithValue(
          EngineRegistry([FakeEngine(familyId: 'fam_a')]),
        ),
      ],
    );

    final data = await container.read(examReportProvider(latestId).future);
    expect(data, isNotNull);
    expect(data!.summary.score, 1.0);
    expect(data.summary.deltaVsPrevious, closeTo(1.0, 1e-9));
    expect(data.sectionDeltas[0], closeTo(1.0, 1e-9));
    expect(data.reviewSections.single.outcomes, hasLength(2));
  });
}
