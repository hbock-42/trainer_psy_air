// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exam_blueprint.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExamBlueprint {

 String get id; int get version; ModuleId get moduleId; LocalizedText get name; LocalizedText get description; Confidence get confidence; List<String> get tags; List<ExamSection> get sections; int get briefingSec; ContentStatus get status; ContentMeta? get meta;
/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamBlueprintCopyWith<ExamBlueprint> get copyWith => _$ExamBlueprintCopyWithImpl<ExamBlueprint>(this as ExamBlueprint, _$identity);

  /// Serializes this ExamBlueprint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamBlueprint&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.sections, sections)&&(identical(other.briefingSec, briefingSec) || other.briefingSec == briefingSec)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,name,description,confidence,const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(sections),briefingSec,status,meta);

@override
String toString() {
  return 'ExamBlueprint(id: $id, version: $version, moduleId: $moduleId, name: $name, description: $description, confidence: $confidence, tags: $tags, sections: $sections, briefingSec: $briefingSec, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class $ExamBlueprintCopyWith<$Res>  {
  factory $ExamBlueprintCopyWith(ExamBlueprint value, $Res Function(ExamBlueprint) _then) = _$ExamBlueprintCopyWithImpl;
@useResult
$Res call({
 String id, int version, ModuleId moduleId, LocalizedText name, LocalizedText description, Confidence confidence, List<String> tags, List<ExamSection> sections, int briefingSec, ContentStatus status, ContentMeta? meta
});


$LocalizedTextCopyWith<$Res> get name;$LocalizedTextCopyWith<$Res> get description;$ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class _$ExamBlueprintCopyWithImpl<$Res>
    implements $ExamBlueprintCopyWith<$Res> {
  _$ExamBlueprintCopyWithImpl(this._self, this._then);

  final ExamBlueprint _self;
  final $Res Function(ExamBlueprint) _then;

/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? name = null,Object? description = null,Object? confidence = null,Object? tags = null,Object? sections = null,Object? briefingSec = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,briefingSec: null == briefingSec ? _self.briefingSec : briefingSec // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}
/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of ExamBlueprint
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


/// Adds pattern-matching-related methods to [ExamBlueprint].
extension ExamBlueprintPatterns on ExamBlueprint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamBlueprint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamBlueprint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamBlueprint value)  $default,){
final _that = this;
switch (_that) {
case _ExamBlueprint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamBlueprint value)?  $default,){
final _that = this;
switch (_that) {
case _ExamBlueprint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  LocalizedText name,  LocalizedText description,  Confidence confidence,  List<String> tags,  List<ExamSection> sections,  int briefingSec,  ContentStatus status,  ContentMeta? meta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamBlueprint() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.name,_that.description,_that.confidence,_that.tags,_that.sections,_that.briefingSec,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version,  ModuleId moduleId,  LocalizedText name,  LocalizedText description,  Confidence confidence,  List<String> tags,  List<ExamSection> sections,  int briefingSec,  ContentStatus status,  ContentMeta? meta)  $default,) {final _that = this;
switch (_that) {
case _ExamBlueprint():
return $default(_that.id,_that.version,_that.moduleId,_that.name,_that.description,_that.confidence,_that.tags,_that.sections,_that.briefingSec,_that.status,_that.meta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version,  ModuleId moduleId,  LocalizedText name,  LocalizedText description,  Confidence confidence,  List<String> tags,  List<ExamSection> sections,  int briefingSec,  ContentStatus status,  ContentMeta? meta)?  $default,) {final _that = this;
switch (_that) {
case _ExamBlueprint() when $default != null:
return $default(_that.id,_that.version,_that.moduleId,_that.name,_that.description,_that.confidence,_that.tags,_that.sections,_that.briefingSec,_that.status,_that.meta);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamBlueprint implements ExamBlueprint {
  const _ExamBlueprint({required this.id, required this.version, required this.moduleId, required this.name, required this.description, required this.confidence, required final  List<String> tags, required final  List<ExamSection> sections, this.briefingSec = 0, this.status = ContentStatus.published, this.meta}): _tags = tags,_sections = sections;
  factory _ExamBlueprint.fromJson(Map<String, dynamic> json) => _$ExamBlueprintFromJson(json);

@override final  String id;
@override final  int version;
@override final  ModuleId moduleId;
@override final  LocalizedText name;
@override final  LocalizedText description;
@override final  Confidence confidence;
 final  List<String> _tags;
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  List<ExamSection> _sections;
@override List<ExamSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}

@override@JsonKey() final  int briefingSec;
@override@JsonKey() final  ContentStatus status;
@override final  ContentMeta? meta;

/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamBlueprintCopyWith<_ExamBlueprint> get copyWith => __$ExamBlueprintCopyWithImpl<_ExamBlueprint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamBlueprintToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamBlueprint&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._sections, _sections)&&(identical(other.briefingSec, briefingSec) || other.briefingSec == briefingSec)&&(identical(other.status, status) || other.status == status)&&(identical(other.meta, meta) || other.meta == meta));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,version,moduleId,name,description,confidence,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_sections),briefingSec,status,meta);

@override
String toString() {
  return 'ExamBlueprint(id: $id, version: $version, moduleId: $moduleId, name: $name, description: $description, confidence: $confidence, tags: $tags, sections: $sections, briefingSec: $briefingSec, status: $status, meta: $meta)';
}


}

/// @nodoc
abstract mixin class _$ExamBlueprintCopyWith<$Res> implements $ExamBlueprintCopyWith<$Res> {
  factory _$ExamBlueprintCopyWith(_ExamBlueprint value, $Res Function(_ExamBlueprint) _then) = __$ExamBlueprintCopyWithImpl;
@override @useResult
$Res call({
 String id, int version, ModuleId moduleId, LocalizedText name, LocalizedText description, Confidence confidence, List<String> tags, List<ExamSection> sections, int briefingSec, ContentStatus status, ContentMeta? meta
});


@override $LocalizedTextCopyWith<$Res> get name;@override $LocalizedTextCopyWith<$Res> get description;@override $ContentMetaCopyWith<$Res>? get meta;

}
/// @nodoc
class __$ExamBlueprintCopyWithImpl<$Res>
    implements _$ExamBlueprintCopyWith<$Res> {
  __$ExamBlueprintCopyWithImpl(this._self, this._then);

  final _ExamBlueprint _self;
  final $Res Function(_ExamBlueprint) _then;

/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? moduleId = null,Object? name = null,Object? description = null,Object? confidence = null,Object? tags = null,Object? sections = null,Object? briefingSec = null,Object? status = null,Object? meta = freezed,}) {
  return _then(_ExamBlueprint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,moduleId: null == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as ModuleId,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as LocalizedText,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as LocalizedText,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ExamSection>,briefingSec: null == briefingSec ? _self.briefingSec : briefingSec // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContentStatus,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as ContentMeta?,
  ));
}

/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get name {
  
  return $LocalizedTextCopyWith<$Res>(_self.name, (value) {
    return _then(_self.copyWith(name: value));
  });
}/// Create a copy of ExamBlueprint
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res> get description {
  
  return $LocalizedTextCopyWith<$Res>(_self.description, (value) {
    return _then(_self.copyWith(description: value));
  });
}/// Create a copy of ExamBlueprint
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


/// @nodoc
mixin _$ExamSection {

 String get id; String get familyId; int get itemCount; ItemSelection get itemSelection; Confidence get confidence; LocalizedText? get title; LocalizedText? get briefing; int? get sectionTimeSec; int? get perItemTimeSec; Cadence? get cadence; ScoringPolicy get scoringPolicy; bool get liveFeedback; InputRequirement get inputRequirement; int get breakAfterSec; double get weight;
/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamSectionCopyWith<ExamSection> get copyWith => _$ExamSectionCopyWithImpl<ExamSection>(this as ExamSection, _$identity);

  /// Serializes this ExamSection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamSection&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.itemSelection, itemSelection) || other.itemSelection == itemSelection)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.title, title) || other.title == title)&&(identical(other.briefing, briefing) || other.briefing == briefing)&&(identical(other.sectionTimeSec, sectionTimeSec) || other.sectionTimeSec == sectionTimeSec)&&(identical(other.perItemTimeSec, perItemTimeSec) || other.perItemTimeSec == perItemTimeSec)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.inputRequirement, inputRequirement) || other.inputRequirement == inputRequirement)&&(identical(other.breakAfterSec, breakAfterSec) || other.breakAfterSec == breakAfterSec)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,itemCount,itemSelection,confidence,title,briefing,sectionTimeSec,perItemTimeSec,cadence,scoringPolicy,liveFeedback,inputRequirement,breakAfterSec,weight);

@override
String toString() {
  return 'ExamSection(id: $id, familyId: $familyId, itemCount: $itemCount, itemSelection: $itemSelection, confidence: $confidence, title: $title, briefing: $briefing, sectionTimeSec: $sectionTimeSec, perItemTimeSec: $perItemTimeSec, cadence: $cadence, scoringPolicy: $scoringPolicy, liveFeedback: $liveFeedback, inputRequirement: $inputRequirement, breakAfterSec: $breakAfterSec, weight: $weight)';
}


}

/// @nodoc
abstract mixin class $ExamSectionCopyWith<$Res>  {
  factory $ExamSectionCopyWith(ExamSection value, $Res Function(ExamSection) _then) = _$ExamSectionCopyWithImpl;
@useResult
$Res call({
 String id, String familyId, int itemCount, ItemSelection itemSelection, Confidence confidence, LocalizedText? title, LocalizedText? briefing, int? sectionTimeSec, int? perItemTimeSec, Cadence? cadence, ScoringPolicy scoringPolicy, bool liveFeedback, InputRequirement inputRequirement, int breakAfterSec, double weight
});


$ItemSelectionCopyWith<$Res> get itemSelection;$LocalizedTextCopyWith<$Res>? get title;$LocalizedTextCopyWith<$Res>? get briefing;$CadenceCopyWith<$Res>? get cadence;$ScoringPolicyCopyWith<$Res> get scoringPolicy;

}
/// @nodoc
class _$ExamSectionCopyWithImpl<$Res>
    implements $ExamSectionCopyWith<$Res> {
  _$ExamSectionCopyWithImpl(this._self, this._then);

  final ExamSection _self;
  final $Res Function(ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyId = null,Object? itemCount = null,Object? itemSelection = null,Object? confidence = null,Object? title = freezed,Object? briefing = freezed,Object? sectionTimeSec = freezed,Object? perItemTimeSec = freezed,Object? cadence = freezed,Object? scoringPolicy = null,Object? liveFeedback = null,Object? inputRequirement = null,Object? breakAfterSec = null,Object? weight = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,itemSelection: null == itemSelection ? _self.itemSelection : itemSelection // ignore: cast_nullable_to_non_nullable
as ItemSelection,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,briefing: freezed == briefing ? _self.briefing : briefing // ignore: cast_nullable_to_non_nullable
as LocalizedText?,sectionTimeSec: freezed == sectionTimeSec ? _self.sectionTimeSec : sectionTimeSec // ignore: cast_nullable_to_non_nullable
as int?,perItemTimeSec: freezed == perItemTimeSec ? _self.perItemTimeSec : perItemTimeSec // ignore: cast_nullable_to_non_nullable
as int?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as Cadence?,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,inputRequirement: null == inputRequirement ? _self.inputRequirement : inputRequirement // ignore: cast_nullable_to_non_nullable
as InputRequirement,breakAfterSec: null == breakAfterSec ? _self.breakAfterSec : breakAfterSec // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}
/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemSelectionCopyWith<$Res> get itemSelection {
  
  return $ItemSelectionCopyWith<$Res>(_self.itemSelection, (value) {
    return _then(_self.copyWith(itemSelection: value));
  });
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get briefing {
    if (_self.briefing == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.briefing!, (value) {
    return _then(_self.copyWith(briefing: value));
  });
}/// Create a copy of ExamSection
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
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExamSection].
extension ExamSectionPatterns on ExamSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamSection value)  $default,){
final _that = this;
switch (_that) {
case _ExamSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamSection value)?  $default,){
final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String familyId,  int itemCount,  ItemSelection itemSelection,  Confidence confidence,  LocalizedText? title,  LocalizedText? briefing,  int? sectionTimeSec,  int? perItemTimeSec,  Cadence? cadence,  ScoringPolicy scoringPolicy,  bool liveFeedback,  InputRequirement inputRequirement,  int breakAfterSec,  double weight)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.familyId,_that.itemCount,_that.itemSelection,_that.confidence,_that.title,_that.briefing,_that.sectionTimeSec,_that.perItemTimeSec,_that.cadence,_that.scoringPolicy,_that.liveFeedback,_that.inputRequirement,_that.breakAfterSec,_that.weight);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String familyId,  int itemCount,  ItemSelection itemSelection,  Confidence confidence,  LocalizedText? title,  LocalizedText? briefing,  int? sectionTimeSec,  int? perItemTimeSec,  Cadence? cadence,  ScoringPolicy scoringPolicy,  bool liveFeedback,  InputRequirement inputRequirement,  int breakAfterSec,  double weight)  $default,) {final _that = this;
switch (_that) {
case _ExamSection():
return $default(_that.id,_that.familyId,_that.itemCount,_that.itemSelection,_that.confidence,_that.title,_that.briefing,_that.sectionTimeSec,_that.perItemTimeSec,_that.cadence,_that.scoringPolicy,_that.liveFeedback,_that.inputRequirement,_that.breakAfterSec,_that.weight);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String familyId,  int itemCount,  ItemSelection itemSelection,  Confidence confidence,  LocalizedText? title,  LocalizedText? briefing,  int? sectionTimeSec,  int? perItemTimeSec,  Cadence? cadence,  ScoringPolicy scoringPolicy,  bool liveFeedback,  InputRequirement inputRequirement,  int breakAfterSec,  double weight)?  $default,) {final _that = this;
switch (_that) {
case _ExamSection() when $default != null:
return $default(_that.id,_that.familyId,_that.itemCount,_that.itemSelection,_that.confidence,_that.title,_that.briefing,_that.sectionTimeSec,_that.perItemTimeSec,_that.cadence,_that.scoringPolicy,_that.liveFeedback,_that.inputRequirement,_that.breakAfterSec,_that.weight);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamSection extends ExamSection {
  const _ExamSection({required this.id, required this.familyId, required this.itemCount, required this.itemSelection, required this.confidence, this.title, this.briefing, this.sectionTimeSec, this.perItemTimeSec, this.cadence, this.scoringPolicy = const ScoringPolicy(), this.liveFeedback = false, this.inputRequirement = InputRequirement.touch, this.breakAfterSec = 0, this.weight = 1.0}): super._();
  factory _ExamSection.fromJson(Map<String, dynamic> json) => _$ExamSectionFromJson(json);

@override final  String id;
@override final  String familyId;
@override final  int itemCount;
@override final  ItemSelection itemSelection;
@override final  Confidence confidence;
@override final  LocalizedText? title;
@override final  LocalizedText? briefing;
@override final  int? sectionTimeSec;
@override final  int? perItemTimeSec;
@override final  Cadence? cadence;
@override@JsonKey() final  ScoringPolicy scoringPolicy;
@override@JsonKey() final  bool liveFeedback;
@override@JsonKey() final  InputRequirement inputRequirement;
@override@JsonKey() final  int breakAfterSec;
@override@JsonKey() final  double weight;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamSectionCopyWith<_ExamSection> get copyWith => __$ExamSectionCopyWithImpl<_ExamSection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamSectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamSection&&(identical(other.id, id) || other.id == id)&&(identical(other.familyId, familyId) || other.familyId == familyId)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.itemSelection, itemSelection) || other.itemSelection == itemSelection)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.title, title) || other.title == title)&&(identical(other.briefing, briefing) || other.briefing == briefing)&&(identical(other.sectionTimeSec, sectionTimeSec) || other.sectionTimeSec == sectionTimeSec)&&(identical(other.perItemTimeSec, perItemTimeSec) || other.perItemTimeSec == perItemTimeSec)&&(identical(other.cadence, cadence) || other.cadence == cadence)&&(identical(other.scoringPolicy, scoringPolicy) || other.scoringPolicy == scoringPolicy)&&(identical(other.liveFeedback, liveFeedback) || other.liveFeedback == liveFeedback)&&(identical(other.inputRequirement, inputRequirement) || other.inputRequirement == inputRequirement)&&(identical(other.breakAfterSec, breakAfterSec) || other.breakAfterSec == breakAfterSec)&&(identical(other.weight, weight) || other.weight == weight));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,familyId,itemCount,itemSelection,confidence,title,briefing,sectionTimeSec,perItemTimeSec,cadence,scoringPolicy,liveFeedback,inputRequirement,breakAfterSec,weight);

@override
String toString() {
  return 'ExamSection(id: $id, familyId: $familyId, itemCount: $itemCount, itemSelection: $itemSelection, confidence: $confidence, title: $title, briefing: $briefing, sectionTimeSec: $sectionTimeSec, perItemTimeSec: $perItemTimeSec, cadence: $cadence, scoringPolicy: $scoringPolicy, liveFeedback: $liveFeedback, inputRequirement: $inputRequirement, breakAfterSec: $breakAfterSec, weight: $weight)';
}


}

/// @nodoc
abstract mixin class _$ExamSectionCopyWith<$Res> implements $ExamSectionCopyWith<$Res> {
  factory _$ExamSectionCopyWith(_ExamSection value, $Res Function(_ExamSection) _then) = __$ExamSectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String familyId, int itemCount, ItemSelection itemSelection, Confidence confidence, LocalizedText? title, LocalizedText? briefing, int? sectionTimeSec, int? perItemTimeSec, Cadence? cadence, ScoringPolicy scoringPolicy, bool liveFeedback, InputRequirement inputRequirement, int breakAfterSec, double weight
});


@override $ItemSelectionCopyWith<$Res> get itemSelection;@override $LocalizedTextCopyWith<$Res>? get title;@override $LocalizedTextCopyWith<$Res>? get briefing;@override $CadenceCopyWith<$Res>? get cadence;@override $ScoringPolicyCopyWith<$Res> get scoringPolicy;

}
/// @nodoc
class __$ExamSectionCopyWithImpl<$Res>
    implements _$ExamSectionCopyWith<$Res> {
  __$ExamSectionCopyWithImpl(this._self, this._then);

  final _ExamSection _self;
  final $Res Function(_ExamSection) _then;

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyId = null,Object? itemCount = null,Object? itemSelection = null,Object? confidence = null,Object? title = freezed,Object? briefing = freezed,Object? sectionTimeSec = freezed,Object? perItemTimeSec = freezed,Object? cadence = freezed,Object? scoringPolicy = null,Object? liveFeedback = null,Object? inputRequirement = null,Object? breakAfterSec = null,Object? weight = null,}) {
  return _then(_ExamSection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyId: null == familyId ? _self.familyId : familyId // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,itemSelection: null == itemSelection ? _self.itemSelection : itemSelection // ignore: cast_nullable_to_non_nullable
as ItemSelection,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as Confidence,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as LocalizedText?,briefing: freezed == briefing ? _self.briefing : briefing // ignore: cast_nullable_to_non_nullable
as LocalizedText?,sectionTimeSec: freezed == sectionTimeSec ? _self.sectionTimeSec : sectionTimeSec // ignore: cast_nullable_to_non_nullable
as int?,perItemTimeSec: freezed == perItemTimeSec ? _self.perItemTimeSec : perItemTimeSec // ignore: cast_nullable_to_non_nullable
as int?,cadence: freezed == cadence ? _self.cadence : cadence // ignore: cast_nullable_to_non_nullable
as Cadence?,scoringPolicy: null == scoringPolicy ? _self.scoringPolicy : scoringPolicy // ignore: cast_nullable_to_non_nullable
as ScoringPolicy,liveFeedback: null == liveFeedback ? _self.liveFeedback : liveFeedback // ignore: cast_nullable_to_non_nullable
as bool,inputRequirement: null == inputRequirement ? _self.inputRequirement : inputRequirement // ignore: cast_nullable_to_non_nullable
as InputRequirement,breakAfterSec: null == breakAfterSec ? _self.breakAfterSec : breakAfterSec // ignore: cast_nullable_to_non_nullable
as int,weight: null == weight ? _self.weight : weight // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemSelectionCopyWith<$Res> get itemSelection {
  
  return $ItemSelectionCopyWith<$Res>(_self.itemSelection, (value) {
    return _then(_self.copyWith(itemSelection: value));
  });
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get title {
    if (_self.title == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.title!, (value) {
    return _then(_self.copyWith(title: value));
  });
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LocalizedTextCopyWith<$Res>? get briefing {
    if (_self.briefing == null) {
    return null;
  }

  return $LocalizedTextCopyWith<$Res>(_self.briefing!, (value) {
    return _then(_self.copyWith(briefing: value));
  });
}/// Create a copy of ExamSection
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
}/// Create a copy of ExamSection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScoringPolicyCopyWith<$Res> get scoringPolicy {
  
  return $ScoringPolicyCopyWith<$Res>(_self.scoringPolicy, (value) {
    return _then(_self.copyWith(scoringPolicy: value));
  });
}
}

ItemSelection _$ItemSelectionFromJson(
  Map<String, dynamic> json
) {
        switch (json['mode']) {
                  case 'bank':
          return BankSelection.fromJson(
            json
          );
                case 'generated':
          return GeneratedSelection.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'mode',
  'ItemSelection',
  'Invalid union type "${json['mode']}"!'
);
        }
      
}

/// @nodoc
mixin _$ItemSelection {

 DifficultyRange? get difficulty;
/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemSelectionCopyWith<ItemSelection> get copyWith => _$ItemSelectionCopyWithImpl<ItemSelection>(this as ItemSelection, _$identity);

  /// Serializes this ItemSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemSelection&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty);

@override
String toString() {
  return 'ItemSelection(difficulty: $difficulty)';
}


}

/// @nodoc
abstract mixin class $ItemSelectionCopyWith<$Res>  {
  factory $ItemSelectionCopyWith(ItemSelection value, $Res Function(ItemSelection) _then) = _$ItemSelectionCopyWithImpl;
@useResult
$Res call({
 DifficultyRange difficulty
});


$DifficultyRangeCopyWith<$Res>? get difficulty;

}
/// @nodoc
class _$ItemSelectionCopyWithImpl<$Res>
    implements $ItemSelectionCopyWith<$Res> {
  _$ItemSelectionCopyWithImpl(this._self, this._then);

  final ItemSelection _self;
  final $Res Function(ItemSelection) _then;

/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? difficulty = null,}) {
  return _then(_self.copyWith(
difficulty: null == difficulty ? _self.difficulty! : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyRange,
  ));
}
/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DifficultyRangeCopyWith<$Res>? get difficulty {
    if (_self.difficulty == null) {
    return null;
  }

  return $DifficultyRangeCopyWith<$Res>(_self.difficulty!, (value) {
    return _then(_self.copyWith(difficulty: value));
  });
}
}


/// Adds pattern-matching-related methods to [ItemSelection].
extension ItemSelectionPatterns on ItemSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BankSelection value)?  bank,TResult Function( GeneratedSelection value)?  generated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BankSelection() when bank != null:
return bank(_that);case GeneratedSelection() when generated != null:
return generated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BankSelection value)  bank,required TResult Function( GeneratedSelection value)  generated,}){
final _that = this;
switch (_that) {
case BankSelection():
return bank(_that);case GeneratedSelection():
return generated(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BankSelection value)?  bank,TResult? Function( GeneratedSelection value)?  generated,}){
final _that = this;
switch (_that) {
case BankSelection() when bank != null:
return bank(_that);case GeneratedSelection() when generated != null:
return generated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DifficultyRange? difficulty,  List<String>? tags,  List<String>? anyTags,  String? balanceByTagPrefix,  int avoidRecentSessions)?  bank,TResult Function( GeneratorId generatorId,  DifficultyRange difficulty, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params)?  generated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BankSelection() when bank != null:
return bank(_that.difficulty,_that.tags,_that.anyTags,_that.balanceByTagPrefix,_that.avoidRecentSessions);case GeneratedSelection() when generated != null:
return generated(_that.generatorId,_that.difficulty,_that.params);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DifficultyRange? difficulty,  List<String>? tags,  List<String>? anyTags,  String? balanceByTagPrefix,  int avoidRecentSessions)  bank,required TResult Function( GeneratorId generatorId,  DifficultyRange difficulty, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params)  generated,}) {final _that = this;
switch (_that) {
case BankSelection():
return bank(_that.difficulty,_that.tags,_that.anyTags,_that.balanceByTagPrefix,_that.avoidRecentSessions);case GeneratedSelection():
return generated(_that.generatorId,_that.difficulty,_that.params);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DifficultyRange? difficulty,  List<String>? tags,  List<String>? anyTags,  String? balanceByTagPrefix,  int avoidRecentSessions)?  bank,TResult? Function( GeneratorId generatorId,  DifficultyRange difficulty, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson)  GeneratorParams params)?  generated,}) {final _that = this;
switch (_that) {
case BankSelection() when bank != null:
return bank(_that.difficulty,_that.tags,_that.anyTags,_that.balanceByTagPrefix,_that.avoidRecentSessions);case GeneratedSelection() when generated != null:
return generated(_that.generatorId,_that.difficulty,_that.params);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class BankSelection implements ItemSelection {
  const BankSelection({this.difficulty, final  List<String>? tags, final  List<String>? anyTags, this.balanceByTagPrefix, this.avoidRecentSessions = 3, final  String? $type}): _tags = tags,_anyTags = anyTags,$type = $type ?? 'bank';
  factory BankSelection.fromJson(Map<String, dynamic> json) => _$BankSelectionFromJson(json);

@override final  DifficultyRange? difficulty;
 final  List<String>? _tags;
 List<String>? get tags {
  final value = _tags;
  if (value == null) return null;
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _anyTags;
 List<String>? get anyTags {
  final value = _anyTags;
  if (value == null) return null;
  if (_anyTags is EqualUnmodifiableListView) return _anyTags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  String? balanceByTagPrefix;
@JsonKey() final  int avoidRecentSessions;

@JsonKey(name: 'mode')
final String $type;


/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BankSelectionCopyWith<BankSelection> get copyWith => _$BankSelectionCopyWithImpl<BankSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BankSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BankSelection&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._anyTags, _anyTags)&&(identical(other.balanceByTagPrefix, balanceByTagPrefix) || other.balanceByTagPrefix == balanceByTagPrefix)&&(identical(other.avoidRecentSessions, avoidRecentSessions) || other.avoidRecentSessions == avoidRecentSessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,difficulty,const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_anyTags),balanceByTagPrefix,avoidRecentSessions);

@override
String toString() {
  return 'ItemSelection.bank(difficulty: $difficulty, tags: $tags, anyTags: $anyTags, balanceByTagPrefix: $balanceByTagPrefix, avoidRecentSessions: $avoidRecentSessions)';
}


}

/// @nodoc
abstract mixin class $BankSelectionCopyWith<$Res> implements $ItemSelectionCopyWith<$Res> {
  factory $BankSelectionCopyWith(BankSelection value, $Res Function(BankSelection) _then) = _$BankSelectionCopyWithImpl;
@override @useResult
$Res call({
 DifficultyRange? difficulty, List<String>? tags, List<String>? anyTags, String? balanceByTagPrefix, int avoidRecentSessions
});


@override $DifficultyRangeCopyWith<$Res>? get difficulty;

}
/// @nodoc
class _$BankSelectionCopyWithImpl<$Res>
    implements $BankSelectionCopyWith<$Res> {
  _$BankSelectionCopyWithImpl(this._self, this._then);

  final BankSelection _self;
  final $Res Function(BankSelection) _then;

/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? difficulty = freezed,Object? tags = freezed,Object? anyTags = freezed,Object? balanceByTagPrefix = freezed,Object? avoidRecentSessions = null,}) {
  return _then(BankSelection(
difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyRange?,tags: freezed == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>?,anyTags: freezed == anyTags ? _self._anyTags : anyTags // ignore: cast_nullable_to_non_nullable
as List<String>?,balanceByTagPrefix: freezed == balanceByTagPrefix ? _self.balanceByTagPrefix : balanceByTagPrefix // ignore: cast_nullable_to_non_nullable
as String?,avoidRecentSessions: null == avoidRecentSessions ? _self.avoidRecentSessions : avoidRecentSessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DifficultyRangeCopyWith<$Res>? get difficulty {
    if (_self.difficulty == null) {
    return null;
  }

  return $DifficultyRangeCopyWith<$Res>(_self.difficulty!, (value) {
    return _then(_self.copyWith(difficulty: value));
  });
}
}

/// @nodoc
@JsonSerializable()

class GeneratedSelection implements ItemSelection {
  const GeneratedSelection({required this.generatorId, required this.difficulty, @JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) required this.params, final  String? $type}): $type = $type ?? 'generated';
  factory GeneratedSelection.fromJson(Map<String, dynamic> json) => _$GeneratedSelectionFromJson(json);

 final  GeneratorId generatorId;
@override final  DifficultyRange difficulty;
@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) final  GeneratorParams params;

@JsonKey(name: 'mode')
final String $type;


/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeneratedSelectionCopyWith<GeneratedSelection> get copyWith => _$GeneratedSelectionCopyWithImpl<GeneratedSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeneratedSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeneratedSelection&&(identical(other.generatorId, generatorId) || other.generatorId == generatorId)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.params, params) || other.params == params));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,generatorId,difficulty,params);

@override
String toString() {
  return 'ItemSelection.generated(generatorId: $generatorId, difficulty: $difficulty, params: $params)';
}


}

/// @nodoc
abstract mixin class $GeneratedSelectionCopyWith<$Res> implements $ItemSelectionCopyWith<$Res> {
  factory $GeneratedSelectionCopyWith(GeneratedSelection value, $Res Function(GeneratedSelection) _then) = _$GeneratedSelectionCopyWithImpl;
@override @useResult
$Res call({
 GeneratorId generatorId, DifficultyRange difficulty,@JsonKey(readValue: readGeneratorParams, toJson: generatorParamsToJson) GeneratorParams params
});


@override $DifficultyRangeCopyWith<$Res> get difficulty;$GeneratorParamsCopyWith<$Res> get params;

}
/// @nodoc
class _$GeneratedSelectionCopyWithImpl<$Res>
    implements $GeneratedSelectionCopyWith<$Res> {
  _$GeneratedSelectionCopyWithImpl(this._self, this._then);

  final GeneratedSelection _self;
  final $Res Function(GeneratedSelection) _then;

/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? generatorId = null,Object? difficulty = null,Object? params = null,}) {
  return _then(GeneratedSelection(
generatorId: null == generatorId ? _self.generatorId : generatorId // ignore: cast_nullable_to_non_nullable
as GeneratorId,difficulty: null == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as DifficultyRange,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as GeneratorParams,
  ));
}

/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DifficultyRangeCopyWith<$Res> get difficulty {
  
  return $DifficultyRangeCopyWith<$Res>(_self.difficulty, (value) {
    return _then(_self.copyWith(difficulty: value));
  });
}/// Create a copy of ItemSelection
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeneratorParamsCopyWith<$Res> get params {
  
  return $GeneratorParamsCopyWith<$Res>(_self.params, (value) {
    return _then(_self.copyWith(params: value));
  });
}
}


/// @nodoc
mixin _$DifficultyRange {

@JsonKey(fromJson: difficultyFromJson) Difficulty get min;@JsonKey(fromJson: difficultyFromJson) Difficulty get max;
/// Create a copy of DifficultyRange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DifficultyRangeCopyWith<DifficultyRange> get copyWith => _$DifficultyRangeCopyWithImpl<DifficultyRange>(this as DifficultyRange, _$identity);

  /// Serializes this DifficultyRange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DifficultyRange&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'DifficultyRange(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class $DifficultyRangeCopyWith<$Res>  {
  factory $DifficultyRangeCopyWith(DifficultyRange value, $Res Function(DifficultyRange) _then) = _$DifficultyRangeCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: difficultyFromJson) Difficulty min,@JsonKey(fromJson: difficultyFromJson) Difficulty max
});




}
/// @nodoc
class _$DifficultyRangeCopyWithImpl<$Res>
    implements $DifficultyRangeCopyWith<$Res> {
  _$DifficultyRangeCopyWithImpl(this._self, this._then);

  final DifficultyRange _self;
  final $Res Function(DifficultyRange) _then;

/// Create a copy of DifficultyRange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? min = null,Object? max = null,}) {
  return _then(_self.copyWith(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as Difficulty,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as Difficulty,
  ));
}

}


/// Adds pattern-matching-related methods to [DifficultyRange].
extension DifficultyRangePatterns on DifficultyRange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DifficultyRange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DifficultyRange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DifficultyRange value)  $default,){
final _that = this;
switch (_that) {
case _DifficultyRange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DifficultyRange value)?  $default,){
final _that = this;
switch (_that) {
case _DifficultyRange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: difficultyFromJson)  Difficulty min, @JsonKey(fromJson: difficultyFromJson)  Difficulty max)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DifficultyRange() when $default != null:
return $default(_that.min,_that.max);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: difficultyFromJson)  Difficulty min, @JsonKey(fromJson: difficultyFromJson)  Difficulty max)  $default,) {final _that = this;
switch (_that) {
case _DifficultyRange():
return $default(_that.min,_that.max);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: difficultyFromJson)  Difficulty min, @JsonKey(fromJson: difficultyFromJson)  Difficulty max)?  $default,) {final _that = this;
switch (_that) {
case _DifficultyRange() when $default != null:
return $default(_that.min,_that.max);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DifficultyRange implements DifficultyRange {
  const _DifficultyRange({@JsonKey(fromJson: difficultyFromJson) required this.min, @JsonKey(fromJson: difficultyFromJson) required this.max}): assert(min <= max, 'min must not exceed max');
  factory _DifficultyRange.fromJson(Map<String, dynamic> json) => _$DifficultyRangeFromJson(json);

@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty min;
@override@JsonKey(fromJson: difficultyFromJson) final  Difficulty max;

/// Create a copy of DifficultyRange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DifficultyRangeCopyWith<_DifficultyRange> get copyWith => __$DifficultyRangeCopyWithImpl<_DifficultyRange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DifficultyRangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DifficultyRange&&(identical(other.min, min) || other.min == min)&&(identical(other.max, max) || other.max == max));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,min,max);

@override
String toString() {
  return 'DifficultyRange(min: $min, max: $max)';
}


}

/// @nodoc
abstract mixin class _$DifficultyRangeCopyWith<$Res> implements $DifficultyRangeCopyWith<$Res> {
  factory _$DifficultyRangeCopyWith(_DifficultyRange value, $Res Function(_DifficultyRange) _then) = __$DifficultyRangeCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: difficultyFromJson) Difficulty min,@JsonKey(fromJson: difficultyFromJson) Difficulty max
});




}
/// @nodoc
class __$DifficultyRangeCopyWithImpl<$Res>
    implements _$DifficultyRangeCopyWith<$Res> {
  __$DifficultyRangeCopyWithImpl(this._self, this._then);

  final _DifficultyRange _self;
  final $Res Function(_DifficultyRange) _then;

/// Create a copy of DifficultyRange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? min = null,Object? max = null,}) {
  return _then(_DifficultyRange(
min: null == min ? _self.min : min // ignore: cast_nullable_to_non_nullable
as Difficulty,max: null == max ? _self.max : max // ignore: cast_nullable_to_non_nullable
as Difficulty,
  ));
}


}

// dart format on
