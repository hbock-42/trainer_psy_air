// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItemResult {

 bool get correct; bool get timedOut; bool get skipped; Map<String, num> get metrics;
/// Create a copy of ItemResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemResultCopyWith<ItemResult> get copyWith => _$ItemResultCopyWithImpl<ItemResult>(this as ItemResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemResult&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&const DeepCollectionEquality().equals(other.metrics, metrics));
}


@override
int get hashCode => Object.hash(runtimeType,correct,timedOut,skipped,const DeepCollectionEquality().hash(metrics));

@override
String toString() {
  return 'ItemResult(correct: $correct, timedOut: $timedOut, skipped: $skipped, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $ItemResultCopyWith<$Res>  {
  factory $ItemResultCopyWith(ItemResult value, $Res Function(ItemResult) _then) = _$ItemResultCopyWithImpl;
@useResult
$Res call({
 bool correct, bool timedOut, bool skipped, Map<String, num> metrics
});




}
/// @nodoc
class _$ItemResultCopyWithImpl<$Res>
    implements $ItemResultCopyWith<$Res> {
  _$ItemResultCopyWithImpl(this._self, this._then);

  final ItemResult _self;
  final $Res Function(ItemResult) _then;

/// Create a copy of ItemResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? timedOut = null,Object? skipped = null,Object? metrics = null,}) {
  return _then(_self.copyWith(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as bool,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemResult].
extension ItemResultPatterns on ItemResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemResult value)  $default,){
final _that = this;
switch (_that) {
case _ItemResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemResult value)?  $default,){
final _that = this;
switch (_that) {
case _ItemResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool correct,  bool timedOut,  bool skipped,  Map<String, num> metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemResult() when $default != null:
return $default(_that.correct,_that.timedOut,_that.skipped,_that.metrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool correct,  bool timedOut,  bool skipped,  Map<String, num> metrics)  $default,) {final _that = this;
switch (_that) {
case _ItemResult():
return $default(_that.correct,_that.timedOut,_that.skipped,_that.metrics);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool correct,  bool timedOut,  bool skipped,  Map<String, num> metrics)?  $default,) {final _that = this;
switch (_that) {
case _ItemResult() when $default != null:
return $default(_that.correct,_that.timedOut,_that.skipped,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc


class _ItemResult extends ItemResult {
  const _ItemResult({required this.correct, this.timedOut = false, this.skipped = false, final  Map<String, num> metrics = const <String, num>{}}): _metrics = metrics,super._();
  

@override final  bool correct;
@override@JsonKey() final  bool timedOut;
@override@JsonKey() final  bool skipped;
 final  Map<String, num> _metrics;
@override@JsonKey() Map<String, num> get metrics {
  if (_metrics is EqualUnmodifiableMapView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_metrics);
}


/// Create a copy of ItemResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemResultCopyWith<_ItemResult> get copyWith => __$ItemResultCopyWithImpl<_ItemResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemResult&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.timedOut, timedOut) || other.timedOut == timedOut)&&(identical(other.skipped, skipped) || other.skipped == skipped)&&const DeepCollectionEquality().equals(other._metrics, _metrics));
}


@override
int get hashCode => Object.hash(runtimeType,correct,timedOut,skipped,const DeepCollectionEquality().hash(_metrics));

@override
String toString() {
  return 'ItemResult(correct: $correct, timedOut: $timedOut, skipped: $skipped, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$ItemResultCopyWith<$Res> implements $ItemResultCopyWith<$Res> {
  factory _$ItemResultCopyWith(_ItemResult value, $Res Function(_ItemResult) _then) = __$ItemResultCopyWithImpl;
@override @useResult
$Res call({
 bool correct, bool timedOut, bool skipped, Map<String, num> metrics
});




}
/// @nodoc
class __$ItemResultCopyWithImpl<$Res>
    implements _$ItemResultCopyWith<$Res> {
  __$ItemResultCopyWithImpl(this._self, this._then);

  final _ItemResult _self;
  final $Res Function(_ItemResult) _then;

/// Create a copy of ItemResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? timedOut = null,Object? skipped = null,Object? metrics = null,}) {
  return _then(_ItemResult(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as bool,timedOut: null == timedOut ? _self.timedOut : timedOut // ignore: cast_nullable_to_non_nullable
as bool,skipped: null == skipped ? _self.skipped : skipped // ignore: cast_nullable_to_non_nullable
as bool,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as Map<String, num>,
  ));
}


}

/// @nodoc
mixin _$ItemOutcome {

 int get index; Item get item; Answer get answer; ItemResult get result; int get responseMs;
/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemOutcomeCopyWith<ItemOutcome> get copyWith => _$ItemOutcomeCopyWithImpl<ItemOutcome>(this as ItemOutcome, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemOutcome&&(identical(other.index, index) || other.index == index)&&(identical(other.item, item) || other.item == item)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.result, result) || other.result == result)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs));
}


@override
int get hashCode => Object.hash(runtimeType,index,item,answer,result,responseMs);

@override
String toString() {
  return 'ItemOutcome(index: $index, item: $item, answer: $answer, result: $result, responseMs: $responseMs)';
}


}

/// @nodoc
abstract mixin class $ItemOutcomeCopyWith<$Res>  {
  factory $ItemOutcomeCopyWith(ItemOutcome value, $Res Function(ItemOutcome) _then) = _$ItemOutcomeCopyWithImpl;
@useResult
$Res call({
 int index, Item item, Answer answer, ItemResult result, int responseMs
});


$ItemCopyWith<$Res> get item;$AnswerCopyWith<$Res> get answer;$ItemResultCopyWith<$Res> get result;

}
/// @nodoc
class _$ItemOutcomeCopyWithImpl<$Res>
    implements $ItemOutcomeCopyWith<$Res> {
  _$ItemOutcomeCopyWithImpl(this._self, this._then);

  final ItemOutcome _self;
  final $Res Function(ItemOutcome) _then;

/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = null,Object? item = null,Object? answer = null,Object? result = null,Object? responseMs = null,}) {
  return _then(_self.copyWith(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Answer,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ItemResult,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerCopyWith<$Res> get answer {
  
  return $AnswerCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemResultCopyWith<$Res> get result {
  
  return $ItemResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemOutcome].
extension ItemOutcomePatterns on ItemOutcome {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemOutcome value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemOutcome() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemOutcome value)  $default,){
final _that = this;
switch (_that) {
case _ItemOutcome():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemOutcome value)?  $default,){
final _that = this;
switch (_that) {
case _ItemOutcome() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int index,  Item item,  Answer answer,  ItemResult result,  int responseMs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemOutcome() when $default != null:
return $default(_that.index,_that.item,_that.answer,_that.result,_that.responseMs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int index,  Item item,  Answer answer,  ItemResult result,  int responseMs)  $default,) {final _that = this;
switch (_that) {
case _ItemOutcome():
return $default(_that.index,_that.item,_that.answer,_that.result,_that.responseMs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int index,  Item item,  Answer answer,  ItemResult result,  int responseMs)?  $default,) {final _that = this;
switch (_that) {
case _ItemOutcome() when $default != null:
return $default(_that.index,_that.item,_that.answer,_that.result,_that.responseMs);case _:
  return null;

}
}

}

/// @nodoc


class _ItemOutcome extends ItemOutcome {
  const _ItemOutcome({required this.index, required this.item, required this.answer, required this.result, required this.responseMs}): super._();
  

@override final  int index;
@override final  Item item;
@override final  Answer answer;
@override final  ItemResult result;
@override final  int responseMs;

/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemOutcomeCopyWith<_ItemOutcome> get copyWith => __$ItemOutcomeCopyWithImpl<_ItemOutcome>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemOutcome&&(identical(other.index, index) || other.index == index)&&(identical(other.item, item) || other.item == item)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.result, result) || other.result == result)&&(identical(other.responseMs, responseMs) || other.responseMs == responseMs));
}


@override
int get hashCode => Object.hash(runtimeType,index,item,answer,result,responseMs);

@override
String toString() {
  return 'ItemOutcome(index: $index, item: $item, answer: $answer, result: $result, responseMs: $responseMs)';
}


}

/// @nodoc
abstract mixin class _$ItemOutcomeCopyWith<$Res> implements $ItemOutcomeCopyWith<$Res> {
  factory _$ItemOutcomeCopyWith(_ItemOutcome value, $Res Function(_ItemOutcome) _then) = __$ItemOutcomeCopyWithImpl;
@override @useResult
$Res call({
 int index, Item item, Answer answer, ItemResult result, int responseMs
});


@override $ItemCopyWith<$Res> get item;@override $AnswerCopyWith<$Res> get answer;@override $ItemResultCopyWith<$Res> get result;

}
/// @nodoc
class __$ItemOutcomeCopyWithImpl<$Res>
    implements _$ItemOutcomeCopyWith<$Res> {
  __$ItemOutcomeCopyWithImpl(this._self, this._then);

  final _ItemOutcome _self;
  final $Res Function(_ItemOutcome) _then;

/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = null,Object? item = null,Object? answer = null,Object? result = null,Object? responseMs = null,}) {
  return _then(_ItemOutcome(
index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as Answer,result: null == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ItemResult,responseMs: null == responseMs ? _self.responseMs : responseMs // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerCopyWith<$Res> get answer {
  
  return $AnswerCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}/// Create a copy of ItemOutcome
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemResultCopyWith<$Res> get result {
  
  return $ItemResultCopyWith<$Res>(_self.result, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
