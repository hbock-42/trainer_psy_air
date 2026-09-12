// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TrendPoint {

 String get sessionId; SessionMode get mode; DateTime get at; int get attempts; int get correct; int get unanswered; double get medianResponseMs;
/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrendPointCopyWith<TrendPoint> get copyWith => _$TrendPointCopyWithImpl<TrendPoint>(this as TrendPoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrendPoint&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.at, at) || other.at == at)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,at,attempts,correct,unanswered,medianResponseMs);

@override
String toString() {
  return 'TrendPoint(sessionId: $sessionId, mode: $mode, at: $at, attempts: $attempts, correct: $correct, unanswered: $unanswered, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class $TrendPointCopyWith<$Res>  {
  factory $TrendPointCopyWith(TrendPoint value, $Res Function(TrendPoint) _then) = _$TrendPointCopyWithImpl;
@useResult
$Res call({
 String sessionId, SessionMode mode, DateTime at, int attempts, int correct, int unanswered, double medianResponseMs
});




}
/// @nodoc
class _$TrendPointCopyWithImpl<$Res>
    implements $TrendPointCopyWith<$Res> {
  _$TrendPointCopyWithImpl(this._self, this._then);

  final TrendPoint _self;
  final $Res Function(TrendPoint) _then;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? mode = null,Object? at = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? medianResponseMs = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [TrendPoint].
extension TrendPointPatterns on TrendPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrendPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrendPoint value)  $default,){
final _that = this;
switch (_that) {
case _TrendPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrendPoint value)?  $default,){
final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  SessionMode mode,  DateTime at,  int attempts,  int correct,  int unanswered,  double medianResponseMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that.sessionId,_that.mode,_that.at,_that.attempts,_that.correct,_that.unanswered,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  SessionMode mode,  DateTime at,  int attempts,  int correct,  int unanswered,  double medianResponseMs)  $default,) {final _that = this;
switch (_that) {
case _TrendPoint():
return $default(_that.sessionId,_that.mode,_that.at,_that.attempts,_that.correct,_that.unanswered,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  SessionMode mode,  DateTime at,  int attempts,  int correct,  int unanswered,  double medianResponseMs)?  $default,) {final _that = this;
switch (_that) {
case _TrendPoint() when $default != null:
return $default(_that.sessionId,_that.mode,_that.at,_that.attempts,_that.correct,_that.unanswered,_that.medianResponseMs);case _:
  return null;

}
}

}

/// @nodoc


class _TrendPoint extends TrendPoint {
  const _TrendPoint({required this.sessionId, required this.mode, required this.at, required this.attempts, required this.correct, required this.unanswered, required this.medianResponseMs}): super._();
  

@override final  String sessionId;
@override final  SessionMode mode;
@override final  DateTime at;
@override final  int attempts;
@override final  int correct;
@override final  int unanswered;
@override final  double medianResponseMs;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrendPointCopyWith<_TrendPoint> get copyWith => __$TrendPointCopyWithImpl<_TrendPoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrendPoint&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.at, at) || other.at == at)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,mode,at,attempts,correct,unanswered,medianResponseMs);

@override
String toString() {
  return 'TrendPoint(sessionId: $sessionId, mode: $mode, at: $at, attempts: $attempts, correct: $correct, unanswered: $unanswered, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class _$TrendPointCopyWith<$Res> implements $TrendPointCopyWith<$Res> {
  factory _$TrendPointCopyWith(_TrendPoint value, $Res Function(_TrendPoint) _then) = __$TrendPointCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, SessionMode mode, DateTime at, int attempts, int correct, int unanswered, double medianResponseMs
});




}
/// @nodoc
class __$TrendPointCopyWithImpl<$Res>
    implements _$TrendPointCopyWith<$Res> {
  __$TrendPointCopyWithImpl(this._self, this._then);

  final _TrendPoint _self;
  final $Res Function(_TrendPoint) _then;

/// Create a copy of TrendPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? mode = null,Object? at = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? medianResponseMs = null,}) {
  return _then(_TrendPoint(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,at: null == at ? _self.at : at // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$TimeSeries {

 String get familyId; List<TrendPoint> get points; DateTime? get from; DateTime? get to;
/// Create a copy of TimeSeries
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeSeriesCopyWith<TimeSeries> get copyWith => _$TimeSeriesCopyWithImpl<TimeSeries>(this as TimeSeries, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeSeries&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other.points, points)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(points),from,to);

@override
String toString() {
  return 'TimeSeries(familyId: $familyId, points: $points, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $TimeSeriesCopyWith<$Res>  {
  factory $TimeSeriesCopyWith(TimeSeries value, $Res Function(TimeSeries) _then) = _$TimeSeriesCopyWithImpl;
@useResult
$Res call({
 String familyId, List<TrendPoint> points, DateTime? from, DateTime? to
});




}
/// @nodoc
class _$TimeSeriesCopyWithImpl<$Res>
    implements $TimeSeriesCopyWith<$Res> {
  _$TimeSeriesCopyWithImpl(this._self, this._then);

  final TimeSeries _self;
  final $Res Function(TimeSeries) _then;

/// Create a copy of TimeSeries
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? points = null,Object? from = freezed,Object? to = freezed,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeSeries].
extension TimeSeriesPatterns on TimeSeries {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeSeries value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeSeries() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeSeries value)  $default,){
final _that = this;
switch (_that) {
case _TimeSeries():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeSeries value)?  $default,){
final _that = this;
switch (_that) {
case _TimeSeries() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  List<TrendPoint> points,  DateTime? from,  DateTime? to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeSeries() when $default != null:
return $default(_that.familyId,_that.points,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  List<TrendPoint> points,  DateTime? from,  DateTime? to)  $default,) {final _that = this;
switch (_that) {
case _TimeSeries():
return $default(_that.familyId,_that.points,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  List<TrendPoint> points,  DateTime? from,  DateTime? to)?  $default,) {final _that = this;
switch (_that) {
case _TimeSeries() when $default != null:
return $default(_that.familyId,_that.points,_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc


class _TimeSeries extends TimeSeries {
  const _TimeSeries({required this.familyId, required final  List<TrendPoint> points, this.from, this.to}): _points = points,super._();
  

@override final  String familyId;
 final  List<TrendPoint> _points;
@override List<TrendPoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

@override final  DateTime? from;
@override final  DateTime? to;

/// Create a copy of TimeSeries
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeSeriesCopyWith<_TimeSeries> get copyWith => __$TimeSeriesCopyWithImpl<_TimeSeries>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeSeries&&(identical(other.familyId, familyId) || other.familyId == familyId)&&const DeepCollectionEquality().equals(other._points, _points)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,const DeepCollectionEquality().hash(_points),from,to);

@override
String toString() {
  return 'TimeSeries(familyId: $familyId, points: $points, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$TimeSeriesCopyWith<$Res> implements $TimeSeriesCopyWith<$Res> {
  factory _$TimeSeriesCopyWith(_TimeSeries value, $Res Function(_TimeSeries) _then) = __$TimeSeriesCopyWithImpl;
@override @useResult
$Res call({
 String familyId, List<TrendPoint> points, DateTime? from, DateTime? to
});




}
/// @nodoc
class __$TimeSeriesCopyWithImpl<$Res>
    implements _$TimeSeriesCopyWith<$Res> {
  __$TimeSeriesCopyWithImpl(this._self, this._then);

  final _TimeSeries _self;
  final $Res Function(_TimeSeries) _then;

/// Create a copy of TimeSeries
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? points = null,Object? from = freezed,Object? to = freezed,}) {
  return _then(_TimeSeries(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<TrendPoint>,from: freezed == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as DateTime?,to: freezed == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
