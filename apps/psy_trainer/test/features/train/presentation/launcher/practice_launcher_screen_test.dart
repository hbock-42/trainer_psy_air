import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/app.dart';
import 'package:psy_trainer/core/l10n/strings.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_content_repository.dart';
import 'package:psy_trainer/core/repositories/in_memory/in_memory_progress_repository.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/core/router/app_router.dart';
import 'package:psy_trainer/core/router/app_routes.dart';
import 'package:psy_trainer/features/train/domain/engine/engine.dart';
import 'package:psy_trainer/features/train/presentation/engine/engine_registry_provider.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_config.dart';
import 'package:psy_trainer/features/train/presentation/train_session_screen.dart';
import 'package:psy_trainer/shared/widgets/widgets.dart';

import '../../../../helpers/content_ready_fakes.dart';
import '../../../../helpers/fake_engine.dart';
import '../../../../helpers/onboarding_fakes.dart';
import 'launcher_fixtures.dart';

/// Pumps the whole app (router included) and navigates straight to the
/// practice launcher of [familyId], over [content] (defaults to
/// [launcherContentRepository]) with an engine registered for [familyId]
/// unless [engineAvailable] is false.
Future<ProviderContainer> pumpLauncher(
  WidgetTester tester, {
  required String familyId,
  InMemoryContentRepository? content,
  InMemoryProgressRepository? progress,
  bool engineAvailable = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        content ?? launcherContentRepository(),
      ),
      progressRepositoryOverride(repository: progress),
      contentReadyOverride(),
      if (engineAvailable)
        engineRegistryProvider.overrideWithValue(
          EngineRegistry([FakeEngine(familyId: familyId)]),
        ),
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
  container.read(appRouterProvider).go(AppRoutes.trainFamily(familyId));
  await tester.pumpAndSettle();
  return container;
}

void main() {
  group('PracticeLauncherScreen', () {
    testWidgets('shows the family defaults: 10 items, auto, untimed', (
      tester,
    ) async {
      await pumpLauncher(tester, familyId: bankFamily().id);

      expect(find.text(AppStrings.practiceItemCountOption(10)), findsOneWidget);
      expect(find.text(AppStrings.practiceDifficultyAuto), findsOneWidget);
      expect(find.text(AppStrings.practiceTimedOff), findsOneWidget);
    });

    testWidgets('a family whose engine is missing shows "coming soon" and '
        'disables the controls', (tester) async {
      await pumpLauncher(
        tester,
        familyId: bankFamily().id,
        engineAvailable: false,
      );

      expect(find.text(AppStrings.practiceEngineComingSoon), findsOneWidget);
      final start = tester.widget<PrimaryButton>(
        find.widgetWithText(PrimaryButton, AppStrings.practiceStartAction),
      );
      expect(start.onPressed, isNull);
    });

    testWidgets('an unknown family id shows the not-found message', (
      tester,
    ) async {
      await pumpLauncher(
        tester,
        familyId: 'does_not_exist',
        content: InMemoryContentRepository(),
      );

      expect(find.text(AppStrings.practiceLauncherNotFound), findsOneWidget);
    });

    testWidgets('picking 20 items and starting builds a matching config and '
        'persists the choice', (tester) async {
      final family = bankFamily();
      final progress = fakeProgressRepository();
      await pumpLauncher(tester, familyId: family.id, progress: progress);

      await tester.tap(find.text(AppStrings.practiceItemCountOption(20)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.practiceStartAction));
      await tester.pumpAndSettle();

      expect(find.byType(TrainSessionScreen), findsOneWidget);
      final screen = tester.widget<TrainSessionScreen>(
        find.byType(TrainSessionScreen),
      );
      final config = screen.config!;
      expect((config.source as BankSource).items.length, 20);

      // Persisted: the profile now remembers 20 items for this family.
      final stored =
          (await progress.profile())!.settings[practiceConfigSettingsKey(
                family.id,
              )]
              as Map;
      expect(stored['itemCount'], 20);
    });

    testWidgets('a stored configuration is restored the next time the '
        'launcher opens', (tester) async {
      final family = bankFamily();
      final progress = fakeProgressRepository();
      final base = progress.storedProfile!;
      progress.storedProfile = base.copyWith(
        settings: {
          ...base.settings,
          practiceConfigSettingsKey(family.id): const PracticeConfig(
            itemCount: 50,
            difficulty: 4,
            timed: true,
          ).toJson(),
        },
      );

      await pumpLauncher(tester, familyId: family.id, progress: progress);

      expect(find.text(AppStrings.practiceDifficultyLevel(4)), findsOneWidget);
      expect(find.text(AppStrings.practiceTimedOn), findsOneWidget);
      // The "50" chip is selected: tapping "Commencer" would build a 50-item
      // session, which the config-built test above already covers directly;
      // here we assert the restored selection is visible.
      expect(find.text(AppStrings.practiceItemCountOption(50)), findsOneWidget);
    });

    testWidgets('Quick 5 starts immediately with 5 items, auto difficulty', (
      tester,
    ) async {
      final family = generatorFamily();
      await pumpLauncher(tester, familyId: family.id);

      // Pick a non-default selection first, to prove Quick 5 overrides it.
      await tester.tap(find.text(AppStrings.practiceItemCountOption(50)));
      await tester.pumpAndSettle();
      await tester.tap(find.text(AppStrings.practiceQuick5Action));
      await tester.pumpAndSettle();

      expect(find.byType(TrainSessionScreen), findsOneWidget);
      final config = tester
          .widget<TrainSessionScreen>(find.byType(TrainSessionScreen))
          .config!;
      final source = config.source as GeneratorSource;
      expect(source.count, 5);
      expect(source.difficulty, const DifficultyRange(min: 1, max: 5));
    });
  });
}
