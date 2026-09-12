import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';
import '../../../home/presentation/providers/active_module_provider.dart';
import '../../../train/presentation/engine/engine_registry_provider.dart';

/// One blueprint on the Exam home (US-060/061): how many of its sections
/// can actually run right now.
class ExamBlueprintEntry {
  const ExamBlueprintEntry({
    required this.blueprint,
    required this.availableSections,
  });

  final ExamBlueprint blueprint;

  /// Count of sections whose family has a registered engine, in blueprint
  /// order.
  final List<bool> availableSections;

  int get totalSections => blueprint.sections.length;

  int get availableCount => availableSections.where((a) => a).length;

  bool get isFullyAvailable => availableCount == totalSections;

  bool get hasAnySection => availableCount > 0;

  /// Total duration of the available sections, in seconds (untimed
  /// sections and per-item-only timing are not counted towards it).
  int get estimatedDurationSec {
    var total = 0;
    for (var i = 0; i < blueprint.sections.length; i++) {
      if (!availableSections[i]) continue;
      total += blueprint.sections[i].sectionTimeSec ?? 0;
    }
    return total;
  }
}

/// The active module's exam blueprints (US-060), each flagged with which
/// sections can run with the engines registered so far. Filtered by
/// `activeModuleProvider` (US-101 module switch).
final FutureProvider<List<ExamBlueprintEntry>> examBlueprintsProvider =
    FutureProvider<List<ExamBlueprintEntry>>((ref) async {
      final blueprints = await ref
          .watch(contentRepositoryProvider)
          .blueprints(moduleId: ref.watch(activeModuleProvider).moduleId);
      final registry = ref.watch(engineRegistryProvider);
      return [
        for (final blueprint in blueprints)
          ExamBlueprintEntry(
            blueprint: blueprint,
            availableSections: [
              for (final section in blueprint.sections)
                registry.hasFamily(section.familyId),
            ],
          ),
      ];
    });
