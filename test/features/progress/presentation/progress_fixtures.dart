import 'package:flutter_riverpod/misc.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/providers/stats_service_provider.dart';

/// Fixed "now" of the dashboard tests: 2026-09-30 12:00 UTC.
final DateTime now = DateTime.utc(2026, 9, 30, 12);

DateTime daysAgo(int days) => now.subtract(Duration(days: days));

TestFamily family(String id, int order, String name, {String? shortName}) =>
    TestFamily(
      id: id,
      moduleId: ModuleId.psy0,
      version: 1,
      order: order,
      name: LocalizedText(fr: name),
      shortName: shortName == null ? null : LocalizedText(fr: shortName),
      description: const LocalizedText(fr: 'x'),
      engineType: EngineType.mcqBank,
      answerFormat: AnswerFormat.mcq,
      defaultDurationSec: 600,
      defaultItemCount: 20,
      confidence: Confidence.reported,
    );

/// Four PSY0-like families in real-test order.
final List<TestFamily> families = [
  family('arithmetic_grid', 1, 'Grilles de calcul', shortName: 'Calcul'),
  family('logic_dominos', 2, 'Dominos', shortName: 'Dominos'),
  family('memory_nback', 3, 'Mémoire n-back', shortName: 'N-back'),
  family('english', 4, 'Anglais', shortName: 'Anglais'),
];

final ExamBlueprint blueprint = ExamBlueprint(
  id: 'psy0_full',
  version: 1,
  moduleId: ModuleId.psy0,
  name: const LocalizedText(fr: 'PSY0 complet'),
  description: const LocalizedText(fr: 'x'),
  confidence: Confidence.reported,
  tags: const [],
  sections: [
    for (final f in families.take(2))
      ExamSection(
        id: 'section-${f.id}',
        familyId: f.id,
        durationSec: 60,
        itemCount: 10,
        itemSelection: const ItemSelection.generated(
          generatorId: 'g',
          difficulty: DifficultyRange(min: 1, max: 5),
        ),
        confidence: Confidence.reported,
      ),
  ],
);

const Lesson lesson = Lesson(
  id: 'lesson-1',
  version: 1,
  moduleId: ModuleId.psy0,
  order: 1,
  title: LocalizedText(fr: 'Leçon'),
  body: LocalizedText(fr: 'Corps'),
  tags: [],
);

/// Repositories seeded with the fixture content and a fixed clock.
class ProgressFixture {
  ProgressFixture()
    : content = InMemoryContentRepository(
        families: families,
        blueprints: [blueprint],
        lessons: const [lesson],
      ),
      progress = InMemoryProgressRepository(clock: () => now);

  final InMemoryContentRepository content;
  final InMemoryProgressRepository progress;

  List<Override> get overrides => [
    contentRepositoryProvider.overrideWithValue(content),
    progressRepositoryProvider.overrideWithValue(progress),
    statsServiceProvider.overrideWithValue(StatsService(now: () => now)),
  ];

  /// A completed practice session of [familyId] started [daysAgo] with
  /// [attempts] answers of which [correct] are right.
  Future<TrainingSession> practice(
    String familyId, {
    required int daysAgo,
    required int correct,
    int attempts = 10,
    SessionStatus status = SessionStatus.completed,
  }) async {
    final startedAt = now.subtract(Duration(days: daysAgo));
    final session = await progress.startSession(
      mode: SessionMode.practice,
      familyId: familyId,
      startedAt: startedAt,
    );
    await progress.recordAttempts([
      for (var i = 0; i < attempts; i++)
        NewAttempt(
          sessionId: session.id,
          familyId: familyId,
          origin: AttemptOrigin(generatorId: 'g', seed: i),
          isCorrect: i < correct,
          responseMs: 800,
          position: i,
          answeredAt: startedAt.add(Duration(seconds: i)),
        ),
    ]);
    return progress.finishSession(
      session.id,
      status: status,
      endedAt: startedAt.add(const Duration(minutes: 5)),
    );
  }

  /// A completed simulation of [blueprint] started [daysAgo]: one section
  /// per blueprint family, [correct] right answers out of 10 in each.
  Future<TrainingSession> exam({
    required int daysAgo,
    required int correct,
  }) async {
    final startedAt = now.subtract(Duration(days: daysAgo));
    final session = await progress.startSession(
      mode: SessionMode.exam,
      blueprintId: blueprint.id,
      startedAt: startedAt,
    );
    var position = 0;
    await progress.recordAttempts([
      for (final (index, section) in blueprint.sections.indexed)
        for (var i = 0; i < 10; i++)
          NewAttempt(
            sessionId: session.id,
            familyId: section.familyId,
            origin: AttemptOrigin(generatorId: 'g', seed: i),
            isCorrect: i < correct,
            responseMs: 800,
            position: position++,
            sectionIndex: index,
            answeredAt: startedAt.add(Duration(seconds: position)),
          ),
    ]);
    return progress.finishSession(
      session.id,
      status: SessionStatus.completed,
      endedAt: startedAt.add(const Duration(minutes: 30)),
    );
  }
}
