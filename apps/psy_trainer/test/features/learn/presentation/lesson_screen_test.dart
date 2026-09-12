import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/learn/presentation/lesson_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/onboarding_fakes.dart' show progressRepositoryOverride;

const String _familyId = 'memory_nback';

/// A body long enough that it never fits the test viewport, so
/// `maxScrollExtent > 0` regardless of window size (the scroll-to-end
/// tracking needs something to scroll).
final String _longBody =
    '# Le rythme\n\n${List.filled(40, 'Un paragraphe assez long pour remplir l\'écran et forcer le défilement.').join('\n\n')}';

/// Two lessons of one family: the first has a heading (for the table of
/// contents), a reading time and enough body to require scrolling; the
/// second a one-line body — enough to exercise prev/next, the TOC and read
/// tracking without depending on real content fixtures.
List<Lesson> _lessons() => [
  Lesson(
    id: 'lesson.01',
    version: 1,
    moduleId: ModuleId.psy0,
    familyId: _familyId,
    order: 1,
    title: const LocalizedText(fr: 'N-back : tenir le rythme'),
    estimatedReadMin: 9,
    tags: const [],
    body: LocalizedText(fr: _longBody),
  ),
  const Lesson(
    id: 'lesson.02',
    version: 1,
    moduleId: ModuleId.psy0,
    familyId: _familyId,
    order: 2,
    title: LocalizedText(fr: 'N-back : gérer les leurres'),
    tags: [],
    body: LocalizedText(fr: 'Texte.'),
  ),
];

/// Pumps the whole app (router included) and navigates straight to the
/// lesson viewer, so `context.go`/`context.pop` inside it have a real
/// `GoRouter` ancestor.
Future<(ProviderContainer, InMemoryProgressRepository)> pumpLesson(
  WidgetTester tester, {
  required String lessonId,
  double textScale = 1.0,
}) async {
  final container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        InMemoryContentRepository(lessons: _lessons()),
      ),
      // No explicit repository: the default fake already has a completed
      // onboarding profile, otherwise the router's guard redirects to
      // /onboarding before the lesson ever renders.
      progressRepositoryOverride(),
      contentReadyOverride(),
    ],
  );
  addTearDown(container.dispose);
  final progress =
      container.read(progressRepositoryProvider) as InMemoryProgressRepository;

  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const PsyTrainerApp(),
    ),
  );
  await tester.pumpAndSettle();

  container
      .read(appRouterProvider)
      .go(AppRoutes.learnLesson(_familyId, lessonId));
  await tester.pumpAndSettle();

  return (container, progress);
}

void main() {
  group('navigation', () {
    testWidgets('shows the title and reading time', (tester) async {
      await pumpLesson(tester, lessonId: 'lesson.01');

      expect(find.text('N-back : tenir le rythme'), findsOneWidget);
      expect(find.text(AppStrings.lessonReadTime(9)), findsOneWidget);
    });

    testWidgets('offers "next" only for the first lesson of the family', (
      tester,
    ) async {
      await pumpLesson(tester, lessonId: 'lesson.01');

      expect(find.text(AppStrings.lessonNext), findsOneWidget);
      expect(find.text(AppStrings.lessonPrevious), findsNothing);
    });

    testWidgets('"next" opens the following lesson of the family', (
      tester,
    ) async {
      await pumpLesson(tester, lessonId: 'lesson.01');

      // The lesson is long: scroll the prev/next row into view first.
      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
      await tester.pumpAndSettle();

      await tester.tap(find.text(AppStrings.lessonNext));
      await tester.pumpAndSettle();

      expect(find.text('N-back : gérer les leurres'), findsOneWidget);
      expect(find.text(AppStrings.lessonPrevious), findsOneWidget);
      expect(find.text(AppStrings.lessonNext), findsNothing);
    });

    testWidgets('"previous" opens the earlier lesson of the family', (
      tester,
    ) async {
      await pumpLesson(tester, lessonId: 'lesson.02');

      await tester.tap(find.text(AppStrings.lessonPrevious));
      await tester.pumpAndSettle();

      expect(find.text('N-back : tenir le rythme'), findsOneWidget);
    });

    testWidgets('shows a not-found message for an unknown lesson id', (
      tester,
    ) async {
      await pumpLesson(tester, lessonId: 'nope');

      expect(find.text(AppStrings.lessonNotFound), findsOneWidget);
    });

    testWidgets('survives 1.3x text scaling on a phone', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pumpLesson(tester, lessonId: 'lesson.01', textScale: 1.3);

      expect(tester.takeException(), isNull);
    });
  });

  group('table of contents', () {
    testWidgets('is collapsed by default and expands on demand', (
      tester,
    ) async {
      await pumpLesson(tester, lessonId: 'lesson.01');

      // The "Le rythme" heading itself is always in the body; only the TOC
      // *entry* for it is collapsible, so the heading appears once (body)
      // before expanding, and twice (body + TOC link) after.
      expect(find.text(AppStrings.lessonTocShow), findsOneWidget);
      expect(find.text('Le rythme'), findsOneWidget);

      await tester.tap(find.text(AppStrings.lessonTocShow));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.lessonTocHide), findsOneWidget);
      expect(find.text('Le rythme'), findsNWidgets(2));
    });

    testWidgets('hidden for a lesson without any heading', (tester) async {
      await pumpLesson(tester, lessonId: 'lesson.02');

      expect(find.text(AppStrings.lessonTocShow), findsNothing);
    });
  });

  group('learning progress (US-044)', () {
    testWidgets('the manual toggle marks the lesson read', (tester) async {
      final (_, progress) = await pumpLesson(tester, lessonId: 'lesson.01');

      expect(await progress.lessonsRead(), isEmpty);
      expect(find.text(AppStrings.lessonMarkedRead), findsNothing);

      final markReadButton = find.byWidgetPredicate(
        (w) => w is AppIconButton && w.glyph == AppIconGlyph.check,
      );
      await tester.tap(markReadButton);
      await tester.pumpAndSettle();

      final reads = await progress.lessonsRead();
      expect(reads.map((r) => r.lessonId), contains('lesson.01'));
      expect(find.text(AppStrings.lessonMarkedRead), findsWidgets);
    });

    testWidgets('a short lesson is marked read after 20 s', (tester) async {
      final (_, progress) = await pumpLesson(tester, lessonId: 'lesson.02');

      expect(await progress.lessonsRead(), isEmpty);

      await tester.pump(shortLessonReadDelay);
      await tester.pumpAndSettle();

      final reads = await progress.lessonsRead();
      expect(reads.map((r) => r.lessonId), contains('lesson.02'));
    });

    testWidgets('scrolling to the end marks the lesson read', (tester) async {
      final (_, progress) = await pumpLesson(tester, lessonId: 'lesson.01');

      final scrollable = tester.state<ScrollableState>(
        find.byType(Scrollable).first,
      );
      scrollable.position.jumpTo(scrollable.position.maxScrollExtent);
      await tester.pumpAndSettle();

      final reads = await progress.lessonsRead();
      expect(reads.map((r) => r.lessonId), contains('lesson.01'));
    });
  });
}
