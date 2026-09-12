import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_resume_provider.dart';

ExamBlueprint _blueprint() => const ExamBlueprint(
  id: 'bp.test',
  version: 1,
  moduleId: ModuleId.psy0,
  name: LocalizedText(fr: 'PSY0 — test'),
  description: LocalizedText(fr: 'Test'),
  confidence: Confidence.assumed,
  tags: [],
  sections: [],
);

void main() {
  final now = DateTime.utc(2026, 9, 12, 12);
  late InMemoryProgressRepository repo;
  late ProviderContainer container;

  ProviderContainer build() => ProviderContainer.test(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        InMemoryContentRepository(blueprints: [_blueprint()]),
      ),
      progressRepositoryProvider.overrideWithValue(repo),
      examResumeNowProvider.overrideWithValue(() => now),
    ],
  );

  setUp(() {
    repo = InMemoryProgressRepository(clock: () => now);
  });

  test(
    'offers the most recent interrupted exam, with its blueprint name',
    () async {
      final session = await repo.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: now.subtract(const Duration(minutes: 8)),
      );
      await repo.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
          answeredAt: now.subtract(const Duration(minutes: 5)),
        ),
      );

      container = build();
      final entry = await container.read(examResumeProvider.future);

      expect(entry, isNotNull);
      expect(entry!.candidate.session.id, session.id);
      expect(entry.blueprintName, 'PSY0 — test');
    },
  );

  test('marks an exam interrupted for more than 10 minutes abandoned and '
      'offers nothing', () async {
    final stale = await repo.startSession(
      mode: SessionMode.exam,
      blueprintId: 'bp.test',
      startedAt: now.subtract(const Duration(hours: 1)),
    );
    await repo.recordAttempt(
      NewAttempt(
        sessionId: stale.id,
        familyId: 'fam_a',
        isCorrect: true,
        responseMs: 500,
        position: 0,
        itemId: 'q1',
        answeredAt: now.subtract(const Duration(minutes: 45)),
      ),
    );

    container = build();
    final entry = await container.read(examResumeProvider.future);

    expect(entry, isNull);
    expect(repo.sessionsById[stale.id]!.status, SessionStatus.abandoned);
  });

  test('ignores practice sessions', () async {
    await repo.startSession(
      mode: SessionMode.practice,
      familyId: 'fam_a',
      startedAt: now.subtract(const Duration(minutes: 1)),
    );

    container = build();
    final entry = await container.read(examResumeProvider.future);

    expect(entry, isNull);
  });
}
