import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';

/// Fixed "now" of every test: 2026-09-30 12:00 UTC.
final DateTime now = DateTime.utc(2026, 9, 30, 12);

DateTime daysAgo(int days) => now.subtract(Duration(days: days));

const Trend down = Trend(
  direction: TrendDirection.down,
  slope: -0.02,
  delta: -0.1,
  sessions: 3,
);

FamilyProgress family(
  String id, {
  int attempts = 40,
  int correct = 20,
  int level = 2,
  Trend trend30d = Trend.none,
  DateTime? lastPractisedAt,
}) => FamilyProgress(
  familyId: id,
  attempts: attempts,
  correct: correct,
  sessions: attempts == 0 ? 0 : 1,
  level: level,
  trend7d: Trend.none,
  trend30d: trend30d,
  lastPractisedAt: lastPractisedAt,
);

WeakArea weakFamily(
  String id, {
  double accuracy = 0.5,
  int attempts = 40,
  Set<WeakAreaReason> reasons = const {WeakAreaReason.lowAccuracy},
  Trend? trend,
}) => WeakArea(
  kind: WeakAreaKind.family,
  id: id,
  reasons: reasons,
  accuracy: accuracy,
  attempts: attempts,
  trend: trend,
);

WeakArea weakTag(String id, {double accuracy = 0.4, int attempts = 20}) =>
    WeakArea(
      kind: WeakAreaKind.tag,
      id: id,
      reasons: const {WeakAreaReason.lowAccuracy},
      accuracy: accuracy,
      attempts: attempts,
    );

const ReadinessScore readiness60 = ReadinessScore(
  value: 60,
  familyComponent: 0.6,
  lessonComponent: 0.6,
  examComponent: 0.6,
  familiesPractised: 3,
  familiesTotal: 4,
  lessonsRead: 1,
  lessonsTotal: 1,
  examsCounted: 1,
);

const ReadinessScore readiness40 = ReadinessScore(
  value: 40,
  familyComponent: 0.4,
  lessonComponent: 0.4,
  examComponent: 0.4,
  familiesPractised: 2,
  familiesTotal: 4,
  lessonsRead: 0,
  lessonsTotal: 1,
  examsCounted: 0,
);

void main() {
  final service = RecommendationService(now: () => now);

  group('trainNext', () {
    test('is empty without weak areas', () {
      expect(
        service.trainNext(weakAreas: const [], families: const []),
        isEmpty,
      );
    });

    test('ranks a lower accuracy above a higher one, all else equal', () {
      final areas = [
        weakFamily('mild', accuracy: 0.55),
        weakFamily('severe', accuracy: 0.2),
      ];
      final result = service.trainNext(
        weakAreas: areas,
        families: [family('mild'), family('severe')],
      );
      expect(result.map((r) => r.targetId), ['severe', 'mild']);
    });

    test(
      'MVP families (weight 2) outrank a non-MVP family with the same gap',
      () {
        // memory_nback is an MVP family (StatsConfig.defaultFamilyWeights);
        // planning_tubes is not.
        final areas = [
          weakFamily('planning_tubes', accuracy: 0.3),
          weakFamily('memory_nback', accuracy: 0.3),
        ];
        final result = service.trainNext(
          weakAreas: areas,
          families: [family('planning_tubes'), family('memory_nback')],
        );
        expect(result.map((r) => r.targetId), [
          'memory_nback',
          'planning_tubes',
        ]);
      },
    );

    test(
      'the longer since last practice, the more urgent (same gap/weight)',
      () {
        final areas = [
          weakFamily('recent', accuracy: 0.3),
          weakFamily('stale', accuracy: 0.3),
        ];
        final result = service.trainNext(
          weakAreas: areas,
          families: [
            family('recent', lastPractisedAt: daysAgo(1)),
            family('stale', lastPractisedAt: daysAgo(30)),
          ],
        );
        expect(result.map((r) => r.targetId), ['stale', 'recent']);
      },
    );

    test(
      'a family flagged only for its trend still ranks (positive severity)',
      () {
        final areas = [
          weakFamily(
            'falling',
            accuracy: 0.9,
            trend: down,
            reasons: const {WeakAreaReason.negativeTrend},
          ),
        ];
        final result = service.trainNext(
          weakAreas: areas,
          families: [family('falling')],
        );
        expect(result, hasLength(1));
        expect(result.single.severity, greaterThan(0));
      },
    );

    test('keeps only the top 3 by severity', () {
      final areas = [
        weakFamily('a', accuracy: 0.1),
        weakFamily('b', accuracy: 0.2),
        weakFamily('c', accuracy: 0.3),
        // Weakest accuracy gap of the four: dropped from the top 3.
        weakTag('d', accuracy: 0.58),
      ];
      final result = service.trainNext(
        weakAreas: areas,
        families: [family('a'), family('b'), family('c')],
      );
      expect(result, hasLength(3));
      expect(result.map((r) => r.targetId), ['a', 'b', 'c']);
    });

    test('resolves family/tag names and builds the FR reason', () {
      final result = service.trainNext(
        weakAreas: [
          weakFamily(
            'arithmetic_grid',
            accuracy: 0.62,
            trend: down,
            reasons: const {
              WeakAreaReason.lowAccuracy,
              WeakAreaReason.negativeTrend,
            },
          ),
          weakTag('percentages', accuracy: 0.3),
        ],
        families: [family('arithmetic_grid')],
        familyNames: const {'arithmetic_grid': 'Grilles de calcul'},
        tagLabel: (tag) => tag == 'percentages' ? 'les pourcentages' : tag,
      );
      final grid = result.firstWhere((r) => r.targetId == 'arithmetic_grid');
      expect(grid.kind, RecommendationKind.family);
      expect(grid.title, 'Grilles de calcul');
      expect(grid.reason, 'précision 62 % sur Grilles de calcul, en baisse');

      final tag = result.firstWhere((r) => r.targetId == 'percentages');
      expect(tag.kind, RecommendationKind.tag);
      expect(tag.title, 'les pourcentages');
      expect(tag.reason, 'précision 30 % sur les pourcentages');
    });

    test('falls back to the raw id when no name/label is given', () {
      final result = service.trainNext(
        weakAreas: [weakFamily('memory_nback', accuracy: 0.4)],
        families: [family('memory_nback')],
      );
      expect(result.single.title, 'memory_nback');
    });

    test('is deterministic: same inputs, same output', () {
      final areas = [
        weakFamily('a', accuracy: 0.3),
        weakFamily('b', accuracy: 0.4),
      ];
      final families = [family('a'), family('b')];
      final first = service.trainNext(weakAreas: areas, families: families);
      final second = service.trainNext(weakAreas: areas, families: families);
      expect(first, second);
    });
  });

  group('extras: simulation nudge', () {
    test(
      'suggested when readiness is high enough and nothing was ever completed',
      () {
        final result = service.extras(readiness: readiness60);
        expect(result, hasLength(1));
        expect(result.single.kind, RecommendationKind.examSim);
        expect(
          result.single.reason,
          'aucune simulation complétée pour le moment',
        );
      },
    );

    test('suggested when the last completed simulation is 7+ days old', () {
      final result = service.extras(
        readiness: readiness60,
        lastCompletedExamAt: daysAgo(7),
      );
      expect(result, hasLength(1));
      expect(result.single.reason, 'aucune simulation depuis 7 jours');
    });

    test('not suggested within the 7-day window', () {
      final result = service.extras(
        readiness: readiness60,
        lastCompletedExamAt: daysAgo(6),
      );
      expect(result, isEmpty);
    });

    test('not suggested at or below the readiness floor', () {
      final result = service.extras(
        readiness: const ReadinessScore(
          value: 50,
          familyComponent: 0.5,
          lessonComponent: 0.5,
          examComponent: 0.5,
          familiesPractised: 1,
          familiesTotal: 4,
          lessonsRead: 0,
          lessonsTotal: 1,
          examsCounted: 0,
        ),
      );
      expect(result, isEmpty);
    });
  });

  group('extras: lesson nudge', () {
    test('suggests the first missing lesson, with both ids', () {
      final result = service.extras(
        readiness: readiness40,
        missingLessons: const [
          (familyId: 'arithmetic_grid', lessonId: 'lesson-1'),
          (familyId: 'logic_dominos', lessonId: 'lesson-2'),
        ],
        familyNames: const {'arithmetic_grid': 'Grilles de calcul'},
      );
      final lesson = result.singleWhere(
        (r) => r.kind == RecommendationKind.lesson,
      );
      expect(lesson.title, 'Lis la leçon : Grilles de calcul');
      expect(lesson.targetId, 'arithmetic_grid');
      expect(lesson.secondaryId, 'lesson-1');
    });

    test('nothing when every practised family has read its lesson', () {
      final result = service.extras(readiness: readiness40);
      expect(result.where((r) => r.kind == RecommendationKind.lesson), isEmpty);
    });
  });

  group('extras: flashcards nudge', () {
    test('suggested strictly above the threshold', () {
      final result = service.extras(
        readiness: readiness40,
        dueFlashcardsCount: 11,
      );
      expect(result.single.kind, RecommendationKind.flashcards);
      expect(result.single.reason, '11 cartes en attente');
    });

    test('not suggested at the threshold', () {
      final result = service.extras(
        readiness: readiness40,
        dueFlashcardsCount: 10,
      );
      expect(result, isEmpty);
    });
  });

  group('recommendations', () {
    test('leads with train next, then the rule-based extras', () {
      final result = service.recommendations(
        weakAreas: [weakFamily('memory_nback', accuracy: 0.3)],
        families: [family('memory_nback')],
        readiness: readiness60,
        missingLessons: const [(familyId: 'english', lessonId: 'lesson-3')],
        dueFlashcardsCount: 15,
      );
      expect(result.map((r) => r.kind), [
        RecommendationKind.family,
        RecommendationKind.examSim,
        RecommendationKind.lesson,
        RecommendationKind.flashcards,
      ]);
    });
  });
}
