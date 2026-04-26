// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DocumentTemplate {

 String get id; String get name; String get description; DocumentType get type; String get promptInstructions; String? get sampleImageUrl;// URL or Storage path for the sample image
 List<String> get supportedAspectRatios; bool get supportsOrientation;
/// Create a copy of DocumentTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentTemplateCopyWith<DocumentTemplate> get copyWith => _$DocumentTemplateCopyWithImpl<DocumentTemplate>(this as DocumentTemplate, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.promptInstructions, promptInstructions) || other.promptInstructions == promptInstructions)&&(identical(other.sampleImageUrl, sampleImageUrl) || other.sampleImageUrl == sampleImageUrl)&&const DeepCollectionEquality().equals(other.supportedAspectRatios, supportedAspectRatios)&&(identical(other.supportsOrientation, supportsOrientation) || other.supportsOrientation == supportsOrientation));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,promptInstructions,sampleImageUrl,const DeepCollectionEquality().hash(supportedAspectRatios),supportsOrientation);

@override
String toString() {
  return 'DocumentTemplate(id: $id, name: $name, description: $description, type: $type, promptInstructions: $promptInstructions, sampleImageUrl: $sampleImageUrl, supportedAspectRatios: $supportedAspectRatios, supportsOrientation: $supportsOrientation)';
}


}

/// @nodoc
abstract mixin class $DocumentTemplateCopyWith<$Res>  {
  factory $DocumentTemplateCopyWith(DocumentTemplate value, $Res Function(DocumentTemplate) _then) = _$DocumentTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, DocumentType type, String promptInstructions, String? sampleImageUrl, List<String> supportedAspectRatios, bool supportsOrientation
});




}
/// @nodoc
class _$DocumentTemplateCopyWithImpl<$Res>
    implements $DocumentTemplateCopyWith<$Res> {
  _$DocumentTemplateCopyWithImpl(this._self, this._then);

  final DocumentTemplate _self;
  final $Res Function(DocumentTemplate) _then;

/// Create a copy of DocumentTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? type = null,Object? promptInstructions = null,Object? sampleImageUrl = freezed,Object? supportedAspectRatios = null,Object? supportsOrientation = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,promptInstructions: null == promptInstructions ? _self.promptInstructions : promptInstructions // ignore: cast_nullable_to_non_nullable
as String,sampleImageUrl: freezed == sampleImageUrl ? _self.sampleImageUrl : sampleImageUrl // ignore: cast_nullable_to_non_nullable
as String?,supportedAspectRatios: null == supportedAspectRatios ? _self.supportedAspectRatios : supportedAspectRatios // ignore: cast_nullable_to_non_nullable
as List<String>,supportsOrientation: null == supportsOrientation ? _self.supportsOrientation : supportsOrientation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentTemplate].
extension DocumentTemplatePatterns on DocumentTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentTemplate value)  $default,){
final _that = this;
switch (_that) {
case _DocumentTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  DocumentType type,  String promptInstructions,  String? sampleImageUrl,  List<String> supportedAspectRatios,  bool supportsOrientation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.promptInstructions,_that.sampleImageUrl,_that.supportedAspectRatios,_that.supportsOrientation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  DocumentType type,  String promptInstructions,  String? sampleImageUrl,  List<String> supportedAspectRatios,  bool supportsOrientation)  $default,) {final _that = this;
switch (_that) {
case _DocumentTemplate():
return $default(_that.id,_that.name,_that.description,_that.type,_that.promptInstructions,_that.sampleImageUrl,_that.supportedAspectRatios,_that.supportsOrientation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  DocumentType type,  String promptInstructions,  String? sampleImageUrl,  List<String> supportedAspectRatios,  bool supportsOrientation)?  $default,) {final _that = this;
switch (_that) {
case _DocumentTemplate() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.type,_that.promptInstructions,_that.sampleImageUrl,_that.supportedAspectRatios,_that.supportsOrientation);case _:
  return null;

}
}

}

/// @nodoc


class _DocumentTemplate implements DocumentTemplate {
  const _DocumentTemplate({required this.id, required this.name, required this.description, required this.type, required this.promptInstructions, this.sampleImageUrl, final  List<String> supportedAspectRatios = const [], this.supportsOrientation = true}): _supportedAspectRatios = supportedAspectRatios;
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  DocumentType type;
@override final  String promptInstructions;
@override final  String? sampleImageUrl;
// URL or Storage path for the sample image
 final  List<String> _supportedAspectRatios;
// URL or Storage path for the sample image
@override@JsonKey() List<String> get supportedAspectRatios {
  if (_supportedAspectRatios is EqualUnmodifiableListView) return _supportedAspectRatios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_supportedAspectRatios);
}

@override@JsonKey() final  bool supportsOrientation;

/// Create a copy of DocumentTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentTemplateCopyWith<_DocumentTemplate> get copyWith => __$DocumentTemplateCopyWithImpl<_DocumentTemplate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.type, type) || other.type == type)&&(identical(other.promptInstructions, promptInstructions) || other.promptInstructions == promptInstructions)&&(identical(other.sampleImageUrl, sampleImageUrl) || other.sampleImageUrl == sampleImageUrl)&&const DeepCollectionEquality().equals(other._supportedAspectRatios, _supportedAspectRatios)&&(identical(other.supportsOrientation, supportsOrientation) || other.supportsOrientation == supportsOrientation));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,type,promptInstructions,sampleImageUrl,const DeepCollectionEquality().hash(_supportedAspectRatios),supportsOrientation);

@override
String toString() {
  return 'DocumentTemplate(id: $id, name: $name, description: $description, type: $type, promptInstructions: $promptInstructions, sampleImageUrl: $sampleImageUrl, supportedAspectRatios: $supportedAspectRatios, supportsOrientation: $supportsOrientation)';
}


}

/// @nodoc
abstract mixin class _$DocumentTemplateCopyWith<$Res> implements $DocumentTemplateCopyWith<$Res> {
  factory _$DocumentTemplateCopyWith(_DocumentTemplate value, $Res Function(_DocumentTemplate) _then) = __$DocumentTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, DocumentType type, String promptInstructions, String? sampleImageUrl, List<String> supportedAspectRatios, bool supportsOrientation
});




}
/// @nodoc
class __$DocumentTemplateCopyWithImpl<$Res>
    implements _$DocumentTemplateCopyWith<$Res> {
  __$DocumentTemplateCopyWithImpl(this._self, this._then);

  final _DocumentTemplate _self;
  final $Res Function(_DocumentTemplate) _then;

/// Create a copy of DocumentTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? type = null,Object? promptInstructions = null,Object? sampleImageUrl = freezed,Object? supportedAspectRatios = null,Object? supportsOrientation = null,}) {
  return _then(_DocumentTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,promptInstructions: null == promptInstructions ? _self.promptInstructions : promptInstructions // ignore: cast_nullable_to_non_nullable
as String,sampleImageUrl: freezed == sampleImageUrl ? _self.sampleImageUrl : sampleImageUrl // ignore: cast_nullable_to_non_nullable
as String?,supportedAspectRatios: null == supportedAspectRatios ? _self._supportedAspectRatios : supportedAspectRatios // ignore: cast_nullable_to_non_nullable
as List<String>,supportsOrientation: null == supportsOrientation ? _self.supportsOrientation : supportsOrientation // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
