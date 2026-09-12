import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/core/theme/app_theme.dart';
import 'package:psy_trainer/features/onboarding/domain/onboarding_answers.dart';
import 'package:psy_trainer/features/onboarding/presentation/widgets/onboarding_flow.dart';
import 'package:psy_trainer/features/settings/presentation/edit_profile_screen.dart';
import 'package:psy_trainer/features/settings/presentation/settings_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../helpers/content_ready_fakes.dart';
import '../../../helpers/onboarding_fakes.dart';

Finder _pressable(String label) => find.byWidgetPredicate(
  (widget) => widget is AppPressable && widget.semanticsLabel == label,
);

final l10nFr = lookupAppLocalizations(const Locale('fr'));

void main() {
  late InMemoryProgressRepository repository;

  Future<ProviderContainer> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    repository = fakeProgressRepository();
    final container = ProviderContainer(
      overrides: [
        progressRepositoryOverride(repository: repository),
        contentReadyOverride(),
      ],
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
      find.textContaining(l10nFr.formatLongDate(completedAnswers.examDate!)),
      findsOneWidget,
    );
    expect(find.textContaining('PSY0'), findsOneWidget);
    expect(find.text(l10nFr.settingsEditProfile), findsOneWidget);
  });

  testWidgets('"edit my profile" replays the flow and saves the changes', (
    tester,
  ) async {
    await pumpSettings(tester);

    await tester.tap(find.text(l10nFr.settingsEditProfile));
    await tester.pumpAndSettle();
    expect(find.byType(EditProfileScreen), findsOneWidget);
    expect(find.byType(OnboardingFlow), findsOneWidget);
    expect(find.text(l10nFr.onboardingEditTitle), findsOneWidget);

    // Already accepted: continue straight to the date and clear it.
    await tester.tap(find.text(l10nFr.actionContinue));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10nFr.onboardingExamDateUnknown));
    await tester.pumpAndSettle();
    await tester.tap(find.text(l10nFr.actionSave));
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
      find.textContaining(l10nFr.settingsProfileSummaryNoExamDate),
      findsOneWidget,
    );
  });

  testWidgets('back from the first step returns to Settings unchanged', (
    tester,
  ) async {
    await pumpSettings(tester);
    await tester.tap(find.text(l10nFr.settingsEditProfile));
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

  testWidgets('switching the theme to dark updates AppThemeScope', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(
      AppTheme.of(tester.element(find.byType(SettingsScreen))).isDark,
      isFalse,
    );

    await tester.tap(find.text(l10nFr.settingsThemeDark));
    await tester.pumpAndSettle();

    expect(
      AppTheme.of(tester.element(find.byType(SettingsScreen))).isDark,
      isTrue,
    );
    expect(repository.storedProfile?.settings['themeMode'], 'dark');
  });

  testWidgets('switching the language to English changes a visible string', (
    tester,
  ) async {
    await pumpSettings(tester);
    expect(find.text(l10nFr.settingsSectionAppearance), findsOneWidget);

    await tester.tap(find.text(l10nFr.settingsLanguageEn));
    await tester.pumpAndSettle();

    final l10nEn = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l10nEn.settingsSectionAppearance), findsOneWidget);
    expect(find.text(l10nFr.settingsSectionAppearance), findsNothing);
    expect(repository.storedProfile?.locale, 'en');
  });

  testWidgets(
    'reset all data needs two confirmations, then re-runs onboarding',
    (tester) async {
      await pumpSettings(tester);
      await tester.scrollUntilVisible(
        find.byKey(SettingsScreen.resetActionKey),
        200,
        // The backup section's paste field (US-074) is an `EditableText`,
        // which owns its own inner `Scrollable`; disambiguate against the
        // screen's outer list.
        scrollable: find
            .descendant(
              of: find.byKey(SettingsScreen.scrollKey),
              matching: find.byType(Scrollable),
            )
            .first,
      );

      await tester.tap(find.byKey(SettingsScreen.resetActionKey));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.settingsResetConfirm1Title), findsOneWidget);

      // Cancelling the first step changes nothing.
      await tester.tap(find.byKey(SettingsScreen.resetCancelKey));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(repository.storedProfile, isNotNull);

      await tester.tap(find.byKey(SettingsScreen.resetActionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(SettingsScreen.resetConfirm1Key));
      await tester.pumpAndSettle();
      expect(find.text(l10nFr.settingsResetConfirm2Title), findsOneWidget);

      await tester.tap(find.byKey(SettingsScreen.resetConfirm2Key));
      await tester.pumpAndSettle();

      expect(repository.storedProfile, isNull);
      expect(repository.sessionsById, isEmpty);
      // The profile is gone: the router's redirect sends the app back to
      // onboarding (US-090's guard, unchanged by this story).
      expect(find.byType(SettingsScreen), findsNothing);
      expect(find.text(l10nFr.onboardingWelcomeHeadline), findsOneWidget);
    },
  );
}
