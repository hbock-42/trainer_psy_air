import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/onboarding_flow.dart';
import 'package:psy_trainer/features/settings/presentation/edit_profile_screen.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/onboarding_fakes.dart';

Finder _pressable(String label) => find.byWidgetPredicate(
  (widget) => widget is AppPressable && widget.semanticsLabel == label,
);

void main() {
  late InMemoryProgressRepository repository;

  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    repository = fakeProgressRepository();
    final container = ProviderContainer(
      overrides: [progressRepositoryOverride(repository: repository)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const PsyTrainerApp(),
      ),
    );
    await tester.pumpAndSettle();
    container.read(appRouterProvider).go(AppRoutes.settings);
    await tester.pumpAndSettle();
    expect(find.byType(SettingsScreen), findsOneWidget);
    return container;
  }

  testWidgets('summarises the stored answers', (tester) async {
    await pumpSettings(tester);

    expect(
      find.textContaining(
        AppStrings.formatLongDate(completedAnswers.examDate!),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('PSY0'), findsOneWidget);
    expect(find.text(AppStrings.settingsEditProfile), findsOneWidget);
  });

  testWidgets('"edit my profile" replays the flow and saves the changes', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.tap(find.text(AppStrings.settingsEditProfile));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfileScreen), findsOneWidget);
    expect(find.byType(OnboardingFlow), findsOneWidget);
    expect(find.text(AppStrings.onboardingEditTitle), findsOneWidget);

    // Already accepted: continue straight to the date and clear it.
    await tester.tap(find.text(AppStrings.actionContinue));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.onboardingExamDateUnknown));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppStrings.actionSave));
    await tester.pumpAndSettle();

    expect(find.byType(EditProfileScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsOneWidget);
    final answers = OnboardingAnswers.fromProfile(repository.storedProfile);
    expect(answers?.examDate, isNull);
    expect(
      answers?.disclaimerAcceptedAt,
      completedAnswers.disclaimerAcceptedAt,
    );
    expect(
      find.textContaining(AppStrings.settingsProfileSummaryNoExamDate),
      findsOneWidget,
    );
  });

  testWidgets('back from the first step returns to Settings unchanged', (
    tester,
  ) async {
    await pumpSettings(tester);
    await tester.tap(find.text(AppStrings.settingsEditProfile));
    await tester.pumpAndSettle();

    await tester.tap(_pressable('Back'));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);
    expect(find.byType(EditProfileScreen), findsNothing);
    expect(
      OnboardingAnswers.fromProfile(repository.storedProfile),
      completedAnswers,
    );
  });
}
