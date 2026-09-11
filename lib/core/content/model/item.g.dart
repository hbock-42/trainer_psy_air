// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ItemBank _$ItemBankFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemBank', json, ($checkedConvert) {
      final val = _ItemBank(
        familyId: $checkedConvert('familyId', (v) => v as String),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        passages: $checkedConvert(
          'passages',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => Passage.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const <Passage>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$ItemBankToJson(_ItemBank instance) => <String, dynamic>{
  'familyId': instance.familyId,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'passages': instance.passages.map((e) => e.toJson()).toList(),
};

_Passage _$PassageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Passage', json, ($checkedConvert) {
      final val = _Passage(
        id: $checkedConvert('id', (v) => v as String),
        body: $checkedConvert(
          'body',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        title: $checkedConvert(
          'title',
          (v) => v == null
              ? null
              : LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        media: $checkedConvert(
          'media',
          (v) =>
              v == null ? null : MediaRef.fromJson(v as Map<String, dynamic>),
        ),
        lang: $checkedConvert(
          'lang',
          (v) => $enumDecodeNullable(_$ContentLangEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$PassageToJson(_Passage instance) => <String, dynamic>{
  'id': instance.id,
  'body': instance.body.toJson(),
  'title': ?instance.title?.toJson(),
  'media': ?instance.media?.toJson(),
  'lang': ?_$ContentLangEnumMap[instance.lang],
};

const _$ContentLangEnumMap = {ContentLang.fr: 'fr', ContentLang.en: 'en'};

_McqOption _$McqOptionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_McqOption', json, ($checkedConvert) {
      final val = _McqOption(
        text: $checkedConvert(
          'text',
          (v) => v == null
              ? null
              : LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        media: $checkedConvert(
          'media',
          (v) =>
              v == null ? null : MediaRef.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$McqOptionToJson(_McqOption instance) =>
    <String, dynamic>{
      'text': ?instance.text?.toJson(),
      'media': ?instance.media?.toJson(),
    };

_Tolerance _$ToleranceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Tolerance', json, ($checkedConvert) {
      final val = _Tolerance(
        mode: $checkedConvert(
          'mode',
          (v) => $enumDecode(_$ToleranceModeEnumMap, v),
        ),
        value: $checkedConvert('value', (v) => v as num),
      );
      return val;
    });

Map<String, dynamic> _$ToleranceToJson(_Tolerance instance) =>
    <String, dynamic>{
      'mode': _$ToleranceModeEnumMap[instance.mode]!,
      'value': instance.value,
    };

const _$ToleranceModeEnumMap = {
  ToleranceMode.absolute: 'absolute',
  ToleranceMode.relative: 'relative',
};

_ItemOrigin _$ItemOriginFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemOrigin', json, ($checkedConvert) {
      final val = _ItemOrigin(
        generatorId: $checkedConvert(
          'generatorId',
          (v) => $enumDecode(_$GeneratorIdEnumMap, v),
        ),
        seed: $checkedConvert('seed', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ItemOriginToJson(_ItemOrigin instance) =>
    <String, dynamic>{
      'generatorId': _$GeneratorIdEnumMap[instance.generatorId]!,
      'seed': instance.seed,
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

McqItem _$McqItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  'McqItem',
  json,
  ($checkedConvert) {
    final val = McqItem(
      id: $checkedConvert('id', (v) => v as String),
      version: $checkedConvert('version', (v) => (v as num).toInt()),
      familyId: $checkedConvert('familyId', (v) => v as String),
      difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      stem: $checkedConvert(
        'stem',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      options: $checkedConvert(
        'options',
        (v) => (v as List<dynamic>)
            .map((e) => McqOption.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      correctIndex: $checkedConvert('correctIndex', (v) => (v as num).toInt()),
      explanation: $checkedConvert(
        'explanation',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      lang: $checkedConvert(
        'lang',
        (v) => $enumDecodeNullable(_$ContentLangEnumMap, v),
      ),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
            ContentStatus.published,
      ),
      origin: $checkedConvert(
        'origin',
        (v) =>
            v == null ? null : ItemOrigin.fromJson(v as Map<String, dynamic>),
      ),
      meta: $checkedConvert(
        'meta',
        (v) =>
            v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
      ),
      media: $checkedConvert(
        'media',
        (v) => v == null ? null : MediaRef.fromJson(v as Map<String, dynamic>),
      ),
      passageId: $checkedConvert('passageId', (v) => v as String?),
      shuffleOptions: $checkedConvert(
        'shuffleOptions',
        (v) => v as bool? ?? true,
      ),
      allowSkip: $checkedConvert('allowSkip', (v) => v as bool? ?? false),
      validAsOf: $checkedConvert(
        'validAsOf',
        (v) => _$JsonConverterFromJson<String, DateTime>(
          v,
          const DateOnlyConverter().fromJson,
        ),
      ),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {r'$type': 'type'},
);

Map<String, dynamic> _$McqItemToJson(McqItem instance) => <String, dynamic>{
  'id': instance.id,
  'version': instance.version,
  'familyId': instance.familyId,
  'difficulty': instance.difficulty,
  'tags': instance.tags,
  'stem': instance.stem.toJson(),
  'options': instance.options.map((e) => e.toJson()).toList(),
  'correctIndex': instance.correctIndex,
  'explanation': instance.explanation.toJson(),
  'lang': ?_$ContentLangEnumMap[instance.lang],
  'status': _$ContentStatusEnumMap[instance.status]!,
  'origin': ?instance.origin?.toJson(),
  'meta': ?instance.meta?.toJson(),
  'media': ?instance.media?.toJson(),
  'passageId': ?instance.passageId,
  'shuffleOptions': instance.shuffleOptions,
  'allowSkip': instance.allowSkip,
  'validAsOf': ?_$JsonConverterToJson<String, DateTime>(
    instance.validAsOf,
    const DateOnlyConverter().toJson,
  ),
  'type': instance.$type,
};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

NumericItem _$NumericItemFromJson(Map<String, dynamic> json) => $checkedCreate(
  'NumericItem',
  json,
  ($checkedConvert) {
    final val = NumericItem(
      id: $checkedConvert('id', (v) => v as String),
      version: $checkedConvert('version', (v) => (v as num).toInt()),
      familyId: $checkedConvert('familyId', (v) => v as String),
      difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
      tags: $checkedConvert(
        'tags',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      stem: $checkedConvert(
        'stem',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      expected: $checkedConvert('expected', (v) => v as num),
      explanation: $checkedConvert(
        'explanation',
        (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
      ),
      lang: $checkedConvert(
        'lang',
        (v) => $enumDecodeNullable(_$ContentLangEnumMap, v),
      ),
      status: $checkedConvert(
        'status',
        (v) =>
            $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
            ContentStatus.published,
      ),
      origin: $checkedConvert(
        'origin',
        (v) =>
            v == null ? null : ItemOrigin.fromJson(v as Map<String, dynamic>),
      ),
      meta: $checkedConvert(
        'meta',
        (v) =>
            v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
      ),
      media: $checkedConvert(
        'media',
        (v) => v == null ? null : MediaRef.fromJson(v as Map<String, dynamic>),
      ),
      tolerance: $checkedConvert(
        'tolerance',
        (v) => v == null ? null : Tolerance.fromJson(v as Map<String, dynamic>),
      ),
      unit: $checkedConvert('unit', (v) => v as String?),
      inputFormat: $checkedConvert(
        'inputFormat',
        (v) =>
            $enumDecodeNullable(_$InputFormatEnumMap, v) ?? InputFormat.decimal,
      ),
      decimals: $checkedConvert('decimals', (v) => (v as num?)?.toInt() ?? 2),
      $type: $checkedConvert('type', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {r'$type': 'type'},
);

Map<String, dynamic> _$NumericItemToJson(NumericItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'familyId': instance.familyId,
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'stem': instance.stem.toJson(),
      'expected': instance.expected,
      'explanation': instance.explanation.toJson(),
      'lang': ?_$ContentLangEnumMap[instance.lang],
      'status': _$ContentStatusEnumMap[instance.status]!,
      'origin': ?instance.origin?.toJson(),
      'meta': ?instance.meta?.toJson(),
      'media': ?instance.media?.toJson(),
      'tolerance': ?instance.tolerance?.toJson(),
      'unit': ?instance.unit,
      'inputFormat': _$InputFormatEnumMap[instance.inputFormat]!,
      'decimals': instance.decimals,
      'type': instance.$type,
    };

const _$InputFormatEnumMap = {
  InputFormat.integer: 'integer',
  InputFormat.decimal: 'decimal',
  InputFormat.time: 'time',
};

SequenceItem _$SequenceItemFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('SequenceItem', json, ($checkedConvert) {
  final val = SequenceItem(
    id: $checkedConvert('id', (v) => v as String),
    version: $checkedConvert('version', (v) => (v as num).toInt()),
    familyId: $checkedConvert('familyId', (v) => v as String),
    difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
    tags: $checkedConvert(
      'tags',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    stimulusKind: $checkedConvert(
      'stimulusKind',
      (v) => $enumDecode(_$StimulusKindEnumMap, v),
    ),
    stimulus: $checkedConvert(
      'stimulus',
      (v) => (v as List<dynamic>).map((e) => e as String).toList(),
    ),
    recallMode: $checkedConvert(
      'recallMode',
      (v) => $enumDecode(_$RecallModeEnumMap, v),
    ),
    lang: $checkedConvert(
      'lang',
      (v) => $enumDecodeNullable(_$ContentLangEnumMap, v),
    ),
    status: $checkedConvert(
      'status',
      (v) =>
          $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
          ContentStatus.published,
    ),
    origin: $checkedConvert(
      'origin',
      (v) => v == null ? null : ItemOrigin.fromJson(v as Map<String, dynamic>),
    ),
    meta: $checkedConvert(
      'meta',
      (v) => v == null ? null : ContentMeta.fromJson(v as Map<String, dynamic>),
    ),
    instructions: $checkedConvert(
      'instructions',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    grid: $checkedConvert(
      'grid',
      (v) => v == null ? null : GridSize.fromJson(v as Map<String, dynamic>),
    ),
    presentationMs: $checkedConvert(
      'presentationMs',
      (v) => (v as num?)?.toInt() ?? 1000,
    ),
    gapMs: $checkedConvert('gapMs', (v) => (v as num?)?.toInt() ?? 250),
    explanation: $checkedConvert(
      'explanation',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    $type: $checkedConvert('type', (v) => v as String?),
  );
  return val;
}, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$SequenceItemToJson(SequenceItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'familyId': instance.familyId,
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'stimulusKind': _$StimulusKindEnumMap[instance.stimulusKind]!,
      'stimulus': instance.stimulus,
      'recallMode': _$RecallModeEnumMap[instance.recallMode]!,
      'lang': ?_$ContentLangEnumMap[instance.lang],
      'status': _$ContentStatusEnumMap[instance.status]!,
      'origin': ?instance.origin?.toJson(),
      'meta': ?instance.meta?.toJson(),
      'instructions': ?instance.instructions?.toJson(),
      'grid': ?instance.grid?.toJson(),
      'presentationMs': instance.presentationMs,
      'gapMs': instance.gapMs,
      'explanation': ?instance.explanation?.toJson(),
      'type': instance.$type,
    };

const _$StimulusKindEnumMap = {
  StimulusKind.digits: 'digits',
  StimulusKind.letters: 'letters',
  StimulusKind.symbols: 'symbols',
  StimulusKind.colors: 'colors',
  StimulusKind.gridCells: 'gridCells',
};

const _$RecallModeEnumMap = {
  RecallMode.forward: 'forward',
  RecallMode.backward: 'backward',
  RecallMode.anyOrder: 'anyOrder',
};

GeneratedItem _$GeneratedItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('GeneratedItem', json, ($checkedConvert) {
      final val = GeneratedItem(
        id: $checkedConvert('id', (v) => v as String),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        familyId: $checkedConvert('familyId', (v) => v as String),
        difficulty: $checkedConvert('difficulty', (v) => difficultyFromJson(v)),
        tags: $checkedConvert(
          'tags',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
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
        lang: $checkedConvert(
          'lang',
          (v) => $enumDecodeNullable(_$ContentLangEnumMap, v),
        ),
        status: $checkedConvert(
          'status',
          (v) =>
              $enumDecodeNullable(_$ContentStatusEnumMap, v) ??
              ContentStatus.published,
        ),
        origin: $checkedConvert(
          'origin',
          (v) =>
              v == null ? null : ItemOrigin.fromJson(v as Map<String, dynamic>),
        ),
        meta: $checkedConvert(
          'meta',
          (v) => v == null
              ? null
              : ContentMeta.fromJson(v as Map<String, dynamic>),
        ),
        $type: $checkedConvert('type', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'type'});

Map<String, dynamic> _$GeneratedItemToJson(GeneratedItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'familyId': instance.familyId,
      'difficulty': instance.difficulty,
      'tags': instance.tags,
      'generatorId': _$GeneratorIdEnumMap[instance.generatorId]!,
      'seed': instance.seed,
      'params': generatorParamsToJson(instance.params),
      'lang': ?_$ContentLangEnumMap[instance.lang],
      'status': _$ContentStatusEnumMap[instance.status]!,
      'origin': ?instance.origin?.toJson(),
      'meta': ?instance.meta?.toJson(),
      'type': instance.$type,
    };
