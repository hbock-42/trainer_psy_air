import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/progress_tables.dart';

part 'lesson_progress_dao.g.dart';

@DriftAccessor(tables: [LessonProgress])
class LessonProgressDao extends DatabaseAccessor<AppDatabase>
    with _$LessonProgressDaoMixin {
  LessonProgressDao(super.db);

  /// Records a read; a lesson already read keeps its first `readAt`.
  Future<void> markRead(LessonProgressCompanion progress) => into(
    lessonProgress,
  ).insert(progress, onConflict: DoNothing(target: [lessonProgress.lessonId]));

  Future<LessonProgressRow?> byLesson(String lessonId) => (select(
    lessonProgress,
  )..where((t) => t.lessonId.equals(lessonId))).getSingleOrNull();

  Future<List<LessonProgressRow>> all() => (select(
    lessonProgress,
  )..orderBy([(t) => OrderingTerm.asc(t.readAt)])).get();
}
