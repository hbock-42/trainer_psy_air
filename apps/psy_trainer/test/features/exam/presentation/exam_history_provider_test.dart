import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_history_provider.dart';

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
  test(
    'lists past simulations newest first, with the blueprint name',
    () async {
      final progress = InMemoryProgressRepository(
        clock: () => DateTime.utc(2026, 9, 10),
      );
      final content = InMemoryContentRepository(blueprints: [_blueprint()]);

      final older = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: DateTime.utc(2026, 9),
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: older.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
        ),
      );
      await progress.finishSession(
        older.id,
        status: SessionStatus.completed,
        endedAt: DateTime.utc(2026, 9, 1, 1),
      );

      final newer = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: DateTime.utc(2026, 9, 5),
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: newer.id,
          familyId: 'fam_a',
          isCorrect: false,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
        ),
      );
      await progress.finishSession(
        newer.id,
        status: SessionStatus.abandoned,
        endedAt: DateTime.utc(2026, 9, 5, 1),
      );

      final container = ProviderContainer.test(
        overrides: [
          contentRepositoryProvider.overrideWithValue(content),
          progressRepositoryProvider.overrideWithValue(progress),
        ],
      );

      final entries = await container.read(examHistoryProvider.future);
      expect(entries, hasLength(2));
      expect(entries[0].summary.sessionId, newer.id);
      expect(entries[0].summary.status, SessionStatus.abandoned);
      expect(entries[0].blueprintName, 'PSY0 — test');
      expect(entries[1].summary.sessionId, older.id);
      expect(entries[1].summary.status, SessionStatus.completed);
      expect(entries[1].blueprintName, 'PSY0 — test');
    },
  );
}
