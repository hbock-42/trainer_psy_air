// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoiceAnswer _$ChoiceAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ChoiceAnswer', json, ($checkedConvert) {
      final val = ChoiceAnswer(
        $checkedConvert('index', (v) => (v as num).toInt()),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$ChoiceAnswerToJson(ChoiceAnswer instance) =>
    <String, dynamic>{'index': instance.index, 'kind': instance.$type};

NumericAnswer _$NumericAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('NumericAnswer', json, ($checkedConvert) {
      final val = NumericAnswer(
        $checkedConvert('value', (v) => v as num),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$NumericAnswerToJson(NumericAnswer instance) =>
    <String, dynamic>{'value': instance.value, 'kind': instance.$type};

MultiSelectAnswer _$MultiSelectAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('MultiSelectAnswer', json, ($checkedConvert) {
      final val = MultiSelectAnswer(
        $checkedConvert(
          'indices',
          (v) => (v as List<dynamic>).map((e) => (e as num).toInt()).toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$MultiSelectAnswerToJson(MultiSelectAnswer instance) =>
    <String, dynamic>{'indices': instance.indices, 'kind': instance.$type};

KeyAnswer _$KeyAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('KeyAnswer', json, ($checkedConvert) {
      final val = KeyAnswer(
        $checkedConvert('key', (v) => v as String),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$KeyAnswerToJson(KeyAnswer instance) => <String, dynamic>{
  'key': instance.key,
  'kind': instance.$type,
};

SequenceAnswer _$SequenceAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('SequenceAnswer', json, ($checkedConvert) {
      final val = SequenceAnswer(
        $checkedConvert(
          'values',
          (v) => (v as List<dynamic>).map((e) => e as String).toList(),
        ),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$SequenceAnswerToJson(SequenceAnswer instance) =>
    <String, dynamic>{'values': instance.values, 'kind': instance.$type};

SkipAnswer _$SkipAnswerFromJson(Map<String, dynamic> json) => $checkedCreate(
  'SkipAnswer',
  json,
  ($checkedConvert) {
    final val = SkipAnswer($type: $checkedConvert('kind', (v) => v as String?));
    return val;
  },
  fieldKeyMap: const {r'$type': 'kind'},
);

Map<String, dynamic> _$SkipAnswerToJson(SkipAnswer instance) =>
    <String, dynamic>{'kind': instance.$type};

TimeoutAnswer _$TimeoutAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('TimeoutAnswer', json, ($checkedConvert) {
      final val = TimeoutAnswer(
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$TimeoutAnswerToJson(TimeoutAnswer instance) =>
    <String, dynamic>{'kind': instance.$type};

RawAnswer _$RawAnswerFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RawAnswer', json, ($checkedConvert) {
      final val = RawAnswer(
        $checkedConvert('payload', (v) => v as Map<String, dynamic>),
        $type: $checkedConvert('kind', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {r'$type': 'kind'});

Map<String, dynamic> _$RawAnswerToJson(RawAnswer instance) => <String, dynamic>{
  'payload': instance.payload,
  'kind': instance.$type,
};
