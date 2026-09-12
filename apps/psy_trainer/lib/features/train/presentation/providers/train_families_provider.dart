import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../home/presentation/providers/active_module_provider.dart';
import '../engine/engine_registry_provider.dart';

/// One PSY0 family on the Train home (US-050): the family itself plus
/// whether its engine is registered yet.
///
/// The 14 activity engines land independently (US-021..036, in parallel);
/// until a family's engine is merged into [engineRegistryProvider] it is
/// shown disabled ("Bientôt") so the launcher never opens on a family it
/// cannot run.
class TrainFamilyEntry {
  const TrainFamilyEntry({required this.family, required this.available});

  final TestFamily family;

  /// Whether `engineRegistryProvider` has an engine for [family].
  final bool available;
}

/// The active module's test families in real-test order (`TestFamily.order`),
/// each flagged with engine availability. Empty until the bundle is seeded
/// (US-013). Filtered by `activeModuleProvider` (US-101 module switch).
final FutureProvider<List<TrainFamilyEntry>> trainFamiliesProvider =
    FutureProvider<List<TrainFamilyEntry>>((ref) async {
      final families = await ref
          .watch(contentRepositoryProvider)
          .families(moduleId: ref.watch(activeModuleProvider).moduleId);
      final registry = ref.watch(engineRegistryProvider);
      return [
        for (final family in families)
          TrainFamilyEntry(
            family: family,
            available: registry.hasFamily(family.id),
          ),
      ];
    });
