// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'PSY Trainer';

  @override
  String get tabLearn => 'Apprendre';

  @override
  String get tabTrain => 'Pratique';

  @override
  String get tabExam => 'Examen';

  @override
  String get tabProgress => 'Progrès';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get tabBarLabel => 'Navigation principale';

  @override
  String get moduleSwitchSemanticsLabel => 'Module actif';

  @override
  String get moduleSwitchPsy0 => 'PSY0';

  @override
  String get moduleSwitchPsy1 => 'PSY1';

  @override
  String get moduleSwitchPsy2 => 'PSY2';

  @override
  String get disclaimerShort =>
      'Entraîneur indépendant et non officiel — aucun lien avec Air France.';

  @override
  String get disclaimerTitle => 'Application non officielle.';

  @override
  String get disclaimerParagraph1 =>
      'Cette application est un outil d\'entraînement indépendant. Elle n\'est ni affiliée à, ni approuvée par Air France, Transavia, l\'ENAC ou leurs prestataires. Les marques citées appartiennent à leurs propriétaires et ne sont utilisées que pour décrire le processus de sélection visé.';

  @override
  String get disclaimerParagraph2 =>
      'Les exercices, questions et durées proposés sont conçus par nous à partir d\'informations publiques et de retours de candidats ; ils sont estimatifs et ne reproduisent aucun sujet réel. Le contenu de la sélection réelle évolue chaque année. Aucun résultat obtenu ici ne préjuge de votre réussite à la sélection.';

  @override
  String get actionContinue => 'Continuer';

  @override
  String get actionBack => 'Retour';

  @override
  String get actionSkip => 'Passer';

  @override
  String get actionFinish => 'Terminer';

  @override
  String get actionSave => 'Enregistrer';

  @override
  String get actionRetry => 'Réessayer';

  @override
  String get startupLoadingContent => 'Chargement du contenu…';

  @override
  String get errorTitle => 'Une erreur est survenue';

  @override
  String get errorUnknown => 'Erreur inconnue';

  @override
  String get errorBackHome => 'Retour à l\'accueil';

  @override
  String get onboardingTitle => 'Bienvenue';

  @override
  String get onboardingEditTitle => 'Mon profil';

  @override
  String get onboardingWelcomeHeadline => 'Bienvenue dans PSY Trainer';

  @override
  String get onboardingWelcomeIntro =>
      'Entraînez-vous aux activités de la présélection en ligne des cadets Air France (PSY0) : cours, exercices chronométrés et simulation d\'examen. Avant de commencer, une précision importante.';

  @override
  String get onboardingDisclaimerAccept =>
      'J\'ai compris que cette application est un entraîneur indépendant, sans lien avec Air France, et que ses exercices sont estimatifs.';

  @override
  String get onboardingDisclaimerRequired =>
      'Acceptez cette mention pour continuer.';

  @override
  String get onboardingExamDateHeadline => 'Quand passez-vous le PSY0 ?';

  @override
  String get onboardingExamDateIntro =>
      'La présélection a lieu le premier week-end de septembre. La date sert à rythmer votre préparation ; vous pourrez la modifier dans les réglages.';

  @override
  String get onboardingExamDateSuggestion => 'Prochaine session probable : ';

  @override
  String get onboardingExamDateUnknown => 'Je ne sais pas encore';

  @override
  String get onboardingExamDateInThePast =>
      'Cette date est déjà passée. Choisissez une date à venir.';

  @override
  String get dateFieldDay => 'Jour';

  @override
  String get dateFieldMonth => 'Mois';

  @override
  String get dateFieldYear => 'Année';

  @override
  String get dateFieldIncrement => 'Suivant';

  @override
  String get dateFieldDecrement => 'Précédent';

  @override
  String get onboardingStageHeadline => 'Quelle étape préparez-vous ?';

  @override
  String get onboardingStageIntro =>
      'Le contenu de l\'application suit l\'étape choisie. Seul le PSY0 est disponible pour le moment.';

  @override
  String get stagePsy0Subtitle =>
      'Tests cognitifs, culture aéronautique et anglais, à distance.';

  @override
  String get stagePsy1Subtitle =>
      'Tests psychotechniques et psychomoteurs, une journée en présentiel.';

  @override
  String get stageComingSoon => 'Bientôt';

  @override
  String get settingsEditProfile => 'Modifier mon profil';

  @override
  String get settingsProfileSummaryExamDate => 'Date d\'examen : ';

  @override
  String get settingsProfileSummaryNoExamDate => 'non renseignée';

  @override
  String get settingsProfileSummaryStage => 'Étape visée : ';

  @override
  String get learnDisclaimerExpand => 'Lire l\'avertissement complet';

  @override
  String get learnDisclaimerCollapse => 'Réduire l\'avertissement';

  @override
  String get learnHowItWorksTitle => 'Comment se passe la sélection';

  @override
  String get learnHowItWorksSubtitle =>
      'Dossier, PSY0, PSY1, PSY2, médical : les étapes, ce qui est éliminatoire et ce que l\'on sait vraiment.';

  @override
  String get learnHowItWorksSemantics =>
      'Comment se passe la sélection, ouvrir la page';

  @override
  String get learnFamiliesTitle => 'Les activités du PSY0';

  @override
  String get learnFamiliesSubtitle =>
      'Dans l\'ordre du test réel, tel que rapporté par les candidats.';

  @override
  String get learnFamiliesLoading => 'Chargement des activités…';

  @override
  String get learnFamiliesError =>
      'Impossible de charger les activités. Relancez l\'application ; si le problème persiste, réinstallez-la.';

  @override
  String get learnEmptyTitle => 'Aucune activité pour le moment';

  @override
  String get learnEmptyBody =>
      'Les fiches des activités PSY0 (mémoire, attention, spatial, logique, culture aéronautique, anglais…) apparaîtront ici dès que le contenu sera installé.';

  @override
  String get familyMasteryLabel => 'Maîtrise';

  @override
  String get familyMasteryUnknown => '—';

  @override
  String get familyActionLearn => 'Apprendre';

  @override
  String get familyActionTrain => 'S\'entraîner';

  @override
  String get familyActionCards => 'Cartes';

  @override
  String get familyLessonsTitle => 'Leçons';

  @override
  String get familyLessonsEmpty =>
      'Aucune leçon pour cette activité pour le moment.';

  @override
  String get familyNotFound => 'Activité introuvable.';

  @override
  String get familyLoading => 'Chargement…';

  @override
  String get familyFormatLabel => 'Format';

  @override
  String get familyEvaluatedLabel => 'Ce qui est évalué';

  @override
  String get confidenceConfirmed => 'confirmé';

  @override
  String get confidenceReported => 'rapporté';

  @override
  String get confidenceAssumed => 'estimé';

  @override
  String get confidenceLegend =>
      'confirmé = source officielle Air France · rapporté = retours de candidats concordants · estimé = notre meilleure hypothèse';

  @override
  String get howItWorksIntro =>
      'La sélection Cadets Air France enchaîne plusieurs étapes, toutes éliminatoires. Cette application prépare le PSY0 ; voici où il se situe.';

  @override
  String get howItWorksStagesTitle => 'Les étapes';

  @override
  String get howItWorksCalendarTitle => 'Calendrier 2026';

  @override
  String get howItWorksCalendarBody =>
      'Candidatures ~15 juin → 31 juillet · PSY0 4–5 septembre · PSY1 19–30 octobre · PSY2 à partir de janvier 2027.';

  @override
  String get howItWorksRetakeTitle => 'Règles de repassage';

  @override
  String get howItWorksRetakeBody =>
      '3 échecs au PSY0 ou 2 échecs au PSY1 = exclusion définitive de la filière Cadets (la filière « Pilote professionnel » reste ouverte). Un ajournement au PSY2 = une nouvelle tentative après 1 ou 2 ans.';

  @override
  String get howItWorksEliminatory => 'Éliminatoire';

  @override
  String get stageDossierTitle => 'Dossier de candidature';

  @override
  String get stageDossierWhen => 'Juin – juillet, en ligne';

  @override
  String get stageDossierBody =>
      'Candidature sur le portail de recrutement Air France. Vérification des prérequis (diplôme, médical classe 2, nationalité) ; frais de 200 €. Seuls les dossiers recevables sont invités au PSY0.';

  @override
  String get stageDossierFactFee => '200 € de frais';

  @override
  String get stagePsy0Title => 'PSY0 — pré-sélection';

  @override
  String get stagePsy0When =>
      'Premier week-end de septembre, à distance, logiciel sécurisé + webcam';

  @override
  String get stagePsy0Body =>
      'Batterie en ligne d\'environ 3 h dans une fenêtre de 36 h : ~14 activités courtes (mémoire, attention, spatial, logique, planification, calcul, multitâche), culture générale aéronautique et anglais renforcé. Produit un classement ; une liste d\'attente existe.';

  @override
  String get stagePsy0FactDuration => '~3 h, fenêtre de 36 h';

  @override
  String get stagePsy0FactActivities => '14 activités';

  @override
  String get stagePsy0FactWaitlist => 'Liste d\'attente';

  @override
  String get stagePsy1Title => 'PSY1 — tests psychotechniques';

  @override
  String get stagePsy1When =>
      'Une journée pendant les vacances de la Toussaint';

  @override
  String get stagePsy1Body =>
      'Tests cognitifs et psychomoteurs sur ordinateur : joysticks, double tâche, poursuite de cible, matrices, compteurs… Élimination rapportée autour de 70 %.';

  @override
  String get stagePsy1FactDay => 'Une journée, Toussaint';

  @override
  String get stagePsy1FactVenue => 'ENAC Toulouse';

  @override
  String get stagePsy1FactRate => '~70 % d\'élimination';

  @override
  String get stagePsy2Title => 'PSY2 — sélection finale';

  @override
  String get stagePsy2When =>
      'À partir de janvier, Roissy-CDG, service de sélection Air France';

  @override
  String get stagePsy2Body =>
      'Deux inventaires de personnalité, un exercice de groupe (sous confidentialité) et un entretien individuel avec psychologues et pilotes. La commission de recrutement prononce la réussite ou l\'ajournement.';

  @override
  String get stagePsy2FactContent => 'Personnalité, groupe, entretien';

  @override
  String get stagePsy2FactCoaching =>
      'Coaching payant : « aucune plus-value » selon Air France';

  @override
  String get stageMedicalTitle => 'Médical classe 1';

  @override
  String get stageMedicalWhen => 'Avant l\'entrée en formation';

  @override
  String get stageMedicalBody =>
      'Un certificat médical de classe 2 est exigé dès la candidature ; la classe 1 est obligatoire avant d\'entrer en école de pilotage.';

  @override
  String get stageMedicalFactClass2 => 'Classe 2 à la candidature';

  @override
  String get stageMedicalFactClass1 => 'Classe 1 avant la formation';

  @override
  String get stageTrainingTitle => 'Formation';

  @override
  String get stageTrainingWhen => '24 mois en école partenaire';

  @override
  String get stageTrainingBody =>
      '9 mois de théorie ATPL puis 15 à 21 mois de CPL/IR-ME/MCC, logé et rémunéré (contrat de professionnalisation). Affectation Air France ou Transavia, non choisie par le cadet.';

  @override
  String get stageTrainingFactDuration => '24 mois, rémunérée';

  @override
  String get sessionStart => 'Commencer';

  @override
  String get sessionNext => 'Suivant';

  @override
  String get sessionPause => 'Pause';

  @override
  String get sessionResume => 'Reprendre';

  @override
  String get sessionQuit => 'Quitter';

  @override
  String get sessionPausedTitle => 'Session en pause';

  @override
  String get sessionFinishedTitle => 'Activité terminée';

  @override
  String get sessionBriefingDefault =>
      'Lisez les consignes, puis appuyez sur Commencer. Le chronomètre démarre avec la première question.';

  @override
  String get sessionExamplePlaceholder => 'Exemple à venir.';

  @override
  String get sessionFeedbackCorrect => 'Bonne réponse';

  @override
  String get sessionFeedbackWrong => 'Mauvaise réponse';

  @override
  String get sessionFeedbackTimeout => 'Temps écoulé';

  @override
  String get sessionFeedbackSkipped => 'Question passée';

  @override
  String get sessionItemTimerLabel => 'Temps pour cette question';

  @override
  String get sessionSectionTimerLabel => 'Temps restant';

  @override
  String get activityValidate => 'Valider';

  @override
  String get activityExplanationTitle => 'Explication';

  @override
  String get mcqSkipOption => 'Je ne sais pas';

  @override
  String get mcqPassageDefaultTitle => 'Texte de référence';

  @override
  String get mcqPassageShow => 'Afficher le texte';

  @override
  String get mcqPassageHide => 'Masquer le texte';

  @override
  String get mcqExampleStem => 'Quelle est la capitale de la France ?';

  @override
  String get mcqExampleOptionCorrect => 'Paris';

  @override
  String get mcqExampleOptionWrong1 => 'Lyon';

  @override
  String get mcqExampleOptionWrong2 => 'Marseille';

  @override
  String get numericAnswerSemanticsLabel => 'Réponse';

  @override
  String get numericBackspaceSemanticsLabel => 'Effacer';

  @override
  String get numericExampleStem => 'Combien font 8 × 6 ?';

  @override
  String get progressTitle => 'Progrès';

  @override
  String get progressLoading => 'Calcul en cours…';

  @override
  String get progressError => 'Impossible de charger tes statistiques.';

  @override
  String get progressEmptyTitle => 'Aucun entraînement pour l\'instant';

  @override
  String get progressEmptyBody =>
      'Lance un premier exercice : ton score de préparation, tes niveaux par famille et ton activité apparaîtront ici.';

  @override
  String get progressEmptyAction => 'Commencer un exercice';

  @override
  String get readinessTitle => 'Préparation';

  @override
  String get readinessSemanticsLabel => 'Score de préparation';

  @override
  String get readinessOutOf => 'sur 100';

  @override
  String get readinessTrendUp => 'En progression';

  @override
  String get readinessTrendFlat => 'Stable';

  @override
  String get readinessTrendDown => 'En baisse';

  @override
  String get readinessHint =>
      'Familles pratiquées, leçons lues et simulations comptent.';

  @override
  String get streakCardTitle => 'Série';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: 'Aucun jour',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
      zero: '—',
    );
    return 'Record : $_temp0';
  }

  @override
  String streakGoalItems(int done, int target) {
    return '$done/$target éléments aujourd\'hui';
  }

  @override
  String streakGoalMinutes(int done, int target) {
    return '$done/$target min aujourd\'hui';
  }

  @override
  String get streakGoalMet => 'Objectif atteint !';

  @override
  String get streakSemanticsLabel => 'Série d\'entraînement';

  @override
  String streakSemanticsValue(int current, int best, String goal) {
    return '$current jours de série, record $best jours, $goal';
  }

  @override
  String get activityHeatmapSemanticsLabel =>
      'Calendrier d\'activité, 12 dernières semaines';

  @override
  String activityHeatmapSemanticsValue(int active, int total) {
    return '$active/$total jours actifs sur les 12 dernières semaines';
  }

  @override
  String get examDateSemanticsLabel => 'Examen';

  @override
  String get examDatePassed => 'Examen passé';

  @override
  String get familyLevelsTitle => 'Niveaux par famille';

  @override
  String get familyLevelsSubtitle => 'Dans l\'ordre du test réel';

  @override
  String get familyLevelsSemanticsLabel => 'Niveaux par famille';

  @override
  String get familyLevelsNone => 'Aucune famille pratiquée.';

  @override
  String get familyNotPractised => 'non pratiquée';

  @override
  String get weakAreasTitle => 'À travailler';

  @override
  String get weakAreasSubtitle => 'Tes points faibles du moment';

  @override
  String get weakAreasNone =>
      'Rien à signaler : continue à t\'entraîner régulièrement.';

  @override
  String get weakAreaTrain => 'S\'entraîner';

  @override
  String get weakReasonLowAccuracy => 'précision faible';

  @override
  String get weakReasonNegativeTrend => 'en baisse';

  @override
  String get trainNextTitle => 'À faire ensuite';

  @override
  String get trainNextSubtitle =>
      'Ce qui fera le plus progresser ta préparation';

  @override
  String get trainNextEmpty =>
      'Rien à recommander pour le moment : continue à t\'entraîner régulièrement.';

  @override
  String get trainNextActionFamily => 'S\'entraîner';

  @override
  String get trainNextActionExam => 'Simuler l\'examen';

  @override
  String get trainNextActionLesson => 'Lire la leçon';

  @override
  String get trainNextActionFlashcards => 'Réviser';

  @override
  String get recentActivityTitle => 'Activité récente';

  @override
  String get recentActivitySubtitle => 'Exercices et simulations';

  @override
  String get recentActivityNone => 'Aucune session terminée.';

  @override
  String get activityPractice => 'Exercice';

  @override
  String get activityExam => 'Simulation';

  @override
  String get activityAbandoned => 'abandonnée';

  @override
  String get activityInProgress => 'en cours';

  @override
  String get scoreUnknown => '—';

  @override
  String get lessonCalloutTip => 'Astuce';

  @override
  String get lessonCalloutTrap => 'Piège';

  @override
  String get lessonCalloutMethod => 'Méthode';

  @override
  String get lessonCalloutExample => 'Exemple';

  @override
  String get lessonImagePlaceholder => 'Image';

  @override
  String get lessonRevealNextStep => 'Étape suivante';

  @override
  String get lessonRevealAllSteps => 'Tout afficher';

  @override
  String get lessonTocTitle => 'Sommaire';

  @override
  String get lessonTocShow => 'Afficher le sommaire';

  @override
  String get lessonTocHide => 'Masquer le sommaire';

  @override
  String get lessonTryIt => 'Essayer';

  @override
  String get lessonPrevious => 'Leçon précédente';

  @override
  String get lessonNext => 'Leçon suivante';

  @override
  String get lessonMarkRead => 'Marquer comme lue';

  @override
  String get lessonMarkedRead => 'Lue';

  @override
  String get lessonNotFound => 'Leçon introuvable.';

  @override
  String get lessonLoading => 'Chargement…';

  @override
  String get flashcardsHomeTitle => 'À réviser aujourd\'hui';

  @override
  String get flashcardsHomeSemantics =>
      'Réviser les cartes du jour, ouvrir la session';

  @override
  String get flashcardsTitle => 'Cartes';

  @override
  String get flashcardsLoading => 'Chargement des cartes…';

  @override
  String get flashcardsError => 'Impossible de charger les cartes.';

  @override
  String get flashcardsStart => 'Commencer';

  @override
  String get flashcardsEmptyTitle => 'Rien à réviser';

  @override
  String get flashcardsEmptyBody =>
      'Toutes les cartes de ce paquet sont à jour. Reviens plus tard.';

  @override
  String get flashcardsFlipHint => 'Appuie ou Espace pour retourner';

  @override
  String get flashcardsAgain => 'À revoir';

  @override
  String get flashcardsHard => 'Difficile';

  @override
  String get flashcardsGood => 'Facile';

  @override
  String get flashcardsAgainSemantics => 'À revoir (touche 1)';

  @override
  String get flashcardsHardSemantics => 'Difficile (touche 2)';

  @override
  String get flashcardsGoodSemantics => 'Facile (touche 3)';

  @override
  String get flashcardsSummaryTitle => 'Session terminée';

  @override
  String get flashcardsSummaryDone => 'Terminer';

  @override
  String get flashcardsBackSemantics => 'Retour';

  @override
  String get familyDetailsTitle => 'Détails par famille';

  @override
  String get familyDetailsHint => 'Touche une famille pour voir son évolution.';

  @override
  String get familyTrendTitle => 'Évolution';

  @override
  String get trendRangeLabel => 'Période';

  @override
  String get trendRange7d => '7 j';

  @override
  String get trendRange30d => '30 j';

  @override
  String get trendRangeAll => 'Tout';

  @override
  String get trendModeLabel => 'Mode';

  @override
  String get trendModeAll => 'Tous';

  @override
  String get trendModePractice => 'Exercices';

  @override
  String get trendModeExam => 'Simulations';

  @override
  String get trendAccuracyTitle => 'Précision';

  @override
  String get trendAccuracySubtitle => 'Réussite par session';

  @override
  String get trendSpeedTitle => 'Vitesse';

  @override
  String get trendSpeedSubtitle => 'Temps de réponse médian par session';

  @override
  String get trendEmpty => 'Aucune session sur cette période.';

  @override
  String get trendLoading => 'Calcul en cours…';

  @override
  String get trendAccuracyLabel => 'Réussite';

  @override
  String get trendSpeedLabel => 'Temps';

  @override
  String get examChartTitle => 'Simulations';

  @override
  String get examChartSubtitle => 'Score global par simulation';

  @override
  String get examChartSemanticsLabel => 'Scores des simulations';

  @override
  String get examChartHint => 'Touche un point pour le détail par section.';

  @override
  String get examSectionsSemanticsLabel => 'Détail par section';

  @override
  String get examSectionNotReached => 'non atteinte';

  @override
  String get actionValidate => 'Valider';

  @override
  String get dominoTopLabel => 'Haut';

  @override
  String get dominoBottomLabel => 'Bas';

  @override
  String get dominoMissingSemantics => 'Domino manquant';

  @override
  String get dominoRuleLinearEachHalf =>
      'Une moitié avance de façon régulière (+k modulo 7).';

  @override
  String get dominoRuleAlternatingTopBottom =>
      'Les moitiés haute et basse avancent chacune leur tour (+k modulo 7).';

  @override
  String get dominoRuleMirroredHalves =>
      'La moitié basse est le miroir de la moitié haute (leur somme fait 6).';

  @override
  String get dominoRuleConstantSum =>
      'La somme des deux moitiés reste la même sur toute la série.';

  @override
  String get dominoRuleInterleavedSeries =>
      'Deux séries s\'entrelacent : une pour les positions paires, une pour les impaires.';

  @override
  String get nbackYes => 'Oui';

  @override
  String get nbackNo => 'Non';

  @override
  String get nbackPrimerLabel => 'Amorce — pas de réponse attendue';

  @override
  String get nbackHistoryStripLabel => 'Repère (derniers stimuli)';

  @override
  String get attentionRulesTouchFallback =>
      'Touches non représentatives : le jour J, utilisez le clavier.';

  @override
  String get arithmeticGridValidate => 'Valider';

  @override
  String get arithmeticGridExampleCaption =>
      'Touchez les égalités fausses (en rouge) puis Valider. Les autres sont justes, ne les touchez pas.';

  @override
  String get trainFamiliesSubtitle => 'Choisis une activité';

  @override
  String get trainFamiliesLoading => 'Chargement des activités…';

  @override
  String get trainFamiliesError => 'Impossible de charger les activités.';

  @override
  String get trainFamiliesEmpty => 'Aucune activité disponible pour le moment.';

  @override
  String get trainFamilyComingSoon => 'Bientôt';

  @override
  String get trainQuick5Label => 'Rapide (5)';

  @override
  String get practiceLauncherNotFound => 'Activité introuvable.';

  @override
  String get practiceEngineComingSoon =>
      'Cette activité arrive bientôt : son moteur n\'est pas encore prêt.';

  @override
  String get practiceItemCountLabel => 'Nombre de questions';

  @override
  String get practiceDifficultyLabel => 'Difficulté';

  @override
  String get practiceDifficultyAuto => 'Auto';

  @override
  String get practiceTimingLabel => 'Chronométrage';

  @override
  String get practiceTimedOn => 'Chronométré';

  @override
  String get practiceTimedOff => 'Libre';

  @override
  String get practiceStartAction => 'Commencer';

  @override
  String get practiceQuick5Action => 'Démarrage rapide (5 questions)';

  @override
  String get practiceRetryMistakesSoon => 'Reprendre mes erreurs (bientôt)';

  @override
  String get practiceRetryMistakesEmpty =>
      'Aucune erreur à reprendre pour le moment.';

  @override
  String get trainSessionPlaceholderTitle => 'Session (US-051)';

  @override
  String get trainSessionSummaryTimed => 'Chronométré';

  @override
  String get trainSessionSummaryUntimed => 'Libre';

  @override
  String get attentionParityStartLabel => 'DÉPART';

  @override
  String get attentionParityEndLabel => 'ARRIVÉE';

  @override
  String get sessionQuitConfirmTitle => 'Quitter la session ?';

  @override
  String get sessionQuitConfirmBody =>
      'Votre progression sera enregistrée comme abandonnée.';

  @override
  String get sessionQuitConfirmAction => 'Quitter';

  @override
  String get sessionQuitCancelAction => 'Annuler';

  @override
  String get sessionResumeCardTitle => 'Reprendre la session';

  @override
  String get sessionResumeCardAction => 'Reprendre la session';

  @override
  String get summaryTitle => 'Résumé';

  @override
  String summaryLevelChangeLabel(int from, int to) {
    return 'Niveau $from → $to';
  }

  @override
  String get summaryAccuracyLabel => 'Précision';

  @override
  String get summaryMeanRtLabel => 'Temps moyen';

  @override
  String get summaryMedianRtLabel => 'Temps médian';

  @override
  String get summaryTimeoutsLabel => 'Temps écoulés';

  @override
  String get summaryItemsTitle => 'Détail des questions';

  @override
  String get summaryRestartAction => 'Recommencer';

  @override
  String get summaryRetryMistakesAction => 'Refaire les erreurs';

  @override
  String get summaryBackAction => 'Retour';

  @override
  String get summaryReviewMyAnswer => 'Ma réponse';

  @override
  String get summaryReviewExpected => 'Réponse attendue';

  @override
  String get summaryReviewRawAnswer => 'Réponse enregistrée';

  @override
  String get tubesStartLabel => 'Départ';

  @override
  String get tubesTargetLabel => 'Cible';

  @override
  String get tubesShowSolutionAction => 'Voir la solution';

  @override
  String get tubesHideSolutionAction => 'Masquer la solution';

  @override
  String get tubesSolutionPreviousStep => 'Étape précédente';

  @override
  String get tubesSolutionNextStep => 'Étape suivante';

  @override
  String get viewpointMapSemanticsLabel =>
      'Carte : 8 points de vue autour de la scène';

  @override
  String get viewpointExampleCaption =>
      'Cliquez le point de vue depuis lequel la scène a été photographiée.';

  @override
  String get examHomeSubtitle =>
      'Simulations chronométrées, dans l\'ordre du vrai test';

  @override
  String get examHistoryAction => 'Historique';

  @override
  String get examEmptyBlueprints =>
      'Aucune simulation disponible pour le moment.';

  @override
  String get examBlueprintsError => 'Impossible de charger les simulations.';

  @override
  String get examBlueprintsLoading => 'Chargement des simulations…';

  @override
  String get examSectionUnavailable => 'non disponible — sera ignorée';

  @override
  String get examStartAction => 'Commencer';

  @override
  String get examRealismTitle => 'Conditions de l\'examen';

  @override
  String get examRealismSubtitle =>
      'Personnalisez le réalisme de la simulation avant de commencer.';

  @override
  String get examRealismPresetAction => 'Conditions réelles';

  @override
  String get examRealismNegativeMarkingLabel =>
      'Points négatifs (culture générale)';

  @override
  String get examRealismHideRemainingTimeLabel => 'Masquer le temps restant';

  @override
  String get examRealismHideTimerEnglishLabel =>
      'Masquer le chronomètre en anglais';

  @override
  String get examRealismRandomizeLabel => 'Formes/couleurs/touches aléatoires';

  @override
  String get examRealismAllowPauseLabel =>
      'Autoriser la pause entre les sections';

  @override
  String get examRealismImmersiveLabel =>
      'Plein écran immersif et orientation verrouillée';

  @override
  String get examRealismSoundCuesLabel =>
      'Signaux sonores (début/fin de section)';

  @override
  String get examRunnerTitle => 'Simulation';

  @override
  String get examRunnerLoading => 'Préparation de la simulation…';

  @override
  String get examRunnerFinishing => 'Calcul des résultats…';

  @override
  String get examRunnerAborted =>
      'Simulation interrompue : elle a été enregistrée comme abandonnée.';

  @override
  String get examRunnerUnavailable =>
      'Aucune activité de cette simulation n\'est disponible pour le moment.';

  @override
  String get examRunnerBackToHome => 'Retour';

  @override
  String get examRunnerBreakTitle => 'Pause';

  @override
  String get examQuitConfirmTitle => 'Quitter la simulation ?';

  @override
  String get examQuitConfirmBody =>
      'La simulation entière sera enregistrée comme abandonnée : elle ne peut pas reprendre en cours.';

  @override
  String get examQuitConfirmAction => 'Quitter';

  @override
  String get examHistoryTitle => 'Historique des simulations';

  @override
  String get examHistoryEmpty => 'Aucune simulation pour le moment.';

  @override
  String get examHistoryError => 'Impossible de charger l\'historique.';

  @override
  String get examHistoryLoading => 'Chargement de l\'historique…';

  @override
  String get examHistoryStatusCompleted => 'Terminée';

  @override
  String get examHistoryStatusAbandoned => 'Abandonnée';

  @override
  String get examHistoryStatusInProgress => 'En cours';

  @override
  String get examHistoryDeleteAction => 'Supprimer';

  @override
  String get examHistoryDeleteConfirmTitle => 'Supprimer cette simulation ?';

  @override
  String get examHistoryDeleteConfirmBody =>
      'Cette action est définitive : la simulation et ses réponses seront supprimées.';

  @override
  String get examResumeCardTitle => 'Reprendre la simulation';

  @override
  String get examResumeCardAction => 'Reprendre';

  @override
  String get examReportTitle => 'Rapport de simulation';

  @override
  String get examReportNotFound => 'Rapport introuvable.';

  @override
  String get examReportError => 'Impossible de charger le rapport.';

  @override
  String get examReportLoading => 'Chargement du rapport…';

  @override
  String get examReportGlobalScoreLabel => 'Score global';

  @override
  String get examReportSectionsTitle => 'Détail par activité';

  @override
  String get examReportReviewTitle => 'Détail des questions';

  @override
  String get overlayGridResetAction => 'Réinitialiser';

  @override
  String get overlayGridTargetLabel => 'Grille cible';

  @override
  String get overlayGridWorkingLabel => 'Votre grille';

  @override
  String get overlayGridTrayLabel => 'Pièces à glisser';

  @override
  String get overlayGridSolutionCaption =>
      'Solution : emplacement de chaque pièce.';

  @override
  String get overlayGridExampleCaption =>
      'Glissez les pièces sur la grille centrale pour reproduire la cible.';

  @override
  String get wordBoxesEmptyBox => '—';

  @override
  String get wordBoxesMissedTitle => 'Mots mal classés';

  @override
  String get cubeNetReferenceLabel => 'Patron de référence';

  @override
  String get cubeNetTargetLabel => 'Patron à compléter';

  @override
  String get cubeNetTrayLabel => 'Faces à placer';

  @override
  String get cubeNetTapToRotateHint =>
      'Touchez une face pour la faire pivoter.';

  @override
  String get cubeNetExplanationTitle => 'Le cube reconstitué';

  @override
  String get airwaysExampleLegendTitle => 'Un bouton de couleur par ligne';

  @override
  String get airwaysExampleBody =>
      'Des avions apparaissent sur chaque ligne et avancent vers leur zone. Touchez le bouton d\'une ligne pour dérouter son prochain avion vers une autre zone -- ou laissez-le filer si aucune zone n\'est menacée.';

  @override
  String get airwaysZoneCountSemanticsLabel =>
      'avions au total sur avions bleus';

  @override
  String get airwaysViolationFlash => 'CRASH';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'Étape $current sur $total';
  }

  @override
  String familyOpenSemantics(String name) {
    return '$name, ouvrir la fiche de l\'activité';
  }

  @override
  String lessonReadTime(int minutes) {
    return '$minutes min de lecture';
  }

  @override
  String sessionResumeHint(int next, int total) {
    return 'Reprise à la question $next sur $total';
  }

  @override
  String readinessFamilies(int practised, int total) {
    return '$practised/$total familles pratiquées';
  }

  @override
  String readinessLessons(int read, int total) {
    return '$read/$total leçons lues';
  }

  @override
  String familyLevel(int level) {
    return 'niveau $level sur 5';
  }

  @override
  String weakAreaDetail(int accuracyPercent, int attempts) {
    return '$accuracyPercent % de réussite sur $attempts réponses';
  }

  @override
  String scorePercent(int percent) {
    return '$percent %';
  }

  @override
  String familyLessonsProgress(int read, int total) {
    return '$read/$total leçons';
  }

  @override
  String familyLessonsProgressSemantics(int read, int total) {
    return '$read leçons lues sur $total';
  }

  @override
  String flashcardsDeckSummary(int due, int total) {
    return '$due à réviser · $total au total';
  }

  @override
  String flashcardsProgress(int index, int total) {
    return 'Carte $index sur $total';
  }

  @override
  String familyTrendOpenSemantics(String name) {
    return 'Voir l\'évolution de $name';
  }

  @override
  String trendTooltipAccuracy(int correct, int attempts, int percent) {
    return 'Réussite : $correct/$attempts ($percent %)';
  }

  @override
  String trendTooltipSpeed(String value) {
    return 'Temps : $value';
  }

  @override
  String examAttempt(int number) {
    return 'Simulation $number';
  }

  @override
  String examScoreLine(int percent) {
    return 'Score : $percent %';
  }

  @override
  String examSectionsTitle(String date) {
    return 'Sections du $date';
  }

  @override
  String examSectionLabel(int number, String family) {
    return '$number. $family';
  }

  @override
  String examSectionValue(int correct, int attempts, int percent) {
    return '$correct/$attempts · $percent %';
  }

  @override
  String dominoSelectorSemantics(String half, int value) {
    return '$half : $value';
  }

  @override
  String dominoAnswerSummary(int top, int bottom) {
    return 'Réponse : $top | $bottom';
  }

  @override
  String nbackYesSemantics(String shortcut) {
    return 'Oui ($shortcut)';
  }

  @override
  String nbackNoSemantics(String shortcut) {
    return 'Non ($shortcut)';
  }

  @override
  String nbackStimulusSemantics(int index) {
    return 'Stimulus $index';
  }

  @override
  String arithmeticGridCellSemantics(int index, String label) {
    return 'Égalité $index, $label';
  }

  @override
  String arithmeticGridCorrectValue(int value) {
    return 'Correct : $value';
  }

  @override
  String trainFamilyComingSoonHint(String name) {
    return '$name arrive bientôt.';
  }

  @override
  String trainFamilyOpenSemantics(String name) {
    return 'S\'entraîner : $name';
  }

  @override
  String trainQuick5Semantics(String name) {
    return 'Démarrage rapide : 5 questions sur $name';
  }

  @override
  String practiceItemCountOption(int count) {
    return '$count';
  }

  @override
  String practiceDifficultyLevel(int level) {
    return 'Niveau $level';
  }

  @override
  String practiceRetryMistakesAction(int count) {
    return 'Reprendre mes erreurs ($count)';
  }

  @override
  String trainSessionSummaryFamily(String name) {
    return 'Famille : $name';
  }

  @override
  String trainSessionSummaryItemCount(int count) {
    return 'Questions : $count';
  }

  @override
  String attentionParityNumberSemantics(int value) {
    return 'Nombre $value';
  }

  @override
  String sessionResumeCardSubtitle(String familyName) {
    return 'Session en cours : $familyName';
  }

  @override
  String summaryScoreFraction(int correct, int played) {
    return '$correct/$played';
  }

  @override
  String summaryBestItemLabel(int index) {
    return 'Meilleure réponse : question $index';
  }

  @override
  String summaryWorstItemLabel(int index) {
    return 'À retravailler : question $index';
  }

  @override
  String summaryItemLabel(int index) {
    return 'Question $index';
  }

  @override
  String summaryItemCorrectSemantics(int index) {
    return 'Question $index, correcte';
  }

  @override
  String summaryItemWrongSemantics(int index) {
    return 'Question $index, incorrecte';
  }

  @override
  String tubesSolutionMoveLabel(String from, String to) {
    return 'Bille du tube $from vers le tube $to';
  }

  @override
  String viewpointPositionSemantics(int azimuth) {
    return 'Point de vue $azimuth';
  }

  @override
  String examBlueprintMeta(int minutes, int available, int total) {
    return '≈ $minutes min · $available/$total activités disponibles';
  }

  @override
  String examRunnerSectionProgress(int current, int total) {
    return 'Section $current/$total';
  }

  @override
  String examResumeCardSubtitle(String blueprintName) {
    return 'Simulation en cours : $blueprintName';
  }

  @override
  String examReportEstimatedPass(int thresholdPercent) {
    return 'Estimation : admis (seuil estimé $thresholdPercent %)';
  }

  @override
  String examReportEstimatedFail(int thresholdPercent) {
    return 'Estimation : non admis (seuil estimé $thresholdPercent %)';
  }

  @override
  String examReportSectionFraction(int correct, int attempts, int unanswered) {
    return '$correct/$attempts correctes · $unanswered sans réponse';
  }

  @override
  String overlayGridTileSemantics(int number) {
    return 'Pièce $number';
  }

  @override
  String wordBoxesBoxSemantics(int boxNumber, String label) {
    return 'Boîte $boxNumber : $label';
  }

  @override
  String wordBoxesMissedWord(String word, String fieldName) {
    return '$word → $fieldName';
  }

  @override
  String cubeNetSlotEmptySemantics(int index) {
    return 'Case $index, vide';
  }

  @override
  String cubeNetSlotFilledSemantics(int index, String value) {
    return 'Case $index, face $value';
  }

  @override
  String cubeNetTileSemantics(String value, int rotation) {
    return 'Face $value, rotation $rotation degrés';
  }

  @override
  String cubeNetCorrectFaces(int correct, int total) {
    return '$correct/$total faces correctement placées';
  }

  @override
  String airwaysExampleCapacity(int capacity, int blueCapacity) {
    return 'Gardez au plus $capacity avions -- et au plus $blueCapacity avions bleus -- dans chaque zone grise.';
  }

  @override
  String airwaysExampleButtonLabel(int number) {
    return 'Ligne $number';
  }

  @override
  String airwaysZoneCount(int total, int blue) {
    return '$total/$blue';
  }

  @override
  String airwaysReroutesCounter(int count) {
    return 'Déroutements : $count';
  }

  @override
  String airwaysViolationsCounter(int count) {
    return 'Violations : $count';
  }

  @override
  String airwaysRouteButtonSemantics(int number) {
    return 'Dérouter la ligne $number';
  }

  @override
  String airwaysSummaryWithViolations(int violations, int reroutes) {
    return '$violations violation(s), $reroutes déroutement(s).';
  }

  @override
  String masteryPercent(int percent) {
    return '$percent %';
  }

  @override
  String get examRunnerBreakContinue => 'Continuer';

  @override
  String get shapeSquare => 'carré';

  @override
  String get shapeTriangle => 'triangle';

  @override
  String get shapeCircle => 'cercle';

  @override
  String get shapeDiamond => 'losange';

  @override
  String get shapeStar => 'étoile';

  @override
  String get colourBlue => 'bleu';

  @override
  String get colourOrange => 'orange';

  @override
  String get colourGreen => 'vert';

  @override
  String get colourPink => 'rose';

  @override
  String get colourRed => 'rouge';

  @override
  String get colourYellow => 'jaune';

  @override
  String attentionRulesExampleFilled(
    String shapeA,
    String keyA,
    String shapeB,
    String keyB,
  ) {
    return 'Forme pleine : $shapeA → $keyA, $shapeB → $keyB';
  }

  @override
  String attentionRulesExampleEmpty(
    String colourA,
    String keyA,
    String colourB,
    String keyB,
  ) {
    return 'Forme vide : $colourA → $keyA, $colourB → $keyB';
  }

  @override
  String durationSecondsOnly(int seconds) {
    return '$seconds s';
  }

  @override
  String durationMinutesOnly(int minutes) {
    return '$minutes min';
  }

  @override
  String durationMinutesSeconds(int minutes, int seconds) {
    return '$minutes min $seconds s';
  }

  @override
  String familyPerItemSuffix(String duration) {
    return '~$duration par item';
  }

  @override
  String flashcardsSummaryAgain(int count) {
    return '$count à revoir';
  }

  @override
  String sessionItemCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count questions',
      one: '1 question',
    );
    return '$_temp0';
  }

  @override
  String readinessExams(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count simulations',
      one: '1 simulation',
      zero: 'Aucune simulation',
    );
    return '$_temp0';
  }

  @override
  String examDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'J-$days',
      one: 'J-1',
      zero: 'Jour J',
    );
    return '$_temp0';
  }

  @override
  String examDaysLeftLong(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Examen dans $days jours',
      one: 'Examen dans 1 jour',
      zero: 'L\'examen est aujourd\'hui',
    );
    return '$_temp0';
  }

  @override
  String flashcardsHomeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes à réviser',
      one: '1 carte à réviser',
      zero: 'Aucune carte à réviser',
    );
    return '$_temp0';
  }

  @override
  String sessionsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sessions',
      one: '1 session',
    );
    return '$_temp0';
  }

  @override
  String attentionParityRestartCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count redémarrages',
      one: '1 redémarrage',
    );
    return '$_temp0';
  }

  @override
  String examHistoryDuration(int minutes) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes min',
      zero: '< 1 min',
    );
    return '$_temp0';
  }

  @override
  String tubesSolutionStepLabel(int step, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      step,
      locale: localeName,
      other: 'Étape $step / $total',
      zero: 'Configuration de départ',
    );
    return '$_temp0';
  }

  @override
  String wordBoxesErrorCount(int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors erreurs',
      one: '$errors erreur',
      zero: 'Aucune erreur',
    );
    return '$_temp0';
  }

  @override
  String wordBoxesResultSummary(int errors, int wordCount) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors erreurs sur $wordCount mots',
      one: '$errors erreur sur $wordCount mots',
      zero: 'Série réussie sans erreur ($wordCount mots)',
    );
    return '$_temp0';
  }

  @override
  String airwaysSummaryClean(int reroutes) {
    String _temp0 = intl.Intl.pluralLogic(
      reroutes,
      locale: localeName,
      other: 'Aucune violation, $reroutes déroutement(s).',
      zero: 'Aucune violation, aucun déroutement.',
    );
    return '$_temp0';
  }

  @override
  String examChartSummary(int n, int toPercent, int fromPercent) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'de $fromPercent % à $toPercent % sur $n simulations',
      one: '$toPercent % sur 1 simulation',
    );
    return '$_temp0';
  }

  @override
  String trendAccuracySummary(int n, int toPercent, int fromPercent) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'de $fromPercent % à $toPercent % sur $n sessions',
      one: '$toPercent % sur 1 session',
    );
    return '$_temp0';
  }

  @override
  String trendSpeedSummary(int n, String toSec, String fromSec) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'de $fromSec à $toSec sur $n sessions',
      one: '$toSec sur 1 session',
    );
    return '$_temp0';
  }

  @override
  String flashcardsSummaryGood(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count faciles',
      one: '$count facile',
    );
    return '$_temp0';
  }

  @override
  String flashcardsSummaryHard(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count difficiles',
      one: '$count difficile',
    );
    return '$_temp0';
  }

  @override
  String familyItemsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '$count item',
    );
    return '$_temp0';
  }

  @override
  String get settingsSectionAppearance => 'Apparence';

  @override
  String get settingsThemeLabel => 'Thème';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeLight => 'Clair';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsLanguageLabel => 'Langue';

  @override
  String get settingsLanguageSystem => 'Système';

  @override
  String get settingsLanguageFr => 'Français';

  @override
  String get settingsLanguageEn => 'Anglais';

  @override
  String get settingsSoundLabel => 'Son';

  @override
  String get settingsSoundOn => 'Activé';

  @override
  String get settingsSoundOff => 'Désactivé';

  @override
  String get settingsKeypadLabel => 'Disposition du clavier numérique';

  @override
  String get settingsKeypadPhone => 'Téléphone';

  @override
  String get settingsKeypadCalculator => 'Calculatrice';

  @override
  String get settingsSectionReminders => 'Rappels';

  @override
  String get settingsReminderLabel => 'Rappel quotidien';

  @override
  String get settingsReminderOn => 'Rappel activé';

  @override
  String get settingsReminderOff => 'Rappel désactivé';

  @override
  String get settingsReminderTimeLabel => 'Heure du rappel';

  @override
  String get settingsReminderHour => 'Heures';

  @override
  String get settingsReminderMinute => 'Minutes';

  @override
  String get settingsReminderUnsupported =>
      'Les rappels ne sont pas disponibles sur cet appareil ; ils fonctionnent sur téléphone (Android/iOS).';

  @override
  String get settingsReminderPermissionDenied =>
      'Notifications refusées : active-les dans les réglages du système pour recevoir le rappel.';

  @override
  String get reminderNotificationTitle => 'PSY Trainer';

  @override
  String reminderFlashcardsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cartes à réviser',
      one: '1 carte à réviser',
    );
    return '$_temp0';
  }

  @override
  String reminderWeakestFamily(String family) {
    return 'Point faible : $family';
  }

  @override
  String get reminderExamToday => 'L\'examen est aujourd\'hui';

  @override
  String reminderExamCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Examen dans $days jours',
      one: 'Examen dans 1 jour',
    );
    return '$_temp0';
  }

  @override
  String get reminderFallback => 'Un peu d\'entraînement aujourd\'hui ?';

  @override
  String get settingsSectionData => 'Données';

  @override
  String get settingsResetAction => 'Réinitialiser toutes les données';

  @override
  String get settingsResetConfirm1Title => 'Réinitialiser toutes les données ?';

  @override
  String get settingsResetConfirm1Body =>
      'Votre progression, vos statistiques et vos réglages seront effacés. Cette action ne peut pas être annulée.';

  @override
  String get settingsResetConfirm2Title => 'Vraiment tout effacer ?';

  @override
  String get settingsResetConfirm2Body =>
      'Dernière confirmation : il n\'y aura aucun moyen de récupérer ces données.';

  @override
  String get settingsResetConfirmAction => 'Effacer définitivement';

  @override
  String get settingsResetCancelAction => 'Annuler';

  @override
  String get settingsSectionGoal => 'Objectif quotidien';

  @override
  String get settingsGoalTargetLabel => 'Cible';

  @override
  String get settingsGoalUnitLabel => 'Unité';

  @override
  String get settingsGoalUnitItems => 'Éléments';

  @override
  String get settingsGoalUnitMinutes => 'Minutes';

  @override
  String get settingsSectionBackup => 'Sauvegarde';

  @override
  String get backupExportAction => 'Exporter mes données';

  @override
  String get backupExportHint =>
      'Génère un fichier JSON avec vos sessions, statistiques et réglages, à partager ou conserver.';

  @override
  String get backupExportSuccess => 'Sauvegarde partagée.';

  @override
  String get backupExportCancelled => 'Partage annulé.';

  @override
  String get backupExportError => 'Échec de l\'export.';

  @override
  String get backupImportTitle => 'Importer une sauvegarde';

  @override
  String get backupImportHint =>
      'Collez ici le contenu d\'un fichier de sauvegarde JSON.';

  @override
  String get backupImportAction => 'Importer';

  @override
  String get backupImportEmpty =>
      'Collez d\'abord le contenu d\'une sauvegarde.';

  @override
  String backupImportSuccess(int inserted, int updated, int skipped) {
    return '$inserted ajout(s), $updated mise(s) à jour, $skipped ignoré(s).';
  }

  @override
  String get backupErrorInvalidJson => 'Le texte n\'est pas un JSON valide.';

  @override
  String get backupErrorNotAnObject => 'Le document doit être un objet JSON.';

  @override
  String get backupErrorWrongFormat =>
      'Ce fichier n\'est pas une sauvegarde PSY Trainer.';

  @override
  String get backupErrorUnsupportedVersion =>
      'Cette sauvegarde vient d\'une version plus récente de l\'application.';

  @override
  String get backupErrorMissingData =>
      'La sauvegarde est incomplète (section « data » manquante).';

  @override
  String get backupErrorInvalidRow =>
      'La sauvegarde contient une entrée invalide.';

  @override
  String get backupErrorGeneric => 'Sauvegarde invalide.';

  @override
  String get settingsAboutAction => 'À propos';

  @override
  String get aboutTitle => 'À propos';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutVersionUnknown => 'Version inconnue';

  @override
  String get aboutSourcesTitle => 'Sources';

  @override
  String get aboutSourceAirFranceCorporate =>
      'Air France Corporate — Pilote de ligne';

  @override
  String get aboutSourceAirFranceRecruitment =>
      'Portail de recrutement Air France — offre Pilote Cadet';

  @override
  String get aboutSourceAirFranceNews =>
      'Air France Corporate — actualités du recrutement Cadets';

  @override
  String get aboutStorageLabel => 'Stockage';

  @override
  String get aboutStorageLocalFile => 'fichier local';

  @override
  String get aboutStorageOpfs => 'OPFS';

  @override
  String get aboutStorageIndexedDb => 'IndexedDB';

  @override
  String get aboutStorageMemory => 'mémoire (non persistant)';

  @override
  String get aboutStorageUnknown => '…';

  @override
  String get aboutStorageNotPersistentWarning =>
      'Vos données ne seront pas conservées après la fermeture de cet onglet (mode navigation privée ou navigateur non compatible).';

  @override
  String get multitaskTouchFallback =>
      'Touches non représentatives : le jour J, utilisez le clavier.';

  @override
  String get multitaskExamKeyboardRequired =>
      'Cette activité nécessite un clavier physique. Aucun clavier n\'a été détecté : cette épreuve ne peut pas être passée de façon représentative sur cet appareil.';

  @override
  String get multitaskShapeButtonLabel => 'Espace';

  @override
  String get multitaskCalcButtonLabel => 'F';

  @override
  String get multitaskExampleTracking =>
      'Maintenez la flèche du clavier dans la direction où se déplace le cercle.';

  @override
  String get multitaskExampleShape =>
      'Appuyez sur Espace quand la forme dans le cercle est identique à la forme de référence (en haut à gauche).';

  @override
  String get multitaskExampleCalc =>
      'Appuyez sur F quand le calcul encadré, en bas, est faux.';

  @override
  String reverseSpanDigitSemantics(int shown, int total) {
    return 'Chiffre $shown sur $total';
  }

  @override
  String get reverseSpanTypeInstructions => 'Retapez la séquence à l\'envers';

  @override
  String get reverseSpanExampleShown =>
      'La séquence affichée, chiffre par chiffre :';

  @override
  String get reverseSpanExampleExpected => 'Retapez-la à l\'envers :';

  @override
  String calcBackStageLabel(int stage, int stageCount) {
    return 'Étape $stage sur $stageCount';
  }

  @override
  String calcBackStemSemantics(int stage) {
    return 'Ajoutez au résultat obtenu il y a $stage calcul(s)';
  }

  @override
  String get calcBackExampleStage =>
      'Étape 2 : combinez le nombre affiché avec le résultat obtenu il y a deux calculs.';

  @override
  String get p1AnglesExampleCaption =>
      'Parmi les valeurs proposées, touchez celles qui correspondent à un angle dessiné (A, B...), puis Valider.';

  @override
  String p1AnglesCandidateSemantics(int index, int value) {
    return 'Valeur $index, $value degrés';
  }

  @override
  String get mentalArithmeticAllIntervalsPrompt =>
      'Sélectionnez tous les intervalles qui contiennent la valeur exacte.';

  @override
  String mentalArithmeticTrueValue(int value) {
    return 'Valeur exacte : $value';
  }

  @override
  String mentalArithmeticIntervalSemantics(int index, String label) {
    return 'Intervalle $index, $label';
  }

  @override
  String get mentalArithmeticAllIntervalsExampleCaption =>
      'Calculez la valeur exacte, puis touchez tous les intervalles qui la contiennent avant de Valider.';

  @override
  String get p1CountersExampleCaption =>
      'Lisez chaque cadran (aiguille, échelle ou compteur à tambour) puis répondez à la question posée.';

  @override
  String get p1CubeRotationReferenceLabel => 'Cube de référence';

  @override
  String get p1CubeRotationCandidateLabel => 'Cube candidat';

  @override
  String get p1CubeRotationQuestion => 'Est-ce le même cube, tourné ?';

  @override
  String get p1CubeRotationSameAnswer => 'Même cube, tourné';

  @override
  String get p1CubeRotationAlteredAnswer => 'Modifié';

  @override
  String get p1CubeRotationExplanationSame =>
      'Le cube candidat est bien le cube de référence, vu sous un autre angle.';

  @override
  String get p1CubeRotationExplanationAltered =>
      'Le cube candidat a été modifié (faces échangées ou face inversée) : ce n\'est pas une simple rotation.';

  @override
  String get matrixMissingSemantics => 'Case manquante';

  @override
  String get matrixQuestionMark => '?';

  @override
  String matrixCandidateSemantics(int index) {
    return 'Réponse $index';
  }

  @override
  String get matrixExampleCaption =>
      'Trouvez la figure qui complète la matrice.';

  @override
  String get matrixAxisRow => 'rangée';

  @override
  String get matrixAxisColumn => 'colonne';

  @override
  String get matrixAttributeOuterShape => 'forme';

  @override
  String get matrixAttributeInnerShape => 'forme intérieure';

  @override
  String get matrixAttributeCount => 'nombre';

  @override
  String get matrixAttributeRotation => 'rotation';

  @override
  String get matrixAttributeFill => 'remplissage';

  @override
  String get matrixAttributeSize => 'taille';

  @override
  String get matrixAttributePosition => 'position';

  @override
  String get matrixRuleDistributionSuffix => 'en distribution (3 valeurs)';

  @override
  String get matrixRuleAlternationSuffix => 'en alternance';

  @override
  String get matrixRuleXorSuffix => '= combinaison des deux premières';

  @override
  String matrixRuleStepPlain(int step) {
    return '+$step';
  }

  @override
  String matrixRuleStepDegrees(int degrees) {
    return '+$degrees°';
  }
}
