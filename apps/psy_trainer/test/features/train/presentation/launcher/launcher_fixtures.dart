import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';

/// A bank-driven family (no `generatorId`): `memory_nback` is the wrong
/// engine type here on purpose, only [TestFamily.generatorId] matters to the
/// launcher/builder.
TestFamily bankFamily({
  String id = 'culture_aero',
  int order = 1,
  int? defaultPerItemTimeSec,
  Cadence? defaultCadence,
}) => TestFamily(
  id: id,
  moduleId: ModuleId.psy0,
  version: 1,
  order: order,
  name: const LocalizedText(fr: 'Culture aéronautique'),
  description: const LocalizedText(fr: 'Ce qui est évalué.'),
  engineType: EngineType.cultureAero,
  answerFormat: AnswerFormat.mcq,
  defaultDurationSec: 300,
  defaultItemCount: 20,
  defaultPerItemTimeSec: defaultPerItemTimeSec,
  defaultCadence: defaultCadence,
  confidence: Confidence.confirmed,
);

/// A generator-driven family.
TestFamily generatorFamily({
  String id = 'memory_nback',
  int order = 2,
  GeneratorId generatorId = GeneratorId.nback,
  int? defaultPerItemTimeSec = 3,
}) => TestFamily(
  id: id,
  moduleId: ModuleId.psy0,
  version: 1,
  order: order,
  name: const LocalizedText(fr: 'Mémoire N-back'),
  description: const LocalizedText(fr: 'Ce qui est évalué.'),
  engineType: EngineType.memoryNback,
  answerFormat: AnswerFormat.mcq,
  defaultDurationSec: 300,
  defaultItemCount: 20,
  defaultPerItemTimeSec: defaultPerItemTimeSec,
  generatorId: generatorId,
  confidence: Confidence.confirmed,
);

/// A 3-option MCQ bank item tagged [tag], for [bankFamily].
McqItem bankItem({
  required String id,
  required String familyId,
  String tag = 'default',
  int difficulty = 3,
}) => McqItem(
  id: id,
  version: 1,
  familyId: familyId,
  difficulty: difficulty,
  tags: [tag],
  stem: LocalizedText(fr: 'Question $id'),
  options: const [
    McqOption(text: LocalizedText(fr: 'A')),
    McqOption(text: LocalizedText(fr: 'B')),
    McqOption(text: LocalizedText(fr: 'C')),
  ],
  correctIndex: 0,
  explanation: const LocalizedText(fr: 'Parce que.'),
);

/// A repository with [bankFamily] (20 bank items over 4 tags) and
/// [generatorFamily].
InMemoryContentRepository launcherContentRepository() {
  final bank = bankFamily();
  final generated = generatorFamily();
  final tags = ['memory', 'logic', 'spatial', 'verbal'];
  return InMemoryContentRepository(
    families: [bank, generated],
    items: [
      for (var i = 0; i < 20; i++)
        bankItem(id: 'item-$i', familyId: bank.id, tag: tags[i % tags.length]),
    ],
  );
}
