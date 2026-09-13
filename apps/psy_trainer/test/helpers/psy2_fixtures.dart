import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';

/// PSY2 test fixtures (US-111/US-112): a couple of families, a handful of
/// interview questions across two themes, and one lesson per family.

List<TestFamily> psy2Families() => const [
  TestFamily(
    id: 'interview',
    moduleId: ModuleId.psy2,
    version: 1,
    order: 1,
    name: LocalizedText(fr: 'Entretien individuel'),
    description: LocalizedText(fr: 'Banque de questions par thème.'),
    engineType: EngineType.interview,
    answerFormat: AnswerFormat.recording,
    defaultDurationSec: 165,
    defaultItemCount: 1,
    confidence: Confidence.reported,
  ),
  TestFamily(
    id: 'group_exercise',
    moduleId: ModuleId.psy2,
    version: 1,
    order: 2,
    name: LocalizedText(fr: 'Exercice de groupe'),
    description: LocalizedText(fr: 'Grille CRM et guide de groupe.'),
    engineType: EngineType.groupExercise,
    answerFormat: AnswerFormat.multiSelect,
    defaultDurationSec: 1800,
    defaultItemCount: 1,
    confidence: Confidence.assumed,
  ),
];

List<InterviewQuestion> psy2InterviewQuestions() => const [
  InterviewQuestion(
    id: 'interview.motivation.0001',
    version: 1,
    familyId: 'interview',
    theme: InterviewTheme.motivation,
    question: LocalizedText(fr: 'Pourquoi ce métier ?'),
    guidance: LocalizedText(fr: 'Un exemple concret et une raison claire.'),
    modelAnswerSkeleton: LocalizedText(
      fr: 'Déclencheur -> décision -> ce que j\'en retiens.',
    ),
    tags: ['interview.motivation'],
  ),
  InterviewQuestion(
    id: 'interview.stress.0001',
    version: 1,
    familyId: 'interview',
    theme: InterviewTheme.stress,
    question: LocalizedText(fr: 'Décrivez une situation stressante.'),
    guidance: LocalizedText(fr: 'Signe observé, action, résultat.'),
    modelAnswerSkeleton: LocalizedText(
      fr: 'Situation -> signe -> action -> résultat.',
    ),
    tags: ['interview.stress'],
  ),
];

List<Lesson> psy2Lessons() => [
  const Lesson(
    id: 'lesson.interview.01',
    version: 1,
    moduleId: ModuleId.psy2,
    familyId: 'interview',
    order: 1,
    title: LocalizedText(fr: 'Préparer l\'entretien'),
    tags: ['psy2.interview'],
    body: LocalizedText(fr: '# Méthode\n\nSituation -> action -> résultat.'),
  ),
  const Lesson(
    id: 'lesson.group_exercise.01',
    version: 1,
    moduleId: ModuleId.psy2,
    familyId: 'group_exercise',
    order: 1,
    title: LocalizedText(fr: 'La grille CRM'),
    tags: ['psy2.group_exercise'],
    body: LocalizedText(fr: '# CRM\n\nSix dimensions.'),
  ),
  const Lesson(
    id: 'lesson.psy2_selection_stage.01',
    version: 1,
    moduleId: ModuleId.psy2,
    order: 1,
    title: LocalizedText(fr: 'Comment se passe le PSY2'),
    tags: ['psy2.selection_stage'],
    body: LocalizedText(fr: '# PSY2\n\nDeux jours.'),
  ),
];

/// An in-memory content repository seeded with the PSY2 fixtures.
InMemoryContentRepository psy2ContentRepository() => InMemoryContentRepository(
  families: psy2Families(),
  lessons: psy2Lessons(),
  interviewQuestions: psy2InterviewQuestions(),
);
