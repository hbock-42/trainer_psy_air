import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'interview_question.freezed.dart';
part 'interview_question.g.dart';

/// One JSON file under `assets/content/psy2/<family>/questions/`
/// (`interview_questions.schema.json`, contract v2): the original PSY2
/// interview questions of one theme (`docs/content/psy2-spec.md` §4.1,
/// US-111). Never a leaked or copied real question — see the
/// `author-content` skill's legal note.
@freezed
abstract class InterviewQuestionBank with _$InterviewQuestionBank {
  const factory InterviewQuestionBank({
    required String familyId,
    required List<InterviewQuestion> questions,
  }) = _InterviewQuestionBank;

  factory InterviewQuestionBank.fromJson(Map<String, Object?> json) =>
      _$InterviewQuestionBankFromJson(json);
}

/// One of the seven reported PSY2 interview themes (spec §4.1).
enum InterviewTheme {
  @JsonValue('motivation')
  motivation,
  @JsonValue('background')
  background,
  @JsonValue('crm_teamwork')
  crmTeamwork,
  @JsonValue('stress')
  stress,
  @JsonValue('self_awareness')
  selfAwareness,
  @JsonValue('aviation_knowledge')
  aviationKnowledge,
  @JsonValue('reflective')
  reflective,
}

/// One original interview question: the prompt, theme-level evaluator
/// guidance (STAR-shaped, without mandating the acronym) and a structural
/// (never scripted) answer skeleton.
@freezed
abstract class InterviewQuestion with _$InterviewQuestion {
  const factory InterviewQuestion({
    required String id,
    required int version,
    required String familyId,
    required InterviewTheme theme,
    required LocalizedText question,

    /// What a strong answer covers; may be shared across every question of
    /// [theme] (the spec gives guidance per theme, not per question).
    required LocalizedText guidance,

    /// A structural skeleton (e.g. "situation -> action -> result -> what
    /// I'd repeat/change"), never a written-out answer.
    required LocalizedText modelAnswerSkeleton,
    @Default(<String>[]) List<String> tags,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _InterviewQuestion;

  factory InterviewQuestion.fromJson(Map<String, Object?> json) =>
      _$InterviewQuestionFromJson(json);
}
