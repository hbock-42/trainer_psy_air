import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/core/router/app_shell.dart';
import 'package:psy_trainer/features/exam/presentation/exam_screen.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/progress/presentation/progress_screen.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_session_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../helpers/content_ready_fakes.dart';
import '../../helpers/onboarding_fakes.dart';
import '../../helpers/psy0_families.dart';

const Size _phone = Size(390, 844);
const Size _desktop = Size(1280, 800);

Future<ProviderContainer> pumpShell(
  WidgetTester tester, {
  Size size = _phone,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final ProviderContainer container = ProviderContainer(
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
  return container;
}

/// The tab pressable labelled [label] (scoped to the bar: the Learn home has
/// "Apprendre" buttons of its own).
Finder _tab(String label) => find.descendant(
  of: find.byType(AppTabBar),
  matching: find.ancestor(
    of: find.text(label),
    matching: find.byType(AppPressable),
  ),
);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  testWidgets('shows five tabs in AppRoutes.tabs order', (tester) async {
    await pumpShell(tester);

    final bar = tester.widget<AppTabBar>(find.byType(AppTabBar));
    final context = tester.element(find.byType(AppTabBar));
    expect(
      bar.items.map((i) => (i.label, i.glyph)),
      AppShell.tabsOf(context).map((i) => (i.label, i.glyph)),
    );
    expect(bar.items.map((i) => i.label), [
      l10nFr.tabLearn,
      l10nFr.tabTrain,
      l10nFr.tabExam,
      l10nFr.tabProgress,
      l10nFr.tabSettings,
    ]);
    expect(bar.items.length, AppRoutes.tabs.length);
    expect(bar.selectedIndex, 0);
  });

  testWidgets('tapping each tab shows its screen and selects the tab', (
    tester,
  ) async {
    final container = await pumpShell(tester);
    final router = container.read(appRouterProvider);

    final expectations = <String, (Type, String)>{
      l10nFr.tabTrain: (TrainScreen, AppRoutes.train),
      l10nFr.tabExam: (ExamScreen, AppRoutes.exam),
      l10nFr.tabProgress: (ProgressScreen, AppRoutes.progress),
      l10nFr.tabSettings: (SettingsScreen, AppRoutes.settings),
      l10nFr.tabLearn: (LearnScreen, AppRoutes.learn),
    };
    var index = 1;
    for (final entry in expectations.entries) {
      await tester.tap(_tab(entry.key));
      await tester.pumpAndSettle();

      final (screen, location) = entry.value;
      expect(find.byType(screen), findsOneWidget, reason: entry.key);
      expect(
        router.routerDelegate.currentConfiguration.uri.toString(),
        location,
      );
      expect(
        tester.widget<AppTabBar>(find.byType(AppTabBar)).selectedIndex,
        index % AppRoutes.tabs.length,
      );
      index++;
    }
  });

  testWidgets('Learn tab shows the app name and the unofficial disclaimer', (
    tester,
  ) async {
    await pumpShell(tester);

    expect(find.text(l10nFr.appName), findsOneWidget);
    expect(find.text(l10nFr.disclaimerShort), findsOneWidget);
    // The full text sits behind the "read the full disclaimer" link (US-040).
    await tester.tap(find.text(l10nFr.learnDisclaimerExpand));
    await tester.pumpAndSettle();
    expect(find.text(l10nFr.disclaimerTitle), findsOneWidget);
    expect(find.text(l10nFr.disclaimerParagraph1), findsOneWidget);
    expect(find.text(l10nFr.disclaimerParagraph2), findsOneWidget);
    expect(find.textContaining('Air France'), findsWidgets);
  });

  testWidgets('other placeholders show their tab name', (tester) async {
    final container = await pumpShell(tester);
    final router = container.read(appRouterProvider);

    // Train is no longer a placeholder (US-050): it has its own test.
    for (final (route, label) in [
      (AppRoutes.exam, l10nFr.tabExam),
      (AppRoutes.progress, l10nFr.tabProgress),
      (AppRoutes.settings, l10nFr.tabSettings),
    ]) {
      router.go(route);
      await tester.pumpAndSettle();
      // Once in the tab bar, once as the screen's headline.
      expect(find.text(label), findsNWidgets(2), reason: route);
    }
  });

  testWidgets('each tab keeps its navigation stack while hidden', (
    tester,
  ) async {
    final container = await pumpShell(tester);
    final router = container.read(appRouterProvider);

    router.go(AppRoutes.trainSession('abc'));
    await tester.pumpAndSettle();
    expect(find.byType(TrainSessionScreen), findsOneWidget);

    await tester.tap(_tab(l10nFr.tabLearn));
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.byType(TrainSessionScreen), findsNothing);
    expect(
      find.byType(TrainSessionScreen, skipOffstage: false),
      findsOneWidget,
    );

    // Back to Train: the session is still on top of that branch.
    await tester.tap(_tab(l10nFr.tabTrain));
    await tester.pumpAndSettle();
    expect(find.byType(TrainSessionScreen), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.trainSession('abc'),
    );
  });

  testWidgets('re-tapping the active tab pops it back to its root', (
    tester,
  ) async {
    final container = await pumpShell(tester);
    final router = container.read(appRouterProvider);

    router.go(AppRoutes.trainSession('abc'));
    await tester.pumpAndSettle();
    expect(find.byType(TrainSessionScreen), findsOneWidget);

    await tester.tap(_tab(l10nFr.tabTrain));
    await tester.pumpAndSettle();
    expect(find.byType(TrainSessionScreen), findsNothing);
    expect(find.byType(TrainScreen), findsOneWidget);
    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      AppRoutes.train,
    );
  });

  testWidgets('narrow window: bottom bar below the content', (tester) async {
    await pumpShell(tester);

    final bar = tester.widget<AppTabBar>(find.byType(AppTabBar));
    expect(bar.layout, AppTabBarLayout.bottom);
    final barRect = tester.getRect(find.byType(AppTabBar));
    final contentRect = tester.getRect(find.byType(LearnScreen));
    expect(barRect.top, greaterThanOrEqualTo(contentRect.bottom));
    expect(barRect.bottom, _phone.height);
    expect(barRect.width, _phone.width);
  });

  testWidgets('wide window: rail on the left of the content', (tester) async {
    await pumpShell(tester, size: _desktop);

    final bar = tester.widget<AppTabBar>(find.byType(AppTabBar));
    expect(bar.layout, AppTabBarLayout.rail);
    final barRect = tester.getRect(find.byType(AppTabBar));
    final contentRect = tester.getRect(find.byType(LearnScreen));
    expect(barRect.left, 0);
    expect(barRect.height, _desktop.height);
    expect(contentRect.left, greaterThanOrEqualTo(barRect.right));

    await tester.tap(_tab(l10nFr.tabSettings));
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
  });

  testWidgets('layout follows the breakpoint when the window resizes', (
    tester,
  ) async {
    await pumpShell(
      tester,
      size: const Size(AppTabBar.railBreakpoint - 1, 700),
    );
    expect(
      tester.widget<AppTabBar>(find.byType(AppTabBar)).layout,
      AppTabBarLayout.bottom,
    );

    tester.view.physicalSize = const Size(AppTabBar.railBreakpoint, 700);
    await tester.pumpAndSettle();
    expect(
      tester.widget<AppTabBar>(find.byType(AppTabBar)).layout,
      AppTabBarLayout.rail,
    );
  });

  testWidgets('tabs are announced as selectable buttons', (tester) async {
    final handle = tester.ensureSemantics();
    await pumpShell(tester);

    expect(find.bySemanticsLabel(l10nFr.tabBarLabel), findsOneWidget);
    expect(
      tester.getSemantics(_tab(l10nFr.tabLearn)),
      matchesSemantics(
        label: l10nFr.tabLearn,
        isButton: true,
        isSelected: true,
        hasSelectedState: true,
        isEnabled: true,
        hasEnabledState: true,
        hasTapAction: true,
        isFocusable: true,
        hasFocusAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('shell is an AppScaffold hosting the branch navigator', (
    tester,
  ) async {
    await pumpShell(tester);
    expect(
      find.descendant(
        of: find.byType(AppShell),
        matching: find.byType(AppScaffold),
      ),
      findsWidgets,
    );
    expect(
      find.descendant(
        of: find.byType(AppShell),
        matching: find.byType(StatefulNavigationShell),
      ),
      findsOneWidget,
    );
  });
}
