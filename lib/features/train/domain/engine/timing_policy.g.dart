// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timing_policy.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimingPolicy _$TimingPolicyFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_TimingPolicy', json, ($checkedConvert) {
      final val = _TimingPolicy(
        perItemMs: $checkedConvert('perItemMs', (v) => (v as num?)?.toInt()),
        sectionMs: $checkedConvert('sectionMs', (v) => (v as num?)?.toInt()),
        cadence: $checkedConvert(
          'cadence',
          (v) => v == null ? null : Cadence.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TimingPolicyToJson(_TimingPolicy instance) =>
    <String, dynamic>{
      'perItemMs': ?instance.perItemMs,
      'sectionMs': ?instance.sectionMs,
      'cadence': ?instance.cadence?.toJson(),
    };
