// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'family_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Trend {

 TrendDirection get direction; double get slope; double get delta; int get sessions;
/// Create a copy of Trend
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendCopyWith<Trend> get copyWith => _$TrendCopyWithImpl<Trend>(this as Trend, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Trend&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.slope, slope) || other.slope == slope)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,direction,slope,delta,sessions);

@override
String toString() {
  return 'Trend(direction: $direction, slope: $slope, delta: $delta, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class $TrendCopyWith<$Res>  {
  factory $TrendCopyWith(Trend value, $Res Function(Trend) _then) = _$TrendCopyWithImpl;
@useResult
$Res call({
 TrendDirection direction, double slope, double delta, int sessions
});




}
/// @nodoc
class _$TrendCopyWithImpl<$Res>
    implements $TrendCopyWith<$Res> {
  _$TrendCopyWithImpl(this._self, this._then);

  final Trend _self;
  final $Res Function(Trend) _then;

/// Create a copy of Trend
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? direction = null,Object? slope = null,Object? delta = null,Object? sessions = null,}) {
  return _then(_self.copyWith(
direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,slope: null == slope ? _self.slope : slope // ignore: cast_nullable_to_non_nullable
as double,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Trend].
extension TrendPatterns on Trend {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trend value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trend() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trend value)  $default,){
final _that = this;
switch (_that) {
case _Trend():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trend value)?  $default,){
final _that = this;
switch (_that) {
case _Trend() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TrendDirection direction,  double slope,  double delta,  int sessions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trend() when $default != null:
return $default(_that.direction,_that.slope,_that.delta,_that.sessions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TrendDirection direction,  double slope,  double delta,  int sessions)  $default,) {final _that = this;
switch (_that) {
case _Trend():
return $default(_that.direction,_that.slope,_that.delta,_that.sessions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TrendDirection direction,  double slope,  double delta,  int sessions)?  $default,) {final _that = this;
switch (_that) {
case _Trend() when $default != null:
return $default(_that.direction,_that.slope,_that.delta,_that.sessions);case _:
  return null;

}
}

}

/// @nodoc


class _Trend extends Trend {
  const _Trend({required this.direction, required this.slope, required this.delta, required this.sessions}): super._();
  

@override final  TrendDirection direction;
@override final  double slope;
@override final  double delta;
@override final  int sessions;

/// Create a copy of Trend
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendCopyWith<_Trend> get copyWith => __$TrendCopyWithImpl<_Trend>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trend&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.slope, slope) || other.slope == slope)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.sessions, sessions) || other.sessions == sessions));
}


@override
int get hashCode => Object.hash(runtimeType,direction,slope,delta,sessions);

@override
String toString() {
  return 'Trend(direction: $direction, slope: $slope, delta: $delta, sessions: $sessions)';
}


}

/// @nodoc
abstract mixin class _$TrendCopyWith<$Res> implements $TrendCopyWith<$Res> {
  factory _$TrendCopyWith(_Trend value, $Res Function(_Trend) _then) = __$TrendCopyWithImpl;
@override @useResult
$Res call({
 TrendDirection direction, double slope, double delta, int sessions
});




}
/// @nodoc
class __$TrendCopyWithImpl<$Res>
    implements _$TrendCopyWith<$Res> {
  __$TrendCopyWithImpl(this._self, this._then);

  final _Trend _self;
  final $Res Function(_Trend) _then;

/// Create a copy of Trend
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? direction = null,Object? slope = null,Object? delta = null,Object? sessions = null,}) {
  return _then(_Trend(
direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as TrendDirection,slope: null == slope ? _self.slope : slope // ignore: cast_nullable_to_non_nullable
as double,delta: null == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as double,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$FamilyProgress {

 String get familyId; int get attempts; int get correct; int get sessions; int get level; Trend get trend7d; Trend get trend30d; double? get medianResponseMs; DateTime? get lastPractisedAt;
/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyProgressCopyWith<FamilyProgress> get copyWith => _$FamilyProgressCopyWithImpl<FamilyProgress>(this as FamilyProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyProgress&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.level, level) || other.level == level)&&(identical(other.trend7d, trend7d) || other.trend7d == trend7d)&&(identical(other.trend30d, trend30d) || other.trend30d == trend30d)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs)&&(identical(other.lastPractisedAt, lastPractisedAt) || other.lastPractisedAt == lastPractisedAt));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,attempts,correct,sessions,level,trend7d,trend30d,medianResponseMs,lastPractisedAt);

@override
String toString() {
  return 'FamilyProgress(familyId: $familyId, attempts: $attempts, correct: $correct, sessions: $sessions, level: $level, trend7d: $trend7d, trend30d: $trend30d, medianResponseMs: $medianResponseMs, lastPractisedAt: $lastPractisedAt)';
}


}

/// @nodoc
abstract mixin class $FamilyProgressCopyWith<$Res>  {
  factory $FamilyProgressCopyWith(FamilyProgress value, $Res Function(FamilyProgress) _then) = _$FamilyProgressCopyWithImpl;
@useResult
$Res call({
 String familyId, int attempts, int correct, int sessions, int level, Trend trend7d, Trend trend30d, double? medianResponseMs, DateTime? lastPractisedAt
});


$TrendCopyWith<$Res> get trend7d;$TrendCopyWith<$Res> get trend30d;

}
/// @nodoc
class _$FamilyProgressCopyWithImpl<$Res>
    implements $FamilyProgressCopyWith<$Res> {
  _$FamilyProgressCopyWithImpl(this._self, this._then);

  final FamilyProgress _self;
  final $Res Function(FamilyProgress) _then;

/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? attempts = null,Object? correct = null,Object? sessions = null,Object? level = null,Object? trend7d = null,Object? trend30d = null,Object? medianResponseMs = freezed,Object? lastPractisedAt = freezed,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,trend7d: null == trend7d ? _self.trend7d : trend7d // ignore: cast_nullable_to_non_nullable
as Trend,trend30d: null == trend30d ? _self.trend30d : trend30d // ignore: cast_nullable_to_non_nullable
as Trend,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,lastPractisedAt: freezed == lastPractisedAt ? _self.lastPractisedAt : lastPractisedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res> get trend7d {
  
  return $TrendCopyWith<$Res>(_self.trend7d, (value) {
    return _then(_self.copyWith(trend7d: value));
  });
}/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res> get trend30d {
  
  return $TrendCopyWith<$Res>(_self.trend30d, (value) {
    return _then(_self.copyWith(trend30d: value));
  });
}
}


/// Adds pattern-matching-related methods to [FamilyProgress].
extension FamilyProgressPatterns on FamilyProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyProgress value)  $default,){
final _that = this;
switch (_that) {
case _FamilyProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyProgress value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  int attempts,  int correct,  int sessions,  int level,  Trend trend7d,  Trend trend30d,  double? medianResponseMs,  DateTime? lastPractisedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyProgress() when $default != null:
return $default(_that.familyId,_that.attempts,_that.correct,_that.sessions,_that.level,_that.trend7d,_that.trend30d,_that.medianResponseMs,_that.lastPractisedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  int attempts,  int correct,  int sessions,  int level,  Trend trend7d,  Trend trend30d,  double? medianResponseMs,  DateTime? lastPractisedAt)  $default,) {final _that = this;
switch (_that) {
case _FamilyProgress():
return $default(_that.familyId,_that.attempts,_that.correct,_that.sessions,_that.level,_that.trend7d,_that.trend30d,_that.medianResponseMs,_that.lastPractisedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  int attempts,  int correct,  int sessions,  int level,  Trend trend7d,  Trend trend30d,  double? medianResponseMs,  DateTime? lastPractisedAt)?  $default,) {final _that = this;
switch (_that) {
case _FamilyProgress() when $default != null:
return $default(_that.familyId,_that.attempts,_that.correct,_that.sessions,_that.level,_that.trend7d,_that.trend30d,_that.medianResponseMs,_that.lastPractisedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyProgress extends FamilyProgress {
  const _FamilyProgress({required this.familyId, required this.attempts, required this.correct, required this.sessions, required this.level, required this.trend7d, required this.trend30d, this.medianResponseMs, this.lastPractisedAt}): super._();
  

@override final  String familyId;
@override final  int attempts;
@override final  int correct;
@override final  int sessions;
@override final  int level;
@override final  Trend trend7d;
@override final  Trend trend30d;
@override final  double? medianResponseMs;
@override final  DateTime? lastPractisedAt;

/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyProgressCopyWith<_FamilyProgress> get copyWith => __$FamilyProgressCopyWithImpl<_FamilyProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyProgress&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.level, level) || other.level == level)&&(identical(other.trend7d, trend7d) || other.trend7d == trend7d)&&(identical(other.trend30d, trend30d) || other.trend30d == trend30d)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs)&&(identical(other.lastPractisedAt, lastPractisedAt) || other.lastPractisedAt == lastPractisedAt));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,attempts,correct,sessions,level,trend7d,trend30d,medianResponseMs,lastPractisedAt);

@override
String toString() {
  return 'FamilyProgress(familyId: $familyId, attempts: $attempts, correct: $correct, sessions: $sessions, level: $level, trend7d: $trend7d, trend30d: $trend30d, medianResponseMs: $medianResponseMs, lastPractisedAt: $lastPractisedAt)';
}


}

/// @nodoc
abstract mixin class _$FamilyProgressCopyWith<$Res> implements $FamilyProgressCopyWith<$Res> {
  factory _$FamilyProgressCopyWith(_FamilyProgress value, $Res Function(_FamilyProgress) _then) = __$FamilyProgressCopyWithImpl;
@override @useResult
$Res call({
 String familyId, int attempts, int correct, int sessions, int level, Trend trend7d, Trend trend30d, double? medianResponseMs, DateTime? lastPractisedAt
});


@override $TrendCopyWith<$Res> get trend7d;@override $TrendCopyWith<$Res> get trend30d;

}
/// @nodoc
class __$FamilyProgressCopyWithImpl<$Res>
    implements _$FamilyProgressCopyWith<$Res> {
  __$FamilyProgressCopyWithImpl(this._self, this._then);

  final _FamilyProgress _self;
  final $Res Function(_FamilyProgress) _then;

/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? attempts = null,Object? correct = null,Object? sessions = null,Object? level = null,Object? trend7d = null,Object? trend30d = null,Object? medianResponseMs = freezed,Object? lastPractisedAt = freezed,}) {
  return _then(_FamilyProgress(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,trend7d: null == trend7d ? _self.trend7d : trend7d // ignore: cast_nullable_to_non_nullable
as Trend,trend30d: null == trend30d ? _self.trend30d : trend30d // ignore: cast_nullable_to_non_nullable
as Trend,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,lastPractisedAt: freezed == lastPractisedAt ? _self.lastPractisedAt : lastPractisedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res> get trend7d {
  
  return $TrendCopyWith<$Res>(_self.trend7d, (value) {
    return _then(_self.copyWith(trend7d: value));
  });
}/// Create a copy of FamilyProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res> get trend30d {
  
  return $TrendCopyWith<$Res>(_self.trend30d, (value) {
    return _then(_self.copyWith(trend30d: value));
  });
}
}

// dart format on
