// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'readiness_score.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReadinessScore {

 double get value;/// Weighted mean of family level fractions over all families.
 double get familyComponent;/// Lessons read / lessons available (0 when there are no lessons).
 double get lessonComponent;/// Mean global score of the most recent exam simulations (0 without).
 double get examComponent; int get familiesPractised; int get familiesTotal; int get lessonsRead; int get lessonsTotal; int get examsCounted;
/// Create a copy of ReadinessScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReadinessScoreCopyWith<ReadinessScore> get copyWith => _$ReadinessScoreCopyWithImpl<ReadinessScore>(this as ReadinessScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReadinessScore&&(identical(other.value, value) || other.value == value)&&(identical(other.familyComponent, familyComponent) || other.familyComponent == familyComponent)&&(identical(other.lessonComponent, lessonComponent) || other.lessonComponent == lessonComponent)&&(identical(other.examComponent, examComponent) || other.examComponent == examComponent)&&(identical(other.familiesPractised, familiesPractised) || other.familiesPractised == familiesPractised)&&(identical(other.familiesTotal, familiesTotal) || other.familiesTotal == familiesTotal)&&(identical(other.lessonsRead, lessonsRead) || other.lessonsRead == lessonsRead)&&(identical(other.lessonsTotal, lessonsTotal) || other.lessonsTotal == lessonsTotal)&&(identical(other.examsCounted, examsCounted) || other.examsCounted == examsCounted));
}


@override
int get hashCode => Object.hash(runtimeType,value,familyComponent,lessonComponent,examComponent,familiesPractised,familiesTotal,lessonsRead,lessonsTotal,examsCounted);

@override
String toString() {
  return 'ReadinessScore(value: $value, familyComponent: $familyComponent, lessonComponent: $lessonComponent, examComponent: $examComponent, familiesPractised: $familiesPractised, familiesTotal: $familiesTotal, lessonsRead: $lessonsRead, lessonsTotal: $lessonsTotal, examsCounted: $examsCounted)';
}


}

/// @nodoc
abstract mixin class $ReadinessScoreCopyWith<$Res>  {
  factory $ReadinessScoreCopyWith(ReadinessScore value, $Res Function(ReadinessScore) _then) = _$ReadinessScoreCopyWithImpl;
@useResult
$Res call({
 double value, double familyComponent, double lessonComponent, double examComponent, int familiesPractised, int familiesTotal, int lessonsRead, int lessonsTotal, int examsCounted
});




}
/// @nodoc
class _$ReadinessScoreCopyWithImpl<$Res>
    implements $ReadinessScoreCopyWith<$Res> {
  _$ReadinessScoreCopyWithImpl(this._self, this._then);

  final ReadinessScore _self;
  final $Res Function(ReadinessScore) _then;

/// Create a copy of ReadinessScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? familyComponent = null,Object? lessonComponent = null,Object? examComponent = null,Object? familiesPractised = null,Object? familiesTotal = null,Object? lessonsRead = null,Object? lessonsTotal = null,Object? examsCounted = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,familyComponent: null == familyComponent ? _self.familyComponent : familyComponent // ignore: cast_nullable_to_non_nullable
as double,lessonComponent: null == lessonComponent ? _self.lessonComponent : lessonComponent // ignore: cast_nullable_to_non_nullable
as double,examComponent: null == examComponent ? _self.examComponent : examComponent // ignore: cast_nullable_to_non_nullable
as double,familiesPractised: null == familiesPractised ? _self.familiesPractised : familiesPractised // ignore: cast_nullable_to_non_nullable
as int,familiesTotal: null == familiesTotal ? _self.familiesTotal : familiesTotal // ignore: cast_nullable_to_non_nullable
as int,lessonsRead: null == lessonsRead ? _self.lessonsRead : lessonsRead // ignore: cast_nullable_to_non_nullable
as int,lessonsTotal: null == lessonsTotal ? _self.lessonsTotal : lessonsTotal // ignore: cast_nullable_to_non_nullable
as int,examsCounted: null == examsCounted ? _self.examsCounted : examsCounted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReadinessScore].
extension ReadinessScorePatterns on ReadinessScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReadinessScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReadinessScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReadinessScore value)  $default,){
final _that = this;
switch (_that) {
case _ReadinessScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReadinessScore value)?  $default,){
final _that = this;
switch (_that) {
case _ReadinessScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double value,  double familyComponent,  double lessonComponent,  double examComponent,  int familiesPractised,  int familiesTotal,  int lessonsRead,  int lessonsTotal,  int examsCounted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReadinessScore() when $default != null:
return $default(_that.value,_that.familyComponent,_that.lessonComponent,_that.examComponent,_that.familiesPractised,_that.familiesTotal,_that.lessonsRead,_that.lessonsTotal,_that.examsCounted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double value,  double familyComponent,  double lessonComponent,  double examComponent,  int familiesPractised,  int familiesTotal,  int lessonsRead,  int lessonsTotal,  int examsCounted)  $default,) {final _that = this;
switch (_that) {
case _ReadinessScore():
return $default(_that.value,_that.familyComponent,_that.lessonComponent,_that.examComponent,_that.familiesPractised,_that.familiesTotal,_that.lessonsRead,_that.lessonsTotal,_that.examsCounted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double value,  double familyComponent,  double lessonComponent,  double examComponent,  int familiesPractised,  int familiesTotal,  int lessonsRead,  int lessonsTotal,  int examsCounted)?  $default,) {final _that = this;
switch (_that) {
case _ReadinessScore() when $default != null:
return $default(_that.value,_that.familyComponent,_that.lessonComponent,_that.examComponent,_that.familiesPractised,_that.familiesTotal,_that.lessonsRead,_that.lessonsTotal,_that.examsCounted);case _:
  return null;

}
}

}

/// @nodoc


class _ReadinessScore extends ReadinessScore {
  const _ReadinessScore({required this.value, required this.familyComponent, required this.lessonComponent, required this.examComponent, required this.familiesPractised, required this.familiesTotal, required this.lessonsRead, required this.lessonsTotal, required this.examsCounted}): super._();
  

@override final  double value;
/// Weighted mean of family level fractions over all families.
@override final  double familyComponent;
/// Lessons read / lessons available (0 when there are no lessons).
@override final  double lessonComponent;
/// Mean global score of the most recent exam simulations (0 without).
@override final  double examComponent;
@override final  int familiesPractised;
@override final  int familiesTotal;
@override final  int lessonsRead;
@override final  int lessonsTotal;
@override final  int examsCounted;

/// Create a copy of ReadinessScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReadinessScoreCopyWith<_ReadinessScore> get copyWith => __$ReadinessScoreCopyWithImpl<_ReadinessScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReadinessScore&&(identical(other.value, value) || other.value == value)&&(identical(other.familyComponent, familyComponent) || other.familyComponent == familyComponent)&&(identical(other.lessonComponent, lessonComponent) || other.lessonComponent == lessonComponent)&&(identical(other.examComponent, examComponent) || other.examComponent == examComponent)&&(identical(other.familiesPractised, familiesPractised) || other.familiesPractised == familiesPractised)&&(identical(other.familiesTotal, familiesTotal) || other.familiesTotal == familiesTotal)&&(identical(other.lessonsRead, lessonsRead) || other.lessonsRead == lessonsRead)&&(identical(other.lessonsTotal, lessonsTotal) || other.lessonsTotal == lessonsTotal)&&(identical(other.examsCounted, examsCounted) || other.examsCounted == examsCounted));
}


@override
int get hashCode => Object.hash(runtimeType,value,familyComponent,lessonComponent,examComponent,familiesPractised,familiesTotal,lessonsRead,lessonsTotal,examsCounted);

@override
String toString() {
  return 'ReadinessScore(value: $value, familyComponent: $familyComponent, lessonComponent: $lessonComponent, examComponent: $examComponent, familiesPractised: $familiesPractised, familiesTotal: $familiesTotal, lessonsRead: $lessonsRead, lessonsTotal: $lessonsTotal, examsCounted: $examsCounted)';
}


}

/// @nodoc
abstract mixin class _$ReadinessScoreCopyWith<$Res> implements $ReadinessScoreCopyWith<$Res> {
  factory _$ReadinessScoreCopyWith(_ReadinessScore value, $Res Function(_ReadinessScore) _then) = __$ReadinessScoreCopyWithImpl;
@override @useResult
$Res call({
 double value, double familyComponent, double lessonComponent, double examComponent, int familiesPractised, int familiesTotal, int lessonsRead, int lessonsTotal, int examsCounted
});




}
/// @nodoc
class __$ReadinessScoreCopyWithImpl<$Res>
    implements _$ReadinessScoreCopyWith<$Res> {
  __$ReadinessScoreCopyWithImpl(this._self, this._then);

  final _ReadinessScore _self;
  final $Res Function(_ReadinessScore) _then;

/// Create a copy of ReadinessScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? familyComponent = null,Object? lessonComponent = null,Object? examComponent = null,Object? familiesPractised = null,Object? familiesTotal = null,Object? lessonsRead = null,Object? lessonsTotal = null,Object? examsCounted = null,}) {
  return _then(_ReadinessScore(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,familyComponent: null == familyComponent ? _self.familyComponent : familyComponent // ignore: cast_nullable_to_non_nullable
as double,lessonComponent: null == lessonComponent ? _self.lessonComponent : lessonComponent // ignore: cast_nullable_to_non_nullable
as double,examComponent: null == examComponent ? _self.examComponent : examComponent // ignore: cast_nullable_to_non_nullable
as double,familiesPractised: null == familiesPractised ? _self.familiesPractised : familiesPractised // ignore: cast_nullable_to_non_nullable
as int,familiesTotal: null == familiesTotal ? _self.familiesTotal : familiesTotal // ignore: cast_nullable_to_non_nullable
as int,lessonsRead: null == lessonsRead ? _self.lessonsRead : lessonsRead // ignore: cast_nullable_to_non_nullable
as int,lessonsTotal: null == lessonsTotal ? _self.lessonsTotal : lessonsTotal // ignore: cast_nullable_to_non_nullable
as int,examsCounted: null == examsCounted ? _self.examsCounted : examsCounted // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
