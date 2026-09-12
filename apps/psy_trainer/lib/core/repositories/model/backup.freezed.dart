// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BackupRow {

 String get id; DateTime get updatedAt; Map<String, Object?> get fields;
/// Create a copy of BackupRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupRowCopyWith<BackupRow> get copyWith => _$BackupRowCopyWithImpl<BackupRow>(this as BackupRow, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupRow&&(identical(other.id, id) || other.id == id)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.fields, fields));
}


@override
int get hashCode => Object.hash(runtimeType,id,updatedAt,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'BackupRow(id: $id, updatedAt: $updatedAt, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $BackupRowCopyWith<$Res>  {
  factory $BackupRowCopyWith(BackupRow value, $Res Function(BackupRow) _then) = _$BackupRowCopyWithImpl;
@useResult
$Res call({
 String id, DateTime updatedAt, Map<String, Object?> fields
});




}
/// @nodoc
class _$BackupRowCopyWithImpl<$Res>
    implements $BackupRowCopyWith<$Res> {
  _$BackupRowCopyWithImpl(this._self, this._then);

  final BackupRow _self;
  final $Res Function(BackupRow) _then;

/// Create a copy of BackupRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? updatedAt = null,Object? fields = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupRow].
extension BackupRowPatterns on BackupRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupRow value)  $default,){
final _that = this;
switch (_that) {
case _BackupRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupRow value)?  $default,){
final _that = this;
switch (_that) {
case _BackupRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime updatedAt,  Map<String, Object?> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupRow() when $default != null:
return $default(_that.id,_that.updatedAt,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime updatedAt,  Map<String, Object?> fields)  $default,) {final _that = this;
switch (_that) {
case _BackupRow():
return $default(_that.id,_that.updatedAt,_that.fields);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime updatedAt,  Map<String, Object?> fields)?  $default,) {final _that = this;
switch (_that) {
case _BackupRow() when $default != null:
return $default(_that.id,_that.updatedAt,_that.fields);case _:
  return null;

}
}

}

/// @nodoc


class _BackupRow implements BackupRow {
  const _BackupRow({required this.id, required this.updatedAt, required final  Map<String, Object?> fields}): _fields = fields;
  

@override final  String id;
@override final  DateTime updatedAt;
 final  Map<String, Object?> _fields;
@override Map<String, Object?> get fields {
  if (_fields is EqualUnmodifiableMapView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_fields);
}


/// Create a copy of BackupRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupRowCopyWith<_BackupRow> get copyWith => __$BackupRowCopyWithImpl<_BackupRow>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupRow&&(identical(other.id, id) || other.id == id)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._fields, _fields));
}


@override
int get hashCode => Object.hash(runtimeType,id,updatedAt,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'BackupRow(id: $id, updatedAt: $updatedAt, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$BackupRowCopyWith<$Res> implements $BackupRowCopyWith<$Res> {
  factory _$BackupRowCopyWith(_BackupRow value, $Res Function(_BackupRow) _then) = __$BackupRowCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime updatedAt, Map<String, Object?> fields
});




}
/// @nodoc
class __$BackupRowCopyWithImpl<$Res>
    implements _$BackupRowCopyWith<$Res> {
  __$BackupRowCopyWithImpl(this._self, this._then);

  final _BackupRow _self;
  final $Res Function(_BackupRow) _then;

/// Create a copy of BackupRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? updatedAt = null,Object? fields = null,}) {
  return _then(_BackupRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$BackupSnapshot {

 List<BackupRow> get sessions; List<BackupRow> get attempts; List<BackupRow> get itemStats; List<BackupRow> get flashcardReviews; List<BackupRow> get lessonProgress;/// Null when onboarding has not created a profile yet.
 BackupRow? get profile;
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupSnapshotCopyWith<BackupSnapshot> get copyWith => _$BackupSnapshotCopyWithImpl<BackupSnapshot>(this as BackupSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupSnapshot&&const DeepCollectionEquality().equals(other.sessions, sessions)&&const DeepCollectionEquality().equals(other.attempts, attempts)&&const DeepCollectionEquality().equals(other.itemStats, itemStats)&&const DeepCollectionEquality().equals(other.flashcardReviews, flashcardReviews)&&const DeepCollectionEquality().equals(other.lessonProgress, lessonProgress)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sessions),const DeepCollectionEquality().hash(attempts),const DeepCollectionEquality().hash(itemStats),const DeepCollectionEquality().hash(flashcardReviews),const DeepCollectionEquality().hash(lessonProgress),profile);

@override
String toString() {
  return 'BackupSnapshot(sessions: $sessions, attempts: $attempts, itemStats: $itemStats, flashcardReviews: $flashcardReviews, lessonProgress: $lessonProgress, profile: $profile)';
}


}

/// @nodoc
abstract mixin class $BackupSnapshotCopyWith<$Res>  {
  factory $BackupSnapshotCopyWith(BackupSnapshot value, $Res Function(BackupSnapshot) _then) = _$BackupSnapshotCopyWithImpl;
@useResult
$Res call({
 List<BackupRow> sessions, List<BackupRow> attempts, List<BackupRow> itemStats, List<BackupRow> flashcardReviews, List<BackupRow> lessonProgress, BackupRow? profile
});


$BackupRowCopyWith<$Res>? get profile;

}
/// @nodoc
class _$BackupSnapshotCopyWithImpl<$Res>
    implements $BackupSnapshotCopyWith<$Res> {
  _$BackupSnapshotCopyWithImpl(this._self, this._then);

  final BackupSnapshot _self;
  final $Res Function(BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessions = null,Object? attempts = null,Object? itemStats = null,Object? flashcardReviews = null,Object? lessonProgress = null,Object? profile = freezed,}) {
  return _then(_self.copyWith(
sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,itemStats: null == itemStats ? _self.itemStats : itemStats // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,flashcardReviews: null == flashcardReviews ? _self.flashcardReviews : flashcardReviews // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,lessonProgress: null == lessonProgress ? _self.lessonProgress : lessonProgress // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as BackupRow?,
  ));
}
/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupRowCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $BackupRowCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}


/// Adds pattern-matching-related methods to [BackupSnapshot].
extension BackupSnapshotPatterns on BackupSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BackupRow> sessions,  List<BackupRow> attempts,  List<BackupRow> itemStats,  List<BackupRow> flashcardReviews,  List<BackupRow> lessonProgress,  BackupRow? profile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.sessions,_that.attempts,_that.itemStats,_that.flashcardReviews,_that.lessonProgress,_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BackupRow> sessions,  List<BackupRow> attempts,  List<BackupRow> itemStats,  List<BackupRow> flashcardReviews,  List<BackupRow> lessonProgress,  BackupRow? profile)  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot():
return $default(_that.sessions,_that.attempts,_that.itemStats,_that.flashcardReviews,_that.lessonProgress,_that.profile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BackupRow> sessions,  List<BackupRow> attempts,  List<BackupRow> itemStats,  List<BackupRow> flashcardReviews,  List<BackupRow> lessonProgress,  BackupRow? profile)?  $default,) {final _that = this;
switch (_that) {
case _BackupSnapshot() when $default != null:
return $default(_that.sessions,_that.attempts,_that.itemStats,_that.flashcardReviews,_that.lessonProgress,_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class _BackupSnapshot implements BackupSnapshot {
  const _BackupSnapshot({required final  List<BackupRow> sessions, required final  List<BackupRow> attempts, required final  List<BackupRow> itemStats, required final  List<BackupRow> flashcardReviews, required final  List<BackupRow> lessonProgress, this.profile}): _sessions = sessions,_attempts = attempts,_itemStats = itemStats,_flashcardReviews = flashcardReviews,_lessonProgress = lessonProgress;
  

 final  List<BackupRow> _sessions;
@override List<BackupRow> get sessions {
  if (_sessions is EqualUnmodifiableListView) return _sessions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sessions);
}

 final  List<BackupRow> _attempts;
@override List<BackupRow> get attempts {
  if (_attempts is EqualUnmodifiableListView) return _attempts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_attempts);
}

 final  List<BackupRow> _itemStats;
@override List<BackupRow> get itemStats {
  if (_itemStats is EqualUnmodifiableListView) return _itemStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_itemStats);
}

 final  List<BackupRow> _flashcardReviews;
@override List<BackupRow> get flashcardReviews {
  if (_flashcardReviews is EqualUnmodifiableListView) return _flashcardReviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flashcardReviews);
}

 final  List<BackupRow> _lessonProgress;
@override List<BackupRow> get lessonProgress {
  if (_lessonProgress is EqualUnmodifiableListView) return _lessonProgress;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lessonProgress);
}

/// Null when onboarding has not created a profile yet.
@override final  BackupRow? profile;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupSnapshotCopyWith<_BackupSnapshot> get copyWith => __$BackupSnapshotCopyWithImpl<_BackupSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupSnapshot&&const DeepCollectionEquality().equals(other._sessions, _sessions)&&const DeepCollectionEquality().equals(other._attempts, _attempts)&&const DeepCollectionEquality().equals(other._itemStats, _itemStats)&&const DeepCollectionEquality().equals(other._flashcardReviews, _flashcardReviews)&&const DeepCollectionEquality().equals(other._lessonProgress, _lessonProgress)&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sessions),const DeepCollectionEquality().hash(_attempts),const DeepCollectionEquality().hash(_itemStats),const DeepCollectionEquality().hash(_flashcardReviews),const DeepCollectionEquality().hash(_lessonProgress),profile);

@override
String toString() {
  return 'BackupSnapshot(sessions: $sessions, attempts: $attempts, itemStats: $itemStats, flashcardReviews: $flashcardReviews, lessonProgress: $lessonProgress, profile: $profile)';
}


}

/// @nodoc
abstract mixin class _$BackupSnapshotCopyWith<$Res> implements $BackupSnapshotCopyWith<$Res> {
  factory _$BackupSnapshotCopyWith(_BackupSnapshot value, $Res Function(_BackupSnapshot) _then) = __$BackupSnapshotCopyWithImpl;
@override @useResult
$Res call({
 List<BackupRow> sessions, List<BackupRow> attempts, List<BackupRow> itemStats, List<BackupRow> flashcardReviews, List<BackupRow> lessonProgress, BackupRow? profile
});


@override $BackupRowCopyWith<$Res>? get profile;

}
/// @nodoc
class __$BackupSnapshotCopyWithImpl<$Res>
    implements _$BackupSnapshotCopyWith<$Res> {
  __$BackupSnapshotCopyWithImpl(this._self, this._then);

  final _BackupSnapshot _self;
  final $Res Function(_BackupSnapshot) _then;

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessions = null,Object? attempts = null,Object? itemStats = null,Object? flashcardReviews = null,Object? lessonProgress = null,Object? profile = freezed,}) {
  return _then(_BackupSnapshot(
sessions: null == sessions ? _self._sessions : sessions // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,attempts: null == attempts ? _self._attempts : attempts // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,itemStats: null == itemStats ? _self._itemStats : itemStats // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,flashcardReviews: null == flashcardReviews ? _self._flashcardReviews : flashcardReviews // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,lessonProgress: null == lessonProgress ? _self._lessonProgress : lessonProgress // ignore: cast_nullable_to_non_nullable
as List<BackupRow>,profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as BackupRow?,
  ));
}

/// Create a copy of BackupSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BackupRowCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $BackupRowCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

/// @nodoc
mixin _$BackupImportSummary {

 int get inserted; int get updated; int get skipped;
/// Create a copy of BackupImportSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BackupImportSummaryCopyWith<BackupImportSummary> get copyWith => _$BackupImportSummaryCopyWithImpl<BackupImportSummary>(this as BackupImportSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BackupImportSummary&&(identical(other.inserted, inserted) || other.inserted == inserted)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}


@override
int get hashCode => Object.hash(runtimeType,inserted,updated,skipped);

@override
String toString() {
  return 'BackupImportSummary(inserted: $inserted, updated: $updated, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class $BackupImportSummaryCopyWith<$Res>  {
  factory $BackupImportSummaryCopyWith(BackupImportSummary value, $Res Function(BackupImportSummary) _then) = _$BackupImportSummaryCopyWithImpl;
@useResult
$Res call({
 int inserted, int updated, int skipped
});




}
/// @nodoc
class _$BackupImportSummaryCopyWithImpl<$Res>
    implements $BackupImportSummaryCopyWith<$Res> {
  _$BackupImportSummaryCopyWithImpl(this._self, this._then);

  final BackupImportSummary _self;
  final $Res Function(BackupImportSummary) _then;

/// Create a copy of BackupImportSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inserted = null,Object? updated = null,Object? skipped = null,}) {
  return _then(_self.copyWith(
inserted: null == inserted ? _self.inserted : inserted // ignore: cast_nullable_to_non_nullable
as int,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BackupImportSummary].
extension BackupImportSummaryPatterns on BackupImportSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BackupImportSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BackupImportSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BackupImportSummary value)  $default,){
final _that = this;
switch (_that) {
case _BackupImportSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BackupImportSummary value)?  $default,){
final _that = this;
switch (_that) {
case _BackupImportSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int inserted,  int updated,  int skipped)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BackupImportSummary() when $default != null:
return $default(_that.inserted,_that.updated,_that.skipped);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int inserted,  int updated,  int skipped)  $default,) {final _that = this;
switch (_that) {
case _BackupImportSummary():
return $default(_that.inserted,_that.updated,_that.skipped);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int inserted,  int updated,  int skipped)?  $default,) {final _that = this;
switch (_that) {
case _BackupImportSummary() when $default != null:
return $default(_that.inserted,_that.updated,_that.skipped);case _:
  return null;

}
}

}

/// @nodoc


class _BackupImportSummary extends BackupImportSummary {
  const _BackupImportSummary({required this.inserted, required this.updated, required this.skipped}): super._();
  

@override final  int inserted;
@override final  int updated;
@override final  int skipped;

/// Create a copy of BackupImportSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BackupImportSummaryCopyWith<_BackupImportSummary> get copyWith => __$BackupImportSummaryCopyWithImpl<_BackupImportSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BackupImportSummary&&(identical(other.inserted, inserted) || other.inserted == inserted)&&(identical(other.updated, updated) || other.updated == updated)&&(identical(other.skipped, skipped) || other.skipped == skipped));
}


@override
int get hashCode => Object.hash(runtimeType,inserted,updated,skipped);

@override
String toString() {
  return 'BackupImportSummary(inserted: $inserted, updated: $updated, skipped: $skipped)';
}


}

/// @nodoc
abstract mixin class _$BackupImportSummaryCopyWith<$Res> implements $BackupImportSummaryCopyWith<$Res> {
  factory _$BackupImportSummaryCopyWith(_BackupImportSummary value, $Res Function(_BackupImportSummary) _then) = __$BackupImportSummaryCopyWithImpl;
@override @useResult
$Res call({
 int inserted, int updated, int skipped
});




}
/// @nodoc
class __$BackupImportSummaryCopyWithImpl<$Res>
    implements _$BackupImportSummaryCopyWith<$Res> {
  __$BackupImportSummaryCopyWithImpl(this._self, this._then);

  final _BackupImportSummary _self;
  final $Res Function(_BackupImportSummary) _then;

/// Create a copy of BackupImportSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inserted = null,Object? updated = null,Object? skipped = null,}) {
  return _then(_BackupImportSummary(
inserted: null == inserted ? _self.inserted : inserted // ignore: cast_nullable_to_non_nullable
as int,updated: null == updated ? _self.updated : updated // ignore: cast_nullable_to_non_nullable
as int,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
