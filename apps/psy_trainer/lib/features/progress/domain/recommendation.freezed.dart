// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recommendation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Recommendation {

 RecommendationKind get kind; String get title; String get reason; double get severity;/// The family id ([RecommendationKind.family] and
/// [RecommendationKind.lesson]) or the tag ([RecommendationKind.tag]);
/// null for [RecommendationKind.examSim] and
/// [RecommendationKind.flashcards].
 String? get targetId;/// The lesson id, only set for [RecommendationKind.lesson].
 String? get secondaryId;
/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecommendationCopyWith<Recommendation> get copyWith => _$RecommendationCopyWithImpl<Recommendation>(this as Recommendation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Recommendation&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.secondaryId, secondaryId) || other.secondaryId == secondaryId));
}


@override
int get hashCode => Object.hash(runtimeType,kind,title,reason,severity,targetId,secondaryId);

@override
String toString() {
  return 'Recommendation(kind: $kind, title: $title, reason: $reason, severity: $severity, targetId: $targetId, secondaryId: $secondaryId)';
}


}

/// @nodoc
abstract mixin class $RecommendationCopyWith<$Res>  {
  factory $RecommendationCopyWith(Recommendation value, $Res Function(Recommendation) _then) = _$RecommendationCopyWithImpl;
@useResult
$Res call({
 RecommendationKind kind, String title, String reason, double severity, String? targetId, String? secondaryId
});




}
/// @nodoc
class _$RecommendationCopyWithImpl<$Res>
    implements $RecommendationCopyWith<$Res> {
  _$RecommendationCopyWithImpl(this._self, this._then);

  final Recommendation _self;
  final $Res Function(Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? title = null,Object? reason = null,Object? severity = null,Object? targetId = freezed,Object? secondaryId = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RecommendationKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as double,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,secondaryId: freezed == secondaryId ? _self.secondaryId : secondaryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Recommendation].
extension RecommendationPatterns on Recommendation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Recommendation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Recommendation value)  $default,){
final _that = this;
switch (_that) {
case _Recommendation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Recommendation value)?  $default,){
final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecommendationKind kind,  String title,  String reason,  double severity,  String? targetId,  String? secondaryId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.kind,_that.title,_that.reason,_that.severity,_that.targetId,_that.secondaryId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecommendationKind kind,  String title,  String reason,  double severity,  String? targetId,  String? secondaryId)  $default,) {final _that = this;
switch (_that) {
case _Recommendation():
return $default(_that.kind,_that.title,_that.reason,_that.severity,_that.targetId,_that.secondaryId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecommendationKind kind,  String title,  String reason,  double severity,  String? targetId,  String? secondaryId)?  $default,) {final _that = this;
switch (_that) {
case _Recommendation() when $default != null:
return $default(_that.kind,_that.title,_that.reason,_that.severity,_that.targetId,_that.secondaryId);case _:
  return null;

}
}

}

/// @nodoc


class _Recommendation extends Recommendation {
  const _Recommendation({required this.kind, required this.title, required this.reason, required this.severity, this.targetId, this.secondaryId}): super._();
  

@override final  RecommendationKind kind;
@override final  String title;
@override final  String reason;
@override final  double severity;
/// The family id ([RecommendationKind.family] and
/// [RecommendationKind.lesson]) or the tag ([RecommendationKind.tag]);
/// null for [RecommendationKind.examSim] and
/// [RecommendationKind.flashcards].
@override final  String? targetId;
/// The lesson id, only set for [RecommendationKind.lesson].
@override final  String? secondaryId;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecommendationCopyWith<_Recommendation> get copyWith => __$RecommendationCopyWithImpl<_Recommendation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Recommendation&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.severity, severity) || other.severity == severity)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.secondaryId, secondaryId) || other.secondaryId == secondaryId));
}


@override
int get hashCode => Object.hash(runtimeType,kind,title,reason,severity,targetId,secondaryId);

@override
String toString() {
  return 'Recommendation(kind: $kind, title: $title, reason: $reason, severity: $severity, targetId: $targetId, secondaryId: $secondaryId)';
}


}

/// @nodoc
abstract mixin class _$RecommendationCopyWith<$Res> implements $RecommendationCopyWith<$Res> {
  factory _$RecommendationCopyWith(_Recommendation value, $Res Function(_Recommendation) _then) = __$RecommendationCopyWithImpl;
@override @useResult
$Res call({
 RecommendationKind kind, String title, String reason, double severity, String? targetId, String? secondaryId
});




}
/// @nodoc
class __$RecommendationCopyWithImpl<$Res>
    implements _$RecommendationCopyWith<$Res> {
  __$RecommendationCopyWithImpl(this._self, this._then);

  final _Recommendation _self;
  final $Res Function(_Recommendation) _then;

/// Create a copy of Recommendation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? title = null,Object? reason = null,Object? severity = null,Object? targetId = freezed,Object? secondaryId = freezed,}) {
  return _then(_Recommendation(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as RecommendationKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,severity: null == severity ? _self.severity : severity // ignore: cast_nullable_to_non_nullable
as double,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,secondaryId: freezed == secondaryId ? _self.secondaryId : secondaryId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
