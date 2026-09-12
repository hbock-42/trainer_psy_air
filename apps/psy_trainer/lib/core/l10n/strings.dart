import 'package:psy_content/psy_content.dart';

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
  static const String actionRetry = 'Réessayer';

  // Startup (US-013) and error screen.
  static const String startupLoadingContent = 'Chargement du contenu…';
  static const String errorTitle = 'Une erreur est survenue';
  static const String errorUnknown = 'Erreur inconnue';
  static const String errorBackHome = 'Retour à l\'accueil';

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
  // Stage titles (`stagePsyNTitle`) are shared with the Learn "how it works"
  // page below.
  static const String stagePsy0Subtitle =
      'Tests cognitifs, culture aéronautique et anglais, à distance.';
  static const String stageComingSoon = 'Bientôt';

  // Settings (placeholder until US-091).
  static const String settingsEditProfile = 'Modifier mon profil';
  static const String settingsProfileSummaryExamDate = 'Date d\'examen : ';
  static const String settingsProfileSummaryNoExamDate = 'non renseignée';
  static const String settingsProfileSummaryStage = 'Étape visée : ';

  /// UI locale used to resolve `LocalizedText` until US-091 adds a setting.
  static const String locale = 'fr';

  // Learn home (US-040).
  static const String learnDisclaimerExpand = 'Lire l\'avertissement complet';
  static const String learnDisclaimerCollapse = 'Réduire l\'avertissement';
  static const String learnHowItWorksTitle = 'Comment se passe la sélection';
  static const String learnHowItWorksSubtitle =
      'Dossier, PSY0, PSY1, PSY2, médical : les étapes, ce qui est '
      'éliminatoire et ce que l\'on sait vraiment.';
  static const String learnHowItWorksSemantics =
      'Comment se passe la sélection, ouvrir la page';
  static const String learnFamiliesTitle = 'Les activités du PSY0';
  static const String learnFamiliesSubtitle =
      'Dans l\'ordre du test réel, tel que rapporté par les candidats.';
  static const String learnFamiliesLoading = 'Chargement des activités…';
  static const String learnFamiliesError =
      'Impossible de charger les activités. Relancez l\'application ; si le '
      'problème persiste, réinstallez-la.';
  static const String learnEmptyTitle = 'Aucune activité pour le moment';
  static const String learnEmptyBody =
      'Les fiches des activités PSY0 (mémoire, attention, spatial, logique, '
      'culture aéronautique, anglais…) apparaîtront ici dès que le contenu '
      'sera installé.';

  // Family card and family page (US-040).
  static const String familyMasteryLabel = 'Maîtrise';
  static const String familyMasteryUnknown = '—';
  static const String familyActionLearn = 'Apprendre';
  static const String familyActionTrain = 'S\'entraîner';
  static const String familyActionCards = 'Cartes';
  static const String familyLessonsTitle = 'Leçons';
  static const String familyLessonsEmpty =
      'Aucune leçon pour cette activité pour le moment.';
  static const String familyNotFound = 'Activité introuvable.';
  static const String familyLoading = 'Chargement…';
  static const String familyFormatLabel = 'Format';
  static const String familyEvaluatedLabel = 'Ce qui est évalué';

  /// `42 items · ~2 min`, plus `· ~40 s par item` when a per-item time exists.
  static String familyFormat({
    required int itemCount,
    required int durationSec,
    int? perItemSec,
  }) {
    final parts = [
      '$itemCount ${itemCount > 1 ? 'items' : 'item'}',
      '~${duration(durationSec)}',
      if (perItemSec != null) '~${duration(perItemSec)} par item',
    ];
    return parts.join(' · ');
  }

  /// `45 s`, `2 min`, `1 min 45 s`.
  static String duration(int seconds) {
    final minutes = seconds ~/ 60;
    final rest = seconds % 60;
    if (minutes == 0) return '$rest s';
    if (rest == 0) return '$minutes min';
    return '$minutes min $rest s';
  }

  /// `72 %` for a mastery ratio in `[0, 1]`.
  static String masteryPercent(double ratio) => '${(ratio * 100).round()} %';

  static String familyOpenSemantics(String name) =>
      '$name, ouvrir la fiche de l\'activité';

  static String lessonReadTime(int minutes) => '$minutes min de lecture';

  // Confidence tags (spec "How to read this document").
  static const String confidenceConfirmed = 'confirmé';
  static const String confidenceReported = 'rapporté';
  static const String confidenceAssumed = 'estimé';
  static const String confidenceLegend =
      'confirmé = source officielle Air France · rapporté = retours de '
      'candidats concordants · estimé = notre meilleure hypothèse';

  // "How the selection works" page (spec §1).
  static const String howItWorksIntro =
      'La sélection Cadets Air France enchaîne plusieurs étapes, toutes '
      'éliminatoires. Cette application prépare le PSY0 ; voici où il se '
      'situe.';
  static const String howItWorksStagesTitle = 'Les étapes';
  static const String howItWorksCalendarTitle = 'Calendrier 2026';
  static const String howItWorksCalendarBody =
      'Candidatures ~15 juin → 31 juillet · PSY0 4–5 septembre · '
      'PSY1 19–30 octobre · PSY2 à partir de janvier 2027.';
  static const String howItWorksRetakeTitle = 'Règles de repassage';
  static const String howItWorksRetakeBody =
      '3 échecs au PSY0 ou 2 échecs au PSY1 = exclusion définitive de la '
      'filière Cadets (la filière « Pilote professionnel » reste ouverte). '
      'Un ajournement au PSY2 = une nouvelle tentative après 1 ou 2 ans.';
  static const String howItWorksEliminatory = 'Éliminatoire';

  static const String stageDossierTitle = 'Dossier de candidature';
  static const String stageDossierWhen = 'Juin – juillet, en ligne';
  static const String stageDossierBody =
      'Candidature sur le portail de recrutement Air France. Vérification '
      'des prérequis (diplôme, médical classe 2, nationalité) ; frais de '
      '200 €. Seuls les dossiers recevables sont invités au PSY0.';
  static const String stageDossierFactFee = '200 € de frais';

  static const String stagePsy0Title = 'PSY0 — pré-sélection';
  static const String stagePsy0When =
      'Premier week-end de septembre, à distance, logiciel sécurisé + webcam';
  static const String stagePsy0Body =
      'Batterie en ligne d\'environ 3 h dans une fenêtre de 36 h : ~14 '
      'activités courtes (mémoire, attention, spatial, logique, planification, '
      'calcul, multitâche), culture générale aéronautique et anglais renforcé. '
      'Produit un classement ; une liste d\'attente existe.';
  static const String stagePsy0FactDuration = '~3 h, fenêtre de 36 h';
  static const String stagePsy0FactActivities = '14 activités';
  static const String stagePsy0FactWaitlist = 'Liste d\'attente';

  static const String stagePsy1Title = 'PSY1 — tests psychotechniques';
  static const String stagePsy1When =
      'Une journée pendant les vacances de la Toussaint';
  static const String stagePsy1Body =
      'Tests cognitifs et psychomoteurs sur ordinateur : joysticks, double '
      'tâche, poursuite de cible, matrices, compteurs… Élimination rapportée '
      'autour de 70 %.';
  static const String stagePsy1FactDay = 'Une journée, Toussaint';
  static const String stagePsy1FactVenue = 'ENAC Toulouse';
  static const String stagePsy1FactRate = '~70 % d\'élimination';

  static const String stagePsy2Title = 'PSY2 — sélection finale';
  static const String stagePsy2When =
      'À partir de janvier, Roissy-CDG, service de sélection Air France';
  static const String stagePsy2Body =
      'Deux inventaires de personnalité, un exercice de groupe (sous '
      'confidentialité) et un entretien individuel avec psychologues et '
      'pilotes. La commission de recrutement prononce la réussite ou '
      'l\'ajournement.';
  static const String stagePsy2FactContent = 'Personnalité, groupe, entretien';
  static const String stagePsy2FactCoaching =
      'Coaching payant : « aucune plus-value » selon Air France';

  static const String stageMedicalTitle = 'Médical classe 1';
  static const String stageMedicalWhen = 'Avant l\'entrée en formation';
  static const String stageMedicalBody =
      'Un certificat médical de classe 2 est exigé dès la candidature ; la '
      'classe 1 est obligatoire avant d\'entrer en école de pilotage.';
  static const String stageMedicalFactClass2 = 'Classe 2 à la candidature';
  static const String stageMedicalFactClass1 = 'Classe 1 avant la formation';

  static const String stageTrainingTitle = 'Formation';
  static const String stageTrainingWhen = '24 mois en école partenaire';
  static const String stageTrainingBody =
      '9 mois de théorie ATPL puis 15 à 21 mois de CPL/IR-ME/MCC, logé et '
      'rémunéré (contrat de professionnalisation). Affectation Air France ou '
      'Transavia, non choisie par le cadet.';
  static const String stageTrainingFactDuration = '24 mois, rémunérée';

  // Activity session runtime (US-020): briefing, running, paused, finished.
  static const String sessionStart = 'Commencer';
  static const String sessionNext = 'Suivant';
  static const String sessionPause = 'Pause';
  static const String sessionResume = 'Reprendre';
  static const String sessionQuit = 'Quitter';
  static const String sessionPausedTitle = 'Session en pause';
  static const String sessionFinishedTitle = 'Activité terminée';
  static const String sessionBriefingDefault =
      'Lisez les consignes, puis appuyez sur Commencer. Le chronomètre '
      'démarre avec la première question.';
  static const String sessionExamplePlaceholder = 'Exemple à venir.';
  static const String sessionFeedbackCorrect = 'Bonne réponse';
  static const String sessionFeedbackWrong = 'Mauvaise réponse';
  static const String sessionFeedbackTimeout = 'Temps écoulé';
  static const String sessionFeedbackSkipped = 'Question passée';

  /// Accessibility label of the per-item countdown.
  static const String sessionItemTimerLabel = 'Temps pour cette question';

  /// Accessibility label of the section countdown.
  static const String sessionSectionTimerLabel = 'Temps restant';

  static String sessionItemCount(int count) =>
      count == 1 ? '1 question' : '$count questions';

  static String sessionResumeHint(int next, int total) =>
      'Reprise à la question $next sur $total';

  // Item renderers (US-021 MCQ, US-022 numeric).
  static const String activityValidate = 'Valider';
  static const String activityExplanationTitle = 'Explication';
  static const String mcqSkipOption = 'Je ne sais pas';
  static const String mcqPassageDefaultTitle = 'Texte de référence';
  static const String mcqPassageShow = 'Afficher le texte';
  static const String mcqPassageHide = 'Masquer le texte';
  static const String mcqExampleStem = 'Quelle est la capitale de la France ?';
  static const String mcqExampleOptionCorrect = 'Paris';
  static const String mcqExampleOptionWrong1 = 'Lyon';
  static const String mcqExampleOptionWrong2 = 'Marseille';
  static const String numericAnswerSemanticsLabel = 'Réponse';
  static const String numericBackspaceSemanticsLabel = 'Effacer';

  // culture_aero (US-028): perishable-fact footer for `McqItem.validAsOf`.
  /// "Donnée valable au 1 septembre 2026."
  static String cultureValidAsOf(DateTime date) =>
      'Donnée valable au ${date.day} ${monthNames[date.month]} ${date.year}.';
  static const String numericExampleStem = 'Combien font 8 × 6 ?';

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

  // "Train next" (US-072): TrainNextCard replaces WeakAreasPreview.
  static const String trainNextTitle = 'À faire ensuite';
  static const String trainNextSubtitle =
      'Ce qui fera le plus progresser ta préparation';
  static const String trainNextEmpty =
      'Rien à recommander pour le moment : continue à t\'entraîner '
      'régulièrement.';
  static const String trainNextActionFamily = 'S\'entraîner';
  static const String trainNextActionExam = 'Simuler l\'examen';
  static const String trainNextActionLesson = 'Lire la leçon';
  static const String trainNextActionFlashcards = 'Réviser';

  static const String recentActivityTitle = 'Activité récente';
  static const String recentActivitySubtitle = 'Exercices et simulations';
  static const String recentActivityNone = 'Aucune session terminée.';
  static const String activityPractice = 'Exercice';
  static const String activityExam = 'Simulation';
  static const String activityAbandoned = 'abandonnée';
  static const String activityInProgress = 'en cours';
  static String scorePercent(int percent) => '$percent %';
  static const String scoreUnknown = '—';

  // Lesson viewer (US-041), worked examples (US-043), learning progress
  // (US-044).
  static const String lessonCalloutTip = 'Astuce';
  static const String lessonCalloutTrap = 'Piège';
  static const String lessonCalloutMethod = 'Méthode';
  static const String lessonCalloutExample = 'Exemple';
  static const String lessonImagePlaceholder = 'Image';
  static const String lessonRevealNextStep = 'Étape suivante';
  static const String lessonRevealAllSteps = 'Tout afficher';
  static const String lessonTocTitle = 'Sommaire';
  static const String lessonTocShow = 'Afficher le sommaire';
  static const String lessonTocHide = 'Masquer le sommaire';
  static const String lessonTryIt = 'Essayer';
  static const String lessonPrevious = 'Leçon précédente';
  static const String lessonNext = 'Leçon suivante';
  static const String lessonMarkRead = 'Marquer comme lue';
  static const String lessonMarkedRead = 'Lue';
  static const String lessonNotFound = 'Leçon introuvable.';
  static const String lessonLoading = 'Chargement…';

  static String familyLessonsProgress(int read, int total) =>
      '$read/$total leçons';

  static String familyLessonsProgressSemantics(int read, int total) =>
      '$read leçons lues sur $total';

  // Flashcards (US-042).
  static const String flashcardsHomeTitle = 'À réviser aujourd\'hui';
  static String flashcardsHomeCount(int count) => switch (count) {
    0 => 'Aucune carte à réviser',
    1 => '1 carte à réviser',
    _ => '$count cartes à réviser',
  };
  static const String flashcardsHomeSemantics =
      'Réviser les cartes du jour, ouvrir la session';
  static const String flashcardsTitle = 'Cartes';
  static const String flashcardsLoading = 'Chargement des cartes…';
  static const String flashcardsError = 'Impossible de charger les cartes.';

  /// `12 à réviser · 48 au total`.
  static String flashcardsDeckSummary({required int due, required int total}) =>
      '$due à réviser · $total au total';
  static const String flashcardsStart = 'Commencer';
  static const String flashcardsEmptyTitle = 'Rien à réviser';
  static const String flashcardsEmptyBody =
      'Toutes les cartes de ce paquet sont à jour. Reviens plus tard.';
  static const String flashcardsFlipHint = 'Appuie ou Espace pour retourner';
  static const String flashcardsAgain = 'À revoir';
  static const String flashcardsHard = 'Difficile';
  static const String flashcardsGood = 'Facile';
  static const String flashcardsAgainSemantics = 'À revoir (touche 1)';
  static const String flashcardsHardSemantics = 'Difficile (touche 2)';
  static const String flashcardsGoodSemantics = 'Facile (touche 3)';
  static String flashcardsProgress(int index, int total) =>
      'Carte $index sur $total';
  static const String flashcardsSummaryTitle = 'Session terminée';
  static String flashcardsSummaryBody({
    required int again,
    required int hard,
    required int good,
  }) =>
      '$good facile${good > 1 ? 's' : ''} · $hard difficile${hard > 1 ? 's' : ''} '
      '· $again à revoir';
  static const String flashcardsSummaryDone = 'Terminer';
  static const String flashcardsBackSemantics = 'Retour';

  // Score-over-time charts (US-071).
  static const String familyDetailsTitle = 'Détails par famille';
  static const String familyDetailsHint =
      'Touche une famille pour voir son évolution.';
  static String familyTrendOpenSemantics(String name) =>
      'Voir l\'évolution de $name';
  static const String familyTrendTitle = 'Évolution';
  static const String trendRangeLabel = 'Période';
  static const String trendRange7d = '7 j';
  static const String trendRange30d = '30 j';
  static const String trendRangeAll = 'Tout';
  static const String trendModeLabel = 'Mode';
  static const String trendModeAll = 'Tous';
  static const String trendModePractice = 'Exercices';
  static const String trendModeExam = 'Simulations';
  static const String trendAccuracyTitle = 'Précision';
  static const String trendAccuracySubtitle = 'Réussite par session';
  static const String trendSpeedTitle = 'Vitesse';
  static const String trendSpeedSubtitle =
      'Temps de réponse médian par session';
  static const String trendEmpty = 'Aucune session sur cette période.';
  static const String trendLoading = 'Calcul en cours…';
  static const String trendAccuracyLabel = 'Réussite';
  static const String trendSpeedLabel = 'Temps';

  /// `1,2 s`: a response time in seconds with one decimal.
  static String seconds(double seconds) =>
      '${seconds.toStringAsFixed(1).replaceFirst('.', ',')} s';
  static String sessionsCount(int count) =>
      count == 1 ? '1 session' : '$count sessions';
  static String trendAccuracySummary(int fromPercent, int toPercent, int n) =>
      n == 1
      ? '$toPercent % sur 1 session'
      : 'de $fromPercent % à $toPercent % sur ${sessionsCount(n)}';
  static String trendSpeedSummary(double fromSec, double toSec, int n) => n == 1
      ? '${seconds(toSec)} sur 1 session'
      : 'de ${seconds(fromSec)} à ${seconds(toSec)} sur ${sessionsCount(n)}';
  static String trendTooltipAccuracy(int correct, int attempts, int percent) =>
      '$trendAccuracyLabel : $correct/$attempts ($percent %)';
  static String trendTooltipSpeed(double seconds) =>
      '$trendSpeedLabel : ${AppStrings.seconds(seconds)}';
  static const String examChartTitle = 'Simulations';
  static const String examChartSubtitle = 'Score global par simulation';
  static const String examChartSemanticsLabel = 'Scores des simulations';
  static const String examChartHint =
      'Touche un point pour le détail par section.';
  static String examChartSummary(int fromPercent, int toPercent, int n) =>
      n == 1
      ? '$toPercent % sur 1 simulation'
      : 'de $fromPercent % à $toPercent % sur $n simulations';
  static String examAttempt(int number) => 'Simulation $number';
  static String examScoreLine(int percent) => 'Score : $percent %';
  static String examSectionsTitle(String date) => 'Sections du $date';
  static const String examSectionsSemanticsLabel = 'Détail par section';
  static String examSectionLabel(int number, String family) =>
      '$number. $family';
  static String examSectionValue(int correct, int attempts, int percent) =>
      '$correct/$attempts · $percent %';
  static const String examSectionNotReached = 'non atteinte';

  // Dominos (US-024, spec §2.4-G).
  static const String actionValidate = 'Valider';
  static const String dominoTopLabel = 'Haut';
  static const String dominoBottomLabel = 'Bas';
  static const String dominoMissingSemantics = 'Domino manquant';
  static String dominoSelectorSemantics(String half, int value) =>
      '$half : $value';
  static String dominoAnswerSummary(int top, int bottom) =>
      'Réponse : $top | $bottom';
  static const String dominoRuleLinearEachHalf =
      'Une moitié avance de façon régulière (+k modulo 7).';
  static const String dominoRuleAlternatingTopBottom =
      'Les moitiés haute et basse avancent chacune leur tour (+k modulo 7).';
  static const String dominoRuleMirroredHalves =
      'La moitié basse est le miroir de la moitié haute (leur somme fait 6).';
  static const String dominoRuleConstantSum =
      'La somme des deux moitiés reste la même sur toute la série.';
  static const String dominoRuleInterleavedSeries =
      'Deux séries s\'entrelacent : une pour les positions paires, une pour '
      'les impaires.';
  // Memory N-back (US-026).
  static const String nbackYes = 'Oui';
  static const String nbackNo = 'Non';
  static String nbackYesSemantics(String shortcut) => 'Oui ($shortcut)';
  static String nbackNoSemantics(String shortcut) => 'Non ($shortcut)';
  static const String nbackPrimerLabel = 'Amorce — pas de réponse attendue';
  static const String nbackHistoryStripLabel = 'Repère (derniers stimuli)';
  static String nbackStimulusSemantics(int index) => 'Stimulus $index';
  // Formes et couleurs (US-029, attention_rules).
  static const String attentionRulesTouchFallback =
      'Touches non représentatives : le jour J, utilisez le clavier.';

  static String attentionRulesExampleFilled(
    StimulusShape shapeA,
    String keyA,
    StimulusShape shapeB,
    String keyB,
  ) =>
      'Forme pleine : ${_shapeName(shapeA)} → ${keyA.toUpperCase()}, '
      '${_shapeName(shapeB)} → ${keyB.toUpperCase()}';

  static String attentionRulesExampleEmpty(
    StimulusColour colourA,
    String keyA,
    StimulusColour colourB,
    String keyB,
  ) =>
      'Forme vide : ${_colourName(colourA)} → ${keyA.toUpperCase()}, '
      '${_colourName(colourB)} → ${keyB.toUpperCase()}';

  static String _shapeName(StimulusShape shape) => switch (shape) {
    StimulusShape.square => 'carré',
    StimulusShape.triangle => 'triangle',
    StimulusShape.circle => 'cercle',
    StimulusShape.diamond => 'losange',
    StimulusShape.star => 'étoile',
  };

  static String _colourName(StimulusColour colour) => switch (colour) {
    StimulusColour.blue => 'bleu',
    StimulusColour.orange => 'orange',
    StimulusColour.green => 'vert',
    StimulusColour.pink => 'rose',
    StimulusColour.red => 'rouge',
    StimulusColour.yellow => 'jaune',
  };
  // Arithmetic grid engine (US-023).
  static const String arithmeticGridValidate = 'Valider';
  static String arithmeticGridCellSemantics(int index, String label) =>
      'Égalité $index, $label';
  static String arithmeticGridCorrectValue(int value) => 'Correct : $value';
  static const String arithmeticGridExampleCaption =
      'Touchez les égalités fausses (en rouge) puis Valider. Les autres '
      'sont justes, ne les touchez pas.';
  // Train home and practice launcher (US-050).
  static const String trainFamiliesSubtitle = 'Choisis une activité';
  static const String trainFamiliesLoading = 'Chargement des activités…';
  static const String trainFamiliesError =
      'Impossible de charger les activités.';
  static const String trainFamiliesEmpty =
      'Aucune activité disponible pour le moment.';
  static const String trainFamilyComingSoon = 'Bientôt';
  static String trainFamilyComingSoonHint(String name) =>
      '$name arrive bientôt.';
  static String trainFamilyOpenSemantics(String name) => 'S\'entraîner : $name';
  static const String trainQuick5Label = 'Rapide (5)';
  static String trainQuick5Semantics(String name) =>
      'Démarrage rapide : 5 questions sur $name';

  static const String practiceLauncherNotFound = 'Activité introuvable.';
  static const String practiceEngineComingSoon =
      'Cette activité arrive bientôt : son moteur n\'est pas encore prêt.';
  static const String practiceItemCountLabel = 'Nombre de questions';
  static String practiceItemCountOption(int count) => '$count';
  static const String practiceDifficultyLabel = 'Difficulté';
  static const String practiceDifficultyAuto = 'Auto';
  static String practiceDifficultyLevel(int level) => 'Niveau $level';
  static const String practiceTimingLabel = 'Chronométrage';
  static const String practiceTimedOn = 'Chronométré';
  static const String practiceTimedOff = 'Libre';
  static const String practiceStartAction = 'Commencer';
  static const String practiceQuick5Action = 'Démarrage rapide (5 questions)';
  static const String practiceRetryMistakesSoon =
      'Reprendre mes erreurs (bientôt)';
  // US-054: family-scoped retry, replaces practiceRetryMistakesSoon above
  // once a family has a non-empty mistake pool.
  static String practiceRetryMistakesAction(int count) =>
      'Reprendre mes erreurs ($count)';
  static const String practiceRetryMistakesEmpty =
      'Aucune erreur à reprendre pour le moment.';

  static const String trainSessionPlaceholderTitle = 'Session (US-051)';
  static String trainSessionSummaryFamily(String name) => 'Famille : $name';
  static String trainSessionSummaryItemCount(int count) => 'Questions : $count';
  static const String trainSessionSummaryTimed = 'Chronométré';
  static const String trainSessionSummaryUntimed = 'Libre';

  // Pair / impair (attention_parity, US-031).
  static const String attentionParityStartLabel = 'DÉPART';
  static const String attentionParityEndLabel = 'ARRIVÉE';
  static String attentionParityNumberSemantics(int value) => 'Nombre $value';
  static String attentionParityRestartCount(int count) =>
      count == 1 ? '1 redémarrage' : '$count redémarrages';

  // Practice session screen (US-051): quit confirmation, resume card.
  static const String sessionQuitConfirmTitle = 'Quitter la session ?';
  static const String sessionQuitConfirmBody =
      'Votre progression sera enregistrée comme abandonnée.';
  static const String sessionQuitConfirmAction = 'Quitter';
  static const String sessionQuitCancelAction = 'Annuler';

  static const String sessionResumeCardTitle = 'Reprendre la session';
  static String sessionResumeCardSubtitle(String familyName) =>
      'Session en cours : $familyName';
  static const String sessionResumeCardAction = 'Reprendre la session';

  // Practice session summary & review (US-052).
  static const String summaryTitle = 'Résumé';
  static const String summaryAccuracyLabel = 'Précision';
  static String summaryScoreFraction(int correct, int played) =>
      '$correct/$played';
  static const String summaryMeanRtLabel = 'Temps moyen';
  static const String summaryMedianRtLabel = 'Temps médian';
  static const String summaryTimeoutsLabel = 'Temps écoulés';
  static String summaryBestItemLabel(int index) =>
      'Meilleure réponse : question $index';
  static String summaryWorstItemLabel(int index) =>
      'À retravailler : question $index';
  static const String summaryItemsTitle = 'Détail des questions';
  static String summaryItemLabel(int index) => 'Question $index';
  static String summaryItemCorrectSemantics(int index) =>
      'Question $index, correcte';
  static String summaryItemWrongSemantics(int index) =>
      'Question $index, incorrecte';
  static const String summaryRestartAction = 'Recommencer';
  static const String summaryRetryMistakesAction = 'Refaire les erreurs';
  static const String summaryBackAction = 'Retour';
  static const String summaryReviewMyAnswer = 'Ma réponse';
  static const String summaryReviewExpected = 'Réponse attendue';
  static const String summaryReviewRawAnswer = 'Réponse enregistrée';

  // planning_tubes (US-035): tube diagrams and the "Voir la solution" replay.
  static const String tubesStartLabel = 'Départ';
  static const String tubesTargetLabel = 'Cible';
  static const String tubesShowSolutionAction = 'Voir la solution';
  static const String tubesHideSolutionAction = 'Masquer la solution';
  static String tubesSolutionStepLabel(int step, int total) =>
      step == 0 ? 'Configuration de départ' : 'Étape $step / $total';
  static String tubesSolutionMoveLabel(String from, String to) =>
      'Bille du tube $from vers le tube $to';
  static const String tubesSolutionPreviousStep = 'Étape précédente';
  static const String tubesSolutionNextStep = 'Étape suivante';
  // 3-D viewpoint engine / "Objets 3D" (US-034, spatial_viewpoint).
  static String viewpointPositionSemantics(int azimuth) =>
      'Point de vue $azimuth';
  static const String viewpointMapSemanticsLabel =
      'Carte : 8 points de vue autour de la scène';
  static String viewpointExplanation(int azimuth, String left, String right) =>
      'Vu depuis la position $azimuth : l\'objet $left est à gauche de '
      'l\'objet $right.';
  static const String viewpointExampleCaption =
      'Cliquez le point de vue depuis lequel la scène a été photographiée.';

  /// Article-free noun, meant to follow "l'objet " (`viewpointExplanation`)
  /// so the sentence never has to agree a gender.
  static String viewpointSolidName(SolidKind kind) => switch (kind) {
    SolidKind.cube => 'cube',
    SolidKind.cylinder => 'cylindre',
    SolidKind.cone => 'cône',
    SolidKind.sphere => 'sphère',
    SolidKind.pyramid => 'pyramide',
  };

  static String viewpointColorName(int colorIndex) => switch (colorIndex % 6) {
    0 => 'orange',
    1 => 'bleu ciel',
    2 => 'vert',
    3 => 'jaune',
    4 => 'bleu',
    _ => 'vermillon',
  };
  // Exam home (US-060/061).
  static const String examHomeSubtitle =
      'Simulations chronométrées, dans l\'ordre du vrai test';
  static const String examHistoryAction = 'Historique';
  static const String examEmptyBlueprints =
      'Aucune simulation disponible pour le moment.';
  static const String examBlueprintsError =
      'Impossible de charger les simulations.';
  static const String examBlueprintsLoading = 'Chargement des simulations…';
  static String examBlueprintMeta(int minutes, int available, int total) =>
      '≈ $minutes min · $available/$total activités disponibles';
  static const String examSectionUnavailable = 'non disponible — sera ignorée';
  static const String examStartAction = 'Commencer';

  // Exam runner (US-061).
  static const String examRunnerTitle = 'Simulation';
  static const String examRunnerLoading = 'Préparation de la simulation…';
  static String examRunnerSectionProgress(int current, int total) =>
      'Section $current/$total';
  static const String examRunnerFinishing = 'Calcul des résultats…';
  static const String examRunnerAborted =
      'Simulation interrompue : elle a été enregistrée comme abandonnée.';
  static const String examRunnerUnavailable =
      'Aucune activité de cette simulation n\'est disponible pour le '
      'moment.';
  static const String examRunnerBackToHome = 'Retour';
  static const String examRunnerBreakTitle = 'Pause';
  static String examRunnerBreakCountdown(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return m > 0 ? '$m:${s.toString().padLeft(2, '0')}' : '$s s';
  }

  static const String examRunnerBreakContinue = 'Continuer';
  static const String examQuitConfirmTitle = 'Quitter la simulation ?';
  static const String examQuitConfirmBody =
      'La simulation entière sera enregistrée comme abandonnée : elle ne '
      'peut pas reprendre en cours.';
  static const String examQuitConfirmAction = 'Quitter';

  // Exam history (US-064 placeholder).
  static const String examHistoryTitle = 'Historique des simulations';
  static const String examHistoryEmpty = 'Aucune simulation pour le moment.';
  static const String examHistoryError = 'Impossible de charger l\'historique.';
  static const String examHistoryLoading = 'Chargement de l\'historique…';
  static const String examHistoryStatusCompleted = 'Terminée';
  static const String examHistoryStatusAbandoned = 'Abandonnée';
  static const String examHistoryStatusInProgress = 'En cours';
  static String examHistoryDuration(int minutes) =>
      minutes < 1 ? '< 1 min' : '$minutes min';
  static const String examHistoryDeleteAction = 'Supprimer';
  static const String examHistoryDeleteConfirmTitle =
      'Supprimer cette simulation ?';
  static const String examHistoryDeleteConfirmBody =
      'Cette action est définitive : la simulation et ses réponses seront '
      'supprimées.';

  // Exam resume (US-064): "Reprendre" card on the Exam home.
  static const String examResumeCardTitle = 'Reprendre la simulation';
  static String examResumeCardSubtitle(String blueprintName) =>
      'Simulation en cours : $blueprintName';
  static const String examResumeCardAction = 'Reprendre';

  // Exam report (US-062).
  static const String examReportTitle = 'Rapport de simulation';
  static const String examReportNotFound = 'Rapport introuvable.';
  static const String examReportError = 'Impossible de charger le rapport.';
  static const String examReportLoading = 'Chargement du rapport…';
  static const String examReportGlobalScoreLabel = 'Score global';
  static String examReportEstimatedPass(int thresholdPercent) =>
      'Estimation : admis (seuil estimé $thresholdPercent %)';
  static String examReportEstimatedFail(int thresholdPercent) =>
      'Estimation : non admis (seuil estimé $thresholdPercent %)';
  static const String examReportSectionsTitle = 'Détail par activité';
  static const String examReportReviewTitle = 'Détail des questions';
  static String examReportSectionFraction(
    int correct,
    int attempts,
    int unanswered,
  ) => '$correct/$attempts correctes · $unanswered sans réponse';

  // Multitâche psychomoteur (US-036, multitask_psychomotor).
  static const String multitaskTouchFallback =
      'Touches non représentatives : le jour J, utilisez le clavier.';
  static const String multitaskExamKeyboardRequired =
      'Cette activité nécessite un clavier physique. Aucun clavier n\'a été '
      'détecté : cette épreuve ne peut pas être passée de façon '
      'représentative sur cet appareil.';
  static const String multitaskShapeButtonLabel = 'Espace';
  static const String multitaskCalcButtonLabel = 'F';
  static const String multitaskExampleTracking =
      'Maintenez la flèche du clavier dans la direction où se déplace le '
      'cercle.';
  static const String multitaskExampleShape =
      'Appuyez sur Espace quand la forme dans le cercle est identique à la '
      'forme de référence (en haut à gauche).';
  static const String multitaskExampleCalc =
      'Appuyez sur F quand le calcul encadré, en bas, est faux.';

  // Overlay grid engine (US-033, spec §2.4-E).
  static const String overlayGridResetAction = 'Réinitialiser';
  static const String overlayGridTargetLabel = 'Grille cible';
  static const String overlayGridWorkingLabel = 'Votre grille';
  static const String overlayGridTrayLabel = 'Pièces à glisser';
  static String overlayGridTileSemantics(int index) => 'Pièce ${index + 1}';
  static const String overlayGridSolutionCaption =
      'Solution : emplacement de chaque pièce.';
  static const String overlayGridExampleCaption =
      'Glissez les pièces sur la grille centrale pour reproduire la cible.';
  // Word boxes / Boîte à mots (US-030).
  static String wordBoxesErrorCount(int errors) =>
      errors == 0 ? 'Aucune erreur' : '$errors erreur${errors > 1 ? 's' : ''}';
  static const String wordBoxesEmptyBox = '—';
  static String wordBoxesBoxSemantics(int boxNumber, String label) =>
      'Boîte $boxNumber : $label';
  static String wordBoxesResultSummary(int errors, int wordCount) => errors == 0
      ? 'Série réussie sans erreur ($wordCount mots)'
      : '$errors erreur${errors > 1 ? 's' : ''} sur $wordCount mots';
  static const String wordBoxesMissedTitle = 'Mots mal classés';
  static String wordBoxesMissedWord(String word, String fieldName) =>
      '$word → $fieldName';
  // spatial_cubes (US-025): cube-net renderer.
  static const String cubeNetReferenceLabel = 'Patron de référence';
  static const String cubeNetTargetLabel = 'Patron à compléter';
  static const String cubeNetTrayLabel = 'Faces à placer';
  static const String cubeNetTapToRotateHint =
      'Touchez une face pour la faire pivoter.';
  static String cubeNetSlotEmptySemantics(int index) => 'Case $index, vide';
  static String cubeNetSlotFilledSemantics(int index, String value) =>
      'Case $index, face $value';
  static String cubeNetTileSemantics(String value, int rotation) =>
      'Face $value, rotation $rotation degrés';
  static const String cubeNetExplanationTitle = 'Le cube reconstitué';
  static String cubeNetCorrectFaces(int correct, int total) =>
      '$correct/$total faces correctement placées';
}
