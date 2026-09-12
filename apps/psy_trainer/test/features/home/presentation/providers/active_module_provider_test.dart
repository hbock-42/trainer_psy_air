import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repositories.dart';
import 'package:psy_trainer/features/home/domain/active_module.dart';
import 'package:psy_trainer/features/home/presentation/providers/active_module_provider.dart';

void main() {
  late InMemoryProgressRepository repo;
  late ProviderContainer container;

  ProviderContainer build() => ProviderContainer.test(
    overrides: [progressRepositoryProvider.overrideWithValue(repo)],
  );

  setUp(() {
    repo = InMemoryProgressRepository(clock: () => DateTime.utc(2026, 9, 13));
  });

  test('starts with defaults, then hydrates from the stored profile', () async {
    await repo.saveProfile(
      const UserProfile(
        locale: 'fr',
        targetStage: 'psy0',
        settings: {'module': 'psy1'},
      ),
    );

    container = build();
    expect(container.read(activeModuleProvider), ActiveModule.defaults);

    final hydrated = await container
        .read(activeModuleProvider.notifier)
        .whenHydrated();
    expect(hydrated.moduleId, ModuleId.psy1);
    expect(container.read(activeModuleProvider).moduleId, ModuleId.psy1);
  });

  test(
    'setModule updates state immediately and persists the override',
    () async {
      container = build();
      final controller = container.read(activeModuleProvider.notifier);
      await controller.whenHydrated();
      expect(container.read(activeModuleProvider).moduleId, ModuleId.psy0);

      await controller.setModule(ModuleId.psy1);

      expect(container.read(activeModuleProvider).moduleId, ModuleId.psy1);
      final saved = await repo.profile();
      expect(saved?.settings['module'], 'psy1');
    },
  );

  test('setModule is a no-op when already selected', () async {
    container = build();
    final controller = container.read(activeModuleProvider.notifier);
    await controller.whenHydrated();

    await controller.setModule(ModuleId.psy0);

    expect(await repo.profile(), isNull);
  });
}
