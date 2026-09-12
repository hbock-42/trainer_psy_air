// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_progress_dao.dart';

// ignore_for_file: type=lint
mixin _$LessonProgressDaoMixin on DatabaseAccessor<AppDatabase> {
  $LessonProgressTable get lessonProgress => attachedDatabase.lessonProgress;
  LessonProgressDaoManager get managers => LessonProgressDaoManager(this);
}

class LessonProgressDaoManager {
  final _$LessonProgressDaoMixin _db;
  LessonProgressDaoManager(this._db);
  $$LessonProgressTableTableManager get lessonProgress =>
      $$LessonProgressTableTableManager(
        _db.attachedDatabase,
        _db.lessonProgress,
      );
}
