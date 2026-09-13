import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/features/psy2/domain/interview_rubric.dart';

void main() {
  test(
    'defaultInterviewRubricScores gives every criterion a neutral score',
    () {
      final scores = defaultInterviewRubricScores();
      expect(scores.keys.toSet(), InterviewRubricCriterion.values.toSet());
      expect(scores.values, everyElement(interviewRubricDefaultScore));
    },
  );

  test('interviewRubricAverage is the mean of the five scores', () {
    final scores = {for (final c in InterviewRubricCriterion.values) c: 2}
      ..[InterviewRubricCriterion.structure] = 4;
    // (4 + 2 + 2 + 2 + 2) / 5 = 2.4
    expect(interviewRubricAverage(scores), closeTo(2.4, 1e-9));
  });

  test('interviewRubricAverage of an empty map is 0', () {
    expect(interviewRubricAverage(const {}), 0);
  });

  test('scores round-trip through JSON', () {
    final scores = defaultInterviewRubricScores()
      ..[InterviewRubricCriterion.delivery] = 4;
    final json = interviewRubricScoresToJson(scores);
    expect(json['delivery'], 4);
    final back = interviewRubricScoresFromJson(json);
    expect(back, scores);
  });

  test('interviewRubricScoresFromJson falls back to the default for unknown/'
      'missing keys', () {
    final back = interviewRubricScoresFromJson({'unknown': 1});
    expect(
      back.values,
      everyElement(interviewRubricDefaultScore),
      reason: 'no known criterion key was present',
    );
    expect(interviewRubricScoresFromJson(null).length, 5);
    expect(interviewRubricScoresFromJson('not a map').length, 5);
  });
}
