import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'lesson.freezed.dart';
part 'lesson.g.dart';

/// A markdown lesson (`lesson.schema.json`). The body is either inline
/// ([body]) or a reference to sibling `.md` files ([file]); exactly one of the
/// two is set.
@freezed
abstract class Lesson with _$Lesson {
  @Assert('(body == null) != (file == null)', 'exactly one of body/file is set')
  @Assert(
    'difficulty == null || (difficulty >= minDifficulty && difficulty <= maxDifficulty)',
    'difficulty must be 1..5',
  )
  const factory Lesson({
    required String id,
    required int version,
    required ModuleId moduleId,
    required int order,
    required LocalizedText title,
    required List<String> tags,
    String? familyId,
    LocalizedText? summary,
    LocalizedText? body,
    LocalizedPath? file,
    int? estimatedReadMin,
    @JsonKey(fromJson: difficultyFromJsonNullable) Difficulty? difficulty,
    @Default(<String>[]) List<String> practiceTags,
    @Default(<String>[]) List<String> deckIds,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _Lesson;

  factory Lesson.fromJson(Map<String, Object?> json) => _$LessonFromJson(json);
}
