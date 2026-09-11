import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'item.freezed.dart';
part 'item.g.dart';

/// Accepted deviation mode for a [NumericItem].
enum ToleranceMode {
  @JsonValue('absolute')
  absolute,
  @JsonValue('relative')
  relative,
}

/// Drives the numeric keypad (US-022).
enum InputFormat {
  @JsonValue('integer')
  integer,
  @JsonValue('decimal')
  decimal,
  @JsonValue('time')
  time,
}

/// What the elements of a [SequenceItem] stimulus are.
enum StimulusKind {
  @JsonValue('digits')
  digits,
  @JsonValue('letters')
  letters,
  @JsonValue('symbols')
  symbols,
  @JsonValue('colors')
  colors,
  @JsonValue('gridCells')
  gridCells,
}

/// How a [SequenceItem] must be recalled.
enum RecallMode {
  @JsonValue('forward')
  forward,
  @JsonValue('backward')
  backward,
  @JsonValue('anyOrder')
  anyOrder,
}

/// One JSON file under `assets/content/<module>/<family>/items/`
/// (`bank.schema.json`): at most 100 items of a single family plus the reading
/// passages they reference.
@freezed
abstract class ItemBank with _$ItemBank {
  const factory ItemBank({
    required String familyId,
    required List<Item> items,
    @Default(<Passage>[]) List<Passage> passages,
  }) = _ItemBank;

  factory ItemBank.fromJson(Map<String, Object?> json) =>
      _$ItemBankFromJson(json);
}

/// Shared reading text for a group of MCQ items.
@freezed
abstract class Passage with _$Passage {
  const factory Passage({
    required String id,
    required LocalizedText body,
    LocalizedText? title,
    MediaRef? media,
    ContentLang? lang,
  }) = _Passage;

  factory Passage.fromJson(Map<String, Object?> json) =>
      _$PassageFromJson(json);
}

/// One MCQ choice: text and/or media.
@freezed
abstract class McqOption with _$McqOption {
  const factory McqOption({LocalizedText? text, MediaRef? media}) = _McqOption;

  factory McqOption.fromJson(Map<String, Object?> json) =>
      _$McqOptionFromJson(json);
}

/// Accepted deviation around [NumericItem.expected].
@freezed
abstract class Tolerance with _$Tolerance {
  const factory Tolerance({required ToleranceMode mode, required num value}) =
      _Tolerance;

  factory Tolerance.fromJson(Map<String, Object?> json) =>
      _$ToleranceFromJson(json);
}

/// Grid dimensions for `gridCells` sequences.
@freezed
abstract class GridSize with _$GridSize {
  const factory GridSize({required int rows, required int cols}) = _GridSize;

  factory GridSize.fromJson(Map<String, Object?> json) =>
      _$GridSizeFromJson(json);
}

/// Present only on items materialised at runtime by a generator. Same
/// `generatorId` + `seed` => same item, so an attempt can be replayed.
@freezed
abstract class ItemOrigin with _$ItemOrigin {
  const factory ItemOrigin({required String generatorId, required int seed}) =
      _ItemOrigin;

  factory ItemOrigin.fromJson(Map<String, Object?> json) =>
      _$ItemOriginFromJson(json);
}

/// One question/stimulus, discriminated by `type` into `mcq` | `numeric` |
/// `sequence` | `generated` (`item.schema.json`).
///
/// Every concrete bank item is self-scoring; a [GeneratedItem] is a recipe
/// the engine materialises into one of the other three.
@Freezed(unionKey: 'type')
sealed class Item with _$Item {
  /// Multiple-choice question.
  @FreezedUnionValue('mcq')
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  @Assert(
    'correctIndex >= 0 && correctIndex < options.length',
    'correctIndex must index into options',
  )
  const factory Item.mcq({
    required String id,
    required int version,
    required String familyId,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    required LocalizedText stem,
    required List<McqOption> options,
    required int correctIndex,
    required LocalizedText explanation,
    ContentLang? lang,
    @Default(ContentStatus.published) ContentStatus status,
    ItemOrigin? origin,
    ContentMeta? meta,
    MediaRef? media,
    String? passageId,
    @Default(true) bool shuffleOptions,
  }) = McqItem;

  /// Free numeric answer compared to [NumericItem.expected].
  @FreezedUnionValue('numeric')
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  const factory Item.numeric({
    required String id,
    required int version,
    required String familyId,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    required LocalizedText stem,
    required num expected,
    required LocalizedText explanation,
    ContentLang? lang,
    @Default(ContentStatus.published) ContentStatus status,
    ItemOrigin? origin,
    ContentMeta? meta,
    MediaRef? media,
    Tolerance? tolerance,
    String? unit,
    @Default(InputFormat.decimal) InputFormat inputFormat,
    @Default(2) int decimals,
  }) = NumericItem;

  /// Memory stimulus: elements shown one at a time (or as a grid pattern),
  /// then recalled.
  @FreezedUnionValue('sequence')
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  @Assert(
    'stimulusKind != StimulusKind.gridCells || grid != null',
    'gridCells sequences require a grid',
  )
  const factory Item.sequence({
    required String id,
    required int version,
    required String familyId,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    required StimulusKind stimulusKind,
    required List<String> stimulus,
    required RecallMode recallMode,
    ContentLang? lang,
    @Default(ContentStatus.published) ContentStatus status,
    ItemOrigin? origin,
    ContentMeta? meta,
    LocalizedText? instructions,
    GridSize? grid,
    @Default(1000) int presentationMs,
    @Default(250) int gapMs,
    LocalizedText? explanation,
  }) = SequenceItem;

  /// A reproducible recipe: generator `generatorId` called with `seed` and
  /// `params` yields a concrete mcq/numeric/sequence item.
  @FreezedUnionValue('generated')
  @Assert(
    'difficulty >= minDifficulty && difficulty <= maxDifficulty',
    'difficulty must be 1..5',
  )
  const factory Item.generated({
    required String id,
    required int version,
    required String familyId,
    @JsonKey(fromJson: difficultyFromJson) required Difficulty difficulty,
    required List<String> tags,
    required String generatorId,
    required int seed,
    ContentLang? lang,
    @Default(ContentStatus.published) ContentStatus status,
    ItemOrigin? origin,
    ContentMeta? meta,
    @Default(<String, Object?>{}) Map<String, Object?> params,
  }) = GeneratedItem;

  factory Item.fromJson(Map<String, Object?> json) => _$ItemFromJson(json);
}
