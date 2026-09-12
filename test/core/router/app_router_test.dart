import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
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
import 'package:psy_trainer/features/settings/presentation/edit_profile_screen.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_screen.dart';
import 'package:psy_trainer/features/train/presentation/train_session_screen.dart';

import '../../helpers/content_ready_fakes.dart';
import '../../helpers/onboarding_fakes.dart';
import '../../helpers/psy0_families.dart';

/// Pumps the whole app over an in-memory profile that has (or, with
/// [onboardingDone] false, has not) completed onboarding. With [settle]
/// false the first frame is left as is, before the guard has read the
/// profile.
Future<ProviderContainer> pumpApp(
  WidgetTester tester, {
  bool onboardingDone = true,
  bool settle = true,
  ProgressRepository? repository,
}) async {
  final ProviderContainer container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(psy0ContentRepository()),
      progressRepositoryOverride(
        repository: repository,
        completed: onboardingDone,
      ),
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
  if (settle) await tester.pumpAndSettle();
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

  testWidgets('renders nothing until the guard has read the profile', (
    tester,
  ) async {
    final repository = _SlowProgressRepository();
    final ProviderContainer container = await pumpApp(
      tester,
      settle: false,
      repository: repository,
    );
    await tester.pump();

    // While the flag is being read no route is shown at all: in particular
    // a returning user never sees the onboarding flash.
    expect(container.read(onboardingCompletedProvider), isNull);
    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(AppShell), findsNothing);

    repository.release();
    await tester.pumpAndSettle();
    expect(container.read(onboardingCompletedProvider), isTrue);
    expect(find.byType(LearnScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
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
    await container
        .read(onboardingCompletedProvider.notifier)
        .complete(completedAnswers);
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(LearnScreen), findsOneWidget);
  });

  testWidgets('a hydrated guard redirects synchronously on later navigation', (
    tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);
    final GoRouter router = container.read(appRouterProvider);

    // Resetting the flag sends the current tab to onboarding on refresh.
    container.read(onboardingCompletedProvider.notifier).reset();
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);

    // And a deliberate navigation to a tab is bounced back synchronously.
    router.go(AppRoutes.train);
    await tester.pump();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(TrainScreen), findsNothing);
  });

  testWidgets('nested route /settings/profile opens the profile editor', (
    tester,
  ) async {
    final ProviderContainer container = await pumpApp(tester);
    final GoRouter router = container.read(appRouterProvider);

    router.go(AppRoutes.settingsProfile);
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileScreen), findsOneWidget);
    expect(find.byType(SettingsScreen, skipOffstage: false), findsOneWidget);
    expect(find.byType(AppShell), findsOneWidget);
  });

  testWidgets('unknown location shows the ErrorScreen', (tester) async {
    final ProviderContainer container = await pumpApp(tester);

    container.read(appRouterProvider).go('/does-not-exist');
    await tester.pumpAndSettle();

    expect(find.byType(ErrorScreen), findsOneWidget);
    expect(find.text(AppStrings.errorTitle), findsOneWidget);

    await tester.tap(find.text(AppStrings.errorBackHome));
    await tester.pumpAndSettle();
    expect(find.byType(LearnScreen), findsOneWidget);
  });
}

/// A completed profile whose first read only answers after [release].
class _SlowProgressRepository extends InMemoryProgressRepository {
  _SlowProgressRepository() {
    storedProfile = completedAnswers.applyTo(null);
  }

  final Completer<void> _gate = Completer<void>();

  void release() => _gate.complete();

  @override
  Future<UserProfile?> profile() async {
    await _gate.future;
    return super.profile();
  }
}
