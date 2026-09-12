import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_resume_provider.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/fake_engine.dart';
import '../../../helpers/onboarding_fakes.dart';

ExamBlueprint _blueprint() => const ExamBlueprint(
  id: 'bp.test',
  version: 1,
  moduleId: ModuleId.psy0,
  name: LocalizedText(fr: 'PSY0 — simulation'),
  description: LocalizedText(fr: 'Description'),
  confidence: Confidence.assumed,
  tags: [],
  sections: [],
);

void main() {
  testWidgets(
    'shows "Reprendre" on the Exam home for an exam interrupted less than '
    '10 minutes ago, and nothing when there is none',
    (tester) async {
      final now = DateTime.utc(2026, 9, 12, 12);
      final progress = InMemoryProgressRepository(clock: () => now)
        ..storedProfile = completedAnswers.applyTo(null);
      final session = await progress.startSession(
        mode: SessionMode.exam,
        blueprintId: 'bp.test',
        startedAt: now.subtract(const Duration(minutes: 8)),
      );
      await progress.recordAttempt(
        NewAttempt(
          sessionId: session.id,
          familyId: 'fam_a',
          isCorrect: true,
          responseMs: 500,
          position: 0,
          itemId: 'q1',
          answeredAt: now.subtract(const Duration(minutes: 3)),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            InMemoryContentRepository(blueprints: [_blueprint()]),
          ),
          progressRepositoryOverride(repository: progress),
          contentReadyOverride(),
          examResumeNowProvider.overrideWithValue(() => now),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry([FakeEngine(familyId: 'fam_a')]),
          ),
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
      container.read(appRouterProvider).go(AppRoutes.exam);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('exam_home.resume')), findsOneWidget);
      expect(find.textContaining('PSY0 — simulation'), findsWidgets);
    },
  );

  testWidgets('shows nothing when there is no interrupted exam', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          InMemoryContentRepository(blueprints: [_blueprint()]),
        ),
        progressRepositoryOverride(),
        contentReadyOverride(),
        engineRegistryProvider.overrideWithValue(
          EngineRegistry([FakeEngine(familyId: 'fam_a')]),
        ),
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
    container.read(appRouterProvider).go(AppRoutes.exam);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('exam_home.resume')), findsNothing);
  });
}
