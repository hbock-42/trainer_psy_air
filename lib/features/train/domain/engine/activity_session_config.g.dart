// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_session_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ActivitySessionConfig _$ActivitySessionConfigFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ActivitySessionConfig', json, ($checkedConvert) {
  final val = _ActivitySessionConfig(
    familyId: $checkedConvert('familyId', (v) => v as String),
    mode: $checkedConvert('mode', (v) => $enumDecode(_$SessionModeEnumMap, v)),
    source: $checkedConvert(
      'source',
      (v) => ItemSource.fromJson(v as Map<String, dynamic>),
    ),
    timing: $checkedConvert(
      'timing',
      (v) => v == null
          ? TimingPolicy.none
          : TimingPolicy.fromJson(v as Map<String, dynamic>),
    ),
    scoringPolicy: $checkedConvert(
      'scoringPolicy',
      (v) => v == null
          ? const ScoringPolicy()
          : ScoringPolicy.fromJson(v as Map<String, dynamic>),
    ),
    liveFeedback: $checkedConvert('liveFeedback', (v) => v as bool? ?? false),
    briefing: $checkedConvert(
      'briefing',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    title: $checkedConvert(
      'title',
      (v) =>
          v == null ? null : LocalizedText.fromJson(v as Map<String, dynamic>),
    ),
    blueprintId: $checkedConvert('blueprintId', (v) => v as String?),
    sectionIndex: $checkedConvert('sectionIndex', (v) => (v as num?)?.toInt()),
    sessionId: $checkedConvert('sessionId', (v) => v as String?),
    ownsSession: $checkedConvert('ownsSession', (v) => v as bool? ?? true),
    positionOffset: $checkedConvert(
      'positionOffset',
      (v) => (v as num?)?.toInt() ?? 0,
    ),
  );
  return val;
});

Map<String, dynamic> _$ActivitySessionConfigToJson(
  _ActivitySessionConfig instance,
) => <String, dynamic>{
  'familyId': instance.familyId,
  'mode': _$SessionModeEnumMap[instance.mode]!,
  'source': instance.source.toJson(),
  'timing': instance.timing.toJson(),
  'scoringPolicy': instance.scoringPolicy.toJson(),
  'liveFeedback': instance.liveFeedback,
  'briefing': ?instance.briefing?.toJson(),
  'title': ?instance.title?.toJson(),
  'blueprintId': ?instance.blueprintId,
  'sectionIndex': ?instance.sectionIndex,
  'sessionId': ?instance.sessionId,
  'ownsSession': instance.ownsSession,
  'positionOffset': instance.positionOffset,
};

const _$SessionModeEnumMap = {
  SessionMode.practice: 'practice',
  SessionMode.exam: 'exam',
};
