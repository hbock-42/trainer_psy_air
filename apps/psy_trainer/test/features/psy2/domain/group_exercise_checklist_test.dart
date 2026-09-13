import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/psy2/domain/group_exercise_checklist.dart';

void main() {
  test('defaultCrmDimensionScores gives every dimension a neutral score', () {
    final scores = defaultCrmDimensionScores();
    expect(scores.keys.toSet(), CrmDimension.values.toSet());
    expect(scores.values, everyElement(crmDimensionDefaultScore));
  });

  test('crmDimensionAverage is the mean across dimensions', () {
    final scores = {for (final d in CrmDimension.values) d: 1}
      ..[CrmDimension.teamwork] = 4;
    // five 1s and one 4 across six dimensions: (5*1 + 4)/6 = 1.5
    expect(crmDimensionAverage(scores), closeTo(1.5, 1e-9));
  });

  test('scores round-trip through JSON', () {
    final scores = defaultCrmDimensionScores()
      ..[CrmDimension.communication] = 3;
    final json = crmDimensionScoresToJson(scores);
    expect(json['communication'], 3);
    expect(crmDimensionScoresFromJson(json), scores);
  });

  test('text notes round-trip through JSON, blank when absent', () {
    final notes = {CrmDimension.leadership: 'Proposed a way forward'};
    final json = textMapToJson(notes);
    final back = textMapFromJson(json);
    expect(back[CrmDimension.leadership], 'Proposed a way forward');
    expect(back[CrmDimension.teamwork], '');
  });
}
