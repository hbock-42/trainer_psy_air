import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'test_family.freezed.dart';
part 'test_family.g.dart';

/// Key of the engine that runs a family (US-020 registry). Bank engines read
/// items from files; the others generate.
enum EngineType {
  @JsonValue('mcq_bank')
  mcqBank,
  @JsonValue('numeric_bank')
  numericBank,
  @JsonValue('mental_arithmetic')
  mentalArithmetic,
  @JsonValue('logic_series')
  logicSeries,
  @JsonValue('figure_matrix')
  figureMatrix,
  @JsonValue('spatial_rotation')
  spatialRotation,
  @JsonValue('cube_folding')
  cubeFolding,
  @JsonValue('memory_digit_span')
  memoryDigitSpan,
  @JsonValue('memory_pattern')
  memoryPattern,
  @JsonValue('memory_sequence')
  memorySequence,
  @JsonValue('attention_symbols')
  attentionSymbols,
  @JsonValue('attention_stream')
  attentionStream,
  @JsonValue('multitasking')
  multitasking,
  @JsonValue('instrument_reading')
  instrumentReading,
}

/// Primary answer widget of a family.
enum AnswerFormat {
  @JsonValue('mcq')
  mcq,
  @JsonValue('numeric')
  numeric,
  @JsonValue('sequence')
  sequence,
  @JsonValue('grid')
  grid,
  @JsonValue('tap')
  tap,
}

/// One test family of a module (e.g. PSY0 > English). File:
/// `assets/content/<module>/<family>/family.json` (`family.schema.json`).
@freezed
abstract class TestFamily with _$TestFamily {
  const factory TestFamily({
    required String id,
    required ModuleId moduleId,
    required int version,
    required int order,
    required LocalizedText name,
    required LocalizedText description,
    required EngineType engineType,
    required AnswerFormat answerFormat,
    required int defaultDurationSec,
    required int defaultItemCount,
    required Confidence confidence,
    LocalizedText? shortName,
    @Default(ContentLang.fr) ContentLang lang,
    int? defaultPerItemTimeSec,
    @Default(<String>[]) List<String> tags,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _TestFamily;

  factory TestFamily.fromJson(Map<String, Object?> json) =>
      _$TestFamilyFromJson(json);
}
