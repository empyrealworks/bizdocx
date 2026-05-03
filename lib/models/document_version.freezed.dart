// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentVersion {

 String get id; String get documentId; String get portfolioId; String get userId;// Content snapshots
 String get htmlContent;// Used for structural
 String? get imageUrl;// Used for graphical
 int get versionNumber; String? get refinementPrompt; String? get label; DateTime get createdAt;
/// Create a copy of DocumentVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentVersionCopyWith<DocumentVersion> get copyWith => _$DocumentVersionCopyWithImpl<DocumentVersion>(this as DocumentVersion, _$identity);

  /// Serializes this DocumentVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.refinementPrompt, refinementPrompt) || other.refinementPrompt == refinementPrompt)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,documentId,portfolioId,userId,htmlContent,imageUrl,versionNumber,refinementPrompt,label,createdAt);

@override
String toString() {
  return 'DocumentVersion(id: $id, documentId: $documentId, portfolioId: $portfolioId, userId: $userId, htmlContent: $htmlContent, imageUrl: $imageUrl, versionNumber: $versionNumber, refinementPrompt: $refinementPrompt, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DocumentVersionCopyWith<$Res>  {
  factory $DocumentVersionCopyWith(DocumentVersion value, $Res Function(DocumentVersion) _then) = _$DocumentVersionCopyWithImpl;
@useResult
$Res call({
 String id, String documentId, String portfolioId, String userId, String htmlContent, String? imageUrl, int versionNumber, String? refinementPrompt, String? label, DateTime createdAt
});




}
/// @nodoc
class _$DocumentVersionCopyWithImpl<$Res>
    implements $DocumentVersionCopyWith<$Res> {
  _$DocumentVersionCopyWithImpl(this._self, this._then);

  final DocumentVersion _self;
  final $Res Function(DocumentVersion) _then;

/// Create a copy of DocumentVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? documentId = null,Object? portfolioId = null,Object? userId = null,Object? htmlContent = null,Object? imageUrl = freezed,Object? versionNumber = null,Object? refinementPrompt = freezed,Object? label = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,htmlContent: null == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,refinementPrompt: freezed == refinementPrompt ? _self.refinementPrompt : refinementPrompt // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentVersion].
extension DocumentVersionPatterns on DocumentVersion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentVersion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentVersion value)  $default,){
final _that = this;
switch (_that) {
case _DocumentVersion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentVersion value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentVersion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String documentId,  String portfolioId,  String userId,  String htmlContent,  String? imageUrl,  int versionNumber,  String? refinementPrompt,  String? label,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentVersion() when $default != null:
return $default(_that.id,_that.documentId,_that.portfolioId,_that.userId,_that.htmlContent,_that.imageUrl,_that.versionNumber,_that.refinementPrompt,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String documentId,  String portfolioId,  String userId,  String htmlContent,  String? imageUrl,  int versionNumber,  String? refinementPrompt,  String? label,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentVersion():
return $default(_that.id,_that.documentId,_that.portfolioId,_that.userId,_that.htmlContent,_that.imageUrl,_that.versionNumber,_that.refinementPrompt,_that.label,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String documentId,  String portfolioId,  String userId,  String htmlContent,  String? imageUrl,  int versionNumber,  String? refinementPrompt,  String? label,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentVersion() when $default != null:
return $default(_that.id,_that.documentId,_that.portfolioId,_that.userId,_that.htmlContent,_that.imageUrl,_that.versionNumber,_that.refinementPrompt,_that.label,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentVersion extends DocumentVersion {
  const _DocumentVersion({required this.id, required this.documentId, required this.portfolioId, required this.userId, this.htmlContent = '', this.imageUrl, required this.versionNumber, this.refinementPrompt, this.label, required this.createdAt}): super._();
  factory _DocumentVersion.fromJson(Map<String, dynamic> json) => _$DocumentVersionFromJson(json);

@override final  String id;
@override final  String documentId;
@override final  String portfolioId;
@override final  String userId;
// Content snapshots
@override@JsonKey() final  String htmlContent;
// Used for structural
@override final  String? imageUrl;
// Used for graphical
@override final  int versionNumber;
@override final  String? refinementPrompt;
@override final  String? label;
@override final  DateTime createdAt;

/// Create a copy of DocumentVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentVersionCopyWith<_DocumentVersion> get copyWith => __$DocumentVersionCopyWithImpl<_DocumentVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentVersion&&(identical(other.id, id) || other.id == id)&&(identical(other.documentId, documentId) || other.documentId == documentId)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.htmlContent, htmlContent) || other.htmlContent == htmlContent)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.versionNumber, versionNumber) || other.versionNumber == versionNumber)&&(identical(other.refinementPrompt, refinementPrompt) || other.refinementPrompt == refinementPrompt)&&(identical(other.label, label) || other.label == label)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,documentId,portfolioId,userId,htmlContent,imageUrl,versionNumber,refinementPrompt,label,createdAt);

@override
String toString() {
  return 'DocumentVersion(id: $id, documentId: $documentId, portfolioId: $portfolioId, userId: $userId, htmlContent: $htmlContent, imageUrl: $imageUrl, versionNumber: $versionNumber, refinementPrompt: $refinementPrompt, label: $label, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentVersionCopyWith<$Res> implements $DocumentVersionCopyWith<$Res> {
  factory _$DocumentVersionCopyWith(_DocumentVersion value, $Res Function(_DocumentVersion) _then) = __$DocumentVersionCopyWithImpl;
@override @useResult
$Res call({
 String id, String documentId, String portfolioId, String userId, String htmlContent, String? imageUrl, int versionNumber, String? refinementPrompt, String? label, DateTime createdAt
});




}
/// @nodoc
class __$DocumentVersionCopyWithImpl<$Res>
    implements _$DocumentVersionCopyWith<$Res> {
  __$DocumentVersionCopyWithImpl(this._self, this._then);

  final _DocumentVersion _self;
  final $Res Function(_DocumentVersion) _then;

/// Create a copy of DocumentVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? documentId = null,Object? portfolioId = null,Object? userId = null,Object? htmlContent = null,Object? imageUrl = freezed,Object? versionNumber = null,Object? refinementPrompt = freezed,Object? label = freezed,Object? createdAt = null,}) {
  return _then(_DocumentVersion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,documentId: null == documentId ? _self.documentId : documentId // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,htmlContent: null == htmlContent ? _self.htmlContent : htmlContent // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,versionNumber: null == versionNumber ? _self.versionNumber : versionNumber // ignore: cast_nullable_to_non_nullable
as int,refinementPrompt: freezed == refinementPrompt ? _self.refinementPrompt : refinementPrompt // ignore: cast_nullable_to_non_nullable
as String?,label: freezed == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
