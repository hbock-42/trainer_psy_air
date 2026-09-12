// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timing_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimingPolicy {

 int? get perItemMs; int? get sectionMs; Cadence? get cadence;
/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimingPolicyCopyWith<TimingPolicy> get copyWith => _$TimingPolicyCopyWithImpl<TimingPolicy>(this as TimingPolicy, _$identity);

  /// Serializes this TimingPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimingPolicy&&(identical(other.perItemMs, perItemMs) || other.perItemMs == perItemMs)&&(identical(other.sectionMs, sectionMs) || other.sectionMs == sectionMs)&&(identical(other.cadence, cadence) || other.cadence == cadence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,perItemMs,sectionMs,cadence);

@override
String toString() {
  return 'TimingPolicy(perItemMs: $perItemMs, sectionMs: $sectionMs, cadence: $cadence)';
}


}

/// @nodoc
abstract mixin class $TimingPolicyCopyWith<$Res>  {
  factory $TimingPolicyCopyWith(TimingPolicy value, $Res Function(TimingPolicy) _then) = _$TimingPolicyCopyWithImpl;
@useResult
$Res call({
 int? perItemMs, int? sectionMs, Cadence? cadence
});


$CadenceCopyWith<$Res>? get cadence;

}
/// @nodoc
class _$TimingPolicyCopyWithImpl<$Res>
    implements $TimingPolicyCopyWith<$Res> {
  _$TimingPolicyCopyWithImpl(this._self, this._then);

  final TimingPolicy _self;
  final $Res Function(TimingPolicy) _then;

/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? perItemMs = freezed,Object? sectionMs = freezed,Object? cadence = freezed,}) {
  return _then(_self.copyWith(
perItemMs: freezed == perItemMs ? _self.perItemMs : perItemMs // ignore: cast_nullable_to_non_nullable
as int?,sectionMs: freezed == sectionMs ? _self.sectionMs : sectionMs // ignore: cast_nullable_to_non_nullable
as int?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as Cadence?,
  ));
}
/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CadenceCopyWith<$Res>? get cadence {
    if (_self.cadence == null) {
    return null;
  }

  return $CadenceCopyWith<$Res>(_self.cadence!, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}
}


/// Adds pattern-matching-related methods to [TimingPolicy].
extension TimingPolicyPatterns on TimingPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimingPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimingPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimingPolicy value)  $default,){
final _that = this;
switch (_that) {
case _TimingPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimingPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _TimingPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? perItemMs,  int? sectionMs,  Cadence? cadence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimingPolicy() when $default != null:
return $default(_that.perItemMs,_that.sectionMs,_that.cadence);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? perItemMs,  int? sectionMs,  Cadence? cadence)  $default,) {final _that = this;
switch (_that) {
case _TimingPolicy():
return $default(_that.perItemMs,_that.sectionMs,_that.cadence);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? perItemMs,  int? sectionMs,  Cadence? cadence)?  $default,) {final _that = this;
switch (_that) {
case _TimingPolicy() when $default != null:
return $default(_that.perItemMs,_that.sectionMs,_that.cadence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimingPolicy extends TimingPolicy {
  const _TimingPolicy({this.perItemMs, this.sectionMs, this.cadence}): super._();
  factory _TimingPolicy.fromJson(Map<String, dynamic> json) => _$TimingPolicyFromJson(json);

@override final  int? perItemMs;
@override final  int? sectionMs;
@override final  Cadence? cadence;

/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimingPolicyCopyWith<_TimingPolicy> get copyWith => __$TimingPolicyCopyWithImpl<_TimingPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimingPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimingPolicy&&(identical(other.perItemMs, perItemMs) || other.perItemMs == perItemMs)&&(identical(other.sectionMs, sectionMs) || other.sectionMs == sectionMs)&&(identical(other.cadence, cadence) || other.cadence == cadence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,perItemMs,sectionMs,cadence);

@override
String toString() {
  return 'TimingPolicy(perItemMs: $perItemMs, sectionMs: $sectionMs, cadence: $cadence)';
}


}

/// @nodoc
abstract mixin class _$TimingPolicyCopyWith<$Res> implements $TimingPolicyCopyWith<$Res> {
  factory _$TimingPolicyCopyWith(_TimingPolicy value, $Res Function(_TimingPolicy) _then) = __$TimingPolicyCopyWithImpl;
@override @useResult
$Res call({
 int? perItemMs, int? sectionMs, Cadence? cadence
});


@override $CadenceCopyWith<$Res>? get cadence;

}
/// @nodoc
class __$TimingPolicyCopyWithImpl<$Res>
    implements _$TimingPolicyCopyWith<$Res> {
  __$TimingPolicyCopyWithImpl(this._self, this._then);

  final _TimingPolicy _self;
  final $Res Function(_TimingPolicy) _then;

/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? perItemMs = freezed,Object? sectionMs = freezed,Object? cadence = freezed,}) {
  return _then(_TimingPolicy(
perItemMs: freezed == perItemMs ? _self.perItemMs : perItemMs // ignore: cast_nullable_to_non_nullable
as int?,sectionMs: freezed == sectionMs ? _self.sectionMs : sectionMs // ignore: cast_nullable_to_non_nullable
as int?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as Cadence?,
  ));
}

/// Create a copy of TimingPolicy
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CadenceCopyWith<$Res>? get cadence {
    if (_self.cadence == null) {
    return null;
  }

  return $CadenceCopyWith<$Res>(_self.cadence!, (value) {
    return _then(_self.copyWith(cadence: value));
  });
}
}

// dart format on
