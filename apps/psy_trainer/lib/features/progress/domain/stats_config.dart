/// Tunable constants of the stats service (US-075). One instance is the
/// single source of truth for the dashboard (US-070), adaptive difficulty
/// (US-053) and recommendations (US-073); tests pass a custom one.
///
/// Every formula that uses these numbers is documented in
/// `docs/ARCHITECTURE.md`, "Progress / analytics".
class StatsConfig {
  const StatsConfig({
    this.familyWeights = defaultFamilyWeights,
    this.defaultFamilyWeight = 1.0,
    this.readinessWeights = const ReadinessWeights(),
    this.levelThresholds = const [0.5, 0.65, 0.8, 0.9],
    this.minAttemptsForLevel = 10,
    this.weakAccuracyThreshold = 0.6,
    this.minAttemptsForWeakArea = 10,
    this.trendDeltaThreshold = 0.05,
    this.recentExamCount = 3,
  }) : assert(recentExamCount > 0, 'at least one exam feeds readiness');

  /// Weight of each family in the family component of the readiness score.
  /// MVP families (EPIC-03) count double; families absent from the map get
  /// [defaultFamilyWeight].
  final Map<String, double> familyWeights;
  final double defaultFamilyWeight;

  /// Relative weights of the three readiness components.
  final ReadinessWeights readinessWeights;

  /// Accuracy floors of levels 2, 3, 4 and 5 (ascending, exactly four).
  /// Level 1 is everything below the first, or fewer than
  /// [minAttemptsForLevel] attempts.
  final List<double> levelThresholds;
  final int minAttemptsForLevel;

  /// A family (or tag) with at least [minAttemptsForWeakArea] attempts and
  /// an all-time accuracy below [weakAccuracyThreshold] is a weak area.
  final double weakAccuracyThreshold;
  final int minAttemptsForWeakArea;

  /// A trend is "up"/"down" only when the accuracy delta over the window
  /// reaches this many points (0.05 = 5 percentage points) and the
  /// regression slope has the same sign; otherwise it is flat.
  final double trendDeltaThreshold;

  /// How many of the latest completed exam simulations feed the exam
  /// component of the readiness score (mean of their global scores).
  final int recentExamCount;

  double weightOf(String familyId) =>
      familyWeights[familyId] ?? defaultFamilyWeight;

  /// PSY0 families (EPIC-03 ids). The MVP ones weigh 2, the rest 1;
  /// `english` is the current content id of the English bank and is kept
  /// alongside the spec's `english_*` ids.
  static const Map<String, double> defaultFamilyWeights = {
    'memory_nback': 2,
    'attention_rules': 2,
    'attention_parity': 2,
    'logic_dominos': 2,
    'arithmetic_grid': 2,
    'culture_aero': 2,
    'english': 2,
    'english_reading': 2,
    'planning_tubes': 1,
    'spatial_overlay': 1,
    'attention_airways': 1,
    'verbal_boxes': 1,
    'spatial_viewpoint': 1,
    'spatial_cubes': 1,
    'multitask_psychomotor': 1,
    'english_listening': 1,
    'english_speaking': 1,
  };
}

/// Relative weights of the readiness components; they are normalised by
/// their sum, so `(6, 1.5, 2.5)` and `(0.6, 0.15, 0.25)` are the same mix.
class ReadinessWeights {
  const ReadinessWeights({
    this.families = 0.6,
    this.lessons = 0.15,
    this.exams = 0.25,
  }) : assert(families >= 0 && lessons >= 0 && exams >= 0, 'weights >= 0'),
       assert(families + lessons + exams > 0, 'at least one weight > 0');

  final double families;
  final double lessons;
  final double exams;

  double get total => families + lessons + exams;
}
