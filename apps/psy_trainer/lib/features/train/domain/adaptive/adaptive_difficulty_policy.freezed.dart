// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'adaptive_difficulty_policy.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdaptiveDifficultyPolicy {

 int get correctStreakToLevelUp; int get wrongStreakToLevelDown; int get minLevel; int get maxLevel; double get fastFactorOfLimit;
/// Create a copy of AdaptiveDifficultyPolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdaptiveDifficultyPolicyCopyWith<AdaptiveDifficultyPolicy> get copyWith => _$AdaptiveDifficultyPolicyCopyWithImpl<AdaptiveDifficultyPolicy>(this as AdaptiveDifficultyPolicy, _$identity);

  /// Serializes this AdaptiveDifficultyPolicy to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdaptiveDifficultyPolicy&&(identical(other.correctStreakToLevelUp, correctStreakToLevelUp) || other.correctStreakToLevelUp == correctStreakToLevelUp)&&(identical(other.wrongStreakToLevelDown, wrongStreakToLevelDown) || other.wrongStreakToLevelDown == wrongStreakToLevelDown)&&(identical(other.minLevel, minLevel) || other.minLevel == minLevel)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel)&&(identical(other.fastFactorOfLimit, fastFactorOfLimit) || other.fastFactorOfLimit == fastFactorOfLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correctStreakToLevelUp,wrongStreakToLevelDown,minLevel,maxLevel,fastFactorOfLimit);

@override
String toString() {
  return 'AdaptiveDifficultyPolicy(correctStreakToLevelUp: $correctStreakToLevelUp, wrongStreakToLevelDown: $wrongStreakToLevelDown, minLevel: $minLevel, maxLevel: $maxLevel, fastFactorOfLimit: $fastFactorOfLimit)';
}


}

/// @nodoc
abstract mixin class $AdaptiveDifficultyPolicyCopyWith<$Res>  {
  factory $AdaptiveDifficultyPolicyCopyWith(AdaptiveDifficultyPolicy value, $Res Function(AdaptiveDifficultyPolicy) _then) = _$AdaptiveDifficultyPolicyCopyWithImpl;
@useResult
$Res call({
 int correctStreakToLevelUp, int wrongStreakToLevelDown, int minLevel, int maxLevel, double fastFactorOfLimit
});




}
/// @nodoc
class _$AdaptiveDifficultyPolicyCopyWithImpl<$Res>
    implements $AdaptiveDifficultyPolicyCopyWith<$Res> {
  _$AdaptiveDifficultyPolicyCopyWithImpl(this._self, this._then);

  final AdaptiveDifficultyPolicy _self;
  final $Res Function(AdaptiveDifficultyPolicy) _then;

/// Create a copy of AdaptiveDifficultyPolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correctStreakToLevelUp = null,Object? wrongStreakToLevelDown = null,Object? minLevel = null,Object? maxLevel = null,Object? fastFactorOfLimit = null,}) {
  return _then(_self.copyWith(
correctStreakToLevelUp: null == correctStreakToLevelUp ? _self.correctStreakToLevelUp : correctStreakToLevelUp // ignore: cast_nullable_to_non_nullable
as int,wrongStreakToLevelDown: null == wrongStreakToLevelDown ? _self.wrongStreakToLevelDown : wrongStreakToLevelDown // ignore: cast_nullable_to_non_nullable
as int,minLevel: null == minLevel ? _self.minLevel : minLevel // ignore: cast_nullable_to_non_nullable
as int,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,fastFactorOfLimit: null == fastFactorOfLimit ? _self.fastFactorOfLimit : fastFactorOfLimit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AdaptiveDifficultyPolicy].
extension AdaptiveDifficultyPolicyPatterns on AdaptiveDifficultyPolicy {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdaptiveDifficultyPolicy value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdaptiveDifficultyPolicy value)  $default,){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdaptiveDifficultyPolicy value)?  $default,){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correctStreakToLevelUp,  int wrongStreakToLevelDown,  int minLevel,  int maxLevel,  double fastFactorOfLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy() when $default != null:
return $default(_that.correctStreakToLevelUp,_that.wrongStreakToLevelDown,_that.minLevel,_that.maxLevel,_that.fastFactorOfLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correctStreakToLevelUp,  int wrongStreakToLevelDown,  int minLevel,  int maxLevel,  double fastFactorOfLimit)  $default,) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy():
return $default(_that.correctStreakToLevelUp,_that.wrongStreakToLevelDown,_that.minLevel,_that.maxLevel,_that.fastFactorOfLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correctStreakToLevelUp,  int wrongStreakToLevelDown,  int minLevel,  int maxLevel,  double fastFactorOfLimit)?  $default,) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyPolicy() when $default != null:
return $default(_that.correctStreakToLevelUp,_that.wrongStreakToLevelDown,_that.minLevel,_that.maxLevel,_that.fastFactorOfLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdaptiveDifficultyPolicy extends AdaptiveDifficultyPolicy {
  const _AdaptiveDifficultyPolicy({this.correctStreakToLevelUp = 3, this.wrongStreakToLevelDown = 2, this.minLevel = 1, this.maxLevel = 5, this.fastFactorOfLimit = 0.6}): super._();
  factory _AdaptiveDifficultyPolicy.fromJson(Map<String, dynamic> json) => _$AdaptiveDifficultyPolicyFromJson(json);

@override@JsonKey() final  int correctStreakToLevelUp;
@override@JsonKey() final  int wrongStreakToLevelDown;
@override@JsonKey() final  int minLevel;
@override@JsonKey() final  int maxLevel;
@override@JsonKey() final  double fastFactorOfLimit;

/// Create a copy of AdaptiveDifficultyPolicy
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdaptiveDifficultyPolicyCopyWith<_AdaptiveDifficultyPolicy> get copyWith => __$AdaptiveDifficultyPolicyCopyWithImpl<_AdaptiveDifficultyPolicy>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdaptiveDifficultyPolicyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdaptiveDifficultyPolicy&&(identical(other.correctStreakToLevelUp, correctStreakToLevelUp) || other.correctStreakToLevelUp == correctStreakToLevelUp)&&(identical(other.wrongStreakToLevelDown, wrongStreakToLevelDown) || other.wrongStreakToLevelDown == wrongStreakToLevelDown)&&(identical(other.minLevel, minLevel) || other.minLevel == minLevel)&&(identical(other.maxLevel, maxLevel) || other.maxLevel == maxLevel)&&(identical(other.fastFactorOfLimit, fastFactorOfLimit) || other.fastFactorOfLimit == fastFactorOfLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,correctStreakToLevelUp,wrongStreakToLevelDown,minLevel,maxLevel,fastFactorOfLimit);

@override
String toString() {
  return 'AdaptiveDifficultyPolicy(correctStreakToLevelUp: $correctStreakToLevelUp, wrongStreakToLevelDown: $wrongStreakToLevelDown, minLevel: $minLevel, maxLevel: $maxLevel, fastFactorOfLimit: $fastFactorOfLimit)';
}


}

/// @nodoc
abstract mixin class _$AdaptiveDifficultyPolicyCopyWith<$Res> implements $AdaptiveDifficultyPolicyCopyWith<$Res> {
  factory _$AdaptiveDifficultyPolicyCopyWith(_AdaptiveDifficultyPolicy value, $Res Function(_AdaptiveDifficultyPolicy) _then) = __$AdaptiveDifficultyPolicyCopyWithImpl;
@override @useResult
$Res call({
 int correctStreakToLevelUp, int wrongStreakToLevelDown, int minLevel, int maxLevel, double fastFactorOfLimit
});




}
/// @nodoc
class __$AdaptiveDifficultyPolicyCopyWithImpl<$Res>
    implements _$AdaptiveDifficultyPolicyCopyWith<$Res> {
  __$AdaptiveDifficultyPolicyCopyWithImpl(this._self, this._then);

  final _AdaptiveDifficultyPolicy _self;
  final $Res Function(_AdaptiveDifficultyPolicy) _then;

/// Create a copy of AdaptiveDifficultyPolicy
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correctStreakToLevelUp = null,Object? wrongStreakToLevelDown = null,Object? minLevel = null,Object? maxLevel = null,Object? fastFactorOfLimit = null,}) {
  return _then(_AdaptiveDifficultyPolicy(
correctStreakToLevelUp: null == correctStreakToLevelUp ? _self.correctStreakToLevelUp : correctStreakToLevelUp // ignore: cast_nullable_to_non_nullable
as int,wrongStreakToLevelDown: null == wrongStreakToLevelDown ? _self.wrongStreakToLevelDown : wrongStreakToLevelDown // ignore: cast_nullable_to_non_nullable
as int,minLevel: null == minLevel ? _self.minLevel : minLevel // ignore: cast_nullable_to_non_nullable
as int,maxLevel: null == maxLevel ? _self.maxLevel : maxLevel // ignore: cast_nullable_to_non_nullable
as int,fastFactorOfLimit: null == fastFactorOfLimit ? _self.fastFactorOfLimit : fastFactorOfLimit // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$AdaptiveDifficultyState {

 int get level; int get correctFastStreak; int get wrongStreak;
/// Create a copy of AdaptiveDifficultyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdaptiveDifficultyStateCopyWith<AdaptiveDifficultyState> get copyWith => _$AdaptiveDifficultyStateCopyWithImpl<AdaptiveDifficultyState>(this as AdaptiveDifficultyState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdaptiveDifficultyState&&(identical(other.level, level) || other.level == level)&&(identical(other.correctFastStreak, correctFastStreak) || other.correctFastStreak == correctFastStreak)&&(identical(other.wrongStreak, wrongStreak) || other.wrongStreak == wrongStreak));
}


@override
int get hashCode => Object.hash(runtimeType,level,correctFastStreak,wrongStreak);

@override
String toString() {
  return 'AdaptiveDifficultyState(level: $level, correctFastStreak: $correctFastStreak, wrongStreak: $wrongStreak)';
}


}

/// @nodoc
abstract mixin class $AdaptiveDifficultyStateCopyWith<$Res>  {
  factory $AdaptiveDifficultyStateCopyWith(AdaptiveDifficultyState value, $Res Function(AdaptiveDifficultyState) _then) = _$AdaptiveDifficultyStateCopyWithImpl;
@useResult
$Res call({
 int level, int correctFastStreak, int wrongStreak
});




}
/// @nodoc
class _$AdaptiveDifficultyStateCopyWithImpl<$Res>
    implements $AdaptiveDifficultyStateCopyWith<$Res> {
  _$AdaptiveDifficultyStateCopyWithImpl(this._self, this._then);

  final AdaptiveDifficultyState _self;
  final $Res Function(AdaptiveDifficultyState) _then;

/// Create a copy of AdaptiveDifficultyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? correctFastStreak = null,Object? wrongStreak = null,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,correctFastStreak: null == correctFastStreak ? _self.correctFastStreak : correctFastStreak // ignore: cast_nullable_to_non_nullable
as int,wrongStreak: null == wrongStreak ? _self.wrongStreak : wrongStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AdaptiveDifficultyState].
extension AdaptiveDifficultyStatePatterns on AdaptiveDifficultyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdaptiveDifficultyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdaptiveDifficultyState value)  $default,){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdaptiveDifficultyState value)?  $default,){
final _that = this;
switch (_that) {
case _AdaptiveDifficultyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  int correctFastStreak,  int wrongStreak)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyState() when $default != null:
return $default(_that.level,_that.correctFastStreak,_that.wrongStreak);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  int correctFastStreak,  int wrongStreak)  $default,) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyState():
return $default(_that.level,_that.correctFastStreak,_that.wrongStreak);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  int correctFastStreak,  int wrongStreak)?  $default,) {final _that = this;
switch (_that) {
case _AdaptiveDifficultyState() when $default != null:
return $default(_that.level,_that.correctFastStreak,_that.wrongStreak);case _:
  return null;

}
}

}

/// @nodoc


class _AdaptiveDifficultyState implements AdaptiveDifficultyState {
  const _AdaptiveDifficultyState({required this.level, this.correctFastStreak = 0, this.wrongStreak = 0});
  

@override final  int level;
@override@JsonKey() final  int correctFastStreak;
@override@JsonKey() final  int wrongStreak;

/// Create a copy of AdaptiveDifficultyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdaptiveDifficultyStateCopyWith<_AdaptiveDifficultyState> get copyWith => __$AdaptiveDifficultyStateCopyWithImpl<_AdaptiveDifficultyState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdaptiveDifficultyState&&(identical(other.level, level) || other.level == level)&&(identical(other.correctFastStreak, correctFastStreak) || other.correctFastStreak == correctFastStreak)&&(identical(other.wrongStreak, wrongStreak) || other.wrongStreak == wrongStreak));
}


@override
int get hashCode => Object.hash(runtimeType,level,correctFastStreak,wrongStreak);

@override
String toString() {
  return 'AdaptiveDifficultyState(level: $level, correctFastStreak: $correctFastStreak, wrongStreak: $wrongStreak)';
}


}

/// @nodoc
abstract mixin class _$AdaptiveDifficultyStateCopyWith<$Res> implements $AdaptiveDifficultyStateCopyWith<$Res> {
  factory _$AdaptiveDifficultyStateCopyWith(_AdaptiveDifficultyState value, $Res Function(_AdaptiveDifficultyState) _then) = __$AdaptiveDifficultyStateCopyWithImpl;
@override @useResult
$Res call({
 int level, int correctFastStreak, int wrongStreak
});




}
/// @nodoc
class __$AdaptiveDifficultyStateCopyWithImpl<$Res>
    implements _$AdaptiveDifficultyStateCopyWith<$Res> {
  __$AdaptiveDifficultyStateCopyWithImpl(this._self, this._then);

  final _AdaptiveDifficultyState _self;
  final $Res Function(_AdaptiveDifficultyState) _then;

/// Create a copy of AdaptiveDifficultyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? correctFastStreak = null,Object? wrongStreak = null,}) {
  return _then(_AdaptiveDifficultyState(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,correctFastStreak: null == correctFastStreak ? _self.correctFastStreak : correctFastStreak // ignore: cast_nullable_to_non_nullable
as int,wrongStreak: null == wrongStreak ? _self.wrongStreak : wrongStreak // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LevelChange {

 int get atItemIndex; int get from; int get to;
/// Create a copy of LevelChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LevelChangeCopyWith<LevelChange> get copyWith => _$LevelChangeCopyWithImpl<LevelChange>(this as LevelChange, _$identity);

  /// Serializes this LevelChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LevelChange&&(identical(other.atItemIndex, atItemIndex) || other.atItemIndex == atItemIndex)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,atItemIndex,from,to);

@override
String toString() {
  return 'LevelChange(atItemIndex: $atItemIndex, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class $LevelChangeCopyWith<$Res>  {
  factory $LevelChangeCopyWith(LevelChange value, $Res Function(LevelChange) _then) = _$LevelChangeCopyWithImpl;
@useResult
$Res call({
 int atItemIndex, int from, int to
});




}
/// @nodoc
class _$LevelChangeCopyWithImpl<$Res>
    implements $LevelChangeCopyWith<$Res> {
  _$LevelChangeCopyWithImpl(this._self, this._then);

  final LevelChange _self;
  final $Res Function(LevelChange) _then;

/// Create a copy of LevelChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? atItemIndex = null,Object? from = null,Object? to = null,}) {
  return _then(_self.copyWith(
atItemIndex: null == atItemIndex ? _self.atItemIndex : atItemIndex // ignore: cast_nullable_to_non_nullable
as int,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LevelChange].
extension LevelChangePatterns on LevelChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LevelChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LevelChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LevelChange value)  $default,){
final _that = this;
switch (_that) {
case _LevelChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LevelChange value)?  $default,){
final _that = this;
switch (_that) {
case _LevelChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int atItemIndex,  int from,  int to)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LevelChange() when $default != null:
return $default(_that.atItemIndex,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int atItemIndex,  int from,  int to)  $default,) {final _that = this;
switch (_that) {
case _LevelChange():
return $default(_that.atItemIndex,_that.from,_that.to);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int atItemIndex,  int from,  int to)?  $default,) {final _that = this;
switch (_that) {
case _LevelChange() when $default != null:
return $default(_that.atItemIndex,_that.from,_that.to);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LevelChange implements LevelChange {
  const _LevelChange({required this.atItemIndex, required this.from, required this.to});
  factory _LevelChange.fromJson(Map<String, dynamic> json) => _$LevelChangeFromJson(json);

@override final  int atItemIndex;
@override final  int from;
@override final  int to;

/// Create a copy of LevelChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LevelChangeCopyWith<_LevelChange> get copyWith => __$LevelChangeCopyWithImpl<_LevelChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LevelChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LevelChange&&(identical(other.atItemIndex, atItemIndex) || other.atItemIndex == atItemIndex)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,atItemIndex,from,to);

@override
String toString() {
  return 'LevelChange(atItemIndex: $atItemIndex, from: $from, to: $to)';
}


}

/// @nodoc
abstract mixin class _$LevelChangeCopyWith<$Res> implements $LevelChangeCopyWith<$Res> {
  factory _$LevelChangeCopyWith(_LevelChange value, $Res Function(_LevelChange) _then) = __$LevelChangeCopyWithImpl;
@override @useResult
$Res call({
 int atItemIndex, int from, int to
});




}
/// @nodoc
class __$LevelChangeCopyWithImpl<$Res>
    implements _$LevelChangeCopyWith<$Res> {
  __$LevelChangeCopyWithImpl(this._self, this._then);

  final _LevelChange _self;
  final $Res Function(_LevelChange) _then;

/// Create a copy of LevelChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? atItemIndex = null,Object? from = null,Object? to = null,}) {
  return _then(_LevelChange(
atItemIndex: null == atItemIndex ? _self.atItemIndex : atItemIndex // ignore: cast_nullable_to_non_nullable
as int,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as int,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
