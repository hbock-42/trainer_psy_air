import 'dart:developer' as developer;

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psy_content/psy_content.dart';

// core/router/startup_gate.dart already reaches into a feature
// (onboarding) to compose the startup sequence; this file follows the same
// precedent for the active module (US-101) so lazy seeding (US-125) can
// seed *that* module first without every screen re-deriving it.
import '../../../features/home/domain/active_module.dart';
import '../../../features/home/presentation/providers/active_module_provider.dart';
import '../app_database_provider.dart';
import 'asset_reader.dart';
import 'content_seeder.dart';

/// Where the seeder reads the bundle from; tests override it with a
/// `FileAssetReader` (or a fake) instead of `rootBundle`.
final Provider<AssetReader> assetReaderProvider = Provider<AssetReader>(
  (ref) => const RootBundleAssetReader(),
);

final Provider<ContentSeeder> contentSeederProvider = Provider<ContentSeeder>(
  (ref) => ContentSeeder(
    database: ref.watch(appDatabaseProvider),
    assets: ref.watch(assetReaderProvider),
  ),
);

/// Resolves once the *active* module ([activeModuleProvider], US-101) is
/// seeded (US-125: lazy per-module seeding — the old behaviour of seeding
/// every module before the first frame is [ContentSeeder.seedIfNeeded],
/// still used by tests/tools that want the whole bundle in one call). The
/// startup gate (`core/router/startup_gate.dart`) shows a splash until this
/// resolves and an error screen with a retry
/// (`ref.invalidate(contentReadyProvider)`) on failure.
///
/// The other supported modules are never awaited here: once the active one
/// is seeded, every other one is queued through [moduleSeedProvider] on the
/// next frame (`SchedulerBinding.addPostFrameCallback`), so it runs well
/// after the router has shown its first screen — in practice finished
/// before a user gets around to switching modules. Screens themselves
/// (`trainFamiliesProvider`, `psy0FamiliesProvider`, `examBlueprintsProvider`)
/// read straight from `contentRepositoryProvider` and do **not** await
/// [moduleSeedProvider]: doing so would make every widget test that fakes
/// `contentRepositoryProvider` (in-memory) also need to fake the real
/// Drift-backed seeding stack. The gap this leaves — a module switch in the
/// first instant after launch, before the background pass reaches it,
/// briefly shows an empty family list instead of a loading state — is a
/// known, documented trade-off (see `docs/ARCHITECTURE.md` Platforms and
/// the story card, US-125).
///
/// Riverpod's automatic retry is disabled: a parse error is deterministic
/// (a corrupt bundle) and a database error needs the user to see it; the
/// retry button re-runs the seeder on demand instead.
///
/// Widget tests that pump the whole app with in-memory repositories override
/// it with `contentReadyOverride()` (`test/helpers/content_ready_fakes.dart`).
final FutureProvider<SeedResult> contentReadyProvider =
    FutureProvider<SeedResult>((ref) async {
      final active = ref.watch(activeModuleProvider).moduleId;
      final result = await ref.watch(contentSeederProvider).seedModule(active);
      developer.log('$result', name: 'psy_trainer.content');
      SchedulerBinding.instance.addPostFrameCallback((_) {
        for (final module in ActiveModule.supportedModules) {
          if (module == active) continue;
          ref.read(moduleSeedProvider(module));
        }
      });
      return result;
    }, retry: (retryCount, error) => null);

/// Seeds [module] on its own (US-125). Triggered in the background for
/// every module but the active one (see [contentReadyProvider]) and awaited
/// on a module switch (`ModuleSwitch`/`ActiveModuleController.setModule`)
/// so the destination screen can show a brief "Chargement du module…"
/// state instead of an empty one when the background pass hasn't reached it
/// yet. A no-op (`SeedResult.seeded == false`) when [module] already mirrors
/// the bundle's current `contentVersion`.
final moduleSeedProvider = FutureProvider.family<SeedResult, ModuleId>((
  ref,
  module,
) async {
  final result = await ref.watch(contentSeederProvider).seedModule(module);
  developer.log('$result', name: 'psy_trainer.content.${module.name}');
  return result;
});
