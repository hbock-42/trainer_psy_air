import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'PSY Trainer'**
  String get appName;

  /// No description provided for @tabLearn.
  ///
  /// In fr, this message translates to:
  /// **'Apprendre'**
  String get tabLearn;

  /// No description provided for @tabTrain.
  ///
  /// In fr, this message translates to:
  /// **'Pratique'**
  String get tabTrain;

  /// No description provided for @tabExam.
  ///
  /// In fr, this message translates to:
  /// **'Examen'**
  String get tabExam;

  /// No description provided for @tabProgress.
  ///
  /// In fr, this message translates to:
  /// **'Progrès'**
  String get tabProgress;

  /// No description provided for @tabSettings.
  ///
  /// In fr, this message translates to:
  /// **'Réglages'**
  String get tabSettings;

  /// No description provided for @tabBarLabel.
  ///
  /// In fr, this message translates to:
  /// **'Navigation principale'**
  String get tabBarLabel;

  /// No description provided for @moduleSwitchSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Module actif'**
  String get moduleSwitchSemanticsLabel;

  /// No description provided for @moduleSwitchPsy0.
  ///
  /// In fr, this message translates to:
  /// **'PSY0'**
  String get moduleSwitchPsy0;

  /// No description provided for @moduleSwitchPsy1.
  ///
  /// In fr, this message translates to:
  /// **'PSY1'**
  String get moduleSwitchPsy1;

  /// No description provided for @moduleSwitchPsy2.
  ///
  /// In fr, this message translates to:
  /// **'PSY2'**
  String get moduleSwitchPsy2;

  /// No description provided for @disclaimerShort.
  ///
  /// In fr, this message translates to:
  /// **'Entraîneur indépendant et non officiel — aucun lien avec Air France.'**
  String get disclaimerShort;

  /// No description provided for @disclaimerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Application non officielle.'**
  String get disclaimerTitle;

  /// No description provided for @disclaimerParagraph1.
  ///
  /// In fr, this message translates to:
  /// **'Cette application est un outil d\'entraînement indépendant. Elle n\'est ni affiliée à, ni approuvée par Air France, Transavia, l\'ENAC ou leurs prestataires. Les marques citées appartiennent à leurs propriétaires et ne sont utilisées que pour décrire le processus de sélection visé.'**
  String get disclaimerParagraph1;

  /// No description provided for @disclaimerParagraph2.
  ///
  /// In fr, this message translates to:
  /// **'Les exercices, questions et durées proposés sont conçus par nous à partir d\'informations publiques et de retours de candidats ; ils sont estimatifs et ne reproduisent aucun sujet réel. Le contenu de la sélection réelle évolue chaque année. Aucun résultat obtenu ici ne préjuge de votre réussite à la sélection.'**
  String get disclaimerParagraph2;

  /// No description provided for @actionContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get actionBack;

  /// No description provided for @actionSkip.
  ///
  /// In fr, this message translates to:
  /// **'Passer'**
  String get actionSkip;

  /// No description provided for @actionFinish.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get actionFinish;

  /// No description provided for @actionSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get actionSave;

  /// No description provided for @actionRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get actionRetry;

  /// No description provided for @startupLoadingContent.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du contenu…'**
  String get startupLoadingContent;

  /// No description provided for @errorTitle.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue'**
  String get errorTitle;

  /// No description provided for @errorUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Erreur inconnue'**
  String get errorUnknown;

  /// No description provided for @errorBackHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'accueil'**
  String get errorBackHome;

  /// No description provided for @onboardingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get onboardingTitle;

  /// No description provided for @onboardingEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get onboardingEditTitle;

  /// No description provided for @onboardingWelcomeHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue dans PSY Trainer'**
  String get onboardingWelcomeHeadline;

  /// No description provided for @onboardingWelcomeIntro.
  ///
  /// In fr, this message translates to:
  /// **'Entraînez-vous aux activités de la présélection en ligne des cadets Air France (PSY0) : cours, exercices chronométrés et simulation d\'examen. Avant de commencer, une précision importante.'**
  String get onboardingWelcomeIntro;

  /// No description provided for @onboardingDisclaimerAccept.
  ///
  /// In fr, this message translates to:
  /// **'J\'ai compris que cette application est un entraîneur indépendant, sans lien avec Air France, et que ses exercices sont estimatifs.'**
  String get onboardingDisclaimerAccept;

  /// No description provided for @onboardingDisclaimerRequired.
  ///
  /// In fr, this message translates to:
  /// **'Acceptez cette mention pour continuer.'**
  String get onboardingDisclaimerRequired;

  /// No description provided for @onboardingExamDateHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Quand passez-vous le PSY0 ?'**
  String get onboardingExamDateHeadline;

  /// No description provided for @onboardingExamDateIntro.
  ///
  /// In fr, this message translates to:
  /// **'La présélection a lieu le premier week-end de septembre. La date sert à rythmer votre préparation ; vous pourrez la modifier dans les réglages.'**
  String get onboardingExamDateIntro;

  /// No description provided for @onboardingExamDateSuggestion.
  ///
  /// In fr, this message translates to:
  /// **'Prochaine session probable : '**
  String get onboardingExamDateSuggestion;

  /// No description provided for @onboardingExamDateUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Je ne sais pas encore'**
  String get onboardingExamDateUnknown;

  /// No description provided for @onboardingExamDateInThePast.
  ///
  /// In fr, this message translates to:
  /// **'Cette date est déjà passée. Choisissez une date à venir.'**
  String get onboardingExamDateInThePast;

  /// No description provided for @dateFieldDay.
  ///
  /// In fr, this message translates to:
  /// **'Jour'**
  String get dateFieldDay;

  /// No description provided for @dateFieldMonth.
  ///
  /// In fr, this message translates to:
  /// **'Mois'**
  String get dateFieldMonth;

  /// No description provided for @dateFieldYear.
  ///
  /// In fr, this message translates to:
  /// **'Année'**
  String get dateFieldYear;

  /// No description provided for @dateFieldIncrement.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get dateFieldIncrement;

  /// No description provided for @dateFieldDecrement.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get dateFieldDecrement;

  /// No description provided for @onboardingStageHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Quelle étape préparez-vous ?'**
  String get onboardingStageHeadline;

  /// No description provided for @onboardingStageIntro.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu de l\'application suit l\'étape choisie.'**
  String get onboardingStageIntro;

  /// No description provided for @stagePsy0Subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tests cognitifs, culture aéronautique et anglais, à distance.'**
  String get stagePsy0Subtitle;

  /// No description provided for @stagePsy1Subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tests psychotechniques et psychomoteurs, une journée en présentiel.'**
  String get stagePsy1Subtitle;

  /// No description provided for @stagePsy2Subtitle.
  ///
  /// In fr, this message translates to:
  /// **'Entretien, exercice de groupe et auto-évaluations CRM, sans épreuve chronométrée.'**
  String get stagePsy2Subtitle;

  /// No description provided for @stageComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get stageComingSoon;

  /// No description provided for @settingsEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon profil'**
  String get settingsEditProfile;

  /// No description provided for @settingsProfileSummaryExamDate.
  ///
  /// In fr, this message translates to:
  /// **'Date d\'examen : '**
  String get settingsProfileSummaryExamDate;

  /// No description provided for @settingsProfileSummaryNoExamDate.
  ///
  /// In fr, this message translates to:
  /// **'non renseignée'**
  String get settingsProfileSummaryNoExamDate;

  /// No description provided for @settingsProfileSummaryStage.
  ///
  /// In fr, this message translates to:
  /// **'Étape visée : '**
  String get settingsProfileSummaryStage;

  /// No description provided for @learnDisclaimerExpand.
  ///
  /// In fr, this message translates to:
  /// **'Lire l\'avertissement complet'**
  String get learnDisclaimerExpand;

  /// No description provided for @learnDisclaimerCollapse.
  ///
  /// In fr, this message translates to:
  /// **'Réduire l\'avertissement'**
  String get learnDisclaimerCollapse;

  /// No description provided for @learnHowItWorksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment se passe la sélection'**
  String get learnHowItWorksTitle;

  /// No description provided for @learnHowItWorksSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dossier, PSY0, PSY1, PSY2, médical : les étapes, ce qui est éliminatoire et ce que l\'on sait vraiment.'**
  String get learnHowItWorksSubtitle;

  /// No description provided for @learnHowItWorksSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Comment se passe la sélection, ouvrir la page'**
  String get learnHowItWorksSemantics;

  /// No description provided for @learnFamiliesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les activités du PSY0'**
  String get learnFamiliesTitle;

  /// No description provided for @learnFamiliesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dans l\'ordre du test réel, tel que rapporté par les candidats.'**
  String get learnFamiliesSubtitle;

  /// No description provided for @learnFamiliesLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des activités…'**
  String get learnFamiliesLoading;

  /// No description provided for @learnFamiliesError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les activités. Relancez l\'application ; si le problème persiste, réinstallez-la.'**
  String get learnFamiliesError;

  /// No description provided for @learnEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité pour le moment'**
  String get learnEmptyTitle;

  /// No description provided for @learnEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Les fiches des activités PSY0 (mémoire, attention, spatial, logique, culture aéronautique, anglais…) apparaîtront ici dès que le contenu sera installé.'**
  String get learnEmptyBody;

  /// No description provided for @familyMasteryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrise'**
  String get familyMasteryLabel;

  /// No description provided for @familyMasteryUnknown.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get familyMasteryUnknown;

  /// No description provided for @familyActionLearn.
  ///
  /// In fr, this message translates to:
  /// **'Apprendre'**
  String get familyActionLearn;

  /// No description provided for @familyActionTrain.
  ///
  /// In fr, this message translates to:
  /// **'S\'entraîner'**
  String get familyActionTrain;

  /// No description provided for @familyActionCards.
  ///
  /// In fr, this message translates to:
  /// **'Cartes'**
  String get familyActionCards;

  /// No description provided for @familyLessonsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Leçons'**
  String get familyLessonsTitle;

  /// No description provided for @familyLessonsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune leçon pour cette activité pour le moment.'**
  String get familyLessonsEmpty;

  /// No description provided for @familyNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Activité introuvable.'**
  String get familyNotFound;

  /// No description provided for @familyLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get familyLoading;

  /// No description provided for @familyFormatLabel.
  ///
  /// In fr, this message translates to:
  /// **'Format'**
  String get familyFormatLabel;

  /// No description provided for @familyEvaluatedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui est évalué'**
  String get familyEvaluatedLabel;

  /// No description provided for @confidenceConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'confirmé'**
  String get confidenceConfirmed;

  /// No description provided for @confidenceReported.
  ///
  /// In fr, this message translates to:
  /// **'rapporté'**
  String get confidenceReported;

  /// No description provided for @confidenceAssumed.
  ///
  /// In fr, this message translates to:
  /// **'estimé'**
  String get confidenceAssumed;

  /// No description provided for @confidenceLegend.
  ///
  /// In fr, this message translates to:
  /// **'confirmé = source officielle Air France · rapporté = retours de candidats concordants · estimé = notre meilleure hypothèse'**
  String get confidenceLegend;

  /// No description provided for @howItWorksIntro.
  ///
  /// In fr, this message translates to:
  /// **'La sélection Cadets Air France enchaîne plusieurs étapes, toutes éliminatoires. Cette application prépare le PSY0 ; voici où il se situe.'**
  String get howItWorksIntro;

  /// No description provided for @howItWorksStagesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Les étapes'**
  String get howItWorksStagesTitle;

  /// No description provided for @howItWorksCalendarTitle.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier 2026'**
  String get howItWorksCalendarTitle;

  /// No description provided for @howItWorksCalendarBody.
  ///
  /// In fr, this message translates to:
  /// **'Candidatures ~15 juin → 31 juillet · PSY0 4–5 septembre · PSY1 19–30 octobre · PSY2 à partir de janvier 2027.'**
  String get howItWorksCalendarBody;

  /// No description provided for @howItWorksRetakeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Règles de repassage'**
  String get howItWorksRetakeTitle;

  /// No description provided for @howItWorksRetakeBody.
  ///
  /// In fr, this message translates to:
  /// **'3 échecs au PSY0 ou 2 échecs au PSY1 = exclusion définitive de la filière Cadets (la filière « Pilote professionnel » reste ouverte). Un ajournement au PSY2 = une nouvelle tentative après 1 ou 2 ans.'**
  String get howItWorksRetakeBody;

  /// No description provided for @howItWorksEliminatory.
  ///
  /// In fr, this message translates to:
  /// **'Éliminatoire'**
  String get howItWorksEliminatory;

  /// No description provided for @stageDossierTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dossier de candidature'**
  String get stageDossierTitle;

  /// No description provided for @stageDossierWhen.
  ///
  /// In fr, this message translates to:
  /// **'Juin – juillet, en ligne'**
  String get stageDossierWhen;

  /// No description provided for @stageDossierBody.
  ///
  /// In fr, this message translates to:
  /// **'Candidature sur le portail de recrutement Air France. Vérification des prérequis (diplôme, médical classe 2, nationalité) ; frais de 200 €. Seuls les dossiers recevables sont invités au PSY0.'**
  String get stageDossierBody;

  /// No description provided for @stageDossierFactFee.
  ///
  /// In fr, this message translates to:
  /// **'200 € de frais'**
  String get stageDossierFactFee;

  /// No description provided for @stagePsy0Title.
  ///
  /// In fr, this message translates to:
  /// **'PSY0 — pré-sélection'**
  String get stagePsy0Title;

  /// No description provided for @stagePsy0When.
  ///
  /// In fr, this message translates to:
  /// **'Premier week-end de septembre, à distance, logiciel sécurisé + webcam'**
  String get stagePsy0When;

  /// No description provided for @stagePsy0Body.
  ///
  /// In fr, this message translates to:
  /// **'Batterie en ligne d\'environ 3 h dans une fenêtre de 36 h : ~14 activités courtes (mémoire, attention, spatial, logique, planification, calcul, multitâche), culture générale aéronautique et anglais renforcé. Produit un classement ; une liste d\'attente existe.'**
  String get stagePsy0Body;

  /// No description provided for @stagePsy0FactDuration.
  ///
  /// In fr, this message translates to:
  /// **'~3 h, fenêtre de 36 h'**
  String get stagePsy0FactDuration;

  /// No description provided for @stagePsy0FactActivities.
  ///
  /// In fr, this message translates to:
  /// **'14 activités'**
  String get stagePsy0FactActivities;

  /// No description provided for @stagePsy0FactWaitlist.
  ///
  /// In fr, this message translates to:
  /// **'Liste d\'attente'**
  String get stagePsy0FactWaitlist;

  /// No description provided for @stagePsy1Title.
  ///
  /// In fr, this message translates to:
  /// **'PSY1 — tests psychotechniques'**
  String get stagePsy1Title;

  /// No description provided for @stagePsy1When.
  ///
  /// In fr, this message translates to:
  /// **'Une journée pendant les vacances de la Toussaint'**
  String get stagePsy1When;

  /// No description provided for @stagePsy1Body.
  ///
  /// In fr, this message translates to:
  /// **'Tests cognitifs et psychomoteurs sur ordinateur : joysticks, double tâche, poursuite de cible, matrices, compteurs… Élimination rapportée autour de 70 %.'**
  String get stagePsy1Body;

  /// No description provided for @stagePsy1FactDay.
  ///
  /// In fr, this message translates to:
  /// **'Une journée, Toussaint'**
  String get stagePsy1FactDay;

  /// No description provided for @stagePsy1FactVenue.
  ///
  /// In fr, this message translates to:
  /// **'ENAC Toulouse'**
  String get stagePsy1FactVenue;

  /// No description provided for @stagePsy1FactRate.
  ///
  /// In fr, this message translates to:
  /// **'~70 % d\'élimination'**
  String get stagePsy1FactRate;

  /// No description provided for @stagePsy2Title.
  ///
  /// In fr, this message translates to:
  /// **'PSY2 — sélection finale'**
  String get stagePsy2Title;

  /// No description provided for @stagePsy2When.
  ///
  /// In fr, this message translates to:
  /// **'À partir de janvier, Roissy-CDG, service de sélection Air France'**
  String get stagePsy2When;

  /// No description provided for @stagePsy2Body.
  ///
  /// In fr, this message translates to:
  /// **'Deux inventaires de personnalité, un exercice de groupe (sous confidentialité) et un entretien individuel avec psychologues et pilotes. La commission de recrutement prononce la réussite ou l\'ajournement.'**
  String get stagePsy2Body;

  /// No description provided for @stagePsy2FactContent.
  ///
  /// In fr, this message translates to:
  /// **'Personnalité, groupe, entretien'**
  String get stagePsy2FactContent;

  /// No description provided for @stagePsy2FactCoaching.
  ///
  /// In fr, this message translates to:
  /// **'Coaching payant : « aucune plus-value » selon Air France'**
  String get stagePsy2FactCoaching;

  /// No description provided for @stageMedicalTitle.
  ///
  /// In fr, this message translates to:
  /// **'Médical classe 1'**
  String get stageMedicalTitle;

  /// No description provided for @stageMedicalWhen.
  ///
  /// In fr, this message translates to:
  /// **'Avant l\'entrée en formation'**
  String get stageMedicalWhen;

  /// No description provided for @stageMedicalBody.
  ///
  /// In fr, this message translates to:
  /// **'Un certificat médical de classe 2 est exigé dès la candidature ; la classe 1 est obligatoire avant d\'entrer en école de pilotage.'**
  String get stageMedicalBody;

  /// No description provided for @stageMedicalFactClass2.
  ///
  /// In fr, this message translates to:
  /// **'Classe 2 à la candidature'**
  String get stageMedicalFactClass2;

  /// No description provided for @stageMedicalFactClass1.
  ///
  /// In fr, this message translates to:
  /// **'Classe 1 avant la formation'**
  String get stageMedicalFactClass1;

  /// No description provided for @stageTrainingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Formation'**
  String get stageTrainingTitle;

  /// No description provided for @stageTrainingWhen.
  ///
  /// In fr, this message translates to:
  /// **'24 mois en école partenaire'**
  String get stageTrainingWhen;

  /// No description provided for @stageTrainingBody.
  ///
  /// In fr, this message translates to:
  /// **'9 mois de théorie ATPL puis 15 à 21 mois de CPL/IR-ME/MCC, logé et rémunéré (contrat de professionnalisation). Affectation Air France ou Transavia, non choisie par le cadet.'**
  String get stageTrainingBody;

  /// No description provided for @stageTrainingFactDuration.
  ///
  /// In fr, this message translates to:
  /// **'24 mois, rémunérée'**
  String get stageTrainingFactDuration;

  /// No description provided for @sessionStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get sessionStart;

  /// No description provided for @sessionNext.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get sessionNext;

  /// No description provided for @sessionPause.
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get sessionPause;

  /// No description provided for @sessionResume.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get sessionResume;

  /// No description provided for @sessionQuit.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get sessionQuit;

  /// No description provided for @sessionPausedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session en pause'**
  String get sessionPausedTitle;

  /// No description provided for @sessionFinishedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activité terminée'**
  String get sessionFinishedTitle;

  /// No description provided for @sessionBriefingDefault.
  ///
  /// In fr, this message translates to:
  /// **'Lisez les consignes, puis appuyez sur Commencer. Le chronomètre démarre avec la première question.'**
  String get sessionBriefingDefault;

  /// No description provided for @sessionExamplePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Exemple à venir.'**
  String get sessionExamplePlaceholder;

  /// No description provided for @sessionFeedbackCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Bonne réponse'**
  String get sessionFeedbackCorrect;

  /// No description provided for @sessionFeedbackWrong.
  ///
  /// In fr, this message translates to:
  /// **'Mauvaise réponse'**
  String get sessionFeedbackWrong;

  /// No description provided for @sessionFeedbackTimeout.
  ///
  /// In fr, this message translates to:
  /// **'Temps écoulé'**
  String get sessionFeedbackTimeout;

  /// No description provided for @sessionFeedbackSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Question passée'**
  String get sessionFeedbackSkipped;

  /// No description provided for @sessionItemTimerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps pour cette question'**
  String get sessionItemTimerLabel;

  /// No description provided for @sessionSectionTimerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps restant'**
  String get sessionSectionTimerLabel;

  /// No description provided for @activityValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get activityValidate;

  /// No description provided for @activityExplanationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Explication'**
  String get activityExplanationTitle;

  /// No description provided for @mcqSkipOption.
  ///
  /// In fr, this message translates to:
  /// **'Je ne sais pas'**
  String get mcqSkipOption;

  /// No description provided for @mcqPassageDefaultTitle.
  ///
  /// In fr, this message translates to:
  /// **'Texte de référence'**
  String get mcqPassageDefaultTitle;

  /// No description provided for @mcqPassageShow.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le texte'**
  String get mcqPassageShow;

  /// No description provided for @mcqPassageHide.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le texte'**
  String get mcqPassageHide;

  /// No description provided for @mcqExampleStem.
  ///
  /// In fr, this message translates to:
  /// **'Quelle est la capitale de la France ?'**
  String get mcqExampleStem;

  /// No description provided for @mcqExampleOptionCorrect.
  ///
  /// In fr, this message translates to:
  /// **'Paris'**
  String get mcqExampleOptionCorrect;

  /// No description provided for @mcqExampleOptionWrong1.
  ///
  /// In fr, this message translates to:
  /// **'Lyon'**
  String get mcqExampleOptionWrong1;

  /// No description provided for @mcqExampleOptionWrong2.
  ///
  /// In fr, this message translates to:
  /// **'Marseille'**
  String get mcqExampleOptionWrong2;

  /// No description provided for @numericAnswerSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Réponse'**
  String get numericAnswerSemanticsLabel;

  /// No description provided for @numericBackspaceSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Effacer'**
  String get numericBackspaceSemanticsLabel;

  /// No description provided for @numericExampleStem.
  ///
  /// In fr, this message translates to:
  /// **'Combien font 8 × 6 ?'**
  String get numericExampleStem;

  /// No description provided for @progressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Progrès'**
  String get progressTitle;

  /// No description provided for @progressLoading.
  ///
  /// In fr, this message translates to:
  /// **'Calcul en cours…'**
  String get progressLoading;

  /// No description provided for @progressError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger tes statistiques.'**
  String get progressError;

  /// No description provided for @progressEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun entraînement pour l\'instant'**
  String get progressEmptyTitle;

  /// No description provided for @progressEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Lance un premier exercice : ton score de préparation, tes niveaux par famille et ton activité apparaîtront ici.'**
  String get progressEmptyBody;

  /// No description provided for @progressEmptyAction.
  ///
  /// In fr, this message translates to:
  /// **'Commencer un exercice'**
  String get progressEmptyAction;

  /// No description provided for @readinessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Préparation'**
  String get readinessTitle;

  /// No description provided for @readinessSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Score de préparation'**
  String get readinessSemanticsLabel;

  /// No description provided for @readinessOutOf.
  ///
  /// In fr, this message translates to:
  /// **'sur 100'**
  String get readinessOutOf;

  /// No description provided for @readinessTrendUp.
  ///
  /// In fr, this message translates to:
  /// **'En progression'**
  String get readinessTrendUp;

  /// No description provided for @readinessTrendFlat.
  ///
  /// In fr, this message translates to:
  /// **'Stable'**
  String get readinessTrendFlat;

  /// No description provided for @readinessTrendDown.
  ///
  /// In fr, this message translates to:
  /// **'En baisse'**
  String get readinessTrendDown;

  /// No description provided for @readinessHint.
  ///
  /// In fr, this message translates to:
  /// **'Familles pratiquées, leçons lues et simulations comptent.'**
  String get readinessHint;

  /// No description provided for @streakCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Série'**
  String get streakCardTitle;

  /// No description provided for @streakDays.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun jour} =1{1 jour} other{{count} jours}}'**
  String streakDays(int count);

  /// No description provided for @streakBest.
  ///
  /// In fr, this message translates to:
  /// **'Record : {count, plural, =0{—} =1{1 jour} other{{count} jours}}'**
  String streakBest(int count);

  /// No description provided for @streakGoalItems.
  ///
  /// In fr, this message translates to:
  /// **'{done}/{target} éléments aujourd\'hui'**
  String streakGoalItems(int done, int target);

  /// No description provided for @streakGoalMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{done}/{target} min aujourd\'hui'**
  String streakGoalMinutes(int done, int target);

  /// No description provided for @streakGoalMet.
  ///
  /// In fr, this message translates to:
  /// **'Objectif atteint !'**
  String get streakGoalMet;

  /// No description provided for @streakSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Série d\'entraînement'**
  String get streakSemanticsLabel;

  /// No description provided for @streakSemanticsValue.
  ///
  /// In fr, this message translates to:
  /// **'{current} jours de série, record {best} jours, {goal}'**
  String streakSemanticsValue(int current, int best, String goal);

  /// No description provided for @activityHeatmapSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Calendrier d\'activité, 12 dernières semaines'**
  String get activityHeatmapSemanticsLabel;

  /// No description provided for @activityHeatmapSemanticsValue.
  ///
  /// In fr, this message translates to:
  /// **'{active}/{total} jours actifs sur les 12 dernières semaines'**
  String activityHeatmapSemanticsValue(int active, int total);

  /// No description provided for @examDateSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Examen'**
  String get examDateSemanticsLabel;

  /// No description provided for @examDatePassed.
  ///
  /// In fr, this message translates to:
  /// **'Examen passé'**
  String get examDatePassed;

  /// No description provided for @familyLevelsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Niveaux par famille'**
  String get familyLevelsTitle;

  /// No description provided for @familyLevelsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Dans l\'ordre du test réel'**
  String get familyLevelsSubtitle;

  /// No description provided for @familyLevelsSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Niveaux par famille'**
  String get familyLevelsSemanticsLabel;

  /// No description provided for @familyLevelsNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune famille pratiquée.'**
  String get familyLevelsNone;

  /// No description provided for @familyNotPractised.
  ///
  /// In fr, this message translates to:
  /// **'non pratiquée'**
  String get familyNotPractised;

  /// No description provided for @weakAreasTitle.
  ///
  /// In fr, this message translates to:
  /// **'À travailler'**
  String get weakAreasTitle;

  /// No description provided for @weakAreasSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Tes points faibles du moment'**
  String get weakAreasSubtitle;

  /// No description provided for @weakAreasNone.
  ///
  /// In fr, this message translates to:
  /// **'Rien à signaler : continue à t\'entraîner régulièrement.'**
  String get weakAreasNone;

  /// No description provided for @weakAreaTrain.
  ///
  /// In fr, this message translates to:
  /// **'S\'entraîner'**
  String get weakAreaTrain;

  /// No description provided for @weakReasonLowAccuracy.
  ///
  /// In fr, this message translates to:
  /// **'précision faible'**
  String get weakReasonLowAccuracy;

  /// No description provided for @weakReasonNegativeTrend.
  ///
  /// In fr, this message translates to:
  /// **'en baisse'**
  String get weakReasonNegativeTrend;

  /// No description provided for @trainNextTitle.
  ///
  /// In fr, this message translates to:
  /// **'À faire ensuite'**
  String get trainNextTitle;

  /// No description provided for @trainNextSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui fera le plus progresser ta préparation'**
  String get trainNextSubtitle;

  /// No description provided for @trainNextEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Rien à recommander pour le moment : continue à t\'entraîner régulièrement.'**
  String get trainNextEmpty;

  /// No description provided for @trainNextActionFamily.
  ///
  /// In fr, this message translates to:
  /// **'S\'entraîner'**
  String get trainNextActionFamily;

  /// No description provided for @trainNextActionExam.
  ///
  /// In fr, this message translates to:
  /// **'Simuler l\'examen'**
  String get trainNextActionExam;

  /// No description provided for @trainNextActionLesson.
  ///
  /// In fr, this message translates to:
  /// **'Lire la leçon'**
  String get trainNextActionLesson;

  /// No description provided for @trainNextActionFlashcards.
  ///
  /// In fr, this message translates to:
  /// **'Réviser'**
  String get trainNextActionFlashcards;

  /// No description provided for @recentActivityTitle.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get recentActivityTitle;

  /// No description provided for @recentActivitySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Exercices et simulations'**
  String get recentActivitySubtitle;

  /// No description provided for @recentActivityNone.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session terminée.'**
  String get recentActivityNone;

  /// No description provided for @activityPractice.
  ///
  /// In fr, this message translates to:
  /// **'Exercice'**
  String get activityPractice;

  /// No description provided for @activityExam.
  ///
  /// In fr, this message translates to:
  /// **'Simulation'**
  String get activityExam;

  /// No description provided for @activityAbandoned.
  ///
  /// In fr, this message translates to:
  /// **'abandonnée'**
  String get activityAbandoned;

  /// No description provided for @activityInProgress.
  ///
  /// In fr, this message translates to:
  /// **'en cours'**
  String get activityInProgress;

  /// No description provided for @scoreUnknown.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get scoreUnknown;

  /// No description provided for @lessonCalloutTip.
  ///
  /// In fr, this message translates to:
  /// **'Astuce'**
  String get lessonCalloutTip;

  /// No description provided for @lessonCalloutTrap.
  ///
  /// In fr, this message translates to:
  /// **'Piège'**
  String get lessonCalloutTrap;

  /// No description provided for @lessonCalloutMethod.
  ///
  /// In fr, this message translates to:
  /// **'Méthode'**
  String get lessonCalloutMethod;

  /// No description provided for @lessonCalloutExample.
  ///
  /// In fr, this message translates to:
  /// **'Exemple'**
  String get lessonCalloutExample;

  /// No description provided for @lessonImagePlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Image'**
  String get lessonImagePlaceholder;

  /// No description provided for @lessonRevealNextStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape suivante'**
  String get lessonRevealNextStep;

  /// No description provided for @lessonRevealAllSteps.
  ///
  /// In fr, this message translates to:
  /// **'Tout afficher'**
  String get lessonRevealAllSteps;

  /// No description provided for @lessonTocTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sommaire'**
  String get lessonTocTitle;

  /// No description provided for @lessonTocShow.
  ///
  /// In fr, this message translates to:
  /// **'Afficher le sommaire'**
  String get lessonTocShow;

  /// No description provided for @lessonTocHide.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le sommaire'**
  String get lessonTocHide;

  /// No description provided for @lessonTryIt.
  ///
  /// In fr, this message translates to:
  /// **'Essayer'**
  String get lessonTryIt;

  /// No description provided for @lessonPrevious.
  ///
  /// In fr, this message translates to:
  /// **'Leçon précédente'**
  String get lessonPrevious;

  /// No description provided for @lessonNext.
  ///
  /// In fr, this message translates to:
  /// **'Leçon suivante'**
  String get lessonNext;

  /// No description provided for @lessonMarkRead.
  ///
  /// In fr, this message translates to:
  /// **'Marquer comme lue'**
  String get lessonMarkRead;

  /// No description provided for @lessonMarkedRead.
  ///
  /// In fr, this message translates to:
  /// **'Lue'**
  String get lessonMarkedRead;

  /// No description provided for @lessonNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Leçon introuvable.'**
  String get lessonNotFound;

  /// No description provided for @lessonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement…'**
  String get lessonLoading;

  /// No description provided for @flashcardsHomeTitle.
  ///
  /// In fr, this message translates to:
  /// **'À réviser aujourd\'hui'**
  String get flashcardsHomeTitle;

  /// No description provided for @flashcardsHomeSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Réviser les cartes du jour, ouvrir la session'**
  String get flashcardsHomeSemantics;

  /// No description provided for @flashcardsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Cartes'**
  String get flashcardsTitle;

  /// No description provided for @flashcardsLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des cartes…'**
  String get flashcardsLoading;

  /// No description provided for @flashcardsError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les cartes.'**
  String get flashcardsError;

  /// No description provided for @flashcardsStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get flashcardsStart;

  /// No description provided for @flashcardsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rien à réviser'**
  String get flashcardsEmptyTitle;

  /// No description provided for @flashcardsEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les cartes de ce paquet sont à jour. Reviens plus tard.'**
  String get flashcardsEmptyBody;

  /// No description provided for @flashcardsFlipHint.
  ///
  /// In fr, this message translates to:
  /// **'Appuie ou Espace pour retourner'**
  String get flashcardsFlipHint;

  /// No description provided for @flashcardsAgain.
  ///
  /// In fr, this message translates to:
  /// **'À revoir'**
  String get flashcardsAgain;

  /// No description provided for @flashcardsHard.
  ///
  /// In fr, this message translates to:
  /// **'Difficile'**
  String get flashcardsHard;

  /// No description provided for @flashcardsGood.
  ///
  /// In fr, this message translates to:
  /// **'Facile'**
  String get flashcardsGood;

  /// No description provided for @flashcardsAgainSemantics.
  ///
  /// In fr, this message translates to:
  /// **'À revoir (touche 1)'**
  String get flashcardsAgainSemantics;

  /// No description provided for @flashcardsHardSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Difficile (touche 2)'**
  String get flashcardsHardSemantics;

  /// No description provided for @flashcardsGoodSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Facile (touche 3)'**
  String get flashcardsGoodSemantics;

  /// No description provided for @flashcardsSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session terminée'**
  String get flashcardsSummaryTitle;

  /// No description provided for @flashcardsSummaryDone.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get flashcardsSummaryDone;

  /// No description provided for @flashcardsBackSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get flashcardsBackSemantics;

  /// No description provided for @familyDetailsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détails par famille'**
  String get familyDetailsTitle;

  /// No description provided for @familyDetailsHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche une famille pour voir son évolution.'**
  String get familyDetailsHint;

  /// No description provided for @familyTrendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Évolution'**
  String get familyTrendTitle;

  /// No description provided for @trendRangeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Période'**
  String get trendRangeLabel;

  /// No description provided for @trendRange7d.
  ///
  /// In fr, this message translates to:
  /// **'7 j'**
  String get trendRange7d;

  /// No description provided for @trendRange30d.
  ///
  /// In fr, this message translates to:
  /// **'30 j'**
  String get trendRange30d;

  /// No description provided for @trendRangeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get trendRangeAll;

  /// No description provided for @trendModeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mode'**
  String get trendModeLabel;

  /// No description provided for @trendModeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get trendModeAll;

  /// No description provided for @trendModePractice.
  ///
  /// In fr, this message translates to:
  /// **'Exercices'**
  String get trendModePractice;

  /// No description provided for @trendModeExam.
  ///
  /// In fr, this message translates to:
  /// **'Simulations'**
  String get trendModeExam;

  /// No description provided for @trendAccuracyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Précision'**
  String get trendAccuracyTitle;

  /// No description provided for @trendAccuracySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Réussite par session'**
  String get trendAccuracySubtitle;

  /// No description provided for @trendSpeedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse'**
  String get trendSpeedTitle;

  /// No description provided for @trendSpeedSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Temps de réponse médian par session'**
  String get trendSpeedSubtitle;

  /// No description provided for @trendEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune session sur cette période.'**
  String get trendEmpty;

  /// No description provided for @trendLoading.
  ///
  /// In fr, this message translates to:
  /// **'Calcul en cours…'**
  String get trendLoading;

  /// No description provided for @trendAccuracyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Réussite'**
  String get trendAccuracyLabel;

  /// No description provided for @trendSpeedLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps'**
  String get trendSpeedLabel;

  /// No description provided for @examChartTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulations'**
  String get examChartTitle;

  /// No description provided for @examChartSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Score global par simulation'**
  String get examChartSubtitle;

  /// No description provided for @examChartSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Scores des simulations'**
  String get examChartSemanticsLabel;

  /// No description provided for @examChartHint.
  ///
  /// In fr, this message translates to:
  /// **'Touche un point pour le détail par section.'**
  String get examChartHint;

  /// No description provided for @examSectionsSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Détail par section'**
  String get examSectionsSemanticsLabel;

  /// No description provided for @examSectionNotReached.
  ///
  /// In fr, this message translates to:
  /// **'non atteinte'**
  String get examSectionNotReached;

  /// No description provided for @actionValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get actionValidate;

  /// No description provided for @dominoTopLabel.
  ///
  /// In fr, this message translates to:
  /// **'Haut'**
  String get dominoTopLabel;

  /// No description provided for @dominoBottomLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bas'**
  String get dominoBottomLabel;

  /// No description provided for @dominoMissingSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Domino manquant'**
  String get dominoMissingSemantics;

  /// No description provided for @dominoRuleLinearEachHalf.
  ///
  /// In fr, this message translates to:
  /// **'Une moitié avance de façon régulière (+k modulo 7).'**
  String get dominoRuleLinearEachHalf;

  /// No description provided for @dominoRuleAlternatingTopBottom.
  ///
  /// In fr, this message translates to:
  /// **'Les moitiés haute et basse avancent chacune leur tour (+k modulo 7).'**
  String get dominoRuleAlternatingTopBottom;

  /// No description provided for @dominoRuleMirroredHalves.
  ///
  /// In fr, this message translates to:
  /// **'La moitié basse est le miroir de la moitié haute (leur somme fait 6).'**
  String get dominoRuleMirroredHalves;

  /// No description provided for @dominoRuleConstantSum.
  ///
  /// In fr, this message translates to:
  /// **'La somme des deux moitiés reste la même sur toute la série.'**
  String get dominoRuleConstantSum;

  /// No description provided for @dominoRuleInterleavedSeries.
  ///
  /// In fr, this message translates to:
  /// **'Deux séries s\'entrelacent : une pour les positions paires, une pour les impaires.'**
  String get dominoRuleInterleavedSeries;

  /// No description provided for @nbackYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get nbackYes;

  /// No description provided for @nbackNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get nbackNo;

  /// No description provided for @nbackPrimerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Amorce — pas de réponse attendue'**
  String get nbackPrimerLabel;

  /// No description provided for @nbackHistoryStripLabel.
  ///
  /// In fr, this message translates to:
  /// **'Repère (derniers stimuli)'**
  String get nbackHistoryStripLabel;

  /// No description provided for @attentionRulesTouchFallback.
  ///
  /// In fr, this message translates to:
  /// **'Touches non représentatives : le jour J, utilisez le clavier.'**
  String get attentionRulesTouchFallback;

  /// No description provided for @arithmeticGridValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get arithmeticGridValidate;

  /// No description provided for @arithmeticGridExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Touchez les égalités fausses (en rouge) puis Valider. Les autres sont justes, ne les touchez pas.'**
  String get arithmeticGridExampleCaption;

  /// No description provided for @trainFamiliesSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisis une activité'**
  String get trainFamiliesSubtitle;

  /// No description provided for @trainFamiliesLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des activités…'**
  String get trainFamiliesLoading;

  /// No description provided for @trainFamiliesError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les activités.'**
  String get trainFamiliesError;

  /// No description provided for @trainFamiliesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité disponible pour le moment.'**
  String get trainFamiliesEmpty;

  /// No description provided for @trainFamilyComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt'**
  String get trainFamilyComingSoon;

  /// No description provided for @trainQuick5Label.
  ///
  /// In fr, this message translates to:
  /// **'Rapide (5)'**
  String get trainQuick5Label;

  /// No description provided for @practiceLauncherNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Activité introuvable.'**
  String get practiceLauncherNotFound;

  /// No description provided for @practiceEngineComingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Cette activité arrive bientôt : son moteur n\'est pas encore prêt.'**
  String get practiceEngineComingSoon;

  /// No description provided for @practiceItemCountLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de questions'**
  String get practiceItemCountLabel;

  /// No description provided for @practiceDifficultyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Difficulté'**
  String get practiceDifficultyLabel;

  /// No description provided for @practiceDifficultyAuto.
  ///
  /// In fr, this message translates to:
  /// **'Auto'**
  String get practiceDifficultyAuto;

  /// No description provided for @practiceTimingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Chronométrage'**
  String get practiceTimingLabel;

  /// No description provided for @practiceTimedOn.
  ///
  /// In fr, this message translates to:
  /// **'Chronométré'**
  String get practiceTimedOn;

  /// No description provided for @practiceTimedOff.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get practiceTimedOff;

  /// No description provided for @practiceStartAction.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get practiceStartAction;

  /// No description provided for @practiceQuick5Action.
  ///
  /// In fr, this message translates to:
  /// **'Démarrage rapide (5 questions)'**
  String get practiceQuick5Action;

  /// No description provided for @practiceRetryMistakesSoon.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre mes erreurs (bientôt)'**
  String get practiceRetryMistakesSoon;

  /// No description provided for @practiceRetryMistakesEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune erreur à reprendre pour le moment.'**
  String get practiceRetryMistakesEmpty;

  /// No description provided for @trainSessionPlaceholderTitle.
  ///
  /// In fr, this message translates to:
  /// **'Session (US-051)'**
  String get trainSessionPlaceholderTitle;

  /// No description provided for @trainSessionSummaryTimed.
  ///
  /// In fr, this message translates to:
  /// **'Chronométré'**
  String get trainSessionSummaryTimed;

  /// No description provided for @trainSessionSummaryUntimed.
  ///
  /// In fr, this message translates to:
  /// **'Libre'**
  String get trainSessionSummaryUntimed;

  /// No description provided for @attentionParityStartLabel.
  ///
  /// In fr, this message translates to:
  /// **'DÉPART'**
  String get attentionParityStartLabel;

  /// No description provided for @attentionParityEndLabel.
  ///
  /// In fr, this message translates to:
  /// **'ARRIVÉE'**
  String get attentionParityEndLabel;

  /// No description provided for @sessionQuitConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la session ?'**
  String get sessionQuitConfirmTitle;

  /// No description provided for @sessionQuitConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression sera enregistrée comme abandonnée.'**
  String get sessionQuitConfirmBody;

  /// No description provided for @sessionQuitConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get sessionQuitConfirmAction;

  /// No description provided for @sessionQuitCancelAction.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get sessionQuitCancelAction;

  /// No description provided for @sessionResumeCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la session'**
  String get sessionResumeCardTitle;

  /// No description provided for @sessionResumeCardAction.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la session'**
  String get sessionResumeCardAction;

  /// No description provided for @summaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé'**
  String get summaryTitle;

  /// No description provided for @summaryLevelChangeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {from} → {to}'**
  String summaryLevelChangeLabel(int from, int to);

  /// No description provided for @summaryAccuracyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Précision'**
  String get summaryAccuracyLabel;

  /// No description provided for @summaryMeanRtLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps moyen'**
  String get summaryMeanRtLabel;

  /// No description provided for @summaryMedianRtLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps médian'**
  String get summaryMedianRtLabel;

  /// No description provided for @summaryTimeoutsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Temps écoulés'**
  String get summaryTimeoutsLabel;

  /// No description provided for @summaryItemsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail des questions'**
  String get summaryItemsTitle;

  /// No description provided for @summaryRestartAction.
  ///
  /// In fr, this message translates to:
  /// **'Recommencer'**
  String get summaryRestartAction;

  /// No description provided for @summaryRetryMistakesAction.
  ///
  /// In fr, this message translates to:
  /// **'Refaire les erreurs'**
  String get summaryRetryMistakesAction;

  /// No description provided for @summaryBackAction.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get summaryBackAction;

  /// No description provided for @summaryReviewMyAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Ma réponse'**
  String get summaryReviewMyAnswer;

  /// No description provided for @summaryReviewExpected.
  ///
  /// In fr, this message translates to:
  /// **'Réponse attendue'**
  String get summaryReviewExpected;

  /// No description provided for @summaryReviewRawAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Réponse enregistrée'**
  String get summaryReviewRawAnswer;

  /// No description provided for @tubesStartLabel.
  ///
  /// In fr, this message translates to:
  /// **'Départ'**
  String get tubesStartLabel;

  /// No description provided for @tubesTargetLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cible'**
  String get tubesTargetLabel;

  /// No description provided for @tubesShowSolutionAction.
  ///
  /// In fr, this message translates to:
  /// **'Voir la solution'**
  String get tubesShowSolutionAction;

  /// No description provided for @tubesHideSolutionAction.
  ///
  /// In fr, this message translates to:
  /// **'Masquer la solution'**
  String get tubesHideSolutionAction;

  /// No description provided for @tubesSolutionPreviousStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape précédente'**
  String get tubesSolutionPreviousStep;

  /// No description provided for @tubesSolutionNextStep.
  ///
  /// In fr, this message translates to:
  /// **'Étape suivante'**
  String get tubesSolutionNextStep;

  /// No description provided for @viewpointMapSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Carte : 8 points de vue autour de la scène'**
  String get viewpointMapSemanticsLabel;

  /// No description provided for @viewpointExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Cliquez le point de vue depuis lequel la scène a été photographiée.'**
  String get viewpointExampleCaption;

  /// No description provided for @examHomeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulations chronométrées, dans l\'ordre du vrai test'**
  String get examHomeSubtitle;

  /// No description provided for @examHistoryAction.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get examHistoryAction;

  /// No description provided for @examEmptyBlueprints.
  ///
  /// In fr, this message translates to:
  /// **'Aucune simulation disponible pour le moment.'**
  String get examEmptyBlueprints;

  /// No description provided for @examBlueprintsError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les simulations.'**
  String get examBlueprintsError;

  /// No description provided for @examBlueprintsLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des simulations…'**
  String get examBlueprintsLoading;

  /// No description provided for @examSectionUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'non disponible — sera ignorée'**
  String get examSectionUnavailable;

  /// No description provided for @examStartAction.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get examStartAction;

  /// No description provided for @examRealismTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conditions de l\'examen'**
  String get examRealismTitle;

  /// No description provided for @examRealismSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Personnalisez le réalisme de la simulation avant de commencer.'**
  String get examRealismSubtitle;

  /// No description provided for @examRealismPresetAction.
  ///
  /// In fr, this message translates to:
  /// **'Conditions réelles'**
  String get examRealismPresetAction;

  /// No description provided for @examRealismNegativeMarkingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Points négatifs (culture générale)'**
  String get examRealismNegativeMarkingLabel;

  /// No description provided for @examRealismHideRemainingTimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le temps restant'**
  String get examRealismHideRemainingTimeLabel;

  /// No description provided for @examRealismHideTimerEnglishLabel.
  ///
  /// In fr, this message translates to:
  /// **'Masquer le chronomètre en anglais'**
  String get examRealismHideTimerEnglishLabel;

  /// No description provided for @examRealismRandomizeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Formes/couleurs/touches aléatoires'**
  String get examRealismRandomizeLabel;

  /// No description provided for @examRealismAllowPauseLabel.
  ///
  /// In fr, this message translates to:
  /// **'Autoriser la pause entre les sections'**
  String get examRealismAllowPauseLabel;

  /// No description provided for @examRealismImmersiveLabel.
  ///
  /// In fr, this message translates to:
  /// **'Plein écran immersif et orientation verrouillée'**
  String get examRealismImmersiveLabel;

  /// No description provided for @examRealismSoundCuesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Signaux sonores (début/fin de section)'**
  String get examRealismSoundCuesLabel;

  /// No description provided for @examRunnerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulation'**
  String get examRunnerTitle;

  /// No description provided for @examRunnerLoading.
  ///
  /// In fr, this message translates to:
  /// **'Préparation de la simulation…'**
  String get examRunnerLoading;

  /// No description provided for @examRunnerFinishing.
  ///
  /// In fr, this message translates to:
  /// **'Calcul des résultats…'**
  String get examRunnerFinishing;

  /// No description provided for @examRunnerAborted.
  ///
  /// In fr, this message translates to:
  /// **'Simulation interrompue : elle a été enregistrée comme abandonnée.'**
  String get examRunnerAborted;

  /// No description provided for @examRunnerUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité de cette simulation n\'est disponible pour le moment.'**
  String get examRunnerUnavailable;

  /// No description provided for @examRunnerBackToHome.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get examRunnerBackToHome;

  /// No description provided for @examRunnerBreakTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pause'**
  String get examRunnerBreakTitle;

  /// No description provided for @examQuitConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Quitter la simulation ?'**
  String get examQuitConfirmTitle;

  /// No description provided for @examQuitConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'La simulation entière sera enregistrée comme abandonnée : elle ne peut pas reprendre en cours.'**
  String get examQuitConfirmBody;

  /// No description provided for @examQuitConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Quitter'**
  String get examQuitConfirmAction;

  /// No description provided for @examHistoryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Historique des simulations'**
  String get examHistoryTitle;

  /// No description provided for @examHistoryEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune simulation pour le moment.'**
  String get examHistoryEmpty;

  /// No description provided for @examHistoryError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger l\'historique.'**
  String get examHistoryError;

  /// No description provided for @examHistoryLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement de l\'historique…'**
  String get examHistoryLoading;

  /// No description provided for @examHistoryStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get examHistoryStatusCompleted;

  /// No description provided for @examHistoryStatusAbandoned.
  ///
  /// In fr, this message translates to:
  /// **'Abandonnée'**
  String get examHistoryStatusAbandoned;

  /// No description provided for @examHistoryStatusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get examHistoryStatusInProgress;

  /// No description provided for @examHistoryDeleteAction.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get examHistoryDeleteAction;

  /// No description provided for @examHistoryDeleteConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer cette simulation ?'**
  String get examHistoryDeleteConfirmTitle;

  /// No description provided for @examHistoryDeleteConfirmBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est définitive : la simulation et ses réponses seront supprimées.'**
  String get examHistoryDeleteConfirmBody;

  /// No description provided for @examResumeCardTitle.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre la simulation'**
  String get examResumeCardTitle;

  /// No description provided for @examResumeCardAction.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre'**
  String get examResumeCardAction;

  /// No description provided for @examReportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rapport de simulation'**
  String get examReportTitle;

  /// No description provided for @examReportNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Rapport introuvable.'**
  String get examReportNotFound;

  /// No description provided for @examReportError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger le rapport.'**
  String get examReportError;

  /// No description provided for @examReportLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du rapport…'**
  String get examReportLoading;

  /// No description provided for @examReportGlobalScoreLabel.
  ///
  /// In fr, this message translates to:
  /// **'Score global'**
  String get examReportGlobalScoreLabel;

  /// No description provided for @examReportSectionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail par activité'**
  String get examReportSectionsTitle;

  /// No description provided for @examReportReviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Détail des questions'**
  String get examReportReviewTitle;

  /// No description provided for @overlayGridResetAction.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get overlayGridResetAction;

  /// No description provided for @overlayGridTargetLabel.
  ///
  /// In fr, this message translates to:
  /// **'Grille cible'**
  String get overlayGridTargetLabel;

  /// No description provided for @overlayGridWorkingLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre grille'**
  String get overlayGridWorkingLabel;

  /// No description provided for @overlayGridTrayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pièces à glisser'**
  String get overlayGridTrayLabel;

  /// No description provided for @overlayGridSolutionCaption.
  ///
  /// In fr, this message translates to:
  /// **'Solution : emplacement de chaque pièce.'**
  String get overlayGridSolutionCaption;

  /// No description provided for @overlayGridExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Glissez les pièces sur la grille centrale pour reproduire la cible.'**
  String get overlayGridExampleCaption;

  /// No description provided for @wordBoxesEmptyBox.
  ///
  /// In fr, this message translates to:
  /// **'—'**
  String get wordBoxesEmptyBox;

  /// No description provided for @wordBoxesMissedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mots mal classés'**
  String get wordBoxesMissedTitle;

  /// No description provided for @cubeNetReferenceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Patron de référence'**
  String get cubeNetReferenceLabel;

  /// No description provided for @cubeNetTargetLabel.
  ///
  /// In fr, this message translates to:
  /// **'Patron à compléter'**
  String get cubeNetTargetLabel;

  /// No description provided for @cubeNetTrayLabel.
  ///
  /// In fr, this message translates to:
  /// **'Faces à placer'**
  String get cubeNetTrayLabel;

  /// No description provided for @cubeNetTapToRotateHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une face pour la faire pivoter.'**
  String get cubeNetTapToRotateHint;

  /// No description provided for @cubeNetExplanationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le cube reconstitué'**
  String get cubeNetExplanationTitle;

  /// No description provided for @airwaysExampleLegendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Un bouton de couleur par ligne'**
  String get airwaysExampleLegendTitle;

  /// No description provided for @airwaysExampleBody.
  ///
  /// In fr, this message translates to:
  /// **'Des avions apparaissent sur chaque ligne et avancent vers leur zone. Touchez le bouton d\'une ligne pour dérouter son prochain avion vers une autre zone -- ou laissez-le filer si aucune zone n\'est menacée.'**
  String get airwaysExampleBody;

  /// No description provided for @airwaysZoneCountSemanticsLabel.
  ///
  /// In fr, this message translates to:
  /// **'avions au total sur avions bleus'**
  String get airwaysZoneCountSemanticsLabel;

  /// No description provided for @airwaysViolationFlash.
  ///
  /// In fr, this message translates to:
  /// **'CRASH'**
  String get airwaysViolationFlash;

  /// No description provided for @onboardingStepLabel.
  ///
  /// In fr, this message translates to:
  /// **'Étape {current} sur {total}'**
  String onboardingStepLabel(int current, int total);

  /// No description provided for @familyOpenSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{name}, ouvrir la fiche de l\'activité'**
  String familyOpenSemantics(String name);

  /// No description provided for @lessonReadTime.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min de lecture'**
  String lessonReadTime(int minutes);

  /// No description provided for @sessionResumeHint.
  ///
  /// In fr, this message translates to:
  /// **'Reprise à la question {next} sur {total}'**
  String sessionResumeHint(int next, int total);

  /// No description provided for @readinessFamilies.
  ///
  /// In fr, this message translates to:
  /// **'{practised}/{total} familles pratiquées'**
  String readinessFamilies(int practised, int total);

  /// No description provided for @readinessLessons.
  ///
  /// In fr, this message translates to:
  /// **'{read}/{total} leçons lues'**
  String readinessLessons(int read, int total);

  /// No description provided for @familyLevel.
  ///
  /// In fr, this message translates to:
  /// **'niveau {level} sur 5'**
  String familyLevel(int level);

  /// No description provided for @weakAreaDetail.
  ///
  /// In fr, this message translates to:
  /// **'{accuracyPercent} % de réussite sur {attempts} réponses'**
  String weakAreaDetail(int accuracyPercent, int attempts);

  /// No description provided for @scorePercent.
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String scorePercent(int percent);

  /// No description provided for @familyLessonsProgress.
  ///
  /// In fr, this message translates to:
  /// **'{read}/{total} leçons'**
  String familyLessonsProgress(int read, int total);

  /// No description provided for @familyLessonsProgressSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{read} leçons lues sur {total}'**
  String familyLessonsProgressSemantics(int read, int total);

  /// No description provided for @flashcardsDeckSummary.
  ///
  /// In fr, this message translates to:
  /// **'{due} à réviser · {total} au total'**
  String flashcardsDeckSummary(int due, int total);

  /// No description provided for @flashcardsProgress.
  ///
  /// In fr, this message translates to:
  /// **'Carte {index} sur {total}'**
  String flashcardsProgress(int index, int total);

  /// No description provided for @familyTrendOpenSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'évolution de {name}'**
  String familyTrendOpenSemantics(String name);

  /// No description provided for @trendTooltipAccuracy.
  ///
  /// In fr, this message translates to:
  /// **'Réussite : {correct}/{attempts} ({percent} %)'**
  String trendTooltipAccuracy(int correct, int attempts, int percent);

  /// No description provided for @trendTooltipSpeed.
  ///
  /// In fr, this message translates to:
  /// **'Temps : {value}'**
  String trendTooltipSpeed(String value);

  /// No description provided for @examAttempt.
  ///
  /// In fr, this message translates to:
  /// **'Simulation {number}'**
  String examAttempt(int number);

  /// No description provided for @examScoreLine.
  ///
  /// In fr, this message translates to:
  /// **'Score : {percent} %'**
  String examScoreLine(int percent);

  /// No description provided for @examSectionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sections du {date}'**
  String examSectionsTitle(String date);

  /// No description provided for @examSectionLabel.
  ///
  /// In fr, this message translates to:
  /// **'{number}. {family}'**
  String examSectionLabel(int number, String family);

  /// No description provided for @examSectionValue.
  ///
  /// In fr, this message translates to:
  /// **'{correct}/{attempts} · {percent} %'**
  String examSectionValue(int correct, int attempts, int percent);

  /// No description provided for @dominoSelectorSemantics.
  ///
  /// In fr, this message translates to:
  /// **'{half} : {value}'**
  String dominoSelectorSemantics(String half, int value);

  /// No description provided for @dominoAnswerSummary.
  ///
  /// In fr, this message translates to:
  /// **'Réponse : {top} | {bottom}'**
  String dominoAnswerSummary(int top, int bottom);

  /// No description provided for @nbackYesSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Oui ({shortcut})'**
  String nbackYesSemantics(String shortcut);

  /// No description provided for @nbackNoSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Non ({shortcut})'**
  String nbackNoSemantics(String shortcut);

  /// No description provided for @nbackStimulusSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Stimulus {index}'**
  String nbackStimulusSemantics(int index);

  /// No description provided for @arithmeticGridCellSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Égalité {index}, {label}'**
  String arithmeticGridCellSemantics(int index, String label);

  /// No description provided for @arithmeticGridCorrectValue.
  ///
  /// In fr, this message translates to:
  /// **'Correct : {value}'**
  String arithmeticGridCorrectValue(int value);

  /// No description provided for @trainFamilyComingSoonHint.
  ///
  /// In fr, this message translates to:
  /// **'{name} arrive bientôt.'**
  String trainFamilyComingSoonHint(String name);

  /// No description provided for @trainFamilyOpenSemantics.
  ///
  /// In fr, this message translates to:
  /// **'S\'entraîner : {name}'**
  String trainFamilyOpenSemantics(String name);

  /// No description provided for @trainQuick5Semantics.
  ///
  /// In fr, this message translates to:
  /// **'Démarrage rapide : 5 questions sur {name}'**
  String trainQuick5Semantics(String name);

  /// No description provided for @practiceItemCountOption.
  ///
  /// In fr, this message translates to:
  /// **'{count}'**
  String practiceItemCountOption(int count);

  /// No description provided for @practiceDifficultyLevel.
  ///
  /// In fr, this message translates to:
  /// **'Niveau {level}'**
  String practiceDifficultyLevel(int level);

  /// No description provided for @practiceRetryMistakesAction.
  ///
  /// In fr, this message translates to:
  /// **'Reprendre mes erreurs ({count})'**
  String practiceRetryMistakesAction(int count);

  /// No description provided for @trainSessionSummaryFamily.
  ///
  /// In fr, this message translates to:
  /// **'Famille : {name}'**
  String trainSessionSummaryFamily(String name);

  /// No description provided for @trainSessionSummaryItemCount.
  ///
  /// In fr, this message translates to:
  /// **'Questions : {count}'**
  String trainSessionSummaryItemCount(int count);

  /// No description provided for @attentionParityNumberSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Nombre {value}'**
  String attentionParityNumberSemantics(int value);

  /// No description provided for @sessionResumeCardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Session en cours : {familyName}'**
  String sessionResumeCardSubtitle(String familyName);

  /// No description provided for @summaryScoreFraction.
  ///
  /// In fr, this message translates to:
  /// **'{correct}/{played}'**
  String summaryScoreFraction(int correct, int played);

  /// No description provided for @summaryBestItemLabel.
  ///
  /// In fr, this message translates to:
  /// **'Meilleure réponse : question {index}'**
  String summaryBestItemLabel(int index);

  /// No description provided for @summaryWorstItemLabel.
  ///
  /// In fr, this message translates to:
  /// **'À retravailler : question {index}'**
  String summaryWorstItemLabel(int index);

  /// No description provided for @summaryItemLabel.
  ///
  /// In fr, this message translates to:
  /// **'Question {index}'**
  String summaryItemLabel(int index);

  /// No description provided for @summaryItemCorrectSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Question {index}, correcte'**
  String summaryItemCorrectSemantics(int index);

  /// No description provided for @summaryItemWrongSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Question {index}, incorrecte'**
  String summaryItemWrongSemantics(int index);

  /// No description provided for @tubesSolutionMoveLabel.
  ///
  /// In fr, this message translates to:
  /// **'Bille du tube {from} vers le tube {to}'**
  String tubesSolutionMoveLabel(String from, String to);

  /// No description provided for @viewpointPositionSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Point de vue {azimuth}'**
  String viewpointPositionSemantics(int azimuth);

  /// No description provided for @examBlueprintMeta.
  ///
  /// In fr, this message translates to:
  /// **'≈ {minutes} min · {available}/{total} activités disponibles'**
  String examBlueprintMeta(int minutes, int available, int total);

  /// No description provided for @examRunnerSectionProgress.
  ///
  /// In fr, this message translates to:
  /// **'Section {current}/{total}'**
  String examRunnerSectionProgress(int current, int total);

  /// No description provided for @examResumeCardSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Simulation en cours : {blueprintName}'**
  String examResumeCardSubtitle(String blueprintName);

  /// No description provided for @examReportEstimatedPass.
  ///
  /// In fr, this message translates to:
  /// **'Estimation : admis (seuil estimé {thresholdPercent} %)'**
  String examReportEstimatedPass(int thresholdPercent);

  /// No description provided for @examReportEstimatedFail.
  ///
  /// In fr, this message translates to:
  /// **'Estimation : non admis (seuil estimé {thresholdPercent} %)'**
  String examReportEstimatedFail(int thresholdPercent);

  /// No description provided for @examReportSectionFraction.
  ///
  /// In fr, this message translates to:
  /// **'{correct}/{attempts} correctes · {unanswered} sans réponse'**
  String examReportSectionFraction(int correct, int attempts, int unanswered);

  /// No description provided for @overlayGridTileSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Pièce {number}'**
  String overlayGridTileSemantics(int number);

  /// No description provided for @wordBoxesBoxSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Boîte {boxNumber} : {label}'**
  String wordBoxesBoxSemantics(int boxNumber, String label);

  /// No description provided for @wordBoxesMissedWord.
  ///
  /// In fr, this message translates to:
  /// **'{word} → {fieldName}'**
  String wordBoxesMissedWord(String word, String fieldName);

  /// No description provided for @cubeNetSlotEmptySemantics.
  ///
  /// In fr, this message translates to:
  /// **'Case {index}, vide'**
  String cubeNetSlotEmptySemantics(int index);

  /// No description provided for @cubeNetSlotFilledSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Case {index}, face {value}'**
  String cubeNetSlotFilledSemantics(int index, String value);

  /// No description provided for @cubeNetTileSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Face {value}, rotation {rotation} degrés'**
  String cubeNetTileSemantics(String value, int rotation);

  /// No description provided for @cubeNetCorrectFaces.
  ///
  /// In fr, this message translates to:
  /// **'{correct}/{total} faces correctement placées'**
  String cubeNetCorrectFaces(int correct, int total);

  /// No description provided for @airwaysExampleCapacity.
  ///
  /// In fr, this message translates to:
  /// **'Gardez au plus {capacity} avions -- et au plus {blueCapacity} avions bleus -- dans chaque zone grise.'**
  String airwaysExampleCapacity(int capacity, int blueCapacity);

  /// No description provided for @airwaysExampleButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ligne {number}'**
  String airwaysExampleButtonLabel(int number);

  /// No description provided for @airwaysZoneCount.
  ///
  /// In fr, this message translates to:
  /// **'{total}/{blue}'**
  String airwaysZoneCount(int total, int blue);

  /// No description provided for @airwaysReroutesCounter.
  ///
  /// In fr, this message translates to:
  /// **'Déroutements : {count}'**
  String airwaysReroutesCounter(int count);

  /// No description provided for @airwaysViolationsCounter.
  ///
  /// In fr, this message translates to:
  /// **'Violations : {count}'**
  String airwaysViolationsCounter(int count);

  /// No description provided for @airwaysRouteButtonSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Dérouter la ligne {number}'**
  String airwaysRouteButtonSemantics(int number);

  /// No description provided for @airwaysSummaryWithViolations.
  ///
  /// In fr, this message translates to:
  /// **'{violations} violation(s), {reroutes} déroutement(s).'**
  String airwaysSummaryWithViolations(int violations, int reroutes);

  /// No description provided for @masteryPercent.
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String masteryPercent(int percent);

  /// No description provided for @examRunnerBreakContinue.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get examRunnerBreakContinue;

  /// No description provided for @shapeSquare.
  ///
  /// In fr, this message translates to:
  /// **'carré'**
  String get shapeSquare;

  /// No description provided for @shapeTriangle.
  ///
  /// In fr, this message translates to:
  /// **'triangle'**
  String get shapeTriangle;

  /// No description provided for @shapeCircle.
  ///
  /// In fr, this message translates to:
  /// **'cercle'**
  String get shapeCircle;

  /// No description provided for @shapeDiamond.
  ///
  /// In fr, this message translates to:
  /// **'losange'**
  String get shapeDiamond;

  /// No description provided for @shapeStar.
  ///
  /// In fr, this message translates to:
  /// **'étoile'**
  String get shapeStar;

  /// No description provided for @colourBlue.
  ///
  /// In fr, this message translates to:
  /// **'bleu'**
  String get colourBlue;

  /// No description provided for @colourOrange.
  ///
  /// In fr, this message translates to:
  /// **'orange'**
  String get colourOrange;

  /// No description provided for @colourGreen.
  ///
  /// In fr, this message translates to:
  /// **'vert'**
  String get colourGreen;

  /// No description provided for @colourPink.
  ///
  /// In fr, this message translates to:
  /// **'rose'**
  String get colourPink;

  /// No description provided for @colourRed.
  ///
  /// In fr, this message translates to:
  /// **'rouge'**
  String get colourRed;

  /// No description provided for @colourYellow.
  ///
  /// In fr, this message translates to:
  /// **'jaune'**
  String get colourYellow;

  /// No description provided for @attentionRulesExampleFilled.
  ///
  /// In fr, this message translates to:
  /// **'Forme pleine : {shapeA} → {keyA}, {shapeB} → {keyB}'**
  String attentionRulesExampleFilled(
    String shapeA,
    String keyA,
    String shapeB,
    String keyB,
  );

  /// No description provided for @attentionRulesExampleEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Forme vide : {colourA} → {keyA}, {colourB} → {keyB}'**
  String attentionRulesExampleEmpty(
    String colourA,
    String keyA,
    String colourB,
    String keyB,
  );

  /// No description provided for @durationSecondsOnly.
  ///
  /// In fr, this message translates to:
  /// **'{seconds} s'**
  String durationSecondsOnly(int seconds);

  /// No description provided for @durationMinutesOnly.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min'**
  String durationMinutesOnly(int minutes);

  /// No description provided for @durationMinutesSeconds.
  ///
  /// In fr, this message translates to:
  /// **'{minutes} min {seconds} s'**
  String durationMinutesSeconds(int minutes, int seconds);

  /// No description provided for @familyPerItemSuffix.
  ///
  /// In fr, this message translates to:
  /// **'~{duration} par item'**
  String familyPerItemSuffix(String duration);

  /// No description provided for @flashcardsSummaryAgain.
  ///
  /// In fr, this message translates to:
  /// **'{count} à revoir'**
  String flashcardsSummaryAgain(int count);

  /// No description provided for @sessionItemCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{1 question} other{{count} questions}}'**
  String sessionItemCount(int count);

  /// No description provided for @readinessExams.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune simulation} =1{1 simulation} other{{count} simulations}}'**
  String readinessExams(int count);

  /// No description provided for @examDaysLeft.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{Jour J} =1{J-1} other{J-{days}}}'**
  String examDaysLeft(int days);

  /// No description provided for @examDaysLeftLong.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{L\'examen est aujourd\'hui} =1{Examen dans 1 jour} other{Examen dans {days} jours}}'**
  String examDaysLeftLong(int days);

  /// No description provided for @flashcardsHomeCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune carte à réviser} =1{1 carte à réviser} other{{count} cartes à réviser}}'**
  String flashcardsHomeCount(int count);

  /// No description provided for @sessionsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{1 session} other{{count} sessions}}'**
  String sessionsCount(int count);

  /// No description provided for @attentionParityRestartCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{1 redémarrage} other{{count} redémarrages}}'**
  String attentionParityRestartCount(int count);

  /// No description provided for @examHistoryDuration.
  ///
  /// In fr, this message translates to:
  /// **'{minutes, plural, =0{< 1 min} other{{minutes} min}}'**
  String examHistoryDuration(int minutes);

  /// No description provided for @tubesSolutionStepLabel.
  ///
  /// In fr, this message translates to:
  /// **'{step, plural, =0{Configuration de départ} other{Étape {step} / {total}}}'**
  String tubesSolutionStepLabel(int step, int total);

  /// No description provided for @wordBoxesErrorCount.
  ///
  /// In fr, this message translates to:
  /// **'{errors, plural, =0{Aucune erreur} one{{errors} erreur} other{{errors} erreurs}}'**
  String wordBoxesErrorCount(int errors);

  /// No description provided for @wordBoxesResultSummary.
  ///
  /// In fr, this message translates to:
  /// **'{errors, plural, =0{Série réussie sans erreur ({wordCount} mots)} one{{errors} erreur sur {wordCount} mots} other{{errors} erreurs sur {wordCount} mots}}'**
  String wordBoxesResultSummary(int errors, int wordCount);

  /// No description provided for @airwaysSummaryClean.
  ///
  /// In fr, this message translates to:
  /// **'{reroutes, plural, =0{Aucune violation, aucun déroutement.} other{Aucune violation, {reroutes} déroutement(s).}}'**
  String airwaysSummaryClean(int reroutes);

  /// No description provided for @examChartSummary.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{{toPercent} % sur 1 simulation} other{de {fromPercent} % à {toPercent} % sur {n} simulations}}'**
  String examChartSummary(int n, int toPercent, int fromPercent);

  /// No description provided for @trendAccuracySummary.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{{toPercent} % sur 1 session} other{de {fromPercent} % à {toPercent} % sur {n} sessions}}'**
  String trendAccuracySummary(int n, int toPercent, int fromPercent);

  /// No description provided for @trendSpeedSummary.
  ///
  /// In fr, this message translates to:
  /// **'{n, plural, =1{{toSec} sur 1 session} other{de {fromSec} à {toSec} sur {n} sessions}}'**
  String trendSpeedSummary(int n, String toSec, String fromSec);

  /// No description provided for @flashcardsSummaryGood.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} facile} other{{count} faciles}}'**
  String flashcardsSummaryGood(int count);

  /// No description provided for @flashcardsSummaryHard.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} difficile} other{{count} difficiles}}'**
  String flashcardsSummaryHard(int count);

  /// No description provided for @familyItemsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, one{{count} item} other{{count} items}}'**
  String familyItemsCount(int count);

  /// No description provided for @settingsSectionAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsSectionAppearance;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageFr.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFr;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In fr, this message translates to:
  /// **'Anglais'**
  String get settingsLanguageEn;

  /// No description provided for @settingsSoundLabel.
  ///
  /// In fr, this message translates to:
  /// **'Son'**
  String get settingsSoundLabel;

  /// No description provided for @settingsSoundOn.
  ///
  /// In fr, this message translates to:
  /// **'Activé'**
  String get settingsSoundOn;

  /// No description provided for @settingsSoundOff.
  ///
  /// In fr, this message translates to:
  /// **'Désactivé'**
  String get settingsSoundOff;

  /// No description provided for @settingsKeypadLabel.
  ///
  /// In fr, this message translates to:
  /// **'Disposition du clavier numérique'**
  String get settingsKeypadLabel;

  /// No description provided for @settingsKeypadPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get settingsKeypadPhone;

  /// No description provided for @settingsKeypadCalculator.
  ///
  /// In fr, this message translates to:
  /// **'Calculatrice'**
  String get settingsKeypadCalculator;

  /// No description provided for @settingsSectionReminders.
  ///
  /// In fr, this message translates to:
  /// **'Rappels'**
  String get settingsSectionReminders;

  /// No description provided for @settingsReminderLabel.
  ///
  /// In fr, this message translates to:
  /// **'Rappel quotidien'**
  String get settingsReminderLabel;

  /// No description provided for @settingsReminderOn.
  ///
  /// In fr, this message translates to:
  /// **'Rappel activé'**
  String get settingsReminderOn;

  /// No description provided for @settingsReminderOff.
  ///
  /// In fr, this message translates to:
  /// **'Rappel désactivé'**
  String get settingsReminderOff;

  /// No description provided for @settingsReminderTimeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Heure du rappel'**
  String get settingsReminderTimeLabel;

  /// No description provided for @settingsReminderHour.
  ///
  /// In fr, this message translates to:
  /// **'Heures'**
  String get settingsReminderHour;

  /// No description provided for @settingsReminderMinute.
  ///
  /// In fr, this message translates to:
  /// **'Minutes'**
  String get settingsReminderMinute;

  /// No description provided for @settingsReminderUnsupported.
  ///
  /// In fr, this message translates to:
  /// **'Les rappels ne sont pas disponibles sur cet appareil ; ils fonctionnent sur téléphone (Android/iOS).'**
  String get settingsReminderUnsupported;

  /// No description provided for @settingsReminderPermissionDenied.
  ///
  /// In fr, this message translates to:
  /// **'Notifications refusées : active-les dans les réglages du système pour recevoir le rappel.'**
  String get settingsReminderPermissionDenied;

  /// No description provided for @reminderNotificationTitle.
  ///
  /// In fr, this message translates to:
  /// **'PSY Trainer'**
  String get reminderNotificationTitle;

  /// No description provided for @reminderFlashcardsDue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 carte à réviser} other{{count} cartes à réviser}}'**
  String reminderFlashcardsDue(int count);

  /// No description provided for @reminderWeakestFamily.
  ///
  /// In fr, this message translates to:
  /// **'Point faible : {family}'**
  String reminderWeakestFamily(String family);

  /// No description provided for @reminderExamToday.
  ///
  /// In fr, this message translates to:
  /// **'L\'examen est aujourd\'hui'**
  String get reminderExamToday;

  /// No description provided for @reminderExamCountdown.
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =1{Examen dans 1 jour} other{Examen dans {days} jours}}'**
  String reminderExamCountdown(int days);

  /// No description provided for @reminderFallback.
  ///
  /// In fr, this message translates to:
  /// **'Un peu d\'entraînement aujourd\'hui ?'**
  String get reminderFallback;

  /// No description provided for @settingsSectionData.
  ///
  /// In fr, this message translates to:
  /// **'Données'**
  String get settingsSectionData;

  /// No description provided for @settingsResetAction.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser toutes les données'**
  String get settingsResetAction;

  /// No description provided for @settingsResetConfirm1Title.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser toutes les données ?'**
  String get settingsResetConfirm1Title;

  /// No description provided for @settingsResetConfirm1Body.
  ///
  /// In fr, this message translates to:
  /// **'Votre progression, vos statistiques et vos réglages seront effacés. Cette action ne peut pas être annulée.'**
  String get settingsResetConfirm1Body;

  /// No description provided for @settingsResetConfirm2Title.
  ///
  /// In fr, this message translates to:
  /// **'Vraiment tout effacer ?'**
  String get settingsResetConfirm2Title;

  /// No description provided for @settingsResetConfirm2Body.
  ///
  /// In fr, this message translates to:
  /// **'Dernière confirmation : il n\'y aura aucun moyen de récupérer ces données.'**
  String get settingsResetConfirm2Body;

  /// No description provided for @settingsResetConfirmAction.
  ///
  /// In fr, this message translates to:
  /// **'Effacer définitivement'**
  String get settingsResetConfirmAction;

  /// No description provided for @settingsResetCancelAction.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get settingsResetCancelAction;

  /// No description provided for @settingsSectionGoal.
  ///
  /// In fr, this message translates to:
  /// **'Objectif quotidien'**
  String get settingsSectionGoal;

  /// No description provided for @settingsGoalTargetLabel.
  ///
  /// In fr, this message translates to:
  /// **'Cible'**
  String get settingsGoalTargetLabel;

  /// No description provided for @settingsGoalUnitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Unité'**
  String get settingsGoalUnitLabel;

  /// No description provided for @settingsGoalUnitItems.
  ///
  /// In fr, this message translates to:
  /// **'Éléments'**
  String get settingsGoalUnitItems;

  /// No description provided for @settingsGoalUnitMinutes.
  ///
  /// In fr, this message translates to:
  /// **'Minutes'**
  String get settingsGoalUnitMinutes;

  /// No description provided for @settingsSectionBackup.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde'**
  String get settingsSectionBackup;

  /// No description provided for @backupExportAction.
  ///
  /// In fr, this message translates to:
  /// **'Exporter mes données'**
  String get backupExportAction;

  /// No description provided for @backupExportHint.
  ///
  /// In fr, this message translates to:
  /// **'Génère un fichier JSON avec vos sessions, statistiques et réglages, à partager ou conserver.'**
  String get backupExportHint;

  /// No description provided for @backupExportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde partagée.'**
  String get backupExportSuccess;

  /// No description provided for @backupExportCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Partage annulé.'**
  String get backupExportCancelled;

  /// No description provided for @backupExportError.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l\'export.'**
  String get backupExportError;

  /// No description provided for @backupImportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Importer une sauvegarde'**
  String get backupImportTitle;

  /// No description provided for @backupImportHint.
  ///
  /// In fr, this message translates to:
  /// **'Collez ici le contenu d\'un fichier de sauvegarde JSON.'**
  String get backupImportHint;

  /// No description provided for @backupImportAction.
  ///
  /// In fr, this message translates to:
  /// **'Importer'**
  String get backupImportAction;

  /// No description provided for @backupImportEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Collez d\'abord le contenu d\'une sauvegarde.'**
  String get backupImportEmpty;

  /// No description provided for @backupImportSuccess.
  ///
  /// In fr, this message translates to:
  /// **'{inserted} ajout(s), {updated} mise(s) à jour, {skipped} ignoré(s).'**
  String backupImportSuccess(int inserted, int updated, int skipped);

  /// No description provided for @backupErrorInvalidJson.
  ///
  /// In fr, this message translates to:
  /// **'Le texte n\'est pas un JSON valide.'**
  String get backupErrorInvalidJson;

  /// No description provided for @backupErrorNotAnObject.
  ///
  /// In fr, this message translates to:
  /// **'Le document doit être un objet JSON.'**
  String get backupErrorNotAnObject;

  /// No description provided for @backupErrorWrongFormat.
  ///
  /// In fr, this message translates to:
  /// **'Ce fichier n\'est pas une sauvegarde PSY Trainer.'**
  String get backupErrorWrongFormat;

  /// No description provided for @backupErrorUnsupportedVersion.
  ///
  /// In fr, this message translates to:
  /// **'Cette sauvegarde vient d\'une version plus récente de l\'application.'**
  String get backupErrorUnsupportedVersion;

  /// No description provided for @backupErrorMissingData.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde est incomplète (section « data » manquante).'**
  String get backupErrorMissingData;

  /// No description provided for @backupErrorInvalidRow.
  ///
  /// In fr, this message translates to:
  /// **'La sauvegarde contient une entrée invalide.'**
  String get backupErrorInvalidRow;

  /// No description provided for @backupErrorGeneric.
  ///
  /// In fr, this message translates to:
  /// **'Sauvegarde invalide.'**
  String get backupErrorGeneric;

  /// No description provided for @settingsAboutAction.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAboutAction;

  /// No description provided for @aboutTitle.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get aboutTitle;

  /// No description provided for @aboutVersionLabel.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get aboutVersionLabel;

  /// No description provided for @aboutVersionUnknown.
  ///
  /// In fr, this message translates to:
  /// **'Version inconnue'**
  String get aboutVersionUnknown;

  /// No description provided for @aboutSourcesTitle.
  ///
  /// In fr, this message translates to:
  /// **'Sources'**
  String get aboutSourcesTitle;

  /// No description provided for @aboutSourceAirFranceCorporate.
  ///
  /// In fr, this message translates to:
  /// **'Air France Corporate — Pilote de ligne'**
  String get aboutSourceAirFranceCorporate;

  /// No description provided for @aboutSourceAirFranceRecruitment.
  ///
  /// In fr, this message translates to:
  /// **'Portail de recrutement Air France — offre Pilote Cadet'**
  String get aboutSourceAirFranceRecruitment;

  /// No description provided for @aboutSourceAirFranceNews.
  ///
  /// In fr, this message translates to:
  /// **'Air France Corporate — actualités du recrutement Cadets'**
  String get aboutSourceAirFranceNews;

  /// No description provided for @aboutStorageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Stockage'**
  String get aboutStorageLabel;

  /// No description provided for @aboutStorageLocalFile.
  ///
  /// In fr, this message translates to:
  /// **'fichier local'**
  String get aboutStorageLocalFile;

  /// No description provided for @aboutStorageOpfs.
  ///
  /// In fr, this message translates to:
  /// **'OPFS'**
  String get aboutStorageOpfs;

  /// No description provided for @aboutStorageIndexedDb.
  ///
  /// In fr, this message translates to:
  /// **'IndexedDB'**
  String get aboutStorageIndexedDb;

  /// No description provided for @aboutStorageMemory.
  ///
  /// In fr, this message translates to:
  /// **'mémoire (non persistant)'**
  String get aboutStorageMemory;

  /// No description provided for @aboutStorageUnknown.
  ///
  /// In fr, this message translates to:
  /// **'…'**
  String get aboutStorageUnknown;

  /// No description provided for @aboutStorageNotPersistentWarning.
  ///
  /// In fr, this message translates to:
  /// **'Vos données ne seront pas conservées après la fermeture de cet onglet (mode navigation privée ou navigateur non compatible).'**
  String get aboutStorageNotPersistentWarning;

  /// No description provided for @multitaskTouchFallback.
  ///
  /// In fr, this message translates to:
  /// **'Touches non représentatives : le jour J, utilisez le clavier.'**
  String get multitaskTouchFallback;

  /// No description provided for @multitaskExamKeyboardRequired.
  ///
  /// In fr, this message translates to:
  /// **'Cette activité nécessite un clavier physique. Aucun clavier n\'a été détecté : cette épreuve ne peut pas être passée de façon représentative sur cet appareil.'**
  String get multitaskExamKeyboardRequired;

  /// No description provided for @multitaskShapeButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Espace'**
  String get multitaskShapeButtonLabel;

  /// No description provided for @multitaskCalcButtonLabel.
  ///
  /// In fr, this message translates to:
  /// **'F'**
  String get multitaskCalcButtonLabel;

  /// No description provided for @multitaskExampleTracking.
  ///
  /// In fr, this message translates to:
  /// **'Maintenez la flèche du clavier dans la direction où se déplace le cercle.'**
  String get multitaskExampleTracking;

  /// No description provided for @multitaskExampleShape.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur Espace quand la forme dans le cercle est identique à la forme de référence (en haut à gauche).'**
  String get multitaskExampleShape;

  /// No description provided for @multitaskExampleCalc.
  ///
  /// In fr, this message translates to:
  /// **'Appuyez sur F quand le calcul encadré, en bas, est faux.'**
  String get multitaskExampleCalc;

  /// No description provided for @reverseSpanDigitSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Chiffre {shown} sur {total}'**
  String reverseSpanDigitSemantics(int shown, int total);

  /// No description provided for @reverseSpanTypeInstructions.
  ///
  /// In fr, this message translates to:
  /// **'Retapez la séquence à l\'envers'**
  String get reverseSpanTypeInstructions;

  /// No description provided for @reverseSpanExampleShown.
  ///
  /// In fr, this message translates to:
  /// **'La séquence affichée, chiffre par chiffre :'**
  String get reverseSpanExampleShown;

  /// No description provided for @reverseSpanExampleExpected.
  ///
  /// In fr, this message translates to:
  /// **'Retapez-la à l\'envers :'**
  String get reverseSpanExampleExpected;

  /// No description provided for @calcBackStageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Étape {stage} sur {stageCount}'**
  String calcBackStageLabel(int stage, int stageCount);

  /// No description provided for @calcBackStemSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez au résultat obtenu il y a {stage} calcul(s)'**
  String calcBackStemSemantics(int stage);

  /// No description provided for @calcBackExampleStage.
  ///
  /// In fr, this message translates to:
  /// **'Étape 2 : combinez le nombre affiché avec le résultat obtenu il y a deux calculs.'**
  String get calcBackExampleStage;

  /// No description provided for @p1AnglesExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Parmi les valeurs proposées, touchez celles qui correspondent à un angle dessiné (A, B...), puis Valider.'**
  String get p1AnglesExampleCaption;

  /// No description provided for @p1AnglesCandidateSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Valeur {index}, {value} degrés'**
  String p1AnglesCandidateSemantics(int index, int value);

  /// No description provided for @mentalArithmeticAllIntervalsPrompt.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionnez tous les intervalles qui contiennent la valeur exacte.'**
  String get mentalArithmeticAllIntervalsPrompt;

  /// No description provided for @mentalArithmeticTrueValue.
  ///
  /// In fr, this message translates to:
  /// **'Valeur exacte : {value}'**
  String mentalArithmeticTrueValue(int value);

  /// No description provided for @mentalArithmeticIntervalSemantics.
  ///
  /// In fr, this message translates to:
  /// **'Intervalle {index}, {label}'**
  String mentalArithmeticIntervalSemantics(int index, String label);

  /// No description provided for @mentalArithmeticAllIntervalsExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Calculez la valeur exacte, puis touchez tous les intervalles qui la contiennent avant de Valider.'**
  String get mentalArithmeticAllIntervalsExampleCaption;

  /// No description provided for @p1CountersExampleCaption.
  ///
  /// In fr, this message translates to:
  /// **'Lisez chaque cadran (aiguille, échelle ou compteur à tambour) puis répondez à la question posée.'**
  String get p1CountersExampleCaption;

  /// No description provided for @psy2NoTimedExercise.
  ///
  /// In fr, this message translates to:
  /// **'Pas d\'exercice chronométré pour le PSY2 : entraînez-vous depuis l\'onglet Apprendre (entretien, exercice de groupe).'**
  String get psy2NoTimedExercise;

  /// No description provided for @psy2LearnInterviewSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Sept thèmes de questions, chronomètre de préparation/réponse, notes et auto-évaluation.'**
  String get psy2LearnInterviewSubtitle;

  /// No description provided for @psy2LearnGroupExerciseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Les six comportements CRM, un guide d\'entraînement entre pairs et une grille d\'auto-évaluation.'**
  String get psy2LearnGroupExerciseSubtitle;

  /// No description provided for @psy2LearnHowItWorksSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'La structure du PSY2, ce que l\'app peut préparer, et ce qu\'elle ne fait pas.'**
  String get psy2LearnHowItWorksSubtitle;

  /// No description provided for @psy2InterviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entretien'**
  String get psy2InterviewTitle;

  /// No description provided for @psy2InterviewIntro.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un thème (ou laissez le hasard décider), puis entraînez-vous avec un chronomètre de préparation et de réponse.'**
  String get psy2InterviewIntro;

  /// No description provided for @psy2InterviewEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune question d\'entretien pour le moment.'**
  String get psy2InterviewEmpty;

  /// No description provided for @psy2InterviewThemeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get psy2InterviewThemeTitle;

  /// No description provided for @psy2InterviewThemeRandom.
  ///
  /// In fr, this message translates to:
  /// **'Au hasard'**
  String get psy2InterviewThemeRandom;

  /// No description provided for @psy2InterviewStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get psy2InterviewStart;

  /// No description provided for @psy2InterviewPrepLabel.
  ///
  /// In fr, this message translates to:
  /// **'Préparation'**
  String get psy2InterviewPrepLabel;

  /// No description provided for @psy2InterviewAnswerLabel.
  ///
  /// In fr, this message translates to:
  /// **'Réponse'**
  String get psy2InterviewAnswerLabel;

  /// No description provided for @psy2InterviewShowGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Voir la méthode de réponse'**
  String get psy2InterviewShowGuidance;

  /// No description provided for @psy2InterviewHideGuidance.
  ///
  /// In fr, this message translates to:
  /// **'Masquer la méthode de réponse'**
  String get psy2InterviewHideGuidance;

  /// No description provided for @psy2InterviewGuidanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ce qu\'une bonne réponse couvre'**
  String get psy2InterviewGuidanceTitle;

  /// No description provided for @psy2InterviewSkeletonTitle.
  ///
  /// In fr, this message translates to:
  /// **'Structure suggérée'**
  String get psy2InterviewSkeletonTitle;

  /// No description provided for @psy2InterviewNotesLabel.
  ///
  /// In fr, this message translates to:
  /// **'Notes personnelles'**
  String get psy2InterviewNotesLabel;

  /// No description provided for @psy2InterviewNotesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui s\'est bien passé, ce que je changerais...'**
  String get psy2InterviewNotesHint;

  /// No description provided for @psy2InterviewSkipPrep.
  ///
  /// In fr, this message translates to:
  /// **'Commencer à répondre'**
  String get psy2InterviewSkipPrep;

  /// No description provided for @psy2InterviewFinishAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Terminer et m\'auto-évaluer'**
  String get psy2InterviewFinishAnswer;

  /// No description provided for @psy2InterviewRubricTitle.
  ///
  /// In fr, this message translates to:
  /// **'Auto-évaluation'**
  String get psy2InterviewRubricTitle;

  /// No description provided for @psy2InterviewSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get psy2InterviewSave;

  /// No description provided for @psy2InterviewSaved.
  ///
  /// In fr, this message translates to:
  /// **'Entraînement enregistré. Retrouvez son historique dans l\'onglet Progression.'**
  String get psy2InterviewSaved;

  /// No description provided for @psy2InterviewPracticeAnother.
  ///
  /// In fr, this message translates to:
  /// **'S\'entraîner sur une autre question'**
  String get psy2InterviewPracticeAnother;

  /// No description provided for @psy2GroupExerciseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exercice de groupe'**
  String get psy2GroupExerciseTitle;

  /// No description provided for @psy2GroupExerciseChecklistTitle.
  ///
  /// In fr, this message translates to:
  /// **'Auto-évaluation après un entraînement'**
  String get psy2GroupExerciseChecklistTitle;

  /// No description provided for @psy2GroupExerciseWentWell.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui s\'est bien passé'**
  String get psy2GroupExerciseWentWell;

  /// No description provided for @psy2GroupExerciseToImprove.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui est à améliorer'**
  String get psy2GroupExerciseToImprove;

  /// No description provided for @psy2GroupExerciseReflection1.
  ///
  /// In fr, this message translates to:
  /// **'Que ferais-je différemment si c\'était l\'épreuve réelle ?'**
  String get psy2GroupExerciseReflection1;

  /// No description provided for @psy2GroupExerciseReflection2.
  ///
  /// In fr, this message translates to:
  /// **'Qu\'ai-je appris sur mon comportement par défaut sous pression ?'**
  String get psy2GroupExerciseReflection2;

  /// No description provided for @psy2GroupExerciseSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get psy2GroupExerciseSave;

  /// No description provided for @psy2GroupExerciseSaved.
  ///
  /// In fr, this message translates to:
  /// **'Auto-évaluation enregistrée. Retrouvez son historique dans l\'onglet Progression.'**
  String get psy2GroupExerciseSaved;

  /// No description provided for @psy2HowItWorksTitle.
  ///
  /// In fr, this message translates to:
  /// **'Comment se passe le PSY2'**
  String get psy2HowItWorksTitle;

  /// No description provided for @psy2HowItWorksEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Contenu à venir.'**
  String get psy2HowItWorksEmpty;

  /// No description provided for @psy2ThemeMotivation.
  ///
  /// In fr, this message translates to:
  /// **'Motivation et projet'**
  String get psy2ThemeMotivation;

  /// No description provided for @psy2ThemeBackground.
  ///
  /// In fr, this message translates to:
  /// **'Parcours et présentation'**
  String get psy2ThemeBackground;

  /// No description provided for @psy2ThemeCrmTeamwork.
  ///
  /// In fr, this message translates to:
  /// **'CRM et travail d\'équipe'**
  String get psy2ThemeCrmTeamwork;

  /// No description provided for @psy2ThemeStress.
  ///
  /// In fr, this message translates to:
  /// **'Stress et pression'**
  String get psy2ThemeStress;

  /// No description provided for @psy2ThemeSelfAwareness.
  ///
  /// In fr, this message translates to:
  /// **'Connaissance de soi'**
  String get psy2ThemeSelfAwareness;

  /// No description provided for @psy2ThemeAviationKnowledge.
  ///
  /// In fr, this message translates to:
  /// **'Culture aéronautique'**
  String get psy2ThemeAviationKnowledge;

  /// No description provided for @psy2ThemeReflective.
  ///
  /// In fr, this message translates to:
  /// **'Questions réflexives'**
  String get psy2ThemeReflective;

  /// No description provided for @psy2RubricStructure.
  ///
  /// In fr, this message translates to:
  /// **'Structure (situation → action → résultat)'**
  String get psy2RubricStructure;

  /// No description provided for @psy2RubricConcreteness.
  ///
  /// In fr, this message translates to:
  /// **'Exemples concrets'**
  String get psy2RubricConcreteness;

  /// No description provided for @psy2RubricSelfAwareness.
  ///
  /// In fr, this message translates to:
  /// **'Connaissance de soi'**
  String get psy2RubricSelfAwareness;

  /// No description provided for @psy2RubricRelevance.
  ///
  /// In fr, this message translates to:
  /// **'Lien avec l\'aéronautique / le CRM'**
  String get psy2RubricRelevance;

  /// No description provided for @psy2RubricDelivery.
  ///
  /// In fr, this message translates to:
  /// **'Aisance à l\'oral'**
  String get psy2RubricDelivery;

  /// No description provided for @psy2DimCommunication.
  ///
  /// In fr, this message translates to:
  /// **'Communication'**
  String get psy2DimCommunication;

  /// No description provided for @psy2DimLeadership.
  ///
  /// In fr, this message translates to:
  /// **'Leadership / suivisme'**
  String get psy2DimLeadership;

  /// No description provided for @psy2DimSituationalAwareness.
  ///
  /// In fr, this message translates to:
  /// **'Conscience de la situation'**
  String get psy2DimSituationalAwareness;

  /// No description provided for @psy2DimDecisionMaking.
  ///
  /// In fr, this message translates to:
  /// **'Prise de décision'**
  String get psy2DimDecisionMaking;

  /// No description provided for @psy2DimWorkloadManagement.
  ///
  /// In fr, this message translates to:
  /// **'Gestion de la charge'**
  String get psy2DimWorkloadManagement;

  /// No description provided for @psy2DimTeamwork.
  ///
  /// In fr, this message translates to:
  /// **'Esprit d\'équipe'**
  String get psy2DimTeamwork;

  /// No description provided for @psy2ProgressInterviewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entretien — progression'**
  String get psy2ProgressInterviewTitle;

  /// No description provided for @psy2ProgressInterviewSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne de l\'auto-évaluation par entraînement, et moyenne par critère.'**
  String get psy2ProgressInterviewSubtitle;

  /// No description provided for @psy2ProgressGroupExerciseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Exercice de groupe — progression'**
  String get psy2ProgressGroupExerciseTitle;

  /// No description provided for @psy2ProgressGroupExerciseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne de l\'auto-évaluation par session, et moyenne par dimension CRM.'**
  String get psy2ProgressGroupExerciseSubtitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
