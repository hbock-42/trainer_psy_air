import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/fake_engine.dart';
import '../../../helpers/onboarding_fakes.dart';

ExamSection _section(String familyId) => ExamSection(
  id: familyId,
  familyId: familyId,
  itemCount: 2,
  sectionTimeSec: 60,
  itemSelection: const ItemSelection.generated(
    generatorId: GeneratorId.dominos,
    difficulty: DifficultyRange(min: 3, max: 3),
    params: GeneratorParams.dominos(),
  ),
  confidence: Confidence.assumed,
);

void main() {
  testWidgets('lists blueprints and greys sections with no registered engine', (
    tester,
  ) async {
    final blueprint = ExamBlueprint(
      id: 'bp.test',
      version: 1,
      moduleId: ModuleId.psy0,
      name: const LocalizedText(fr: 'PSY0 — simulation'),
      description: const LocalizedText(fr: 'Description'),
      confidence: Confidence.assumed,
      tags: const [],
      sections: [_section('fam_a'), _section('fam_missing')],
    );

    final container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(
          InMemoryContentRepository(blueprints: [blueprint]),
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

    expect(find.text('PSY0 — simulation'), findsOneWidget);
    expect(find.textContaining('1/2'), findsOneWidget);
    expect(find.text('non disponible — sera ignorée'), findsOneWidget);
    final start = tester.widget<PrimaryButton>(
      find.byKey(const Key('exam_home.start.bp.test')),
    );
    expect(start.onPressed, isNotNull);
  });
}
