import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/exam/presentation/exam_screen.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';

import '../../../helpers/fake_engine.dart';
import '../../../helpers/onboarding_fakes.dart' show progressRepositoryOverride;
import '../../../helpers/psy0_families.dart';
import '../../../helpers/pump_app.dart';

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

ExamBlueprint _blueprint(ModuleId moduleId, String familyId) => ExamBlueprint(
  id: '${moduleId.name}.blueprint.test',
  version: 1,
  moduleId: moduleId,
  name: LocalizedText(fr: '${moduleId.name} blueprint'),
  description: const LocalizedText(fr: 'Test.'),
  confidence: Confidence.assumed,
  tags: const [],
  sections: [_section(familyId)],
);

void main() {
  group('ModuleSwitch filters the Learn home (US-101)', () {
    testWidgets('shows PSY0 families by default and switches to PSY1 on tap', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const LearnScreen(),
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            psy0AndPsy1ContentRepository(),
          ),
          progressRepositoryOverride(),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text(psy0FamilyNames.first), findsOneWidget);
      expect(find.text('Matrices progressives'), findsNothing);

      await tester.tap(find.text('PSY1'));
      await tester.pumpAndSettle();

      expect(find.text(psy0FamilyNames.first), findsNothing);
      expect(find.text('Matrices progressives'), findsOneWidget);
      expect(find.text('Psychomoteur'), findsOneWidget);
    });
  });

  group('ModuleSwitch filters the Train home (US-101)', () {
    testWidgets('shows PSY0 families by default and switches to PSY1 on tap', (
      tester,
    ) async {
      await pumpApp(
        tester,
        const TrainScreen(),
        overrides: [
          contentRepositoryProvider.overrideWithValue(
            psy0AndPsy1ContentRepository(),
          ),
          progressRepositoryOverride(),
          engineRegistryProvider.overrideWithValue(
            EngineRegistry([FakeEngine(familyId: 'memory_nback')]),
          ),
        ],
      );
      await tester.pumpAndSettle();

      expect(find.text(psy0FamilyNames.first), findsOneWidget);
      expect(find.text('Matrices progressives'), findsNothing);

      await tester.tap(find.text('PSY1'));
      await tester.pumpAndSettle();

      expect(find.text(psy0FamilyNames.first), findsNothing);
      expect(find.text('Matrices progressives'), findsOneWidget);
    });
  });

  group('ModuleSwitch filters the Exam home (US-101)', () {
    testWidgets(
      'shows PSY0 blueprints by default and switches to PSY1 on tap',
      (tester) async {
        await pumpApp(
          tester,
          const ExamScreen(),
          overrides: [
            contentRepositoryProvider.overrideWithValue(
              InMemoryContentRepository(
                blueprints: [
                  _blueprint(ModuleId.psy0, 'memory_nback'),
                  _blueprint(ModuleId.psy1, 'p1_raven_matrices'),
                ],
              ),
            ),
            progressRepositoryOverride(),
            engineRegistryProvider.overrideWithValue(
              EngineRegistry([FakeEngine(familyId: 'memory_nback')]),
            ),
          ],
        );
        await tester.pumpAndSettle();

        expect(find.text('psy0 blueprint'), findsOneWidget);
        expect(find.text('psy1 blueprint'), findsNothing);

        await tester.tap(find.text('PSY1'));
        await tester.pumpAndSettle();

        expect(find.text('psy0 blueprint'), findsNothing);
        expect(find.text('psy1 blueprint'), findsOneWidget);
      },
    );
  });
}
