// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_blueprint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExamBlueprint _$ExamBlueprintFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ExamBlueprint', json, ($checkedConvert) {
      final val = _ExamBlueprint(
        id: $checkedConvert('id', (v) => v as String),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        moduleId: $checkedConvert(
          'moduleId',
          (v) => $enumDecode(_$ModuleIdEnumMap, v),
        ),
        name: $checkedConvert(
          'name',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        description: $checkedConvert(
          'description',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        confidence: $checkedConvert(
          'confidence',
          (v) => $enumDecode(_$ConfidenceEnumMap, v),
        ),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        sections: $checkedConvert(
          'sections',
          (v) => (v as List<dynamic>)
              .map((e) => ExamSection.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        briefingSec: $checkedConvert(
          'briefingSec',
          (v) => (v as num?)?.toInt() ?? 0,
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

Map<String, dynamic> _$ExamBlueprintToJson(_ExamBlueprint instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'moduleId': _$ModuleIdEnumMap[instance.moduleId]!,
      'name': instance.name.toJson(),
      'description': instance.description.toJson(),
      'confidence': _$ConfidenceEnumMap[instance.confidence]!,
      'tags': instance.tags,
      'sections': instance.sections.map((e) => e.toJson()).toList(),
      'briefingSec': instance.briefingSec,
      'status': _$ContentStatusEnumMap[instance.status]!,
      'meta': ?instance.meta?.toJson(),
    };

const _$ModuleIdEnumMap = {
  ModuleId.psy0: 'psy0',
  ModuleId.psy1: 'psy1',
  ModuleId.psy2: 'psy2',
};

const _$ConfidenceEnumMap = {
  Confidence.confirmed: 'confirmed',
  Confidence.reported: 'reported',
  Confidence.assumed: 'assumed',
};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};

_ExamSection _$ExamSectionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ExamSection', json, ($checkedConvert) {
  final val = _ExamSection(
    id: $checkedConvert('id', (v) => v as String),
    familyId: $checkedConvert('familyId', (v) => v as String),
    itemCount: $checkedConvert('itemCount', (v) => (v as num).toInt()),
    itemSelection: $checkedConvert(
      'itemSelection',
      (v) => ItemSelection.fromJson(v as Map<String, dynamic>),
    ),
    confidence: $checkedConvert(
      'confidence',
      (v) => $enumDecode(_$ConfidenceEnumMap, v),
    ),
    title: $checkedConvert(
      'title',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    briefing: $checkedConvert(
      'briefing',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    sectionTimeSec: $checkedConvert(
      'sectionTimeSec',
      (v) => (v as num?)?.toInt(),
    ),
    perItemTimeSec: $checkedConvert(
      'perItemTimeSec',
      (v) => (v as num?)?.toInt(),
    ),
    cadence: $checkedConvert(
      'cadence',
      (v) => v == null ? null : Cadence.fromJson(v as Map<String, dynamic>),
    ),
    scoringPolicy: $checkedConvert(
      'scoringPolicy',
      (v) => v == null
          ? const ScoringPolicy()
          : ScoringPolicy.fromJson(v as Map<String, dynamic>),
    ),
    liveFeedback: $checkedConvert('liveFeedback', (v) => v as bool? ?? false),
    inputRequirement: $checkedConvert(
      'inputRequirement',
      (v) =>
          $enumDecodeNullable(_$InputRequirementEnumMap, v) ??
          InputRequirement.touch,
    ),
    breakAfterSec: $checkedConvert(
      'breakAfterSec',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
    weight: $checkedConvert('weight', (v) => (v as num?)?.toDouble() ?? 1.0),
  );
  return val;
});

Map<String, dynamic> _$ExamSectionToJson(_ExamSection instance) =>
    <String, dynamic>{
      'id': instance.id,
      'familyId': instance.familyId,
      'itemCount': instance.itemCount,
      'itemSelection': instance.itemSelection.toJson(),
      'confidence': _$ConfidenceEnumMap[instance.confidence]!,
      'title': ?instance.title?.toJson(),
      'briefing': ?instance.briefing?.toJson(),
      'sectionTimeSec': ?instance.sectionTimeSec,
      'perItemTimeSec': ?instance.perItemTimeSec,
      'cadence': ?instance.cadence?.toJson(),
      'scoringPolicy': instance.scoringPolicy.toJson(),
      'liveFeedback': instance.liveFeedback,
      'inputRequirement': _$InputRequirementEnumMap[instance.inputRequirement]!,
      'breakAfterSec': instance.breakAfterSec,
      'weight': instance.weight,
    };

const _$InputRequirementEnumMap = {
  InputRequirement.touch: 'touch',
  InputRequirement.keyboard: 'keyboard',
};

BankSelection _$BankSelectionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BankSelection', json, ($checkedConvert) {
      final val = BankSelection(
        difficulty: $checkedConvert(
          'difficulty',
          (v) => v == null
              ? null
              : DifficultyRange.fromJson(v as Map<String, dynamic>),
        ),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        anyTags: $checkedConvert(
          'anyTags',
          (v) => (v as List<dynamic>?)?.map((e) => e as String).toList(),
        ),
        balanceByTagPrefix: $checkedConvert(
          'balanceByTagPrefix',
          (v) => v as String?,
        ),
        avoidRecentSessions: $checkedConvert(
          'avoidRecentSessions',
          (v) => (v as num?)?.toInt() ?? 3,
        ),
        $type: $checkedConvert('mode', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'mode'});

Map<String, dynamic> _$BankSelectionToJson(BankSelection instance) =>
    <String, dynamic>{
      'difficulty': ?instance.difficulty?.toJson(),
      'tags': ?instance.tags,
      'anyTags': ?instance.anyTags,
      'balanceByTagPrefix': ?instance.balanceByTagPrefix,
      'avoidRecentSessions': instance.avoidRecentSessions,
      'mode': instance.$type,
    };

GeneratedSelection _$GeneratedSelectionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GeneratedSelection', json, ($checkedConvert) {
      final val = GeneratedSelection(
        generatorId: $checkedConvert(
          'generatorId',
          (v) => $enumDecode(_$GeneratorIdEnumMap, v),
        ),
        difficulty: $checkedConvert(
          'difficulty',
          (v) => DifficultyRange.fromJson(v as Map<String, dynamic>),
        ),
        params: $checkedConvert(
          'params',
          (v) => GeneratorParams.fromJson(v as Map<String, dynamic>),
          readValue: readGeneratorParams,
        ),
        $type: $checkedConvert('mode', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'mode'});

Map<String, dynamic> _$GeneratedSelectionToJson(GeneratedSelection instance) =>
    <String, dynamic>{
      'generatorId': _$GeneratorIdEnumMap[instance.generatorId]!,
      'difficulty': instance.difficulty.toJson(),
      'params': generatorParamsToJson(instance.params),
      'mode': instance.$type,
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

_DifficultyRange _$DifficultyRangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_DifficultyRange', json, ($checkedConvert) {
      final val = _DifficultyRange(
        min: $checkedConvert('min', (v) => difficultyFromJson(v)),
        max: $checkedConvert('max', (v) => difficultyFromJson(v)),
      );
      return val;
    });

Map<String, dynamic> _$DifficultyRangeToJson(_DifficultyRange instance) =>
    <String, dynamic>{'min': instance.min, 'max': instance.max};
