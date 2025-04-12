// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtistEntity {

 String? get id; String? get name; String? get coverArt; int? get albumCount; String? get artistImageUrl; List<AlbumEntity>? get album;
/// Create a copy of ArtistEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistEntityCopyWith<ArtistEntity> get copyWith => _$ArtistEntityCopyWithImpl<ArtistEntity>(this as ArtistEntity, _$identity);

  /// Serializes this ArtistEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount)&&(identical(other.artistImageUrl, artistImageUrl) || other.artistImageUrl == artistImageUrl)&&const DeepCollectionEquality().equals(other.album, album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverArt,albumCount,artistImageUrl,const DeepCollectionEquality().hash(album));

@override
String toString() {
  return 'ArtistEntity(id: $id, name: $name, coverArt: $coverArt, albumCount: $albumCount, artistImageUrl: $artistImageUrl, album: $album)';
}


}

/// @nodoc
abstract mixin class $ArtistEntityCopyWith<$Res>  {
  factory $ArtistEntityCopyWith(ArtistEntity value, $Res Function(ArtistEntity) _then) = _$ArtistEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? coverArt, int? albumCount, String? artistImageUrl, List<AlbumEntity>? album
});




}
/// @nodoc
class _$ArtistEntityCopyWithImpl<$Res>
    implements $ArtistEntityCopyWith<$Res> {
  _$ArtistEntityCopyWithImpl(this._self, this._then);

  final ArtistEntity _self;
  final $Res Function(ArtistEntity) _then;

/// Create a copy of ArtistEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? coverArt = freezed,Object? albumCount = freezed,Object? artistImageUrl = freezed,Object? album = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,albumCount: freezed == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int?,artistImageUrl: freezed == artistImageUrl ? _self.artistImageUrl : artistImageUrl // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ArtistEntity implements ArtistEntity {
  const _ArtistEntity({this.id, this.name, this.coverArt, this.albumCount, this.artistImageUrl, final  List<AlbumEntity>? album}): _album = album;
  factory _ArtistEntity.fromJson(Map<String, dynamic> json) => _$ArtistEntityFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? coverArt;
@override final  int? albumCount;
@override final  String? artistImageUrl;
 final  List<AlbumEntity>? _album;
@override List<AlbumEntity>? get album {
  final value = _album;
  if (value == null) return null;
  if (_album is EqualUnmodifiableListView) return _album;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ArtistEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistEntityCopyWith<_ArtistEntity> get copyWith => __$ArtistEntityCopyWithImpl<_ArtistEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount)&&(identical(other.artistImageUrl, artistImageUrl) || other.artistImageUrl == artistImageUrl)&&const DeepCollectionEquality().equals(other._album, _album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,coverArt,albumCount,artistImageUrl,const DeepCollectionEquality().hash(_album));

@override
String toString() {
  return 'ArtistEntity(id: $id, name: $name, coverArt: $coverArt, albumCount: $albumCount, artistImageUrl: $artistImageUrl, album: $album)';
}


}

/// @nodoc
abstract mixin class _$ArtistEntityCopyWith<$Res> implements $ArtistEntityCopyWith<$Res> {
  factory _$ArtistEntityCopyWith(_ArtistEntity value, $Res Function(_ArtistEntity) _then) = __$ArtistEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? coverArt, int? albumCount, String? artistImageUrl, List<AlbumEntity>? album
});




}
/// @nodoc
class __$ArtistEntityCopyWithImpl<$Res>
    implements _$ArtistEntityCopyWith<$Res> {
  __$ArtistEntityCopyWithImpl(this._self, this._then);

  final _ArtistEntity _self;
  final $Res Function(_ArtistEntity) _then;

/// Create a copy of ArtistEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? coverArt = freezed,Object? albumCount = freezed,Object? artistImageUrl = freezed,Object? album = freezed,}) {
  return _then(_ArtistEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,albumCount: freezed == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int?,artistImageUrl: freezed == artistImageUrl ? _self.artistImageUrl : artistImageUrl // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self._album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}


}

// dart format on
