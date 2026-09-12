import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/exam/presentation/exam_history_screen.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/onboarding_fakes.dart';

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
  testWidgets(
    'shows duration and status, and long-pressing a row deletes it after '
    'confirmation (US-064)',
    (tester) async {
      final now = DateTime.utc(2026, 9, 12, 12);
      final progress = InMemoryProgressRepository(clock: () => now)
        ..storedProfile = completedAnswers.applyTo(null);

      final startedAt = now.subtract(const Duration(days: 1, hours: 1));
      final completed = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: startedAt,
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: completed.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
        ),
      );
      await progress.finishSession(
        completed.id,
        status: SessionStatus.completed,
        endedAt: startedAt.add(const Duration(minutes: 45)),
      );

      final container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            InMemoryContentRepository(blueprints: [_blueprint()]),
          ),
          progressRepositoryOverride(repository: progress),
          contentReadyOverride(),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const PsyTrainerApp(),
        ),
      );
      await tester.pumpAndSettle();
      container.read(appRouterProvider).go(AppRoutes.examHistory);
      await tester.pumpAndSettle();

      final rowKey = Key('exam_history.row.${completed.id}');
      expect(find.byKey(rowKey), findsOneWidget);
      expect(find.textContaining('Terminée'), findsOneWidget);
      expect(find.textContaining('min'), findsOneWidget);

      await tester.longPress(find.byKey(rowKey));
      await tester.pumpAndSettle();
      expect(find.byKey(ExamHistoryScreen.deleteConfirmKey), findsOneWidget);

      await tester.tap(find.byKey(ExamHistoryScreen.deleteConfirmKey));
      await tester.pumpAndSettle();

      expect(find.byKey(rowKey), findsNothing);
      expect(progress.sessionsById.containsKey(completed.id), isFalse);
      expect(
        progress.attempts.where((a) => a.sessionId == completed.id),
        isEmpty,
      );
    },
  );

  testWidgets('cancelling the delete confirmation keeps the simulation', (
    tester,
  ) async {
    final now = DateTime.utc(2026, 9, 12, 12);
    final progress = InMemoryProgressRepository(clock: () => now)
      ..storedProfile = completedAnswers.applyTo(null);
    final session = await progress.startSession(
      mode: SessionMode.exam,
      blueprintId: 'bp.test',
      startedAt: now.subtract(const Duration(hours: 1)),
    );
    await progress.finishSession(
      session.id,
      status: SessionStatus.abandoned,
      endedAt: now,
    );

    final container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          InMemoryContentRepository(blueprints: [_blueprint()]),
        ),
        progressRepositoryOverride(repository: progress),
        contentReadyOverride(),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PsyTrainerApp(),
      ),
    );
    await tester.pumpAndSettle();
    container.read(appRouterProvider).go(AppRoutes.examHistory);
    await tester.pumpAndSettle();

    final rowKey = Key('exam_history.row.${session.id}');
    await tester.longPress(find.byKey(rowKey));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(ExamHistoryScreen.deleteCancelKey));
    await tester.pumpAndSettle();

    expect(find.byKey(rowKey), findsOneWidget);
    expect(progress.sessionsById.containsKey(session.id), isTrue);
  });
}
