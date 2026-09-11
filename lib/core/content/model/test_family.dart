import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';
import 'generator.dart';

part 'test_family.freezed.dart';
part 'test_family.g.dart';

/// Key of the engine that runs a family (US-020 registry): the 14 PSY0
/// activity families of EPIC-03 plus the English sub-families (contract v2).
/// Bank-driven engines (`cultureAero`, `english*`) read [McqItem]s from
/// files; the others own a generator ([TestFamily.generatorId]).
enum EngineType {
  @JsonValue('memory_nback')
  memoryNback,
  @JsonValue('planning_tubes')
  planningTubes,
  @JsonValue('attention_rules')
  attentionRules,
  @JsonValue('attention_parity')
  attentionParity,
  @JsonValue('spatial_overlay')
  spatialOverlay,
  @JsonValue('logic_dominos')
  logicDominos,
  @JsonValue('attention_airways')
  attentionAirways,
  @JsonValue('verbal_boxes')
  verbalBoxes,
  @JsonValue('arithmetic_grid')
  arithmeticGrid,
  @JsonValue('spatial_viewpoint')
  spatialViewpoint,
  @JsonValue('spatial_cubes')
  spatialCubes,
  @JsonValue('culture_aero')
  cultureAero,
  @JsonValue('multitask_psychomotor')
  multitaskPsychomotor,
  @JsonValue('english_reading')
  englishReading,
  @JsonValue('english_grammar')
  englishGrammar,
  @JsonValue('english_listening')
  englishListening,
  @JsonValue('english_speaking')
  englishSpeaking,
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

  /// Keyboard keys at a fixed cadence.
  @JsonValue('key_press')
  keyPress,

  /// Ordered clicks on scattered targets.
  @JsonValue('click_sequence')
  clickSequence,

  /// Drag and drop of tiles / faces.
  @JsonValue('drag')
  drag,

  /// Toggle cells then validate.
  @JsonValue('multi_select')
  multiSelect,

  /// Continuous interaction with a running simulation.
  @JsonValue('simulation')
  simulation,

  /// Microphone self-recording.
  @JsonValue('recording')
  recording,
}

/// One activity family of a module (e.g. PSY0 > memory_nback). File:
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

    /// v2: generator the practice launcher uses (null for bank-driven
    /// families).
    GeneratorId? generatorId,
    @Default(InputRequirement.touch) InputRequirement inputRequirement,

    /// v2: the real activity shows right/wrong feedback live; engines keep it
    /// in exam mode.
    @Default(false) bool liveFeedback,
    @Default(ContentLang.fr) ContentLang lang,
    int? defaultPerItemTimeSec,

    /// v2: fixed-rhythm families (memory_nback, attention_rules).
    Cadence? defaultCadence,
    @Default(<String>[]) List<String> tags,
    @Default(ContentStatus.published) ContentStatus status,
    ContentMeta? meta,
  }) = _TestFamily;

  factory TestFamily.fromJson(Map<String, Object?> json) =>
      _$TestFamilyFromJson(json);
}
