// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview_question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InterviewQuestionBank _$InterviewQuestionBankFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_InterviewQuestionBank', json, ($checkedConvert) {
  final val = _InterviewQuestionBank(
    familyId: $checkedConvert('familyId', (v) => v as String),
    questions: $checkedConvert(
      'questions',
      (v) => (v as List<dynamic>)
          .map((e) => InterviewQuestion.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  );
  return val;
});

Map<String, dynamic> _$InterviewQuestionBankToJson(
  _InterviewQuestionBank instance,
) => <String, dynamic>{
  'familyId': instance.familyId,
  'questions': instance.questions.map((e) => e.toJson()).toList(),
};

_InterviewQuestion _$InterviewQuestionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_InterviewQuestion', json, ($checkedConvert) {
      final val = _InterviewQuestion(
        id: $checkedConvert('id', (v) => v as String),
        version: $checkedConvert('version', (v) => (v as num).toInt()),
        familyId: $checkedConvert('familyId', (v) => v as String),
        theme: $checkedConvert(
          'theme',
          (v) => $enumDecode(_$InterviewThemeEnumMap, v),
        ),
        question: $checkedConvert(
          'question',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        guidance: $checkedConvert(
          'guidance',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        modelAnswerSkeleton: $checkedConvert(
          'modelAnswerSkeleton',
          (v) => LocalizedText.fromJson(v as Map<String, dynamic>),
        ),
        tags: $checkedConvert(
          'tags',
          (v) =>
              (v as List<dynamic>?)?.map((e) => e as String).toList() ??
              const <String>[],
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

Map<String, dynamic> _$InterviewQuestionToJson(_InterviewQuestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'version': instance.version,
      'familyId': instance.familyId,
      'theme': _$InterviewThemeEnumMap[instance.theme]!,
      'question': instance.question.toJson(),
      'guidance': instance.guidance.toJson(),
      'modelAnswerSkeleton': instance.modelAnswerSkeleton.toJson(),
      'tags': instance.tags,
      'status': _$ContentStatusEnumMap[instance.status]!,
      'meta': ?instance.meta?.toJson(),
    };

const _$InterviewThemeEnumMap = {
  InterviewTheme.motivation: 'motivation',
  InterviewTheme.background: 'background',
  InterviewTheme.crmTeamwork: 'crm_teamwork',
  InterviewTheme.stress: 'stress',
  InterviewTheme.selfAwareness: 'self_awareness',
  InterviewTheme.aviationKnowledge: 'aviation_knowledge',
  InterviewTheme.reflective: 'reflective',
};

const _$ContentStatusEnumMap = {
  ContentStatus.draft: 'draft',
  ContentStatus.published: 'published',
};
