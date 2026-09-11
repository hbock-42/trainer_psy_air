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

  // Common actions.
  static const String actionContinue = 'Continuer';
  static const String actionBack = 'Retour';
  static const String actionSkip = 'Passer';
  static const String actionFinish = 'Terminer';
  static const String actionSave = 'Enregistrer';

  // Onboarding (US-090).
  static const String onboardingTitle = 'Bienvenue';
  static const String onboardingEditTitle = 'Mon profil';

  /// Accessibility label of the step indicator ("Étape 2 sur 3").
  static String onboardingStepLabel(int current, int total) =>
      'Étape $current sur $total';

  // Step 1: welcome + disclaimer.
  static const String onboardingWelcomeHeadline = 'Bienvenue dans PSY Trainer';
  static const String onboardingWelcomeIntro =
      'Entraînez-vous aux activités de la présélection en ligne des cadets '
      'Air France (PSY0) : cours, exercices chronométrés et simulation '
      'd\'examen. Avant de commencer, une précision importante.';
  static const String onboardingDisclaimerAccept =
      'J\'ai compris que cette application est un entraîneur indépendant, '
      'sans lien avec Air France, et que ses exercices sont estimatifs.';
  static const String onboardingDisclaimerRequired =
      'Acceptez cette mention pour continuer.';

  // Step 2: exam date.
  static const String onboardingExamDateHeadline =
      'Quand passez-vous le PSY0 ?';
  static const String onboardingExamDateIntro =
      'La présélection a lieu le premier week-end de septembre. La date '
      'sert à rythmer votre préparation ; vous pourrez la modifier dans les '
      'réglages.';
  static const String onboardingExamDateSuggestion =
      'Prochaine session probable : ';
  static const String onboardingExamDateUnknown = 'Je ne sais pas encore';
  static const String onboardingExamDateInThePast =
      'Cette date est déjà passée. Choisissez une date à venir.';
  static const String dateFieldDay = 'Jour';
  static const String dateFieldMonth = 'Mois';
  static const String dateFieldYear = 'Année';
  static const String dateFieldIncrement = 'Suivant';
  static const String dateFieldDecrement = 'Précédent';

  /// Full French month names, index 1..12 (index 0 unused).
  static const List<String> monthNames = [
    '',
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  /// Short French month names, index 1..12 (index 0 unused).
  static const List<String> monthNamesShort = [
    '',
    'janv.',
    'févr.',
    'mars',
    'avr.',
    'mai',
    'juin',
    'juil.',
    'août',
    'sept.',
    'oct.',
    'nov.',
    'déc.',
  ];

  /// Weekday names, index 1 (Monday)..7 (Sunday) as `DateTime.weekday`.
  static const List<String> weekdayNames = [
    '',
    'lundi',
    'mardi',
    'mercredi',
    'jeudi',
    'vendredi',
    'samedi',
    'dimanche',
  ];

  /// "samedi 4 septembre 2027".
  static String formatLongDate(DateTime date) =>
      '${weekdayNames[date.weekday]} ${date.day} '
      '${monthNames[date.month]} ${date.year}';

  // Step 3: target stage.
  static const String onboardingStageHeadline = 'Quelle étape préparez-vous ?';
  static const String onboardingStageIntro =
      'Le contenu de l\'application suit l\'étape choisie. Seul le PSY0 est '
      'disponible pour le moment.';
  static const String stagePsy0Title = 'PSY0 — présélection en ligne';
  static const String stagePsy0Subtitle =
      'Tests cognitifs, culture aéronautique et anglais, à distance.';
  static const String stagePsy1Title = 'PSY1 — tests psychotechniques';
  static const String stagePsy2Title = 'PSY2 — sélection finale';
  static const String stageComingSoon = 'Bientôt';

  // Settings (placeholder until US-091).
  static const String settingsEditProfile = 'Modifier mon profil';
  static const String settingsProfileSummaryExamDate = 'Date d\'examen : ';
  static const String settingsProfileSummaryNoExamDate = 'non renseignée';
  static const String settingsProfileSummaryStage = 'Étape visée : ';
}
