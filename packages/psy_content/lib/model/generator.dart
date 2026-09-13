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

  // PSY1 (EPIC-10, US-101). One per family of `psy1-spec.md` §4.1; every
  // param below is `[estimated]`/`[assumed]` unless the spec's own tag says
  // otherwise, since PSY1 content authoring (US-103+) has not landed yet.
  @JsonValue('p1_math_word_problems')
  p1MathWordProblems,
  @JsonValue('p1_tangram')
  p1Tangram,
  @JsonValue('p1_attention_sustained')
  p1AttentionSustained,
  @JsonValue('p1_reading_fr')
  p1ReadingFr,
  @JsonValue('p1_angles')
  p1Angles,
  @JsonValue('p1_general_efficiency')
  p1GeneralEfficiency,
  @JsonValue('p1_counters')
  p1Counters,
  @JsonValue('p1_cube_nets')
  p1CubeNets,
  @JsonValue('p1_wm_reverse_span')
  p1WmReverseSpan,
  @JsonValue('p1_wm_calc_back')
  p1WmCalcBack,
  @JsonValue('p1_raven_matrices')
  p1RavenMatrices,
  @JsonValue('p1_mental_arithmetic')
  p1MentalArithmetic,
  @JsonValue('p1_psychomotor')
  p1Psychomotor,
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

/// `p1_math_word_problems` / `p1_general_efficiency`: how the answer is
/// captured (spec §2.3 rows 1/6 report both MCQ and free-numeric shapes).
enum P1AnswerMode {
  @JsonValue('mcq')
  mcq,
  @JsonValue('numeric')
  numeric,
}

/// `p1_tangram` (spec §2.3 row 2): assemble the shape, or count how many
/// times a given piece occurs in it (2024-only "new version").
enum TangramMode {
  @JsonValue('compose')
  compose,
  @JsonValue('count_occurrences')
  countOccurrences,
}

/// `p1_cube_nets` (spec §2.3/§4.1 row 8): the symbol alphabet drawn on the
/// net's faces; `runic` is the invented, non-memorisable symbol set some
/// sessions use.
enum CubeNetAlphabet {
  @JsonValue('latin')
  latin,
  @JsonValue('runic')
  runic,
}

/// `p1_mental_arithmetic` (spec §2.3/§4.1 row 12): the four graded response
/// formats of "Calcul mental 1-4", progressively more demanding over the
/// same underlying arithmetic.
enum MentalArithmeticAnswerMode {
  /// Type the exact result.
  @JsonValue('free_numeric')
  freeNumeric,

  /// Solve a simple equation for `x`.
  @JsonValue('equation')
  equation,

  /// Pick the tightest interval that contains the true value.
  @JsonValue('smallest_interval')
  smallestInterval,

  /// Select every interval that contains the true value (multi-select).
  @JsonValue('all_intervals')
  allIntervals,
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

  // --- PSY1 (EPIC-10, US-101) ------------------------------------------

  /// `p1_math_word_problems` (spec §4.1 row 1). Multi-step word-problem
  /// arithmetic, harder than PSY0's `arithmetic_grid`; scratch paper is
  /// allowed on the real test. Defaults `[estimated]` from the 2024 debrief
  /// ("30 q / 35 min").
  @FreezedUnionValue('p1_math_word_problems')
  const factory GeneratorParams.p1MathWordProblems({
    @Default(30) int count,
    @Default(P1AnswerMode.mcq) P1AnswerMode answerMode,
    @Default(3) int maxSteps,
    @Default(100) int maxOperand,
  }) = P1MathWordProblemsParams;

  /// `p1_tangram` (spec §4.1 row 2). Compose a shape from a fixed piece set,
  /// or (2024 variant) count how many times a given piece occurs in it.
  /// Defaults `[estimated]` ("24 planches / ~20 min").
  @FreezedUnionValue('p1_tangram')
  const factory GeneratorParams.p1Tangram({
    @Default(24) int count,
    @Default(7) int pieceCount,
    @Default(TangramMode.compose) TangramMode mode,
  }) = P1TangramParams;

  /// `p1_attention_sustained` (spec §4.1 row 3). Format is an
  /// `[open question]`; built against the closest PSY0 paradigm
  /// (`attention_rules`-style cadence) until a fuller debrief exists.
  /// Defaults `[assumed]` ("3 series of 5, ~9 min").
  @FreezedUnionValue('p1_attention_sustained')
  const factory GeneratorParams.p1AttentionSustained({
    @Default(3) int seriesCount,
    @Default(5) int itemsPerSeries,
    @Default(500) int stimulusMs,
    @Default(3000) int answerWindowMs,
  }) = P1AttentionSustainedParams;

  /// `p1_reading_fr` (spec §4.1 row 4). French-language reading
  /// comprehension, same MCQ-on-passage shape as PSY0's `english` bank.
  /// Defaults `[estimated]` ("10 texts / 20 min"); a bank of authored
  /// passages (US-103) feeds it, this only sizes a generated session.
  @FreezedUnionValue('p1_reading_fr')
  const factory GeneratorParams.p1ReadingFr({
    @Default(10) int passageCount,
    @Default(1) int questionsPerPassage,
  }) = P1ReadingFrParams;

  /// `p1_angles` (spec §4.1 row 5). Among `optionCount` candidate angle
  /// values, select up to `maxCorrect`. Defaults `[reported]` optionCount /
  /// maxCorrect ("9 possibilités, max 4 bonnes réponses"), the rest
  /// `[assumed]`.
  @FreezedUnionValue('p1_angles')
  const factory GeneratorParams.p1Angles({
    @Default(3) int setCount,
    @Default(9) int optionCount,
    @Default(4) int maxCorrect,
  }) = P1AnglesParams;

  /// `p1_general_efficiency` ("EFG", spec §4.1 row 6). Mixed-topic reasoning
  /// MCQ; exact item type is an `[open question]`. Defaults `[estimated]`
  /// ("35 q / 30 min").
  @FreezedUnionValue('p1_general_efficiency')
  const factory GeneratorParams.p1GeneralEfficiency({@Default(35) int count}) =
      P1GeneralEfficiencyParams;

  /// `p1_counters` (spec §4.1 row 7). Read values off dial/counter displays.
  /// No timing was found for the family; defaults entirely `[assumed]`.
  @FreezedUnionValue('p1_counters')
  const factory GeneratorParams.p1Counters({
    @Default(10) int count,
    @Default(3) int dialsPerItem,
  }) = P1CountersParams;

  /// `p1_cube_nets` (spec §4.1 row 8). Net-folding, extending PSY0's
  /// `spatial_cubes`/`cube_net` with an alphabet parameter (latin vs the
  /// invented "runic" set) and the rotation-matching sub-variant. Defaults
  /// `[reported]` phase/net counts ("2 phases x 10 patrons x 20 min"), the
  /// rest `[assumed]`.
  @FreezedUnionValue('p1_cube_nets')
  const factory GeneratorParams.p1CubeNets({
    @Default(2) int phaseCount,
    @Default(10) int netsPerPhase,
    @Default(CubeNetAlphabet.latin) CubeNetAlphabet alphabet,
    @Default(2) int missingFaces,
    @Default(false) bool includeRotationMatching,
  }) = P1CubeNetsParams;

  /// `p1_wm_reverse_span` (spec §4.1 row 9). Reverse-digit working-memory
  /// span; digit-length range `[reported]`, timing `[assumed]`.
  @FreezedUnionValue('p1_wm_reverse_span')
  const factory GeneratorParams.p1WmReverseSpan({
    @Default(10) int count,
    @Default(4) int minDigits,
    @Default(9) int maxDigits,
    @Default(3500) int answerWindowMs,
  }) = P1WmReverseSpanParams;

  /// `p1_wm_calc_back` (spec §4.1 row 10). "Calcul memory back": holds
  /// intermediate results in working memory over increasing-load stages.
  /// Defaults `[reported]` ("4 stages x 20+ calcs").
  @FreezedUnionValue('p1_wm_calc_back')
  const factory GeneratorParams.p1WmCalcBack({
    @Default(4) int stageCount,
    @Default(20) int calcsPerStage,
  }) = P1WmCalcBackParams;

  /// `p1_raven_matrices` (spec §4.1 row 11). Classic Raven-style visual
  /// matrix completion. Defaults `[estimated]` ("30 q / 30 min").
  @FreezedUnionValue('p1_raven_matrices')
  const factory GeneratorParams.p1RavenMatrices({
    @Default(30) int count,
    @Default(GridSize(rows: 3, cols: 3)) GridSize grid,
    @Default(8) int optionCount,
  }) = P1RavenMatricesParams;

  /// `p1_mental_arithmetic` ("Calcul mental 1-4", spec §4.1 row 12). Same
  /// underlying arithmetic generator as PSY0's `arithmetic_grid`, graded
  /// over four answer-format modes. Defaults `[estimated]`
  /// ("10 per series, 4 series").
  @FreezedUnionValue('p1_mental_arithmetic')
  const factory GeneratorParams.p1MentalArithmetic({
    @Default(10) int count,
    @Default(MentalArithmeticAnswerMode.freeNumeric)
    MentalArithmeticAnswerMode answerMode,
    @Default(100) int maxOperand,
  }) = P1MentalArithmeticParams;

  /// `p1_psychomotor` (spec §4.1 row 13). Continuous 4-channel multitasking
  /// test (dual-axis tracking, gauge-nulling, letter cancellation, timed
  /// arithmetic); any sub-task in its "red zone" zeroes the whole score.
  /// Needs the joystick/gamepad input abstraction of §3 (US-102); this
  /// contract only sizes the phases. Defaults `[reported]`
  /// ("6 x 3 min phases, calc every 12 s").
  @FreezedUnionValue('p1_psychomotor')
  const factory GeneratorParams.p1Psychomotor({
    @Default(6) int phaseCount,
    @Default(180) int phaseDurationSec,
    @Default(12) int calcIntervalSec,
  }) = P1PsychomotorParams;

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
    P1MathWordProblemsParams() => GeneratorId.p1MathWordProblems,
    P1TangramParams() => GeneratorId.p1Tangram,
    P1AttentionSustainedParams() => GeneratorId.p1AttentionSustained,
    P1ReadingFrParams() => GeneratorId.p1ReadingFr,
    P1AnglesParams() => GeneratorId.p1Angles,
    P1GeneralEfficiencyParams() => GeneratorId.p1GeneralEfficiency,
    P1CountersParams() => GeneratorId.p1Counters,
    P1CubeNetsParams() => GeneratorId.p1CubeNets,
    P1WmReverseSpanParams() => GeneratorId.p1WmReverseSpan,
    P1WmCalcBackParams() => GeneratorId.p1WmCalcBack,
    P1RavenMatricesParams() => GeneratorId.p1RavenMatrices,
    P1MentalArithmeticParams() => GeneratorId.p1MentalArithmetic,
    P1PsychomotorParams() => GeneratorId.p1Psychomotor,
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
    GeneratorId.p1MathWordProblems =>
      const GeneratorParams.p1MathWordProblems(),
    GeneratorId.p1Tangram => const GeneratorParams.p1Tangram(),
    GeneratorId.p1AttentionSustained =>
      const GeneratorParams.p1AttentionSustained(),
    GeneratorId.p1ReadingFr => const GeneratorParams.p1ReadingFr(),
    GeneratorId.p1Angles => const GeneratorParams.p1Angles(),
    GeneratorId.p1GeneralEfficiency =>
      const GeneratorParams.p1GeneralEfficiency(),
    GeneratorId.p1Counters => const GeneratorParams.p1Counters(),
    GeneratorId.p1CubeNets => const GeneratorParams.p1CubeNets(),
    GeneratorId.p1WmReverseSpan => const GeneratorParams.p1WmReverseSpan(),
    GeneratorId.p1WmCalcBack => const GeneratorParams.p1WmCalcBack(),
    GeneratorId.p1RavenMatrices => const GeneratorParams.p1RavenMatrices(),
    GeneratorId.p1MentalArithmetic =>
      const GeneratorParams.p1MentalArithmetic(),
    GeneratorId.p1Psychomotor => const GeneratorParams.p1Psychomotor(),
  };
}
