/// Route paths, in one place so no screen hard-codes a string.
///
/// Top-level tab routes are absolute paths. Nested routes (screens pushed on
/// top of a tab, inside that tab's navigator) are declared as *relative*
/// segments under their parent in `app_router.dart`; the helpers below return
/// the full location to pass to `context.go` / `context.push`.
///
/// Pattern for a nested route, e.g. a training session under the Train tab:
///
/// ```dart
/// // Declaration (app_router.dart): GoRoute(path: AppRoutes.trainSessionSegment)
/// // nested in the '/train' GoRoute's `routes:`.
/// // Navigation:
/// context.go(AppRoutes.trainSession('abc'));   // -> /train/session/abc
/// // Reading the parameter in the route builder:
/// state.pathParameters[AppRoutes.sessionIdParam]
/// ```
abstract final class AppRoutes {
  static const String learn = '/learn';
  static const String train = '/train';
  static const String exam = '/exam';
  static const String progress = '/progress';
  static const String settings = '/settings';
  static const String onboarding = '/onboarding';

  /// Path parameter name for a training session id.
  static const String sessionIdParam = 'sessionId';

  /// Relative path of the training session route (nested under [train]).
  static const String trainSessionSegment = 'session/:$sessionIdParam';

  /// Full location of a training session screen.
  static String trainSession(String sessionId) => '$train/session/$sessionId';

  /// Relative path of the "edit my profile" screen (nested under
  /// [settings]): the onboarding answers, editable later (US-090).
  static const String settingsProfileSegment = 'profile';

  /// Full location of the "edit my profile" screen.
  static const String settingsProfile = '$settings/$settingsProfileSegment';

  /// Path parameter name for a test family id (US-040).
  static const String familyIdParam = 'familyId';

  /// Relative path of the family page (nested under [learn]).
  static const String learnFamilySegment = 'family/:$familyIdParam';

  /// Full location of a family page (lessons + quick actions).
  static String learnFamily(String familyId) => '$learn/family/$familyId';

  /// Relative path of the "how the selection works" page (nested under
  /// [learn]).
  static const String learnHowItWorksSegment = 'how-it-works';

  /// Full location of the "how the selection works" page.
  static const String learnHowItWorks = '$learn/$learnHowItWorksSegment';

  /// Relative path of the family score-over-time page (nested under
  /// [progress], US-071).
  static const String progressFamilySegment = 'family/:$familyIdParam';

  /// Full location of a family's score-over-time charts.
  static String progressFamily(String familyId) => '$progress/family/$familyId';

  /// The tab routes, in bottom-navigation order. The index in this list is the
  /// `StatefulShellRoute` branch index.
  static const List<String> tabs = [learn, train, exam, progress, settings];

  /// Where the app lands on a cold start.
  static const String initial = learn;
}
