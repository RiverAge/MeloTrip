// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_index.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtistsEntity {

 List<ArtistIndexBucketEntity>? get index;
/// Create a copy of ArtistsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistsEntityCopyWith<ArtistsEntity> get copyWith => _$ArtistsEntityCopyWithImpl<ArtistsEntity>(this as ArtistsEntity, _$identity);

  /// Serializes this ArtistsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistsEntity&&const DeepCollectionEquality().equals(other.index, index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(index));

@override
String toString() {
  return 'ArtistsEntity(index: $index)';
}


}

/// @nodoc
abstract mixin class $ArtistsEntityCopyWith<$Res>  {
  factory $ArtistsEntityCopyWith(ArtistsEntity value, $Res Function(ArtistsEntity) _then) = _$ArtistsEntityCopyWithImpl;
@useResult
$Res call({
 List<ArtistIndexBucketEntity>? index
});




}
/// @nodoc
class _$ArtistsEntityCopyWithImpl<$Res>
    implements $ArtistsEntityCopyWith<$Res> {
  _$ArtistsEntityCopyWithImpl(this._self, this._then);

  final ArtistsEntity _self;
  final $Res Function(ArtistsEntity) _then;

/// Create a copy of ArtistsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,}) {
  return _then(_self.copyWith(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as List<ArtistIndexBucketEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistsEntity].
extension ArtistsEntityPatterns on ArtistsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistsEntity value)  $default,){
final _that = this;
switch (_that) {
case _ArtistsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistsEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ArtistIndexBucketEntity>? index)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistsEntity() when $default != null:
return $default(_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ArtistIndexBucketEntity>? index)  $default,) {final _that = this;
switch (_that) {
case _ArtistsEntity():
return $default(_that.index);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ArtistIndexBucketEntity>? index)?  $default,) {final _that = this;
switch (_that) {
case _ArtistsEntity() when $default != null:
return $default(_that.index);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistsEntity implements ArtistsEntity {
  const _ArtistsEntity({final  List<ArtistIndexBucketEntity>? index}): _index = index;
  factory _ArtistsEntity.fromJson(Map<String, dynamic> json) => _$ArtistsEntityFromJson(json);

 final  List<ArtistIndexBucketEntity>? _index;
@override List<ArtistIndexBucketEntity>? get index {
  final value = _index;
  if (value == null) return null;
  if (_index is EqualUnmodifiableListView) return _index;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ArtistsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistsEntityCopyWith<_ArtistsEntity> get copyWith => __$ArtistsEntityCopyWithImpl<_ArtistsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistsEntity&&const DeepCollectionEquality().equals(other._index, _index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_index));

@override
String toString() {
  return 'ArtistsEntity(index: $index)';
}


}

/// @nodoc
abstract mixin class _$ArtistsEntityCopyWith<$Res> implements $ArtistsEntityCopyWith<$Res> {
  factory _$ArtistsEntityCopyWith(_ArtistsEntity value, $Res Function(_ArtistsEntity) _then) = __$ArtistsEntityCopyWithImpl;
@override @useResult
$Res call({
 List<ArtistIndexBucketEntity>? index
});




}
/// @nodoc
class __$ArtistsEntityCopyWithImpl<$Res>
    implements _$ArtistsEntityCopyWith<$Res> {
  __$ArtistsEntityCopyWithImpl(this._self, this._then);

  final _ArtistsEntity _self;
  final $Res Function(_ArtistsEntity) _then;

/// Create a copy of ArtistsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,}) {
  return _then(_ArtistsEntity(
index: freezed == index ? _self._index : index // ignore: cast_nullable_to_non_nullable
as List<ArtistIndexBucketEntity>?,
  ));
}


}


/// @nodoc
mixin _$ArtistIndexBucketEntity {

 String? get name; List<ArtistEntity>? get artist;
/// Create a copy of ArtistIndexBucketEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistIndexBucketEntityCopyWith<ArtistIndexBucketEntity> get copyWith => _$ArtistIndexBucketEntityCopyWithImpl<ArtistIndexBucketEntity>(this as ArtistIndexBucketEntity, _$identity);

  /// Serializes this ArtistIndexBucketEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistIndexBucketEntity&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.artist, artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(artist));

@override
String toString() {
  return 'ArtistIndexBucketEntity(name: $name, artist: $artist)';
}


}

/// @nodoc
abstract mixin class $ArtistIndexBucketEntityCopyWith<$Res>  {
  factory $ArtistIndexBucketEntityCopyWith(ArtistIndexBucketEntity value, $Res Function(ArtistIndexBucketEntity) _then) = _$ArtistIndexBucketEntityCopyWithImpl;
@useResult
$Res call({
 String? name, List<ArtistEntity>? artist
});




}
/// @nodoc
class _$ArtistIndexBucketEntityCopyWithImpl<$Res>
    implements $ArtistIndexBucketEntityCopyWith<$Res> {
  _$ArtistIndexBucketEntityCopyWithImpl(this._self, this._then);

  final ArtistIndexBucketEntity _self;
  final $Res Function(ArtistIndexBucketEntity) _then;

/// Create a copy of ArtistIndexBucketEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,Object? artist = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistIndexBucketEntity].
extension ArtistIndexBucketEntityPatterns on ArtistIndexBucketEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistIndexBucketEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistIndexBucketEntity value)  $default,){
final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistIndexBucketEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? name,  List<ArtistEntity>? artist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity() when $default != null:
return $default(_that.name,_that.artist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? name,  List<ArtistEntity>? artist)  $default,) {final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity():
return $default(_that.name,_that.artist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? name,  List<ArtistEntity>? artist)?  $default,) {final _that = this;
switch (_that) {
case _ArtistIndexBucketEntity() when $default != null:
return $default(_that.name,_that.artist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistIndexBucketEntity implements ArtistIndexBucketEntity {
  const _ArtistIndexBucketEntity({this.name, final  List<ArtistEntity>? artist}): _artist = artist;
  factory _ArtistIndexBucketEntity.fromJson(Map<String, dynamic> json) => _$ArtistIndexBucketEntityFromJson(json);

@override final  String? name;
 final  List<ArtistEntity>? _artist;
@override List<ArtistEntity>? get artist {
  final value = _artist;
  if (value == null) return null;
  if (_artist is EqualUnmodifiableListView) return _artist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ArtistIndexBucketEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistIndexBucketEntityCopyWith<_ArtistIndexBucketEntity> get copyWith => __$ArtistIndexBucketEntityCopyWithImpl<_ArtistIndexBucketEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistIndexBucketEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistIndexBucketEntity&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._artist, _artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,const DeepCollectionEquality().hash(_artist));

@override
String toString() {
  return 'ArtistIndexBucketEntity(name: $name, artist: $artist)';
}


}

/// @nodoc
abstract mixin class _$ArtistIndexBucketEntityCopyWith<$Res> implements $ArtistIndexBucketEntityCopyWith<$Res> {
  factory _$ArtistIndexBucketEntityCopyWith(_ArtistIndexBucketEntity value, $Res Function(_ArtistIndexBucketEntity) _then) = __$ArtistIndexBucketEntityCopyWithImpl;
@override @useResult
$Res call({
 String? name, List<ArtistEntity>? artist
});




}
/// @nodoc
class __$ArtistIndexBucketEntityCopyWithImpl<$Res>
    implements _$ArtistIndexBucketEntityCopyWith<$Res> {
  __$ArtistIndexBucketEntityCopyWithImpl(this._self, this._then);

  final _ArtistIndexBucketEntity _self;
  final $Res Function(_ArtistIndexBucketEntity) _then;

/// Create a copy of ArtistIndexBucketEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,Object? artist = freezed,}) {
  return _then(_ArtistIndexBucketEntity(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self._artist : artist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}


}


/// @nodoc
mixin _$IndexesEntity {

 String? get lastModified; List<ArtistIndexBucketEntity>? get index;
/// Create a copy of IndexesEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IndexesEntityCopyWith<IndexesEntity> get copyWith => _$IndexesEntityCopyWithImpl<IndexesEntity>(this as IndexesEntity, _$identity);

  /// Serializes this IndexesEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IndexesEntity&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&const DeepCollectionEquality().equals(other.index, index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastModified,const DeepCollectionEquality().hash(index));

@override
String toString() {
  return 'IndexesEntity(lastModified: $lastModified, index: $index)';
}


}

/// @nodoc
abstract mixin class $IndexesEntityCopyWith<$Res>  {
  factory $IndexesEntityCopyWith(IndexesEntity value, $Res Function(IndexesEntity) _then) = _$IndexesEntityCopyWithImpl;
@useResult
$Res call({
 String? lastModified, List<ArtistIndexBucketEntity>? index
});




}
/// @nodoc
class _$IndexesEntityCopyWithImpl<$Res>
    implements $IndexesEntityCopyWith<$Res> {
  _$IndexesEntityCopyWithImpl(this._self, this._then);

  final IndexesEntity _self;
  final $Res Function(IndexesEntity) _then;

/// Create a copy of IndexesEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lastModified = freezed,Object? index = freezed,}) {
  return _then(_self.copyWith(
lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as List<ArtistIndexBucketEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [IndexesEntity].
extension IndexesEntityPatterns on IndexesEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IndexesEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IndexesEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IndexesEntity value)  $default,){
final _that = this;
switch (_that) {
case _IndexesEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IndexesEntity value)?  $default,){
final _that = this;
switch (_that) {
case _IndexesEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? lastModified,  List<ArtistIndexBucketEntity>? index)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IndexesEntity() when $default != null:
return $default(_that.lastModified,_that.index);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? lastModified,  List<ArtistIndexBucketEntity>? index)  $default,) {final _that = this;
switch (_that) {
case _IndexesEntity():
return $default(_that.lastModified,_that.index);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? lastModified,  List<ArtistIndexBucketEntity>? index)?  $default,) {final _that = this;
switch (_that) {
case _IndexesEntity() when $default != null:
return $default(_that.lastModified,_that.index);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IndexesEntity implements IndexesEntity {
  const _IndexesEntity({this.lastModified, final  List<ArtistIndexBucketEntity>? index}): _index = index;
  factory _IndexesEntity.fromJson(Map<String, dynamic> json) => _$IndexesEntityFromJson(json);

@override final  String? lastModified;
 final  List<ArtistIndexBucketEntity>? _index;
@override List<ArtistIndexBucketEntity>? get index {
  final value = _index;
  if (value == null) return null;
  if (_index is EqualUnmodifiableListView) return _index;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of IndexesEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IndexesEntityCopyWith<_IndexesEntity> get copyWith => __$IndexesEntityCopyWithImpl<_IndexesEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IndexesEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IndexesEntity&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&const DeepCollectionEquality().equals(other._index, _index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lastModified,const DeepCollectionEquality().hash(_index));

@override
String toString() {
  return 'IndexesEntity(lastModified: $lastModified, index: $index)';
}


}

/// @nodoc
abstract mixin class _$IndexesEntityCopyWith<$Res> implements $IndexesEntityCopyWith<$Res> {
  factory _$IndexesEntityCopyWith(_IndexesEntity value, $Res Function(_IndexesEntity) _then) = __$IndexesEntityCopyWithImpl;
@override @useResult
$Res call({
 String? lastModified, List<ArtistIndexBucketEntity>? index
});




}
/// @nodoc
class __$IndexesEntityCopyWithImpl<$Res>
    implements _$IndexesEntityCopyWith<$Res> {
  __$IndexesEntityCopyWithImpl(this._self, this._then);

  final _IndexesEntity _self;
  final $Res Function(_IndexesEntity) _then;

/// Create a copy of IndexesEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lastModified = freezed,Object? index = freezed,}) {
  return _then(_IndexesEntity(
lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as String?,index: freezed == index ? _self._index : index // ignore: cast_nullable_to_non_nullable
as List<ArtistIndexBucketEntity>?,
  ));
}


}


/// @nodoc
mixin _$DirectoryEntity {

 String? get id; String? get parent; String? get name; String? get title; List<DirectoryChildEntity>? get child;
/// Create a copy of DirectoryEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectoryEntityCopyWith<DirectoryEntity> get copyWith => _$DirectoryEntityCopyWithImpl<DirectoryEntity>(this as DirectoryEntity, _$identity);

  /// Serializes this DirectoryEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.child, child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parent,name,title,const DeepCollectionEquality().hash(child));

@override
String toString() {
  return 'DirectoryEntity(id: $id, parent: $parent, name: $name, title: $title, child: $child)';
}


}

/// @nodoc
abstract mixin class $DirectoryEntityCopyWith<$Res>  {
  factory $DirectoryEntityCopyWith(DirectoryEntity value, $Res Function(DirectoryEntity) _then) = _$DirectoryEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? parent, String? name, String? title, List<DirectoryChildEntity>? child
});




}
/// @nodoc
class _$DirectoryEntityCopyWithImpl<$Res>
    implements $DirectoryEntityCopyWith<$Res> {
  _$DirectoryEntityCopyWithImpl(this._self, this._then);

  final DirectoryEntity _self;
  final $Res Function(DirectoryEntity) _then;

/// Create a copy of DirectoryEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? parent = freezed,Object? name = freezed,Object? title = freezed,Object? child = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self.child : child // ignore: cast_nullable_to_non_nullable
as List<DirectoryChildEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectoryEntity].
extension DirectoryEntityPatterns on DirectoryEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectoryEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectoryEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectoryEntity value)  $default,){
final _that = this;
switch (_that) {
case _DirectoryEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectoryEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DirectoryEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? parent,  String? name,  String? title,  List<DirectoryChildEntity>? child)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectoryEntity() when $default != null:
return $default(_that.id,_that.parent,_that.name,_that.title,_that.child);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? parent,  String? name,  String? title,  List<DirectoryChildEntity>? child)  $default,) {final _that = this;
switch (_that) {
case _DirectoryEntity():
return $default(_that.id,_that.parent,_that.name,_that.title,_that.child);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? parent,  String? name,  String? title,  List<DirectoryChildEntity>? child)?  $default,) {final _that = this;
switch (_that) {
case _DirectoryEntity() when $default != null:
return $default(_that.id,_that.parent,_that.name,_that.title,_that.child);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DirectoryEntity implements DirectoryEntity {
  const _DirectoryEntity({this.id, this.parent, this.name, this.title, final  List<DirectoryChildEntity>? child}): _child = child;
  factory _DirectoryEntity.fromJson(Map<String, dynamic> json) => _$DirectoryEntityFromJson(json);

@override final  String? id;
@override final  String? parent;
@override final  String? name;
@override final  String? title;
 final  List<DirectoryChildEntity>? _child;
@override List<DirectoryChildEntity>? get child {
  final value = _child;
  if (value == null) return null;
  if (_child is EqualUnmodifiableListView) return _child;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of DirectoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectoryEntityCopyWith<_DirectoryEntity> get copyWith => __$DirectoryEntityCopyWithImpl<_DirectoryEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DirectoryEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectoryEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.name, name) || other.name == name)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._child, _child));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parent,name,title,const DeepCollectionEquality().hash(_child));

@override
String toString() {
  return 'DirectoryEntity(id: $id, parent: $parent, name: $name, title: $title, child: $child)';
}


}

/// @nodoc
abstract mixin class _$DirectoryEntityCopyWith<$Res> implements $DirectoryEntityCopyWith<$Res> {
  factory _$DirectoryEntityCopyWith(_DirectoryEntity value, $Res Function(_DirectoryEntity) _then) = __$DirectoryEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? parent, String? name, String? title, List<DirectoryChildEntity>? child
});




}
/// @nodoc
class __$DirectoryEntityCopyWithImpl<$Res>
    implements _$DirectoryEntityCopyWith<$Res> {
  __$DirectoryEntityCopyWithImpl(this._self, this._then);

  final _DirectoryEntity _self;
  final $Res Function(_DirectoryEntity) _then;

/// Create a copy of DirectoryEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? parent = freezed,Object? name = freezed,Object? title = freezed,Object? child = freezed,}) {
  return _then(_DirectoryEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,child: freezed == child ? _self._child : child // ignore: cast_nullable_to_non_nullable
as List<DirectoryChildEntity>?,
  ));
}


}


/// @nodoc
mixin _$DirectoryChildEntity {

 String? get id; String? get parent; bool? get isDir; String? get title; String? get name; String? get album; String? get genre; int? get year; int? get duration; String? get coverArt; String? get artist;
/// Create a copy of DirectoryChildEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DirectoryChildEntityCopyWith<DirectoryChildEntity> get copyWith => _$DirectoryChildEntityCopyWithImpl<DirectoryChildEntity>(this as DirectoryChildEntity, _$identity);

  /// Serializes this DirectoryChildEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DirectoryChildEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.album, album) || other.album == album)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.year, year) || other.year == year)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.artist, artist) || other.artist == artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parent,isDir,title,name,album,genre,year,duration,coverArt,artist);

@override
String toString() {
  return 'DirectoryChildEntity(id: $id, parent: $parent, isDir: $isDir, title: $title, name: $name, album: $album, genre: $genre, year: $year, duration: $duration, coverArt: $coverArt, artist: $artist)';
}


}

/// @nodoc
abstract mixin class $DirectoryChildEntityCopyWith<$Res>  {
  factory $DirectoryChildEntityCopyWith(DirectoryChildEntity value, $Res Function(DirectoryChildEntity) _then) = _$DirectoryChildEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? parent, bool? isDir, String? title, String? name, String? album, String? genre, int? year, int? duration, String? coverArt, String? artist
});




}
/// @nodoc
class _$DirectoryChildEntityCopyWithImpl<$Res>
    implements $DirectoryChildEntityCopyWith<$Res> {
  _$DirectoryChildEntityCopyWithImpl(this._self, this._then);

  final DirectoryChildEntity _self;
  final $Res Function(DirectoryChildEntity) _then;

/// Create a copy of DirectoryChildEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? parent = freezed,Object? isDir = freezed,Object? title = freezed,Object? name = freezed,Object? album = freezed,Object? genre = freezed,Object? year = freezed,Object? duration = freezed,Object? coverArt = freezed,Object? artist = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,isDir: freezed == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DirectoryChildEntity].
extension DirectoryChildEntityPatterns on DirectoryChildEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DirectoryChildEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DirectoryChildEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DirectoryChildEntity value)  $default,){
final _that = this;
switch (_that) {
case _DirectoryChildEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DirectoryChildEntity value)?  $default,){
final _that = this;
switch (_that) {
case _DirectoryChildEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? parent,  bool? isDir,  String? title,  String? name,  String? album,  String? genre,  int? year,  int? duration,  String? coverArt,  String? artist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DirectoryChildEntity() when $default != null:
return $default(_that.id,_that.parent,_that.isDir,_that.title,_that.name,_that.album,_that.genre,_that.year,_that.duration,_that.coverArt,_that.artist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? parent,  bool? isDir,  String? title,  String? name,  String? album,  String? genre,  int? year,  int? duration,  String? coverArt,  String? artist)  $default,) {final _that = this;
switch (_that) {
case _DirectoryChildEntity():
return $default(_that.id,_that.parent,_that.isDir,_that.title,_that.name,_that.album,_that.genre,_that.year,_that.duration,_that.coverArt,_that.artist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? parent,  bool? isDir,  String? title,  String? name,  String? album,  String? genre,  int? year,  int? duration,  String? coverArt,  String? artist)?  $default,) {final _that = this;
switch (_that) {
case _DirectoryChildEntity() when $default != null:
return $default(_that.id,_that.parent,_that.isDir,_that.title,_that.name,_that.album,_that.genre,_that.year,_that.duration,_that.coverArt,_that.artist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DirectoryChildEntity implements DirectoryChildEntity {
  const _DirectoryChildEntity({this.id, this.parent, this.isDir, this.title, this.name, this.album, this.genre, this.year, this.duration, this.coverArt, this.artist});
  factory _DirectoryChildEntity.fromJson(Map<String, dynamic> json) => _$DirectoryChildEntityFromJson(json);

@override final  String? id;
@override final  String? parent;
@override final  bool? isDir;
@override final  String? title;
@override final  String? name;
@override final  String? album;
@override final  String? genre;
@override final  int? year;
@override final  int? duration;
@override final  String? coverArt;
@override final  String? artist;

/// Create a copy of DirectoryChildEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DirectoryChildEntityCopyWith<_DirectoryChildEntity> get copyWith => __$DirectoryChildEntityCopyWithImpl<_DirectoryChildEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DirectoryChildEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DirectoryChildEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.title, title) || other.title == title)&&(identical(other.name, name) || other.name == name)&&(identical(other.album, album) || other.album == album)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.year, year) || other.year == year)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.artist, artist) || other.artist == artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parent,isDir,title,name,album,genre,year,duration,coverArt,artist);

@override
String toString() {
  return 'DirectoryChildEntity(id: $id, parent: $parent, isDir: $isDir, title: $title, name: $name, album: $album, genre: $genre, year: $year, duration: $duration, coverArt: $coverArt, artist: $artist)';
}


}

/// @nodoc
abstract mixin class _$DirectoryChildEntityCopyWith<$Res> implements $DirectoryChildEntityCopyWith<$Res> {
  factory _$DirectoryChildEntityCopyWith(_DirectoryChildEntity value, $Res Function(_DirectoryChildEntity) _then) = __$DirectoryChildEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? parent, bool? isDir, String? title, String? name, String? album, String? genre, int? year, int? duration, String? coverArt, String? artist
});




}
/// @nodoc
class __$DirectoryChildEntityCopyWithImpl<$Res>
    implements _$DirectoryChildEntityCopyWith<$Res> {
  __$DirectoryChildEntityCopyWithImpl(this._self, this._then);

  final _DirectoryChildEntity _self;
  final $Res Function(_DirectoryChildEntity) _then;

/// Create a copy of DirectoryChildEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? parent = freezed,Object? isDir = freezed,Object? title = freezed,Object? name = freezed,Object? album = freezed,Object? genre = freezed,Object? year = freezed,Object? duration = freezed,Object? coverArt = freezed,Object? artist = freezed,}) {
  return _then(_DirectoryChildEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,isDir: freezed == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
