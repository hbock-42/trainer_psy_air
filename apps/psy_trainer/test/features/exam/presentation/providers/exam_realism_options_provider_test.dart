import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/exam/domain/exam_realism_options.dart';
import 'package:psy_trainer/features/exam/presentation/providers/exam_realism_options_provider.dart';

void main() {
  late InMemoryProgressRepository repo;
  late ProviderContainer container;

  ProviderContainer build() => ProviderContainer.test(
    overrides: [progressRepositoryProvider.overrideWithValue(repo)],
  );

  setUp(() {
    repo = InMemoryProgressRepository(clock: () => DateTime.utc(2026, 9, 12));
  });

  test('starts with defaults, then hydrates from the stored profile', () async {
    const stored = ExamRealismOptions(
      negativeMarkingCulture: true,
      allowPauseBetweenSections: false,
    );
    await repo.saveProfile(stored.applyTo(const UserProfile(locale: 'fr')));

    container = build();
    expect(
      container.read(examRealismOptionsProvider),
      ExamRealismOptions.defaults,
    );

    final hydrated = await container
        .read(examRealismOptionsProvider.notifier)
        .whenHydrated();
    expect(hydrated, stored);
    expect(container.read(examRealismOptionsProvider), stored);
  });

  test(
    'a setter updates state immediately and persists to the profile',
    () async {
      container = build();
      final controller = container.read(examRealismOptionsProvider.notifier);
      await controller.whenHydrated();

      await controller.setNegativeMarkingCulture(enabled: true);

      expect(
        container.read(examRealismOptionsProvider).negativeMarkingCulture,
        isTrue,
      );
      final saved = await repo.profile();
      expect(
        ExamRealismOptions.fromProfile(saved).negativeMarkingCulture,
        isTrue,
      );
    },
  );

  test(
    'applyRealConditionsPreset sets and persists every option at once',
    () async {
      container = build();
      final controller = container.read(examRealismOptionsProvider.notifier);
      await controller.whenHydrated();

      await controller.applyRealConditionsPreset();

      expect(
        container.read(examRealismOptionsProvider),
        ExamRealismOptions.realConditions,
      );
      final saved = await repo.profile();
      expect(
        ExamRealismOptions.fromProfile(saved),
        ExamRealismOptions.realConditions,
      );
    },
  );

  test('setters preserve every other option', () async {
    container = build();
    final controller = container.read(examRealismOptionsProvider.notifier);
    await controller.whenHydrated();

    await controller.setImmersiveFullScreen(enabled: true);
    await controller.setHideRemainingTime(enabled: true);

    final options = container.read(examRealismOptionsProvider);
    expect(options.immersiveFullScreen, isTrue);
    expect(options.hideRemainingTime, isTrue);
    expect(options.negativeMarkingCulture, isFalse);
    expect(options.allowPauseBetweenSections, isTrue);
  });
}
