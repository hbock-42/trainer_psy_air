import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:psy_content/psy_content.dart';
import 'package:psy_trainer/core/repositories/repository_providers.dart';
import 'package:psy_trainer/features/home/presentation/providers/active_module_provider.dart';
import 'package:psy_trainer/features/train/presentation/launcher/practice_launcher_provider.dart';

import '../../../../helpers/onboarding_fakes.dart'
    show progressRepositoryOverride;
import '../../../../helpers/psy0_families.dart';

/// US-101: the practice launcher must reject a family that does not belong
/// to the currently active module, even reached by a direct route (deep
/// link, back-navigation after a module switch, stale bookmark...).
void main() {
  ProviderContainer build() => ProviderContainer.test(
    overrides: [
      contentRepositoryProvider.overrideWithValue(
        psy0AndPsy1ContentRepository(),
      ),
      progressRepositoryOverride(),
    ],
  );

  /// Reads `practiceLauncherProvider(familyId)` until it leaves `loading`
  /// (the notifier's `_load` future resolves on a microtask, not
  /// synchronously).
  Future<PracticeLauncherState> readSettled(
    ProviderContainer container,
    String familyId,
  ) async {
    // A plain `container.read` on an autoDispose family provider with no
    // listener can be disposed and recreated between polls, restarting
    // `_load` forever; keep one subscription alive for the poll.
    final sub = container.listen(
      practiceLauncherProvider(familyId),
      (prev, next) {},
    );
    addTearDown(sub.close);
    for (var i = 0; i < 50; i++) {
      final state = sub.read();
      if (state.status != PracticeLauncherStatus.loading) return state;
      await Future<void>.delayed(Duration.zero);
    }
    fail('practiceLauncherProvider($familyId) never left loading');
  }

  test('opens a family of the active module (PSY0 default)', () async {
    final container = build();
    addTearDown(container.dispose);

    final state = await readSettled(container, 'memory_nback');

    expect(state.status, PracticeLauncherStatus.ready);
    expect(state.family?.id, 'memory_nback');
  });

  test('rejects a PSY1 family while PSY0 is active (notFound)', () async {
    final container = build();
    addTearDown(container.dispose);

    final state = await readSettled(container, 'p1_raven_matrices');

    expect(state.status, PracticeLauncherStatus.notFound);
  });

  test('opens the PSY1 family once PSY1 is made active', () async {
    final container = build();
    addTearDown(container.dispose);
    await container.read(activeModuleProvider.notifier).whenHydrated();
    await container
        .read(activeModuleProvider.notifier)
        .setModule(ModuleId.psy1);

    final state = await readSettled(container, 'p1_raven_matrices');

    expect(state.status, PracticeLauncherStatus.ready);
    expect(state.family?.id, 'p1_raven_matrices');
  });
}
