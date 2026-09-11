import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_page.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/core/router/app_shell.dart';
import 'package:psy_trainer/core/router/error_screen.dart';
import 'package:psy_trainer/features/learn/presentation/family_screen.dart';
import 'package:psy_trainer/features/learn/presentation/how_it_works_screen.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/onboarding/presentation/onboarding_screen.dart';
import 'package:psy_trainer/features/onboarding/presentation/providers/onboarding_completed_provider.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_session_screen.dart';

import '../../helpers/psy0_families.dart';

Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  bool onboardingDone = true,
}) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
      if (!onboardingDone)
        onboardingCompletedProvider.overrideWith(_NotCompletedOnboarding.new),
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

void main() {
  testWidgets('cold start lands on the Learn tab inside the shell', (
    tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });

  testWidgets('every route is wrapped in an AppPage', (tester) async {
    final ProviderContainer container = await pumpApp(tester);

    for (final tab in AppRoutes.tabs) {
      container.read(appRouterProvider).go(tab);
      await tester.pumpAndSettle();
      final ModalRoute<Object?>? route = ModalRoute.of(
        tester.element(find.byType(SafeArea).last),
      );
      expect(route?.settings, isA<AppPage<void>>(), reason: tab);
    }
  });

  testWidgets('switching tabs keeps each branch state (indexed stack)', (
    tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);
    final GoRouter router = container.read(appRouterProvider);

    router.go(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    // The Learn branch is still mounted (offstage) in the IndexedStack.
    expect(find.byType(LearnScreen, skipOffstage: false), findsOneWidget);
  });

  testWidgets('nested route /train/session/:id pushes inside the Train tab', (
    tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);
    final GoRouter router = container.read(appRouterProvider);

    router.go(AppRoutes.trainSession('abc'));
    await tester.pumpAndSettle();

    expect(find.byType(TrainSessionScreen), findsOneWidget);
    expect(find.text('Session abc'), findsOneWidget);
    // Parent tab screen is still on the branch's stack, below the session.
    expect(find.byType(TrainScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(TrainScreen), findsOneWidget);
    expect(find.byType(TrainSessionScreen), findsNothing);
  });

  testWidgets('nested Learn routes push inside the Learn tab', (tester) async {
    final ProviderContainer container = await pumpApp(tester);
    final GoRouter router = container.read(appRouterProvider);

    router.go(AppRoutes.learnFamily('memory_nback'));
    await tester.pumpAndSettle();
    expect(find.byType(FamilyScreen), findsOneWidget);
    expect(find.byType(LearnScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);

    router.go(AppRoutes.learnHowItWorks);
    await tester.pumpAndSettle();
    expect(find.byType(HowItWorksScreen), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('redirects to /onboarding when onboarding is not completed', (
    tester,
  ) async {
    final ProviderContainer container = await pumpApp(
      tester,
      onboardingDone: false,
    );

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(AppShell), findsNothing);

    // Completing onboarding refreshes the router and leaves the onboarding
    // route.
    container.read(onboardingCompletedProvider.notifier).complete();
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('unknown location shows the ErrorScreen', (tester) async {
    final ProviderContainer container = await pumpApp(tester);

    container.read(appRouterProvider).go('/does-not-exist');
    await tester.pumpAndSettle();

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);

    await tester.tap(find.text('Back to home'));
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
  });
}

class _NotCompletedOnboarding extends OnboardingCompletedNotifier {
  @override
  bool build() => false;
}
