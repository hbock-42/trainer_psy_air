// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_family.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestFamily {

 String get id; ModuleId get moduleId; int get version; int get order; LocalizedText get name; LocalizedText get description; EngineType get engineType; AnswerFormat get answerFormat; int get defaultDurationSec; int get defaultItemCount; Confidence get confidence; LocalizedText? get shortName;/// v2: generator the practice launcher uses (null for bank-driven
/// families).
 GeneratorId? get generatorId; InputRequirement get inputRequirement;/// v2: the real activity shows right/wrong feedback live; engines keep it
/// in exam mode.
 bool get liveFeedback; ContentLang get lang; int? get defaultPerItemTimeSec;/// v2: fixed-rhythm families (memory_nback, attention_rules).
 Cadence? get defaultCadence; List<String> get tags; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestFamilyCopyWith<TestFamily> get copyWith => _$TestFamilyCopyWithImpl<TestFamily>(this as TestFamily, _$identity);

  /// Serializes this TestFamily to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestFamily&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.version, version) || other.version == version)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.engineType, engineType) || other.engineType == engineType)&&(identical(other.answerFormat, answerFormat) || other.answerFormat == answerFormat)&&(identical(other.defaultDurationSec, defaultDurationSec) || other.defaultDurationSec == defaultDurationSec)&&(identical(other.defaultItemCount, defaultItemCount) || other.defaultItemCount == defaultItemCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.inputRequirement, inputRequirement) || other.inputRequirement == inputRequirement)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.defaultPerItemTimeSec, defaultPerItemTimeSec) || other.defaultPerItemTimeSec == defaultPerItemTimeSec)&&(identical(other.defaultCadence, defaultCadence) || other.defaultCadence == defaultCadence)&&const DeepCollectionEquality().equals(other.tags, tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,moduleId,version,order,name,description,engineType,answerFormat,defaultDurationSec,defaultItemCount,confidence,shortName,generatorId,inputRequirement,liveFeedback,lang,defaultPerItemTimeSec,defaultCadence,const DeepCollectionEquality().hash(tags),status,meta]);

@override
String toString() {
  return 'TestFamily(id: $id, moduleId: $moduleId, version: $version, order: $order, name: $name, description: $description, engineType: $engineType, answerFormat: $answerFormat, defaultDurationSec: $defaultDurationSec, defaultItemCount: $defaultItemCount, confidence: $confidence, shortName: $shortName, generatorId: $generatorId, inputRequirement: $inputRequirement, liveFeedback: $liveFeedback, lang: $lang, defaultPerItemTimeSec: $defaultPerItemTimeSec, defaultCadence: $defaultCadence, tags: $tags, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $TestFamilyCopyWith<$Res>  {
  factory $TestFamilyCopyWith(TestFamily value, $Res Function(TestFamily) _then) = _$TestFamilyCopyWithImpl;
@useResult
$Res call({
 String id, ModuleId moduleId, int version, int order, LocalizedText name, LocalizedText description, EngineType engineType, AnswerFormat answerFormat, int defaultDurationSec, int defaultItemCount, Confidence confidence, LocalizedText? shortName, GeneratorId? generatorId, InputRequirement inputRequirement, bool liveFeedback, ContentLang lang, int? defaultPerItemTimeSec, Cadence? defaultCadence, List<String> tags, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get name;$LocalizedTextCopyWith<$Res> get description;$LocalizedTextCopyWith<$Res>? get shortName;$CadenceCopyWith<$Res>? get defaultCadence;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$TestFamilyCopyWithImpl<$Res>
    implements $TestFamilyCopyWith<$Res> {
  _$TestFamilyCopyWithImpl(this._self, this._then);

  final TestFamily _self;
  final $Res Function(TestFamily) _then;

/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? moduleId = null,Object? version = null,Object? order = null,Object? name = null,Object? description = null,Object? engineType = null,Object? answerFormat = null,Object? defaultDurationSec = null,Object? defaultItemCount = null,Object? confidence = null,Object? shortName = freezed,Object? generatorId = freezed,Object? inputRequirement = null,Object? liveFeedback = null,Object? lang = null,Object? defaultPerItemTimeSec = freezed,Object? defaultCadence = freezed,Object? tags = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,engineType: null == engineType ? _self.engineType : engineType // ignore: cast_nullable_to_non_nullable
as EngineType,answerFormat: null == answerFormat ? _self.answerFormat : answerFormat // ignore: cast_nullable_to_non_nullable
as AnswerFormat,defaultDurationSec: null == defaultDurationSec ? _self.defaultDurationSec : defaultDurationSec // ignore: cast_nullable_to_non_nullable
as int,defaultItemCount: null == defaultItemCount ? _self.defaultItemCount : defaultItemCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as LocalizedText?,generatorId: freezed == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId?,inputRequirement: null == inputRequirement ? _self.inputRequirement : inputRequirement // ignore: cast_nullable_to_non_nullable
as InputRequirement,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang,defaultPerItemTimeSec: freezed == defaultPerItemTimeSec ? _self.defaultPerItemTimeSec : defaultPerItemTimeSec // ignore: cast_nullable_to_non_nullable
as int?,defaultCadence: freezed == defaultCadence ? _self.defaultCadence : defaultCadence // ignore: cast_nullable_to_non_nullable
as Cadence?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get shortName {
    if (_self.shortName == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.shortName!, (value) {
    return _then(_self.copyWith(shortName: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CadenceCopyWith<$Res>? get defaultCadence {
    if (_self.defaultCadence == null) {
    return null;
  }

  return $CadenceCopyWith<$Res>(_self.defaultCadence!, (value) {
    return _then(_self.copyWith(defaultCadence: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}


/// Adds pattern-matching-related methods to [TestFamily].
extension TestFamilyPatterns on TestFamily {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestFamily value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestFamily() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestFamily value)  $default,){
final _that = this;
switch (_that) {
case _TestFamily():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestFamily value)?  $default,){
final _that = this;
switch (_that) {
case _TestFamily() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ModuleId moduleId,  int version,  int order,  LocalizedText name,  LocalizedText description,  EngineType engineType,  AnswerFormat answerFormat,  int defaultDurationSec,  int defaultItemCount,  Confidence confidence,  LocalizedText? shortName,  GeneratorId? generatorId,  InputRequirement inputRequirement,  bool liveFeedback,  ContentLang lang,  int? defaultPerItemTimeSec,  Cadence? defaultCadence,  List<String> tags,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestFamily() when $default != null:
return $default(_that.id,_that.moduleId,_that.version,_that.order,_that.name,_that.description,_that.engineType,_that.answerFormat,_that.defaultDurationSec,_that.defaultItemCount,_that.confidence,_that.shortName,_that.generatorId,_that.inputRequirement,_that.liveFeedback,_that.lang,_that.defaultPerItemTimeSec,_that.defaultCadence,_that.tags,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ModuleId moduleId,  int version,  int order,  LocalizedText name,  LocalizedText description,  EngineType engineType,  AnswerFormat answerFormat,  int defaultDurationSec,  int defaultItemCount,  Confidence confidence,  LocalizedText? shortName,  GeneratorId? generatorId,  InputRequirement inputRequirement,  bool liveFeedback,  ContentLang lang,  int? defaultPerItemTimeSec,  Cadence? defaultCadence,  List<String> tags,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _TestFamily():
return $default(_that.id,_that.moduleId,_that.version,_that.order,_that.name,_that.description,_that.engineType,_that.answerFormat,_that.defaultDurationSec,_that.defaultItemCount,_that.confidence,_that.shortName,_that.generatorId,_that.inputRequirement,_that.liveFeedback,_that.lang,_that.defaultPerItemTimeSec,_that.defaultCadence,_that.tags,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ModuleId moduleId,  int version,  int order,  LocalizedText name,  LocalizedText description,  EngineType engineType,  AnswerFormat answerFormat,  int defaultDurationSec,  int defaultItemCount,  Confidence confidence,  LocalizedText? shortName,  GeneratorId? generatorId,  InputRequirement inputRequirement,  bool liveFeedback,  ContentLang lang,  int? defaultPerItemTimeSec,  Cadence? defaultCadence,  List<String> tags,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _TestFamily() when $default != null:
return $default(_that.id,_that.moduleId,_that.version,_that.order,_that.name,_that.description,_that.engineType,_that.answerFormat,_that.defaultDurationSec,_that.defaultItemCount,_that.confidence,_that.shortName,_that.generatorId,_that.inputRequirement,_that.liveFeedback,_that.lang,_that.defaultPerItemTimeSec,_that.defaultCadence,_that.tags,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestFamily implements TestFamily {
  const _TestFamily({required this.id, required this.moduleId, required this.version, required this.order, required this.name, required this.description, required this.engineType, required this.answerFormat, required this.defaultDurationSec, required this.defaultItemCount, required this.confidence, this.shortName, this.generatorId, this.inputRequirement = InputRequirement.touch, this.liveFeedback = false, this.lang = ContentLang.fr, this.defaultPerItemTimeSec, this.defaultCadence, final  List<String> tags = const <String>[], this.status = ContentStatus.published, this.meta}): _tags = tags;
  factory _TestFamily.fromJson(Map<String, dynamic> json) => _$TestFamilyFromJson(json);

@override final  String id;
@override final  ModuleId moduleId;
@override final  int version;
@override final  int order;
@override final  LocalizedText name;
@override final  LocalizedText description;
@override final  EngineType engineType;
@override final  AnswerFormat answerFormat;
@override final  int defaultDurationSec;
@override final  int defaultItemCount;
@override final  Confidence confidence;
@override final  LocalizedText? shortName;
/// v2: generator the practice launcher uses (null for bank-driven
/// families).
@override final  GeneratorId? generatorId;
@override@JsonKey() final  InputRequirement inputRequirement;
/// v2: the real activity shows right/wrong feedback live; engines keep it
/// in exam mode.
@override@JsonKey() final  bool liveFeedback;
@override@JsonKey() final  ContentLang lang;
@override final  int? defaultPerItemTimeSec;
/// v2: fixed-rhythm families (memory_nback, attention_rules).
@override final  Cadence? defaultCadence;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestFamilyCopyWith<_TestFamily> get copyWith => __$TestFamilyCopyWithImpl<_TestFamily>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestFamilyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestFamily&&(identical(other.id, id) || other.id == id)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.version, version) || other.version == version)&&(identical(other.order, order) || other.order == order)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.engineType, engineType) || other.engineType == engineType)&&(identical(other.answerFormat, answerFormat) || other.answerFormat == answerFormat)&&(identical(other.defaultDurationSec, defaultDurationSec) || other.defaultDurationSec == defaultDurationSec)&&(identical(other.defaultItemCount, defaultItemCount) || other.defaultItemCount == defaultItemCount)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.shortName, shortName) || other.shortName == shortName)&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.inputRequirement, inputRequirement) || other.inputRequirement == inputRequirement)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.lang, lang) || other.lang == lang)&&(identical(other.defaultPerItemTimeSec, defaultPerItemTimeSec) || other.defaultPerItemTimeSec == defaultPerItemTimeSec)&&(identical(other.defaultCadence, defaultCadence) || other.defaultCadence == defaultCadence)&&const DeepCollectionEquality().equals(other._tags, _tags)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,moduleId,version,order,name,description,engineType,answerFormat,defaultDurationSec,defaultItemCount,confidence,shortName,generatorId,inputRequirement,liveFeedback,lang,defaultPerItemTimeSec,defaultCadence,const DeepCollectionEquality().hash(_tags),status,meta]);

@override
String toString() {
  return 'TestFamily(id: $id, moduleId: $moduleId, version: $version, order: $order, name: $name, description: $description, engineType: $engineType, answerFormat: $answerFormat, defaultDurationSec: $defaultDurationSec, defaultItemCount: $defaultItemCount, confidence: $confidence, shortName: $shortName, generatorId: $generatorId, inputRequirement: $inputRequirement, liveFeedback: $liveFeedback, lang: $lang, defaultPerItemTimeSec: $defaultPerItemTimeSec, defaultCadence: $defaultCadence, tags: $tags, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$TestFamilyCopyWith<$Res> implements $TestFamilyCopyWith<$Res> {
  factory _$TestFamilyCopyWith(_TestFamily value, $Res Function(_TestFamily) _then) = __$TestFamilyCopyWithImpl;
@override @useResult
$Res call({
 String id, ModuleId moduleId, int version, int order, LocalizedText name, LocalizedText description, EngineType engineType, AnswerFormat answerFormat, int defaultDurationSec, int defaultItemCount, Confidence confidence, LocalizedText? shortName, GeneratorId? generatorId, InputRequirement inputRequirement, bool liveFeedback, ContentLang lang, int? defaultPerItemTimeSec, Cadence? defaultCadence, List<String> tags, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get name;@override $LocalizedTextCopyWith<$Res> get description;@override $LocalizedTextCopyWith<$Res>? get shortName;@override $CadenceCopyWith<$Res>? get defaultCadence;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$TestFamilyCopyWithImpl<$Res>
    implements _$TestFamilyCopyWith<$Res> {
  __$TestFamilyCopyWithImpl(this._self, this._then);

  final _TestFamily _self;
  final $Res Function(_TestFamily) _then;

/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? moduleId = null,Object? version = null,Object? order = null,Object? name = null,Object? description = null,Object? engineType = null,Object? answerFormat = null,Object? defaultDurationSec = null,Object? defaultItemCount = null,Object? confidence = null,Object? shortName = freezed,Object? generatorId = freezed,Object? inputRequirement = null,Object? liveFeedback = null,Object? lang = null,Object? defaultPerItemTimeSec = freezed,Object? defaultCadence = freezed,Object? tags = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_TestFamily(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,engineType: null == engineType ? _self.engineType : engineType // ignore: cast_nullable_to_non_nullable
as EngineType,answerFormat: null == answerFormat ? _self.answerFormat : answerFormat // ignore: cast_nullable_to_non_nullable
as AnswerFormat,defaultDurationSec: null == defaultDurationSec ? _self.defaultDurationSec : defaultDurationSec // ignore: cast_nullable_to_non_nullable
as int,defaultItemCount: null == defaultItemCount ? _self.defaultItemCount : defaultItemCount // ignore: cast_nullable_to_non_nullable
as int,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,shortName: freezed == shortName ? _self.shortName : shortName // ignore: cast_nullable_to_non_nullable
as LocalizedText?,generatorId: freezed == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId?,inputRequirement: null == inputRequirement ? _self.inputRequirement : inputRequirement // ignore: cast_nullable_to_non_nullable
as InputRequirement,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,lang: null == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as ContentLang,defaultPerItemTimeSec: freezed == defaultPerItemTimeSec ? _self.defaultPerItemTimeSec : defaultPerItemTimeSec // ignore: cast_nullable_to_non_nullable
as int?,defaultCadence: freezed == defaultCadence ? _self.defaultCadence : defaultCadence // ignore: cast_nullable_to_non_nullable
as Cadence?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get shortName {
    if (_self.shortName == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.shortName!, (value) {
    return _then(_self.copyWith(shortName: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CadenceCopyWith<$Res>? get defaultCadence {
    if (_self.defaultCadence == null) {
    return null;
  }

  return $CadenceCopyWith<$Res>(_self.defaultCadence!, (value) {
    return _then(_self.copyWith(defaultCadence: value));
  });
}/// Create a copy of TestFamily
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentMetaCopyWith<$Res>? get meta {
    if (_self.meta == null) {
    return null;
  }

  return $ContentMetaCopyWith<$Res>(_self.meta!, (value) {
    return _then(_self.copyWith(meta: value));
  });
}
}

// dart format on
