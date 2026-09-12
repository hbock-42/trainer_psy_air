import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'lexical_field.freezed.dart';
part 'lexical_field.g.dart';

/// One JSON file under `assets/content/<module>/verbal_boxes/lexical_fields/`
/// (`lexical_fields.schema.json`, contract v2): the French lexical fields the
/// `word_boxes` generator draws from (Boîte à mots, US-030 / US-085).
@freezed
abstract class LexicalFieldBank with _$LexicalFieldBank {
  const factory LexicalFieldBank({
    required String familyId,
    required List<LexicalField> fields,
  }) = _LexicalFieldBank;

  factory LexicalFieldBank.fromJson(Map<String, Object?> json) =>
      _$LexicalFieldBankFromJson(json);
}

/// A semantic category and the words that belong to it.
@freezed
abstract class LexicalField with _$LexicalField {
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  const factory LexicalField({
    required String id,
    required int version,
    required String familyId,
    required LocalizedText name,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    required List<String> words,
    @Default(ContentLang.fr) ContentLang lang,

    /// Words that belong to this field but look like they belong to
    /// [LexicalTrap.trapFor] (near misses).
    @Default(<LexicalTrap>[]) List<LexicalTrap> traps,

    /// Fields that must never share a series with this one.
    @Default(<String>[]) List<String> incompatibleWith,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _LexicalField;

  factory LexicalField.fromJson(Map<String, Object?> json) =>
      _$LexicalFieldFromJson(json);
}

/// A near-miss word of a [LexicalField]: it belongs to the field that lists
/// it, but a hurried candidate would file it under [trapFor].
@freezed
abstract class LexicalTrap with _$LexicalTrap {
  const factory LexicalTrap({required String word, required String trapFor}) =
      _LexicalTrap;

  factory LexicalTrap.fromJson(Map<String, Object?> json) =>
      _$LexicalTrapFromJson(json);
}
