// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SectionScore {

 int get sectionIndex; String get familyId; int get attempts; int get correct; int get unanswered; double get weight; double? get medianResponseMs;
/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SectionScoreCopyWith<SectionScore> get copyWith => _$SectionScoreCopyWithImpl<SectionScore>(this as SectionScore, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SectionScore&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sectionIndex,familyId,attempts,correct,unanswered,weight,medianResponseMs);

@override
String toString() {
  return 'SectionScore(sectionIndex: $sectionIndex, familyId: $familyId, attempts: $attempts, correct: $correct, unanswered: $unanswered, weight: $weight, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class $SectionScoreCopyWith<$Res>  {
  factory $SectionScoreCopyWith(SectionScore value, $Res Function(SectionScore) _then) = _$SectionScoreCopyWithImpl;
@useResult
$Res call({
 int sectionIndex, String familyId, int attempts, int correct, int unanswered, double weight, double? medianResponseMs
});




}
/// @nodoc
class _$SectionScoreCopyWithImpl<$Res>
    implements $SectionScoreCopyWith<$Res> {
  _$SectionScoreCopyWithImpl(this._self, this._then);

  final SectionScore _self;
  final $Res Function(SectionScore) _then;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sectionIndex = null,Object? familyId = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? weight = null,Object? medianResponseMs = freezed,}) {
  return _then(_self.copyWith(
sectionIndex: null == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [SectionScore].
extension SectionScorePatterns on SectionScore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SectionScore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SectionScore value)  $default,){
final _that = this;
switch (_that) {
case _SectionScore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SectionScore value)?  $default,){
final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int sectionIndex,  String familyId,  int attempts,  int correct,  int unanswered,  double weight,  double? medianResponseMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
return $default(_that.sectionIndex,_that.familyId,_that.attempts,_that.correct,_that.unanswered,_that.weight,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int sectionIndex,  String familyId,  int attempts,  int correct,  int unanswered,  double weight,  double? medianResponseMs)  $default,) {final _that = this;
switch (_that) {
case _SectionScore():
return $default(_that.sectionIndex,_that.familyId,_that.attempts,_that.correct,_that.unanswered,_that.weight,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int sectionIndex,  String familyId,  int attempts,  int correct,  int unanswered,  double weight,  double? medianResponseMs)?  $default,) {final _that = this;
switch (_that) {
case _SectionScore() when $default != null:
return $default(_that.sectionIndex,_that.familyId,_that.attempts,_that.correct,_that.unanswered,_that.weight,_that.medianResponseMs);case _:
  return null;

}
}

}

/// @nodoc


class _SectionScore extends SectionScore {
  const _SectionScore({required this.sectionIndex, required this.familyId, required this.attempts, required this.correct, required this.unanswered, required this.weight, this.medianResponseMs}): super._();
  

@override final  int sectionIndex;
@override final  String familyId;
@override final  int attempts;
@override final  int correct;
@override final  int unanswered;
@override final  double weight;
@override final  double? medianResponseMs;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SectionScoreCopyWith<_SectionScore> get copyWith => __$SectionScoreCopyWithImpl<_SectionScore>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SectionScore&&(identical(other.sectionIndex, sectionIndex) || other.sectionIndex == sectionIndex)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.weight, weight) || other.weight == weight)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sectionIndex,familyId,attempts,correct,unanswered,weight,medianResponseMs);

@override
String toString() {
  return 'SectionScore(sectionIndex: $sectionIndex, familyId: $familyId, attempts: $attempts, correct: $correct, unanswered: $unanswered, weight: $weight, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class _$SectionScoreCopyWith<$Res> implements $SectionScoreCopyWith<$Res> {
  factory _$SectionScoreCopyWith(_SectionScore value, $Res Function(_SectionScore) _then) = __$SectionScoreCopyWithImpl;
@override @useResult
$Res call({
 int sectionIndex, String familyId, int attempts, int correct, int unanswered, double weight, double? medianResponseMs
});




}
/// @nodoc
class __$SectionScoreCopyWithImpl<$Res>
    implements _$SectionScoreCopyWith<$Res> {
  __$SectionScoreCopyWithImpl(this._self, this._then);

  final _SectionScore _self;
  final $Res Function(_SectionScore) _then;

/// Create a copy of SectionScore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sectionIndex = null,Object? familyId = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? weight = null,Object? medianResponseMs = freezed,}) {
  return _then(_SectionScore(
sectionIndex: null == sectionIndex ? _self.sectionIndex : sectionIndex // ignore: cast_nullable_to_non_nullable
as int,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: freezed == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$ExamSummary {

 String get sessionId; DateTime get startedAt; SessionStatus get status;/// Weighted mean of section accuracies, 0..1.
 double get score; List<SectionScore> get sections; String? get blueprintId; DateTime? get endedAt; String? get previousSessionId;/// `score - previous.score`, in the 0..1 scale.
 double? get deltaVsPrevious;
/// Create a copy of ExamSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSummaryCopyWith<ExamSummary> get copyWith => _$ExamSummaryCopyWithImpl<ExamSummary>(this as ExamSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSummary&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.previousSessionId, previousSessionId) || other.previousSessionId == previousSessionId)&&(identical(other.deltaVsPrevious, deltaVsPrevious) || other.deltaVsPrevious == deltaVsPrevious));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,startedAt,status,score,const DeepCollectionEquality().hash(sections),blueprintId,endedAt,previousSessionId,deltaVsPrevious);

@override
String toString() {
  return 'ExamSummary(sessionId: $sessionId, startedAt: $startedAt, status: $status, score: $score, sections: $sections, blueprintId: $blueprintId, endedAt: $endedAt, previousSessionId: $previousSessionId, deltaVsPrevious: $deltaVsPrevious)';
}


}

/// @nodoc
abstract mixin class $ExamSummaryCopyWith<$Res>  {
  factory $ExamSummaryCopyWith(ExamSummary value, $Res Function(ExamSummary) _then) = _$ExamSummaryCopyWithImpl;
@useResult
$Res call({
 String sessionId, DateTime startedAt, SessionStatus status, double score, List<SectionScore> sections, String? blueprintId, DateTime? endedAt, String? previousSessionId, double? deltaVsPrevious
});




}
/// @nodoc
class _$ExamSummaryCopyWithImpl<$Res>
    implements $ExamSummaryCopyWith<$Res> {
  _$ExamSummaryCopyWithImpl(this._self, this._then);

  final ExamSummary _self;
  final $Res Function(ExamSummary) _then;

/// Create a copy of ExamSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? startedAt = null,Object? status = null,Object? score = null,Object? sections = null,Object? blueprintId = freezed,Object? endedAt = freezed,Object? previousSessionId = freezed,Object? deltaVsPrevious = freezed,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionScore>,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previousSessionId: freezed == previousSessionId ? _self.previousSessionId : previousSessionId // ignore: cast_nullable_to_non_nullable
as String?,deltaVsPrevious: freezed == deltaVsPrevious ? _self.deltaVsPrevious : deltaVsPrevious // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamSummary].
extension ExamSummaryPatterns on ExamSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSummary value)  $default,){
final _that = this;
switch (_that) {
case _ExamSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  DateTime startedAt,  SessionStatus status,  double score,  List<SectionScore> sections,  String? blueprintId,  DateTime? endedAt,  String? previousSessionId,  double? deltaVsPrevious)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSummary() when $default != null:
return $default(_that.sessionId,_that.startedAt,_that.status,_that.score,_that.sections,_that.blueprintId,_that.endedAt,_that.previousSessionId,_that.deltaVsPrevious);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  DateTime startedAt,  SessionStatus status,  double score,  List<SectionScore> sections,  String? blueprintId,  DateTime? endedAt,  String? previousSessionId,  double? deltaVsPrevious)  $default,) {final _that = this;
switch (_that) {
case _ExamSummary():
return $default(_that.sessionId,_that.startedAt,_that.status,_that.score,_that.sections,_that.blueprintId,_that.endedAt,_that.previousSessionId,_that.deltaVsPrevious);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  DateTime startedAt,  SessionStatus status,  double score,  List<SectionScore> sections,  String? blueprintId,  DateTime? endedAt,  String? previousSessionId,  double? deltaVsPrevious)?  $default,) {final _that = this;
switch (_that) {
case _ExamSummary() when $default != null:
return $default(_that.sessionId,_that.startedAt,_that.status,_that.score,_that.sections,_that.blueprintId,_that.endedAt,_that.previousSessionId,_that.deltaVsPrevious);case _:
  return null;

}
}

}

/// @nodoc


class _ExamSummary extends ExamSummary {
  const _ExamSummary({required this.sessionId, required this.startedAt, required this.status, required this.score, required final  List<SectionScore> sections, this.blueprintId, this.endedAt, this.previousSessionId, this.deltaVsPrevious}): _sections = sections,super._();
  

@override final  String sessionId;
@override final  DateTime startedAt;
@override final  SessionStatus status;
/// Weighted mean of section accuracies, 0..1.
@override final  double score;
 final  List<SectionScore> _sections;
@override List<SectionScore> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override final  String? blueprintId;
@override final  DateTime? endedAt;
@override final  String? previousSessionId;
/// `score - previous.score`, in the 0..1 scale.
@override final  double? deltaVsPrevious;

/// Create a copy of ExamSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSummaryCopyWith<_ExamSummary> get copyWith => __$ExamSummaryCopyWithImpl<_ExamSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSummary&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.score, score) || other.score == score)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.blueprintId, blueprintId) || other.blueprintId == blueprintId)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.previousSessionId, previousSessionId) || other.previousSessionId == previousSessionId)&&(identical(other.deltaVsPrevious, deltaVsPrevious) || other.deltaVsPrevious == deltaVsPrevious));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,startedAt,status,score,const DeepCollectionEquality().hash(_sections),blueprintId,endedAt,previousSessionId,deltaVsPrevious);

@override
String toString() {
  return 'ExamSummary(sessionId: $sessionId, startedAt: $startedAt, status: $status, score: $score, sections: $sections, blueprintId: $blueprintId, endedAt: $endedAt, previousSessionId: $previousSessionId, deltaVsPrevious: $deltaVsPrevious)';
}


}

/// @nodoc
abstract mixin class _$ExamSummaryCopyWith<$Res> implements $ExamSummaryCopyWith<$Res> {
  factory _$ExamSummaryCopyWith(_ExamSummary value, $Res Function(_ExamSummary) _then) = __$ExamSummaryCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, DateTime startedAt, SessionStatus status, double score, List<SectionScore> sections, String? blueprintId, DateTime? endedAt, String? previousSessionId, double? deltaVsPrevious
});




}
/// @nodoc
class __$ExamSummaryCopyWithImpl<$Res>
    implements _$ExamSummaryCopyWith<$Res> {
  __$ExamSummaryCopyWithImpl(this._self, this._then);

  final _ExamSummary _self;
  final $Res Function(_ExamSummary) _then;

/// Create a copy of ExamSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? startedAt = null,Object? status = null,Object? score = null,Object? sections = null,Object? blueprintId = freezed,Object? endedAt = freezed,Object? previousSessionId = freezed,Object? deltaVsPrevious = freezed,}) {
  return _then(_ExamSummary(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SessionStatus,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as double,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<SectionScore>,blueprintId: freezed == blueprintId ? _self.blueprintId : blueprintId // ignore: cast_nullable_to_non_nullable
as String?,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,previousSessionId: freezed == previousSessionId ? _self.previousSessionId : previousSessionId // ignore: cast_nullable_to_non_nullable
as String?,deltaVsPrevious: freezed == deltaVsPrevious ? _self.deltaVsPrevious : deltaVsPrevious // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
