import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/exam/presentation/exam_screen.dart';
import '../../features/learn/presentation/family_screen.dart';
import '../../features/learn/presentation/how_it_works_screen.dart';
import '../../features/learn/presentation/learn_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_completed_provider.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/train/presentation/train_screen.dart';
import '../../features/train/presentation/train_session_screen.dart';
import 'app_page.dart';
import 'app_redirect.dart';
import 'app_routes.dart';
import 'app_shell.dart';
import 'error_screen.dart';

/// The app's [GoRouter], owned by Riverpod so the redirect can read other
/// providers and the router is rebuilt/refreshed when they change.
final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((ref) {
  final GoRouter router = createAppRouter(
    isOnboardingDone: () => ref.read(onboardingCompletedProvider),
  );
  // Re-evaluate the redirect whenever the guard's input changes, without
  // recreating the router (which would lose navigation state).
  ref.listen<bool>(onboardingCompletedProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});

/// Builds the route table. Exposed as a function so tests can construct a
/// router with their own guard inputs and no [ProviderContainer].
///
/// Route structure:
///
/// ```
/// /onboarding                       (outside the shell, root navigator)
/// StatefulShellRoute.indexedStack   (AppShell; one branch per tab)
///   /learn
///     family/:familyId             (nested: /learn/family/:familyId)
///     how-it-works                 (nested: /learn/how-it-works)
///   /train
///     session/:sessionId            (nested: /train/session/:sessionId)
///   /exam
///   /progress
///   /settings
/// ```
///
/// Every route goes through [AppPage] (`pageBuilder`), never `builder`, so
/// go_router does not fall back to a platform page type.
GoRouter createAppRouter({
  required ValueGetter<bool> isOnboardingDone,
  String initialLocation = AppRoutes.initial,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    redirect: (context, state) => computeRedirect(
      onboardingDone: isOnboardingDone(),
      location: state.matchedLocation,
    ),
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _page(state, const OnboardingScreen()),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (context, state, navigationShell) =>
            _page(state, AppShell(navigationShell: navigationShell)),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.learn,
                pageBuilder: (context, state) =>
                    _page(state, const LearnScreen()),
                routes: [
                  GoRoute(
                    path: AppRoutes.learnFamilySegment,
                    pageBuilder: (context, state) => _page(
                      state,
                      FamilyScreen(
                        familyId:
                            state.pathParameters[AppRoutes.familyIdParam]!,
                      ),
                    ),
                  ),
                  GoRoute(
                    path: AppRoutes.learnHowItWorksSegment,
                    pageBuilder: (context, state) =>
                        _page(state, const HowItWorksScreen()),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.train,
                pageBuilder: (context, state) =>
                    _page(state, const TrainScreen()),
                routes: [
                  // Nested route pattern: relative path, pushed inside the
                  // Train tab's navigator so the tab stays selected.
                  GoRoute(
                    path: AppRoutes.trainSessionSegment,
                    pageBuilder: (context, state) => _page(
                      state,
                      TrainSessionScreen(
                        sessionId:
                            state.pathParameters[AppRoutes.sessionIdParam]!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.exam,
                pageBuilder: (context, state) =>
                    _page(state, const ExamScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                pageBuilder: (context, state) =>
                    _page(state, const ProgressScreen()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    _page(state, const SettingsScreen()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

AppPage<void> _page(GoRouterState state, Widget child) =>
    AppPage<void>(key: state.pageKey, name: state.uri.toString(), child: child);
