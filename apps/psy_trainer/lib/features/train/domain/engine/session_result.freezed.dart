// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SectionResult {

 int get itemCount; int get played; int get correct; int get wrong; int get timeouts; int get skipped; double get accuracy; double? get meanResponseMs; double? get medianResponseMs; num get points; num get maxPoints; ScoringPolicy get scoringPolicy; Map<String, num> get metricTotals;
/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionResultCopyWith<SectionResult> get copyWith => _$SectionResultCopyWithImpl<SectionResult>(this as SectionResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionResult&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.played, played) || other.played == played)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.timeouts, timeouts) || other.timeouts == timeouts)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs)&&(identical(other.points, points) || other.points == points)&&(identical(other.maxPoints, maxPoints) || other.maxPoints == maxPoints)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&const DeepCollectionEquality().equals(other.metricTotals, metricTotals));
}


@override
int get hashCode => Object.hash(runtimeType,itemCount,played,correct,wrong,timeouts,skipped,accuracy,meanResponseMs,medianResponseMs,points,maxPoints,scoringPolicy,const DeepCollectionEquality().hash(metricTotals));

@override
String toString() {
  return 'SectionResult(itemCount: $itemCount, played: $played, correct: $correct, wrong: $wrong, timeouts: $timeouts, skipped: $skipped, accuracy: $accuracy, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs, points: $points, maxPoints: $maxPoints, scoringPolicy: $scoringPolicy, metricTotals: $metricTotals)';
}


}

/// @nodoc
abstract mixin class $SectionResultCopyWith<$Res>  {
  factory $SectionResultCopyWith(SectionResult value, $Res Function(SectionResult) _then) = _$SectionResultCopyWithImpl;
@useResult
$Res call({
 int itemCount, int played, int correct, int wrong, int timeouts, int skipped, double accuracy, double? meanResponseMs, double? medianResponseMs, num points, num maxPoints, ScoringPolicy scoringPolicy, Map<String, num> metricTotals
});


$ScoringPolicyCopyWith<$Res> get scoringPolicy;

}
/// @nodoc
class _$SectionResultCopyWithImpl<$Res>
    implements $SectionResultCopyWith<$Res> {
  _$SectionResultCopyWithImpl(this._self, this._then);

  final SectionResult _self;
  final $Res Function(SectionResult) _then;

/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemCount = null,Object? played = null,Object? correct = null,Object? wrong = null,Object? timeouts = null,Object? skipped = null,Object? accuracy = null,Object? meanResponseMs = freezed,Object? medianResponseMs = freezed,Object? points = null,Object? maxPoints = null,Object? scoringPolicy = null,Object? metricTotals = null,}) {
  return _then(_self.copyWith(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,timeouts: null == timeouts ? _self.timeouts : timeouts // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,meanResponseMs: freezed == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double?,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as num,maxPoints: null == maxPoints ? _self.maxPoints : maxPoints // ignore: cast_nullable_to_non_nullable
as num,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,metricTotals: null == metricTotals ? _self.metricTotals : metricTotals // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}
/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [SectionResult].
extension SectionResultPatterns on SectionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionResult value)  $default,){
final _that = this;
switch (_that) {
case _SectionResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionResult value)?  $default,){
final _that = this;
switch (_that) {
case _SectionResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int itemCount,  int played,  int correct,  int wrong,  int timeouts,  int skipped,  double accuracy,  double? meanResponseMs,  double? medianResponseMs,  num points,  num maxPoints,  ScoringPolicy scoringPolicy,  Map<String, num> metricTotals)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionResult() when $default != null:
return $default(_that.itemCount,_that.played,_that.correct,_that.wrong,_that.timeouts,_that.skipped,_that.accuracy,_that.meanResponseMs,_that.medianResponseMs,_that.points,_that.maxPoints,_that.scoringPolicy,_that.metricTotals);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int itemCount,  int played,  int correct,  int wrong,  int timeouts,  int skipped,  double accuracy,  double? meanResponseMs,  double? medianResponseMs,  num points,  num maxPoints,  ScoringPolicy scoringPolicy,  Map<String, num> metricTotals)  $default,) {final _that = this;
switch (_that) {
case _SectionResult():
return $default(_that.itemCount,_that.played,_that.correct,_that.wrong,_that.timeouts,_that.skipped,_that.accuracy,_that.meanResponseMs,_that.medianResponseMs,_that.points,_that.maxPoints,_that.scoringPolicy,_that.metricTotals);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int itemCount,  int played,  int correct,  int wrong,  int timeouts,  int skipped,  double accuracy,  double? meanResponseMs,  double? medianResponseMs,  num points,  num maxPoints,  ScoringPolicy scoringPolicy,  Map<String, num> metricTotals)?  $default,) {final _that = this;
switch (_that) {
case _SectionResult() when $default != null:
return $default(_that.itemCount,_that.played,_that.correct,_that.wrong,_that.timeouts,_that.skipped,_that.accuracy,_that.meanResponseMs,_that.medianResponseMs,_that.points,_that.maxPoints,_that.scoringPolicy,_that.metricTotals);case _:
  return null;

}
}

}

/// @nodoc


class _SectionResult extends SectionResult {
  const _SectionResult({required this.itemCount, required this.played, required this.correct, required this.wrong, required this.timeouts, required this.skipped, required this.accuracy, required this.meanResponseMs, required this.medianResponseMs, required this.points, required this.maxPoints, required this.scoringPolicy, final  Map<String, num> metricTotals = const <String, num>{}}): _metricTotals = metricTotals,super._();
  

@override final  int itemCount;
@override final  int played;
@override final  int correct;
@override final  int wrong;
@override final  int timeouts;
@override final  int skipped;
@override final  double accuracy;
@override final  double? meanResponseMs;
@override final  double? medianResponseMs;
@override final  num points;
@override final  num maxPoints;
@override final  ScoringPolicy scoringPolicy;
 final  Map<String, num> _metricTotals;
@override@JsonKey() Map<String, num> get metricTotals {
  if (_metricTotals is EqualUnmodifiableMapView) return _metricTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metricTotals);
}


/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionResultCopyWith<_SectionResult> get copyWith => __$SectionResultCopyWithImpl<_SectionResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionResult&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.played, played) || other.played == played)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.timeouts, timeouts) || other.timeouts == timeouts)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs)&&(identical(other.points, points) || other.points == points)&&(identical(other.maxPoints, maxPoints) || other.maxPoints == maxPoints)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&const DeepCollectionEquality().equals(other._metricTotals, _metricTotals));
}


@override
int get hashCode => Object.hash(runtimeType,itemCount,played,correct,wrong,timeouts,skipped,accuracy,meanResponseMs,medianResponseMs,points,maxPoints,scoringPolicy,const DeepCollectionEquality().hash(_metricTotals));

@override
String toString() {
  return 'SectionResult(itemCount: $itemCount, played: $played, correct: $correct, wrong: $wrong, timeouts: $timeouts, skipped: $skipped, accuracy: $accuracy, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs, points: $points, maxPoints: $maxPoints, scoringPolicy: $scoringPolicy, metricTotals: $metricTotals)';
}


}

/// @nodoc
abstract mixin class _$SectionResultCopyWith<$Res> implements $SectionResultCopyWith<$Res> {
  factory _$SectionResultCopyWith(_SectionResult value, $Res Function(_SectionResult) _then) = __$SectionResultCopyWithImpl;
@override @useResult
$Res call({
 int itemCount, int played, int correct, int wrong, int timeouts, int skipped, double accuracy, double? meanResponseMs, double? medianResponseMs, num points, num maxPoints, ScoringPolicy scoringPolicy, Map<String, num> metricTotals
});


@override $ScoringPolicyCopyWith<$Res> get scoringPolicy;

}
/// @nodoc
class __$SectionResultCopyWithImpl<$Res>
    implements _$SectionResultCopyWith<$Res> {
  __$SectionResultCopyWithImpl(this._self, this._then);

  final _SectionResult _self;
  final $Res Function(_SectionResult) _then;

/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemCount = null,Object? played = null,Object? correct = null,Object? wrong = null,Object? timeouts = null,Object? skipped = null,Object? accuracy = null,Object? meanResponseMs = freezed,Object? medianResponseMs = freezed,Object? points = null,Object? maxPoints = null,Object? scoringPolicy = null,Object? metricTotals = null,}) {
  return _then(_SectionResult(
itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,played: null == played ? _self.played : played // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as int,timeouts: null == timeouts ? _self.timeouts : timeouts // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,meanResponseMs: freezed == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double?,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as num,maxPoints: null == maxPoints ? _self.maxPoints : maxPoints // ignore: cast_nullable_to_non_nullable
as num,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,metricTotals: null == metricTotals ? _self._metricTotals : metricTotals // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}

/// Create a copy of SectionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}
}

/// @nodoc
mixin _$SessionResult {

 SessionMode get mode; String get familyId; FinishReason get reason; List<ItemOutcome> get outcomes; SectionResult get section; String? get sessionId; int? get sectionIndex;
/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionResultCopyWith<SessionResult> get copyWith => _$SessionResultCopyWithImpl<SessionResult>(this as SessionResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.outcomes, outcomes)&&(identical(other.section, section) || other.section == section)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex));
}


@override
int get hashCode => Object.hash(runtimeType,mode,familyId,reason,const DeepCollectionEquality().hash(outcomes),section,sessionId,sectionIndex);

@override
String toString() {
  return 'SessionResult(mode: $mode, familyId: $familyId, reason: $reason, outcomes: $outcomes, section: $section, sessionId: $sessionId, sectionIndex: $sectionIndex)';
}


}

/// @nodoc
abstract mixin class $SessionResultCopyWith<$Res>  {
  factory $SessionResultCopyWith(SessionResult value, $Res Function(SessionResult) _then) = _$SessionResultCopyWithImpl;
@useResult
$Res call({
 SessionMode mode, String familyId, FinishReason reason, List<ItemOutcome> outcomes, SectionResult section, String? sessionId, int? sectionIndex
});


$SectionResultCopyWith<$Res> get section;

}
/// @nodoc
class _$SessionResultCopyWithImpl<$Res>
    implements $SessionResultCopyWith<$Res> {
  _$SessionResultCopyWithImpl(this._self, this._then);

  final SessionResult _self;
  final $Res Function(SessionResult) _then;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? familyId = null,Object? reason = null,Object? outcomes = null,Object? section = null,Object? sessionId = freezed,Object? sectionIndex = freezed,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as FinishReason,outcomes: null == outcomes ? _self.outcomes : outcomes // ignore: cast_nullable_to_non_nullable
as List<ItemOutcome>,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as SectionResult,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionResultCopyWith<$Res> get section {
  
  return $SectionResultCopyWith<$Res>(_self.section, (value) {
    return _then(_self.copyWith(section: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionResult].
extension SessionResultPatterns on SessionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionResult value)  $default,){
final _that = this;
switch (_that) {
case _SessionResult():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionResult value)?  $default,){
final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SessionMode mode,  String familyId,  FinishReason reason,  List<ItemOutcome> outcomes,  SectionResult section,  String? sessionId,  int? sectionIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that.mode,_that.familyId,_that.reason,_that.outcomes,_that.section,_that.sessionId,_that.sectionIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SessionMode mode,  String familyId,  FinishReason reason,  List<ItemOutcome> outcomes,  SectionResult section,  String? sessionId,  int? sectionIndex)  $default,) {final _that = this;
switch (_that) {
case _SessionResult():
return $default(_that.mode,_that.familyId,_that.reason,_that.outcomes,_that.section,_that.sessionId,_that.sectionIndex);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SessionMode mode,  String familyId,  FinishReason reason,  List<ItemOutcome> outcomes,  SectionResult section,  String? sessionId,  int? sectionIndex)?  $default,) {final _that = this;
switch (_that) {
case _SessionResult() when $default != null:
return $default(_that.mode,_that.familyId,_that.reason,_that.outcomes,_that.section,_that.sessionId,_that.sectionIndex);case _:
  return null;

}
}

}

/// @nodoc


class _SessionResult extends SessionResult {
  const _SessionResult({required this.mode, required this.familyId, required this.reason, required final  List<ItemOutcome> outcomes, required this.section, this.sessionId, this.sectionIndex}): _outcomes = outcomes,super._();
  

@override final  SessionMode mode;
@override final  String familyId;
@override final  FinishReason reason;
 final  List<ItemOutcome> _outcomes;
@override List<ItemOutcome> get outcomes {
  if (_outcomes is EqualUnmodifiableListView) return _outcomes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_outcomes);
}

@override final  SectionResult section;
@override final  String? sessionId;
@override final  int? sectionIndex;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionResultCopyWith<_SessionResult> get copyWith => __$SessionResultCopyWithImpl<_SessionResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionResult&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other._outcomes, _outcomes)&&(identical(other.section, section) || other.section == section)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex));
}


@override
int get hashCode => Object.hash(runtimeType,mode,familyId,reason,const DeepCollectionEquality().hash(_outcomes),section,sessionId,sectionIndex);

@override
String toString() {
  return 'SessionResult(mode: $mode, familyId: $familyId, reason: $reason, outcomes: $outcomes, section: $section, sessionId: $sessionId, sectionIndex: $sectionIndex)';
}


}

/// @nodoc
abstract mixin class _$SessionResultCopyWith<$Res> implements $SessionResultCopyWith<$Res> {
  factory _$SessionResultCopyWith(_SessionResult value, $Res Function(_SessionResult) _then) = __$SessionResultCopyWithImpl;
@override @useResult
$Res call({
 SessionMode mode, String familyId, FinishReason reason, List<ItemOutcome> outcomes, SectionResult section, String? sessionId, int? sectionIndex
});


@override $SectionResultCopyWith<$Res> get section;

}
/// @nodoc
class __$SessionResultCopyWithImpl<$Res>
    implements _$SessionResultCopyWith<$Res> {
  __$SessionResultCopyWithImpl(this._self, this._then);

  final _SessionResult _self;
  final $Res Function(_SessionResult) _then;

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? familyId = null,Object? reason = null,Object? outcomes = null,Object? section = null,Object? sessionId = freezed,Object? sectionIndex = freezed,}) {
  return _then(_SessionResult(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as FinishReason,outcomes: null == outcomes ? _self._outcomes : outcomes // ignore: cast_nullable_to_non_nullable
as List<ItemOutcome>,section: null == section ? _self.section : section // ignore: cast_nullable_to_non_nullable
as SectionResult,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,sectionIndex: freezed == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of SessionResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SectionResultCopyWith<$Res> get section {
  
  return $SectionResultCopyWith<$Res>(_self.section, (value) {
    return _then(_self.copyWith(section: value));
  });
}
}

// dart format on
