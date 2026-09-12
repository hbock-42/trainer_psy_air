// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lexical_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LexicalFieldBank _$LexicalFieldBankFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LexicalFieldBank', json, ($checkedConvert) {
      final val = _LexicalFieldBank(
        familyId: $checkedConvert('familyId', (v) => v as String),
        fields: $checkedConvert(
          'fields',
          (v) => (v as List<dynamic>)
              .map((e) => LexicalField.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LexicalFieldBankToJson(_LexicalFieldBank instance) =>
    <String, dynamic>{
      'familyId': instance.familyId,
      'fields': instance.fields.map((e) => e.toJson()).toList(),
    };

_LexicalField _$LexicalFieldFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LexicalField', json, ($checkedConvert) {
      final val = _LexicalField(
        id: $checkedConvert('id', (v) => v as String),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        familyId: $checkedConvert('familyId', (v) => v as String),
        name: $checkedConvert(
          'name',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        words: $checkedConvert(
          'words',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        lang: $checkedConvert(
          'lang',
          (v) => $enumDecodeNullable(_$ContentLangEnumMap, v) ?? ContentLang.fr,
        ),
        traps: $checkedConvert(
          'traps',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => LexicalTrap.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <LexicalTrap>[],
        ),
        incompatibleWith: $checkedConvert(
          'incompatibleWith',
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
          (v) => v == null
              ? null
              : ContentMeta.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LexicalFieldToJson(_LexicalField instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'familyId': instance.familyId,
      'name': instance.name.toJson(),
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'words': instance.words,
      'lang': _$ContentLangEnumMap[instance.lang]!,
      'traps': instance.traps.map((e) => e.toJson()).toList(),
      'incompatibleWith': instance.incompatibleWith,
      'status': _$ContentStatusEnumMap[instance.status]!,
      'meta': ?instance.meta?.toJson(),
    };

const _$ContentLangEnumMap = {ContentLang.fr: 'fr', ContentLang.en: 'en'};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};

_LexicalTrap _$LexicalTrapFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LexicalTrap', json, ($checkedConvert) {
      final val = _LexicalTrap(
        word: $checkedConvert('word', (v) => v as String),
        trapFor: $checkedConvert('trapFor', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$LexicalTrapToJson(_LexicalTrap instance) =>
    <String, dynamic>{'word': instance.word, 'trapFor': instance.trapFor};
