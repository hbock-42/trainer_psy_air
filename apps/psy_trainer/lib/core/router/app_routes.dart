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

  /// Full location of a training session screen. The practice launcher
  /// (US-050) has no session id yet when it navigates here (the session is
  /// only created once the runner starts, US-051): it passes `'new'` and
  /// hands the built `ActivitySessionConfig` through `context.push`'s
  /// `extra`, which `TrainSessionScreen` reads to show a placeholder
  /// summary until US-051 replaces it.
  static String trainSession(String sessionId) => '$train/session/$sessionId';

  /// Relative path of the "edit my profile" screen (nested under
  /// [settings]): the onboarding answers, editable later (US-090).
  static const String settingsProfileSegment = 'profile';

  /// Full location of the "edit my profile" screen.
  static const String settingsProfile = '$settings/$settingsProfileSegment';

  /// Relative path of the "about" screen (nested under [settings], US-091):
  /// app version, disclaimer, sources.
  static const String settingsAboutSegment = 'about';

  /// Full location of the "about" screen.
  static const String settingsAbout = '$settings/$settingsAboutSegment';

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

  /// Path parameter name for a lesson id (US-041).
  static const String lessonIdParam = 'lessonId';

  /// Relative path of the lesson viewer (nested under [learnFamilySegment]).
  static const String learnLessonSegment = 'lesson/:$lessonIdParam';

  /// Full location of a lesson viewer screen.
  static String learnLesson(String familyId, String lessonId) =>
      '${learnFamily(familyId)}/lesson/$lessonId';

  /// Relative path of the practice launcher (nested under [train], US-050).
  static const String trainFamilySegment = 'family/:$familyIdParam';

  /// Where the "Essayer" / "S'entraîner" action of a family or lesson goes:
  /// that family's practice launcher.
  static String trainFamily(String familyId) => '$train/family/$familyId';

  /// Relative path of a family's flashcards screen (nested under
  /// [learnFamilySegment], US-042).
  static const String learnFamilyCardsSegment = 'cards';

  /// Full location of a family's flashcards screen.
  static String learnFamilyCards(String familyId) =>
      '${learnFamily(familyId)}/$learnFamilyCardsSegment';

  /// Relative path of the "review today" flashcards screen (nested under
  /// [learn], every deck combined; US-042).
  static const String learnCardsSegment = 'cards';

  /// Full location of the "review today" flashcards screen.
  static const String learnCards = '$learn/$learnCardsSegment';

  /// Relative path of the PSY2 interview practice screen (nested under
  /// [learn], US-111).
  static const String learnInterviewSegment = 'interview';

  /// Full location of the PSY2 interview practice screen.
  static const String learnInterview = '$learn/$learnInterviewSegment';

  /// Relative path of the PSY2 group-exercise guide and self-assessment
  /// screen (nested under [learn], US-112).
  static const String learnGroupExerciseSegment = 'group-exercise';

  /// Full location of the PSY2 group-exercise screen.
  static const String learnGroupExercise = '$learn/$learnGroupExerciseSegment';

  /// Relative path of the "Comment se passe le PSY2" overview (nested under
  /// [learn], US-111/US-112).
  static const String learnPsy2HowItWorksSegment = 'psy2-how-it-works';

  /// Full location of the PSY2 "how it works" overview.
  static const String learnPsy2HowItWorks =
      '$learn/$learnPsy2HowItWorksSegment';

  /// Relative path of the family score-over-time page (nested under
  /// [progress], US-071).
  static const String progressFamilySegment = 'family/:$familyIdParam';

  /// Full location of a family's score-over-time charts.
  static String progressFamily(String familyId) => '$progress/family/$familyId';

  /// Path parameter name for a blueprint id (US-061).
  static const String blueprintIdParam = 'blueprintId';

  /// Relative path of the exam runner (nested under [exam]).
  static const String examRunSegment = 'run/:$blueprintIdParam';

  /// Full location of the exam runner for one blueprint.
  static String examRun(String blueprintId) => '$exam/run/$blueprintId';

  /// Relative path of the exam history (nested under [exam], US-064).
  static const String examHistorySegment = 'history';

  /// Full location of the exam history.
  static const String examHistory = '$exam/$examHistorySegment';

  /// Relative path of an exam report (nested under [exam], US-062).
  static const String examReportSegment = 'report/:$sessionIdParam';

  /// Full location of one exam session's report.
  static String examReport(String sessionId) => '$exam/report/$sessionId';

  /// The tab routes, in bottom-navigation order. The index in this list is the
  /// `StatefulShellRoute` branch index.
  static const List<String> tabs = [learn, train, exam, progress, settings];

  /// Where the app lands on a cold start.
  static const String initial = learn;
}
