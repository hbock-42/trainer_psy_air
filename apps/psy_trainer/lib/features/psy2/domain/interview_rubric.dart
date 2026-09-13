/// The PSY2 interview self-assessment rubric (US-111,
/// `docs/content/psy2-spec.md` §4.1): five criteria, each self-scored 1
/// (weak) to 4 (strong) after a practised answer. Self-scored only -- never
/// a simulated "pass/fail" grading of the real interview.
enum InterviewRubricCriterion {
  /// Clear situation -> action -> result/reasoning.
  structure,

  /// A specific example rather than a generic claim.
  concreteness,

  /// Owns a real weakness or mistake, not a disguised strength.
  selfAwareness,

  /// Connects the answer to teamwork, safety or professional judgement
  /// where natural.
  relevance,

  /// Pace, clarity, confidence without notes.
  delivery,
}

/// Lowest and highest score a criterion can take.
const int interviewRubricMinScore = 1;
const int interviewRubricMaxScore = 4;

/// Self-scores of one practised answer, one entry per
/// [InterviewRubricCriterion]. Persisted in `TrainingSession.config['scores']`
/// keyed by [InterviewRubricCriterion.name].
typedef InterviewRubricScores = Map<InterviewRubricCriterion, int>;

/// A neutral starting score for every criterion before the user adjusts it.
int get interviewRubricDefaultScore =>
    (interviewRubricMinScore + interviewRubricMaxScore) ~/ 2;

InterviewRubricScores defaultInterviewRubricScores() => {
  for (final criterion in InterviewRubricCriterion.values)
    criterion: interviewRubricDefaultScore,
};

/// Mean of [scores] on the 1..4 scale, 0 when empty.
double interviewRubricAverage(InterviewRubricScores scores) {
  if (scores.isEmpty) return 0;
  final sum = scores.values.fold<int>(0, (a, b) => a + b);
  return sum / scores.length;
}

/// [scores] as a JSON-safe map (`TrainingSession.config['scores']`).
Map<String, Object?> interviewRubricScoresToJson(
  InterviewRubricScores scores,
) => {for (final entry in scores.entries) entry.key.name: entry.value};

/// Reads back a map produced by [interviewRubricScoresToJson]; unknown keys
/// are ignored and missing criteria fall back to
/// [interviewRubricDefaultScore] (forward/backward compatible with a future
/// criterion).
InterviewRubricScores interviewRubricScoresFromJson(Object? json) {
  final map = json is Map ? json : const <String, Object?>{};
  return {
    for (final criterion in InterviewRubricCriterion.values)
      criterion:
          (map[criterion.name] as num?)?.toInt() ?? interviewRubricDefaultScore,
  };
}
