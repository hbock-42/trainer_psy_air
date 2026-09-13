import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:psy_content/psy_content.dart';

import '../../../../core/repositories/repositories.dart';

/// Lessons of one PSY2 family (`interview` or `group_exercise`), ordered by
/// `order`. Used by the interview practice and group-exercise screens to
/// show the theme/CRM guidance above the practice flow.
final familyLessonsProvider = FutureProvider.family<List<Lesson>, String>(
  (ref, familyId) => ref
      .watch(contentRepositoryProvider)
      .lessons(moduleId: ModuleId.psy2, familyId: familyId),
);

/// Module-level PSY2 lessons (no `familyId`): today, the "how PSY2 works"
/// overview shown from the Learn home's "Comment se passe le PSY2" entry.
final psy2OverviewLessonsProvider = FutureProvider<List<Lesson>>((ref) async {
  final all = await ref
      .watch(contentRepositoryProvider)
      .lessons(moduleId: ModuleId.psy2);
  return all.where((l) => l.familyId == null).toList()
    ..sort((a, b) => a.order.compareTo(b.order));
});
