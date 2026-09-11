// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItemStat {

 String get itemId; String get familyId; int get seen; int get correct; int get totalResponseMs; bool get lastCorrect; DateTime get lastSeenAt;
/// Create a copy of ItemStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemStatCopyWith<ItemStat> get copyWith => _$ItemStatCopyWithImpl<ItemStat>(this as ItemStat, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemStat&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.seen, seen) || other.seen == seen)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.totalResponseMs, totalResponseMs) || other.totalResponseMs == totalResponseMs)&&(identical(other.lastCorrect, lastCorrect) || other.lastCorrect == lastCorrect)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,familyId,seen,correct,totalResponseMs,lastCorrect,lastSeenAt);

@override
String toString() {
  return 'ItemStat(itemId: $itemId, familyId: $familyId, seen: $seen, correct: $correct, totalResponseMs: $totalResponseMs, lastCorrect: $lastCorrect, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class $ItemStatCopyWith<$Res>  {
  factory $ItemStatCopyWith(ItemStat value, $Res Function(ItemStat) _then) = _$ItemStatCopyWithImpl;
@useResult
$Res call({
 String itemId, String familyId, int seen, int correct, int totalResponseMs, bool lastCorrect, DateTime lastSeenAt
});




}
/// @nodoc
class _$ItemStatCopyWithImpl<$Res>
    implements $ItemStatCopyWith<$Res> {
  _$ItemStatCopyWithImpl(this._self, this._then);

  final ItemStat _self;
  final $Res Function(ItemStat) _then;

/// Create a copy of ItemStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? itemId = null,Object? familyId = null,Object? seen = null,Object? correct = null,Object? totalResponseMs = null,Object? lastCorrect = null,Object? lastSeenAt = null,}) {
  return _then(_self.copyWith(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,seen: null == seen ? _self.seen : seen // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,totalResponseMs: null == totalResponseMs ? _self.totalResponseMs : totalResponseMs // ignore: cast_nullable_to_non_nullable
as int,lastCorrect: null == lastCorrect ? _self.lastCorrect : lastCorrect // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemStat].
extension ItemStatPatterns on ItemStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemStat value)  $default,){
final _that = this;
switch (_that) {
case _ItemStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemStat value)?  $default,){
final _that = this;
switch (_that) {
case _ItemStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String itemId,  String familyId,  int seen,  int correct,  int totalResponseMs,  bool lastCorrect,  DateTime lastSeenAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemStat() when $default != null:
return $default(_that.itemId,_that.familyId,_that.seen,_that.correct,_that.totalResponseMs,_that.lastCorrect,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String itemId,  String familyId,  int seen,  int correct,  int totalResponseMs,  bool lastCorrect,  DateTime lastSeenAt)  $default,) {final _that = this;
switch (_that) {
case _ItemStat():
return $default(_that.itemId,_that.familyId,_that.seen,_that.correct,_that.totalResponseMs,_that.lastCorrect,_that.lastSeenAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String itemId,  String familyId,  int seen,  int correct,  int totalResponseMs,  bool lastCorrect,  DateTime lastSeenAt)?  $default,) {final _that = this;
switch (_that) {
case _ItemStat() when $default != null:
return $default(_that.itemId,_that.familyId,_that.seen,_that.correct,_that.totalResponseMs,_that.lastCorrect,_that.lastSeenAt);case _:
  return null;

}
}

}

/// @nodoc


class _ItemStat extends ItemStat {
  const _ItemStat({required this.itemId, required this.familyId, required this.seen, required this.correct, required this.totalResponseMs, required this.lastCorrect, required this.lastSeenAt}): super._();
  

@override final  String itemId;
@override final  String familyId;
@override final  int seen;
@override final  int correct;
@override final  int totalResponseMs;
@override final  bool lastCorrect;
@override final  DateTime lastSeenAt;

/// Create a copy of ItemStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemStatCopyWith<_ItemStat> get copyWith => __$ItemStatCopyWithImpl<_ItemStat>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemStat&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.seen, seen) || other.seen == seen)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.totalResponseMs, totalResponseMs) || other.totalResponseMs == totalResponseMs)&&(identical(other.lastCorrect, lastCorrect) || other.lastCorrect == lastCorrect)&&(identical(other.lastSeenAt, lastSeenAt) || other.lastSeenAt == lastSeenAt));
}


@override
int get hashCode => Object.hash(runtimeType,itemId,familyId,seen,correct,totalResponseMs,lastCorrect,lastSeenAt);

@override
String toString() {
  return 'ItemStat(itemId: $itemId, familyId: $familyId, seen: $seen, correct: $correct, totalResponseMs: $totalResponseMs, lastCorrect: $lastCorrect, lastSeenAt: $lastSeenAt)';
}


}

/// @nodoc
abstract mixin class _$ItemStatCopyWith<$Res> implements $ItemStatCopyWith<$Res> {
  factory _$ItemStatCopyWith(_ItemStat value, $Res Function(_ItemStat) _then) = __$ItemStatCopyWithImpl;
@override @useResult
$Res call({
 String itemId, String familyId, int seen, int correct, int totalResponseMs, bool lastCorrect, DateTime lastSeenAt
});




}
/// @nodoc
class __$ItemStatCopyWithImpl<$Res>
    implements _$ItemStatCopyWith<$Res> {
  __$ItemStatCopyWithImpl(this._self, this._then);

  final _ItemStat _self;
  final $Res Function(_ItemStat) _then;

/// Create a copy of ItemStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? itemId = null,Object? familyId = null,Object? seen = null,Object? correct = null,Object? totalResponseMs = null,Object? lastCorrect = null,Object? lastSeenAt = null,}) {
  return _then(_ItemStat(
itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,seen: null == seen ? _self.seen : seen // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,totalResponseMs: null == totalResponseMs ? _self.totalResponseMs : totalResponseMs // ignore: cast_nullable_to_non_nullable
as int,lastCorrect: null == lastCorrect ? _self.lastCorrect : lastCorrect // ignore: cast_nullable_to_non_nullable
as bool,lastSeenAt: null == lastSeenAt ? _self.lastSeenAt : lastSeenAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$FamilyStats {

 String get familyId; int get attempts; int get correct; double get meanResponseMs; double get medianResponseMs;
/// Create a copy of FamilyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FamilyStatsCopyWith<FamilyStats> get copyWith => _$FamilyStatsCopyWithImpl<FamilyStats>(this as FamilyStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FamilyStats&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,attempts,correct,meanResponseMs,medianResponseMs);

@override
String toString() {
  return 'FamilyStats(familyId: $familyId, attempts: $attempts, correct: $correct, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class $FamilyStatsCopyWith<$Res>  {
  factory $FamilyStatsCopyWith(FamilyStats value, $Res Function(FamilyStats) _then) = _$FamilyStatsCopyWithImpl;
@useResult
$Res call({
 String familyId, int attempts, int correct, double meanResponseMs, double medianResponseMs
});




}
/// @nodoc
class _$FamilyStatsCopyWithImpl<$Res>
    implements $FamilyStatsCopyWith<$Res> {
  _$FamilyStatsCopyWithImpl(this._self, this._then);

  final FamilyStats _self;
  final $Res Function(FamilyStats) _then;

/// Create a copy of FamilyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyId = null,Object? attempts = null,Object? correct = null,Object? meanResponseMs = null,Object? medianResponseMs = null,}) {
  return _then(_self.copyWith(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,meanResponseMs: null == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [FamilyStats].
extension FamilyStatsPatterns on FamilyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FamilyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FamilyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FamilyStats value)  $default,){
final _that = this;
switch (_that) {
case _FamilyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FamilyStats value)?  $default,){
final _that = this;
switch (_that) {
case _FamilyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyId,  int attempts,  int correct,  double meanResponseMs,  double medianResponseMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FamilyStats() when $default != null:
return $default(_that.familyId,_that.attempts,_that.correct,_that.meanResponseMs,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyId,  int attempts,  int correct,  double meanResponseMs,  double medianResponseMs)  $default,) {final _that = this;
switch (_that) {
case _FamilyStats():
return $default(_that.familyId,_that.attempts,_that.correct,_that.meanResponseMs,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyId,  int attempts,  int correct,  double meanResponseMs,  double medianResponseMs)?  $default,) {final _that = this;
switch (_that) {
case _FamilyStats() when $default != null:
return $default(_that.familyId,_that.attempts,_that.correct,_that.meanResponseMs,_that.medianResponseMs);case _:
  return null;

}
}

}

/// @nodoc


class _FamilyStats extends FamilyStats {
  const _FamilyStats({required this.familyId, required this.attempts, required this.correct, required this.meanResponseMs, required this.medianResponseMs}): super._();
  

@override final  String familyId;
@override final  int attempts;
@override final  int correct;
@override final  double meanResponseMs;
@override final  double medianResponseMs;

/// Create a copy of FamilyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FamilyStatsCopyWith<_FamilyStats> get copyWith => __$FamilyStatsCopyWithImpl<_FamilyStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FamilyStats&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,familyId,attempts,correct,meanResponseMs,medianResponseMs);

@override
String toString() {
  return 'FamilyStats(familyId: $familyId, attempts: $attempts, correct: $correct, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class _$FamilyStatsCopyWith<$Res> implements $FamilyStatsCopyWith<$Res> {
  factory _$FamilyStatsCopyWith(_FamilyStats value, $Res Function(_FamilyStats) _then) = __$FamilyStatsCopyWithImpl;
@override @useResult
$Res call({
 String familyId, int attempts, int correct, double meanResponseMs, double medianResponseMs
});




}
/// @nodoc
class __$FamilyStatsCopyWithImpl<$Res>
    implements _$FamilyStatsCopyWith<$Res> {
  __$FamilyStatsCopyWithImpl(this._self, this._then);

  final _FamilyStats _self;
  final $Res Function(_FamilyStats) _then;

/// Create a copy of FamilyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyId = null,Object? attempts = null,Object? correct = null,Object? meanResponseMs = null,Object? medianResponseMs = null,}) {
  return _then(_FamilyStats(
familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,meanResponseMs: null == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$SessionFamilyStats {

 String get sessionId; String get familyId; SessionMode get mode; DateTime get startedAt; int get attempts; int get correct; int get unanswered; double get meanResponseMs; double get medianResponseMs;
/// Create a copy of SessionFamilyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionFamilyStatsCopyWith<SessionFamilyStats> get copyWith => _$SessionFamilyStatsCopyWithImpl<SessionFamilyStats>(this as SessionFamilyStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionFamilyStats&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,mode,startedAt,attempts,correct,unanswered,meanResponseMs,medianResponseMs);

@override
String toString() {
  return 'SessionFamilyStats(sessionId: $sessionId, familyId: $familyId, mode: $mode, startedAt: $startedAt, attempts: $attempts, correct: $correct, unanswered: $unanswered, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class $SessionFamilyStatsCopyWith<$Res>  {
  factory $SessionFamilyStatsCopyWith(SessionFamilyStats value, $Res Function(SessionFamilyStats) _then) = _$SessionFamilyStatsCopyWithImpl;
@useResult
$Res call({
 String sessionId, String familyId, SessionMode mode, DateTime startedAt, int attempts, int correct, int unanswered, double meanResponseMs, double medianResponseMs
});




}
/// @nodoc
class _$SessionFamilyStatsCopyWithImpl<$Res>
    implements $SessionFamilyStatsCopyWith<$Res> {
  _$SessionFamilyStatsCopyWithImpl(this._self, this._then);

  final SessionFamilyStats _self;
  final $Res Function(SessionFamilyStats) _then;

/// Create a copy of SessionFamilyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionId = null,Object? familyId = null,Object? mode = null,Object? startedAt = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? meanResponseMs = null,Object? medianResponseMs = null,}) {
  return _then(_self.copyWith(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,meanResponseMs: null == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionFamilyStats].
extension SessionFamilyStatsPatterns on SessionFamilyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionFamilyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionFamilyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionFamilyStats value)  $default,){
final _that = this;
switch (_that) {
case _SessionFamilyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionFamilyStats value)?  $default,){
final _that = this;
switch (_that) {
case _SessionFamilyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String sessionId,  String familyId,  SessionMode mode,  DateTime startedAt,  int attempts,  int correct,  int unanswered,  double meanResponseMs,  double medianResponseMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionFamilyStats() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.mode,_that.startedAt,_that.attempts,_that.correct,_that.unanswered,_that.meanResponseMs,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String sessionId,  String familyId,  SessionMode mode,  DateTime startedAt,  int attempts,  int correct,  int unanswered,  double meanResponseMs,  double medianResponseMs)  $default,) {final _that = this;
switch (_that) {
case _SessionFamilyStats():
return $default(_that.sessionId,_that.familyId,_that.mode,_that.startedAt,_that.attempts,_that.correct,_that.unanswered,_that.meanResponseMs,_that.medianResponseMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String sessionId,  String familyId,  SessionMode mode,  DateTime startedAt,  int attempts,  int correct,  int unanswered,  double meanResponseMs,  double medianResponseMs)?  $default,) {final _that = this;
switch (_that) {
case _SessionFamilyStats() when $default != null:
return $default(_that.sessionId,_that.familyId,_that.mode,_that.startedAt,_that.attempts,_that.correct,_that.unanswered,_that.meanResponseMs,_that.medianResponseMs);case _:
  return null;

}
}

}

/// @nodoc


class _SessionFamilyStats extends SessionFamilyStats {
  const _SessionFamilyStats({required this.sessionId, required this.familyId, required this.mode, required this.startedAt, required this.attempts, required this.correct, required this.unanswered, required this.meanResponseMs, required this.medianResponseMs}): super._();
  

@override final  String sessionId;
@override final  String familyId;
@override final  SessionMode mode;
@override final  DateTime startedAt;
@override final  int attempts;
@override final  int correct;
@override final  int unanswered;
@override final  double meanResponseMs;
@override final  double medianResponseMs;

/// Create a copy of SessionFamilyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionFamilyStatsCopyWith<_SessionFamilyStats> get copyWith => __$SessionFamilyStatsCopyWithImpl<_SessionFamilyStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionFamilyStats&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.unanswered, unanswered) || other.unanswered == unanswered)&&(identical(other.meanResponseMs, meanResponseMs) || other.meanResponseMs == meanResponseMs)&&(identical(other.medianResponseMs, medianResponseMs) || other.medianResponseMs == medianResponseMs));
}


@override
int get hashCode => Object.hash(runtimeType,sessionId,familyId,mode,startedAt,attempts,correct,unanswered,meanResponseMs,medianResponseMs);

@override
String toString() {
  return 'SessionFamilyStats(sessionId: $sessionId, familyId: $familyId, mode: $mode, startedAt: $startedAt, attempts: $attempts, correct: $correct, unanswered: $unanswered, meanResponseMs: $meanResponseMs, medianResponseMs: $medianResponseMs)';
}


}

/// @nodoc
abstract mixin class _$SessionFamilyStatsCopyWith<$Res> implements $SessionFamilyStatsCopyWith<$Res> {
  factory _$SessionFamilyStatsCopyWith(_SessionFamilyStats value, $Res Function(_SessionFamilyStats) _then) = __$SessionFamilyStatsCopyWithImpl;
@override @useResult
$Res call({
 String sessionId, String familyId, SessionMode mode, DateTime startedAt, int attempts, int correct, int unanswered, double meanResponseMs, double medianResponseMs
});




}
/// @nodoc
class __$SessionFamilyStatsCopyWithImpl<$Res>
    implements _$SessionFamilyStatsCopyWith<$Res> {
  __$SessionFamilyStatsCopyWithImpl(this._self, this._then);

  final _SessionFamilyStats _self;
  final $Res Function(_SessionFamilyStats) _then;

/// Create a copy of SessionFamilyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionId = null,Object? familyId = null,Object? mode = null,Object? startedAt = null,Object? attempts = null,Object? correct = null,Object? unanswered = null,Object? meanResponseMs = null,Object? medianResponseMs = null,}) {
  return _then(_SessionFamilyStats(
sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SessionMode,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,unanswered: null == unanswered ? _self.unanswered : unanswered // ignore: cast_nullable_to_non_nullable
as int,meanResponseMs: null == meanResponseMs ? _self.meanResponseMs : meanResponseMs // ignore: cast_nullable_to_non_nullable
as double,medianResponseMs: null == medianResponseMs ? _self.medianResponseMs : medianResponseMs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
