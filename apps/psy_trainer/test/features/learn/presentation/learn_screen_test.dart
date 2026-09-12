import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/model/learning.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/learn/presentation/family_screen.dart';
import 'package:psy_trainer/features/learn/presentation/how_it_works_screen.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/learn/presentation/providers/family_mastery_provider.dart';
import 'package:psy_trainer/features/learn/presentation/widgets/family_card.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';
import 'package:psy_trainer/features/progress/presentation/widgets/readiness_card.dart'
    show ExamCountdownChip;
import 'package:psy_trainer/features/settings/presentation/edit_profile_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/flashcards_fixtures.dart';
import '../../../helpers/onboarding_fakes.dart'
    show fakeProgressRepository, progressRepositoryOverride;
import '../../../helpers/psy0_families.dart';
import '../../../helpers/pump_app.dart';

/// Pumps the bare [LearnScreen] over the in-memory repository.
///
/// [progress] overrides `progressRepositoryProvider` (defaults to a fresh
/// fake); pass it instead of doing so through [overrides], which would
/// override the same provider twice.
Future<void> pumpLearn(
  WidgetTester tester, {
  bool seeded = true,
  double textScale = 1.0,
  InMemoryContentRepository? content,
  InMemoryProgressRepository? progress,
  List<Override> overrides = const [],
}) async {
  await pumpApp(
    tester,
    const LearnScreen(),
    textScale: textScale,
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        content ?? psy0ContentRepository(seeded: seeded),
      ),
      progressRepositoryOverride(repository: progress),
      ...overrides,
    ],
  );
  await tester.pumpAndSettle();
}

/// Pumps the whole app (router included) over the in-memory repository, so
/// navigation from the Learn home can be exercised.
Future<ProviderContainer> pumpFullApp(
  WidgetTester tester, {
  InMemoryContentRepository? content,
}) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        content ?? psy0ContentRepository(),
      ),
      progressRepositoryOverride(),
      contentReadyOverride(),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const PsyTrainerApp(),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void setViewSize(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Family cards found in tree order, offstage ones included (the list is
/// longer than the viewport).
Finder allCards() => find.byType(FamilyCard, skipOffstage: false);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  group('header', () {
    testWidgets('shows the app name and the short disclaimer', (tester) async {
      await pumpLearn(tester);

      expect(find.text(l10nFr.appName), findsOneWidget);
      expect(find.text(l10nFr.disclaimerShort), findsOneWidget);
      expect(find.text(l10nFr.disclaimerParagraph1), findsNothing);
    });

    testWidgets('the link expands and collapses the full disclaimer', (
      tester,
    ) async {
      await pumpLearn(tester);

      await tester.tap(find.text(l10nFr.learnDisclaimerExpand));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.disclaimerTitle), findsOneWidget);
      expect(find.text(l10nFr.disclaimerParagraph1), findsOneWidget);
      expect(find.text(l10nFr.disclaimerParagraph2), findsOneWidget);

      await tester.tap(find.text(l10nFr.learnDisclaimerCollapse));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.disclaimerParagraph1), findsNothing);
    });
  });

  group('family list', () {
    testWidgets('renders the 14 PSY0 families as cards in real-test order', (
      tester,
    ) async {
      await pumpLearn(tester);

      final cards = tester
          .widgetList<FamilyCard>(allCards())
          .toList(growable: false);
      expect(cards, hasLength(14));
      expect(cards.map((c) => c.family.id).toList(), equals(psy0FamilyIds));
      expect(
        cards.map((c) => c.index).toList(),
        List.generate(14, (i) => i + 1),
      );
    });

    testWidgets(
      'a card shows name, evaluated, format, confidence and mastery',
      (tester) async {
        await pumpLearn(tester);

        final first = allCards().first;
        expect(
          find.descendant(of: first, matching: find.text('Mémoire N-back')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: first,
            matching: find.text('Ce qui est évalué pour memory_nback.'),
          ),
          findsOneWidget,
        );
        // 10 items, 60 s, no per-item time.
        expect(
          find.descendant(of: first, matching: find.text('10 items · ~1 min')),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: first,
            matching: find.text(l10nFr.confidenceConfirmed),
          ),
          findsOneWidget,
        );
        // No mastery yet: the slot falls back to lesson-read progress
        // (memory_nback has 2 lessons in the fixture, US-044).
        expect(
          find.descendant(
            of: first,
            matching: find.text(l10nFr.familyLessonsProgress(0, 2)),
          ),
          findsOneWidget,
        );

        // Second family: 11 items, 2 min 45 s, 30 s per item, "reported".
        final second = allCards().at(1);
        expect(
          find.descendant(
            of: second,
            matching: find.text('11 items · ~2 min 45 s · ~30 s par item'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: second,
            matching: find.text(l10nFr.confidenceReported),
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets('mastery comes from familyMasteryProvider when available', (
      tester,
    ) async {
      await pumpLearn(
        tester,
        overrides: [
          familyMasteryProvider.overrideWith(
            (ref, id) async => id == 'memory_nback' ? 0.724 : null,
          ),
        ],
      );

      expect(
        find.descendant(of: allCards().first, matching: find.text('72 %')),
        findsOneWidget,
      );
      // planning_tubes has no mastery override: falls back to lesson
      // progress (1 lesson in the fixture, US-044).
      expect(
        find.descendant(
          of: allCards().at(1),
          matching: find.text(l10nFr.familyLessonsProgress(0, 1)),
        ),
        findsOneWidget,
      );
    });

    testWidgets('the flashcards action is disabled until US-042', (
      tester,
    ) async {
      await pumpLearn(tester);

      SecondaryButton button(String label) => tester.widget<SecondaryButton>(
        find.descendant(
          of: allCards().first,
          matching: find.widgetWithText(SecondaryButton, label),
        ),
      );
      expect(button(l10nFr.familyActionCards).onPressed, isNull);
      expect(button(l10nFr.familyActionLearn).onPressed, isNotNull);
      expect(button(l10nFr.familyActionTrain).onPressed, isNotNull);
    });

    testWidgets('lays out one column on a phone', (tester) async {
      setViewSize(tester, const Size(390, 844));
      await pumpLearn(tester);

      final first = tester.getRect(allCards().first);
      final second = tester.getRect(allCards().at(1));
      expect(second.top, greaterThanOrEqualTo(first.bottom));
      expect(second.left, first.left);
    });

    testWidgets('lays out two columns from 900 dp', (tester) async {
      setViewSize(tester, const Size(1000, 800));
      await pumpLearn(tester);

      final first = tester.getRect(allCards().first);
      final second = tester.getRect(allCards().at(1));
      final third = tester.getRect(allCards().at(2));
      expect(second.top, first.top);
      expect(second.left, greaterThan(first.right));
      expect(third.top, greaterThanOrEqualTo(first.bottom));
      expect(third.left, first.left);
    });

    testWidgets('survives 1.3x text scaling without overflow', (tester) async {
      setViewSize(tester, const Size(360, 780));
      await pumpLearn(tester, textScale: 1.3);
      expect(tester.takeException(), isNull);
      expect(allCards(), findsNWidgets(14));
    });
  });

  group('empty state', () {
    testWidgets('shows the designed empty state when nothing is seeded', (
      tester,
    ) async {
      await pumpLearn(tester, seeded: false);

      expect(find.byType(FamilyCard), findsNothing);
      expect(find.text(l10nFr.learnEmptyTitle), findsOneWidget);
      expect(find.text(l10nFr.learnEmptyBody), findsOneWidget);
      // The rest of the home stays useful.
      expect(find.text(l10nFr.learnHowItWorksTitle), findsOneWidget);
      expect(find.text(l10nFr.learnFamiliesTitle), findsOneWidget);
    });
  });

  group('flashcards due today (US-042)', () {
    testWidgets('hidden when no deck is seeded', (tester) async {
      await pumpLearn(tester);

      expect(find.text(l10nFr.flashcardsHomeTitle), findsNothing);
    });

    testWidgets('hidden when every card is up to date', (tester) async {
      final content = psy0ContentRepository();
      content.addDeck(
        flashcardsDeckFixture(familyId: 'memory_nback', count: 2),
      );
      final progress = InMemoryProgressRepository();
      for (var i = 1; i <= 2; i++) {
        progress.reviewsByCard['memory_nback.deck.test.000$i'] =
            FlashcardReview(
              flashcardId: 'memory_nback.deck.test.000$i',
              deckId: 'memory_nback.deck.test',
              box: 5,
              reviews: 5,
              lapses: 0,
              nextReviewAt: DateTime.utc(2099),
            );
      }
      await pumpLearn(tester, content: content, progress: progress);

      expect(find.text(l10nFr.flashcardsHomeTitle), findsNothing);
    });

    testWidgets('shows the due count and opens the review-today screen', (
      tester,
    ) async {
      final content = psy0ContentRepository();
      content.addDeck(
        flashcardsDeckFixture(familyId: 'memory_nback', count: 4),
      );
      await pumpLearn(
        tester,
        content: content,
        progress: InMemoryProgressRepository(),
      );

      expect(find.text(l10nFr.flashcardsHomeTitle), findsOneWidget);
      expect(find.text(l10nFr.flashcardsHomeCount(4)), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('"Apprendre" opens the family page inside the Learn tab', (
      tester,
    ) async {
      final container = await pumpFullApp(tester);

      final learnAction = find.descendant(
        of: find.byType(FamilyCard).first,
        matching: find.text(l10nFr.familyActionLearn),
      );
      await tester.ensureVisible(learnAction);
      await tester.tap(learnAction);
      await tester.pumpAndSettle();

      expect(find.byType(FamilyScreen), findsOneWidget);
      expect(
        container.read(appRouterProvider).state.uri.toString(),
        AppRoutes.learnFamily('memory_nback'),
      );
      // Title, description and lesson titles of that family.
      expect(find.text('Mémoire N-back'), findsOneWidget);
      expect(find.text('N-back : tenir le rythme'), findsOneWidget);
      expect(find.text('N-back : gérer les leurres'), findsOneWidget);
      expect(find.text('Éprouvettes : compter les coups'), findsNothing);
      // The Learn home is still below on the tab's stack.
      expect(find.byType(LearnScreen, skipOffstage: false), findsOneWidget);

      container.read(appRouterProvider).pop();
      await tester.pumpAndSettle();
      expect(find.byType(LearnScreen), findsOneWidget);
      expect(find.byType(FamilyScreen), findsNothing);
    });

    testWidgets('tapping the card header also opens the family page', (
      tester,
    ) async {
      await pumpFullApp(tester);

      await tester.tap(
        find.descendant(
          of: find.byType(FamilyCard).first,
          matching: find.text('Mémoire N-back'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(FamilyScreen), findsOneWidget);
    });

    testWidgets('"S\'entraîner" switches to the Train tab', (tester) async {
      await pumpFullApp(tester);

      final trainAction = find.descendant(
        of: find.byType(FamilyCard).first,
        matching: find.text(l10nFr.familyActionTrain),
      );
      await tester.ensureVisible(trainAction);
      await tester.tap(trainAction);
      await tester.pumpAndSettle();

      expect(find.byType(TrainScreen), findsOneWidget);
    });

    testWidgets('the "how it works" card opens the selection page', (
      tester,
    ) async {
      final container = await pumpFullApp(tester);

      await tester.tap(find.text(l10nFr.learnHowItWorksTitle));
      await tester.pumpAndSettle();

      expect(find.byType(HowItWorksScreen), findsOneWidget);
      expect(
        container.read(appRouterProvider).state.uri.toString(),
        AppRoutes.learnHowItWorks,
      );
      expect(find.text(l10nFr.stagePsy0Title), findsOneWidget);
    });

    testWidgets('"À réviser aujourd\'hui" opens the review-today screen', (
      tester,
    ) async {
      final content = psy0ContentRepository();
      content.addDeck(
        flashcardsDeckFixture(familyId: 'memory_nback', count: 4),
      );
      final container = await pumpFullApp(tester, content: content);

      await tester.tap(find.text(l10nFr.flashcardsHomeTitle));
      await tester.pumpAndSettle();

      expect(
        container.read(appRouterProvider).state.uri.toString(),
        AppRoutes.learnCards,
      );
      expect(find.text(l10nFr.flashcardsDeckSummary(4, 4)), findsOneWidget);
    });
  });

  group('accessibility', () {
    testWidgets('meets accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpLearn(tester);

      await expectLater(tester, meetsGuideline(textContrastGuideline));
      await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });

  group('exam countdown chip (US-093)', () {
    testWidgets('shown when an exam date is set, tap opens the profile edit', (
      tester,
    ) async {
      final container = await pumpFullApp(tester);

      expect(
        find.byWidgetPredicate((w) => w is ExamCountdownChip),
        findsOneWidget,
      );

      await tester.tap(find.byKey(const Key('learn.exam_countdown_chip')));
      await tester.pumpAndSettle();

      expect(find.byType(EditProfileScreen), findsOneWidget);
      expect(
        container.read(appRouterProvider).state.uri.toString(),
        AppRoutes.settingsProfile,
      );
    });

    testWidgets('hidden when no exam date is set', (tester) async {
      await pumpLearn(
        tester,
        progress: fakeProgressRepository(
          answers: OnboardingAnswers(
            disclaimerAcceptedAt: DateTime.utc(2026, 9, 1, 9),
            targetStage: TargetStage.psy0,
          ),
        ),
      );

      expect(
        find.byWidgetPredicate((w) => w is ExamCountdownChip),
        findsNothing,
      );
    });
  });
}
