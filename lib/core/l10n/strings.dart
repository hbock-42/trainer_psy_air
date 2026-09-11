/// User-facing strings, French only for now.
///
/// Interim solution until US-091 introduces ARB-based localisation: every
/// screen reads its copy from here so no literal is hard-coded in a widget and
/// the migration to `flutter_localizations` is a mechanical rename.
///
/// Disclaimer wording comes verbatim from `docs/content/psy0-spec.md` §7
/// ("Disclaimer text for the app"); keep both in sync.
abstract final class AppStrings {
  static const String appName = 'PSY Trainer';

  // Tabs (bottom bar / rail), in `AppRoutes.tabs` order.
  static const String tabLearn = 'Apprendre';
  static const String tabTrain = 'Pratique';
  static const String tabExam = 'Examen';
  static const String tabProgress = 'Progrès';
  static const String tabSettings = 'Réglages';

  /// Accessibility label of the tab bar itself.
  static const String tabBarLabel = 'Navigation principale';

  // Unofficial-trainer disclaimer (spec §7).
  static const String disclaimerShort =
      'Entraîneur indépendant et non officiel — aucun lien avec Air France.';
  static const String disclaimerTitle = 'Application non officielle.';
  static const String disclaimerParagraph1 =
      'Cette application est un outil d\'entraînement indépendant. '
      'Elle n\'est ni affiliée à, ni approuvée par Air France, Transavia, '
      'l\'ENAC ou leurs prestataires. Les marques citées appartiennent à leurs '
      'propriétaires et ne sont utilisées que pour décrire le processus de '
      'sélection visé.';
  static const String disclaimerParagraph2 =
      'Les exercices, questions et durées proposés sont conçus par nous à '
      'partir d\'informations publiques et de retours de candidats ; ils sont '
      'estimatifs et ne reproduisent aucun sujet réel. Le contenu de la '
      'sélection réelle évolue chaque année. Aucun résultat obtenu ici ne '
      'préjuge de votre réussite à la sélection.';

  // Progress dashboard (US-070).
  static const String progressTitle = 'Progrès';
  static const String progressLoading = 'Calcul en cours…';
  static const String progressError = 'Impossible de charger tes statistiques.';
  static const String progressEmptyTitle = 'Aucun entraînement pour l\'instant';
  static const String progressEmptyBody =
      'Lance un premier exercice : ton score de préparation, tes niveaux par '
      'famille et ton activité apparaîtront ici.';
  static const String progressEmptyAction = 'Commencer un exercice';
  static const String readinessTitle = 'Préparation';
  static const String readinessSemanticsLabel = 'Score de préparation';

  /// `sur 100`, shown under the readiness figure.
  static const String readinessOutOf = 'sur 100';
  static const String readinessTrendUp = 'En progression';
  static const String readinessTrendFlat = 'Stable';
  static const String readinessTrendDown = 'En baisse';
  static const String readinessHint =
      'Familles pratiquées, leçons lues et simulations comptent.';
  static String readinessFamilies(int practised, int total) =>
      '$practised/$total familles pratiquées';
  static String readinessLessons(int read, int total) =>
      '$read/$total leçons lues';
  static String readinessExams(int count) => switch (count) {
    0 => 'Aucune simulation',
    1 => '1 simulation',
    _ => '$count simulations',
  };
  static const String examDateSemanticsLabel = 'Examen';
  static String examDaysLeft(int days) => switch (days) {
    0 => 'Jour J',
    1 => 'J-1',
    _ => 'J-$days',
  };
  static String examDaysLeftLong(int days) => switch (days) {
    0 => 'L\'examen est aujourd\'hui',
    1 => 'Examen dans 1 jour',
    _ => 'Examen dans $days jours',
  };
  static const String examDatePassed = 'Examen passé';
  static const String familyLevelsTitle = 'Niveaux par famille';
  static const String familyLevelsSubtitle = 'Dans l\'ordre du test réel';
  static const String familyLevelsSemanticsLabel = 'Niveaux par famille';
  static const String familyLevelsNone = 'Aucune famille pratiquée.';
  static String familyLevel(int level) => 'niveau $level sur 5';
  static const String familyNotPractised = 'non pratiquée';
  static const String weakAreasTitle = 'À travailler';
  static const String weakAreasSubtitle = 'Tes points faibles du moment';
  static const String weakAreasNone =
      'Rien à signaler : continue à t\'entraîner régulièrement.';
  static const String weakAreaTrain = 'S\'entraîner';
  static const String weakReasonLowAccuracy = 'précision faible';
  static const String weakReasonNegativeTrend = 'en baisse';
  static String weakAreaDetail(int accuracyPercent, int attempts) =>
      '$accuracyPercent % de réussite sur $attempts réponses';
  static const String recentActivityTitle = 'Activité récente';
  static const String recentActivitySubtitle = 'Exercices et simulations';
  static const String recentActivityNone = 'Aucune session terminée.';
  static const String activityPractice = 'Exercice';
  static const String activityExam = 'Simulation';
  static const String activityAbandoned = 'abandonnée';
  static const String activityInProgress = 'en cours';
  static String scorePercent(int percent) => '$percent %';
  static const String scoreUnknown = '—';
}
