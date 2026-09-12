import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/features/progress/domain/recommendation.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/train_next_card.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/pump_app.dart';

const Recommendation familyRec = Recommendation(
  kind: RecommendationKind.family,
  title: 'Grilles de calcul',
  reason: 'précision 62 % sur Grilles de calcul, en baisse',
  severity: 1.2,
  targetId: 'arithmetic_grid',
);

const Recommendation tagRec = Recommendation(
  kind: RecommendationKind.tag,
  title: 'les pourcentages',
  reason: 'précision 30 % sur les pourcentages',
  severity: 0.9,
  targetId: 'percentages',
);

const Recommendation examRec = Recommendation(
  kind: RecommendationKind.examSim,
  title: 'Fais une simulation',
  reason: 'aucune simulation depuis 7 jours',
  severity: 0,
);

const Recommendation lessonRec = Recommendation(
  kind: RecommendationKind.lesson,
  title: 'Lis la leçon : Dominos',
  reason: 'des tentatives sur Dominos sans avoir lu la leçon',
  severity: 0,
  targetId: 'logic_dominos',
  secondaryId: 'lesson-1',
);

const Recommendation flashcardsRec = Recommendation(
  kind: RecommendationKind.flashcards,
  title: 'Cartes à réviser',
  reason: '15 cartes en attente',
  severity: 0,
);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  testWidgets('shows the empty caption without recommendations', (
    tester,
  ) async {
    await tester.pumpApp(
      const TrainNextCard(recommendations: [], onAction: _noop),
    );
    expect(find.text(l10nFr.trainNextEmpty), findsOneWidget);
    expect(find.byType(SecondaryButton), findsNothing);
  });

  testWidgets('shows every recommendation with its title, reason and action', (
    tester,
  ) async {
    await tester.pumpApp(
      const TrainNextCard(
        recommendations: [familyRec, examRec, lessonRec, flashcardsRec],
        onAction: _noop,
      ),
      align: false,
    );

    expect(find.text('Grilles de calcul'), findsOneWidget);
    expect(
      find.text('précision 62 % sur Grilles de calcul, en baisse'),
      findsOneWidget,
    );
    expect(find.text('Fais une simulation'), findsOneWidget);
    expect(find.text('aucune simulation depuis 7 jours'), findsOneWidget);
    expect(find.text('Lis la leçon : Dominos'), findsOneWidget);
    expect(find.text('Cartes à réviser'), findsOneWidget);
    expect(find.text('15 cartes en attente'), findsOneWidget);

    expect(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionFamily),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionExam),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionLesson),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionFlashcards),
      findsOneWidget,
    );
  });

  testWidgets('a tag recommendation uses the same "train" action as a family', (
    tester,
  ) async {
    await tester.pumpApp(
      const TrainNextCard(recommendations: [tagRec], onAction: _noop),
    );
    expect(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionFamily),
      findsOneWidget,
    );
  });

  testWidgets('tapping an action calls back with that recommendation', (
    tester,
  ) async {
    Recommendation? tapped;
    await tester.pumpApp(
      TrainNextCard(
        recommendations: const [familyRec, examRec],
        onAction: (rec) => tapped = rec,
      ),
      align: false,
    );

    await tester.tap(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionFamily),
    );
    await tester.pump();
    expect(tapped, familyRec);

    await tester.tap(
      find.widgetWithText(SecondaryButton, l10nFr.trainNextActionExam),
    );
    await tester.pump();
    expect(tapped, examRec);
  });
}

void _noop(Recommendation _) {}
