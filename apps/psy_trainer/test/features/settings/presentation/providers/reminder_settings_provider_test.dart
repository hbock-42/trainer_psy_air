import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/settings/domain/reminder_settings.dart';
import 'package:psy_trainer/features/settings/presentation/providers/reminder_settings_provider.dart';

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
    const stored = ReminderSettings(enabled: true, hour: 7, minute: 30);
    await repo.saveProfile(stored.applyTo(const UserProfile(locale: 'fr')));

    container = build();
    expect(container.read(reminderSettingsProvider), ReminderSettings.defaults);

    final hydrated = await container
        .read(reminderSettingsProvider.notifier)
        .whenHydrated();
    expect(hydrated, stored);
    expect(container.read(reminderSettingsProvider), stored);
  });

  test('setEnabled updates state immediately and persists', () async {
    container = build();
    final controller = container.read(reminderSettingsProvider.notifier);
    await controller.whenHydrated();

    await controller.setEnabled(enabled: true);

    expect(container.read(reminderSettingsProvider).enabled, isTrue);
    final saved = await repo.profile();
    expect(ReminderSettings.fromProfile(saved).enabled, isTrue);
  });

  test('setTime updates hour and minute and persists', () async {
    container = build();
    final controller = container.read(reminderSettingsProvider.notifier);
    await controller.whenHydrated();

    await controller.setTime(hour: 21, minute: 15);

    final settings = container.read(reminderSettingsProvider);
    expect(settings.hour, 21);
    expect(settings.minute, 15);
    final saved = await repo.profile();
    final savedSettings = ReminderSettings.fromProfile(saved);
    expect(savedSettings.hour, 21);
    expect(savedSettings.minute, 15);
  });

  test('setTime preserves whether the reminder is enabled', () async {
    container = build();
    final controller = container.read(reminderSettingsProvider.notifier);
    await controller.whenHydrated();

    await controller.setEnabled(enabled: true);
    await controller.setTime(hour: 6, minute: 0);

    expect(container.read(reminderSettingsProvider).enabled, isTrue);
  });
}
