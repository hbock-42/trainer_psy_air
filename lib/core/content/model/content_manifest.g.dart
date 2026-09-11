// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContentManifest _$ContentManifestFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ContentManifest', json, ($checkedConvert) {
  final val = _ContentManifest(
    schemaVersion: $checkedConvert('schemaVersion', (v) => (v as num).toInt()),
    contentVersion: $checkedConvert(
      'contentVersion',
      (v) => (v as num).toInt(),
    ),
    updatedAt: $checkedConvert(
      'updatedAt',
      (v) => const DateOnlyConverter().fromJson(v as String),
    ),
    modules: $checkedConvert(
      'modules',
      (v) => (v as List<dynamic>)
          .map((e) => $enumDecode(_$ModuleIdEnumMap, e))
          .toList(),
    ),
    changelog: $checkedConvert(
      'changelog',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ChangelogEntry.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ChangelogEntry>[],
    ),
  );
  return val;
});

Map<String, dynamic> _$ContentManifestToJson(_ContentManifest instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'contentVersion': instance.contentVersion,
      'updatedAt': const DateOnlyConverter().toJson(instance.updatedAt),
      'modules': instance.modules.map((e) => _$ModuleIdEnumMap[e]!).toList(),
      'changelog': instance.changelog.map((e) => e.toJson()).toList(),
    };

const _$ModuleIdEnumMap = {
  ModuleId.psy0: 'psy0',
  ModuleId.psy1: 'psy1',
  ModuleId.psy2: 'psy2',
};

_ChangelogEntry _$ChangelogEntryFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ChangelogEntry', json, ($checkedConvert) {
      final val = _ChangelogEntry(
        contentVersion: $checkedConvert(
          'contentVersion',
          (v) => (v as num).toInt(),
        ),
        date: $checkedConvert(
          'date',
          (v) => const DateOnlyConverter().fromJson(v as String),
        ),
        summary: $checkedConvert('summary', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$ChangelogEntryToJson(_ChangelogEntry instance) =>
    <String, dynamic>{
      'contentVersion': instance.contentVersion,
      'date': const DateOnlyConverter().toJson(instance.date),
      'summary': instance.summary,
    };
