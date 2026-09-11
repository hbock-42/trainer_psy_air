// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_family.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TestFamily _$TestFamilyFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_TestFamily', json, ($checkedConvert) {
  final val = _TestFamily(
    id: $checkedConvert('id', (v) => v as String),
    moduleId: $checkedConvert(
      'moduleId',
      (v) => $enumDecode(_$ModuleIdEnumMap, v),
    ),
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
    engineType: $checkedConvert(
      'engineType',
      (v) => $enumDecode(_$EngineTypeEnumMap, v),
    ),
    answerFormat: $checkedConvert(
      'answerFormat',
      (v) => $enumDecode(_$AnswerFormatEnumMap, v),
    ),
    defaultDurationSec: $checkedConvert(
      'defaultDurationSec',
      (v) => (v as num).toInt(),
    ),
    defaultItemCount: $checkedConvert(
      'defaultItemCount',
      (v) => (v as num).toInt(),
    ),
    confidence: $checkedConvert(
      'confidence',
      (v) => $enumDecode(_$ConfidenceEnumMap, v),
    ),
    shortName: $checkedConvert(
      'shortName',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    lang: $checkedConvert(
      'lang',
      (v) => $enumDecodeNullable(_$ContentLangEnumMap, v) ?? ContentLang.fr,
    ),
    defaultPerItemTimeSec: $checkedConvert(
      'defaultPerItemTimeSec',
      (v) => (v as num?)?.toInt(),
    ),
    tags: $checkedConvert(
      'tags',
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

Map<String, dynamic> _$TestFamilyToJson(_TestFamily instance) =>
    <String, dynamic>{
      'id': instance.id,
      'moduleId': _$ModuleIdEnumMap[instance.moduleId]!,
      'version': instance.version,
      'order': instance.order,
      'name': instance.name.toJson(),
      'description': instance.description.toJson(),
      'engineType': _$EngineTypeEnumMap[instance.engineType]!,
      'answerFormat': _$AnswerFormatEnumMap[instance.answerFormat]!,
      'defaultDurationSec': instance.defaultDurationSec,
      'defaultItemCount': instance.defaultItemCount,
      'confidence': _$ConfidenceEnumMap[instance.confidence]!,
      'shortName': ?instance.shortName?.toJson(),
      'lang': _$ContentLangEnumMap[instance.lang]!,
      'defaultPerItemTimeSec': ?instance.defaultPerItemTimeSec,
      'tags': instance.tags,
      'status': _$ContentStatusEnumMap[instance.status]!,
      'meta': ?instance.meta?.toJson(),
    };

const _$ModuleIdEnumMap = {
  ModuleId.psy0: 'psy0',
  ModuleId.psy1: 'psy1',
  ModuleId.psy2: 'psy2',
};

const _$EngineTypeEnumMap = {
  EngineType.mcqBank: 'mcq_bank',
  EngineType.numericBank: 'numeric_bank',
  EngineType.mentalArithmetic: 'mental_arithmetic',
  EngineType.logicSeries: 'logic_series',
  EngineType.figureMatrix: 'figure_matrix',
  EngineType.spatialRotation: 'spatial_rotation',
  EngineType.cubeFolding: 'cube_folding',
  EngineType.memoryDigitSpan: 'memory_digit_span',
  EngineType.memoryPattern: 'memory_pattern',
  EngineType.memorySequence: 'memory_sequence',
  EngineType.attentionSymbols: 'attention_symbols',
  EngineType.attentionStream: 'attention_stream',
  EngineType.multitasking: 'multitasking',
  EngineType.instrumentReading: 'instrument_reading',
};

const _$AnswerFormatEnumMap = {
  AnswerFormat.mcq: 'mcq',
  AnswerFormat.numeric: 'numeric',
  AnswerFormat.sequence: 'sequence',
  AnswerFormat.grid: 'grid',
  AnswerFormat.tap: 'tap',
};

const _$ConfidenceEnumMap = {
  Confidence.confirmed: 'confirmed',
  Confidence.reported: 'reported',
  Confidence.assumed: 'assumed',
};

const _$ContentLangEnumMap = {ContentLang.fr: 'fr', ContentLang.en: 'en'};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};
