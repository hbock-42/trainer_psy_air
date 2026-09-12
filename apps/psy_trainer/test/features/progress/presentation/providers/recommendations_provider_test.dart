import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';
import 'package:psy_trainer/features/progress/presentation/providers/progress_version_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/recommendations_provider.dart';
import 'package:psy_trainer/features/progress/presentation/providers/stats_service_provider.dart';

/// Fixed "now" of every test: 2026-09-30 12:00 UTC.
final DateTime now = DateTime.utc(2026, 9, 30, 12);

DateTime daysAgo(int days) => now.subtract(Duration(days: days));

TestFamily family(String id, {String? name}) => TestFamily(
  id: id,
  moduleId: ModuleId.psy0,
  version: 1,
  order: 1,
  name: LocalizedText(fr: name ?? id),
  description: const LocalizedText(fr: 'x'),
  engineType: EngineType.cultureAero,
  answerFormat: AnswerFormat.mcq,
  defaultDurationSec: 600,
  defaultItemCount: 20,
  confidence: Confidence.reported,
);

Lesson lesson(String id, String familyId) => Lesson(
  id: id,
  version: 1,
  moduleId: ModuleId.psy0,
  order: 1,
  title: LocalizedText(fr: 'Leçon $id'),
  body: const LocalizedText(fr: 'Corps'),
  tags: const [],
  familyId: familyId,
);

void main() {
  late InMemoryProgressRepository progress;
  late InMemoryContentRepository content;
  late ProviderContainer container;

  setUp(() {
    progress = InMemoryProgressRepository(clock: () => now);
    content = InMemoryContentRepository(
      families: [family('arithmetic_grid', name: 'Grilles de calcul')],
      lessons: [lesson('lesson-1', 'arithmetic_grid')],
    );
    container = ProviderContainer.test(
      overrides: [
        progressRepositoryProvider.overrideWithValue(progress),
        contentRepositoryProvider.overrideWithValue(content),
        statsServiceProvider.overrideWithValue(StatsService(now: () => now)),
      ],
    );
  });

  Future<void> practice(
    String familyId, {
    required int correct,
    int attempts = 10,
    int daysAgo = 0,
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
          responseMs: 500,
          position: i,
          answeredAt: startedAt.add(Duration(seconds: i)),
        ),
    ]);
    await progress.finishSession(
      session.id,
      status: SessionStatus.completed,
      endedAt: startedAt,
    );
  }

  test('is empty with no data', () async {
    final result = await container.read(recommendationsProvider.future);
    expect(result, isEmpty);
  });

  test(
    'a weak family becomes a family recommendation with its real name',
    () async {
      await practice('arithmetic_grid', correct: 2);
      final result = await container.read(recommendationsProvider.future);
      final rec = result.singleWhere(
        (r) => r.kind == RecommendationKind.family,
      );
      expect(rec.targetId, 'arithmetic_grid');
      expect(rec.title, 'Grilles de calcul');
      expect(rec.reason, 'précision 20 % sur Grilles de calcul');
    },
  );

  test(
    'the unread lesson of a practised family becomes a lesson nudge',
    () async {
      await practice('arithmetic_grid', correct: 9); // not weak
      var result = await container.read(recommendationsProvider.future);
      final lessonRec = result.singleWhere(
        (r) => r.kind == RecommendationKind.lesson,
      );
      expect(lessonRec.targetId, 'arithmetic_grid');
      expect(lessonRec.secondaryId, 'lesson-1');

      await progress.markLessonRead('lesson-1', readAt: now);
      container.read(progressVersionProvider.notifier).bump();
      result = await container.read(recommendationsProvider.future);
      expect(result.where((r) => r.kind == RecommendationKind.lesson), isEmpty);
    },
  );

  test('a due flashcard backlog above the threshold becomes a nudge', () async {
    for (var i = 0; i < 11; i++) {
      await progress.saveFlashcardReview(
        FlashcardReview(
          flashcardId: 'card-$i',
          deckId: 'deck-1',
          box: 1,
          reviews: 0,
          lapses: 0,
          nextReviewAt: daysAgo(1),
        ),
      );
    }
    final result = await container.read(recommendationsProvider.future);
    final flashcards = result.singleWhere(
      (r) => r.kind == RecommendationKind.flashcards,
    );
    expect(flashcards.reason, '11 cartes en attente');
  });

  test('cached until the version is bumped', () async {
    final empty = await container.read(recommendationsProvider.future);
    expect(empty, isEmpty);

    await practice('arithmetic_grid', correct: 2);
    expect(container.read(recommendationsProvider).value, same(empty));

    container.read(progressVersionProvider.notifier).bump();
    final fresh = await container.read(recommendationsProvider.future);
    expect(fresh, isNotEmpty);
  });
}
