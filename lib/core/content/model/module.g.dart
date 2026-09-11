// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'module.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Module _$ModuleFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Module', json, ($checkedConvert) {
      final val = _Module(
        id: $checkedConvert('id', (v) => $enumDecode(_$ModuleIdEnumMap, v)),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        order: $checkedConvert('order', (v) => (v as num).toInt()),
        name: $checkedConvert(
          'name',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        description: $checkedConvert(
          'description',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        familyIds: $checkedConvert(
          'familyIds',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        defaultBlueprintId: $checkedConvert(
          'defaultBlueprintId',
          (v) => v as String?,
        ),
        status: $checkedConvert(
          'status',
          (v) =>
              $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
              ContentStatus.published,
        ),
      );
      return val;
    });

Map<String, dynamic> _$ModuleToJson(_Module instance) => <String, dynamic>{
  'id': _$ModuleIdEnumMap[instance.id]!,
  'version': instance.version,
  'order': instance.order,
  'name': instance.name.toJson(),
  'description': instance.description.toJson(),
  'familyIds': instance.familyIds,
  'defaultBlueprintId': ?instance.defaultBlueprintId,
  'status': _$ContentStatusEnumMap[instance.status]!,
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
