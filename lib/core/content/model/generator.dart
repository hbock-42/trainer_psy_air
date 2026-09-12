import 'package:freezed_annotation/freezed_annotation.dart';

import 'common.dart';

part 'generator.freezed.dart';
part 'generator.g.dart';

/// The closed list of activity generators (contract v2,
/// `generators.schema.json#/$defs/GeneratorId`). One per interactive PSY0
/// activity of EPIC-03; keys the engine registry (US-020).
enum GeneratorId {
  @JsonValue('nback')
  nback,
  @JsonValue('tubes')
  tubes,
  @JsonValue('stimulus_response')
  stimulusResponse,
  @JsonValue('parity_sequence')
  paritySequence,
  @JsonValue('overlay_grid')
  overlayGrid,
  @JsonValue('dominos')
  dominos,
  @JsonValue('airways')
  airways,
  @JsonValue('word_boxes')
  wordBoxes,
  @JsonValue('arithmetic_grid')
  arithmeticGrid,
  @JsonValue('viewpoint')
  viewpoint,
  @JsonValue('cube_net')
  cubeNet,
  @JsonValue('multitask')
  multitask,
}

/// Name of the JSON key that discriminates [GeneratorParams] cases. It is the
/// sibling `generatorId` of the recipe, injected into the params map by
/// [readGeneratorParams] and stripped again by [generatorParamsToJson].
const String generatorParamsUnionKey = 'generatorId';

/// `@JsonKey(readValue:)` helper: reads `params` from [json] (defaulting to
/// `{}`) and injects the recipe's `generatorId` so the [GeneratorParams]
/// union can pick its case.
Object? readGeneratorParams(Map<Object?, Object?> json, String key) {
  final raw = json[key];
  final params = raw is Map<Object?, Object?>
      ? Map<String, Object?>.from(raw)
      : <String, Object?>{};
  return <String, Object?>{
    ...params,
    generatorParamsUnionKey: json[generatorParamsUnionKey],
  };
}

/// `@JsonKey(toJson:)` helper: serialises [params] without the injected
/// discriminator, so the file keeps a single `generatorId`.
Map<String, Object?> generatorParamsToJson(GeneratorParams params) =>
    params.toJson()..remove(generatorParamsUnionKey);

/// What the n-back stimulus is.
enum NbackStimulusKind {
  @JsonValue('colour')
  colour,
  @JsonValue('digit')
  digit,
  @JsonValue('letter')
  letter,
}

/// Shapes the rule-based stimulus-response activity can flash.
enum StimulusShape {
  @JsonValue('square')
  square,
  @JsonValue('triangle')
  triangle,
  @JsonValue('circle')
  circle,
  @JsonValue('diamond')
  diamond,
  @JsonValue('star')
  star,
}

/// Colours the rule-based stimulus-response activity can flash.
enum StimulusColour {
  @JsonValue('blue')
  blue,
  @JsonValue('orange')
  orange,
  @JsonValue('green')
  green,
  @JsonValue('pink')
  pink,
  @JsonValue('red')
  red,
  @JsonValue('yellow')
  yellow,
}

/// Arrangement of the dominoes on screen.
enum DominoLayout {
  @JsonValue('row')
  row,
  @JsonValue('grid')
  grid,
  @JsonValue('spiral')
  spiral,
}

/// How the missing domino is answered.
enum DominoAnswerMode {
  /// Two 0-6 selectors (real test).
  @JsonValue('pick')
  pick,

  /// Six candidate dominoes.
  @JsonValue('mcq')
  mcq,
}

/// Operations an arithmetic grid may contain.
enum ArithmeticOperation {
  @JsonValue('add')
  add,
  @JsonValue('sub')
  sub,
  @JsonValue('mul')
  mul,
  @JsonValue('div')
  div,
  @JsonValue('square')
  square,
  @JsonValue('percent')
  percent,
  @JsonValue('priority')
  priority,
}

/// Solids a viewpoint scene is built from.
enum SolidKind {
  @JsonValue('cube')
  cube,
  @JsonValue('cylinder')
  cylinder,
  @JsonValue('cone')
  cone,
  @JsonValue('sphere')
  sphere,
  @JsonValue('pyramid')
  pyramid,
}

/// Symbols drawn on cube faces.
enum CubeSymbolKind {
  @JsonValue('letters')
  letters,
  @JsonValue('shapes')
  shapes,
  @JsonValue('mixed')
  mixed,
}

/// Typed `params` of a generated recipe, one case per [GeneratorId]
/// (`generators.schema.json#/$defs/*Params`). Every field has the real-test
/// default from `docs/content/psy0-spec.md` §2.4, so an empty `params` object
/// is always valid. A generated item is reproducible from
/// `(generatorId, seed, params)`.
@Freezed(unionKey: generatorParamsUnionKey)
sealed class GeneratorParams with _$GeneratorParams {
  const GeneratorParams._();

  /// `memory_nback` (spec §2.4-A, US-026).
  @FreezedUnionValue('nback')
  const factory GeneratorParams.nback({
    @Default(2) int n,
    @Default(NbackStimulusKind.colour) NbackStimulusKind stimulusKind,
    @Default(3) int paletteSize,
    @Default(42) int count,
    @Default(2) int primers,
    @Default(1000) int stimulusMs,
    @Default(1500) int answerWindowMs,
    @Default(0.3) double targetRatio,
    @Default(0.1) double lureRatio,
  }) = NbackParams;

  /// `planning_tubes` (spec §2.4-B, US-035).
  @FreezedUnionValue('tubes')
  const factory GeneratorParams.tubes({
    @Default(<int>[3, 2, 3]) List<int> capacities,
    @Default(3) int colourCount,
    @Default(5) int ballCount,
    @Default(2) int minMoves,
    @Default(8) int maxMoves,
  }) = TubesParams;

  /// `attention_rules` (spec §2.4-C, US-029).
  @FreezedUnionValue('stimulus_response')
  const factory GeneratorParams.stimulusResponse({
    @Default(36) int count,
    @Default(500) int stimulusMs,
    @Default(3000) int answerWindowMs,
    @Default(<String>['n', 'x']) List<String> keys,
    @Default(<StimulusShape>[StimulusShape.square, StimulusShape.triangle])
    List<StimulusShape> shapes,
    @Default(<StimulusColour>[StimulusColour.blue, StimulusColour.orange])
    List<StimulusColour> colours,
    @Default(2) int ruleDepth,
  }) = StimulusResponseParams;

  /// `attention_parity` (spec §2.4-D, US-031).
  @FreezedUnionValue('parity_sequence')
  const factory GeneratorParams.paritySequence({
    @Default(16) int numberCount,
    @Default(1) int numberMin,
    @Default(99) int numberMax,
    @Default(true) bool restartOnError,
    @Default(true) bool labelEnds,
  }) = ParitySequenceParams;

  /// `spatial_overlay` (spec §2.4-E, US-033).
  @FreezedUnionValue('overlay_grid')
  const factory GeneratorParams.overlayGrid({
    @Default(GridSize(rows: 5, cols: 5)) GridSize grid,
    @Default(3) int tileCount,
    @Default(true) bool overlapping,
    @Default(true) bool blackCells,
  }) = OverlayGridParams;

  /// `logic_dominos` (spec §2.4-G, US-024).
  @FreezedUnionValue('dominos')
  const factory GeneratorParams.dominos({
    @Default(6) int length,
    @Default(DominoLayout.row) DominoLayout layout,
    @Default(1) int ruleCount,
    @Default(DominoAnswerMode.pick) DominoAnswerMode answerMode,
  }) = DominosParams;

  /// `attention_airways` (spec §2.4-H, US-032).
  @FreezedUnionValue('airways')
  const factory GeneratorParams.airways({
    @Default(4) int capacity,
    @Default(2) int blueCapacity,
    @Default(2) int zoneCount,
    @Default(3) int routeCount,
    @Default(2500) int spawnIntervalMs,
    @Default(30) int durationSec,
  }) = AirwaysParams;

  /// `verbal_boxes` (spec §2.4-I, US-030); fields come from the
  /// `lexical_fields` bank (US-085).
  @FreezedUnionValue('word_boxes')
  const factory GeneratorParams.wordBoxes({
    @Default(5) int boxCount,
    @Default(20) int wordCount,
    List<String>? fieldIds,
    @Default(0.1) double trapRatio,
    @Default(3000) int wordTimeMs,
  }) = WordBoxesParams;

  /// `arithmetic_grid` (spec §2.4-J, US-023).
  @FreezedUnionValue('arithmetic_grid')
  const factory GeneratorParams.arithmeticGrid({
    @Default(GridSize(rows: 3, cols: 3)) GridSize grid,
    @Default(0) int wrongMin,
    @Default(4) int wrongMax,
    @Default(<ArithmeticOperation>[
      ArithmeticOperation.add,
      ArithmeticOperation.sub,
      ArithmeticOperation.mul,
      ArithmeticOperation.div,
      ArithmeticOperation.square,
      ArithmeticOperation.priority,
    ])
    List<ArithmeticOperation> operations,
    @Default(100) int maxOperand,
  }) = ArithmeticGridParams;

  /// `spatial_viewpoint` (spec §2.4-K, US-034).
  @FreezedUnionValue('viewpoint')
  const factory GeneratorParams.viewpoint({
    @Default(8) int viewpointCount,
    @Default(4) int objectCount,
    @Default(<SolidKind>[SolidKind.cube, SolidKind.cylinder, SolidKind.cone])
    List<SolidKind> objectKinds,
    @Default(false) bool allowSymmetric,
  }) = ViewpointParams;

  /// `spatial_cubes` (spec §2.4-L, US-025).
  @FreezedUnionValue('cube_net')
  const factory GeneratorParams.cubeNet({
    @Default(2) int missingFaces,
    @Default(2) int distractorFaces,
    @Default(CubeSymbolKind.letters) CubeSymbolKind symbolKind,
    @Default(true) bool flippable,
  }) = CubeNetParams;

  /// `multitask_psychomotor` (spec §2.4-M, US-036).
  @FreezedUnionValue('multitask')
  const factory GeneratorParams.multitask({
    @Default(300) int durationSec,
    @Default(1.0) double trackingSpeed,
    @Default(1.0) double trackingNoise,
    @Default(2000) int shapeIntervalMs,
    @Default(4000) int calcIntervalMs,
    @Default(0.3) double shapeTargetRatio,
    @Default(0.4) double calcWrongRatio,
    @Default('space') String shapeKey,
    @Default('f') String calcKey,
  }) = MultitaskParams;

  factory GeneratorParams.fromJson(Map<String, Object?> json) =>
      _$GeneratorParamsFromJson(json);

  /// The generator these params belong to.
  GeneratorId get generatorId => switch (this) {
    NbackParams() => GeneratorId.nback,
    TubesParams() => GeneratorId.tubes,
    StimulusResponseParams() => GeneratorId.stimulusResponse,
    ParitySequenceParams() => GeneratorId.paritySequence,
    OverlayGridParams() => GeneratorId.overlayGrid,
    DominosParams() => GeneratorId.dominos,
    AirwaysParams() => GeneratorId.airways,
    WordBoxesParams() => GeneratorId.wordBoxes,
    ArithmeticGridParams() => GeneratorId.arithmeticGrid,
    ViewpointParams() => GeneratorId.viewpoint,
    CubeNetParams() => GeneratorId.cubeNet,
    MultitaskParams() => GeneratorId.multitask,
  };

  /// The real-test defaults of [id].
  static GeneratorParams defaultsFor(GeneratorId id) => switch (id) {
    GeneratorId.nback => const GeneratorParams.nback(),
    GeneratorId.tubes => const GeneratorParams.tubes(),
    GeneratorId.stimulusResponse => const GeneratorParams.stimulusResponse(),
    GeneratorId.paritySequence => const GeneratorParams.paritySequence(),
    GeneratorId.overlayGrid => const GeneratorParams.overlayGrid(),
    GeneratorId.dominos => const GeneratorParams.dominos(),
    GeneratorId.airways => const GeneratorParams.airways(),
    GeneratorId.wordBoxes => const GeneratorParams.wordBoxes(),
    GeneratorId.arithmeticGrid => const GeneratorParams.arithmeticGrid(),
    GeneratorId.viewpoint => const GeneratorParams.viewpoint(),
    GeneratorId.cubeNet => const GeneratorParams.cubeNet(),
    GeneratorId.multitask => const GeneratorParams.multitask(),
  };
}
