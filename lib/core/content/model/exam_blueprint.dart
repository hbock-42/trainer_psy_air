import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'exam_blueprint.freezed.dart';
part 'exam_blueprint.g.dart';

/// Structure of a timed exam simulation: ordered sections, each bound to one
/// family. File: `assets/content/<module>/blueprints/<slug>.json`
/// (`blueprint.schema.json`).
@freezed
abstract class ExamBlueprint with _$ExamBlueprint {
  const factory ExamBlueprint({
    required String id,
    required int version,
    required ModuleId moduleId,
    required LocalizedText name,
    required LocalizedText description,
    required Confidence confidence,
    required List<String> tags,
    required List<ExamSection> sections,
    @Default(0) int briefingSec,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _ExamBlueprint;

  factory ExamBlueprint.fromJson(Map<String, Object?> json) =>
      _$ExamBlueprintFromJson(json);
}

/// One timed section of an [ExamBlueprint].
@freezed
abstract class ExamSection with _$ExamSection {
  const factory ExamSection({
    required String id,
    required String familyId,
    required int durationSec,
    required int itemCount,
    required ItemSelection itemSelection,
    required Confidence confidence,
    LocalizedText? title,
    LocalizedText? instructions,
    int? perItemTimeSec,
    @Default(0) int breakAfterSec,
    @Default(1.0) double weight,
  }) = _ExamSection;

  factory ExamSection.fromJson(Map<String, Object?> json) =>
      _$ExamSectionFromJson(json);
}

/// Where a section's items come from, discriminated by `mode` into `bank` |
/// `generated`.
@Freezed(unionKey: 'mode')
sealed class ItemSelection with _$ItemSelection {
  /// Sample `itemCount` published items of the family from the bank.
  @FreezedUnionValue('bank')
  const factory ItemSelection.bank({
    DifficultyRange? difficulty,
    List<String>? tags,
    List<String>? anyTags,
    String? balanceByTagPrefix,
    @Default(3) int avoidRecentSessions,
  }) = BankSelection;

  /// Generate `itemCount` items from `generatorId`.
  @FreezedUnionValue('generated')
  const factory ItemSelection.generated({
    required String generatorId,
    required DifficultyRange difficulty,
    @Default(<String, Object?>{}) Map<String, Object?> params,
  }) = GeneratedSelection;

  factory ItemSelection.fromJson(Map<String, Object?> json) =>
      _$ItemSelectionFromJson(json);
}

/// Inclusive difficulty range; `min == max` for a fixed level.
@freezed
abstract class DifficultyRange with _$DifficultyRange {
  @Assert('min <= max', 'min must not exceed max')
  const factory DifficultyRange({
    @JsonKey(fromJson: difficultyFromJson) required Difficulty min,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty max,
  }) = _DifficultyRange;

  factory DifficultyRange.fromJson(Map<String, Object?> json) =>
      _$DifficultyRangeFromJson(json);
}
