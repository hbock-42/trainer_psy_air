import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/l10n_extensions.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
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
      find.textContaining(
        l10nFr.formatLongDate(completedAnswers.examDate!),
      ),
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
}
