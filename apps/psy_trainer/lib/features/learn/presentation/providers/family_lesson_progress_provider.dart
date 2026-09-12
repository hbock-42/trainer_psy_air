import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../../../../core/repositories/repository_providers.dart';
import '../../../progress/presentation/providers/progress_version_provider.dart';
import 'family_lessons_provider.dart';

/// How many of one family's lessons have been read (US-044): the family
/// page's read/total ring and, while [familyMasteryProvider] is still null
/// (no stats yet), the learn-home card's mastery slot.
typedef LessonProgress = ({int read, int total});

final FutureProviderFamily<LessonProgress, String>
familyLessonProgressProvider = FutureProvider.family<LessonProgress, String>((
  ref,
  familyId,
) async {
  ref.watch(progressVersionProvider);
  final lessons = await ref.watch(familyLessonsProvider(familyId).future);
  if (lessons.isEmpty) return (read: 0, total: 0);
  final reads = await ref.read(progressRepositoryProvider).lessonsRead();
  final readIds = reads.map((r) => r.lessonId).toSet();
  final read = lessons.where((l) => readIds.contains(l.id)).length;
  return (read: read, total: lessons.length);
});
