// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weak_area.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeakArea {

 WeakAreaKind get kind; String get id; Set<WeakAreaReason> get reasons; double get accuracy; int get attempts;/// The 30-day trend for families; null for tags.
 Trend? get trend;
/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeakAreaCopyWith<WeakArea> get copyWith => _$WeakAreaCopyWithImpl<WeakArea>(this as WeakArea, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeakArea&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.reasons, reasons)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode => Object.hash(runtimeType,kind,id,const DeepCollectionEquality().hash(reasons),accuracy,attempts,trend);

@override
String toString() {
  return 'WeakArea(kind: $kind, id: $id, reasons: $reasons, accuracy: $accuracy, attempts: $attempts, trend: $trend)';
}


}

/// @nodoc
abstract mixin class $WeakAreaCopyWith<$Res>  {
  factory $WeakAreaCopyWith(WeakArea value, $Res Function(WeakArea) _then) = _$WeakAreaCopyWithImpl;
@useResult
$Res call({
 WeakAreaKind kind, String id, Set<WeakAreaReason> reasons, double accuracy, int attempts, Trend? trend
});


$TrendCopyWith<$Res>? get trend;

}
/// @nodoc
class _$WeakAreaCopyWithImpl<$Res>
    implements $WeakAreaCopyWith<$Res> {
  _$WeakAreaCopyWithImpl(this._self, this._then);

  final WeakArea _self;
  final $Res Function(WeakArea) _then;

/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? id = null,Object? reasons = null,Object? accuracy = null,Object? attempts = null,Object? trend = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeakAreaKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self.reasons : reasons // ignore: cast_nullable_to_non_nullable
as Set<WeakAreaReason>,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend?,
  ));
}
/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res>? get trend {
    if (_self.trend == null) {
    return null;
  }

  return $TrendCopyWith<$Res>(_self.trend!, (value) {
    return _then(_self.copyWith(trend: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeakArea].
extension WeakAreaPatterns on WeakArea {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeakArea value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeakArea() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeakArea value)  $default,){
final _that = this;
switch (_that) {
case _WeakArea():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeakArea value)?  $default,){
final _that = this;
switch (_that) {
case _WeakArea() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WeakAreaKind kind,  String id,  Set<WeakAreaReason> reasons,  double accuracy,  int attempts,  Trend? trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeakArea() when $default != null:
return $default(_that.kind,_that.id,_that.reasons,_that.accuracy,_that.attempts,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WeakAreaKind kind,  String id,  Set<WeakAreaReason> reasons,  double accuracy,  int attempts,  Trend? trend)  $default,) {final _that = this;
switch (_that) {
case _WeakArea():
return $default(_that.kind,_that.id,_that.reasons,_that.accuracy,_that.attempts,_that.trend);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WeakAreaKind kind,  String id,  Set<WeakAreaReason> reasons,  double accuracy,  int attempts,  Trend? trend)?  $default,) {final _that = this;
switch (_that) {
case _WeakArea() when $default != null:
return $default(_that.kind,_that.id,_that.reasons,_that.accuracy,_that.attempts,_that.trend);case _:
  return null;

}
}

}

/// @nodoc


class _WeakArea extends WeakArea {
  const _WeakArea({required this.kind, required this.id, required final  Set<WeakAreaReason> reasons, required this.accuracy, required this.attempts, this.trend}): _reasons = reasons,super._();
  

@override final  WeakAreaKind kind;
@override final  String id;
 final  Set<WeakAreaReason> _reasons;
@override Set<WeakAreaReason> get reasons {
  if (_reasons is EqualUnmodifiableSetView) return _reasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_reasons);
}

@override final  double accuracy;
@override final  int attempts;
/// The 30-day trend for families; null for tags.
@override final  Trend? trend;

/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeakAreaCopyWith<_WeakArea> get copyWith => __$WeakAreaCopyWithImpl<_WeakArea>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeakArea&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._reasons, _reasons)&&(identical(other.accuracy, accuracy) || other.accuracy == accuracy)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.trend, trend) || other.trend == trend));
}


@override
int get hashCode => Object.hash(runtimeType,kind,id,const DeepCollectionEquality().hash(_reasons),accuracy,attempts,trend);

@override
String toString() {
  return 'WeakArea(kind: $kind, id: $id, reasons: $reasons, accuracy: $accuracy, attempts: $attempts, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$WeakAreaCopyWith<$Res> implements $WeakAreaCopyWith<$Res> {
  factory _$WeakAreaCopyWith(_WeakArea value, $Res Function(_WeakArea) _then) = __$WeakAreaCopyWithImpl;
@override @useResult
$Res call({
 WeakAreaKind kind, String id, Set<WeakAreaReason> reasons, double accuracy, int attempts, Trend? trend
});


@override $TrendCopyWith<$Res>? get trend;

}
/// @nodoc
class __$WeakAreaCopyWithImpl<$Res>
    implements _$WeakAreaCopyWith<$Res> {
  __$WeakAreaCopyWithImpl(this._self, this._then);

  final _WeakArea _self;
  final $Res Function(_WeakArea) _then;

/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? id = null,Object? reasons = null,Object? accuracy = null,Object? attempts = null,Object? trend = freezed,}) {
  return _then(_WeakArea(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as WeakAreaKind,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,reasons: null == reasons ? _self._reasons : reasons // ignore: cast_nullable_to_non_nullable
as Set<WeakAreaReason>,accuracy: null == accuracy ? _self.accuracy : accuracy // ignore: cast_nullable_to_non_nullable
as double,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as Trend?,
  ));
}

/// Create a copy of WeakArea
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TrendCopyWith<$Res>? get trend {
    if (_self.trend == null) {
    return null;
  }

  return $TrendCopyWith<$Res>(_self.trend!, (value) {
    return _then(_self.copyWith(trend: value));
  });
}
}

// dart format on
