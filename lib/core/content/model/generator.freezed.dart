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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( NbackParams value)?  nback,TResult Function( TubesParams value)?  tubes,TResult Function( StimulusResponseParams value)?  stimulusResponse,TResult Function( ParitySequenceParams value)?  paritySequence,TResult Function( OverlayGridParams value)?  overlayGrid,TResult Function( DominosParams value)?  dominos,TResult Function( AirwaysParams value)?  airways,TResult Function( WordBoxesParams value)?  wordBoxes,TResult Function( ArithmeticGridParams value)?  arithmeticGrid,TResult Function( ViewpointParams value)?  viewpoint,TResult Function( CubeNetParams value)?  cubeNet,TResult Function( MultitaskParams value)?  multitask,required TResult orElse(),}){
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
return multitask(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( NbackParams value)  nback,required TResult Function( TubesParams value)  tubes,required TResult Function( StimulusResponseParams value)  stimulusResponse,required TResult Function( ParitySequenceParams value)  paritySequence,required TResult Function( OverlayGridParams value)  overlayGrid,required TResult Function( DominosParams value)  dominos,required TResult Function( AirwaysParams value)  airways,required TResult Function( WordBoxesParams value)  wordBoxes,required TResult Function( ArithmeticGridParams value)  arithmeticGrid,required TResult Function( ViewpointParams value)  viewpoint,required TResult Function( CubeNetParams value)  cubeNet,required TResult Function( MultitaskParams value)  multitask,}){
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
return multitask(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( NbackParams value)?  nback,TResult? Function( TubesParams value)?  tubes,TResult? Function( StimulusResponseParams value)?  stimulusResponse,TResult? Function( ParitySequenceParams value)?  paritySequence,TResult? Function( OverlayGridParams value)?  overlayGrid,TResult? Function( DominosParams value)?  dominos,TResult? Function( AirwaysParams value)?  airways,TResult? Function( WordBoxesParams value)?  wordBoxes,TResult? Function( ArithmeticGridParams value)?  arithmeticGrid,TResult? Function( ViewpointParams value)?  viewpoint,TResult? Function( CubeNetParams value)?  cubeNet,TResult? Function( MultitaskParams value)?  multitask,}){
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
return multitask(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)?  nback,TResult Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)?  tubes,TResult Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)?  stimulusResponse,TResult Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)?  paritySequence,TResult Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)?  overlayGrid,TResult Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)?  dominos,TResult Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)?  airways,TResult Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)?  wordBoxes,TResult Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)?  arithmeticGrid,TResult Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)?  viewpoint,TResult Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)?  cubeNet,TResult Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)?  multitask,required TResult orElse(),}) {final _that = this;
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
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)  nback,required TResult Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)  tubes,required TResult Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)  stimulusResponse,required TResult Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)  paritySequence,required TResult Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)  overlayGrid,required TResult Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)  dominos,required TResult Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)  airways,required TResult Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)  wordBoxes,required TResult Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)  arithmeticGrid,required TResult Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)  viewpoint,required TResult Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)  cubeNet,required TResult Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)  multitask,}) {final _that = this;
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
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int n,  NbackStimulusKind stimulusKind,  int paletteSize,  int count,  int primers,  int stimulusMs,  int answerWindowMs,  double targetRatio,  double lureRatio)?  nback,TResult? Function( List<int> capacities,  int colourCount,  int ballCount,  int minMoves,  int maxMoves)?  tubes,TResult? Function( int count,  int stimulusMs,  int answerWindowMs,  List<String> keys,  List<StimulusShape> shapes,  List<StimulusColour> colours,  int ruleDepth)?  stimulusResponse,TResult? Function( int numberCount,  int numberMin,  int numberMax,  bool restartOnError,  bool labelEnds)?  paritySequence,TResult? Function( GridSize grid,  int tileCount,  bool overlapping,  bool blackCells)?  overlayGrid,TResult? Function( int length,  DominoLayout layout,  int ruleCount,  DominoAnswerMode answerMode)?  dominos,TResult? Function( int capacity,  int blueCapacity,  int zoneCount,  int routeCount,  int spawnIntervalMs,  int durationSec)?  airways,TResult? Function( int boxCount,  int wordCount,  List<String>? fieldIds,  double trapRatio,  int wordTimeMs)?  wordBoxes,TResult? Function( GridSize grid,  int wrongMin,  int wrongMax,  List<ArithmeticOperation> operations,  int maxOperand)?  arithmeticGrid,TResult? Function( int viewpointCount,  int objectCount,  List<SolidKind> objectKinds,  bool allowSymmetric)?  viewpoint,TResult? Function( int missingFaces,  int distractorFaces,  CubeSymbolKind symbolKind,  bool flippable)?  cubeNet,TResult? Function( int durationSec,  double trackingSpeed,  double trackingNoise,  int shapeIntervalMs,  int calcIntervalMs,  double shapeTargetRatio,  double calcWrongRatio,  String shapeKey,  String calcKey)?  multitask,}) {final _that = this;
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
return multitask(_that.durationSec,_that.trackingSpeed,_that.trackingNoise,_that.shapeIntervalMs,_that.calcIntervalMs,_that.shapeTargetRatio,_that.calcWrongRatio,_that.shapeKey,_that.calcKey);case _:
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

// dart format on
