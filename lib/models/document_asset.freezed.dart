// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_asset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentAsset {

 String get id; String get portfolioId; String get userId; String get title; DocumentType get type; AssetPipeline get pipeline;// Structural pipeline fields
 String? get htmlContent;// Graphical pipeline fields
 String? get storageUrl;// Shared / cache
 String? get localCachePath;// absolute path on device
 String? get prompt;// the original user prompt
 bool get isCached; DateTime get createdAt; DateTime? get updatedAt;
/// Create a copy of DocumentAsset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentAssetCopyWith<DocumentAsset> get copyWith => _$DocumentAssetCopyWithImpl<DocumentAsset>(this as DocumentAsset, _$identity);

  /// Serializes this DocumentAsset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.pipeline, pipeline) || other.pipeline == pipeline)&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.localCachePath, localCachePath) || other.localCachePath == localCachePath)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.isCached, isCached) || other.isCached == isCached)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,portfolioId,userId,title,type,pipeline,htmlContent,storageUrl,localCachePath,prompt,isCached,createdAt,updatedAt);

@override
String toString() {
  return 'DocumentAsset(id: $id, portfolioId: $portfolioId, userId: $userId, title: $title, type: $type, pipeline: $pipeline, htmlContent: $htmlContent, storageUrl: $storageUrl, localCachePath: $localCachePath, prompt: $prompt, isCached: $isCached, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $DocumentAssetCopyWith<$Res>  {
  factory $DocumentAssetCopyWith(DocumentAsset value, $Res Function(DocumentAsset) _then) = _$DocumentAssetCopyWithImpl;
@useResult
$Res call({
 String id, String portfolioId, String userId, String title, DocumentType type, AssetPipeline pipeline, String? htmlContent, String? storageUrl, String? localCachePath, String? prompt, bool isCached, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$DocumentAssetCopyWithImpl<$Res>
    implements $DocumentAssetCopyWith<$Res> {
  _$DocumentAssetCopyWithImpl(this._self, this._then);

  final DocumentAsset _self;
  final $Res Function(DocumentAsset) _then;

/// Create a copy of DocumentAsset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? portfolioId = null,Object? userId = null,Object? title = null,Object? type = null,Object? pipeline = null,Object? htmlContent = freezed,Object? storageUrl = freezed,Object? localCachePath = freezed,Object? prompt = freezed,Object? isCached = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as AssetPipeline,htmlContent: freezed == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String?,storageUrl: freezed == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String?,localCachePath: freezed == localCachePath ? _self.localCachePath : localCachePath // ignore: cast_nullable_to_non_nullable
as String?,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String?,isCached: null == isCached ? _self.isCached : isCached // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentAsset].
extension DocumentAssetPatterns on DocumentAsset {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentAsset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentAsset() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentAsset value)  $default,){
final _that = this;
switch (_that) {
case _DocumentAsset():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentAsset value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentAsset() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String portfolioId,  String userId,  String title,  DocumentType type,  AssetPipeline pipeline,  String? htmlContent,  String? storageUrl,  String? localCachePath,  String? prompt,  bool isCached,  DateTime createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentAsset() when $default != null:
return $default(_that.id,_that.portfolioId,_that.userId,_that.title,_that.type,_that.pipeline,_that.htmlContent,_that.storageUrl,_that.localCachePath,_that.prompt,_that.isCached,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String portfolioId,  String userId,  String title,  DocumentType type,  AssetPipeline pipeline,  String? htmlContent,  String? storageUrl,  String? localCachePath,  String? prompt,  bool isCached,  DateTime createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentAsset():
return $default(_that.id,_that.portfolioId,_that.userId,_that.title,_that.type,_that.pipeline,_that.htmlContent,_that.storageUrl,_that.localCachePath,_that.prompt,_that.isCached,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String portfolioId,  String userId,  String title,  DocumentType type,  AssetPipeline pipeline,  String? htmlContent,  String? storageUrl,  String? localCachePath,  String? prompt,  bool isCached,  DateTime createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentAsset() when $default != null:
return $default(_that.id,_that.portfolioId,_that.userId,_that.title,_that.type,_that.pipeline,_that.htmlContent,_that.storageUrl,_that.localCachePath,_that.prompt,_that.isCached,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentAsset extends DocumentAsset {
  const _DocumentAsset({required this.id, required this.portfolioId, required this.userId, required this.title, required this.type, required this.pipeline, this.htmlContent, this.storageUrl, this.localCachePath, this.prompt, this.isCached = false, required this.createdAt, this.updatedAt}): super._();
  factory _DocumentAsset.fromJson(Map<String, dynamic> json) => _$DocumentAssetFromJson(json);

@override final  String id;
@override final  String portfolioId;
@override final  String userId;
@override final  String title;
@override final  DocumentType type;
@override final  AssetPipeline pipeline;
// Structural pipeline fields
@override final  String? htmlContent;
// Graphical pipeline fields
@override final  String? storageUrl;
// Shared / cache
@override final  String? localCachePath;
// absolute path on device
@override final  String? prompt;
// the original user prompt
@override@JsonKey() final  bool isCached;
@override final  DateTime createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of DocumentAsset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentAssetCopyWith<_DocumentAsset> get copyWith => __$DocumentAssetCopyWithImpl<_DocumentAsset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentAssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentAsset&&(identical(other.id, id) || other.id == id)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.pipeline, pipeline) || other.pipeline == pipeline)&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.storageUrl, storageUrl) || other.storageUrl == storageUrl)&&(identical(other.localCachePath, localCachePath) || other.localCachePath == localCachePath)&&(identical(other.prompt, prompt) || other.prompt == prompt)&&(identical(other.isCached, isCached) || other.isCached == isCached)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,portfolioId,userId,title,type,pipeline,htmlContent,storageUrl,localCachePath,prompt,isCached,createdAt,updatedAt);

@override
String toString() {
  return 'DocumentAsset(id: $id, portfolioId: $portfolioId, userId: $userId, title: $title, type: $type, pipeline: $pipeline, htmlContent: $htmlContent, storageUrl: $storageUrl, localCachePath: $localCachePath, prompt: $prompt, isCached: $isCached, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentAssetCopyWith<$Res> implements $DocumentAssetCopyWith<$Res> {
  factory _$DocumentAssetCopyWith(_DocumentAsset value, $Res Function(_DocumentAsset) _then) = __$DocumentAssetCopyWithImpl;
@override @useResult
$Res call({
 String id, String portfolioId, String userId, String title, DocumentType type, AssetPipeline pipeline, String? htmlContent, String? storageUrl, String? localCachePath, String? prompt, bool isCached, DateTime createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$DocumentAssetCopyWithImpl<$Res>
    implements _$DocumentAssetCopyWith<$Res> {
  __$DocumentAssetCopyWithImpl(this._self, this._then);

  final _DocumentAsset _self;
  final $Res Function(_DocumentAsset) _then;

/// Create a copy of DocumentAsset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? portfolioId = null,Object? userId = null,Object? title = null,Object? type = null,Object? pipeline = null,Object? htmlContent = freezed,Object? storageUrl = freezed,Object? localCachePath = freezed,Object? prompt = freezed,Object? isCached = null,Object? createdAt = null,Object? updatedAt = freezed,}) {
  return _then(_DocumentAsset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as DocumentType,pipeline: null == pipeline ? _self.pipeline : pipeline // ignore: cast_nullable_to_non_nullable
as AssetPipeline,htmlContent: freezed == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String?,storageUrl: freezed == storageUrl ? _self.storageUrl : storageUrl // ignore: cast_nullable_to_non_nullable
as String?,localCachePath: freezed == localCachePath ? _self.localCachePath : localCachePath // ignore: cast_nullable_to_non_nullable
as String?,prompt: freezed == prompt ? _self.prompt : prompt // ignore: cast_nullable_to_non_nullable
as String?,isCached: null == isCached ? _self.isCached : isCached // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
