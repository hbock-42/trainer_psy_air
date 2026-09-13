// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generator.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
GeneratorParams _$GeneratorParamsFromJson(
  Map<String, dynamic> json
) {
        switch (json['generatorId']) {
                  case 'nback':
          return NbackParams.fromJson(
            json
          );
                case 'tubes':
          return TubesParams.fromJson(
            json
          );
                case 'stimulus_response':
          return StimulusResponseParams.fromJson(
            json
          );
                case 'parity_sequence':
          return ParitySequenceParams.fromJson(
            json
          );
                case 'overlay_grid':
          return OverlayGridParams.fromJson(
            json
          );
                case 'dominos':
          return DominosParams.fromJson(
            json
          );
                case 'airways':
          return AirwaysParams.fromJson(
            json
          );
                case 'word_boxes':
          return WordBoxesParams.fromJson(
            json
          );
                case 'arithmetic_grid':
          return ArithmeticGridParams.fromJson(
            json
          );
                case 'viewpoint':
          return ViewpointParams.fromJson(
            json
          );
                case 'cube_net':
          return CubeNetParams.fromJson(
            json
          );
                case 'multitask':
          return MultitaskParams.fromJson(
            json
          );
                case 'p1_math_word_problems':
          return P1MathWordProblemsParams.fromJson(
            json
          );
                case 'p1_tangram':
          return P1TangramParams.fromJson(
            json
          );
                case 'p1_attention_sustained':
          return P1AttentionSustainedParams.fromJson(
            json
          );
                case 'p1_reading_fr':
          return P1ReadingFrParams.fromJson(
            json
          );
                case 'p1_angles':
          return P1AnglesParams.fromJson(
            json
          );
                case 'p1_general_efficiency':
          return P1GeneralEfficiencyParams.fromJson(
            json
          );
                case 'p1_counters':
          return P1CountersParams.fromJson(
            json
          );
                case 'p1_cube_nets':
          return P1CubeNetsParams.fromJson(
            json
          );
                case 'p1_wm_reverse_span':
          return P1WmReverseSpanParams.fromJson(
            json
          );
                case 'p1_wm_calc_back':
          return P1WmCalcBackParams.fromJson(
            json
          );
                case 'p1_raven_matrices':
          return P1RavenMatricesParams.fromJson(
            json
          );
                case 'p1_mental_arithmetic':
          return P1MentalArithmeticParams.fromJson(
            json
          );
                case 'p1_psychomotor':
          return P1PsychomotorParams.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'generatorId',
  'GeneratorParams',
  'Invalid union type "${json['generatorId']}"!'
);
        }
      
}

/// @nodoc
mixin _$GeneratorParams {



  /// Serializes this GeneratorParams to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratorParams);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'GeneratorParams()';
}


}

/// @nodoc
class $GeneratorParamsCopyWith<$Res>  {
$GeneratorParamsCopyWith(GeneratorParams _, $Res Function(GeneratorParams) __);
}


/// Adds pattern-matching-related methods to [GeneratorParams].
extension GeneratorParamsPatterns on GeneratorParams {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NbackParams value)?  nback,TResult Function( TubesParams value)?  tubes,TResult Function( StimulusResponseParams value)?  stimulusResponse,TResult Function( ParitySequenceParams value)?  paritySequence,TResult Function( OverlayGridParams value)?  overlayGrid,TResult Function( DominosParams value)?  dominos,TResult Function( AirwaysParams value)?  airways,TResult Function( WordBoxesParams value)?  wordBoxes,TResult Function( ArithmeticGridParams value)?  arithmeticGrid,TResult Function( ViewpointParams value)?  viewpoint,TResult Function( CubeNetParams value)?  cubeNet,TResult Function( MultitaskParams value)?  multitask,TResult Function( P1MathWordProblemsParams value)?  p1MathWordProblems,TResult Function( P1TangramParams value)?  p1Tangram,TResult Function( P1AttentionSustainedParams value)?  p1AttentionSustained,TResult Function( P1ReadingFrParams value)?  p1ReadingFr,TResult Function( P1AnglesParams value)?  p1Angles,TResult Function( P1GeneralEfficiencyParams value)?  p1GeneralEfficiency,TResult Function( P1CountersParams value)?  p1Counters,TResult Function( P1CubeNetsParams value)?  p1CubeNets,TResult Function( P1WmReverseSpanParams value)?  p1WmReverseSpan,TResult Function( P1WmCalcBackParams value)?  p1WmCalcBack,TResult Function( P1RavenMatricesParams value)?  p1RavenMatrices,TResult Function( P1MentalArithmeticParams value)?  p1MentalArithmetic,TResult Function( P1PsychomotorParams value)?  p1Psychomotor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case NbackParams() when nback != null:
return nback(_that);case TubesParams() when tubes != null:
return tubes(_that);case StimulusResponseParams() when stimulusResponse != null:
return stimulusResponse(_that);case ParitySequenceParams() when paritySequence != null:
return paritySequence(_that);case OverlayGridParams() when overlayGrid != null:
return overlayGrid(_that);case DominosParams() when dominos != null:
return dominos(_that);case AirwaysParams() when airways != null:
return airways(_that);case WordBoxesParams() when wordBoxes != null:
return wordBoxes(_that);case ArithmeticGridParams() when arithmeticGrid != null:
return arithmeticGrid(_that);case ViewpointParams() when viewpoint != null:
return viewpoint(_that);case CubeNetParams() when cubeNet != null:
return cubeNet(_that);case MultitaskParams() when multitask != null:
return multitask(_that);case P1MathWordProblemsParams() when p1MathWordProblems != null:
return p1MathWordProblems(_that);case P1TangramParams() when p1Tangram != null:
return p1Tangram(_that);case P1AttentionSustainedParams() when p1AttentionSustained != null:
return p1AttentionSustained(_that);case P1ReadingFrParams() when p1ReadingFr != null:
return p1ReadingFr(_that);case P1AnglesParams() when p1Angles != null:
return p1Angles(_that);case P1GeneralEfficiencyParams() when p1GeneralEfficiency != null:
return p1GeneralEfficiency(_that);case P1CountersParams() when p1Counters != null:
return p1Counters(_that);case P1CubeNetsParams() when p1CubeNets != null:
return p1CubeNets(_that);case P1WmReverseSpanParams() when p1WmReverseSpan != null:
return p1WmReverseSpan(_that);case P1WmCalcBackParams() when p1WmCalcBack != null:
return p1WmCalcBack(_that);case P1RavenMatricesParams() when p1RavenMatrices != null:
return p1RavenMatrices(_that);case P1MentalArithmeticParams() when p1MentalArithmetic != null:
return p1MentalArithmetic(_that);case P1PsychomotorParams() when p1Psychomotor != null:
return p1Psychomotor(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NbackParams value)  nback,required TResult Function( TubesParams value)  tubes,required TResult Function( StimulusResponseParams value)  stimulusResponse,required TResult Function( ParitySequenceParams value)  paritySequence,required TResult Function( OverlayGridParams value)  overlayGrid,required TResult Function( DominosParams value)  dominos,required TResult Function( AirwaysParams value)  airways,required TResult Function( WordBoxesParams value)  wordBoxes,required TResult Function( ArithmeticGridParams value)  arithmeticGrid,required TResult Function( ViewpointParams value)  viewpoint,required TResult Function( CubeNetParams value)  cubeNet,required TResult Function( MultitaskParams value)  multitask,required TResult Function( P1MathWordProblemsParams value)  p1MathWordProblems,required TResult Function( P1TangramParams value)  p1Tangram,required TResult Function( P1AttentionSustainedParams value)  p1AttentionSustained,required TResult Function( P1ReadingFrParams value)  p1ReadingFr,required TResult Function( P1AnglesParams value)  p1Angles,required TResult Function( P1GeneralEfficiencyParams value)  p1GeneralEfficiency,required TResult Function( P1CountersParams value)  p1Counters,required TResult Function( P1CubeNetsParams value)  p1CubeNets,required TResult Function( P1WmReverseSpanParams value)  p1WmReverseSpan,required TResult Function( P1WmCalcBackParams value)  p1WmCalcBack,required TResult Function( P1RavenMatricesParams value)  p1RavenMatrices,required TResult Function( P1MentalArithmeticParams value)  p1MentalArithmetic,required TResult Function( P1PsychomotorParams value)  p1Psychomotor,}){
final _that = this;
switch (_that) {
case NbackParams():
return nback(_that);case TubesParams():
return tubes(_that);case StimulusResponseParams():
return stimulusResponse(_that);case ParitySequenceParams():
return paritySequence(_that);case OverlayGridParams():
return overlayGrid(_that);case DominosParams():
return dominos(_that);case AirwaysParams():
return airways(_that);case WordBoxesParams():
return wordBoxes(_that);case ArithmeticGridParams():
return arithmeticGrid(_that);case ViewpointParams():
return viewpoint(_that);case CubeNetParams():
return cubeNet(_that);case MultitaskParams():
return multitask(_that);case P1MathWordProblemsParams():
return p1MathWordProblems(_that);case P1TangramParams():
return p1Tangram(_that);case P1AttentionSustainedParams():
return p1AttentionSustained(_that);case P1ReadingFrParams():
return p1ReadingFr(_that);case P1AnglesParams():
return p1Angles(_that);case P1GeneralEfficiencyParams():
return p1GeneralEfficiency(_that);case P1CountersParams():
return p1Counters(_that);case P1CubeNetsParams():
return p1CubeNets(_that);case P1WmReverseSpanParams():
return p1WmReverseSpan(_that);case P1WmCalcBackParams():
return p1WmCalcBack(_that);case P1RavenMatricesParams():
return p1RavenMatrices(_that);case P1MentalArithmeticParams():
return p1MentalArithmetic(_that);case P1PsychomotorParams():
return p1Psychomotor(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NbackParams value)?  nback,TResult? Function( TubesParams value)?  tubes,TResult? Function( StimulusResponseParams value)?  stimulusResponse,TResult? Function( ParitySequenceParams value)?  paritySequence,TResult? Function( OverlayGridParams value)?  overlayGrid,TResult? Function( DominosParams value)?  dominos,TResult? Function( AirwaysParams value)?  airways,TResult? Function( WordBoxesParams value)?  wordBoxes,TResult? Function( ArithmeticGridParams value)?  arithmeticGrid,TResult? Function( ViewpointParams value)?  viewpoint,TResult? Function( CubeNetParams value)?  cubeNet,TResult? Function( MultitaskParams value)?  multitask,TResult? Function( P1MathWordProblemsParams value)?  p1MathWordProblems,TResult? Function( P1TangramParams value)?  p1Tangram,TResult? Function( P1AttentionSustainedParams value)?  p1AttentionSustained,TResult? Function( P1ReadingFrParams value)?  p1ReadingFr,TResult? Function( P1AnglesParams value)?  p1Angles,TResult? Function( P1GeneralEfficiencyParams value)?  p1GeneralEfficiency,TResult? Function( P1CountersParams value)?  p1Counters,TResult? Function( P1CubeNetsParams value)?  p1CubeNets,TResult? Function( P1WmReverseSpanParams value)?  p1WmReverseSpan,TResult? Function( P1WmCalcBackParams value)?  p1WmCalcBack,TResult? Function( P1RavenMatricesParams value)?  p1RavenMatrices,TResult? Function( P1MentalArithmeticParams value)?  p1MentalArithmetic,TResult? Function( P1PsychomotorParams value)?  p1Psychomotor,}){
final _that = this;
switch (_that) {
case NbackParams() when nback != null:
return nback(_that);case TubesParams() when tubes != null:
return tubes(_that);case StimulusResponseParams() when stimulusResponse != null:
return stimulusResponse(_that);case ParitySequenceParams() when paritySequence != null:
return paritySequence(_that);case OverlayGridParams() when overlayGrid != null:
return overlayGrid(_that);case DominosParams() when dominos != null:
return dominos(_that);case AirwaysParams() when airways != null:
return airways(_that);case WordBoxesParams() when wordBoxes != null:
return wordBoxes(_that);case ArithmeticGridParams() when arithmeticGrid != null:
return arithmeticGrid(_that);case ViewpointParams() when viewpoint != null:
return viewpoint(_that);case CubeNetParams() when cubeNet != null:
return cubeNet(_that);case MultitaskParams() when multitask != null:
return multitask(_that);case P1MathWordProblemsParams() when p1MathWordProblems != null:
return p1MathWordProblems(_that);case P1TangramParams() when p1Tangram != null:
return p1Tangram(_that);case P1AttentionSustainedParams() when p1AttentionSustained != null:
return p1AttentionSustained(_that);case P1ReadingFrParams() when p1ReadingFr != null:
return p1ReadingFr(_that);case P1AnglesParams() when p1Angles != null:
return p1Angles(_that);case P1GeneralEfficiencyParams() when p1GeneralEfficiency != null:
return p1GeneralEfficiency(_that);case P1CountersParams() when p1Counters != null:
return p1Counters(_that);case P1CubeNetsParams() when p1CubeNets != null:
return p1CubeNets(_that);case P1WmReverseSpanParams() when p1WmReverseSpan != null:
return p1WmReverseSpan(_that);case P1WmCalcBackParams() when p1WmCalcBack != null:
return p1WmCalcBack(_that);case P1RavenMatricesParams() when p1RavenMatrices != null:
return p1RavenMatrices(_that);case P1MentalArithmeticParams() when p1MentalArithmetic != null:
return p1MentalArithmetic(_that);case P1PsychomotorParams() when p1Psychomotor != null:
return p1Psychomotor(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)?  nback,TResult Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)?  tubes,TResult Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)?  stimulusResponse,TResult Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)?  paritySequence,TResult Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)?  overlayGrid,TResult Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)?  dominos,TResult Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)?  airways,TResult Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)?  wordBoxes,TResult Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)?  arithmeticGrid,TResult Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)?  viewpoint,TResult Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)?  cubeNet,TResult Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)?  multitask,TResult Function( int count,  P1AnswerMode answerMode,  int maxSteps,  int maxOperand)?  p1MathWordProblems,TResult Function( int count,  int pieceCount,  TangramMode mode)?  p1Tangram,TResult Function( int seriesCount,  int itemsPerSeries,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio,  List<StimulusShape> shapes,  List<StimulusColour> colours)?  p1AttentionSustained,TResult Function( int passageCount,  int questionsPerPassage)?  p1ReadingFr,TResult Function( int setCount,  int optionCount,  int maxCorrect)?  p1Angles,TResult Function( int count)?  p1GeneralEfficiency,TResult Function( int count,  int dialsPerItem)?  p1Counters,TResult Function( int phaseCount,  int netsPerPhase,  CubeNetAlphabet alphabet,  int missingFaces,  bool includeRotationMatching)?  p1CubeNets,TResult Function( int count,  int minDigits,  int maxDigits,  int answerWindowMs)?  p1WmReverseSpan,TResult Function( int stageCount,  int calcsPerStage)?  p1WmCalcBack,TResult Function( int count,  GridSize grid,  int optionCount)?  p1RavenMatrices,TResult Function( int count,  MentalArithmeticAnswerMode answerMode,  int maxOperand)?  p1MentalArithmetic,TResult Function( int phaseCount,  int phaseDurationSec,  int calcIntervalSec)?  p1Psychomotor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case NbackParams() when nback != null:
return nback(_that.n,_that.stimulusKind,_that.paletteSize,_that.count,_that.primers,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio);case TubesParams() when tubes != null:
return tubes(_that.capacities,_that.colourCount,_that.ballCount,_that.minMoves,_that.maxMoves);case StimulusResponseParams() when stimulusResponse != null:
return stimulusResponse(_that.count,_that.stimulusMs,_that.answerWindowMs,_that.keys,_that.shapes,_that.colours,_that.ruleDepth);case ParitySequenceParams() when paritySequence != null:
return paritySequence(_that.numberCount,_that.numberMin,_that.numberMax,_that.restartOnError,_that.labelEnds);case OverlayGridParams() when overlayGrid != null:
return overlayGrid(_that.grid,_that.tileCount,_that.overlapping,_that.blackCells);case DominosParams() when dominos != null:
return dominos(_that.length,_that.layout,_that.ruleCount,_that.answerMode);case AirwaysParams() when airways != null:
return airways(_that.capacity,_that.blueCapacity,_that.zoneCount,_that.routeCount,_that.spawnIntervalMs,_that.durationSec);case WordBoxesParams() when wordBoxes != null:
return wordBoxes(_that.boxCount,_that.wordCount,_that.fieldIds,_that.trapRatio,_that.wordTimeMs);case ArithmeticGridParams() when arithmeticGrid != null:
return arithmeticGrid(_that.grid,_that.wrongMin,_that.wrongMax,_that.operations,_that.maxOperand);case ViewpointParams() when viewpoint != null:
return viewpoint(_that.viewpointCount,_that.objectCount,_that.objectKinds,_that.allowSymmetric);case CubeNetParams() when cubeNet != null:
return cubeNet(_that.missingFaces,_that.distractorFaces,_that.symbolKind,_that.flippable);case MultitaskParams() when multitask != null:
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);case P1MathWordProblemsParams() when p1MathWordProblems != null:
return p1MathWordProblems(_that.count,_that.answerMode,_that.maxSteps,_that.maxOperand);case P1TangramParams() when p1Tangram != null:
return p1Tangram(_that.count,_that.pieceCount,_that.mode);case P1AttentionSustainedParams() when p1AttentionSustained != null:
return p1AttentionSustained(_that.seriesCount,_that.itemsPerSeries,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio,_that.shapes,_that.colours);case P1ReadingFrParams() when p1ReadingFr != null:
return p1ReadingFr(_that.passageCount,_that.questionsPerPassage);case P1AnglesParams() when p1Angles != null:
return p1Angles(_that.setCount,_that.optionCount,_that.maxCorrect);case P1GeneralEfficiencyParams() when p1GeneralEfficiency != null:
return p1GeneralEfficiency(_that.count);case P1CountersParams() when p1Counters != null:
return p1Counters(_that.count,_that.dialsPerItem);case P1CubeNetsParams() when p1CubeNets != null:
return p1CubeNets(_that.phaseCount,_that.netsPerPhase,_that.alphabet,_that.missingFaces,_that.includeRotationMatching);case P1WmReverseSpanParams() when p1WmReverseSpan != null:
return p1WmReverseSpan(_that.count,_that.minDigits,_that.maxDigits,_that.answerWindowMs);case P1WmCalcBackParams() when p1WmCalcBack != null:
return p1WmCalcBack(_that.stageCount,_that.calcsPerStage);case P1RavenMatricesParams() when p1RavenMatrices != null:
return p1RavenMatrices(_that.count,_that.grid,_that.optionCount);case P1MentalArithmeticParams() when p1MentalArithmetic != null:
return p1MentalArithmetic(_that.count,_that.answerMode,_that.maxOperand);case P1PsychomotorParams() when p1Psychomotor != null:
return p1Psychomotor(_that.phaseCount,_that.phaseDurationSec,_that.calcIntervalSec);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)  nback,required TResult Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)  tubes,required TResult Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)  stimulusResponse,required TResult Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)  paritySequence,required TResult Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)  overlayGrid,required TResult Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)  dominos,required TResult Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)  airways,required TResult Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)  wordBoxes,required TResult Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)  arithmeticGrid,required TResult Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)  viewpoint,required TResult Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)  cubeNet,required TResult Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)  multitask,required TResult Function( int count,  P1AnswerMode answerMode,  int maxSteps,  int maxOperand)  p1MathWordProblems,required TResult Function( int count,  int pieceCount,  TangramMode mode)  p1Tangram,required TResult Function( int seriesCount,  int itemsPerSeries,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio,  List<StimulusShape> shapes,  List<StimulusColour> colours)  p1AttentionSustained,required TResult Function( int passageCount,  int questionsPerPassage)  p1ReadingFr,required TResult Function( int setCount,  int optionCount,  int maxCorrect)  p1Angles,required TResult Function( int count)  p1GeneralEfficiency,required TResult Function( int count,  int dialsPerItem)  p1Counters,required TResult Function( int phaseCount,  int netsPerPhase,  CubeNetAlphabet alphabet,  int missingFaces,  bool includeRotationMatching)  p1CubeNets,required TResult Function( int count,  int minDigits,  int maxDigits,  int answerWindowMs)  p1WmReverseSpan,required TResult Function( int stageCount,  int calcsPerStage)  p1WmCalcBack,required TResult Function( int count,  GridSize grid,  int optionCount)  p1RavenMatrices,required TResult Function( int count,  MentalArithmeticAnswerMode answerMode,  int maxOperand)  p1MentalArithmetic,required TResult Function( int phaseCount,  int phaseDurationSec,  int calcIntervalSec)  p1Psychomotor,}) {final _that = this;
switch (_that) {
case NbackParams():
return nback(_that.n,_that.stimulusKind,_that.paletteSize,_that.count,_that.primers,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio);case TubesParams():
return tubes(_that.capacities,_that.colourCount,_that.ballCount,_that.minMoves,_that.maxMoves);case StimulusResponseParams():
return stimulusResponse(_that.count,_that.stimulusMs,_that.answerWindowMs,_that.keys,_that.shapes,_that.colours,_that.ruleDepth);case ParitySequenceParams():
return paritySequence(_that.numberCount,_that.numberMin,_that.numberMax,_that.restartOnError,_that.labelEnds);case OverlayGridParams():
return overlayGrid(_that.grid,_that.tileCount,_that.overlapping,_that.blackCells);case DominosParams():
return dominos(_that.length,_that.layout,_that.ruleCount,_that.answerMode);case AirwaysParams():
return airways(_that.capacity,_that.blueCapacity,_that.zoneCount,_that.routeCount,_that.spawnIntervalMs,_that.durationSec);case WordBoxesParams():
return wordBoxes(_that.boxCount,_that.wordCount,_that.fieldIds,_that.trapRatio,_that.wordTimeMs);case ArithmeticGridParams():
return arithmeticGrid(_that.grid,_that.wrongMin,_that.wrongMax,_that.operations,_that.maxOperand);case ViewpointParams():
return viewpoint(_that.viewpointCount,_that.objectCount,_that.objectKinds,_that.allowSymmetric);case CubeNetParams():
return cubeNet(_that.missingFaces,_that.distractorFaces,_that.symbolKind,_that.flippable);case MultitaskParams():
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);case P1MathWordProblemsParams():
return p1MathWordProblems(_that.count,_that.answerMode,_that.maxSteps,_that.maxOperand);case P1TangramParams():
return p1Tangram(_that.count,_that.pieceCount,_that.mode);case P1AttentionSustainedParams():
return p1AttentionSustained(_that.seriesCount,_that.itemsPerSeries,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio,_that.shapes,_that.colours);case P1ReadingFrParams():
return p1ReadingFr(_that.passageCount,_that.questionsPerPassage);case P1AnglesParams():
return p1Angles(_that.setCount,_that.optionCount,_that.maxCorrect);case P1GeneralEfficiencyParams():
return p1GeneralEfficiency(_that.count);case P1CountersParams():
return p1Counters(_that.count,_that.dialsPerItem);case P1CubeNetsParams():
return p1CubeNets(_that.phaseCount,_that.netsPerPhase,_that.alphabet,_that.missingFaces,_that.includeRotationMatching);case P1WmReverseSpanParams():
return p1WmReverseSpan(_that.count,_that.minDigits,_that.maxDigits,_that.answerWindowMs);case P1WmCalcBackParams():
return p1WmCalcBack(_that.stageCount,_that.calcsPerStage);case P1RavenMatricesParams():
return p1RavenMatrices(_that.count,_that.grid,_that.optionCount);case P1MentalArithmeticParams():
return p1MentalArithmetic(_that.count,_that.answerMode,_that.maxOperand);case P1PsychomotorParams():
return p1Psychomotor(_that.phaseCount,_that.phaseDurationSec,_that.calcIntervalSec);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)?  nback,TResult? Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)?  tubes,TResult? Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)?  stimulusResponse,TResult? Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)?  paritySequence,TResult? Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)?  overlayGrid,TResult? Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)?  dominos,TResult? Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)?  airways,TResult? Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)?  wordBoxes,TResult? Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)?  arithmeticGrid,TResult? Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)?  viewpoint,TResult? Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)?  cubeNet,TResult? Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)?  multitask,TResult? Function( int count,  P1AnswerMode answerMode,  int maxSteps,  int maxOperand)?  p1MathWordProblems,TResult? Function( int count,  int pieceCount,  TangramMode mode)?  p1Tangram,TResult? Function( int seriesCount,  int itemsPerSeries,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio,  List<StimulusShape> shapes,  List<StimulusColour> colours)?  p1AttentionSustained,TResult? Function( int passageCount,  int questionsPerPassage)?  p1ReadingFr,TResult? Function( int setCount,  int optionCount,  int maxCorrect)?  p1Angles,TResult? Function( int count)?  p1GeneralEfficiency,TResult? Function( int count,  int dialsPerItem)?  p1Counters,TResult? Function( int phaseCount,  int netsPerPhase,  CubeNetAlphabet alphabet,  int missingFaces,  bool includeRotationMatching)?  p1CubeNets,TResult? Function( int count,  int minDigits,  int maxDigits,  int answerWindowMs)?  p1WmReverseSpan,TResult? Function( int stageCount,  int calcsPerStage)?  p1WmCalcBack,TResult? Function( int count,  GridSize grid,  int optionCount)?  p1RavenMatrices,TResult? Function( int count,  MentalArithmeticAnswerMode answerMode,  int maxOperand)?  p1MentalArithmetic,TResult? Function( int phaseCount,  int phaseDurationSec,  int calcIntervalSec)?  p1Psychomotor,}) {final _that = this;
switch (_that) {
case NbackParams() when nback != null:
return nback(_that.n,_that.stimulusKind,_that.paletteSize,_that.count,_that.primers,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio);case TubesParams() when tubes != null:
return tubes(_that.capacities,_that.colourCount,_that.ballCount,_that.minMoves,_that.maxMoves);case StimulusResponseParams() when stimulusResponse != null:
return stimulusResponse(_that.count,_that.stimulusMs,_that.answerWindowMs,_that.keys,_that.shapes,_that.colours,_that.ruleDepth);case ParitySequenceParams() when paritySequence != null:
return paritySequence(_that.numberCount,_that.numberMin,_that.numberMax,_that.restartOnError,_that.labelEnds);case OverlayGridParams() when overlayGrid != null:
return overlayGrid(_that.grid,_that.tileCount,_that.overlapping,_that.blackCells);case DominosParams() when dominos != null:
return dominos(_that.length,_that.layout,_that.ruleCount,_that.answerMode);case AirwaysParams() when airways != null:
return airways(_that.capacity,_that.blueCapacity,_that.zoneCount,_that.routeCount,_that.spawnIntervalMs,_that.durationSec);case WordBoxesParams() when wordBoxes != null:
return wordBoxes(_that.boxCount,_that.wordCount,_that.fieldIds,_that.trapRatio,_that.wordTimeMs);case ArithmeticGridParams() when arithmeticGrid != null:
return arithmeticGrid(_that.grid,_that.wrongMin,_that.wrongMax,_that.operations,_that.maxOperand);case ViewpointParams() when viewpoint != null:
return viewpoint(_that.viewpointCount,_that.objectCount,_that.objectKinds,_that.allowSymmetric);case CubeNetParams() when cubeNet != null:
return cubeNet(_that.missingFaces,_that.distractorFaces,_that.symbolKind,_that.flippable);case MultitaskParams() when multitask != null:
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);case P1MathWordProblemsParams() when p1MathWordProblems != null:
return p1MathWordProblems(_that.count,_that.answerMode,_that.maxSteps,_that.maxOperand);case P1TangramParams() when p1Tangram != null:
return p1Tangram(_that.count,_that.pieceCount,_that.mode);case P1AttentionSustainedParams() when p1AttentionSustained != null:
return p1AttentionSustained(_that.seriesCount,_that.itemsPerSeries,_that.stimulusMs,_that.answerWindowMs,_that.targetRatio,_that.lureRatio,_that.shapes,_that.colours);case P1ReadingFrParams() when p1ReadingFr != null:
return p1ReadingFr(_that.passageCount,_that.questionsPerPassage);case P1AnglesParams() when p1Angles != null:
return p1Angles(_that.setCount,_that.optionCount,_that.maxCorrect);case P1GeneralEfficiencyParams() when p1GeneralEfficiency != null:
return p1GeneralEfficiency(_that.count);case P1CountersParams() when p1Counters != null:
return p1Counters(_that.count,_that.dialsPerItem);case P1CubeNetsParams() when p1CubeNets != null:
return p1CubeNets(_that.phaseCount,_that.netsPerPhase,_that.alphabet,_that.missingFaces,_that.includeRotationMatching);case P1WmReverseSpanParams() when p1WmReverseSpan != null:
return p1WmReverseSpan(_that.count,_that.minDigits,_that.maxDigits,_that.answerWindowMs);case P1WmCalcBackParams() when p1WmCalcBack != null:
return p1WmCalcBack(_that.stageCount,_that.calcsPerStage);case P1RavenMatricesParams() when p1RavenMatrices != null:
return p1RavenMatrices(_that.count,_that.grid,_that.optionCount);case P1MentalArithmeticParams() when p1MentalArithmetic != null:
return p1MentalArithmetic(_that.count,_that.answerMode,_that.maxOperand);case P1PsychomotorParams() when p1Psychomotor != null:
return p1Psychomotor(_that.phaseCount,_that.phaseDurationSec,_that.calcIntervalSec);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class NbackParams extends GeneratorParams {
  const NbackParams({this.n = 2, this.stimulusKind = NbackStimulusKind.colour, this.paletteSize = 3, this.count = 42, this.primers = 2, this.stimulusMs = 1000, this.answerWindowMs = 1500, this.targetRatio = 0.3, this.lureRatio = 0.1, final  String? $type}): $type = $type ?? 'nback',super._();
  factory NbackParams.fromJson(Map<String, dynamic> json) => _$NbackParamsFromJson(json);

@JsonKey() final  int n;
@JsonKey() final  NbackStimulusKind stimulusKind;
@JsonKey() final  int paletteSize;
@JsonKey() final  int count;
@JsonKey() final  int primers;
@JsonKey() final  int stimulusMs;
@JsonKey() final  int answerWindowMs;
@JsonKey() final  double targetRatio;
@JsonKey() final  double lureRatio;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NbackParamsCopyWith<NbackParams> get copyWith => _$NbackParamsCopyWithImpl<NbackParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NbackParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NbackParams&&(identical(other.n, n) || other.n == n)&&(identical(other.stimulusKind, stimulusKind) || other.stimulusKind == stimulusKind)&&(identical(other.paletteSize, paletteSize) || other.paletteSize == paletteSize)&&(identical(other.count, count) || other.count == count)&&(identical(other.primers, primers) || other.primers == primers)&&(identical(other.stimulusMs, stimulusMs) || other.stimulusMs == stimulusMs)&&(identical(other.answerWindowMs, answerWindowMs) || other.answerWindowMs == answerWindowMs)&&(identical(other.targetRatio, targetRatio) || other.targetRatio == targetRatio)&&(identical(other.lureRatio, lureRatio) || other.lureRatio == lureRatio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,n,stimulusKind,paletteSize,count,primers,stimulusMs,answerWindowMs,targetRatio,lureRatio);

@override
String toString() {
  return 'GeneratorParams.nback(n: $n, stimulusKind: $stimulusKind, paletteSize: $paletteSize, count: $count, primers: $primers, stimulusMs: $stimulusMs, answerWindowMs: $answerWindowMs, targetRatio: $targetRatio, lureRatio: $lureRatio)';
}


}

/// @nodoc
abstract mixin class $NbackParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $NbackParamsCopyWith(NbackParams value, $Res Function(NbackParams) _then) = _$NbackParamsCopyWithImpl;
@useResult
$Res call({
 int n, NbackStimulusKind stimulusKind, int paletteSize, int count, int primers, int stimulusMs, int answerWindowMs, double targetRatio, double lureRatio
});




}
/// @nodoc
class _$NbackParamsCopyWithImpl<$Res>
    implements $NbackParamsCopyWith<$Res> {
  _$NbackParamsCopyWithImpl(this._self, this._then);

  final NbackParams _self;
  final $Res Function(NbackParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? n = null,Object? stimulusKind = null,Object? paletteSize = null,Object? count = null,Object? primers = null,Object? stimulusMs = null,Object? answerWindowMs = null,Object? targetRatio = null,Object? lureRatio = null,}) {
  return _then(NbackParams(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,stimulusKind: null == stimulusKind ? _self.stimulusKind : stimulusKind // ignore: cast_nullable_to_non_nullable
as NbackStimulusKind,paletteSize: null == paletteSize ? _self.paletteSize : paletteSize // ignore: cast_nullable_to_non_nullable
as int,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,primers: null == primers ? _self.primers : primers // ignore: cast_nullable_to_non_nullable
as int,stimulusMs: null == stimulusMs ? _self.stimulusMs : stimulusMs // ignore: cast_nullable_to_non_nullable
as int,answerWindowMs: null == answerWindowMs ? _self.answerWindowMs : answerWindowMs // ignore: cast_nullable_to_non_nullable
as int,targetRatio: null == targetRatio ? _self.targetRatio : targetRatio // ignore: cast_nullable_to_non_nullable
as double,lureRatio: null == lureRatio ? _self.lureRatio : lureRatio // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class TubesParams extends GeneratorParams {
  const TubesParams({final  List<int> capacities = const <int>[3, 2, 3], this.colourCount = 3, this.ballCount = 5, this.minMoves = 2, this.maxMoves = 8, final  String? $type}): _capacities = capacities,$type = $type ?? 'tubes',super._();
  factory TubesParams.fromJson(Map<String, dynamic> json) => _$TubesParamsFromJson(json);

 final  List<int> _capacities;
@JsonKey() List<int> get capacities {
  if (_capacities is EqualUnmodifiableListView) return _capacities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_capacities);
}

@JsonKey() final  int colourCount;
@JsonKey() final  int ballCount;
@JsonKey() final  int minMoves;
@JsonKey() final  int maxMoves;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TubesParamsCopyWith<TubesParams> get copyWith => _$TubesParamsCopyWithImpl<TubesParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TubesParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TubesParams&&const DeepCollectionEquality().equals(other._capacities, _capacities)&&(identical(other.colourCount, colourCount) || other.colourCount == colourCount)&&(identical(other.ballCount, ballCount) || other.ballCount == ballCount)&&(identical(other.minMoves, minMoves) || other.minMoves == minMoves)&&(identical(other.maxMoves, maxMoves) || other.maxMoves == maxMoves));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_capacities),colourCount,ballCount,minMoves,maxMoves);

@override
String toString() {
  return 'GeneratorParams.tubes(capacities: $capacities, colourCount: $colourCount, ballCount: $ballCount, minMoves: $minMoves, maxMoves: $maxMoves)';
}


}

/// @nodoc
abstract mixin class $TubesParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $TubesParamsCopyWith(TubesParams value, $Res Function(TubesParams) _then) = _$TubesParamsCopyWithImpl;
@useResult
$Res call({
 List<int> capacities, int colourCount, int ballCount, int minMoves, int maxMoves
});




}
/// @nodoc
class _$TubesParamsCopyWithImpl<$Res>
    implements $TubesParamsCopyWith<$Res> {
  _$TubesParamsCopyWithImpl(this._self, this._then);

  final TubesParams _self;
  final $Res Function(TubesParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? capacities = null,Object? colourCount = null,Object? ballCount = null,Object? minMoves = null,Object? maxMoves = null,}) {
  return _then(TubesParams(
capacities: null == capacities ? _self._capacities : capacities // ignore: cast_nullable_to_non_nullable
as List<int>,colourCount: null == colourCount ? _self.colourCount : colourCount // ignore: cast_nullable_to_non_nullable
as int,ballCount: null == ballCount ? _self.ballCount : ballCount // ignore: cast_nullable_to_non_nullable
as int,minMoves: null == minMoves ? _self.minMoves : minMoves // ignore: cast_nullable_to_non_nullable
as int,maxMoves: null == maxMoves ? _self.maxMoves : maxMoves // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StimulusResponseParams extends GeneratorParams {
  const StimulusResponseParams({this.count = 36, this.stimulusMs = 500, this.answerWindowMs = 3000, final  List<String> keys = const <String>['n', 'x'], final  List<StimulusShape> shapes = const <StimulusShape>[StimulusShape.square, StimulusShape.triangle], final  List<StimulusColour> colours = const <StimulusColour>[StimulusColour.blue, StimulusColour.orange], this.ruleDepth = 2, final  String? $type}): _keys = keys,_shapes = shapes,_colours = colours,$type = $type ?? 'stimulus_response',super._();
  factory StimulusResponseParams.fromJson(Map<String, dynamic> json) => _$StimulusResponseParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  int stimulusMs;
@JsonKey() final  int answerWindowMs;
 final  List<String> _keys;
@JsonKey() List<String> get keys {
  if (_keys is EqualUnmodifiableListView) return _keys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_keys);
}

 final  List<StimulusShape> _shapes;
@JsonKey() List<StimulusShape> get shapes {
  if (_shapes is EqualUnmodifiableListView) return _shapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shapes);
}

 final  List<StimulusColour> _colours;
@JsonKey() List<StimulusColour> get colours {
  if (_colours is EqualUnmodifiableListView) return _colours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colours);
}

@JsonKey() final  int ruleDepth;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StimulusResponseParamsCopyWith<StimulusResponseParams> get copyWith => _$StimulusResponseParamsCopyWithImpl<StimulusResponseParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StimulusResponseParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StimulusResponseParams&&(identical(other.count, count) || other.count == count)&&(identical(other.stimulusMs, stimulusMs) || other.stimulusMs == stimulusMs)&&(identical(other.answerWindowMs, answerWindowMs) || other.answerWindowMs == answerWindowMs)&&const DeepCollectionEquality().equals(other._keys, _keys)&&const DeepCollectionEquality().equals(other._shapes, _shapes)&&const DeepCollectionEquality().equals(other._colours, _colours)&&(identical(other.ruleDepth, ruleDepth) || other.ruleDepth == ruleDepth));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,stimulusMs,answerWindowMs,const DeepCollectionEquality().hash(_keys),const DeepCollectionEquality().hash(_shapes),const DeepCollectionEquality().hash(_colours),ruleDepth);

@override
String toString() {
  return 'GeneratorParams.stimulusResponse(count: $count, stimulusMs: $stimulusMs, answerWindowMs: $answerWindowMs, keys: $keys, shapes: $shapes, colours: $colours, ruleDepth: $ruleDepth)';
}


}

/// @nodoc
abstract mixin class $StimulusResponseParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $StimulusResponseParamsCopyWith(StimulusResponseParams value, $Res Function(StimulusResponseParams) _then) = _$StimulusResponseParamsCopyWithImpl;
@useResult
$Res call({
 int count, int stimulusMs, int answerWindowMs, List<String> keys, List<StimulusShape> shapes, List<StimulusColour> colours, int ruleDepth
});




}
/// @nodoc
class _$StimulusResponseParamsCopyWithImpl<$Res>
    implements $StimulusResponseParamsCopyWith<$Res> {
  _$StimulusResponseParamsCopyWithImpl(this._self, this._then);

  final StimulusResponseParams _self;
  final $Res Function(StimulusResponseParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? stimulusMs = null,Object? answerWindowMs = null,Object? keys = null,Object? shapes = null,Object? colours = null,Object? ruleDepth = null,}) {
  return _then(StimulusResponseParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,stimulusMs: null == stimulusMs ? _self.stimulusMs : stimulusMs // ignore: cast_nullable_to_non_nullable
as int,answerWindowMs: null == answerWindowMs ? _self.answerWindowMs : answerWindowMs // ignore: cast_nullable_to_non_nullable
as int,keys: null == keys ? _self._keys : keys // ignore: cast_nullable_to_non_nullable
as List<String>,shapes: null == shapes ? _self._shapes : shapes // ignore: cast_nullable_to_non_nullable
as List<StimulusShape>,colours: null == colours ? _self._colours : colours // ignore: cast_nullable_to_non_nullable
as List<StimulusColour>,ruleDepth: null == ruleDepth ? _self.ruleDepth : ruleDepth // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ParitySequenceParams extends GeneratorParams {
  const ParitySequenceParams({this.numberCount = 16, this.numberMin = 1, this.numberMax = 99, this.restartOnError = true, this.labelEnds = true, final  String? $type}): $type = $type ?? 'parity_sequence',super._();
  factory ParitySequenceParams.fromJson(Map<String, dynamic> json) => _$ParitySequenceParamsFromJson(json);

@JsonKey() final  int numberCount;
@JsonKey() final  int numberMin;
@JsonKey() final  int numberMax;
@JsonKey() final  bool restartOnError;
@JsonKey() final  bool labelEnds;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParitySequenceParamsCopyWith<ParitySequenceParams> get copyWith => _$ParitySequenceParamsCopyWithImpl<ParitySequenceParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParitySequenceParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParitySequenceParams&&(identical(other.numberCount, numberCount) || other.numberCount == numberCount)&&(identical(other.numberMin, numberMin) || other.numberMin == numberMin)&&(identical(other.numberMax, numberMax) || other.numberMax == numberMax)&&(identical(other.restartOnError, restartOnError) || other.restartOnError == restartOnError)&&(identical(other.labelEnds, labelEnds) || other.labelEnds == labelEnds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,numberCount,numberMin,numberMax,restartOnError,labelEnds);

@override
String toString() {
  return 'GeneratorParams.paritySequence(numberCount: $numberCount, numberMin: $numberMin, numberMax: $numberMax, restartOnError: $restartOnError, labelEnds: $labelEnds)';
}


}

/// @nodoc
abstract mixin class $ParitySequenceParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $ParitySequenceParamsCopyWith(ParitySequenceParams value, $Res Function(ParitySequenceParams) _then) = _$ParitySequenceParamsCopyWithImpl;
@useResult
$Res call({
 int numberCount, int numberMin, int numberMax, bool restartOnError, bool labelEnds
});




}
/// @nodoc
class _$ParitySequenceParamsCopyWithImpl<$Res>
    implements $ParitySequenceParamsCopyWith<$Res> {
  _$ParitySequenceParamsCopyWithImpl(this._self, this._then);

  final ParitySequenceParams _self;
  final $Res Function(ParitySequenceParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? numberCount = null,Object? numberMin = null,Object? numberMax = null,Object? restartOnError = null,Object? labelEnds = null,}) {
  return _then(ParitySequenceParams(
numberCount: null == numberCount ? _self.numberCount : numberCount // ignore: cast_nullable_to_non_nullable
as int,numberMin: null == numberMin ? _self.numberMin : numberMin // ignore: cast_nullable_to_non_nullable
as int,numberMax: null == numberMax ? _self.numberMax : numberMax // ignore: cast_nullable_to_non_nullable
as int,restartOnError: null == restartOnError ? _self.restartOnError : restartOnError // ignore: cast_nullable_to_non_nullable
as bool,labelEnds: null == labelEnds ? _self.labelEnds : labelEnds // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class OverlayGridParams extends GeneratorParams {
  const OverlayGridParams({this.grid = const GridSize(rows: 5, cols: 5), this.tileCount = 3, this.overlapping = true, this.blackCells = true, final  String? $type}): $type = $type ?? 'overlay_grid',super._();
  factory OverlayGridParams.fromJson(Map<String, dynamic> json) => _$OverlayGridParamsFromJson(json);

@JsonKey() final  GridSize grid;
@JsonKey() final  int tileCount;
@JsonKey() final  bool overlapping;
@JsonKey() final  bool blackCells;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverlayGridParamsCopyWith<OverlayGridParams> get copyWith => _$OverlayGridParamsCopyWithImpl<OverlayGridParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OverlayGridParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverlayGridParams&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.tileCount, tileCount) || other.tileCount == tileCount)&&(identical(other.overlapping, overlapping) || other.overlapping == overlapping)&&(identical(other.blackCells, blackCells) || other.blackCells == blackCells));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grid,tileCount,overlapping,blackCells);

@override
String toString() {
  return 'GeneratorParams.overlayGrid(grid: $grid, tileCount: $tileCount, overlapping: $overlapping, blackCells: $blackCells)';
}


}

/// @nodoc
abstract mixin class $OverlayGridParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $OverlayGridParamsCopyWith(OverlayGridParams value, $Res Function(OverlayGridParams) _then) = _$OverlayGridParamsCopyWithImpl;
@useResult
$Res call({
 GridSize grid, int tileCount, bool overlapping, bool blackCells
});


$GridSizeCopyWith<$Res> get grid;

}
/// @nodoc
class _$OverlayGridParamsCopyWithImpl<$Res>
    implements $OverlayGridParamsCopyWith<$Res> {
  _$OverlayGridParamsCopyWithImpl(this._self, this._then);

  final OverlayGridParams _self;
  final $Res Function(OverlayGridParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? grid = null,Object? tileCount = null,Object? overlapping = null,Object? blackCells = null,}) {
  return _then(OverlayGridParams(
grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as GridSize,tileCount: null == tileCount ? _self.tileCount : tileCount // ignore: cast_nullable_to_non_nullable
as int,overlapping: null == overlapping ? _self.overlapping : overlapping // ignore: cast_nullable_to_non_nullable
as bool,blackCells: null == blackCells ? _self.blackCells : blackCells // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GridSizeCopyWith<$Res> get grid {
  
  return $GridSizeCopyWith<$Res>(_self.grid, (value) {
    return _then(_self.copyWith(grid: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class DominosParams extends GeneratorParams {
  const DominosParams({this.length = 6, this.layout = DominoLayout.row, this.ruleCount = 1, this.answerMode = DominoAnswerMode.pick, final  String? $type}): $type = $type ?? 'dominos',super._();
  factory DominosParams.fromJson(Map<String, dynamic> json) => _$DominosParamsFromJson(json);

@JsonKey() final  int length;
@JsonKey() final  DominoLayout layout;
@JsonKey() final  int ruleCount;
@JsonKey() final  DominoAnswerMode answerMode;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DominosParamsCopyWith<DominosParams> get copyWith => _$DominosParamsCopyWithImpl<DominosParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DominosParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DominosParams&&(identical(other.length, length) || other.length == length)&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.ruleCount, ruleCount) || other.ruleCount == ruleCount)&&(identical(other.answerMode, answerMode) || other.answerMode == answerMode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,length,layout,ruleCount,answerMode);

@override
String toString() {
  return 'GeneratorParams.dominos(length: $length, layout: $layout, ruleCount: $ruleCount, answerMode: $answerMode)';
}


}

/// @nodoc
abstract mixin class $DominosParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $DominosParamsCopyWith(DominosParams value, $Res Function(DominosParams) _then) = _$DominosParamsCopyWithImpl;
@useResult
$Res call({
 int length, DominoLayout layout, int ruleCount, DominoAnswerMode answerMode
});




}
/// @nodoc
class _$DominosParamsCopyWithImpl<$Res>
    implements $DominosParamsCopyWith<$Res> {
  _$DominosParamsCopyWithImpl(this._self, this._then);

  final DominosParams _self;
  final $Res Function(DominosParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? length = null,Object? layout = null,Object? ruleCount = null,Object? answerMode = null,}) {
  return _then(DominosParams(
length: null == length ? _self.length : length // ignore: cast_nullable_to_non_nullable
as int,layout: null == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as DominoLayout,ruleCount: null == ruleCount ? _self.ruleCount : ruleCount // ignore: cast_nullable_to_non_nullable
as int,answerMode: null == answerMode ? _self.answerMode : answerMode // ignore: cast_nullable_to_non_nullable
as DominoAnswerMode,
  ));
}


}

/// @nodoc
@JsonSerializable()

class AirwaysParams extends GeneratorParams {
  const AirwaysParams({this.capacity = 4, this.blueCapacity = 2, this.zoneCount = 2, this.routeCount = 3, this.spawnIntervalMs = 2500, this.durationSec = 30, final  String? $type}): $type = $type ?? 'airways',super._();
  factory AirwaysParams.fromJson(Map<String, dynamic> json) => _$AirwaysParamsFromJson(json);

@JsonKey() final  int capacity;
@JsonKey() final  int blueCapacity;
@JsonKey() final  int zoneCount;
@JsonKey() final  int routeCount;
@JsonKey() final  int spawnIntervalMs;
@JsonKey() final  int durationSec;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirwaysParamsCopyWith<AirwaysParams> get copyWith => _$AirwaysParamsCopyWithImpl<AirwaysParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirwaysParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirwaysParams&&(identical(other.capacity, capacity) || other.capacity == capacity)&&(identical(other.blueCapacity, blueCapacity) || other.blueCapacity == blueCapacity)&&(identical(other.zoneCount, zoneCount) || other.zoneCount == zoneCount)&&(identical(other.routeCount, routeCount) || other.routeCount == routeCount)&&(identical(other.spawnIntervalMs, spawnIntervalMs) || other.spawnIntervalMs == spawnIntervalMs)&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,capacity,blueCapacity,zoneCount,routeCount,spawnIntervalMs,durationSec);

@override
String toString() {
  return 'GeneratorParams.airways(capacity: $capacity, blueCapacity: $blueCapacity, zoneCount: $zoneCount, routeCount: $routeCount, spawnIntervalMs: $spawnIntervalMs, durationSec: $durationSec)';
}


}

/// @nodoc
abstract mixin class $AirwaysParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $AirwaysParamsCopyWith(AirwaysParams value, $Res Function(AirwaysParams) _then) = _$AirwaysParamsCopyWithImpl;
@useResult
$Res call({
 int capacity, int blueCapacity, int zoneCount, int routeCount, int spawnIntervalMs, int durationSec
});




}
/// @nodoc
class _$AirwaysParamsCopyWithImpl<$Res>
    implements $AirwaysParamsCopyWith<$Res> {
  _$AirwaysParamsCopyWithImpl(this._self, this._then);

  final AirwaysParams _self;
  final $Res Function(AirwaysParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? capacity = null,Object? blueCapacity = null,Object? zoneCount = null,Object? routeCount = null,Object? spawnIntervalMs = null,Object? durationSec = null,}) {
  return _then(AirwaysParams(
capacity: null == capacity ? _self.capacity : capacity // ignore: cast_nullable_to_non_nullable
as int,blueCapacity: null == blueCapacity ? _self.blueCapacity : blueCapacity // ignore: cast_nullable_to_non_nullable
as int,zoneCount: null == zoneCount ? _self.zoneCount : zoneCount // ignore: cast_nullable_to_non_nullable
as int,routeCount: null == routeCount ? _self.routeCount : routeCount // ignore: cast_nullable_to_non_nullable
as int,spawnIntervalMs: null == spawnIntervalMs ? _self.spawnIntervalMs : spawnIntervalMs // ignore: cast_nullable_to_non_nullable
as int,durationSec: null == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class WordBoxesParams extends GeneratorParams {
  const WordBoxesParams({this.boxCount = 5, this.wordCount = 20, final  List<String>? fieldIds, this.trapRatio = 0.1, this.wordTimeMs = 3000, final  String? $type}): _fieldIds = fieldIds,$type = $type ?? 'word_boxes',super._();
  factory WordBoxesParams.fromJson(Map<String, dynamic> json) => _$WordBoxesParamsFromJson(json);

@JsonKey() final  int boxCount;
@JsonKey() final  int wordCount;
 final  List<String>? _fieldIds;
 List<String>? get fieldIds {
  final value = _fieldIds;
  if (value == null) return null;
  if (_fieldIds is EqualUnmodifiableListView) return _fieldIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@JsonKey() final  double trapRatio;
@JsonKey() final  int wordTimeMs;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordBoxesParamsCopyWith<WordBoxesParams> get copyWith => _$WordBoxesParamsCopyWithImpl<WordBoxesParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordBoxesParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordBoxesParams&&(identical(other.boxCount, boxCount) || other.boxCount == boxCount)&&(identical(other.wordCount, wordCount) || other.wordCount == wordCount)&&const DeepCollectionEquality().equals(other._fieldIds, _fieldIds)&&(identical(other.trapRatio, trapRatio) || other.trapRatio == trapRatio)&&(identical(other.wordTimeMs, wordTimeMs) || other.wordTimeMs == wordTimeMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,boxCount,wordCount,const DeepCollectionEquality().hash(_fieldIds),trapRatio,wordTimeMs);

@override
String toString() {
  return 'GeneratorParams.wordBoxes(boxCount: $boxCount, wordCount: $wordCount, fieldIds: $fieldIds, trapRatio: $trapRatio, wordTimeMs: $wordTimeMs)';
}


}

/// @nodoc
abstract mixin class $WordBoxesParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $WordBoxesParamsCopyWith(WordBoxesParams value, $Res Function(WordBoxesParams) _then) = _$WordBoxesParamsCopyWithImpl;
@useResult
$Res call({
 int boxCount, int wordCount, List<String>? fieldIds, double trapRatio, int wordTimeMs
});




}
/// @nodoc
class _$WordBoxesParamsCopyWithImpl<$Res>
    implements $WordBoxesParamsCopyWith<$Res> {
  _$WordBoxesParamsCopyWithImpl(this._self, this._then);

  final WordBoxesParams _self;
  final $Res Function(WordBoxesParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? boxCount = null,Object? wordCount = null,Object? fieldIds = freezed,Object? trapRatio = null,Object? wordTimeMs = null,}) {
  return _then(WordBoxesParams(
boxCount: null == boxCount ? _self.boxCount : boxCount // ignore: cast_nullable_to_non_nullable
as int,wordCount: null == wordCount ? _self.wordCount : wordCount // ignore: cast_nullable_to_non_nullable
as int,fieldIds: freezed == fieldIds ? _self._fieldIds : fieldIds // ignore: cast_nullable_to_non_nullable
as List<String>?,trapRatio: null == trapRatio ? _self.trapRatio : trapRatio // ignore: cast_nullable_to_non_nullable
as double,wordTimeMs: null == wordTimeMs ? _self.wordTimeMs : wordTimeMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ArithmeticGridParams extends GeneratorParams {
  const ArithmeticGridParams({this.grid = const GridSize(rows: 3, cols: 3), this.wrongMin = 0, this.wrongMax = 4, final  List<ArithmeticOperation> operations = const <ArithmeticOperation>[ArithmeticOperation.add, ArithmeticOperation.sub, ArithmeticOperation.mul, ArithmeticOperation.div, ArithmeticOperation.square, ArithmeticOperation.priority], this.maxOperand = 100, final  String? $type}): _operations = operations,$type = $type ?? 'arithmetic_grid',super._();
  factory ArithmeticGridParams.fromJson(Map<String, dynamic> json) => _$ArithmeticGridParamsFromJson(json);

@JsonKey() final  GridSize grid;
@JsonKey() final  int wrongMin;
@JsonKey() final  int wrongMax;
 final  List<ArithmeticOperation> _operations;
@JsonKey() List<ArithmeticOperation> get operations {
  if (_operations is EqualUnmodifiableListView) return _operations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_operations);
}

@JsonKey() final  int maxOperand;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArithmeticGridParamsCopyWith<ArithmeticGridParams> get copyWith => _$ArithmeticGridParamsCopyWithImpl<ArithmeticGridParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArithmeticGridParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArithmeticGridParams&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.wrongMin, wrongMin) || other.wrongMin == wrongMin)&&(identical(other.wrongMax, wrongMax) || other.wrongMax == wrongMax)&&const DeepCollectionEquality().equals(other._operations, _operations)&&(identical(other.maxOperand, maxOperand) || other.maxOperand == maxOperand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,grid,wrongMin,wrongMax,const DeepCollectionEquality().hash(_operations),maxOperand);

@override
String toString() {
  return 'GeneratorParams.arithmeticGrid(grid: $grid, wrongMin: $wrongMin, wrongMax: $wrongMax, operations: $operations, maxOperand: $maxOperand)';
}


}

/// @nodoc
abstract mixin class $ArithmeticGridParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $ArithmeticGridParamsCopyWith(ArithmeticGridParams value, $Res Function(ArithmeticGridParams) _then) = _$ArithmeticGridParamsCopyWithImpl;
@useResult
$Res call({
 GridSize grid, int wrongMin, int wrongMax, List<ArithmeticOperation> operations, int maxOperand
});


$GridSizeCopyWith<$Res> get grid;

}
/// @nodoc
class _$ArithmeticGridParamsCopyWithImpl<$Res>
    implements $ArithmeticGridParamsCopyWith<$Res> {
  _$ArithmeticGridParamsCopyWithImpl(this._self, this._then);

  final ArithmeticGridParams _self;
  final $Res Function(ArithmeticGridParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? grid = null,Object? wrongMin = null,Object? wrongMax = null,Object? operations = null,Object? maxOperand = null,}) {
  return _then(ArithmeticGridParams(
grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as GridSize,wrongMin: null == wrongMin ? _self.wrongMin : wrongMin // ignore: cast_nullable_to_non_nullable
as int,wrongMax: null == wrongMax ? _self.wrongMax : wrongMax // ignore: cast_nullable_to_non_nullable
as int,operations: null == operations ? _self._operations : operations // ignore: cast_nullable_to_non_nullable
as List<ArithmeticOperation>,maxOperand: null == maxOperand ? _self.maxOperand : maxOperand // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GridSizeCopyWith<$Res> get grid {
  
  return $GridSizeCopyWith<$Res>(_self.grid, (value) {
    return _then(_self.copyWith(grid: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class ViewpointParams extends GeneratorParams {
  const ViewpointParams({this.viewpointCount = 8, this.objectCount = 4, final  List<SolidKind> objectKinds = const <SolidKind>[SolidKind.cube, SolidKind.cylinder, SolidKind.cone], this.allowSymmetric = false, final  String? $type}): _objectKinds = objectKinds,$type = $type ?? 'viewpoint',super._();
  factory ViewpointParams.fromJson(Map<String, dynamic> json) => _$ViewpointParamsFromJson(json);

@JsonKey() final  int viewpointCount;
@JsonKey() final  int objectCount;
 final  List<SolidKind> _objectKinds;
@JsonKey() List<SolidKind> get objectKinds {
  if (_objectKinds is EqualUnmodifiableListView) return _objectKinds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objectKinds);
}

@JsonKey() final  bool allowSymmetric;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ViewpointParamsCopyWith<ViewpointParams> get copyWith => _$ViewpointParamsCopyWithImpl<ViewpointParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ViewpointParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ViewpointParams&&(identical(other.viewpointCount, viewpointCount) || other.viewpointCount == viewpointCount)&&(identical(other.objectCount, objectCount) || other.objectCount == objectCount)&&const DeepCollectionEquality().equals(other._objectKinds, _objectKinds)&&(identical(other.allowSymmetric, allowSymmetric) || other.allowSymmetric == allowSymmetric));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,viewpointCount,objectCount,const DeepCollectionEquality().hash(_objectKinds),allowSymmetric);

@override
String toString() {
  return 'GeneratorParams.viewpoint(viewpointCount: $viewpointCount, objectCount: $objectCount, objectKinds: $objectKinds, allowSymmetric: $allowSymmetric)';
}


}

/// @nodoc
abstract mixin class $ViewpointParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $ViewpointParamsCopyWith(ViewpointParams value, $Res Function(ViewpointParams) _then) = _$ViewpointParamsCopyWithImpl;
@useResult
$Res call({
 int viewpointCount, int objectCount, List<SolidKind> objectKinds, bool allowSymmetric
});




}
/// @nodoc
class _$ViewpointParamsCopyWithImpl<$Res>
    implements $ViewpointParamsCopyWith<$Res> {
  _$ViewpointParamsCopyWithImpl(this._self, this._then);

  final ViewpointParams _self;
  final $Res Function(ViewpointParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? viewpointCount = null,Object? objectCount = null,Object? objectKinds = null,Object? allowSymmetric = null,}) {
  return _then(ViewpointParams(
viewpointCount: null == viewpointCount ? _self.viewpointCount : viewpointCount // ignore: cast_nullable_to_non_nullable
as int,objectCount: null == objectCount ? _self.objectCount : objectCount // ignore: cast_nullable_to_non_nullable
as int,objectKinds: null == objectKinds ? _self._objectKinds : objectKinds // ignore: cast_nullable_to_non_nullable
as List<SolidKind>,allowSymmetric: null == allowSymmetric ? _self.allowSymmetric : allowSymmetric // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class CubeNetParams extends GeneratorParams {
  const CubeNetParams({this.missingFaces = 2, this.distractorFaces = 2, this.symbolKind = CubeSymbolKind.letters, this.flippable = true, final  String? $type}): $type = $type ?? 'cube_net',super._();
  factory CubeNetParams.fromJson(Map<String, dynamic> json) => _$CubeNetParamsFromJson(json);

@JsonKey() final  int missingFaces;
@JsonKey() final  int distractorFaces;
@JsonKey() final  CubeSymbolKind symbolKind;
@JsonKey() final  bool flippable;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CubeNetParamsCopyWith<CubeNetParams> get copyWith => _$CubeNetParamsCopyWithImpl<CubeNetParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CubeNetParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CubeNetParams&&(identical(other.missingFaces, missingFaces) || other.missingFaces == missingFaces)&&(identical(other.distractorFaces, distractorFaces) || other.distractorFaces == distractorFaces)&&(identical(other.symbolKind, symbolKind) || other.symbolKind == symbolKind)&&(identical(other.flippable, flippable) || other.flippable == flippable));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,missingFaces,distractorFaces,symbolKind,flippable);

@override
String toString() {
  return 'GeneratorParams.cubeNet(missingFaces: $missingFaces, distractorFaces: $distractorFaces, symbolKind: $symbolKind, flippable: $flippable)';
}


}

/// @nodoc
abstract mixin class $CubeNetParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $CubeNetParamsCopyWith(CubeNetParams value, $Res Function(CubeNetParams) _then) = _$CubeNetParamsCopyWithImpl;
@useResult
$Res call({
 int missingFaces, int distractorFaces, CubeSymbolKind symbolKind, bool flippable
});




}
/// @nodoc
class _$CubeNetParamsCopyWithImpl<$Res>
    implements $CubeNetParamsCopyWith<$Res> {
  _$CubeNetParamsCopyWithImpl(this._self, this._then);

  final CubeNetParams _self;
  final $Res Function(CubeNetParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? missingFaces = null,Object? distractorFaces = null,Object? symbolKind = null,Object? flippable = null,}) {
  return _then(CubeNetParams(
missingFaces: null == missingFaces ? _self.missingFaces : missingFaces // ignore: cast_nullable_to_non_nullable
as int,distractorFaces: null == distractorFaces ? _self.distractorFaces : distractorFaces // ignore: cast_nullable_to_non_nullable
as int,symbolKind: null == symbolKind ? _self.symbolKind : symbolKind // ignore: cast_nullable_to_non_nullable
as CubeSymbolKind,flippable: null == flippable ? _self.flippable : flippable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MultitaskParams extends GeneratorParams {
  const MultitaskParams({this.durationSec = 300, this.trackingSpeed = 1.0, this.trackingNoise = 1.0, this.shapeIntervalMs = 2000, this.calcIntervalMs = 4000, this.shapeTargetRatio = 0.3, this.calcWrongRatio = 0.4, this.shapeKey = 'space', this.calcKey = 'f', final  String? $type}): $type = $type ?? 'multitask',super._();
  factory MultitaskParams.fromJson(Map<String, dynamic> json) => _$MultitaskParamsFromJson(json);

@JsonKey() final  int durationSec;
@JsonKey() final  double trackingSpeed;
@JsonKey() final  double trackingNoise;
@JsonKey() final  int shapeIntervalMs;
@JsonKey() final  int calcIntervalMs;
@JsonKey() final  double shapeTargetRatio;
@JsonKey() final  double calcWrongRatio;
@JsonKey() final  String shapeKey;
@JsonKey() final  String calcKey;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MultitaskParamsCopyWith<MultitaskParams> get copyWith => _$MultitaskParamsCopyWithImpl<MultitaskParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MultitaskParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MultitaskParams&&(identical(other.durationSec, durationSec) || other.durationSec == durationSec)&&(identical(other.trackingSpeed, trackingSpeed) || other.trackingSpeed == trackingSpeed)&&(identical(other.trackingNoise, trackingNoise) || other.trackingNoise == trackingNoise)&&(identical(other.shapeIntervalMs, shapeIntervalMs) || other.shapeIntervalMs == shapeIntervalMs)&&(identical(other.calcIntervalMs, calcIntervalMs) || other.calcIntervalMs == calcIntervalMs)&&(identical(other.shapeTargetRatio, shapeTargetRatio) || other.shapeTargetRatio == shapeTargetRatio)&&(identical(other.calcWrongRatio, calcWrongRatio) || other.calcWrongRatio == calcWrongRatio)&&(identical(other.shapeKey, shapeKey) || other.shapeKey == shapeKey)&&(identical(other.calcKey, calcKey) || other.calcKey == calcKey));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,durationSec,trackingSpeed,trackingNoise,shapeIntervalMs,calcIntervalMs,shapeTargetRatio,calcWrongRatio,shapeKey,calcKey);

@override
String toString() {
  return 'GeneratorParams.multitask(durationSec: $durationSec, trackingSpeed: $trackingSpeed, trackingNoise: $trackingNoise, shapeIntervalMs: $shapeIntervalMs, calcIntervalMs: $calcIntervalMs, shapeTargetRatio: $shapeTargetRatio, calcWrongRatio: $calcWrongRatio, shapeKey: $shapeKey, calcKey: $calcKey)';
}


}

/// @nodoc
abstract mixin class $MultitaskParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $MultitaskParamsCopyWith(MultitaskParams value, $Res Function(MultitaskParams) _then) = _$MultitaskParamsCopyWithImpl;
@useResult
$Res call({
 int durationSec, double trackingSpeed, double trackingNoise, int shapeIntervalMs, int calcIntervalMs, double shapeTargetRatio, double calcWrongRatio, String shapeKey, String calcKey
});




}
/// @nodoc
class _$MultitaskParamsCopyWithImpl<$Res>
    implements $MultitaskParamsCopyWith<$Res> {
  _$MultitaskParamsCopyWithImpl(this._self, this._then);

  final MultitaskParams _self;
  final $Res Function(MultitaskParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? durationSec = null,Object? trackingSpeed = null,Object? trackingNoise = null,Object? shapeIntervalMs = null,Object? calcIntervalMs = null,Object? shapeTargetRatio = null,Object? calcWrongRatio = null,Object? shapeKey = null,Object? calcKey = null,}) {
  return _then(MultitaskParams(
durationSec: null == durationSec ? _self.durationSec : durationSec // ignore: cast_nullable_to_non_nullable
as int,trackingSpeed: null == trackingSpeed ? _self.trackingSpeed : trackingSpeed // ignore: cast_nullable_to_non_nullable
as double,trackingNoise: null == trackingNoise ? _self.trackingNoise : trackingNoise // ignore: cast_nullable_to_non_nullable
as double,shapeIntervalMs: null == shapeIntervalMs ? _self.shapeIntervalMs : shapeIntervalMs // ignore: cast_nullable_to_non_nullable
as int,calcIntervalMs: null == calcIntervalMs ? _self.calcIntervalMs : calcIntervalMs // ignore: cast_nullable_to_non_nullable
as int,shapeTargetRatio: null == shapeTargetRatio ? _self.shapeTargetRatio : shapeTargetRatio // ignore: cast_nullable_to_non_nullable
as double,calcWrongRatio: null == calcWrongRatio ? _self.calcWrongRatio : calcWrongRatio // ignore: cast_nullable_to_non_nullable
as double,shapeKey: null == shapeKey ? _self.shapeKey : shapeKey // ignore: cast_nullable_to_non_nullable
as String,calcKey: null == calcKey ? _self.calcKey : calcKey // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1MathWordProblemsParams extends GeneratorParams {
  const P1MathWordProblemsParams({this.count = 30, this.answerMode = P1AnswerMode.mcq, this.maxSteps = 3, this.maxOperand = 100, final  String? $type}): $type = $type ?? 'p1_math_word_problems',super._();
  factory P1MathWordProblemsParams.fromJson(Map<String, dynamic> json) => _$P1MathWordProblemsParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  P1AnswerMode answerMode;
@JsonKey() final  int maxSteps;
@JsonKey() final  int maxOperand;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1MathWordProblemsParamsCopyWith<P1MathWordProblemsParams> get copyWith => _$P1MathWordProblemsParamsCopyWithImpl<P1MathWordProblemsParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1MathWordProblemsParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1MathWordProblemsParams&&(identical(other.count, count) || other.count == count)&&(identical(other.answerMode, answerMode) || other.answerMode == answerMode)&&(identical(other.maxSteps, maxSteps) || other.maxSteps == maxSteps)&&(identical(other.maxOperand, maxOperand) || other.maxOperand == maxOperand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,answerMode,maxSteps,maxOperand);

@override
String toString() {
  return 'GeneratorParams.p1MathWordProblems(count: $count, answerMode: $answerMode, maxSteps: $maxSteps, maxOperand: $maxOperand)';
}


}

/// @nodoc
abstract mixin class $P1MathWordProblemsParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1MathWordProblemsParamsCopyWith(P1MathWordProblemsParams value, $Res Function(P1MathWordProblemsParams) _then) = _$P1MathWordProblemsParamsCopyWithImpl;
@useResult
$Res call({
 int count, P1AnswerMode answerMode, int maxSteps, int maxOperand
});




}
/// @nodoc
class _$P1MathWordProblemsParamsCopyWithImpl<$Res>
    implements $P1MathWordProblemsParamsCopyWith<$Res> {
  _$P1MathWordProblemsParamsCopyWithImpl(this._self, this._then);

  final P1MathWordProblemsParams _self;
  final $Res Function(P1MathWordProblemsParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? answerMode = null,Object? maxSteps = null,Object? maxOperand = null,}) {
  return _then(P1MathWordProblemsParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,answerMode: null == answerMode ? _self.answerMode : answerMode // ignore: cast_nullable_to_non_nullable
as P1AnswerMode,maxSteps: null == maxSteps ? _self.maxSteps : maxSteps // ignore: cast_nullable_to_non_nullable
as int,maxOperand: null == maxOperand ? _self.maxOperand : maxOperand // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1TangramParams extends GeneratorParams {
  const P1TangramParams({this.count = 24, this.pieceCount = 7, this.mode = TangramMode.compose, final  String? $type}): $type = $type ?? 'p1_tangram',super._();
  factory P1TangramParams.fromJson(Map<String, dynamic> json) => _$P1TangramParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  int pieceCount;
@JsonKey() final  TangramMode mode;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1TangramParamsCopyWith<P1TangramParams> get copyWith => _$P1TangramParamsCopyWithImpl<P1TangramParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1TangramParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1TangramParams&&(identical(other.count, count) || other.count == count)&&(identical(other.pieceCount, pieceCount) || other.pieceCount == pieceCount)&&(identical(other.mode, mode) || other.mode == mode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,pieceCount,mode);

@override
String toString() {
  return 'GeneratorParams.p1Tangram(count: $count, pieceCount: $pieceCount, mode: $mode)';
}


}

/// @nodoc
abstract mixin class $P1TangramParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1TangramParamsCopyWith(P1TangramParams value, $Res Function(P1TangramParams) _then) = _$P1TangramParamsCopyWithImpl;
@useResult
$Res call({
 int count, int pieceCount, TangramMode mode
});




}
/// @nodoc
class _$P1TangramParamsCopyWithImpl<$Res>
    implements $P1TangramParamsCopyWith<$Res> {
  _$P1TangramParamsCopyWithImpl(this._self, this._then);

  final P1TangramParams _self;
  final $Res Function(P1TangramParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? pieceCount = null,Object? mode = null,}) {
  return _then(P1TangramParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,pieceCount: null == pieceCount ? _self.pieceCount : pieceCount // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as TangramMode,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1AttentionSustainedParams extends GeneratorParams {
  const P1AttentionSustainedParams({this.seriesCount = 3, this.itemsPerSeries = 5, this.stimulusMs = 500, this.answerWindowMs = 3000, this.targetRatio = 0.2, this.lureRatio = 0.2, final  List<StimulusShape> shapes = const <StimulusShape>[StimulusShape.square, StimulusShape.triangle, StimulusShape.circle, StimulusShape.diamond], final  List<StimulusColour> colours = const <StimulusColour>[StimulusColour.blue, StimulusColour.red, StimulusColour.green, StimulusColour.yellow], final  String? $type}): _shapes = shapes,_colours = colours,$type = $type ?? 'p1_attention_sustained',super._();
  factory P1AttentionSustainedParams.fromJson(Map<String, dynamic> json) => _$P1AttentionSustainedParamsFromJson(json);

@JsonKey() final  int seriesCount;
@JsonKey() final  int itemsPerSeries;
@JsonKey() final  int stimulusMs;
@JsonKey() final  int answerWindowMs;
@JsonKey() final  double targetRatio;
@JsonKey() final  double lureRatio;
 final  List<StimulusShape> _shapes;
@JsonKey() List<StimulusShape> get shapes {
  if (_shapes is EqualUnmodifiableListView) return _shapes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shapes);
}

 final  List<StimulusColour> _colours;
@JsonKey() List<StimulusColour> get colours {
  if (_colours is EqualUnmodifiableListView) return _colours;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_colours);
}


@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1AttentionSustainedParamsCopyWith<P1AttentionSustainedParams> get copyWith => _$P1AttentionSustainedParamsCopyWithImpl<P1AttentionSustainedParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1AttentionSustainedParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1AttentionSustainedParams&&(identical(other.seriesCount, seriesCount) || other.seriesCount == seriesCount)&&(identical(other.itemsPerSeries, itemsPerSeries) || other.itemsPerSeries == itemsPerSeries)&&(identical(other.stimulusMs, stimulusMs) || other.stimulusMs == stimulusMs)&&(identical(other.answerWindowMs, answerWindowMs) || other.answerWindowMs == answerWindowMs)&&(identical(other.targetRatio, targetRatio) || other.targetRatio == targetRatio)&&(identical(other.lureRatio, lureRatio) || other.lureRatio == lureRatio)&&const DeepCollectionEquality().equals(other._shapes, _shapes)&&const DeepCollectionEquality().equals(other._colours, _colours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,seriesCount,itemsPerSeries,stimulusMs,answerWindowMs,targetRatio,lureRatio,const DeepCollectionEquality().hash(_shapes),const DeepCollectionEquality().hash(_colours));

@override
String toString() {
  return 'GeneratorParams.p1AttentionSustained(seriesCount: $seriesCount, itemsPerSeries: $itemsPerSeries, stimulusMs: $stimulusMs, answerWindowMs: $answerWindowMs, targetRatio: $targetRatio, lureRatio: $lureRatio, shapes: $shapes, colours: $colours)';
}


}

/// @nodoc
abstract mixin class $P1AttentionSustainedParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1AttentionSustainedParamsCopyWith(P1AttentionSustainedParams value, $Res Function(P1AttentionSustainedParams) _then) = _$P1AttentionSustainedParamsCopyWithImpl;
@useResult
$Res call({
 int seriesCount, int itemsPerSeries, int stimulusMs, int answerWindowMs, double targetRatio, double lureRatio, List<StimulusShape> shapes, List<StimulusColour> colours
});




}
/// @nodoc
class _$P1AttentionSustainedParamsCopyWithImpl<$Res>
    implements $P1AttentionSustainedParamsCopyWith<$Res> {
  _$P1AttentionSustainedParamsCopyWithImpl(this._self, this._then);

  final P1AttentionSustainedParams _self;
  final $Res Function(P1AttentionSustainedParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? seriesCount = null,Object? itemsPerSeries = null,Object? stimulusMs = null,Object? answerWindowMs = null,Object? targetRatio = null,Object? lureRatio = null,Object? shapes = null,Object? colours = null,}) {
  return _then(P1AttentionSustainedParams(
seriesCount: null == seriesCount ? _self.seriesCount : seriesCount // ignore: cast_nullable_to_non_nullable
as int,itemsPerSeries: null == itemsPerSeries ? _self.itemsPerSeries : itemsPerSeries // ignore: cast_nullable_to_non_nullable
as int,stimulusMs: null == stimulusMs ? _self.stimulusMs : stimulusMs // ignore: cast_nullable_to_non_nullable
as int,answerWindowMs: null == answerWindowMs ? _self.answerWindowMs : answerWindowMs // ignore: cast_nullable_to_non_nullable
as int,targetRatio: null == targetRatio ? _self.targetRatio : targetRatio // ignore: cast_nullable_to_non_nullable
as double,lureRatio: null == lureRatio ? _self.lureRatio : lureRatio // ignore: cast_nullable_to_non_nullable
as double,shapes: null == shapes ? _self._shapes : shapes // ignore: cast_nullable_to_non_nullable
as List<StimulusShape>,colours: null == colours ? _self._colours : colours // ignore: cast_nullable_to_non_nullable
as List<StimulusColour>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1ReadingFrParams extends GeneratorParams {
  const P1ReadingFrParams({this.passageCount = 10, this.questionsPerPassage = 1, final  String? $type}): $type = $type ?? 'p1_reading_fr',super._();
  factory P1ReadingFrParams.fromJson(Map<String, dynamic> json) => _$P1ReadingFrParamsFromJson(json);

@JsonKey() final  int passageCount;
@JsonKey() final  int questionsPerPassage;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1ReadingFrParamsCopyWith<P1ReadingFrParams> get copyWith => _$P1ReadingFrParamsCopyWithImpl<P1ReadingFrParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1ReadingFrParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1ReadingFrParams&&(identical(other.passageCount, passageCount) || other.passageCount == passageCount)&&(identical(other.questionsPerPassage, questionsPerPassage) || other.questionsPerPassage == questionsPerPassage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,passageCount,questionsPerPassage);

@override
String toString() {
  return 'GeneratorParams.p1ReadingFr(passageCount: $passageCount, questionsPerPassage: $questionsPerPassage)';
}


}

/// @nodoc
abstract mixin class $P1ReadingFrParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1ReadingFrParamsCopyWith(P1ReadingFrParams value, $Res Function(P1ReadingFrParams) _then) = _$P1ReadingFrParamsCopyWithImpl;
@useResult
$Res call({
 int passageCount, int questionsPerPassage
});




}
/// @nodoc
class _$P1ReadingFrParamsCopyWithImpl<$Res>
    implements $P1ReadingFrParamsCopyWith<$Res> {
  _$P1ReadingFrParamsCopyWithImpl(this._self, this._then);

  final P1ReadingFrParams _self;
  final $Res Function(P1ReadingFrParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? passageCount = null,Object? questionsPerPassage = null,}) {
  return _then(P1ReadingFrParams(
passageCount: null == passageCount ? _self.passageCount : passageCount // ignore: cast_nullable_to_non_nullable
as int,questionsPerPassage: null == questionsPerPassage ? _self.questionsPerPassage : questionsPerPassage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1AnglesParams extends GeneratorParams {
  const P1AnglesParams({this.setCount = 3, this.optionCount = 9, this.maxCorrect = 4, final  String? $type}): $type = $type ?? 'p1_angles',super._();
  factory P1AnglesParams.fromJson(Map<String, dynamic> json) => _$P1AnglesParamsFromJson(json);

@JsonKey() final  int setCount;
@JsonKey() final  int optionCount;
@JsonKey() final  int maxCorrect;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1AnglesParamsCopyWith<P1AnglesParams> get copyWith => _$P1AnglesParamsCopyWithImpl<P1AnglesParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1AnglesParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1AnglesParams&&(identical(other.setCount, setCount) || other.setCount == setCount)&&(identical(other.optionCount, optionCount) || other.optionCount == optionCount)&&(identical(other.maxCorrect, maxCorrect) || other.maxCorrect == maxCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,setCount,optionCount,maxCorrect);

@override
String toString() {
  return 'GeneratorParams.p1Angles(setCount: $setCount, optionCount: $optionCount, maxCorrect: $maxCorrect)';
}


}

/// @nodoc
abstract mixin class $P1AnglesParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1AnglesParamsCopyWith(P1AnglesParams value, $Res Function(P1AnglesParams) _then) = _$P1AnglesParamsCopyWithImpl;
@useResult
$Res call({
 int setCount, int optionCount, int maxCorrect
});




}
/// @nodoc
class _$P1AnglesParamsCopyWithImpl<$Res>
    implements $P1AnglesParamsCopyWith<$Res> {
  _$P1AnglesParamsCopyWithImpl(this._self, this._then);

  final P1AnglesParams _self;
  final $Res Function(P1AnglesParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? setCount = null,Object? optionCount = null,Object? maxCorrect = null,}) {
  return _then(P1AnglesParams(
setCount: null == setCount ? _self.setCount : setCount // ignore: cast_nullable_to_non_nullable
as int,optionCount: null == optionCount ? _self.optionCount : optionCount // ignore: cast_nullable_to_non_nullable
as int,maxCorrect: null == maxCorrect ? _self.maxCorrect : maxCorrect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1GeneralEfficiencyParams extends GeneratorParams {
  const P1GeneralEfficiencyParams({this.count = 35, final  String? $type}): $type = $type ?? 'p1_general_efficiency',super._();
  factory P1GeneralEfficiencyParams.fromJson(Map<String, dynamic> json) => _$P1GeneralEfficiencyParamsFromJson(json);

@JsonKey() final  int count;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1GeneralEfficiencyParamsCopyWith<P1GeneralEfficiencyParams> get copyWith => _$P1GeneralEfficiencyParamsCopyWithImpl<P1GeneralEfficiencyParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1GeneralEfficiencyParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1GeneralEfficiencyParams&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count);

@override
String toString() {
  return 'GeneratorParams.p1GeneralEfficiency(count: $count)';
}


}

/// @nodoc
abstract mixin class $P1GeneralEfficiencyParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1GeneralEfficiencyParamsCopyWith(P1GeneralEfficiencyParams value, $Res Function(P1GeneralEfficiencyParams) _then) = _$P1GeneralEfficiencyParamsCopyWithImpl;
@useResult
$Res call({
 int count
});




}
/// @nodoc
class _$P1GeneralEfficiencyParamsCopyWithImpl<$Res>
    implements $P1GeneralEfficiencyParamsCopyWith<$Res> {
  _$P1GeneralEfficiencyParamsCopyWithImpl(this._self, this._then);

  final P1GeneralEfficiencyParams _self;
  final $Res Function(P1GeneralEfficiencyParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,}) {
  return _then(P1GeneralEfficiencyParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1CountersParams extends GeneratorParams {
  const P1CountersParams({this.count = 10, this.dialsPerItem = 3, final  String? $type}): $type = $type ?? 'p1_counters',super._();
  factory P1CountersParams.fromJson(Map<String, dynamic> json) => _$P1CountersParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  int dialsPerItem;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1CountersParamsCopyWith<P1CountersParams> get copyWith => _$P1CountersParamsCopyWithImpl<P1CountersParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1CountersParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1CountersParams&&(identical(other.count, count) || other.count == count)&&(identical(other.dialsPerItem, dialsPerItem) || other.dialsPerItem == dialsPerItem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,dialsPerItem);

@override
String toString() {
  return 'GeneratorParams.p1Counters(count: $count, dialsPerItem: $dialsPerItem)';
}


}

/// @nodoc
abstract mixin class $P1CountersParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1CountersParamsCopyWith(P1CountersParams value, $Res Function(P1CountersParams) _then) = _$P1CountersParamsCopyWithImpl;
@useResult
$Res call({
 int count, int dialsPerItem
});




}
/// @nodoc
class _$P1CountersParamsCopyWithImpl<$Res>
    implements $P1CountersParamsCopyWith<$Res> {
  _$P1CountersParamsCopyWithImpl(this._self, this._then);

  final P1CountersParams _self;
  final $Res Function(P1CountersParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? dialsPerItem = null,}) {
  return _then(P1CountersParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,dialsPerItem: null == dialsPerItem ? _self.dialsPerItem : dialsPerItem // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1CubeNetsParams extends GeneratorParams {
  const P1CubeNetsParams({this.phaseCount = 2, this.netsPerPhase = 10, this.alphabet = CubeNetAlphabet.latin, this.missingFaces = 2, this.includeRotationMatching = false, final  String? $type}): $type = $type ?? 'p1_cube_nets',super._();
  factory P1CubeNetsParams.fromJson(Map<String, dynamic> json) => _$P1CubeNetsParamsFromJson(json);

@JsonKey() final  int phaseCount;
@JsonKey() final  int netsPerPhase;
@JsonKey() final  CubeNetAlphabet alphabet;
@JsonKey() final  int missingFaces;
@JsonKey() final  bool includeRotationMatching;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1CubeNetsParamsCopyWith<P1CubeNetsParams> get copyWith => _$P1CubeNetsParamsCopyWithImpl<P1CubeNetsParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1CubeNetsParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1CubeNetsParams&&(identical(other.phaseCount, phaseCount) || other.phaseCount == phaseCount)&&(identical(other.netsPerPhase, netsPerPhase) || other.netsPerPhase == netsPerPhase)&&(identical(other.alphabet, alphabet) || other.alphabet == alphabet)&&(identical(other.missingFaces, missingFaces) || other.missingFaces == missingFaces)&&(identical(other.includeRotationMatching, includeRotationMatching) || other.includeRotationMatching == includeRotationMatching));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phaseCount,netsPerPhase,alphabet,missingFaces,includeRotationMatching);

@override
String toString() {
  return 'GeneratorParams.p1CubeNets(phaseCount: $phaseCount, netsPerPhase: $netsPerPhase, alphabet: $alphabet, missingFaces: $missingFaces, includeRotationMatching: $includeRotationMatching)';
}


}

/// @nodoc
abstract mixin class $P1CubeNetsParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1CubeNetsParamsCopyWith(P1CubeNetsParams value, $Res Function(P1CubeNetsParams) _then) = _$P1CubeNetsParamsCopyWithImpl;
@useResult
$Res call({
 int phaseCount, int netsPerPhase, CubeNetAlphabet alphabet, int missingFaces, bool includeRotationMatching
});




}
/// @nodoc
class _$P1CubeNetsParamsCopyWithImpl<$Res>
    implements $P1CubeNetsParamsCopyWith<$Res> {
  _$P1CubeNetsParamsCopyWithImpl(this._self, this._then);

  final P1CubeNetsParams _self;
  final $Res Function(P1CubeNetsParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phaseCount = null,Object? netsPerPhase = null,Object? alphabet = null,Object? missingFaces = null,Object? includeRotationMatching = null,}) {
  return _then(P1CubeNetsParams(
phaseCount: null == phaseCount ? _self.phaseCount : phaseCount // ignore: cast_nullable_to_non_nullable
as int,netsPerPhase: null == netsPerPhase ? _self.netsPerPhase : netsPerPhase // ignore: cast_nullable_to_non_nullable
as int,alphabet: null == alphabet ? _self.alphabet : alphabet // ignore: cast_nullable_to_non_nullable
as CubeNetAlphabet,missingFaces: null == missingFaces ? _self.missingFaces : missingFaces // ignore: cast_nullable_to_non_nullable
as int,includeRotationMatching: null == includeRotationMatching ? _self.includeRotationMatching : includeRotationMatching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1WmReverseSpanParams extends GeneratorParams {
  const P1WmReverseSpanParams({this.count = 10, this.minDigits = 4, this.maxDigits = 9, this.answerWindowMs = 3500, final  String? $type}): $type = $type ?? 'p1_wm_reverse_span',super._();
  factory P1WmReverseSpanParams.fromJson(Map<String, dynamic> json) => _$P1WmReverseSpanParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  int minDigits;
@JsonKey() final  int maxDigits;
@JsonKey() final  int answerWindowMs;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1WmReverseSpanParamsCopyWith<P1WmReverseSpanParams> get copyWith => _$P1WmReverseSpanParamsCopyWithImpl<P1WmReverseSpanParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1WmReverseSpanParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1WmReverseSpanParams&&(identical(other.count, count) || other.count == count)&&(identical(other.minDigits, minDigits) || other.minDigits == minDigits)&&(identical(other.maxDigits, maxDigits) || other.maxDigits == maxDigits)&&(identical(other.answerWindowMs, answerWindowMs) || other.answerWindowMs == answerWindowMs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,minDigits,maxDigits,answerWindowMs);

@override
String toString() {
  return 'GeneratorParams.p1WmReverseSpan(count: $count, minDigits: $minDigits, maxDigits: $maxDigits, answerWindowMs: $answerWindowMs)';
}


}

/// @nodoc
abstract mixin class $P1WmReverseSpanParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1WmReverseSpanParamsCopyWith(P1WmReverseSpanParams value, $Res Function(P1WmReverseSpanParams) _then) = _$P1WmReverseSpanParamsCopyWithImpl;
@useResult
$Res call({
 int count, int minDigits, int maxDigits, int answerWindowMs
});




}
/// @nodoc
class _$P1WmReverseSpanParamsCopyWithImpl<$Res>
    implements $P1WmReverseSpanParamsCopyWith<$Res> {
  _$P1WmReverseSpanParamsCopyWithImpl(this._self, this._then);

  final P1WmReverseSpanParams _self;
  final $Res Function(P1WmReverseSpanParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? minDigits = null,Object? maxDigits = null,Object? answerWindowMs = null,}) {
  return _then(P1WmReverseSpanParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,minDigits: null == minDigits ? _self.minDigits : minDigits // ignore: cast_nullable_to_non_nullable
as int,maxDigits: null == maxDigits ? _self.maxDigits : maxDigits // ignore: cast_nullable_to_non_nullable
as int,answerWindowMs: null == answerWindowMs ? _self.answerWindowMs : answerWindowMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1WmCalcBackParams extends GeneratorParams {
  const P1WmCalcBackParams({this.stageCount = 4, this.calcsPerStage = 20, final  String? $type}): $type = $type ?? 'p1_wm_calc_back',super._();
  factory P1WmCalcBackParams.fromJson(Map<String, dynamic> json) => _$P1WmCalcBackParamsFromJson(json);

@JsonKey() final  int stageCount;
@JsonKey() final  int calcsPerStage;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1WmCalcBackParamsCopyWith<P1WmCalcBackParams> get copyWith => _$P1WmCalcBackParamsCopyWithImpl<P1WmCalcBackParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1WmCalcBackParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1WmCalcBackParams&&(identical(other.stageCount, stageCount) || other.stageCount == stageCount)&&(identical(other.calcsPerStage, calcsPerStage) || other.calcsPerStage == calcsPerStage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stageCount,calcsPerStage);

@override
String toString() {
  return 'GeneratorParams.p1WmCalcBack(stageCount: $stageCount, calcsPerStage: $calcsPerStage)';
}


}

/// @nodoc
abstract mixin class $P1WmCalcBackParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1WmCalcBackParamsCopyWith(P1WmCalcBackParams value, $Res Function(P1WmCalcBackParams) _then) = _$P1WmCalcBackParamsCopyWithImpl;
@useResult
$Res call({
 int stageCount, int calcsPerStage
});




}
/// @nodoc
class _$P1WmCalcBackParamsCopyWithImpl<$Res>
    implements $P1WmCalcBackParamsCopyWith<$Res> {
  _$P1WmCalcBackParamsCopyWithImpl(this._self, this._then);

  final P1WmCalcBackParams _self;
  final $Res Function(P1WmCalcBackParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stageCount = null,Object? calcsPerStage = null,}) {
  return _then(P1WmCalcBackParams(
stageCount: null == stageCount ? _self.stageCount : stageCount // ignore: cast_nullable_to_non_nullable
as int,calcsPerStage: null == calcsPerStage ? _self.calcsPerStage : calcsPerStage // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1RavenMatricesParams extends GeneratorParams {
  const P1RavenMatricesParams({this.count = 30, this.grid = const GridSize(rows: 3, cols: 3), this.optionCount = 8, final  String? $type}): $type = $type ?? 'p1_raven_matrices',super._();
  factory P1RavenMatricesParams.fromJson(Map<String, dynamic> json) => _$P1RavenMatricesParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  GridSize grid;
@JsonKey() final  int optionCount;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1RavenMatricesParamsCopyWith<P1RavenMatricesParams> get copyWith => _$P1RavenMatricesParamsCopyWithImpl<P1RavenMatricesParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1RavenMatricesParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1RavenMatricesParams&&(identical(other.count, count) || other.count == count)&&(identical(other.grid, grid) || other.grid == grid)&&(identical(other.optionCount, optionCount) || other.optionCount == optionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,grid,optionCount);

@override
String toString() {
  return 'GeneratorParams.p1RavenMatrices(count: $count, grid: $grid, optionCount: $optionCount)';
}


}

/// @nodoc
abstract mixin class $P1RavenMatricesParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1RavenMatricesParamsCopyWith(P1RavenMatricesParams value, $Res Function(P1RavenMatricesParams) _then) = _$P1RavenMatricesParamsCopyWithImpl;
@useResult
$Res call({
 int count, GridSize grid, int optionCount
});


$GridSizeCopyWith<$Res> get grid;

}
/// @nodoc
class _$P1RavenMatricesParamsCopyWithImpl<$Res>
    implements $P1RavenMatricesParamsCopyWith<$Res> {
  _$P1RavenMatricesParamsCopyWithImpl(this._self, this._then);

  final P1RavenMatricesParams _self;
  final $Res Function(P1RavenMatricesParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? grid = null,Object? optionCount = null,}) {
  return _then(P1RavenMatricesParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,grid: null == grid ? _self.grid : grid // ignore: cast_nullable_to_non_nullable
as GridSize,optionCount: null == optionCount ? _self.optionCount : optionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GridSizeCopyWith<$Res> get grid {
  
  return $GridSizeCopyWith<$Res>(_self.grid, (value) {
    return _then(_self.copyWith(grid: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class P1MentalArithmeticParams extends GeneratorParams {
  const P1MentalArithmeticParams({this.count = 10, this.answerMode = MentalArithmeticAnswerMode.freeNumeric, this.maxOperand = 100, final  String? $type}): $type = $type ?? 'p1_mental_arithmetic',super._();
  factory P1MentalArithmeticParams.fromJson(Map<String, dynamic> json) => _$P1MentalArithmeticParamsFromJson(json);

@JsonKey() final  int count;
@JsonKey() final  MentalArithmeticAnswerMode answerMode;
@JsonKey() final  int maxOperand;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1MentalArithmeticParamsCopyWith<P1MentalArithmeticParams> get copyWith => _$P1MentalArithmeticParamsCopyWithImpl<P1MentalArithmeticParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1MentalArithmeticParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1MentalArithmeticParams&&(identical(other.count, count) || other.count == count)&&(identical(other.answerMode, answerMode) || other.answerMode == answerMode)&&(identical(other.maxOperand, maxOperand) || other.maxOperand == maxOperand));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,count,answerMode,maxOperand);

@override
String toString() {
  return 'GeneratorParams.p1MentalArithmetic(count: $count, answerMode: $answerMode, maxOperand: $maxOperand)';
}


}

/// @nodoc
abstract mixin class $P1MentalArithmeticParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1MentalArithmeticParamsCopyWith(P1MentalArithmeticParams value, $Res Function(P1MentalArithmeticParams) _then) = _$P1MentalArithmeticParamsCopyWithImpl;
@useResult
$Res call({
 int count, MentalArithmeticAnswerMode answerMode, int maxOperand
});




}
/// @nodoc
class _$P1MentalArithmeticParamsCopyWithImpl<$Res>
    implements $P1MentalArithmeticParamsCopyWith<$Res> {
  _$P1MentalArithmeticParamsCopyWithImpl(this._self, this._then);

  final P1MentalArithmeticParams _self;
  final $Res Function(P1MentalArithmeticParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? count = null,Object? answerMode = null,Object? maxOperand = null,}) {
  return _then(P1MentalArithmeticParams(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,answerMode: null == answerMode ? _self.answerMode : answerMode // ignore: cast_nullable_to_non_nullable
as MentalArithmeticAnswerMode,maxOperand: null == maxOperand ? _self.maxOperand : maxOperand // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class P1PsychomotorParams extends GeneratorParams {
  const P1PsychomotorParams({this.phaseCount = 6, this.phaseDurationSec = 180, this.calcIntervalSec = 12, final  String? $type}): $type = $type ?? 'p1_psychomotor',super._();
  factory P1PsychomotorParams.fromJson(Map<String, dynamic> json) => _$P1PsychomotorParamsFromJson(json);

@JsonKey() final  int phaseCount;
@JsonKey() final  int phaseDurationSec;
@JsonKey() final  int calcIntervalSec;

@JsonKey(name: 'generatorId')
final String $type;


/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$P1PsychomotorParamsCopyWith<P1PsychomotorParams> get copyWith => _$P1PsychomotorParamsCopyWithImpl<P1PsychomotorParams>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$P1PsychomotorParamsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is P1PsychomotorParams&&(identical(other.phaseCount, phaseCount) || other.phaseCount == phaseCount)&&(identical(other.phaseDurationSec, phaseDurationSec) || other.phaseDurationSec == phaseDurationSec)&&(identical(other.calcIntervalSec, calcIntervalSec) || other.calcIntervalSec == calcIntervalSec));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phaseCount,phaseDurationSec,calcIntervalSec);

@override
String toString() {
  return 'GeneratorParams.p1Psychomotor(phaseCount: $phaseCount, phaseDurationSec: $phaseDurationSec, calcIntervalSec: $calcIntervalSec)';
}


}

/// @nodoc
abstract mixin class $P1PsychomotorParamsCopyWith<$Res> implements $GeneratorParamsCopyWith<$Res> {
  factory $P1PsychomotorParamsCopyWith(P1PsychomotorParams value, $Res Function(P1PsychomotorParams) _then) = _$P1PsychomotorParamsCopyWithImpl;
@useResult
$Res call({
 int phaseCount, int phaseDurationSec, int calcIntervalSec
});




}
/// @nodoc
class _$P1PsychomotorParamsCopyWithImpl<$Res>
    implements $P1PsychomotorParamsCopyWith<$Res> {
  _$P1PsychomotorParamsCopyWithImpl(this._self, this._then);

  final P1PsychomotorParams _self;
  final $Res Function(P1PsychomotorParams) _then;

/// Create a copy of GeneratorParams
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phaseCount = null,Object? phaseDurationSec = null,Object? calcIntervalSec = null,}) {
  return _then(P1PsychomotorParams(
phaseCount: null == phaseCount ? _self.phaseCount : phaseCount // ignore: cast_nullable_to_non_nullable
as int,phaseDurationSec: null == phaseDurationSec ? _self.phaseDurationSec : phaseDurationSec // ignore: cast_nullable_to_non_nullable
as int,calcIntervalSec: null == calcIntervalSec ? _self.calcIntervalSec : calcIntervalSec // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
