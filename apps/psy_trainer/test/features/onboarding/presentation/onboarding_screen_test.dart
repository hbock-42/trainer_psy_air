import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_shell.dart';
import 'package:psy_trainer/features/learn/presentation/learn_screen.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/domain/target_stage.dart';
import 'package:psy_trainer/features/onboarding/presentation/onboarding_screen.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/accept_toggle.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/exam_date_step.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/target_stage_step.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/onboarding_fakes.dart';

/// End to end on a fresh install: the router lands on onboarding, the flow
/// writes the profile through the repository and the app moves to Learn.
final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  Future<InMemoryProgressRepository> pumpFreshApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repository = fakeProgressRepository(completed: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressRepositoryOverride(repository: repository),
          contentReadyOverride(),
        ],
        child: const PsyTrainerApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(OnboardingScreen), findsOneWidget);
    return repository;
  }

  Future<void> accept(WidgetTester tester) async {
    await tester.ensureVisible(find.byType(AcceptToggle));
    await tester.tap(find.byType(AcceptToggle));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10nFr.actionContinue));
    await tester.pumpAndSettle();
    expect(find.byType(ExamDateStep), findsOneWidget);
  }

  testWidgets('completing the flow persists the profile and opens Learn', (
    tester,
  ) async {
    final repository = await pumpFreshApp(tester);
    await accept(tester);

    // Keep the suggested date.
    await tester.tap(find.text(l10nFr.actionContinue));
    await tester.pumpAndSettle();
    expect(find.byType(TargetStageStep), findsOneWidget);
    await tester.tap(find.text(l10nFr.actionFinish));
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsNothing);
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.byType(LearnScreen), findsOneWidget);

    final profile = repository.storedProfile;
    expect(OnboardingAnswers.isCompleted(profile), isTrue);
    expect(profile?.targetStage, TargetStage.psy0.key);
    expect(profile?.examDate?.weekday, DateTime.saturday);
    expect(profile?.examDate?.month, DateTime.september);
    expect(
      profile?.settings[OnboardingAnswers.settingsKeyDisclaimerAcceptedAt],
      isA<String>(),
    );
  });

  testWidgets('skipping persists the defaults with the disclaimer accepted', (
    tester,
  ) async {
    final repository = await pumpFreshApp(tester);
    await accept(tester);

    await tester.tap(find.text(l10nFr.actionSkip));
    await tester.pumpAndSettle();

    expect(find.byType(LearnScreen), findsOneWidget);
    final answers = OnboardingAnswers.fromProfile(repository.storedProfile);
    expect(answers, isNotNull);
    expect(answers?.examDate, isNull);
    expect(answers?.targetStage, TargetStage.defaultStage);
  });
}
