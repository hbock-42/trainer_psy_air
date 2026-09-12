import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'generator.dart';

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

/// One activity of an [ExamBlueprint] (contract v2).
///
/// Timing is any combination of [sectionTimeSec] (hard limit),
/// [perItemTimeSec] (per-item limit) and [cadence] (fixed rhythm); the
/// parser rejects a section with none of the three.
@freezed
abstract class ExamSection with _$ExamSection {
  const factory ExamSection({
    required String id,
    required String familyId,
    required int itemCount,
    required ItemSelection itemSelection,
    required Confidence confidence,
    LocalizedText? title,
    LocalizedText? briefing,
    int? sectionTimeSec,
    int? perItemTimeSec,
    Cadence? cadence,
    @Default(ScoringPolicy()) ScoringPolicy scoringPolicy,
    @Default(false) bool liveFeedback,
    @Default(InputRequirement.touch) InputRequirement inputRequirement,
    @Default(0) int breakAfterSec,
    @Default(1.0) double weight,
  }) = _ExamSection;

  const ExamSection._();

  factory ExamSection.fromJson(Map<String, Object?> json) =>
      _$ExamSectionFromJson(json);

  /// Whether at least one timing policy is set.
  bool get hasTiming =>
      sectionTimeSec != null || perItemTimeSec != null || cadence != null;
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

  /// Generate `itemCount` items from `generatorId` with the typed `params`
  /// (see [GeneratorParams]; decoded params always belong to `generatorId`);
  /// one seed per item is derived from the session seed.
  @FreezedUnionValue('generated')
  const factory ItemSelection.generated({
    required GeneratorId generatorId,
    required DifficultyRange difficulty,
    @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)
    required GeneratorParams params,
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
