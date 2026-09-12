import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';

/// The 14 PSY0 family ids in real-test order (EPIC-03 table).
const List<String> psy0FamilyIds = [
  'memory_nback',
  'planning_tubes',
  'attention_rules',
  'attention_parity',
  'spatial_overlay',
  'logic_dominos',
  'attention_airways',
  'verbal_boxes',
  'arithmetic_grid',
  'spatial_viewpoint',
  'spatial_cubes',
  'culture_aero',
  'multitask_psychomotor',
  'english_reading',
];

/// French display names, in [psy0FamilyIds] order.
const List<String> psy0FamilyNames = [
  'Mémoire N-back',
  'Billes et éprouvettes',
  'Formes et couleurs',
  'Pair / impair',
  'Formes glissées',
  'Dominos',
  'Airways',
  'Boîte à mots',
  'Grilles de calcul',
  'Objets 3D',
  'Cubes et dés',
  'Culture aéronautique',
  'Multitâche',
  'Anglais — compréhension écrite',
];

/// Test fixture: the 14 PSY0 families with plausible formats. Values are
/// only meant to exercise the UI (order, formatting), not to mirror the spec.
List<TestFamily> psy0Families() => [
  for (final (i, id) in psy0FamilyIds.indexed)
    TestFamily(
      id: id,
      moduleId: ModuleId.psy0,
      version: 1,
      order: i + 1,
      name: LocalizedText(fr: psy0FamilyNames[i]),
      description: LocalizedText(fr: 'Ce qui est évalué pour $id.'),
      engineType: EngineType.cultureAero,
      answerFormat: AnswerFormat.mcq,
      defaultDurationSec: 60 * (i + 1) + (i.isEven ? 0 : 45),
      defaultItemCount: 10 + i,
      defaultPerItemTimeSec: i.isEven ? null : 30,
      confidence: Confidence.values[i % Confidence.values.length],
    ),
];

/// Two lessons on the first family, one on the second.
List<Lesson> psy0Lessons() => [
  const Lesson(
    id: 'lesson.memory_nback.01',
    version: 1,
    moduleId: ModuleId.psy0,
    familyId: 'memory_nback',
    order: 1,
    title: LocalizedText(fr: 'N-back : tenir le rythme'),
    summary: LocalizedText(fr: 'Méthode du train de wagons.'),
    estimatedReadMin: 9,
    tags: ['memory_nback'],
    file: LocalizedPath(fr: 'lessons/memory_nback/01.fr.md'),
  ),
  const Lesson(
    id: 'lesson.memory_nback.02',
    version: 1,
    moduleId: ModuleId.psy0,
    familyId: 'memory_nback',
    order: 2,
    title: LocalizedText(fr: 'N-back : gérer les leurres'),
    tags: ['memory_nback'],
    body: LocalizedText(fr: 'Texte.'),
  ),
  const Lesson(
    id: 'lesson.planning_tubes.01',
    version: 1,
    moduleId: ModuleId.psy0,
    familyId: 'planning_tubes',
    order: 1,
    title: LocalizedText(fr: 'Éprouvettes : compter les coups'),
    tags: ['planning_tubes'],
    body: LocalizedText(fr: 'Texte.'),
  ),
];

/// An in-memory content repository seeded with the PSY0 fixture, or empty
/// when [seeded] is false (the pre-US-013 state).
InMemoryContentRepository psy0ContentRepository({bool seeded = true}) =>
    InMemoryContentRepository(
      families: seeded ? psy0Families() : const [],
      lessons: seeded ? psy0Lessons() : const [],
    );
