import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
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

void main() {
  testWidgets('shows five tabs in AppRoutes.tabs order', (tester) async {
    await pumpShell(tester);

    final bar = tester.widget<AppTabBar>(find.byType(AppTabBar));
    expect(bar.items, AppShell.tabs);
    expect(bar.items.map((i) => i.label), [
      AppStrings.tabLearn,
      AppStrings.tabTrain,
      AppStrings.tabExam,
      AppStrings.tabProgress,
      AppStrings.tabSettings,
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
      AppStrings.tabTrain: (TrainScreen, AppRoutes.train),
      AppStrings.tabExam: (ExamScreen, AppRoutes.exam),
      AppStrings.tabProgress: (ProgressScreen, AppRoutes.progress),
      AppStrings.tabSettings: (SettingsScreen, AppRoutes.settings),
      AppStrings.tabLearn: (LearnScreen, AppRoutes.learn),
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

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.disclaimerShort), findsOneWidget);
    // The full text sits behind the "read the full disclaimer" link (US-040).
    await tester.tap(find.text(AppStrings.learnDisclaimerExpand));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.disclaimerTitle), findsOneWidget);
    expect(find.text(AppStrings.disclaimerParagraph1), findsOneWidget);
    expect(find.text(AppStrings.disclaimerParagraph2), findsOneWidget);
    expect(find.textContaining('Air France'), findsWidgets);
  });

  testWidgets('other placeholders show their tab name', (tester) async {
    final container = await pumpShell(tester);
    final router = container.read(appRouterProvider);

    for (final (route, label) in [
      (AppRoutes.train, AppStrings.tabTrain),
      (AppRoutes.exam, AppStrings.tabExam),
      (AppRoutes.progress, AppStrings.tabProgress),
      (AppRoutes.settings, AppStrings.tabSettings),
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

    await tester.tap(_tab(AppStrings.tabLearn));
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.byType(TrainSessionScreen), findsNothing);
    expect(
      find.byType(TrainSessionScreen, skipOffstage: false),
      findsOneWidget,
    );

    // Back to Train: the session is still on top of that branch.
    await tester.tap(_tab(AppStrings.tabTrain));
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

    await tester.tap(_tab(AppStrings.tabTrain));
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

    await tester.tap(_tab(AppStrings.tabSettings));
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

    expect(find.bySemanticsLabel(AppStrings.tabBarLabel), findsOneWidget);
    expect(
      tester.getSemantics(_tab(AppStrings.tabLearn)),
      matchesSemantics(
        label: AppStrings.tabLearn,
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
