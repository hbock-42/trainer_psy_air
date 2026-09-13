// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PSY Trainer';

  @override
  String get tabLearn => 'Learn';

  @override
  String get tabTrain => 'Practice';

  @override
  String get tabExam => 'Exam';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabBarLabel => 'Main navigation';

  @override
  String get moduleSwitchSemanticsLabel => 'Active module';

  @override
  String get moduleSwitchPsy0 => 'PSY0';

  @override
  String get moduleSwitchPsy1 => 'PSY1';

  @override
  String get moduleSwitchPsy2 => 'PSY2';

  @override
  String get disclaimerShort =>
      'Independent, unofficial trainer — no affiliation with Air France.';

  @override
  String get disclaimerTitle => 'Unofficial application.';

  @override
  String get disclaimerParagraph1 =>
      'This application is an independent training tool. It is neither affiliated with, nor endorsed by, Air France, Transavia, ENAC or their providers. The trademarks mentioned belong to their owners and are used only to describe the selection process concerned.';

  @override
  String get disclaimerParagraph2 =>
      'The exercises, questions and durations offered are designed by us from public information and candidate feedback; they are estimates and do not reproduce any real test material. The content of the real selection changes every year. No result obtained here prejudges your success in the selection.';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionFinish => 'Finish';

  @override
  String get actionSave => 'Save';

  @override
  String get actionRetry => 'Retry';

  @override
  String get startupLoadingContent => 'Loading content…';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get errorBackHome => 'Back to home';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingEditTitle => 'My profile';

  @override
  String get onboardingWelcomeHeadline => 'Welcome to PSY Trainer';

  @override
  String get onboardingWelcomeIntro =>
      'Train for the Air France cadet online pre-selection activities (PSY0): lessons, timed exercises and exam simulation. Before you start, one important note.';

  @override
  String get onboardingDisclaimerAccept =>
      'I understand that this application is an independent trainer, with no affiliation to Air France, and that its exercises are estimates.';

  @override
  String get onboardingDisclaimerRequired => 'Accept this notice to continue.';

  @override
  String get onboardingExamDateHeadline => 'When are you taking the PSY0?';

  @override
  String get onboardingExamDateIntro =>
      'The pre-selection takes place on the first weekend of September. This date paces your preparation; you can change it later in settings.';

  @override
  String get onboardingExamDateSuggestion => 'Likely next session:';

  @override
  String get onboardingExamDateUnknown => 'I don\'t know yet';

  @override
  String get onboardingExamDateInThePast =>
      'This date is already past. Choose an upcoming date.';

  @override
  String get dateFieldDay => 'Day';

  @override
  String get dateFieldMonth => 'Month';

  @override
  String get dateFieldYear => 'Year';

  @override
  String get dateFieldIncrement => 'Next';

  @override
  String get dateFieldDecrement => 'Previous';

  @override
  String get onboardingStageHeadline => 'Which stage are you preparing?';

  @override
  String get onboardingStageIntro =>
      'The app\'s content follows the stage you choose. Only PSY0 is available for now.';

  @override
  String get stagePsy0Subtitle =>
      'Cognitive tests, aviation knowledge and English, remote.';

  @override
  String get stagePsy1Subtitle =>
      'Psychotechnical and psychomotor tests, one day in person.';

  @override
  String get stageComingSoon => 'Coming soon';

  @override
  String get settingsEditProfile => 'Edit my profile';

  @override
  String get settingsProfileSummaryExamDate => 'Exam date:';

  @override
  String get settingsProfileSummaryNoExamDate => 'not set';

  @override
  String get settingsProfileSummaryStage => 'Target stage:';

  @override
  String get learnDisclaimerExpand => 'Read the full disclaimer';

  @override
  String get learnDisclaimerCollapse => 'Collapse the disclaimer';

  @override
  String get learnHowItWorksTitle => 'How the selection works';

  @override
  String get learnHowItWorksSubtitle =>
      'Dossier, PSY0, PSY1, PSY2, medical: the stages, what\'s eliminatory and what we actually know.';

  @override
  String get learnHowItWorksSemantics =>
      'How the selection works, open the page';

  @override
  String get learnFamiliesTitle => 'The PSY0 activities';

  @override
  String get learnFamiliesSubtitle =>
      'In the order of the real test, as reported by candidates.';

  @override
  String get learnFamiliesLoading => 'Loading activities…';

  @override
  String get learnFamiliesError =>
      'Could not load activities. Restart the app; if the problem persists, reinstall it.';

  @override
  String get learnEmptyTitle => 'No activities yet';

  @override
  String get learnEmptyBody =>
      'The PSY0 activity sheets (memory, attention, spatial, logic, aviation knowledge, English…) will appear here once the content is installed.';

  @override
  String get familyMasteryLabel => 'Mastery';

  @override
  String get familyMasteryUnknown => '—';

  @override
  String get familyActionLearn => 'Learn';

  @override
  String get familyActionTrain => 'Practice';

  @override
  String get familyActionCards => 'Cards';

  @override
  String get familyLessonsTitle => 'Lessons';

  @override
  String get familyLessonsEmpty => 'No lesson for this activity yet.';

  @override
  String get familyNotFound => 'Activity not found.';

  @override
  String get familyLoading => 'Loading…';

  @override
  String get familyFormatLabel => 'Format';

  @override
  String get familyEvaluatedLabel => 'What is assessed';

  @override
  String get confidenceConfirmed => 'confirmed';

  @override
  String get confidenceReported => 'reported';

  @override
  String get confidenceAssumed => 'assumed';

  @override
  String get confidenceLegend =>
      'confirmed = official Air France source · reported = consistent candidate feedback · assumed = our best guess';

  @override
  String get howItWorksIntro =>
      'The Air France Cadet selection is a sequence of stages, all eliminatory. This application prepares you for PSY0; here is where it fits in.';

  @override
  String get howItWorksStagesTitle => 'The stages';

  @override
  String get howItWorksCalendarTitle => '2026 calendar';

  @override
  String get howItWorksCalendarBody =>
      'Applications ~June 15 → July 31 · PSY0 September 4–5 · PSY1 October 19–30 · PSY2 from January 2027.';

  @override
  String get howItWorksRetakeTitle => 'Retake rules';

  @override
  String get howItWorksRetakeBody =>
      '3 failures at PSY0 or 2 at PSY1 mean permanent exclusion from the Cadet track (the \"Professional Pilot\" track stays open). A deferral at PSY2 means a new attempt after 1 or 2 years.';

  @override
  String get howItWorksEliminatory => 'Eliminatory';

  @override
  String get stageDossierTitle => 'Application dossier';

  @override
  String get stageDossierWhen => 'June – July, online';

  @override
  String get stageDossierBody =>
      'Application through the Air France recruitment portal. Prerequisites checked (degree, class 2 medical, nationality); a €200 fee. Only admissible files are invited to PSY0.';

  @override
  String get stageDossierFactFee => '€200 fee';

  @override
  String get stagePsy0Title => 'PSY0 — pre-selection';

  @override
  String get stagePsy0When =>
      'First weekend of September, remote, secured software + webcam';

  @override
  String get stagePsy0Body =>
      'An online battery of about 3 h within a 36 h window: ~14 short activities (memory, attention, spatial, logic, planning, arithmetic, multitasking), general aviation knowledge and intensive English. Produces a ranking; a waiting list exists.';

  @override
  String get stagePsy0FactDuration => '~3 h, 36 h window';

  @override
  String get stagePsy0FactActivities => '14 activities';

  @override
  String get stagePsy0FactWaitlist => 'Waiting list';

  @override
  String get stagePsy1Title => 'PSY1 — psychotechnical tests';

  @override
  String get stagePsy1When => 'One day during the Toussaint school holidays';

  @override
  String get stagePsy1Body =>
      'Cognitive and psychomotor tests on computer: joysticks, dual task, target tracking, matrices, counters… Elimination reported around 70%.';

  @override
  String get stagePsy1FactDay => 'One day, Toussaint';

  @override
  String get stagePsy1FactVenue => 'ENAC Toulouse';

  @override
  String get stagePsy1FactRate => '~70% elimination';

  @override
  String get stagePsy2Title => 'PSY2 — final selection';

  @override
  String get stagePsy2When =>
      'From January, Roissy-CDG, Air France selection service';

  @override
  String get stagePsy2Body =>
      'Two personality inventories, a group exercise (under confidentiality) and an individual interview with psychologists and pilots. The recruitment board decides pass or deferral.';

  @override
  String get stagePsy2FactContent => 'Personality, group, interview';

  @override
  String get stagePsy2FactCoaching =>
      'Paid coaching: \"no added value\" according to Air France';

  @override
  String get stageMedicalTitle => 'Class 1 medical';

  @override
  String get stageMedicalWhen => 'Before entering training';

  @override
  String get stageMedicalBody =>
      'A class 2 medical certificate is required from the application stage; class 1 is mandatory before entering flight school.';

  @override
  String get stageMedicalFactClass2 => 'Class 2 at application';

  @override
  String get stageMedicalFactClass1 => 'Class 1 before training';

  @override
  String get stageTrainingTitle => 'Training';

  @override
  String get stageTrainingWhen => '24 months at a partner school';

  @override
  String get stageTrainingBody =>
      '9 months of ATPL theory then 15 to 21 months of CPL/IR-ME/MCC, housed and paid (professional training contract). Assignment to Air France or Transavia, not chosen by the cadet.';

  @override
  String get stageTrainingFactDuration => '24 months, paid';

  @override
  String get sessionStart => 'Start';

  @override
  String get sessionNext => 'Next';

  @override
  String get sessionPause => 'Pause';

  @override
  String get sessionResume => 'Resume';

  @override
  String get sessionQuit => 'Quit';

  @override
  String get sessionPausedTitle => 'Session paused';

  @override
  String get sessionFinishedTitle => 'Activity finished';

  @override
  String get sessionBriefingDefault =>
      'Read the instructions, then press Start. The timer starts with the first question.';

  @override
  String get sessionExamplePlaceholder => 'Example coming soon.';

  @override
  String get sessionFeedbackCorrect => 'Correct answer';

  @override
  String get sessionFeedbackWrong => 'Wrong answer';

  @override
  String get sessionFeedbackTimeout => 'Time\'s up';

  @override
  String get sessionFeedbackSkipped => 'Question skipped';

  @override
  String get sessionItemTimerLabel => 'Time for this question';

  @override
  String get sessionSectionTimerLabel => 'Time remaining';

  @override
  String get activityValidate => 'Confirm';

  @override
  String get activityExplanationTitle => 'Explanation';

  @override
  String get mcqSkipOption => 'I don\'t know';

  @override
  String get mcqPassageDefaultTitle => 'Reference text';

  @override
  String get mcqPassageShow => 'Show the text';

  @override
  String get mcqPassageHide => 'Hide the text';

  @override
  String get mcqExampleStem => 'What is the capital of France?';

  @override
  String get mcqExampleOptionCorrect => 'Paris';

  @override
  String get mcqExampleOptionWrong1 => 'Lyon';

  @override
  String get mcqExampleOptionWrong2 => 'Marseille';

  @override
  String get numericAnswerSemanticsLabel => 'Answer';

  @override
  String get numericBackspaceSemanticsLabel => 'Delete';

  @override
  String get numericExampleStem => 'How much is 8 × 6?';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressLoading => 'Calculating…';

  @override
  String get progressError => 'Could not load your statistics.';

  @override
  String get progressEmptyTitle => 'No training yet';

  @override
  String get progressEmptyBody =>
      'Start your first exercise: your readiness score, your levels per family and your activity will appear here.';

  @override
  String get progressEmptyAction => 'Start an exercise';

  @override
  String get readinessTitle => 'Readiness';

  @override
  String get readinessSemanticsLabel => 'Readiness score';

  @override
  String get readinessOutOf => 'out of 100';

  @override
  String get readinessTrendUp => 'Improving';

  @override
  String get readinessTrendFlat => 'Stable';

  @override
  String get readinessTrendDown => 'Declining';

  @override
  String get readinessHint =>
      'Families practised, lessons read and simulations count.';

  @override
  String get streakCardTitle => 'Streak';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: 'No streak',
    );
    return '$_temp0';
  }

  @override
  String streakBest(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
      zero: '—',
    );
    return 'Best: $_temp0';
  }

  @override
  String streakGoalItems(int done, int target) {
    return '$done/$target items today';
  }

  @override
  String streakGoalMinutes(int done, int target) {
    return '$done/$target min today';
  }

  @override
  String get streakGoalMet => 'Goal reached!';

  @override
  String get streakSemanticsLabel => 'Training streak';

  @override
  String streakSemanticsValue(int current, int best, String goal) {
    return '$current day streak, best $best days, $goal';
  }

  @override
  String get activityHeatmapSemanticsLabel =>
      'Activity calendar, last 12 weeks';

  @override
  String activityHeatmapSemanticsValue(int active, int total) {
    return '$active/$total active days over the last 12 weeks';
  }

  @override
  String get examDateSemanticsLabel => 'Exam';

  @override
  String get examDatePassed => 'Exam date passed';

  @override
  String get familyLevelsTitle => 'Levels per family';

  @override
  String get familyLevelsSubtitle => 'In the order of the real test';

  @override
  String get familyLevelsSemanticsLabel => 'Levels per family';

  @override
  String get familyLevelsNone => 'No family practised yet.';

  @override
  String get familyNotPractised => 'not practised';

  @override
  String get weakAreasTitle => 'To work on';

  @override
  String get weakAreasSubtitle => 'Your current weak spots';

  @override
  String get weakAreasNone => 'Nothing to report: keep training regularly.';

  @override
  String get weakAreaTrain => 'Practice';

  @override
  String get weakReasonLowAccuracy => 'low accuracy';

  @override
  String get weakReasonNegativeTrend => 'declining';

  @override
  String get trainNextTitle => 'Up next';

  @override
  String get trainNextSubtitle => 'What will improve your readiness the most';

  @override
  String get trainNextEmpty =>
      'Nothing to recommend for now: keep training regularly.';

  @override
  String get trainNextActionFamily => 'Practice';

  @override
  String get trainNextActionExam => 'Simulate the exam';

  @override
  String get trainNextActionLesson => 'Read the lesson';

  @override
  String get trainNextActionFlashcards => 'Review';

  @override
  String get recentActivityTitle => 'Recent activity';

  @override
  String get recentActivitySubtitle => 'Exercises and simulations';

  @override
  String get recentActivityNone => 'No session completed yet.';

  @override
  String get activityPractice => 'Exercise';

  @override
  String get activityExam => 'Simulation';

  @override
  String get activityAbandoned => 'abandoned';

  @override
  String get activityInProgress => 'in progress';

  @override
  String get scoreUnknown => '—';

  @override
  String get lessonCalloutTip => 'Tip';

  @override
  String get lessonCalloutTrap => 'Pitfall';

  @override
  String get lessonCalloutMethod => 'Method';

  @override
  String get lessonCalloutExample => 'Example';

  @override
  String get lessonImagePlaceholder => 'Image';

  @override
  String get lessonRevealNextStep => 'Next step';

  @override
  String get lessonRevealAllSteps => 'Show all';

  @override
  String get lessonTocTitle => 'Contents';

  @override
  String get lessonTocShow => 'Show contents';

  @override
  String get lessonTocHide => 'Hide contents';

  @override
  String get lessonTryIt => 'Try it';

  @override
  String get lessonPrevious => 'Previous lesson';

  @override
  String get lessonNext => 'Next lesson';

  @override
  String get lessonMarkRead => 'Mark as read';

  @override
  String get lessonMarkedRead => 'Read';

  @override
  String get lessonNotFound => 'Lesson not found.';

  @override
  String get lessonLoading => 'Loading…';

  @override
  String get flashcardsHomeTitle => 'To review today';

  @override
  String get flashcardsHomeSemantics =>
      'Review today\'s cards, open the session';

  @override
  String get flashcardsTitle => 'Cards';

  @override
  String get flashcardsLoading => 'Loading cards…';

  @override
  String get flashcardsError => 'Could not load the cards.';

  @override
  String get flashcardsStart => 'Start';

  @override
  String get flashcardsEmptyTitle => 'Nothing to review';

  @override
  String get flashcardsEmptyBody =>
      'Every card in this deck is up to date. Come back later.';

  @override
  String get flashcardsFlipHint => 'Tap or press Space to flip';

  @override
  String get flashcardsAgain => 'Again';

  @override
  String get flashcardsHard => 'Hard';

  @override
  String get flashcardsGood => 'Easy';

  @override
  String get flashcardsAgainSemantics => 'Again (key 1)';

  @override
  String get flashcardsHardSemantics => 'Hard (key 2)';

  @override
  String get flashcardsGoodSemantics => 'Easy (key 3)';

  @override
  String get flashcardsSummaryTitle => 'Session finished';

  @override
  String get flashcardsSummaryDone => 'Finish';

  @override
  String get flashcardsBackSemantics => 'Back';

  @override
  String get familyDetailsTitle => 'Details per family';

  @override
  String get familyDetailsHint => 'Tap a family to see its trend.';

  @override
  String get familyTrendTitle => 'Trend';

  @override
  String get trendRangeLabel => 'Range';

  @override
  String get trendRange7d => '7 d';

  @override
  String get trendRange30d => '30 d';

  @override
  String get trendRangeAll => 'All';

  @override
  String get trendModeLabel => 'Mode';

  @override
  String get trendModeAll => 'All';

  @override
  String get trendModePractice => 'Exercises';

  @override
  String get trendModeExam => 'Simulations';

  @override
  String get trendAccuracyTitle => 'Accuracy';

  @override
  String get trendAccuracySubtitle => 'Success rate per session';

  @override
  String get trendSpeedTitle => 'Speed';

  @override
  String get trendSpeedSubtitle => 'Median response time per session';

  @override
  String get trendEmpty => 'No session in this period.';

  @override
  String get trendLoading => 'Calculating…';

  @override
  String get trendAccuracyLabel => 'Accuracy';

  @override
  String get trendSpeedLabel => 'Time';

  @override
  String get examChartTitle => 'Simulations';

  @override
  String get examChartSubtitle => 'Overall score per simulation';

  @override
  String get examChartSemanticsLabel => 'Simulation scores';

  @override
  String get examChartHint => 'Tap a point for the detail per section.';

  @override
  String get examSectionsSemanticsLabel => 'Detail per section';

  @override
  String get examSectionNotReached => 'not reached';

  @override
  String get actionValidate => 'Confirm';

  @override
  String get dominoTopLabel => 'Top';

  @override
  String get dominoBottomLabel => 'Bottom';

  @override
  String get dominoMissingSemantics => 'Missing domino';

  @override
  String get dominoRuleLinearEachHalf =>
      'One half advances at a steady rate (+k modulo 7).';

  @override
  String get dominoRuleAlternatingTopBottom =>
      'The top and bottom halves advance in turn (+k modulo 7).';

  @override
  String get dominoRuleMirroredHalves =>
      'The bottom half mirrors the top half (their sum is 6).';

  @override
  String get dominoRuleConstantSum =>
      'The sum of the two halves stays the same throughout the series.';

  @override
  String get dominoRuleInterleavedSeries =>
      'Two series are interleaved: one for even positions, one for odd ones.';

  @override
  String get nbackYes => 'Yes';

  @override
  String get nbackNo => 'No';

  @override
  String get nbackPrimerLabel => 'Primer — no response expected';

  @override
  String get nbackHistoryStripLabel => 'Reference (recent stimuli)';

  @override
  String get attentionRulesTouchFallback =>
      'Non-representative touch controls: on the real day, use the keyboard.';

  @override
  String get arithmeticGridValidate => 'Confirm';

  @override
  String get arithmeticGridExampleCaption =>
      'Tap the false equalities (in red), then Confirm. The others are correct; do not tap them.';

  @override
  String get trainFamiliesSubtitle => 'Choose an activity';

  @override
  String get trainFamiliesLoading => 'Loading activities…';

  @override
  String get trainFamiliesError => 'Could not load activities.';

  @override
  String get trainFamiliesEmpty => 'No activity available yet.';

  @override
  String get trainFamilyComingSoon => 'Coming soon';

  @override
  String get trainQuick5Label => 'Quick (5)';

  @override
  String get practiceLauncherNotFound => 'Activity not found.';

  @override
  String get practiceEngineComingSoon =>
      'This activity is coming soon: its engine is not ready yet.';

  @override
  String get practiceItemCountLabel => 'Number of questions';

  @override
  String get practiceDifficultyLabel => 'Difficulty';

  @override
  String get practiceDifficultyAuto => 'Auto';

  @override
  String get practiceTimingLabel => 'Timing';

  @override
  String get practiceTimedOn => 'Timed';

  @override
  String get practiceTimedOff => 'Untimed';

  @override
  String get practiceStartAction => 'Start';

  @override
  String get practiceQuick5Action => 'Quick start (5 questions)';

  @override
  String get practiceRetryMistakesSoon => 'Retry my mistakes (coming soon)';

  @override
  String get practiceRetryMistakesEmpty => 'No mistake to retry for now.';

  @override
  String get trainSessionPlaceholderTitle => 'Session (US-051)';

  @override
  String get trainSessionSummaryTimed => 'Timed';

  @override
  String get trainSessionSummaryUntimed => 'Untimed';

  @override
  String get attentionParityStartLabel => 'START';

  @override
  String get attentionParityEndLabel => 'FINISH';

  @override
  String get sessionQuitConfirmTitle => 'Quit the session?';

  @override
  String get sessionQuitConfirmBody =>
      'Your progress will be recorded as abandoned.';

  @override
  String get sessionQuitConfirmAction => 'Quit';

  @override
  String get sessionQuitCancelAction => 'Cancel';

  @override
  String get sessionResumeCardTitle => 'Resume the session';

  @override
  String get sessionResumeCardAction => 'Resume the session';

  @override
  String get summaryTitle => 'Summary';

  @override
  String summaryLevelChangeLabel(int from, int to) {
    return 'Level $from → $to';
  }

  @override
  String get summaryAccuracyLabel => 'Accuracy';

  @override
  String get summaryMeanRtLabel => 'Mean time';

  @override
  String get summaryMedianRtLabel => 'Median time';

  @override
  String get summaryTimeoutsLabel => 'Timeouts';

  @override
  String get summaryItemsTitle => 'Question detail';

  @override
  String get summaryRestartAction => 'Restart';

  @override
  String get summaryRetryMistakesAction => 'Redo the mistakes';

  @override
  String get summaryBackAction => 'Back';

  @override
  String get summaryReviewMyAnswer => 'Your answer';

  @override
  String get summaryReviewExpected => 'Expected answer';

  @override
  String get summaryReviewRawAnswer => 'Recorded answer';

  @override
  String get tubesStartLabel => 'Start';

  @override
  String get tubesTargetLabel => 'Target';

  @override
  String get tubesShowSolutionAction => 'Show the solution';

  @override
  String get tubesHideSolutionAction => 'Hide the solution';

  @override
  String get tubesSolutionPreviousStep => 'Previous step';

  @override
  String get tubesSolutionNextStep => 'Next step';

  @override
  String get viewpointMapSemanticsLabel => 'Map: 8 viewpoints around the scene';

  @override
  String get viewpointExampleCaption =>
      'Click the viewpoint from which the scene was photographed.';

  @override
  String get examHomeSubtitle =>
      'Timed simulations, in the order of the real test';

  @override
  String get examHistoryAction => 'History';

  @override
  String get examEmptyBlueprints => 'No simulation available yet.';

  @override
  String get examBlueprintsError => 'Could not load the simulations.';

  @override
  String get examBlueprintsLoading => 'Loading simulations…';

  @override
  String get examSectionUnavailable => 'unavailable — will be skipped';

  @override
  String get examStartAction => 'Start';

  @override
  String get examRealismTitle => 'Exam conditions';

  @override
  String get examRealismSubtitle =>
      'Adjust how closely the simulation matches the real test before you start.';

  @override
  String get examRealismPresetAction => 'Real conditions';

  @override
  String get examRealismNegativeMarkingLabel =>
      'Negative marking (general knowledge)';

  @override
  String get examRealismHideRemainingTimeLabel => 'Hide remaining time';

  @override
  String get examRealismHideTimerEnglishLabel => 'Hide the timer in English';

  @override
  String get examRealismRandomizeLabel => 'Randomise shapes/colours/keys';

  @override
  String get examRealismAllowPauseLabel => 'Allow pausing between sections';

  @override
  String get examRealismImmersiveLabel =>
      'Immersive full screen and orientation lock';

  @override
  String get examRealismSoundCuesLabel => 'Sound cues (section start/end)';

  @override
  String get examRunnerTitle => 'Simulation';

  @override
  String get examRunnerLoading => 'Preparing the simulation…';

  @override
  String get examRunnerFinishing => 'Calculating results…';

  @override
  String get examRunnerAborted =>
      'Simulation interrupted: it was recorded as abandoned.';

  @override
  String get examRunnerUnavailable =>
      'No activity in this simulation is available right now.';

  @override
  String get examRunnerBackToHome => 'Back';

  @override
  String get examRunnerBreakTitle => 'Break';

  @override
  String get examQuitConfirmTitle => 'Quit the simulation?';

  @override
  String get examQuitConfirmBody =>
      'The whole simulation will be recorded as abandoned: it cannot resume once quit.';

  @override
  String get examQuitConfirmAction => 'Quit';

  @override
  String get examHistoryTitle => 'Simulation history';

  @override
  String get examHistoryEmpty => 'No simulation yet.';

  @override
  String get examHistoryError => 'Could not load the history.';

  @override
  String get examHistoryLoading => 'Loading history…';

  @override
  String get examHistoryStatusCompleted => 'Completed';

  @override
  String get examHistoryStatusAbandoned => 'Abandoned';

  @override
  String get examHistoryStatusInProgress => 'In progress';

  @override
  String get examHistoryDeleteAction => 'Delete';

  @override
  String get examHistoryDeleteConfirmTitle => 'Delete this simulation?';

  @override
  String get examHistoryDeleteConfirmBody =>
      'This action is permanent: the simulation and its answers will be deleted.';

  @override
  String get examResumeCardTitle => 'Resume the simulation';

  @override
  String get examResumeCardAction => 'Resume';

  @override
  String get examReportTitle => 'Simulation report';

  @override
  String get examReportNotFound => 'Report not found.';

  @override
  String get examReportError => 'Could not load the report.';

  @override
  String get examReportLoading => 'Loading the report…';

  @override
  String get examReportGlobalScoreLabel => 'Overall score';

  @override
  String get examReportSectionsTitle => 'Detail per activity';

  @override
  String get examReportReviewTitle => 'Question detail';

  @override
  String get overlayGridResetAction => 'Reset';

  @override
  String get overlayGridTargetLabel => 'Target grid';

  @override
  String get overlayGridWorkingLabel => 'Your grid';

  @override
  String get overlayGridTrayLabel => 'Pieces to drag';

  @override
  String get overlayGridSolutionCaption =>
      'Solution: where each piece belongs.';

  @override
  String get overlayGridExampleCaption =>
      'Drag the pieces onto the central grid to match the target.';

  @override
  String get wordBoxesEmptyBox => '—';

  @override
  String get wordBoxesMissedTitle => 'Misclassified words';

  @override
  String get cubeNetReferenceLabel => 'Reference net';

  @override
  String get cubeNetTargetLabel => 'Net to complete';

  @override
  String get cubeNetTrayLabel => 'Faces to place';

  @override
  String get cubeNetTapToRotateHint => 'Tap a face to rotate it.';

  @override
  String get cubeNetExplanationTitle => 'The reconstructed cube';

  @override
  String get airwaysExampleLegendTitle => 'One colored button per route';

  @override
  String get airwaysExampleBody =>
      'Aircraft appear on each route and move toward their zone. Tap a route\'s button to reroute its next aircraft to another zone — or let it fly on if no zone is at risk.';

  @override
  String get airwaysZoneCountSemanticsLabel =>
      'total aircraft over blue aircraft';

  @override
  String get airwaysViolationFlash => 'CRASH';

  @override
  String onboardingStepLabel(int current, int total) {
    return 'Step $current of $total';
  }

  @override
  String familyOpenSemantics(String name) {
    return '$name, open the activity sheet';
  }

  @override
  String lessonReadTime(int minutes) {
    return '$minutes min read';
  }

  @override
  String sessionResumeHint(int next, int total) {
    return 'Resuming at question $next of $total';
  }

  @override
  String readinessFamilies(int practised, int total) {
    return '$practised/$total families practised';
  }

  @override
  String readinessLessons(int read, int total) {
    return '$read/$total lessons read';
  }

  @override
  String familyLevel(int level) {
    return 'level $level of 5';
  }

  @override
  String weakAreaDetail(int accuracyPercent, int attempts) {
    return '$accuracyPercent% correct over $attempts answers';
  }

  @override
  String scorePercent(int percent) {
    return '$percent%';
  }

  @override
  String familyLessonsProgress(int read, int total) {
    return '$read/$total lessons';
  }

  @override
  String familyLessonsProgressSemantics(int read, int total) {
    return '$read lessons read out of $total';
  }

  @override
  String flashcardsDeckSummary(int due, int total) {
    return '$due to review · $total total';
  }

  @override
  String flashcardsProgress(int index, int total) {
    return 'Card $index of $total';
  }

  @override
  String familyTrendOpenSemantics(String name) {
    return 'View $name\'s trend';
  }

  @override
  String trendTooltipAccuracy(int correct, int attempts, int percent) {
    return 'Accuracy: $correct/$attempts ($percent%)';
  }

  @override
  String trendTooltipSpeed(String value) {
    return 'Time: $value';
  }

  @override
  String examAttempt(int number) {
    return 'Simulation $number';
  }

  @override
  String examScoreLine(int percent) {
    return 'Score: $percent%';
  }

  @override
  String examSectionsTitle(String date) {
    return 'Sections of $date';
  }

  @override
  String examSectionLabel(int number, String family) {
    return '$number. $family';
  }

  @override
  String examSectionValue(int correct, int attempts, int percent) {
    return '$correct/$attempts · $percent%';
  }

  @override
  String dominoSelectorSemantics(String half, int value) {
    return '$half: $value';
  }

  @override
  String dominoAnswerSummary(int top, int bottom) {
    return 'Answer: $top | $bottom';
  }

  @override
  String nbackYesSemantics(String shortcut) {
    return 'Yes ($shortcut)';
  }

  @override
  String nbackNoSemantics(String shortcut) {
    return 'No ($shortcut)';
  }

  @override
  String nbackStimulusSemantics(int index) {
    return 'Stimulus $index';
  }

  @override
  String arithmeticGridCellSemantics(int index, String label) {
    return 'Equality $index, $label';
  }

  @override
  String arithmeticGridCorrectValue(int value) {
    return 'Correct: $value';
  }

  @override
  String trainFamilyComingSoonHint(String name) {
    return '$name is coming soon.';
  }

  @override
  String trainFamilyOpenSemantics(String name) {
    return 'Practice: $name';
  }

  @override
  String trainQuick5Semantics(String name) {
    return 'Quick start: 5 questions on $name';
  }

  @override
  String practiceItemCountOption(int count) {
    return '$count';
  }

  @override
  String practiceDifficultyLevel(int level) {
    return 'Level $level';
  }

  @override
  String practiceRetryMistakesAction(int count) {
    return 'Retry my mistakes ($count)';
  }

  @override
  String trainSessionSummaryFamily(String name) {
    return 'Family: $name';
  }

  @override
  String trainSessionSummaryItemCount(int count) {
    return 'Questions: $count';
  }

  @override
  String attentionParityNumberSemantics(int value) {
    return 'Number $value';
  }

  @override
  String sessionResumeCardSubtitle(String familyName) {
    return 'Session in progress: $familyName';
  }

  @override
  String summaryScoreFraction(int correct, int played) {
    return '$correct/$played';
  }

  @override
  String summaryBestItemLabel(int index) {
    return 'Best answer: question $index';
  }

  @override
  String summaryWorstItemLabel(int index) {
    return 'To rework: question $index';
  }

  @override
  String summaryItemLabel(int index) {
    return 'Question $index';
  }

  @override
  String summaryItemCorrectSemantics(int index) {
    return 'Question $index, correct';
  }

  @override
  String summaryItemWrongSemantics(int index) {
    return 'Question $index, incorrect';
  }

  @override
  String tubesSolutionMoveLabel(String from, String to) {
    return 'Ball from tube $from to tube $to';
  }

  @override
  String viewpointPositionSemantics(int azimuth) {
    return 'Viewpoint $azimuth';
  }

  @override
  String examBlueprintMeta(int minutes, int available, int total) {
    return '≈ $minutes min · $available/$total activities available';
  }

  @override
  String examRunnerSectionProgress(int current, int total) {
    return 'Section $current/$total';
  }

  @override
  String examResumeCardSubtitle(String blueprintName) {
    return 'Simulation in progress: $blueprintName';
  }

  @override
  String examReportEstimatedPass(int thresholdPercent) {
    return 'Estimate: pass (estimated threshold $thresholdPercent%)';
  }

  @override
  String examReportEstimatedFail(int thresholdPercent) {
    return 'Estimate: fail (estimated threshold $thresholdPercent%)';
  }

  @override
  String examReportSectionFraction(int correct, int attempts, int unanswered) {
    return '$correct/$attempts correct · $unanswered unanswered';
  }

  @override
  String overlayGridTileSemantics(int number) {
    return 'Piece $number';
  }

  @override
  String wordBoxesBoxSemantics(int boxNumber, String label) {
    return 'Box $boxNumber: $label';
  }

  @override
  String wordBoxesMissedWord(String word, String fieldName) {
    return '$word → $fieldName';
  }

  @override
  String cubeNetSlotEmptySemantics(int index) {
    return 'Slot $index, empty';
  }

  @override
  String cubeNetSlotFilledSemantics(int index, String value) {
    return 'Slot $index, face $value';
  }

  @override
  String cubeNetTileSemantics(String value, int rotation) {
    return 'Face $value, rotation $rotation degrees';
  }

  @override
  String cubeNetCorrectFaces(int correct, int total) {
    return '$correct/$total faces correctly placed';
  }

  @override
  String airwaysExampleCapacity(int capacity, int blueCapacity) {
    return 'Keep at most $capacity aircraft -- and at most $blueCapacity blue aircraft -- in each gray zone.';
  }

  @override
  String airwaysExampleButtonLabel(int number) {
    return 'Route $number';
  }

  @override
  String airwaysZoneCount(int total, int blue) {
    return '$total/$blue';
  }

  @override
  String airwaysReroutesCounter(int count) {
    return 'Reroutes: $count';
  }

  @override
  String airwaysViolationsCounter(int count) {
    return 'Violations: $count';
  }

  @override
  String airwaysRouteButtonSemantics(int number) {
    return 'Reroute route $number';
  }

  @override
  String airwaysSummaryWithViolations(int violations, int reroutes) {
    return '$violations violation(s), $reroutes reroute(s).';
  }

  @override
  String masteryPercent(int percent) {
    return '$percent%';
  }

  @override
  String get examRunnerBreakContinue => 'Continue';

  @override
  String get shapeSquare => 'square';

  @override
  String get shapeTriangle => 'triangle';

  @override
  String get shapeCircle => 'circle';

  @override
  String get shapeDiamond => 'diamond';

  @override
  String get shapeStar => 'star';

  @override
  String get colourBlue => 'blue';

  @override
  String get colourOrange => 'orange';

  @override
  String get colourGreen => 'green';

  @override
  String get colourPink => 'pink';

  @override
  String get colourRed => 'red';

  @override
  String get colourYellow => 'yellow';

  @override
  String attentionRulesExampleFilled(
    String shapeA,
    String keyA,
    String shapeB,
    String keyB,
  ) {
    return 'Filled shape: $shapeA → $keyA, $shapeB → $keyB';
  }

  @override
  String attentionRulesExampleEmpty(
    String colourA,
    String keyA,
    String colourB,
    String keyB,
  ) {
    return 'Empty shape: $colourA → $keyA, $colourB → $keyB';
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
    return '~$duration per item';
  }

  @override
  String flashcardsSummaryAgain(int count) {
    return '$count to redo';
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
      zero: 'No simulation',
    );
    return '$_temp0';
  }

  @override
  String examDaysLeft(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'D-$days',
      one: 'D-1',
      zero: 'D-day',
    );
    return '$_temp0';
  }

  @override
  String examDaysLeftLong(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Exam in $days days',
      one: 'Exam in 1 day',
      zero: 'The exam is today',
    );
    return '$_temp0';
  }

  @override
  String flashcardsHomeCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards to review',
      one: '1 card to review',
      zero: 'No card to review',
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
      other: '$count restarts',
      one: '1 restart',
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
      other: 'Step $step / $total',
      zero: 'Starting configuration',
    );
    return '$_temp0';
  }

  @override
  String wordBoxesErrorCount(int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errors',
      one: '$errors error',
      zero: 'No errors',
    );
    return '$_temp0';
  }

  @override
  String wordBoxesResultSummary(int errors, int wordCount) {
    String _temp0 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errors out of $wordCount words',
      one: '$errors error out of $wordCount words',
      zero: 'Perfect run, no errors ($wordCount words)',
    );
    return '$_temp0';
  }

  @override
  String airwaysSummaryClean(int reroutes) {
    String _temp0 = intl.Intl.pluralLogic(
      reroutes,
      locale: localeName,
      other: 'No violation, $reroutes reroute(s).',
      zero: 'No violation, no reroutes.',
    );
    return '$_temp0';
  }

  @override
  String examChartSummary(int n, int toPercent, int fromPercent) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'from $fromPercent% to $toPercent% over $n simulations',
      one: '$toPercent% over 1 simulation',
    );
    return '$_temp0';
  }

  @override
  String trendAccuracySummary(int n, int toPercent, int fromPercent) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'from $fromPercent% to $toPercent% over $n sessions',
      one: '$toPercent% over 1 session',
    );
    return '$_temp0';
  }

  @override
  String trendSpeedSummary(int n, String toSec, String fromSec) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'from $fromSec to $toSec over $n sessions',
      one: '$toSec over 1 session',
    );
    return '$_temp0';
  }

  @override
  String flashcardsSummaryGood(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count easy',
      one: '$count easy',
    );
    return '$_temp0';
  }

  @override
  String flashcardsSummaryHard(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hard',
      one: '$count hard',
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
  String get settingsSectionAppearance => 'Appearance';

  @override
  String get settingsThemeLabel => 'Theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsLanguageLabel => 'Language';

  @override
  String get settingsLanguageSystem => 'System';

  @override
  String get settingsLanguageFr => 'French';

  @override
  String get settingsLanguageEn => 'English';

  @override
  String get settingsSoundLabel => 'Sound';

  @override
  String get settingsSoundOn => 'On';

  @override
  String get settingsSoundOff => 'Off';

  @override
  String get settingsKeypadLabel => 'Numeric keypad layout';

  @override
  String get settingsKeypadPhone => 'Phone';

  @override
  String get settingsKeypadCalculator => 'Calculator';

  @override
  String get settingsSectionReminders => 'Reminders';

  @override
  String get settingsReminderLabel => 'Daily reminder';

  @override
  String get settingsReminderOn => 'Reminder on';

  @override
  String get settingsReminderOff => 'Reminder off';

  @override
  String get settingsReminderTimeLabel => 'Reminder time';

  @override
  String get settingsReminderHour => 'Hour';

  @override
  String get settingsReminderMinute => 'Minute';

  @override
  String get settingsReminderUnsupported =>
      'Reminders are not available on this device; they work on phone (Android/iOS).';

  @override
  String get settingsReminderPermissionDenied =>
      'Notifications denied: enable them in your system settings to receive the reminder.';

  @override
  String get reminderNotificationTitle => 'PSY Trainer';

  @override
  String reminderFlashcardsDue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count flashcards to review',
      one: '1 flashcard to review',
    );
    return '$_temp0';
  }

  @override
  String reminderWeakestFamily(String family) {
    return 'Weak spot: $family';
  }

  @override
  String get reminderExamToday => 'The exam is today';

  @override
  String reminderExamCountdown(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Exam in $days days',
      one: 'Exam in 1 day',
    );
    return '$_temp0';
  }

  @override
  String get reminderFallback => 'A little practice today?';

  @override
  String get settingsSectionData => 'Data';

  @override
  String get settingsResetAction => 'Reset all data';

  @override
  String get settingsResetConfirm1Title => 'Reset all data?';

  @override
  String get settingsResetConfirm1Body =>
      'Your progress, statistics and settings will be erased. This action cannot be undone.';

  @override
  String get settingsResetConfirm2Title => 'Really erase everything?';

  @override
  String get settingsResetConfirm2Body =>
      'Last confirmation: there is no way to recover this data.';

  @override
  String get settingsResetConfirmAction => 'Erase permanently';

  @override
  String get settingsResetCancelAction => 'Cancel';

  @override
  String get settingsSectionGoal => 'Daily goal';

  @override
  String get settingsGoalTargetLabel => 'Target';

  @override
  String get settingsGoalUnitLabel => 'Unit';

  @override
  String get settingsGoalUnitItems => 'Items';

  @override
  String get settingsGoalUnitMinutes => 'Minutes';

  @override
  String get settingsSectionBackup => 'Backup';

  @override
  String get backupExportAction => 'Export my data';

  @override
  String get backupExportHint =>
      'Generates a JSON file with your sessions, stats and settings, to share or keep.';

  @override
  String get backupExportSuccess => 'Backup shared.';

  @override
  String get backupExportCancelled => 'Share cancelled.';

  @override
  String get backupExportError => 'Export failed.';

  @override
  String get backupImportTitle => 'Import a backup';

  @override
  String get backupImportHint =>
      'Paste the content of a backup JSON file here.';

  @override
  String get backupImportAction => 'Import';

  @override
  String get backupImportEmpty => 'Paste a backup\'s content first.';

  @override
  String backupImportSuccess(int inserted, int updated, int skipped) {
    return '$inserted inserted, $updated updated, $skipped skipped.';
  }

  @override
  String get backupErrorInvalidJson => 'The text is not valid JSON.';

  @override
  String get backupErrorNotAnObject => 'The document must be a JSON object.';

  @override
  String get backupErrorWrongFormat => 'This file is not a PSY Trainer backup.';

  @override
  String get backupErrorUnsupportedVersion =>
      'This backup comes from a newer version of the app.';

  @override
  String get backupErrorMissingData =>
      'The backup is incomplete (missing \"data\" section).';

  @override
  String get backupErrorInvalidRow => 'The backup contains an invalid entry.';

  @override
  String get backupErrorGeneric => 'Invalid backup.';

  @override
  String get settingsAboutAction => 'About';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutVersionLabel => 'Version';

  @override
  String get aboutVersionUnknown => 'Unknown version';

  @override
  String get aboutSourcesTitle => 'Sources';

  @override
  String get aboutSourceAirFranceCorporate =>
      'Air France Corporate — Pilote de ligne';

  @override
  String get aboutSourceAirFranceRecruitment =>
      'Air France recruitment portal — Cadet Pilot offer';

  @override
  String get aboutSourceAirFranceNews =>
      'Air France Corporate — Cadets recruitment news';

  @override
  String get aboutStorageLabel => 'Storage';

  @override
  String get aboutStorageLocalFile => 'local file';

  @override
  String get aboutStorageOpfs => 'OPFS';

  @override
  String get aboutStorageIndexedDb => 'IndexedDB';

  @override
  String get aboutStorageMemory => 'memory (not persisted)';

  @override
  String get aboutStorageUnknown => '…';

  @override
  String get aboutStorageNotPersistentWarning =>
      'Your data will not be kept after this tab is closed (private browsing, or an unsupported browser).';

  @override
  String get multitaskTouchFallback =>
      'Non-representative touch controls: on the real day, use the keyboard.';

  @override
  String get multitaskExamKeyboardRequired =>
      'This activity requires a physical keyboard. No keyboard was detected: this test cannot be taken representatively on this device.';

  @override
  String get multitaskShapeButtonLabel => 'Space';

  @override
  String get multitaskCalcButtonLabel => 'F';

  @override
  String get multitaskExampleTracking =>
      'Keep the keyboard arrow in the direction the circle is moving.';

  @override
  String get multitaskExampleShape =>
      'Press Space when the shape in the circle matches the reference shape (top left).';

  @override
  String get multitaskExampleCalc =>
      'Press F when the boxed calculation, at the bottom, is wrong.';

  @override
  String get matrixMissingSemantics => 'Missing cell';

  @override
  String get matrixQuestionMark => '?';

  @override
  String matrixCandidateSemantics(int index) {
    return 'Answer $index';
  }

  @override
  String get matrixExampleCaption =>
      'Find the figure that completes the matrix.';

  @override
  String get matrixAxisRow => 'row';

  @override
  String get matrixAxisColumn => 'column';

  @override
  String get matrixAttributeOuterShape => 'shape';

  @override
  String get matrixAttributeInnerShape => 'inner shape';

  @override
  String get matrixAttributeCount => 'count';

  @override
  String get matrixAttributeRotation => 'rotation';

  @override
  String get matrixAttributeFill => 'fill';

  @override
  String get matrixAttributeSize => 'size';

  @override
  String get matrixAttributePosition => 'position';

  @override
  String get matrixRuleDistributionSuffix => 'in distribution (3 values)';

  @override
  String get matrixRuleAlternationSuffix => 'alternating';

  @override
  String get matrixRuleXorSuffix => '= combination of the first two';

  @override
  String matrixRuleStepPlain(int step) {
    return '+$step';
  }

  @override
  String matrixRuleStepDegrees(int degrees) {
    return '+$degrees°';
  }

  @override
  String get p1AnglesExampleCaption =>
      'Among the candidate values, tap the ones matching a drawn angle (A, B...), then Confirm.';

  @override
  String p1AnglesCandidateSemantics(int index, int value) {
    return 'Value $index, $value degrees';
  }

  @override
  String get mentalArithmeticAllIntervalsPrompt =>
      'Select every interval that contains the exact value.';

  @override
  String mentalArithmeticTrueValue(int value) {
    return 'Exact value: $value';
  }

  @override
  String mentalArithmeticIntervalSemantics(int index, String label) {
    return 'Interval $index, $label';
  }

  @override
  String get mentalArithmeticAllIntervalsExampleCaption =>
      'Work out the exact value, then tap every interval that contains it before Confirm.';

  @override
  String get p1CountersExampleCaption =>
      'Read each gauge (needle, scale or drum counter) then answer the question asked.';
}
