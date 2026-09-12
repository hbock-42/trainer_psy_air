// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'common.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LocalizedText _$LocalizedTextFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LocalizedText', json, ($checkedConvert) {
      final val = _LocalizedText(
        fr: $checkedConvert('fr', (v) => v as String),
        en: $checkedConvert('en', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LocalizedTextToJson(_LocalizedText instance) =>
    <String, dynamic>{'fr': instance.fr, 'en': ?instance.en};

_LocalizedPath _$LocalizedPathFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LocalizedPath', json, ($checkedConvert) {
      final val = _LocalizedPath(
        fr: $checkedConvert('fr', (v) => v as String),
        en: $checkedConvert('en', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$LocalizedPathToJson(_LocalizedPath instance) =>
    <String, dynamic>{'fr': instance.fr, 'en': ?instance.en};

_MediaRef _$MediaRefFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MediaRef', json, ($checkedConvert) {
  final val = _MediaRef(
    kind: $checkedConvert('kind', (v) => $enumDecode(_$MediaKindEnumMap, v)),
    path: $checkedConvert('path', (v) => v as String),
    alt: $checkedConvert(
      'alt',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    width: $checkedConvert('width', (v) => (v as num?)?.toInt()),
    height: $checkedConvert('height', (v) => (v as num?)?.toInt()),
    durationMs: $checkedConvert('durationMs', (v) => (v as num?)?.toInt()),
  );
  return val;
});

Map<String, dynamic> _$MediaRefToJson(_MediaRef instance) => <String, dynamic>{
  'kind': _$MediaKindEnumMap[instance.kind]!,
  'path': instance.path,
  'alt': ?instance.alt?.toJson(),
  'width': ?instance.width,
  'height': ?instance.height,
  'durationMs': ?instance.durationMs,
};

const _$MediaKindEnumMap = {MediaKind.image: 'image', MediaKind.audio: 'audio'};

_ContentMeta _$ContentMetaFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ContentMeta', json, ($checkedConvert) {
      final val = _ContentMeta(
        author: $checkedConvert('author', (v) => v as String?),
        source: $checkedConvert('source', (v) => v as String?),
        sources: $checkedConvert(
          'sources',
          (v) => (v as List<dynamic>?)
              ?.map((e) => ContentSource.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        reviewedBy: $checkedConvert('reviewedBy', (v) => v as String?),
        reviewedAt: $checkedConvert(
          'reviewedAt',
          (v) => _$JsonConverterFromJson<String, DateTime>(
            v,
            const DateOnlyConverter().fromJson,
          ),
        ),
        notes: $checkedConvert('notes', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ContentMetaToJson(_ContentMeta instance) =>
    <String, dynamic>{
      'author': ?instance.author,
      'source': ?instance.source,
      'sources': ?instance.sources?.map((e) => e.toJson()).toList(),
      'reviewedBy': ?instance.reviewedBy,
      'reviewedAt': ?_$JsonConverterToJson<String, DateTime>(
        instance.reviewedAt,
        const DateOnlyConverter().toJson,
      ),
      'notes': ?instance.notes,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_ContentSource _$ContentSourceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ContentSource', json, ($checkedConvert) {
      final val = _ContentSource(
        title: $checkedConvert('title', (v) => v as String),
        url: $checkedConvert('url', (v) => v as String?),
        accessedOn: $checkedConvert(
          'accessedOn',
          (v) => _$JsonConverterFromJson<String, DateTime>(
            v,
            const DateOnlyConverter().fromJson,
          ),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ContentSourceToJson(_ContentSource instance) =>
    <String, dynamic>{
      'title': instance.title,
      'url': ?instance.url,
      'accessedOn': ?_$JsonConverterToJson<String, DateTime>(
        instance.accessedOn,
        const DateOnlyConverter().toJson,
      ),
    };

_GridSize _$GridSizeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_GridSize', json, ($checkedConvert) {
      final val = _GridSize(
        rows: $checkedConvert('rows', (v) => (v as num).toInt()),
        cols: $checkedConvert('cols', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$GridSizeToJson(_GridSize instance) => <String, dynamic>{
  'rows': instance.rows,
  'cols': instance.cols,
};

_Cadence _$CadenceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_Cadence', json, ($checkedConvert) {
      final val = _Cadence(
        stimulusMs: $checkedConvert('stimulusMs', (v) => (v as num).toInt()),
        answerWindowMs: $checkedConvert(
          'answerWindowMs',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$CadenceToJson(_Cadence instance) => <String, dynamic>{
  'stimulusMs': instance.stimulusMs,
  'answerWindowMs': instance.answerWindowMs,
};

_ScoringPolicy _$ScoringPolicyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ScoringPolicy', json, ($checkedConvert) {
      final val = _ScoringPolicy(
        correct: $checkedConvert('correct', (v) => v as num? ?? 1),
        wrong: $checkedConvert('wrong', (v) => v as num? ?? 0),
        skip: $checkedConvert('skip', (v) => v as num? ?? 0),
      );
      return val;
    });

Map<String, dynamic> _$ScoringPolicyToJson(_ScoringPolicy instance) =>
    <String, dynamic>{
      'correct': instance.correct,
      'wrong': instance.wrong,
      'skip': instance.skip,
    };
