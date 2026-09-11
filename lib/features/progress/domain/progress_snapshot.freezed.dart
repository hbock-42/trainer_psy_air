// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'progress_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProgressSnapshot {

 DateTime get computedAt; List<FamilyProgress> get families; ReadinessScore get readiness; List<WeakArea> get weakAreas; List<ExamSummary> get exams;
/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProgressSnapshotCopyWith<ProgressSnapshot> get copyWith => _$ProgressSnapshotCopyWithImpl<ProgressSnapshot>(this as ProgressSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProgressSnapshot&&(identical(other.computedAt, computedAt) || other.computedAt == computedAt)&&const DeepCollectionEquality().equals(other.families, families)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&const DeepCollectionEquality().equals(other.weakAreas, weakAreas)&&const DeepCollectionEquality().equals(other.exams, exams));
}


@override
int get hashCode => Object.hash(runtimeType,computedAt,const DeepCollectionEquality().hash(families),readiness,const DeepCollectionEquality().hash(weakAreas),const DeepCollectionEquality().hash(exams));

@override
String toString() {
  return 'ProgressSnapshot(computedAt: $computedAt, families: $families, readiness: $readiness, weakAreas: $weakAreas, exams: $exams)';
}


}

/// @nodoc
abstract mixin class $ProgressSnapshotCopyWith<$Res>  {
  factory $ProgressSnapshotCopyWith(ProgressSnapshot value, $Res Function(ProgressSnapshot) _then) = _$ProgressSnapshotCopyWithImpl;
@useResult
$Res call({
 DateTime computedAt, List<FamilyProgress> families, ReadinessScore readiness, List<WeakArea> weakAreas, List<ExamSummary> exams
});


$ReadinessScoreCopyWith<$Res> get readiness;

}
/// @nodoc
class _$ProgressSnapshotCopyWithImpl<$Res>
    implements $ProgressSnapshotCopyWith<$Res> {
  _$ProgressSnapshotCopyWithImpl(this._self, this._then);

  final ProgressSnapshot _self;
  final $Res Function(ProgressSnapshot) _then;

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? computedAt = null,Object? families = null,Object? readiness = null,Object? weakAreas = null,Object? exams = null,}) {
  return _then(_self.copyWith(
computedAt: null == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as DateTime,families: null == families ? _self.families : families // ignore: cast_nullable_to_non_nullable
as List<FamilyProgress>,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as ReadinessScore,weakAreas: null == weakAreas ? _self.weakAreas : weakAreas // ignore: cast_nullable_to_non_nullable
as List<WeakArea>,exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamSummary>,
  ));
}
/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReadinessScoreCopyWith<$Res> get readiness {
  
  return $ReadinessScoreCopyWith<$Res>(_self.readiness, (value) {
    return _then(_self.copyWith(readiness: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProgressSnapshot].
extension ProgressSnapshotPatterns on ProgressSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProgressSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProgressSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ProgressSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProgressSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime computedAt,  List<FamilyProgress> families,  ReadinessScore readiness,  List<WeakArea> weakAreas,  List<ExamSummary> exams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
return $default(_that.computedAt,_that.families,_that.readiness,_that.weakAreas,_that.exams);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime computedAt,  List<FamilyProgress> families,  ReadinessScore readiness,  List<WeakArea> weakAreas,  List<ExamSummary> exams)  $default,) {final _that = this;
switch (_that) {
case _ProgressSnapshot():
return $default(_that.computedAt,_that.families,_that.readiness,_that.weakAreas,_that.exams);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime computedAt,  List<FamilyProgress> families,  ReadinessScore readiness,  List<WeakArea> weakAreas,  List<ExamSummary> exams)?  $default,) {final _that = this;
switch (_that) {
case _ProgressSnapshot() when $default != null:
return $default(_that.computedAt,_that.families,_that.readiness,_that.weakAreas,_that.exams);case _:
  return null;

}
}

}

/// @nodoc


class _ProgressSnapshot extends ProgressSnapshot {
  const _ProgressSnapshot({required this.computedAt, required final  List<FamilyProgress> families, required this.readiness, required final  List<WeakArea> weakAreas, required final  List<ExamSummary> exams}): _families = families,_weakAreas = weakAreas,_exams = exams,super._();
  

@override final  DateTime computedAt;
 final  List<FamilyProgress> _families;
@override List<FamilyProgress> get families {
  if (_families is EqualUnmodifiableListView) return _families;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_families);
}

@override final  ReadinessScore readiness;
 final  List<WeakArea> _weakAreas;
@override List<WeakArea> get weakAreas {
  if (_weakAreas is EqualUnmodifiableListView) return _weakAreas;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_weakAreas);
}

 final  List<ExamSummary> _exams;
@override List<ExamSummary> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}


/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProgressSnapshotCopyWith<_ProgressSnapshot> get copyWith => __$ProgressSnapshotCopyWithImpl<_ProgressSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProgressSnapshot&&(identical(other.computedAt, computedAt) || other.computedAt == computedAt)&&const DeepCollectionEquality().equals(other._families, _families)&&(identical(other.readiness, readiness) || other.readiness == readiness)&&const DeepCollectionEquality().equals(other._weakAreas, _weakAreas)&&const DeepCollectionEquality().equals(other._exams, _exams));
}


@override
int get hashCode => Object.hash(runtimeType,computedAt,const DeepCollectionEquality().hash(_families),readiness,const DeepCollectionEquality().hash(_weakAreas),const DeepCollectionEquality().hash(_exams));

@override
String toString() {
  return 'ProgressSnapshot(computedAt: $computedAt, families: $families, readiness: $readiness, weakAreas: $weakAreas, exams: $exams)';
}


}

/// @nodoc
abstract mixin class _$ProgressSnapshotCopyWith<$Res> implements $ProgressSnapshotCopyWith<$Res> {
  factory _$ProgressSnapshotCopyWith(_ProgressSnapshot value, $Res Function(_ProgressSnapshot) _then) = __$ProgressSnapshotCopyWithImpl;
@override @useResult
$Res call({
 DateTime computedAt, List<FamilyProgress> families, ReadinessScore readiness, List<WeakArea> weakAreas, List<ExamSummary> exams
});


@override $ReadinessScoreCopyWith<$Res> get readiness;

}
/// @nodoc
class __$ProgressSnapshotCopyWithImpl<$Res>
    implements _$ProgressSnapshotCopyWith<$Res> {
  __$ProgressSnapshotCopyWithImpl(this._self, this._then);

  final _ProgressSnapshot _self;
  final $Res Function(_ProgressSnapshot) _then;

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? computedAt = null,Object? families = null,Object? readiness = null,Object? weakAreas = null,Object? exams = null,}) {
  return _then(_ProgressSnapshot(
computedAt: null == computedAt ? _self.computedAt : computedAt // ignore: cast_nullable_to_non_nullable
as DateTime,families: null == families ? _self._families : families // ignore: cast_nullable_to_non_nullable
as List<FamilyProgress>,readiness: null == readiness ? _self.readiness : readiness // ignore: cast_nullable_to_non_nullable
as ReadinessScore,weakAreas: null == weakAreas ? _self._weakAreas : weakAreas // ignore: cast_nullable_to_non_nullable
as List<WeakArea>,exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamSummary>,
  ));
}

/// Create a copy of ProgressSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReadinessScoreCopyWith<$Res> get readiness {
  
  return $ReadinessScoreCopyWith<$Res>(_self.readiness, (value) {
    return _then(_self.copyWith(readiness: value));
  });
}
}

// dart format on
