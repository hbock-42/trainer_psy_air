import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/learn/presentation/family_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/flashcards_fixtures.dart';
import '../../../helpers/psy0_families.dart';
import '../../../helpers/pump_app.dart';

Future<void> pumpFamily(
  WidgetTester tester,
  String familyId, {
  double textScale = 1.0,
  List<Override>? overrides,
}) async {
  await pumpApp(
    tester,
    FamilyScreen(familyId: familyId),
    textScale: textScale,
    overrides:
        overrides ??
        [contentRepositoryProvider.overrideWithValue(psy0ContentRepository())],
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the family, its format, mastery and lesson titles', (
    tester,
  ) async {
    await pumpFamily(tester, 'memory_nback');

    expect(find.text('Mémoire N-back'), findsOneWidget);
    expect(find.text('Ce qui est évalué pour memory_nback.'), findsOneWidget);
    expect(find.text('10 items · ~1 min'), findsOneWidget);
    expect(find.text(AppStrings.familyMasteryUnknown), findsOneWidget);
    expect(find.text(AppStrings.confidenceConfirmed), findsOneWidget);
    expect(find.text('N-back : tenir le rythme'), findsOneWidget);
    expect(find.text('Méthode du train de wagons.'), findsOneWidget);
    expect(find.text(AppStrings.lessonReadTime(9)), findsOneWidget);
    expect(find.text('N-back : gérer les leurres'), findsOneWidget);
    expect(find.text('Éprouvettes : compter les coups'), findsNothing);
    expect(find.byType(PrimaryButton), findsOneWidget);
  });

  testWidgets('says so when the family has no lesson yet', (tester) async {
    await pumpFamily(tester, 'logic_dominos');

    expect(find.text('Dominos'), findsOneWidget);
    expect(find.text(AppStrings.familyLessonsEmpty), findsOneWidget);
  });

  testWidgets('shows a not-found message for an unknown id', (tester) async {
    await pumpFamily(tester, 'nope');

    expect(find.text(AppStrings.familyNotFound), findsOneWidget);
    expect(find.byType(PrimaryButton), findsNothing);
  });

  testWidgets('the "Cartes" action is disabled when the family has no deck', (
    tester,
  ) async {
    await pumpFamily(tester, 'logic_dominos');

    final button = tester.widget<SecondaryButton>(
      find.widgetWithText(SecondaryButton, AppStrings.familyActionCards),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('the "Cartes" action is enabled when the family has a deck', (
    tester,
  ) async {
    final repository = psy0ContentRepository();
    repository.addDeck(
      flashcardsDeckFixture(familyId: 'logic_dominos', count: 5),
    );
    await pumpFamily(
      tester,
      'logic_dominos',
      overrides: [
        contentRepositoryProvider.overrideWithValue(repository),
        progressRepositoryProvider.overrideWithValue(
          InMemoryProgressRepository(),
        ),
      ],
    );

    final button = tester.widget<SecondaryButton>(
      find.widgetWithText(SecondaryButton, AppStrings.familyActionCards),
    );
    expect(button.onPressed, isNotNull);
  });

  testWidgets('survives 1.3x text scaling on a phone', (tester) async {
    tester.view.physicalSize = const Size(360, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpFamily(tester, 'planning_tubes', textScale: 1.3);

    expect(tester.takeException(), isNull);
  });
}
