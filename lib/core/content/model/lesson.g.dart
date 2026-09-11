// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Lesson _$LessonFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_Lesson', json, ($checkedConvert) {
  final val = _Lesson(
    id: $checkedConvert('id', (v) => v as String),
    version: $checkedConvert('version', (v) => (v as num).toInt()),
    moduleId: $checkedConvert(
      'moduleId',
      (v) => $enumDecode(_$ModuleIdEnumMap, v),
    ),
    order: $checkedConvert('order', (v) => (v as num).toInt()),
    title: $checkedConvert(
      'title',
      (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    familyId: $checkedConvert('familyId', (v) => v as String?),
    summary: $checkedConvert(
      'summary',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    body: $checkedConvert(
      'body',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    file: $checkedConvert(
      'file',
      (v) =>
          v == null ? null : LocalizedPath.fromJson(v as Map<String, dynamic>),
    ),
    estimatedReadMin: $checkedConvert(
      'estimatedReadMin',
      (v) => (v as num?)?.toInt(),
    ),
    difficulty: $checkedConvert(
      'difficulty',
      (v) => difficultyFromJsonNullable(v),
    ),
    practiceTags: $checkedConvert(
      'practiceTags',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    ),
    deckIds: $checkedConvert(
      'deckIds',
      (v) =>
          (v as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    ),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
          ContentStatus.published,
    ),
    meta: $checkedConvert(
      'meta',
      (v) => v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
    ),
  );
  return val;
});

Map<String, dynamic> _$LessonToJson(_Lesson instance) => <String, dynamic>{
  'id': instance.id,
  'version': instance.version,
  'moduleId': _$ModuleIdEnumMap[instance.moduleId]!,
  'order': instance.order,
  'title': instance.title.toJson(),
  'tags': instance.tags,
  'familyId': ?instance.familyId,
  'summary': ?instance.summary?.toJson(),
  'body': ?instance.body?.toJson(),
  'file': ?instance.file?.toJson(),
  'estimatedReadMin': ?instance.estimatedReadMin,
  'difficulty': ?instance.difficulty,
  'practiceTags': instance.practiceTags,
  'deckIds': instance.deckIds,
  'status': _$ContentStatusEnumMap[instance.status]!,
  'meta': ?instance.meta?.toJson(),
};

const _$ModuleIdEnumMap = {
  ModuleId.psy0: 'psy0',
  ModuleId.psy1: 'psy1',
  ModuleId.psy2: 'psy2',
};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};
