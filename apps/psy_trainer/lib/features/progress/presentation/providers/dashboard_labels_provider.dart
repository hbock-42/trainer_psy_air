import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:psy_content/psy_content.dart';
import '../../../../core/repositories/repository_providers.dart';

/// Content the dashboard needs to label ids: families (in real-test order)
/// and blueprints, by id.
class DashboardLabels {
  const DashboardLabels({required this.families, required this.blueprints});

  static const DashboardLabels empty = DashboardLabels(
    families: {},
    blueprints: {},
  );

  final Map<String, TestFamily> families;
  final Map<String, ExamBlueprint> blueprints;

  /// Name of a family for the given [locale] (the short one when [short]);
  /// the id when unknown.
  String familyName(
    String familyId, {
    String locale = 'fr',
    bool short = true,
  }) {
    final family = families[familyId];
    if (family == null) return familyId;
    final text = short ? family.shortName ?? family.name : family.name;
    return text.resolve(locale);
  }

  /// Name of a blueprint for the given [locale]; the id when unknown.
  String blueprintName(String blueprintId, {String locale = 'fr'}) =>
      blueprints[blueprintId]?.name.resolve(locale) ?? blueprintId;
}

/// Families and blueprints of the content bundle, loaded once (content only
/// changes when the bundle is re-seeded, at start-up).
final FutureProvider<DashboardLabels> dashboardLabelsProvider =
    FutureProvider<DashboardLabels>((ref) async {
      final content = ref.watch(contentRepositoryProvider);
      final families = await content.families();
      final blueprints = await content.blueprints();
      return DashboardLabels(
        families: {for (final f in families) f.id: f},
        blueprints: {for (final b in blueprints) b.id: b},
      );
    });
