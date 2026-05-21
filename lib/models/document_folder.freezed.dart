// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'document_folder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DocumentFolder {

 String get id; String get portfolioId; String get name; bool get isAiGenerated; DateTime get createdAt;
/// Create a copy of DocumentFolder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DocumentFolderCopyWith<DocumentFolder> get copyWith => _$DocumentFolderCopyWithImpl<DocumentFolder>(this as DocumentFolder, _$identity);

  /// Serializes this DocumentFolder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DocumentFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isAiGenerated, isAiGenerated) || other.isAiGenerated == isAiGenerated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,portfolioId,name,isAiGenerated,createdAt);

@override
String toString() {
  return 'DocumentFolder(id: $id, portfolioId: $portfolioId, name: $name, isAiGenerated: $isAiGenerated, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $DocumentFolderCopyWith<$Res>  {
  factory $DocumentFolderCopyWith(DocumentFolder value, $Res Function(DocumentFolder) _then) = _$DocumentFolderCopyWithImpl;
@useResult
$Res call({
 String id, String portfolioId, String name, bool isAiGenerated, DateTime createdAt
});




}
/// @nodoc
class _$DocumentFolderCopyWithImpl<$Res>
    implements $DocumentFolderCopyWith<$Res> {
  _$DocumentFolderCopyWithImpl(this._self, this._then);

  final DocumentFolder _self;
  final $Res Function(DocumentFolder) _then;

/// Create a copy of DocumentFolder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? portfolioId = null,Object? name = null,Object? isAiGenerated = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isAiGenerated: null == isAiGenerated ? _self.isAiGenerated : isAiGenerated // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [DocumentFolder].
extension DocumentFolderPatterns on DocumentFolder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DocumentFolder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DocumentFolder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DocumentFolder value)  $default,){
final _that = this;
switch (_that) {
case _DocumentFolder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DocumentFolder value)?  $default,){
final _that = this;
switch (_that) {
case _DocumentFolder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String portfolioId,  String name,  bool isAiGenerated,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DocumentFolder() when $default != null:
return $default(_that.id,_that.portfolioId,_that.name,_that.isAiGenerated,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String portfolioId,  String name,  bool isAiGenerated,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _DocumentFolder():
return $default(_that.id,_that.portfolioId,_that.name,_that.isAiGenerated,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String portfolioId,  String name,  bool isAiGenerated,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _DocumentFolder() when $default != null:
return $default(_that.id,_that.portfolioId,_that.name,_that.isAiGenerated,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DocumentFolder extends DocumentFolder {
  const _DocumentFolder({required this.id, required this.portfolioId, required this.name, this.isAiGenerated = true, required this.createdAt}): super._();
  factory _DocumentFolder.fromJson(Map<String, dynamic> json) => _$DocumentFolderFromJson(json);

@override final  String id;
@override final  String portfolioId;
@override final  String name;
@override@JsonKey() final  bool isAiGenerated;
@override final  DateTime createdAt;

/// Create a copy of DocumentFolder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DocumentFolderCopyWith<_DocumentFolder> get copyWith => __$DocumentFolderCopyWithImpl<_DocumentFolder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DocumentFolderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DocumentFolder&&(identical(other.id, id) || other.id == id)&&(identical(other.portfolioId, portfolioId) || other.portfolioId == portfolioId)&&(identical(other.name, name) || other.name == name)&&(identical(other.isAiGenerated, isAiGenerated) || other.isAiGenerated == isAiGenerated)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,portfolioId,name,isAiGenerated,createdAt);

@override
String toString() {
  return 'DocumentFolder(id: $id, portfolioId: $portfolioId, name: $name, isAiGenerated: $isAiGenerated, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$DocumentFolderCopyWith<$Res> implements $DocumentFolderCopyWith<$Res> {
  factory _$DocumentFolderCopyWith(_DocumentFolder value, $Res Function(_DocumentFolder) _then) = __$DocumentFolderCopyWithImpl;
@override @useResult
$Res call({
 String id, String portfolioId, String name, bool isAiGenerated, DateTime createdAt
});




}
/// @nodoc
class __$DocumentFolderCopyWithImpl<$Res>
    implements _$DocumentFolderCopyWith<$Res> {
  __$DocumentFolderCopyWithImpl(this._self, this._then);

  final _DocumentFolder _self;
  final $Res Function(_DocumentFolder) _then;

/// Create a copy of DocumentFolder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? portfolioId = null,Object? name = null,Object? isAiGenerated = null,Object? createdAt = null,}) {
  return _then(_DocumentFolder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,portfolioId: null == portfolioId ? _self.portfolioId : portfolioId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isAiGenerated: null == isAiGenerated ? _self.isAiGenerated : isAiGenerated // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
