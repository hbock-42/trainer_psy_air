// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attempt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttemptOrigin _$AttemptOriginFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AttemptOrigin', json, ($checkedConvert) {
      final val = _AttemptOrigin(
        generatorId: $checkedConvert('generatorId', (v) => v as String),
        seed: $checkedConvert('seed', (v) => (v as num).toInt()),
        params: $checkedConvert(
          'params',
          (v) => v as Map<String, dynamic>? ?? const <String, Object?>{},
        ),
      );
      return val;
    });

Map<String, dynamic> _$AttemptOriginToJson(_AttemptOrigin instance) =>
    <String, dynamic>{
      'generatorId': instance.generatorId,
      'seed': instance.seed,
      'params': instance.params,
    };
