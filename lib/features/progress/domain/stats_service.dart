import 'dart:math' as math;

import '../../../core/content/model/exam_blueprint.dart';
import '../../../core/repositories/model/session.dart';
import '../../../core/repositories/model/stats.dart';
import 'exam_summary.dart';
import 'family_progress.dart';
import 'readiness_score.dart';
import 'stats_config.dart';
import 'time_series.dart';
import 'weak_area.dart';

/// Lifetime accuracy of one item tag, folded from [ItemStat]s.
typedef TagAccuracy = ({int attempts, int correct});

/// Every aggregate the app shows or decides on (US-075), as pure functions
/// of repository rows: per-family progress, chart series, exam summaries,
/// the readiness score and weak areas. No I/O; `ProgressAnalytics` fetches
/// the rows and calls in here, and the unit tests feed fixtures directly.
///
/// Activity-specific metrics are treated generically: an attempt is correct
/// or not, took `responseMs`, and was answered or not (timeout). Engines
/// that need more (restarts, violations) put it in the attempt's `answer`
/// json and read it themselves.
///
/// Formulas are documented in `docs/ARCHITECTURE.md`, "Progress / analytics".
class StatsService {
  const StatsService({
    this.config = const StatsConfig(),
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  final StatsConfig config;
  final DateTime Function() _now;

  static const Duration shortWindow = Duration(days: 7);
  static const Duration longWindow = Duration(days: 30);

  DateTime get now => _now().toUtc();

  // --- Time series ----------------------------------------------------------

  /// The chart series of [familyId] from per-session rows (any family, any
  /// order): one point per session, oldest first. Rows of the same session
  /// (an exam with two sections of the family) are merged: counts add up and
  /// the median becomes the attempt-weighted mean of the section medians.
  TimeSeries timeSeries({
    required String familyId,
    required Iterable<SessionFamilyStats> rows,
    DateTime? from,
    DateTime? to,
  }) {
    final bySession = <String, List<SessionFamilyStats>>{};
    for (final row in rows) {
      if (row.familyId != familyId) continue;
      bySession.putIfAbsent(row.sessionId, () => []).add(row);
    }
    final points = [for (final group in bySession.values) _mergePoint(group)]
      ..sort((a, b) {
        final byTime = a.at.compareTo(b.at);
        return byTime != 0 ? byTime : a.sessionId.compareTo(b.sessionId);
      });
    return TimeSeries(familyId: familyId, points: points, from: from, to: to);
  }

  static TrendPoint _mergePoint(List<SessionFamilyStats> group) {
    final first = group.first;
    var attempts = 0;
    var correct = 0;
    var unanswered = 0;
    var weightedMedian = 0.0;
    for (final row in group) {
      attempts += row.attempts;
      correct += row.correct;
      unanswered += row.unanswered;
      weightedMedian += row.medianResponseMs * row.attempts;
    }
    return TrendPoint(
      sessionId: first.sessionId,
      mode: first.mode,
      at: first.startedAt,
      attempts: attempts,
      correct: correct,
      unanswered: unanswered,
      medianResponseMs: attempts == 0 ? 0 : weightedMedian / attempts,
    );
  }

  // --- Trend ----------------------------------------------------------------

  /// Accuracy trend over the sessions of the last [window] (ending now).
  /// See [Trend] for the slope/delta/direction semantics.
  Trend trend(Iterable<TrendPoint> points, {required Duration window}) {
    final cutoff = now.subtract(window);
    final recent = points.where((p) => !p.at.isBefore(cutoff)).toList()
      ..sort((a, b) => a.at.compareTo(b.at));
    if (recent.length < 2) {
      return Trend.none.copyWith(sessions: recent.length);
    }
    final origin = recent.first.at;
    final xs = [
      for (final p in recent)
        p.at.difference(origin).inMilliseconds / Duration.millisecondsPerDay,
    ];
    final ys = [for (final p in recent) p.accuracy];
    final n = recent.length;
    final xMean = xs.reduce((a, b) => a + b) / n;
    final yMean = ys.reduce((a, b) => a + b) / n;
    var sxy = 0.0;
    var sxx = 0.0;
    for (var i = 0; i < n; i++) {
      sxy += (xs[i] - xMean) * (ys[i] - yMean);
      sxx += (xs[i] - xMean) * (xs[i] - xMean);
    }
    final slope = sxx == 0 ? 0.0 : sxy / sxx;
    final delta = ys.last - ys.first;
    final threshold = config.trendDeltaThreshold;
    final direction = delta >= threshold && slope > 0
        ? TrendDirection.up
        : delta <= -threshold && slope < 0
        ? TrendDirection.down
        : TrendDirection.flat;
    return Trend(direction: direction, slope: slope, delta: delta, sessions: n);
  }

  // --- Level ----------------------------------------------------------------

  /// 1..5 from lifetime accuracy: level 1 below the first threshold or with
  /// fewer than `minAttemptsForLevel` attempts, then one level per
  /// threshold reached.
  int levelFor({required int attempts, required double accuracy}) {
    if (attempts < config.minAttemptsForLevel) return FamilyProgress.minLevel;
    var level = FamilyProgress.minLevel;
    for (final threshold in config.levelThresholds) {
      if (accuracy >= threshold) level++;
    }
    return math.min(level, FamilyProgress.maxLevel);
  }

  // --- Family progress ------------------------------------------------------

  /// Dashboard row of one family. [lifetime] is the all-time SQL aggregate
  /// (null when the family was never practised); [series] its per-session
  /// series, which drives trends, session count and last practised date.
  FamilyProgress familyProgress({
    required String familyId,
    required TimeSeries series,
    FamilyStats? lifetime,
  }) {
    final attempts = lifetime?.attempts ?? series.totalAttempts;
    final correct =
        lifetime?.correct ??
        series.points.fold<int>(0, (s, p) => s + p.correct);
    final accuracy = attempts == 0 ? 0.0 : correct / attempts;
    return FamilyProgress(
      familyId: familyId,
      attempts: attempts,
      correct: correct,
      sessions: series.points.length,
      level: levelFor(attempts: attempts, accuracy: accuracy),
      trend7d: trend(series.points, window: shortWindow),
      trend30d: trend(series.points, window: longWindow),
      medianResponseMs: attempts == 0
          ? null
          : lifetime?.medianResponseMs ?? _weightedMedian(series.points),
      lastPractisedAt: series.latest?.at,
    );
  }

  static double _weightedMedian(List<TrendPoint> points) {
    var attempts = 0;
    var sum = 0.0;
    for (final p in points) {
      attempts += p.attempts;
      sum += p.medianResponseMs * p.attempts;
    }
    return attempts == 0 ? 0 : sum / attempts;
  }

  // --- Exams ----------------------------------------------------------------

  /// Summary of one exam session from its per-section rows (rows of other
  /// sessions are ignored). With a [blueprint], every section appears (0
  /// when never reached) weighted by `ExamSection.weight`; without one the
  /// sections are those seen in the rows, weight 1. [previous] is the
  /// simulation to compute the delta against.
  ExamSummary examSummary({
    required TrainingSession session,
    required Iterable<SessionFamilyStats> rows,
    ExamBlueprint? blueprint,
    ExamSummary? previous,
  }) {
    final bySection = <int, List<SessionFamilyStats>>{};
    for (final row in rows) {
      if (row.sessionId != session.id) continue;
      bySection.putIfAbsent(row.sectionIndex ?? 0, () => []).add(row);
    }
    final sections = <SectionScore>[];
    if (blueprint != null) {
      for (var i = 0; i < blueprint.sections.length; i++) {
        final spec = blueprint.sections[i];
        sections.add(
          _section(
            i,
            bySection.remove(i) ?? const [],
            familyId: spec.familyId,
            weight: spec.weight,
          ),
        );
      }
    }
    final extra = bySection.keys.toList()..sort();
    for (final index in extra) {
      sections.add(_section(index, bySection[index]!));
    }
    var weighted = 0.0;
    var weights = 0.0;
    for (final s in sections) {
      weighted += s.accuracy * s.weight;
      weights += s.weight;
    }
    final score = weights == 0 ? 0.0 : weighted / weights;
    return ExamSummary(
      sessionId: session.id,
      blueprintId: session.blueprintId,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      status: session.status,
      score: score,
      sections: sections,
      previousSessionId: previous?.sessionId,
      deltaVsPrevious: previous == null ? null : score - previous.score,
    );
  }

  static SectionScore _section(
    int index,
    List<SessionFamilyStats> rows, {
    String? familyId,
    double weight = 1,
  }) {
    var attempts = 0;
    var correct = 0;
    var unanswered = 0;
    var weightedMedian = 0.0;
    for (final row in rows) {
      attempts += row.attempts;
      correct += row.correct;
      unanswered += row.unanswered;
      weightedMedian += row.medianResponseMs * row.attempts;
    }
    return SectionScore(
      sectionIndex: index,
      familyId: familyId ?? rows.first.familyId,
      attempts: attempts,
      correct: correct,
      unanswered: unanswered,
      weight: weight,
      medianResponseMs: attempts == 0 ? null : weightedMedian / attempts,
    );
  }

  /// Summaries of the given exam [sessions] (any order), newest first, each
  /// with its delta against the previous *completed* simulation of the same
  /// blueprint. [blueprints] is keyed by blueprint id; missing ones fall
  /// back to the sections seen in the rows.
  List<ExamSummary> examHistory({
    required Iterable<TrainingSession> sessions,
    required Iterable<SessionFamilyStats> rows,
    Map<String, ExamBlueprint> blueprints = const {},
  }) {
    final ordered = sessions.toList()
      ..sort((a, b) {
        final byTime = a.startedAt.compareTo(b.startedAt);
        return byTime != 0 ? byTime : a.id.compareTo(b.id);
      });
    final rowsBySession = <String, List<SessionFamilyStats>>{};
    for (final row in rows) {
      rowsBySession.putIfAbsent(row.sessionId, () => []).add(row);
    }
    final lastCompleted = <String?, ExamSummary>{};
    final summaries = <ExamSummary>[];
    for (final session in ordered) {
      final summary = examSummary(
        session: session,
        rows: rowsBySession[session.id] ?? const [],
        blueprint: blueprints[session.blueprintId],
        previous: lastCompleted[session.blueprintId],
      );
      summaries.add(summary);
      if (session.status == SessionStatus.completed) {
        lastCompleted[session.blueprintId] = summary;
      }
    }
    return summaries.reversed.toList();
  }

  // --- Readiness ------------------------------------------------------------

  /// 0..100 = weighted mix (see `StatsConfig.readinessWeights`) of the
  /// family component (weighted mean of level fractions over [families]),
  /// the lesson component (`lessonsRead / lessonsTotal`) and the exam
  /// component (mean score of the latest `recentExamCount` completed
  /// [exams], given newest first).
  ReadinessScore readiness({
    required Iterable<FamilyProgress> families,
    required int lessonsRead,
    required int lessonsTotal,
    required Iterable<ExamSummary> exams,
  }) {
    var weightedLevels = 0.0;
    var weights = 0.0;
    var practised = 0;
    var total = 0;
    for (final family in families) {
      final weight = config.weightOf(family.familyId);
      weightedLevels += family.levelFraction * weight;
      weights += weight;
      total++;
      if (family.hasData) practised++;
    }
    final familyComponent = weights == 0 ? 0.0 : weightedLevels / weights;

    final read = math.min(lessonsRead, lessonsTotal);
    final lessonComponent = lessonsTotal == 0 ? 0.0 : read / lessonsTotal;

    final recent = exams
        .where((e) => e.status == SessionStatus.completed)
        .take(config.recentExamCount)
        .toList();
    final examComponent = recent.isEmpty
        ? 0.0
        : recent.fold(0.0, (s, e) => s + e.score) / recent.length;

    final w = config.readinessWeights;
    final mixed =
        (familyComponent * w.families +
            lessonComponent * w.lessons +
            examComponent * w.exams) /
        w.total;
    return ReadinessScore(
      value: (mixed * 100).clamp(0, 100).toDouble(),
      familyComponent: familyComponent,
      lessonComponent: lessonComponent,
      examComponent: examComponent,
      familiesPractised: practised,
      familiesTotal: total,
      lessonsRead: read,
      lessonsTotal: lessonsTotal,
      examsCounted: recent.length,
    );
  }

  // --- Weak areas -----------------------------------------------------------

  /// Families whose lifetime accuracy is below the threshold (with enough
  /// attempts) or whose 30-day trend is negative, then tags below the
  /// threshold; each group weakest first.
  List<WeakArea> weakAreas({
    required Iterable<FamilyProgress> families,
    Map<String, TagAccuracy> tags = const {},
  }) {
    final result = <WeakArea>[];
    for (final family in families) {
      final reasons = <WeakAreaReason>{
        if (family.attempts >= config.minAttemptsForWeakArea &&
            family.accuracy < config.weakAccuracyThreshold)
          WeakAreaReason.lowAccuracy,
        if (family.trend30d.isNegative) WeakAreaReason.negativeTrend,
      };
      if (reasons.isEmpty) continue;
      result.add(
        WeakArea(
          kind: WeakAreaKind.family,
          id: family.familyId,
          reasons: reasons,
          accuracy: family.accuracy,
          attempts: family.attempts,
          trend: family.trend30d,
        ),
      );
    }
    result.sort(_byAccuracyThenId);
    final weakTags = <WeakArea>[];
    for (final MapEntry(key: tag, value: stat) in tags.entries) {
      if (stat.attempts < config.minAttemptsForWeakArea) continue;
      final accuracy = stat.correct / stat.attempts;
      if (accuracy >= config.weakAccuracyThreshold) continue;
      weakTags.add(
        WeakArea(
          kind: WeakAreaKind.tag,
          id: tag,
          reasons: const {WeakAreaReason.lowAccuracy},
          accuracy: accuracy,
          attempts: stat.attempts,
        ),
      );
    }
    weakTags.sort(_byAccuracyThenId);
    return result..addAll(weakTags);
  }

  static int _byAccuracyThenId(WeakArea a, WeakArea b) {
    final byAccuracy = a.accuracy.compareTo(b.accuracy);
    return byAccuracy != 0 ? byAccuracy : a.id.compareTo(b.id);
  }

  /// Folds bank-item stats into per-tag accuracy, given each item's tags
  /// (items absent from [tagsByItem] are skipped).
  static Map<String, TagAccuracy> tagAccuracy({
    required Iterable<ItemStat> itemStats,
    required Map<String, List<String>> tagsByItem,
  }) {
    final result = <String, TagAccuracy>{};
    for (final stat in itemStats) {
      for (final tag in tagsByItem[stat.itemId] ?? const <String>[]) {
        final old = result[tag] ?? (attempts: 0, correct: 0);
        result[tag] = (
          attempts: old.attempts + stat.seen,
          correct: old.correct + stat.correct,
        );
      }
    }
    return result;
  }
}
