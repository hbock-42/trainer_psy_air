import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/model/learning.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/learn/presentation/flashcards/flashcards_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/flashcards_fixtures.dart';
import '../../../../helpers/pump_app.dart';

Future<void> pumpFlashcards(
  WidgetTester tester, {
  required Deck deck,
  InMemoryProgressRepository? progress,
  double textScale = 1.0,
}) async {
  await pumpApp(
    tester,
    FlashcardsScreen(familyId: deck.familyId),
    textScale: textScale,
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        InMemoryContentRepository(decks: [deck]),
      ),
      progressRepositoryProvider.overrideWithValue(
        progress ?? InMemoryProgressRepository(),
      ),
    ],
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('deck summary shows due/total then starts the session', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero');
    await pumpFlashcards(tester, deck: deck);

    expect(
      find.text(AppStrings.flashcardsDeckSummary(due: 3, total: 3)),
      findsOneWidget,
    );
    expect(find.byType(PrimaryButton), findsOneWidget);

    await tester.tap(
      find.widgetWithText(PrimaryButton, AppStrings.flashcardsStart),
    );
    await tester.pumpAndSettle();

    expect(find.text('Recto 1'), findsOneWidget);
    expect(find.text(AppStrings.flashcardsProgress(1, 3)), findsOneWidget);
  });

  testWidgets('flipping reveals the back and the grading buttons', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero', count: 1);
    await pumpFlashcards(tester, deck: deck);
    await tester.tap(find.text(AppStrings.flashcardsStart));
    await tester.pumpAndSettle();

    expect(find.text('Verso 1'), findsNothing);
    expect(find.text(AppStrings.flashcardsAgain), findsNothing);

    await tester.tap(find.text('Recto 1'));
    await tester.pumpAndSettle();

    expect(find.text('Verso 1'), findsOneWidget);
    expect(find.text(AppStrings.flashcardsAgain), findsOneWidget);
    expect(find.text(AppStrings.flashcardsHard), findsOneWidget);
    expect(find.text(AppStrings.flashcardsGood), findsOneWidget);
  });

  testWidgets('space flips and 1/2/3 grade, advancing to the next card', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero', count: 2);
    await pumpFlashcards(tester, deck: deck);
    await tester.tap(find.text(AppStrings.flashcardsStart));
    await tester.pumpAndSettle();

    expect(find.text('Recto 1'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    expect(find.text('Verso 1'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.digit3); // good
    await tester.pumpAndSettle();

    expect(find.text('Recto 2'), findsOneWidget);
    expect(find.text(AppStrings.flashcardsProgress(2, 2)), findsOneWidget);
  });

  testWidgets('grading every due card shows the end-of-session summary', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero', count: 2);
    await pumpFlashcards(tester, deck: deck);
    await tester.tap(find.text(AppStrings.flashcardsStart));
    await tester.pumpAndSettle();

    // Card 1: flip then "again".
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit1);
    await tester.pumpAndSettle();

    // Card 2: flip then "good".
    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit3);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.flashcardsSummaryTitle), findsOneWidget);
    expect(
      find.text(AppStrings.flashcardsSummaryBody(again: 1, hard: 0, good: 1)),
      findsOneWidget,
    );
  });

  testWidgets('saves the graded review through ProgressRepository', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero', count: 1);
    final progress = InMemoryProgressRepository();
    await pumpFlashcards(tester, deck: deck, progress: progress);
    await tester.tap(find.text(AppStrings.flashcardsStart));
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.digit2); // hard
    await tester.pumpAndSettle();

    final saved = progress.reviewsByCard['culture_aero.deck.test.0001'];
    expect(saved, isNotNull);
    expect(saved!.box, 1);
  });

  testWidgets('empty deck shows the empty state without a start button', (
    tester,
  ) async {
    final deck = flashcardsDeckFixture(familyId: 'culture_aero', count: 1);
    final progress = InMemoryProgressRepository();
    // Pre-grade the single card far into the future so nothing is due.
    progress.reviewsByCard['culture_aero.deck.test.0001'] = FlashcardReview(
      flashcardId: 'culture_aero.deck.test.0001',
      deckId: 'culture_aero.deck.test',
      box: 5,
      reviews: 5,
      lapses: 0,
      nextReviewAt: DateTime.utc(2099),
    );
    await pumpFlashcards(tester, deck: deck, progress: progress);

    expect(find.text(AppStrings.flashcardsEmptyTitle), findsOneWidget);
    expect(find.byType(PrimaryButton), findsNothing);
  });
}
