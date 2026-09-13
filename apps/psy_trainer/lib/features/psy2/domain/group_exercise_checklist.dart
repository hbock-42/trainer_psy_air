/// The six CRM behaviour dimensions of the PSY2 group-exercise
/// self-assessment checklist (US-112, `docs/content/psy2-spec.md` §4.2),
/// each self-scored 1 (weak) to 4 (strong) after a mock session.
enum CrmDimension {
  communication,
  leadership,
  situationalAwareness,
  decisionMaking,
  workloadManagement,
  teamwork,
}

const int crmDimensionMinScore = 1;
const int crmDimensionMaxScore = 4;

int get crmDimensionDefaultScore =>
    (crmDimensionMinScore + crmDimensionMaxScore) ~/ 2;

typedef CrmDimensionScores = Map<CrmDimension, int>;

CrmDimensionScores defaultCrmDimensionScores() => {
  for (final dimension in CrmDimension.values)
    dimension: crmDimensionDefaultScore,
};

double crmDimensionAverage(CrmDimensionScores scores) {
  if (scores.isEmpty) return 0;
  final sum = scores.values.fold<int>(0, (a, b) => a + b);
  return sum / scores.length;
}

Map<String, Object?> crmDimensionScoresToJson(CrmDimensionScores scores) => {
  for (final entry in scores.entries) entry.key.name: entry.value,
};

CrmDimensionScores crmDimensionScoresFromJson(Object? json) {
  final map = json is Map ? json : const <String, Object?>{};
  return {
    for (final dimension in CrmDimension.values)
      dimension:
          (map[dimension.name] as num?)?.toInt() ?? crmDimensionDefaultScore,
  };
}

/// Free-text notes per dimension ("one thing done well" / "one thing to
/// improve"), keyed the same way as the scores.
Map<String, Object?> textMapToJson(Map<CrmDimension, String> notes) => {
  for (final entry in notes.entries) entry.key.name: entry.value,
};

Map<CrmDimension, String> textMapFromJson(Object? json) {
  final map = json is Map ? json : const <String, Object?>{};
  return {
    for (final dimension in CrmDimension.values)
      dimension: (map[dimension.name] as String?) ?? '',
  };
}
