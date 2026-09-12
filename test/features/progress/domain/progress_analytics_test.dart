import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/content/content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';

import '../../../core/db/example_content.dart';

/// Fixed "now": 2026-09-30 12:00 UTC.
final DateTime now = DateTime.utc(2026, 9, 30, 12);

DateTime daysAgo(int days) => now.subtract(Duration(days: days));

/// The one content family of this fixture: `mental_arithmetic` has no entry
/// in `StatsConfig.defaultFamilyWeights`, so it weighs 1 in the readiness
/// score (the arithmetic below relies on that).
const TestFamily arithFamily = TestFamily(
  id: 'mental_arithmetic',
  moduleId: ModuleId.psy0,
  version: 1,
  order: 1,
  name: LocalizedText(fr: 'Calcul mental'),
  description: LocalizedText(fr: 'Calculs rapides.'),
  engineType: EngineType.arithmeticGrid,
  answerFormat: AnswerFormat.numeric,
  defaultDurationSec: 300,
  defaultItemCount: 20,
  confidence: Confidence.assumed,
);

const Lesson arithLesson = Lesson(
  id: 'mental_arithmetic.lesson.03',
  version: 1,
  moduleId: ModuleId.psy0,
  familyId: 'mental_arithmetic',
  order: 3,
  title: LocalizedText(fr: 'Vitesse, temps, distance'),
  tags: ['arith'],
  body: LocalizedText(fr: 'x'),
);

ExamSection shortSection(String id, String familyId, {double weight = 1}) =>
    ExamSection(
      id: id,
      familyId: familyId,
      sectionTimeSec: 300,
      itemCount: 10,
      itemSelection: const ItemSelection.bank(),
      confidence: Confidence.assumed,
      weight: weight,
    );

/// Four sections (weights 1, 1, 1, 0.5) — the exam scores below are computed
/// against this structure.
final ExamBlueprint shortBlueprint = ExamBlueprint(
  id: 'psy0.blueprint.short',
  version: 1,
  moduleId: ModuleId.psy0,
  name: const LocalizedText(fr: 'Courte'),
  description: const LocalizedText(fr: 'Quatre sections.'),
  confidence: Confidence.assumed,
  tags: const ['blueprint.short'],
  sections: [
    shortSection('s01-arith', 'mental_arithmetic'),
    shortSection('s02-logic', 'logic'),
    shortSection('s03-english', 'english'),
    shortSection('s04-memory', 'memory', weight: 0.5),
  ],
);

void main() {
  late InMemoryProgressRepository progress;
  late InMemoryContentRepository content;
  late ProgressAnalytics analytics;

  setUp(() {
    final example = ExampleContent.load();
    progress = InMemoryProgressRepository(clock: () => now);
    content = InMemoryContentRepository(
      modules: example.modules,
      families: const [arithFamily],
      items: example.items,
      lessons: const [arithLesson],
      decks: example.decks,
      blueprints: [shortBlueprint],
    );
    analytics = ProgressAnalytics(
      progress: progress,
      content: content,
      stats: StatsService(now: () => now),
    );
  });

  /// A practice session of [family] started [days] ago answering [correct]
  /// of [total] generated items (or bank [itemIds]) in [ms] each.
  Future<TrainingSession> practice(
    String family, {
    required int days,
    required int total,
    required int correct,
    int ms = 1000,
    List<String>? itemIds,
    bool answered = true,
  }) async {
    final session = await progress.startSession(
      mode: SessionMode.practice,
      familyId: family,
      startedAt: daysAgo(days),
    );
    await progress.recordAttempts([
      for (var i = 0; i < total; i++)
        NewAttempt(
          sessionId: session.id,
          familyId: family,
          itemId: itemIds?[i],
          origin: itemIds == null
              ? AttemptOrigin(generatorId: 'g', seed: i)
              : null,
          answer: answered ? const {'index': 0} : null,
          isCorrect: i < correct,
          responseMs: ms,
          position: i,
          answeredAt: daysAgo(days),
        ),
    ]);
    return progress.finishSession(
      session.id,
      status: SessionStatus.completed,
      endedAt: daysAgo(days).add(const Duration(minutes: 10)),
    );
  }

  /// An exam on `psy0.blueprint.short` started [days] ago with the given
  /// `correct / total` per section index (sections absent are unreached).
  Future<TrainingSession> exam(
    Map<int, (int, int)> sections, {
    required int days,
    SessionStatus status = SessionStatus.completed,
  }) async {
    final blueprint = (await content.blueprints()).single;
    final session = await progress.startSession(
      mode: SessionMode.exam,
      blueprintId: blueprint.id,
      startedAt: daysAgo(days),
    );
    var position = 0;
    await progress.recordAttempts([
      for (final MapEntry(key: index, value: (correct, total))
          in sections.entries)
        for (var i = 0; i < total; i++)
          NewAttempt(
            sessionId: session.id,
            familyId: blueprint.sections[index].familyId,
            origin: AttemptOrigin(generatorId: 'g', seed: position),
            answer: const {'index': 0},
            isCorrect: i < correct,
            responseMs: 800,
            position: position++,
            sectionIndex: index,
            answeredAt: daysAgo(days),
          ),
    ]);
    return progress.finishSession(session.id, status: status);
  }

  group('snapshot', () {
    test(
      'with no data lists content families at level 1 and is empty',
      () async {
        final snapshot = await analytics.snapshot();
        expect(snapshot.isEmpty, isTrue);
        expect(snapshot.computedAt, now);
        expect(snapshot.families.map((f) => f.familyId), ['mental_arithmetic']);
        expect(snapshot.families.single.level, 1);
        expect(snapshot.families.single.hasData, isFalse);
        expect(snapshot.readiness.value, 0);
        expect(snapshot.readiness.lessonsTotal, 1);
        expect(snapshot.weakAreas, isEmpty);
        expect(snapshot.exams, isEmpty);
        expect(snapshot.latestExam, isNull);
        expect(snapshot.family('mental_arithmetic'), isNotNull);
        expect(snapshot.family('nope'), isNull);
      },
    );

    test('mixes practice, exam and lesson data', () async {
      // mental_arithmetic (content family): improving over 3 sessions.
      await practice('mental_arithmetic', days: 20, total: 10, correct: 5);
      await practice('mental_arithmetic', days: 10, total: 10, correct: 7);
      await practice('mental_arithmetic', days: 2, total: 10, correct: 10);
      // logic: not in content, all timeouts.
      await practice(
        'logic',
        days: 1,
        total: 12,
        correct: 0,
        ms: 6000,
        answered: false,
      );
      // english bank items -> item stats -> tags.
      await practice(
        'english',
        days: 3,
        total: 4,
        correct: 1,
        itemIds: const [
          'english.grammar.0001',
          'english.grammar.0001',
          'english.grammar.0001',
          'english.vocab.0001',
        ],
      );
      // Two exams: sections 0 (arith) and 1 (logic) reached only.
      await exam({0: (4, 10), 1: (5, 10)}, days: 8);
      await exam({0: (8, 10), 1: (5, 10), 2: (0, 0)}, days: 1);
      await progress.markLessonRead('mental_arithmetic.lesson.03');

      final snapshot = await analytics.snapshot();
      expect(snapshot.isEmpty, isFalse);
      expect(snapshot.families.map((f) => f.familyId), [
        'mental_arithmetic',
        'english',
        'logic',
      ]);

      final arith = snapshot.family('mental_arithmetic')!;
      // 22/30 practice + 12/20 exam attempts count in the lifetime figures.
      expect(arith.attempts, 50);
      expect(arith.correct, 34);
      expect(arith.sessions, 5);
      expect(arith.level, 3);
      expect(arith.lastPractisedAt, daysAgo(1));
      expect(arith.trend30d.direction, TrendDirection.up);
      expect(arith.trend30d.sessions, 5);
      expect(arith.trend7d.sessions, 2);
      expect(arith.medianResponseMs, 1000);

      final logic = snapshot.family('logic')!;
      expect(logic.attempts, 32);
      expect(logic.correct, 10);
      expect(logic.level, 1);
      expect(logic.medianResponseMs, 800);

      final english = snapshot.family('english')!;
      expect(english.attempts, 4);
      expect(english.level, 1);

      expect(snapshot.exams, hasLength(2));
      final latest = snapshot.latestExam!;
      expect(latest.sections.map((s) => s.familyId), [
        'mental_arithmetic',
        'logic',
        'english',
        'memory',
      ]);
      expect(latest.sections.map((s) => s.weight), [1, 1, 1, 0.5]);
      // (0.8 + 0.5 + 0 + 0) / 3.5
      expect(latest.score, closeTo(1.3 / 3.5, 1e-9));
      expect(latest.previousSessionId, snapshot.exams.last.sessionId);
      expect(snapshot.exams.last.score, closeTo(0.9 / 3.5, 1e-9));
      expect(latest.deltaVsPrevious, closeTo(0.4 / 3.5, 1e-9));

      final readiness = snapshot.readiness;
      expect(readiness.familiesTotal, 3);
      expect(readiness.familiesPractised, 3);
      expect(readiness.lessonsRead, 1);
      expect(readiness.lessonsTotal, 1);
      expect(readiness.lessonComponent, 1);
      expect(readiness.examsCounted, 2);
      expect(readiness.examComponent, closeTo(2.2 / 3.5 / 2, 1e-9));
      // Only mental_arithmetic (weight 1, level 3 -> 0.5) has a level > 1;
      // english is an MVP family (weight 2), logic weighs 1: sum 4.
      expect(readiness.familyComponent, closeTo(0.5 / 4, 1e-9));
      expect(
        readiness.value,
        closeTo(100 * (0.6 * 0.5 / 4 + 0.15 + 0.25 * 2.2 / 7), 1e-9),
      );

      expect(snapshot.weakAreas.map((a) => (a.kind, a.id)), [
        (WeakAreaKind.family, 'logic'),
      ]);
      expect(snapshot.weakAreas.single.reasons, {WeakAreaReason.lowAccuracy});
    });

    test('flags weak tags from bank item stats', () async {
      await practice(
        'english',
        days: 1,
        total: 12,
        correct: 2,
        itemIds: List.filled(12, 'english.grammar.0001'),
      );
      final snapshot = await analytics.snapshot();
      expect(snapshot.weakAreas.map((a) => (a.kind, a.id)), [
        (WeakAreaKind.family, 'english'),
        (WeakAreaKind.tag, 'english.grammar'),
        (WeakAreaKind.tag, 'english.grammar.tenses'),
      ]);
      expect(snapshot.weakAreas.last.accuracy, closeTo(1 / 6, 1e-9));
    });
  });

  group('familyTimeSeries', () {
    test('returns one point per session in the range', () async {
      await practice('mental_arithmetic', days: 40, total: 10, correct: 5);
      await practice('mental_arithmetic', days: 5, total: 10, correct: 8);
      await exam({0: (9, 10)}, days: 2);
      await practice('logic', days: 1, total: 10, correct: 8);

      final all = await analytics.familyTimeSeries('mental_arithmetic');
      expect(all.points.map((p) => p.accuracy), [0.5, 0.8, 0.9]);
      expect(all.points.map((p) => p.mode), [
        SessionMode.practice,
        SessionMode.practice,
        SessionMode.exam,
      ]);

      final month = await analytics.familyTimeSeries(
        'mental_arithmetic',
        from: daysAgo(30),
        to: now,
        mode: SessionMode.practice,
      );
      expect(month.points.map((p) => p.accuracy), [0.8]);
      expect(month.from, daysAgo(30));
      expect(month.to, now);

      expect((await analytics.familyTimeSeries('memory')).isEmpty, isTrue);
    });
  });

  group('familyProgress', () {
    test('computes one family from the repositories', () async {
      await practice('mental_arithmetic', days: 1, total: 20, correct: 19);
      final one = await analytics.familyProgress('mental_arithmetic');
      expect(one.level, 5);
      expect(one.sessions, 1);
      expect(one.medianResponseMs, 1000);
      final none = await analytics.familyProgress('memory');
      expect(none.hasData, isFalse);
    });
  });

  group('examHistory and examSummary', () {
    test('lists exams newest first and finds one by id', () async {
      final first = await exam({0: (2, 10)}, days: 9);
      final left = await exam(
        {0: (9, 10)},
        days: 4,
        status: SessionStatus.abandoned,
      );
      final last = await exam({0: (6, 10)}, days: 1);

      final history = await analytics.examHistory();
      expect(history.map((e) => e.sessionId), [last.id, left.id, first.id]);
      expect(history.first.blueprintId, 'psy0.blueprint.short');
      expect(history.first.endedAt, now);
      expect(history.first.previousSessionId, first.id);
      expect(history.first.deltaVsPrevious, closeTo(0.4 / 3.5, 1e-9));
      expect(history[1].status, SessionStatus.abandoned);

      final summary = await analytics.examSummary(first.id);
      expect(summary!.deltaVsPrevious, isNull);
      expect(summary.sections, hasLength(4));
      expect(await analytics.examSummary('nope'), isNull);
    });
  });
}
