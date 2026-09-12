import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/learn/presentation/family_screen.dart';
import 'package:psy_trainer/features/learn/presentation/lesson_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/flashcards_fixtures.dart';
import '../../../helpers/onboarding_fakes.dart' show progressRepositoryOverride;
import '../../../helpers/psy0_families.dart';
import '../../../helpers/pump_app.dart';

Future<void> pumpFamily(
  WidgetTester tester,
  String familyId, {
  double textScale = 1.0,
  InMemoryProgressRepository? progress,
  List<Override>? overrides,
}) async {
  await pumpApp(
    tester,
    FamilyScreen(familyId: familyId),
    textScale: textScale,
    overrides:
        overrides ??
        [
          contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
          progressRepositoryOverride(repository: progress),
        ],
  );
  await tester.pumpAndSettle();
}

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  testWidgets('shows the family, its format, mastery and lesson titles', (
    tester,
  ) async {
    await pumpFamily(tester, 'memory_nback');

    expect(find.text('Mémoire N-back'), findsOneWidget);
    expect(find.text('Ce qui est évalué pour memory_nback.'), findsOneWidget);
    expect(find.text('10 items · ~1 min'), findsOneWidget);
    expect(find.text(l10nFr.familyMasteryUnknown), findsOneWidget);
    expect(find.text(l10nFr.confidenceConfirmed), findsOneWidget);
    expect(find.text('N-back : tenir le rythme'), findsOneWidget);
    expect(find.text('Méthode du train de wagons.'), findsOneWidget);
    expect(find.text(l10nFr.lessonReadTime(9)), findsOneWidget);
    expect(find.text('N-back : gérer les leurres'), findsOneWidget);
    expect(find.text('Éprouvettes : compter les coups'), findsNothing);
    expect(find.byType(PrimaryButton), findsOneWidget);
  });

  testWidgets('says so when the family has no lesson yet', (tester) async {
    await pumpFamily(tester, 'logic_dominos');

    expect(find.text('Dominos'), findsOneWidget);
    expect(find.text(l10nFr.familyLessonsEmpty), findsOneWidget);
  });

  testWidgets('shows a not-found message for an unknown id', (tester) async {
    await pumpFamily(tester, 'nope');

    expect(find.text(l10nFr.familyNotFound), findsOneWidget);
    expect(find.byType(PrimaryButton), findsNothing);
  });

  testWidgets('the "Cartes" action is disabled when the family has no deck', (
    tester,
  ) async {
    await pumpFamily(tester, 'logic_dominos');

    final button = tester.widget<SecondaryButton>(
      find.widgetWithText(SecondaryButton, l10nFr.familyActionCards),
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
      find.widgetWithText(SecondaryButton, l10nFr.familyActionCards),
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

  group('learning progress (US-044)', () {
    testWidgets('the lessons ring shows 0 read of the total', (tester) async {
      await pumpFamily(tester, 'memory_nback');

      expect(find.text(l10nFr.familyLessonsProgress(0, 2)), findsOneWidget);
    });

    testWidgets('the ring reflects an already-read lesson', (tester) async {
      final progress = InMemoryProgressRepository();
      await progress.markLessonRead('lesson.memory_nback.01');

      await pumpFamily(tester, 'memory_nback', progress: progress);

      expect(find.text(l10nFr.familyLessonsProgress(1, 2)), findsOneWidget);
    });

    testWidgets('no ring when the family has no lesson', (tester) async {
      await pumpFamily(tester, 'logic_dominos');

      expect(find.textContaining('/0'), findsNothing);
    });

    testWidgets('a lesson tile is marked read with a check', (tester) async {
      final progress = InMemoryProgressRepository();
      await progress.markLessonRead('lesson.memory_nback.01');

      await pumpFamily(tester, 'memory_nback', progress: progress);

      final readTile = find.ancestor(
        of: find.text('N-back : tenir le rythme'),
        matching: find.byType(AppCard),
      );
      final unreadTile = find.ancestor(
        of: find.text('N-back : gérer les leurres'),
        matching: find.byType(AppCard),
      );
      expect(
        find.descendant(
          of: readTile,
          matching: find.byWidgetPredicate(
            (w) => w is AppIcon && w.glyph == AppIconGlyph.check,
          ),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: unreadTile,
          matching: find.byWidgetPredicate(
            (w) => w is AppIcon && w.glyph == AppIconGlyph.check,
          ),
        ),
        findsNothing,
      );
    });
  });

  testWidgets('tapping a lesson opens the lesson viewer', (tester) async {
    final container = ProviderContainer(
      overrides: [
        contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
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
    container.read(appRouterProvider).go(AppRoutes.learnFamily('memory_nback'));
    await tester.pumpAndSettle();

    final tile = find.text('N-back : tenir le rythme');
    await tester.ensureVisible(tile);
    await tester.pumpAndSettle();
    await tester.tap(tile);
    await tester.pumpAndSettle();

    expect(find.byType(LessonScreen), findsOneWidget);
  });

  testWidgets('scrolls from the margins beside the capped content on a wide '
      'window', (tester) async {
    tester.view.physicalSize = const Size(1600, 500);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await pumpFamily(tester, 'memory_nback');

    final scrollable = find.byType(Scrollable);
    expect(scrollable, findsOneWidget);
    final position = tester.state<ScrollableState>(scrollable).position;
    expect(position.maxScrollExtent, greaterThan(0));

    // Drag in the left margin, outside the 1100 dp content column.
    await tester.dragFrom(const Offset(60, 300), const Offset(0, -200));
    await tester.pumpAndSettle();

    expect(position.pixels, greaterThan(50));
  });
}
