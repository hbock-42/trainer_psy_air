import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/exam/presentation/exam_screen.dart';
import '../../features/learn/presentation/family_screen.dart';
import '../../features/learn/presentation/flashcards/flashcards_screen.dart';
import '../../features/learn/presentation/how_it_works_screen.dart';
import '../../features/learn/presentation/learn_screen.dart';
import '../../features/learn/presentation/lesson_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/providers/onboarding_completed_provider.dart';
import '../../features/progress/presentation/family_trend_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/settings/presentation/edit_profile_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/train/domain/engine/activity_session_config.dart';
import '../../features/train/presentation/launcher/practice_launcher_screen.dart';
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
    isOnboardingDone: () =>
        ref.read(onboardingCompletedProvider.notifier).whenHydrated(),
  );
  // Re-evaluate the redirect whenever the guard's input changes, without
  // recreating the router (which would lose navigation state).
  ref.listen<bool?>(onboardingCompletedProvider, (_, _) => router.refresh());
  ref.onDispose(router.dispose);
  return router;
});

/// Builds the route table. Exposed as a function so tests can construct a
/// router with their own guard inputs and no [ProviderContainer].
///
/// [isOnboardingDone] may answer with a `Future` while the flag is still
/// being read from the database: the redirect then awaits it, and go_router
/// renders nothing (an empty `SizedBox`) until the first location is known,
/// so a returning user never sees the onboarding flash. Once hydrated the
/// guard answers synchronously and navigation stays synchronous.
///
/// Route structure:
///
/// ```
/// /onboarding                       (outside the shell, root navigator)
/// StatefulShellRoute.indexedStack   (AppShell; one branch per tab)
///   /learn
///     family/:familyId             (nested: /learn/family/:familyId)
///       lesson/:lessonId            (nested: /learn/family/:familyId/lesson/:lessonId)
///       cards                      (nested: /learn/family/:familyId/cards, US-042)
///     how-it-works                 (nested: /learn/how-it-works)
///     cards                        (nested: /learn/cards, "review today", US-042)
///   /train
///     family/:familyId              (nested: /train/family/:familyId, US-050)
///     session/:sessionId            (nested: /train/session/:sessionId)
///   /exam
///   /progress
///     family/:familyId             (nested: /progress/family/:familyId)
///   /settings
///     profile                       (nested: /settings/profile, edit onboarding)
/// ```
///
/// Every route goes through [AppPage] (`pageBuilder`), never `builder`, so
/// go_router does not fall back to a platform page type.
GoRouter createAppRouter({
  required ValueGetter<FutureOr<bool>> isOnboardingDone,
  String initialLocation = AppRoutes.initial,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation,
    redirect: (context, state) {
      final FutureOr<bool> done = isOnboardingDone();
      final String location = state.matchedLocation;
      if (done is bool) {
        return computeRedirect(onboardingDone: done, location: location);
      }
      return done.then(
        (value) => computeRedirect(onboardingDone: value, location: location),
      );
    },
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
                    routes: [
                      GoRoute(
                        path: AppRoutes.learnLessonSegment,
                        pageBuilder: (context, state) => _page(
                          state,
                          LessonScreen(
                            familyId:
                                state.pathParameters[AppRoutes.familyIdParam]!,
                            lessonId:
                                state.pathParameters[AppRoutes.lessonIdParam]!,
                          ),
                        ),
                      ),
                      GoRoute(
                        path: AppRoutes.learnFamilyCardsSegment,
                        pageBuilder: (context, state) => _page(
                          state,
                          FlashcardsScreen(
                            familyId:
                                state.pathParameters[AppRoutes.familyIdParam]!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: AppRoutes.learnHowItWorksSegment,
                    pageBuilder: (context, state) =>
                        _page(state, const HowItWorksScreen()),
                  ),
                  GoRoute(
                    path: AppRoutes.learnCardsSegment,
                    pageBuilder: (context, state) =>
                        _page(state, const FlashcardsScreen()),
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
                  // Practice launcher (US-050): number of items, difficulty,
                  // timed on/off for one family.
                  GoRoute(
                    path: AppRoutes.trainFamilySegment,
                    pageBuilder: (context, state) => _page(
                      state,
                      PracticeLauncherScreen(
                        familyId:
                            state.pathParameters[AppRoutes.familyIdParam]!,
                      ),
                    ),
                  ),
                  // Nested route pattern: relative path, pushed inside the
                  // Train tab's navigator so the tab stays selected. The
                  // launcher passes the built `ActivitySessionConfig` as
                  // `extra` (US-051 replaces this screen with the real
                  // runner).
                  GoRoute(
                    path: AppRoutes.trainSessionSegment,
                    pageBuilder: (context, state) => _page(
                      state,
                      TrainSessionScreen(
                        sessionId:
                            state.pathParameters[AppRoutes.sessionIdParam]!,
                        config: state.extra as ActivitySessionConfig?,
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
                routes: [
                  // Score-over-time charts of one family (US-071).
                  GoRoute(
                    path: AppRoutes.progressFamilySegment,
                    pageBuilder: (context, state) => _page(
                      state,
                      FamilyTrendScreen(
                        familyId:
                            state.pathParameters[AppRoutes.familyIdParam]!,
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
                path: AppRoutes.settings,
                pageBuilder: (context, state) =>
                    _page(state, const SettingsScreen()),
                routes: [
                  // Edit the onboarding answers later, inside the Settings
                  // tab (US-090).
                  GoRoute(
                    path: AppRoutes.settingsProfileSegment,
                    pageBuilder: (context, state) =>
                        _page(state, const EditProfileScreen()),
                  ),
                ],
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
