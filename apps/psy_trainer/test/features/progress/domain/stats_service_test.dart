import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/progress/domain/progress_domain.dart';

/// Fixed "now" of every test: 2026-09-30 12:00 UTC.
final DateTime now = DateTime.utc(2026, 9, 30, 12);

/// `daysAgo(3)` is 3 days before [now].
DateTime daysAgo(int days) => now.subtract(Duration(days: days));

/// A per-session row of [family] in a session started [daysAgo].
SessionFamilyStats row({
  required String session,
  required int daysAgo,
  required int attempts,
  required int correct,
  String family = 'english',
  int unanswered = 0,
  double median = 1000,
  SessionMode mode = SessionMode.practice,
  int? section,
}) => SessionFamilyStats(
  sessionId: session,
  familyId: family,
  mode: mode,
  startedAt: now.subtract(Duration(days: daysAgo)),
  attempts: attempts,
  correct: correct,
  unanswered: unanswered,
  meanResponseMs: median,
  medianResponseMs: median,
  sectionIndex: section,
);

TrainingSession examSession(
  String id, {
  required int daysAgo,
  String? blueprintId = 'bp',
  SessionStatus status = SessionStatus.completed,
}) => TrainingSession(
  id: id,
  mode: SessionMode.exam,
  startedAt: now.subtract(Duration(days: daysAgo)),
  endedAt: status == SessionStatus.inProgress
      ? null
      : now.subtract(Duration(days: daysAgo, hours: -1)),
  status: status,
  config: const {},
  blueprintId: blueprintId,
);

const LocalizedText text = LocalizedText(fr: 'x');

ExamSection section(String family, {double weight = 1}) => ExamSection(
  id: 'section-$family',
  familyId: family,
  sectionTimeSec: 60,
  itemCount: 10,
  itemSelection: const ItemSelection.generated(
    generatorId: GeneratorId.dominos,
    difficulty: DifficultyRange(min: 1, max: 5),
    params: GeneratorParams.dominos(),
  ),
  confidence: Confidence.confirmed,
  weight: weight,
);

final ExamBlueprint blueprint = ExamBlueprint(
  id: 'bp',
  version: 1,
  moduleId: ModuleId.psy0,
  name: text,
  description: text,
  confidence: Confidence.confirmed,
  tags: const [],
  sections: [section('logic'), section('english', weight: 2)],
);

FamilyProgress family(
  String id, {
  int attempts = 0,
  int correct = 0,
  int level = 1,
  Trend trend30d = Trend.none,
}) => FamilyProgress(
  familyId: id,
  attempts: attempts,
  correct: correct,
  sessions: attempts == 0 ? 0 : 1,
  level: level,
  trend7d: Trend.none,
  trend30d: trend30d,
);

void main() {
  final service = StatsService(now: () => now);

  group('timeSeries', () {
    test('is empty without rows', () {
      final series = service.timeSeries(familyId: 'english', rows: const []);
      expect(series.isEmpty, isTrue);
      expect(series.latest, isNull);
      expect(series.totalAttempts, 0);
      expect(series.familyId, 'english');
    });

    test('keeps only the family, one point per session, oldest first', () {
      final series = service.timeSeries(
        familyId: 'english',
        rows: [
          row(session: 's2', daysAgo: 1, attempts: 10, correct: 9),
          row(session: 's1', daysAgo: 5, attempts: 10, correct: 5),
          row(session: 'x', daysAgo: 2, attempts: 4, correct: 4, family: 'l'),
        ],
        from: daysAgo(7),
        to: now,
      );
      expect(series.points.map((p) => p.sessionId), ['s1', 's2']);
      expect(series.points.first.accuracy, 0.5);
      expect(series.latest!.accuracy, 0.9);
      expect(series.latest!.at, daysAgo(1));
      expect(series.totalAttempts, 20);
      expect(series.from, daysAgo(7));
      expect(series.to, now);
    });

    test('merges the sections of one exam into one point', () {
      final series = service.timeSeries(
        familyId: 'english',
        rows: [
          row(
            session: 'exam',
            daysAgo: 1,
            attempts: 10,
            correct: 8,
            mode: SessionMode.exam,
            section: 0,
          ),
          row(
            session: 'exam',
            daysAgo: 1,
            attempts: 30,
            correct: 12,
            unanswered: 3,
            median: 2000,
            mode: SessionMode.exam,
            section: 2,
          ),
        ],
      );
      final point = series.points.single;
      expect(point.mode, SessionMode.exam);
      expect(point.attempts, 40);
      expect(point.correct, 20);
      expect(point.unanswered, 3);
      expect(point.accuracy, 0.5);
      // Attempt-weighted mean of the section medians.
      expect(point.medianResponseMs, 1750);
    });
  });

  group('trend', () {
    TrendPoint point(int daysAgo, double accuracy) => TrendPoint(
      sessionId: 'd$daysAgo',
      mode: SessionMode.practice,
      at: now.subtract(Duration(days: daysAgo)),
      attempts: 100,
      correct: (accuracy * 100).round(),
      unanswered: 0,
      medianResponseMs: 1000,
    );

    test('is flat with no or one session', () {
      expect(
        service.trend(const [], window: StatsService.shortWindow),
        Trend.none,
      );
      final single = service.trend([
        point(1, 0.9),
      ], window: StatsService.shortWindow);
      expect(single.direction, TrendDirection.flat);
      expect(single.sessions, 1);
      expect(single.delta, 0);
      expect(single.slope, 0);
    });

    test('goes up with rising accuracy', () {
      final trend = service.trend([
        point(6, 0.5),
        point(4, 0.6),
        point(2, 0.7),
        point(0, 0.8),
      ], window: StatsService.shortWindow);
      expect(trend.direction, TrendDirection.up);
      expect(trend.sessions, 4);
      expect(trend.delta, closeTo(0.3, 1e-9));
      // +0.1 every 2 days = +0.05 / day.
      expect(trend.slope, closeTo(0.05, 1e-9));
    });

    test('goes down with falling accuracy', () {
      final trend = service.trend([
        point(10, 0.9),
        point(5, 0.7),
        point(0, 0.6),
      ], window: StatsService.longWindow);
      expect(trend.direction, TrendDirection.down);
      expect(trend.isNegative, isTrue);
      expect(trend.delta, closeTo(-0.3, 1e-9));
      expect(trend.slope, lessThan(0));
    });

    test('is flat when the delta stays under the threshold', () {
      final trend = service.trend([
        point(3, 0.80),
        point(2, 0.84),
        point(1, 0.82),
        point(0, 0.83),
      ], window: StatsService.shortWindow);
      expect(trend.direction, TrendDirection.flat);
      expect(trend.delta, closeTo(0.03, 1e-9));
      expect(trend.slope, greaterThan(0));
    });

    test('is flat when the delta and the slope disagree', () {
      // Ends higher than it started but the regression line goes down.
      final trend = service.trend([
        point(4, 0.5),
        point(3, 0.95),
        point(2, 0.9),
        point(1, 0.3),
        point(0, 0.6),
      ], window: StatsService.shortWindow);
      expect(trend.delta, closeTo(0.1, 1e-9));
      expect(trend.slope, lessThan(0));
      expect(trend.direction, TrendDirection.flat);
    });

    test('ignores sessions outside the window', () {
      final points = [point(40, 0.2), point(20, 0.9), point(3, 0.6)];
      final week = service.trend(points, window: StatsService.shortWindow);
      expect(week.sessions, 1);
      expect(week.direction, TrendDirection.flat);
      final month = service.trend(points, window: StatsService.longWindow);
      expect(month.sessions, 2);
      expect(month.direction, TrendDirection.down);
      expect(month.delta, closeTo(-0.3, 1e-9));
    });

    test('has a zero slope when every session shares a timestamp', () {
      final trend = service.trend([
        point(1, 0.2),
        point(1, 0.9),
      ], window: StatsService.shortWindow);
      expect(trend.slope, 0);
      expect(trend.direction, TrendDirection.flat);
    });

    test('honours a custom delta threshold', () {
      final strict = StatsService(
        config: const StatsConfig(trendDeltaThreshold: 0.5),
        now: () => now,
      );
      final trend = strict.trend([
        point(2, 0.5),
        point(0, 0.8),
      ], window: StatsService.shortWindow);
      expect(trend.direction, TrendDirection.flat);
    });
  });

  group('levelFor', () {
    test('is 1 under the minimum attempt count whatever the accuracy', () {
      expect(service.levelFor(attempts: 9, accuracy: 1), 1);
      expect(service.levelFor(attempts: 0, accuracy: 0), 1);
    });

    test('climbs one level per threshold reached', () {
      expect(service.levelFor(attempts: 10, accuracy: 0.49), 1);
      expect(service.levelFor(attempts: 10, accuracy: 0.5), 2);
      expect(service.levelFor(attempts: 10, accuracy: 0.649), 2);
      expect(service.levelFor(attempts: 10, accuracy: 0.65), 3);
      expect(service.levelFor(attempts: 10, accuracy: 0.8), 4);
      expect(service.levelFor(attempts: 10, accuracy: 0.9), 5);
      expect(service.levelFor(attempts: 500, accuracy: 1), 5);
    });

    test('uses the configured thresholds and minimum', () {
      final custom = StatsService(
        config: const StatsConfig(
          levelThresholds: [0.2, 0.4, 0.6, 0.8],
          minAttemptsForLevel: 1,
        ),
        now: () => now,
      );
      expect(custom.levelFor(attempts: 1, accuracy: 0.45), 3);
    });
  });

  group('familyProgress', () {
    test('is empty for a family never practised', () {
      final progress = service.familyProgress(
        familyId: 'english',
        series: service.timeSeries(familyId: 'english', rows: const []),
      );
      expect(progress.hasData, isFalse);
      expect(progress.attempts, 0);
      expect(progress.accuracy, 0);
      expect(progress.level, 1);
      expect(progress.levelFraction, 0);
      expect(progress.sessions, 0);
      expect(progress.medianResponseMs, isNull);
      expect(progress.lastPractisedAt, isNull);
      expect(progress.trend7d, Trend.none);
      expect(progress.trend30d, Trend.none);
    });

    test('a single session gives flat trends and lifetime figures', () {
      final rows = [
        row(session: 's1', daysAgo: 2, attempts: 20, correct: 17, median: 850),
      ];
      final progress = service.familyProgress(
        familyId: 'english',
        lifetime: const FamilyStats(
          familyId: 'english',
          attempts: 20,
          correct: 17,
          meanResponseMs: 900,
          medianResponseMs: 850,
        ),
        series: service.timeSeries(familyId: 'english', rows: rows),
      );
      expect(progress.attempts, 20);
      expect(progress.accuracy, 0.85);
      expect(progress.level, 4);
      expect(progress.levelFraction, 0.75);
      expect(progress.sessions, 1);
      expect(progress.medianResponseMs, 850);
      expect(progress.lastPractisedAt, daysAgo(2));
      expect(progress.trend7d.direction, TrendDirection.flat);
      expect(progress.trend7d.sessions, 1);
    });

    test('all timeouts: zero accuracy, level 1, still counted', () {
      final rows = [
        row(
          session: 's1',
          daysAgo: 1,
          attempts: 12,
          correct: 0,
          unanswered: 12,
          median: 5000,
        ),
      ];
      final progress = service.familyProgress(
        familyId: 'english',
        lifetime: const FamilyStats(
          familyId: 'english',
          attempts: 12,
          correct: 0,
          meanResponseMs: 5000,
          medianResponseMs: 5000,
        ),
        series: service.timeSeries(familyId: 'english', rows: rows),
      );
      expect(progress.hasData, isTrue);
      expect(progress.accuracy, 0);
      expect(progress.level, 1);
      expect(progress.medianResponseMs, 5000);
    });

    test('falls back to the series when no lifetime aggregate is given', () {
      final rows = [
        row(session: 's1', daysAgo: 9, attempts: 10, correct: 4),
        row(session: 's2', daysAgo: 1, attempts: 30, correct: 27, median: 600),
      ];
      final progress = service.familyProgress(
        familyId: 'english',
        series: service.timeSeries(familyId: 'english', rows: rows),
      );
      expect(progress.attempts, 40);
      expect(progress.correct, 31);
      expect(progress.medianResponseMs, 700);
      expect(progress.sessions, 2);
      expect(progress.trend7d.sessions, 1);
      expect(progress.trend30d.direction, TrendDirection.up);
      expect(progress.trend30d.delta, closeTo(0.5, 1e-9));
    });
  });

  group('examSummary', () {
    test('without attempts nor blueprint scores 0', () {
      final summary = service.examSummary(
        session: examSession('e1', daysAgo: 1, blueprintId: null),
        rows: const [],
      );
      expect(summary.score, 0);
      expect(summary.percent, 0);
      expect(summary.sections, isEmpty);
      expect(summary.attempts, 0);
      expect(summary.deltaVsPrevious, isNull);
      expect(summary.previousSessionId, isNull);
      expect(summary.blueprintId, isNull);
    });

    test('weights sections by the blueprint and lists unreached ones', () {
      final summary = service.examSummary(
        session: examSession('e1', daysAgo: 1),
        rows: [
          row(
            session: 'e1',
            daysAgo: 1,
            attempts: 10,
            correct: 5,
            family: 'logic',
            mode: SessionMode.exam,
            section: 0,
            median: 700,
          ),
          row(
            session: 'other',
            daysAgo: 1,
            attempts: 10,
            correct: 10,
            family: 'logic',
            mode: SessionMode.exam,
            section: 0,
          ),
        ],
        blueprint: blueprint,
      );
      expect(summary.sections, hasLength(2));
      final logic = summary.sections[0];
      expect(logic.sectionIndex, 0);
      expect(logic.familyId, 'logic');
      expect(logic.accuracy, 0.5);
      expect(logic.weight, 1);
      expect(logic.medianResponseMs, 700);
      final english = summary.sections[1];
      expect(english.sectionIndex, 1);
      expect(english.familyId, 'english');
      expect(english.attempts, 0);
      expect(english.accuracy, 0);
      expect(english.weight, 2);
      expect(english.medianResponseMs, isNull);
      // (0.5 * 1 + 0 * 2) / 3
      expect(summary.score, closeTo(1 / 6, 1e-9));
      expect(summary.percent, 17);
      expect(summary.attempts, 10);
      expect(summary.correct, 5);
    });

    test('without a blueprint uses the sections seen, weight 1', () {
      final summary = service.examSummary(
        session: examSession('e1', daysAgo: 1, blueprintId: null),
        rows: [
          row(
            session: 'e1',
            daysAgo: 1,
            attempts: 10,
            correct: 8,
            family: 'logic',
            mode: SessionMode.exam,
            section: 1,
          ),
          row(
            session: 'e1',
            daysAgo: 1,
            attempts: 10,
            correct: 2,
            unanswered: 6,
            mode: SessionMode.exam,
            section: 0,
          ),
        ],
      );
      expect(summary.sections.map((s) => s.sectionIndex), [0, 1]);
      expect(summary.sections.map((s) => s.familyId), ['english', 'logic']);
      expect(summary.sections.first.unanswered, 6);
      expect(summary.score, closeTo(0.5, 1e-9));
    });

    test('rows outside the blueprint are appended with weight 1', () {
      final summary = service.examSummary(
        session: examSession('e1', daysAgo: 1),
        rows: [
          row(
            session: 'e1',
            daysAgo: 1,
            attempts: 10,
            correct: 10,
            family: 'memory',
            mode: SessionMode.exam,
            section: 7,
          ),
        ],
        blueprint: blueprint,
      );
      expect(summary.sections.map((s) => s.sectionIndex), [0, 1, 7]);
      expect(summary.sections.last.weight, 1);
      expect(summary.score, closeTo(1 / 4, 1e-9));
    });

    test('computes the delta against the previous summary', () {
      final previous = service.examSummary(
        session: examSession('e0', daysAgo: 3),
        rows: [
          row(
            session: 'e0',
            daysAgo: 3,
            attempts: 10,
            correct: 4,
            family: 'logic',
            mode: SessionMode.exam,
            section: 0,
          ),
        ],
      );
      final summary = service.examSummary(
        session: examSession('e1', daysAgo: 1),
        rows: [
          row(
            session: 'e1',
            daysAgo: 1,
            attempts: 10,
            correct: 7,
            family: 'logic',
            mode: SessionMode.exam,
            section: 0,
          ),
        ],
        previous: previous,
      );
      expect(summary.previousSessionId, 'e0');
      expect(summary.deltaVsPrevious, closeTo(0.3, 1e-9));
    });
  });

  group('examHistory', () {
    final rows = [
      for (final (id, days, correct) in [
        ('e1', 10, 4),
        ('e2', 5, 6),
        ('e3', 1, 9),
        ('other', 2, 10),
        ('left', 3, 1),
      ])
        row(
          session: id,
          daysAgo: days,
          attempts: 10,
          correct: correct,
          family: 'logic',
          mode: SessionMode.exam,
          section: 0,
        ),
    ];
    final sessions = [
      examSession('e3', daysAgo: 1),
      examSession('other', daysAgo: 2, blueprintId: 'bp2'),
      examSession('left', daysAgo: 3, status: SessionStatus.abandoned),
      examSession('e2', daysAgo: 5),
      examSession('e1', daysAgo: 10),
    ];

    test('is newest first with deltas against the previous completed one', () {
      final history = service.examHistory(
        sessions: sessions,
        rows: rows,
        blueprints: {'bp': blueprint},
      );
      expect(history.map((e) => e.sessionId), [
        'e3',
        'other',
        'left',
        'e2',
        'e1',
      ]);
      final byId = {for (final e in history) e.sessionId: e};
      expect(byId['e1']!.deltaVsPrevious, isNull);
      expect(byId['e2']!.previousSessionId, 'e1');
      // Blueprint bp: logic weight 1, english (unreached) weight 2.
      expect(byId['e2']!.score, closeTo(0.6 / 3, 1e-9));
      expect(byId['e2']!.deltaVsPrevious, closeTo(0.2 / 3, 1e-9));
      // The abandoned one gets a delta but is not a reference point.
      expect(byId['left']!.status, SessionStatus.abandoned);
      expect(byId['left']!.previousSessionId, 'e2');
      expect(byId['e3']!.previousSessionId, 'e2');
      expect(byId['e3']!.deltaVsPrevious, closeTo(0.3 / 3, 1e-9));
      // Another blueprint (unknown to content) has its own chain.
      expect(byId['other']!.previousSessionId, isNull);
      expect(byId['other']!.score, 1);
      expect(byId['other']!.sections.single.weight, 1);
    });

    test('is empty without sessions', () {
      expect(service.examHistory(sessions: const [], rows: rows), isEmpty);
    });
  });

  group('readiness', () {
    test('is 0 with no data at all', () {
      final score = service.readiness(
        families: const [],
        lessonsRead: 0,
        lessonsTotal: 0,
        exams: const [],
      );
      expect(score.value, 0);
      expect(score.rounded, 0);
      expect(score.hasAnyData, isFalse);
      expect(score.familyComponent, 0);
      expect(score.lessonComponent, 0);
      expect(score.examComponent, 0);
      expect(score.familiesTotal, 0);
    });

    test('is 100 when everything is maxed', () {
      final score = service.readiness(
        families: [
          family('logic_dominos', attempts: 50, correct: 50, level: 5),
        ],
        lessonsRead: 4,
        lessonsTotal: 4,
        exams: [
          service.examSummary(
            session: examSession('e', daysAgo: 1),
            rows: [
              row(
                session: 'e',
                daysAgo: 1,
                attempts: 10,
                correct: 10,
                family: 'logic',
                mode: SessionMode.exam,
                section: 0,
              ),
            ],
          ),
        ],
      );
      expect(score.value, closeTo(100, 1e-9));
      expect(score.hasAnyData, isTrue);
      expect(score.familiesPractised, 1);
      expect(score.examsCounted, 1);
    });

    test('weights MVP families double and unpractised ones as level 1', () {
      // logic_dominos (w2) level 5 -> 1.0; planning_tubes (w1) level 3 -> 0.5;
      // unknown (w1) never practised -> 0.
      final score = service.readiness(
        families: [
          family('logic_dominos', attempts: 50, correct: 48, level: 5),
          family('planning_tubes', attempts: 50, correct: 35, level: 3),
          family('unknown_family'),
        ],
        lessonsRead: 0,
        lessonsTotal: 10,
        exams: const [],
      );
      expect(score.familyComponent, closeTo((2 * 1 + 1 * 0.5 + 0) / 4, 1e-9));
      expect(score.familiesPractised, 2);
      expect(score.familiesTotal, 3);
      expect(score.lessonComponent, 0);
      expect(score.examComponent, 0);
      // 0.6 * 0.625 = 0.375 -> 37.5
      expect(score.value, closeTo(37.5, 1e-9));
      expect(score.rounded, 38);
    });

    test('mixes the three components with the configured weights', () {
      final custom = StatsService(
        config: const StatsConfig(
          readinessWeights: ReadinessWeights(families: 1, lessons: 1, exams: 2),
          recentExamCount: 2,
        ),
        now: () => now,
      );
      ExamSummary exam(String id, int days, double score) => ExamSummary(
        sessionId: id,
        startedAt: daysAgo(days),
        status: SessionStatus.completed,
        score: score,
        sections: const [],
      );
      final score = custom.readiness(
        families: [family('f', attempts: 20, correct: 15, level: 3)],
        lessonsRead: 3,
        lessonsTotal: 4,
        exams: [
          exam('e3', 1, 0.8),
          ExamSummary(
            sessionId: 'left',
            startedAt: daysAgo(2),
            status: SessionStatus.abandoned,
            score: 0.1,
            sections: const [],
          ),
          exam('e2', 3, 0.6),
          exam('e1', 9, 0.1),
        ],
      );
      expect(score.familyComponent, 0.5);
      expect(score.lessonComponent, 0.75);
      // Latest two completed exams: (0.8 + 0.6) / 2.
      expect(score.examComponent, closeTo(0.7, 1e-9));
      expect(score.examsCounted, 2);
      // (0.5 * 1 + 0.75 * 1 + 0.7 * 2) / 4 = 0.6625
      expect(score.value, closeTo(66.25, 1e-9));
    });

    test('caps lessons read at the total', () {
      final score = service.readiness(
        families: const [],
        lessonsRead: 7,
        lessonsTotal: 5,
        exams: const [],
      );
      expect(score.lessonsRead, 5);
      expect(score.lessonComponent, 1);
      expect(score.value, closeTo(15, 1e-9));
    });
  });

  group('weakAreas', () {
    const down = Trend(
      direction: TrendDirection.down,
      slope: -0.02,
      delta: -0.1,
      sessions: 3,
    );

    test('is empty without data', () {
      expect(service.weakAreas(families: const []), isEmpty);
      expect(service.weakAreas(families: [family('f')]), isEmpty);
    });

    test('flags low accuracy (with enough attempts) and negative trends', () {
      final areas = service.weakAreas(
        families: [
          family('fine', attempts: 40, correct: 36),
          family('low', attempts: 40, correct: 20),
          family('few', attempts: 5),
          family('falling', attempts: 40, correct: 36, trend30d: down),
          family('both', attempts: 40, correct: 10, trend30d: down),
        ],
      );
      expect(areas.map((a) => a.id), ['both', 'low', 'falling']);
      expect(areas[0].reasons, {
        WeakAreaReason.lowAccuracy,
        WeakAreaReason.negativeTrend,
      });
      expect(areas[0].accuracy, 0.25);
      expect(areas[0].trend, down);
      expect(areas[0].isFamily, isTrue);
      expect(areas[1].reasons, {WeakAreaReason.lowAccuracy});
      expect(areas[2].reasons, {WeakAreaReason.negativeTrend});
      expect(areas[2].accuracy, 0.9);
    });

    test('appends weak tags after the families', () {
      final areas = service.weakAreas(
        families: [family('low', attempts: 40, correct: 20)],
        tags: {
          'english.grammar': (attempts: 20, correct: 8),
          'english.vocab': (attempts: 20, correct: 18),
          'english.reading': (attempts: 3, correct: 0),
          'arith.time': (attempts: 12, correct: 2),
        },
      );
      expect(areas.map((a) => a.id), ['low', 'arith.time', 'english.grammar']);
      expect(areas[1].kind, WeakAreaKind.tag);
      expect(areas[1].reasons, {WeakAreaReason.lowAccuracy});
      expect(areas[1].trend, isNull);
      expect(areas[2].accuracy, 0.4);
    });

    test('uses the configured threshold and minimum', () {
      final strict = StatsService(
        config: const StatsConfig(
          weakAccuracyThreshold: 0.95,
          minAttemptsForWeakArea: 2,
        ),
        now: () => now,
      );
      final areas = strict.weakAreas(
        families: [family('good', attempts: 2, correct: 1)],
      );
      expect(areas.single.id, 'good');
    });
  });

  group('tagAccuracy', () {
    test('folds item stats into their tags', () {
      ItemStat stat(String id, int seen, int correct) => ItemStat(
        itemId: id,
        familyId: 'english',
        seen: seen,
        correct: correct,
        totalResponseMs: 1000 * seen,
        lastCorrect: true,
        lastSeenAt: now,
      );
      final tags = StatsService.tagAccuracy(
        itemStats: [stat('a', 4, 1), stat('b', 6, 6), stat('orphan', 9, 0)],
        tagsByItem: {
          'a': ['grammar', 'grammar.tenses'],
          'b': ['grammar'],
        },
      );
      expect(tags, {
        'grammar': (attempts: 10, correct: 7),
        'grammar.tenses': (attempts: 4, correct: 1),
      });
    });
  });
}
