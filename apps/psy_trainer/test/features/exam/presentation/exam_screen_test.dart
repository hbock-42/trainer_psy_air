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

/// Pumps the whole app and navigates to the exam home (`/exam`) over the
/// given [blueprints], so a real router + repository stack backs the
/// screen (matches how `ExamScreen` is actually reached).
Future<ProviderContainer> _pumpExamHome(
  WidgetTester tester, {
  required List<ExamBlueprint> blueprints,
  Size? size,
  double textScale = 1.0,
}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  final container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        InMemoryContentRepository(blueprints: blueprints),
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
  return container;
}

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

  testWidgets('exam home meets accessibility guidelines', (tester) async {
    final handle = tester.ensureSemantics();
    await _pumpExamHome(
      tester,
      blueprints: [
        ExamBlueprint(
          id: 'bp.test',
          version: 1,
          moduleId: ModuleId.psy0,
          name: const LocalizedText(fr: 'PSY0 — simulation'),
          description: const LocalizedText(fr: 'Description'),
          confidence: Confidence.assumed,
          tags: const [],
          sections: [_section('fam_a')],
        ),
      ],
    );

    await expectLater(tester, meetsGuideline(textContrastGuideline));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    handle.dispose();
  });

  testWidgets('survives 1.3x text scale at 360dp with a long blueprint name', (
    tester,
  ) async {
    await _pumpExamHome(
      tester,
      size: const Size(360, 780),
      textScale: 1.3,
      blueprints: [
        ExamBlueprint(
          id: 'bp.long',
          version: 1,
          moduleId: ModuleId.psy0,
          name: const LocalizedText(
            fr:
                'Simulation complète PSY0 — épreuves psychotechniques et '
                'connaissances aéronautiques',
          ),
          description: const LocalizedText(
            fr: 'Une description volontairement longue pour la mise en page.',
          ),
          confidence: Confidence.assumed,
          tags: const [],
          sections: [
            _section('fam_a'),
            const ExamSection(
              id: 'fam_b',
              familyId: 'fam_b',
              itemCount: 2,
              sectionTimeSec: 60,
              title: LocalizedText(
                fr: 'Attention divisée — gestion multitâche prolongée',
              ),
              itemSelection: ItemSelection.generated(
                generatorId: GeneratorId.dominos,
                difficulty: DifficultyRange(min: 3, max: 3),
                params: GeneratorParams.dominos(),
              ),
              confidence: Confidence.assumed,
            ),
          ],
        ),
      ],
    );

    expect(tester.takeException(), isNull);
  });
}
