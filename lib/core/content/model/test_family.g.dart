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
    generatorId: $checkedConvert(
      'generatorId',
      (v) => $enumDecodeNullable(_$GeneratorIdEnumMap, v),
    ),
    inputRequirement: $checkedConvert(
      'inputRequirement',
      (v) =>
          $enumDecodeNullable(_$InputRequirementEnumMap, v) ??
          InputRequirement.touch,
    ),
    liveFeedback: $checkedConvert('liveFeedback', (v) => v as bool? ?? false),
    lang: $checkedConvert(
      'lang',
      (v) => $enumDecodeNullable(_$ContentLangEnumMap, v) ?? ContentLang.fr,
    ),
    defaultPerItemTimeSec: $checkedConvert(
      'defaultPerItemTimeSec',
      (v) => (v as num?)?.toInt(),
    ),
    defaultCadence: $checkedConvert(
      'defaultCadence',
      (v) => v == null ? null : Cadence.fromJson(v as Map<String, dynamic>),
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
      'generatorId': ?_$GeneratorIdEnumMap[instance.generatorId],
      'inputRequirement': _$InputRequirementEnumMap[instance.inputRequirement]!,
      'liveFeedback': instance.liveFeedback,
      'lang': _$ContentLangEnumMap[instance.lang]!,
      'defaultPerItemTimeSec': ?instance.defaultPerItemTimeSec,
      'defaultCadence': ?instance.defaultCadence?.toJson(),
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
  EngineType.memoryNback: 'memory_nback',
  EngineType.planningTubes: 'planning_tubes',
  EngineType.attentionRules: 'attention_rules',
  EngineType.attentionParity: 'attention_parity',
  EngineType.spatialOverlay: 'spatial_overlay',
  EngineType.logicDominos: 'logic_dominos',
  EngineType.attentionAirways: 'attention_airways',
  EngineType.verbalBoxes: 'verbal_boxes',
  EngineType.arithmeticGrid: 'arithmetic_grid',
  EngineType.spatialViewpoint: 'spatial_viewpoint',
  EngineType.spatialCubes: 'spatial_cubes',
  EngineType.cultureAero: 'culture_aero',
  EngineType.multitaskPsychomotor: 'multitask_psychomotor',
  EngineType.englishReading: 'english_reading',
  EngineType.englishGrammar: 'english_grammar',
  EngineType.englishListening: 'english_listening',
  EngineType.englishSpeaking: 'english_speaking',
};

const _$AnswerFormatEnumMap = {
  AnswerFormat.mcq: 'mcq',
  AnswerFormat.numeric: 'numeric',
  AnswerFormat.sequence: 'sequence',
  AnswerFormat.grid: 'grid',
  AnswerFormat.tap: 'tap',
  AnswerFormat.keyPress: 'key_press',
  AnswerFormat.clickSequence: 'click_sequence',
  AnswerFormat.drag: 'drag',
  AnswerFormat.multiSelect: 'multi_select',
  AnswerFormat.simulation: 'simulation',
  AnswerFormat.recording: 'recording',
};

const _$ConfidenceEnumMap = {
  Confidence.confirmed: 'confirmed',
  Confidence.reported: 'reported',
  Confidence.assumed: 'assumed',
};

const _$GeneratorIdEnumMap = {
  GeneratorId.nback: 'nback',
  GeneratorId.tubes: 'tubes',
  GeneratorId.stimulusResponse: 'stimulus_response',
  GeneratorId.paritySequence: 'parity_sequence',
  GeneratorId.overlayGrid: 'overlay_grid',
  GeneratorId.dominos: 'dominos',
  GeneratorId.airways: 'airways',
  GeneratorId.wordBoxes: 'word_boxes',
  GeneratorId.arithmeticGrid: 'arithmetic_grid',
  GeneratorId.viewpoint: 'viewpoint',
  GeneratorId.cubeNet: 'cube_net',
  GeneratorId.multitask: 'multitask',
};

const _$InputRequirementEnumMap = {
  InputRequirement.touch: 'touch',
  InputRequirement.keyboard: 'keyboard',
};

const _$ContentLangEnumMap = {ContentLang.fr: 'fr', ContentLang.en: 'en'};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};
