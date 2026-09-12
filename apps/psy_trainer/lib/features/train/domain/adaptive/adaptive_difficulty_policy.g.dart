// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'adaptive_difficulty_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AdaptiveDifficultyPolicy _$AdaptiveDifficultyPolicyFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_AdaptiveDifficultyPolicy', json, ($checkedConvert) {
  final val = _AdaptiveDifficultyPolicy(
    correctStreakToLevelUp: $checkedConvert(
      'correctStreakToLevelUp',
      (v) => (v as num?)?.toInt() ?? 3,
    ),
    wrongStreakToLevelDown: $checkedConvert(
      'wrongStreakToLevelDown',
      (v) => (v as num?)?.toInt() ?? 2,
    ),
    minLevel: $checkedConvert('minLevel', (v) => (v as num?)?.toInt() ?? 1),
    maxLevel: $checkedConvert('maxLevel', (v) => (v as num?)?.toInt() ?? 5),
    fastFactorOfLimit: $checkedConvert(
      'fastFactorOfLimit',
      (v) => (v as num?)?.toDouble() ?? 0.6,
    ),
  );
  return val;
});

Map<String, dynamic> _$AdaptiveDifficultyPolicyToJson(
  _AdaptiveDifficultyPolicy instance,
) => <String, dynamic>{
  'correctStreakToLevelUp': instance.correctStreakToLevelUp,
  'wrongStreakToLevelDown': instance.wrongStreakToLevelDown,
  'minLevel': instance.minLevel,
  'maxLevel': instance.maxLevel,
  'fastFactorOfLimit': instance.fastFactorOfLimit,
};

_LevelChange _$LevelChangeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LevelChange', json, ($checkedConvert) {
      final val = _LevelChange(
        atItemIndex: $checkedConvert('atItemIndex', (v) => (v as num).toInt()),
        from: $checkedConvert('from', (v) => (v as num).toInt()),
        to: $checkedConvert('to', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$LevelChangeToJson(_LevelChange instance) =>
    <String, dynamic>{
      'atItemIndex': instance.atItemIndex,
      'from': instance.from,
      'to': instance.to,
    };
