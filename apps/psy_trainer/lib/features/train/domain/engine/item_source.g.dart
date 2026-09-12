// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankSource _$BankSourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('BankSource', json, ($checkedConvert) {
      final val = BankSource(
        $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$BankSourceToJson(BankSource instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'kind': instance.$type,
    };

GeneratorSource _$GeneratorSourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GeneratorSource', json, ($checkedConvert) {
      final val = GeneratorSource(
        generatorId: $checkedConvert(
          'generatorId',
          (v) => $enumDecode(_$GeneratorIdEnumMap, v),
        ),
        seed: $checkedConvert('seed', (v) => (v as num).toInt()),
        params: $checkedConvert(
          'params',
          (v) => GeneratorParams.fromJson(v as Map<String, dynamic>),
          readValue: readGeneratorParams,
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        difficulty: $checkedConvert(
          'difficulty',
          (v) => v == null
              ? const DifficultyRange(min: 3, max: 3)
              : DifficultyRange.fromJson(v as Map<String, dynamic>),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$GeneratorSourceToJson(GeneratorSource instance) =>
    <String, dynamic>{
      'generatorId': _$GeneratorIdEnumMap[instance.generatorId]!,
      'seed': instance.seed,
      'params': generatorParamsToJson(instance.params),
      'count': instance.count,
      'difficulty': instance.difficulty.toJson(),
      'kind': instance.$type,
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

ReplaySource _$ReplaySourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReplaySource', json, ($checkedConvert) {
      final val = ReplaySource(
        $checkedConvert(
          'origins',
          (v) => (v as List<dynamic>)
              .map((e) => AttemptOrigin.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ReplaySourceToJson(ReplaySource instance) =>
    <String, dynamic>{
      'origins': instance.origins.map((e) => e.toJson()).toList(),
      'kind': instance.$type,
    };
