import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';

import '../content_repository_contract.dart';

void main() {
  group('InMemoryContentRepository', () {
    runContentRepositoryContract(
      create: (content) async => InMemoryContentRepository(
        info: ContentInfo(
          schemaVersion: content.manifest.schemaVersion,
          contentVersion: content.manifest.contentVersion,
          seededAt: seededAt,
        ),
        modules: content.modules,
        families: content.families,
        items: content.items,
        passages: content.passages,
        lessons: content.lessons,
        decks: content.decks,
        blueprints: content.blueprints,
        lexicalFields: content.lexicalFields,
      ),
      dispose: () async {},
    );

    test('starts empty and accepts content incrementally', () async {
      final repo = InMemoryContentRepository();
      expect(await repo.contentInfo(), isNull);
      expect(await repo.families(), isEmpty);
      repo.addFamily(
        const TestFamily(
          id: 'english',
          moduleId: ModuleId.psy0,
          version: 1,
          order: 1,
          name: LocalizedText(fr: 'Anglais'),
          description: LocalizedText(fr: 'QCM'),
          engineType: EngineType.englishReading,
          answerFormat: AnswerFormat.mcq,
          defaultDurationSec: 600,
          defaultItemCount: 20,
          confidence: Confidence.reported,
        ),
      );
      expect((await repo.familyById('english'))?.name.fr, 'Anglais');
    });
  });
}
