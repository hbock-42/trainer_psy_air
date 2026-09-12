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
  GeneratorId.p1MathWordProblems: 'p1_math_word_problems',
  GeneratorId.p1Tangram: 'p1_tangram',
  GeneratorId.p1AttentionSustained: 'p1_attention_sustained',
  GeneratorId.p1ReadingFr: 'p1_reading_fr',
  GeneratorId.p1Angles: 'p1_angles',
  GeneratorId.p1GeneralEfficiency: 'p1_general_efficiency',
  GeneratorId.p1Counters: 'p1_counters',
  GeneratorId.p1CubeNets: 'p1_cube_nets',
  GeneratorId.p1WmReverseSpan: 'p1_wm_reverse_span',
  GeneratorId.p1WmCalcBack: 'p1_wm_calc_back',
  GeneratorId.p1RavenMatrices: 'p1_raven_matrices',
  GeneratorId.p1MentalArithmetic: 'p1_mental_arithmetic',
  GeneratorId.p1Psychomotor: 'p1_psychomotor',
};

AdaptiveSource _$AdaptiveSourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdaptiveSource', json, ($checkedConvert) {
      final val = AdaptiveSource(
        generatorId: $checkedConvert(
          'generatorId',
          (v) => $enumDecode(_$GeneratorIdEnumMap, v),
        ),
        runSeed: $checkedConvert('runSeed', (v) => (v as num).toInt()),
        params: $checkedConvert(
          'params',
          (v) => GeneratorParams.fromJson(v as Map<String, dynamic>),
          readValue: readGeneratorParams,
        ),
        count: $checkedConvert('count', (v) => (v as num).toInt()),
        initialDifficulty: $checkedConvert(
          'initialDifficulty',
          (v) => (v as num).toInt(),
        ),
        fastThresholdMs: $checkedConvert(
          'fastThresholdMs',
          (v) => (v as num?)?.toInt(),
        ),
        policy: $checkedConvert(
          'policy',
          (v) => v == null
              ? AdaptiveDifficultyPolicy.standard
              : AdaptiveDifficultyPolicy.fromJson(v as Map<String, dynamic>),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$AdaptiveSourceToJson(AdaptiveSource instance) =>
    <String, dynamic>{
      'generatorId': _$GeneratorIdEnumMap[instance.generatorId]!,
      'runSeed': instance.runSeed,
      'params': generatorParamsToJson(instance.params),
      'count': instance.count,
      'initialDifficulty': instance.initialDifficulty,
      'fastThresholdMs': ?instance.fastThresholdMs,
      'policy': instance.policy.toJson(),
      'kind': instance.$type,
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
