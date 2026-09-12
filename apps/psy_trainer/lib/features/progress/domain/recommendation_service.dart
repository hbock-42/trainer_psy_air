import 'family_progress.dart';
import 'readiness_score.dart';
import 'recommendation.dart';
import 'stats_config.dart';
import 'weak_area.dart';

/// A family with attempts but at least one unread lesson (the caller finds
/// these by joining `ContentRepository.lessons(familyId:)` against
/// `ProgressRepository.lessonsRead()`); [lessonId] is the one to suggest.
typedef MissingLesson = ({String familyId, String lessonId});

/// Turns the dashboard's weak areas and readiness (US-075) plus a few extra
/// repository facts into "what to do next" (US-072): the top 3 weakest
/// families/tags to train, ranked by severity, and rule-based nudges (try a
/// simulation, read a lesson, clear the flashcard backlog).
///
/// Pure Dart with an injectable clock, exactly like [StatsService]; the
/// providers fetch the extra rows (last completed simulation, families
/// missing a lesson, due flashcard count) and call in here. Family/tag
/// display names are resolved by the caller (locale-aware, from
/// `DashboardLabels`) and passed in, so this stays presentation-agnostic.
class RecommendationService {
  const RecommendationService({
    this.config = const StatsConfig(),
    DateTime Function() now = DateTime.now,
  }) : _now = now;

  final StatsConfig config;
  final DateTime Function() _now;

  DateTime get now => _now().toUtc();

  /// How many ranked weak areas lead the "train next" section.
  static const int maxTrainNext = 3;

  /// A simulation is only suggested once readiness clears this (0..100).
  static const double examReadinessFloor = 50;

  /// A simulation is suggested when none *completed* within this window.
  static const Duration examRecencyWindow = Duration(days: 7);

  /// Flashcards due strictly above this many trigger the nudge.
  static const int dueFlashcardsThreshold = 10;

  // --- Train next (ranked) ---------------------------------------------------

  /// The top [maxTrainNext] of [weakAreas] (already families-then-tags,
  /// weakest first, per `StatsService.weakAreas`) re-ranked by severity:
  /// how far under the accuracy threshold, how long since it was last
  /// practised, and the family's readiness weight (MVP families weigh
  /// double, see `StatsConfig.familyWeights`). Tags carry no practice date
  /// and weigh 1.
  List<Recommendation> trainNext({
    required List<WeakArea> weakAreas,
    required List<FamilyProgress> families,
    Map<String, String> familyNames = const {},
    String Function(String tag)? tagLabel,
  }) {
    final familyById = {for (final f in families) f.familyId: f};
    final scored = <Recommendation>[
      for (final area in weakAreas)
        _trainNextRecommendation(
          area,
          severity: _severity(area, familyById[area.id]),
          familyNames: familyNames,
          tagLabel: tagLabel,
        ),
    ]..sort((a, b) => b.severity.compareTo(a.severity));
    return scored.take(maxTrainNext).toList();
  }

  Recommendation _trainNextRecommendation(
    WeakArea area, {
    required double severity,
    required Map<String, String> familyNames,
    String Function(String tag)? tagLabel,
  }) {
    final name = area.isFamily
        ? (familyNames[area.id] ?? area.id)
        : (tagLabel?.call(area.id) ?? area.id);
    return Recommendation(
      kind: area.isFamily ? RecommendationKind.family : RecommendationKind.tag,
      title: name,
      reason: _weakAreaReason(area, name),
      severity: severity,
      targetId: area.id,
    );
  }

  double _severity(WeakArea area, FamilyProgress? family) {
    final gap = (config.weakAccuracyThreshold - area.accuracy).clamp(0.0, 1.0);
    // A family flagged only for its trend (accuracy already >= threshold)
    // still ranks, just below any accuracy-driven gap.
    final accuracyGap = gap == 0 ? 0.05 : gap;
    final lastPractised = family?.lastPractisedAt;
    final recencyDays = lastPractised == null
        ? 30
        : now.difference(lastPractised).inDays.clamp(0, 30);
    final recency = 1 + recencyDays / 30; // 1..2, oldest practice ranks up
    final weight = area.isFamily ? config.weightOf(area.id) : 1.0;
    return accuracyGap * recency * weight;
  }

  static String _weakAreaReason(WeakArea area, String name) {
    final percent = (area.accuracy * 100).round();
    final trend = area.reasons.contains(WeakAreaReason.negativeTrend)
        ? ', en baisse'
        : '';
    return 'précision $percent % sur $name$trend';
  }

  // --- Rule-based extras ------------------------------------------------------

  /// Nudges outside the weak-area ranking: a missed simulation (readiness
  /// above [examReadinessFloor] and no *completed* one within
  /// [examRecencyWindow]), the first family with attempts but an unread
  /// lesson, and a flashcard backlog above [dueFlashcardsThreshold].
  List<Recommendation> extras({
    required ReadinessScore readiness,
    DateTime? lastCompletedExamAt,
    List<MissingLesson> missingLessons = const [],
    Map<String, String> familyNames = const {},
    int dueFlashcardsCount = 0,
  }) {
    final result = <Recommendation>[];

    final daysSinceExam = lastCompletedExamAt == null
        ? null
        : now.difference(lastCompletedExamAt).inDays;
    if (readiness.value > examReadinessFloor &&
        (daysSinceExam == null || daysSinceExam >= examRecencyWindow.inDays)) {
      result.add(
        Recommendation(
          kind: RecommendationKind.examSim,
          title: 'Fais une simulation',
          reason: lastCompletedExamAt == null
              ? 'aucune simulation complétée pour le moment'
              : 'aucune simulation depuis $daysSinceExam jours',
          severity: 0,
        ),
      );
    }

    if (missingLessons.isNotEmpty) {
      final missing = missingLessons.first;
      final name = familyNames[missing.familyId] ?? missing.familyId;
      result.add(
        Recommendation(
          kind: RecommendationKind.lesson,
          title: 'Lis la leçon : $name',
          reason: 'des tentatives sur $name sans avoir lu la leçon',
          severity: 0,
          targetId: missing.familyId,
          secondaryId: missing.lessonId,
        ),
      );
    }

    if (dueFlashcardsCount > dueFlashcardsThreshold) {
      result.add(
        Recommendation(
          kind: RecommendationKind.flashcards,
          title: 'Cartes à réviser',
          reason: '$dueFlashcardsCount cartes en attente',
          severity: 0,
        ),
      );
    }

    return result;
  }

  // --- Everything the card shows ----------------------------------------------

  /// [trainNext] followed by [extras]: everything the "Train next" card
  /// shows, in the order it shows it.
  List<Recommendation> recommendations({
    required List<WeakArea> weakAreas,
    required List<FamilyProgress> families,
    required ReadinessScore readiness,
    DateTime? lastCompletedExamAt,
    List<MissingLesson> missingLessons = const [],
    Map<String, String> familyNames = const {},
    String Function(String tag)? tagLabel,
    int dueFlashcardsCount = 0,
  }) => [
    ...trainNext(
      weakAreas: weakAreas,
      families: families,
      familyNames: familyNames,
      tagLabel: tagLabel,
    ),
    ...extras(
      readiness: readiness,
      lastCompletedExamAt: lastCompletedExamAt,
      missingLessons: missingLessons,
      familyNames: familyNames,
      dueFlashcardsCount: dueFlashcardsCount,
    ),
  ];
}
