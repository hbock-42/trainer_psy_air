import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/psy2/domain/group_exercise_checklist.dart';
import 'package:psy_trainer/features/psy2/domain/psy2_sessions.dart';
import 'package:psy_trainer/features/psy2/presentation/group_exercise_screen.dart';

import '../../../helpers/psy2_fixtures.dart';
import '../../../helpers/pump_app.dart';

void main() {
  late InMemoryProgressRepository progress;

  setUp(() => progress = InMemoryProgressRepository());

  Future<void> pumpScreen(WidgetTester tester) => pumpApp(
    tester,
    const GroupExerciseScreen(),
    overrides: [
      contentRepositoryProvider.overrideWithValue(psy2ContentRepository()),
      progressRepositoryProvider.overrideWithValue(progress),
    ],
  );

  testWidgets('renders the CRM lesson and the six-dimension checklist', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pumpAndSettle();

    expect(find.text('La grille CRM'), findsOneWidget);
    expect(find.byKey(const Key('group_exercise.save')), findsOneWidget);
  });

  testWidgets('saving the checklist persists a psy2_group_exercise session', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const Key('group_exercise.save'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    final sessions = await progress.sessions(
      familyId: Psy2SessionFamily.groupExercise,
    );
    expect(sessions, hasLength(1));
    final session = sessions.single;
    expect(session.mode, SessionMode.practice);
    expect(session.status, SessionStatus.completed);
    final scores = crmDimensionScoresFromJson(session.config['scores']);
    expect(scores.values, everyElement(crmDimensionDefaultScore));
    expect(session.score, crmDimensionDefaultScore / crmDimensionMaxScore);
  });
}
