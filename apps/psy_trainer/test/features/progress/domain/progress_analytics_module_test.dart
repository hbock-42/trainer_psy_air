import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';

/// US-101: the readiness snapshot is scoped to one module at a time (the
/// dashboard passes `activeModuleProvider`'s module).
void main() {
  final now = DateTime.utc(2026, 9, 13, 12);

  const psy0Family = TestFamily(
    id: 'memory_nback',
    moduleId: ModuleId.psy0,
    version: 1,
    order: 1,
    name: LocalizedText(fr: 'Mémoire N-back'),
    description: LocalizedText(fr: 'x'),
    engineType: EngineType.memoryNback,
    answerFormat: AnswerFormat.mcq,
    defaultDurationSec: 300,
    defaultItemCount: 20,
    confidence: Confidence.confirmed,
  );

  const psy1Family = TestFamily(
    id: 'p1_raven_matrices',
    moduleId: ModuleId.psy1,
    version: 1,
    order: 1,
    name: LocalizedText(fr: 'Matrices progressives'),
    description: LocalizedText(fr: 'x'),
    engineType: EngineType.p1RavenMatrices,
    answerFormat: AnswerFormat.mcq,
    defaultDurationSec: 1800,
    defaultItemCount: 30,
    confidence: Confidence.reported,
  );

  late InMemoryProgressRepository progress;
  late InMemoryContentRepository content;
  late ProgressAnalytics analytics;

  setUp(() {
    progress = InMemoryProgressRepository(clock: () => now);
    content = InMemoryContentRepository(families: [psy0Family, psy1Family]);
    analytics = ProgressAnalytics(
      progress: progress,
      content: content,
      stats: StatsService(now: () => now),
    );
  });

  Future<void> practice(String familyId, {required int correct}) async {
    final session = await progress.startSession(
      mode: SessionMode.practice,
      familyId: familyId,
    );
    // Above StatsConfig.minAttemptsForLevel (10) so a family with a strong
    // accuracy actually reaches a level above 1 (level 1 also covers "too
    // few attempts"), which is what makes the readiness component nonzero.
    for (var i = 0; i < 12; i++) {
      await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: familyId,
          origin: const AttemptOrigin(generatorId: 'nback', seed: 1),
          isCorrect: i < correct,
          responseMs: 900,
          position: i,
        ),
      );
    }
    await progress.finishSession(session.id, status: SessionStatus.completed);
  }

  test('scopes the family list to the given module', () async {
    final psy0Snapshot = await analytics.snapshot(moduleId: ModuleId.psy0);
    expect(psy0Snapshot.families.map((f) => f.familyId), ['memory_nback']);

    final psy1Snapshot = await analytics.snapshot(moduleId: ModuleId.psy1);
    expect(psy1Snapshot.families.map((f) => f.familyId), ['p1_raven_matrices']);
  });

  test('a family practised under one module never leaks into the other '
      "module's snapshot as an 'orphaned' family", () async {
    await practice('memory_nback', correct: 12);

    final psy1Snapshot = await analytics.snapshot(moduleId: ModuleId.psy1);
    expect(psy1Snapshot.families.map((f) => f.familyId), ['p1_raven_matrices']);

    final psy0Snapshot = await analytics.snapshot(moduleId: ModuleId.psy0);
    expect(psy0Snapshot.families.single.attempts, 12);
  });

  test('readiness differs per module once one has real attempts', () async {
    await practice('memory_nback', correct: 12);

    final psy0Readiness = (await analytics.snapshot(
      moduleId: ModuleId.psy0,
    )).readiness.value;
    final psy1Readiness = (await analytics.snapshot(
      moduleId: ModuleId.psy1,
    )).readiness.value;

    expect(psy0Readiness, greaterThan(psy1Readiness));
  });
}
