// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playlist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlaylistEntity {

 String? get id; String? get name; String? get comment; int? get songCount; int? get duration; bool? get public; String? get owner; DateTime? get created; DateTime? get changed; String? get coverArt; List<SongEntity>? get entry;
/// Create a copy of PlaylistEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistEntityCopyWith<PlaylistEntity> get copyWith => _$PlaylistEntityCopyWithImpl<PlaylistEntity>(this as PlaylistEntity, _$identity);

  /// Serializes this PlaylistEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.public, public) || other.public == public)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.created, created) || other.created == created)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&const DeepCollectionEquality().equals(other.entry, entry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,comment,songCount,duration,public,owner,created,changed,coverArt,const DeepCollectionEquality().hash(entry));

@override
String toString() {
  return 'PlaylistEntity(id: $id, name: $name, comment: $comment, songCount: $songCount, duration: $duration, public: $public, owner: $owner, created: $created, changed: $changed, coverArt: $coverArt, entry: $entry)';
}


}

/// @nodoc
abstract mixin class $PlaylistEntityCopyWith<$Res>  {
  factory $PlaylistEntityCopyWith(PlaylistEntity value, $Res Function(PlaylistEntity) _then) = _$PlaylistEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? comment, int? songCount, int? duration, bool? public, String? owner, DateTime? created, DateTime? changed, String? coverArt, List<SongEntity>? entry
});




}
/// @nodoc
class _$PlaylistEntityCopyWithImpl<$Res>
    implements $PlaylistEntityCopyWith<$Res> {
  _$PlaylistEntityCopyWithImpl(this._self, this._then);

  final PlaylistEntity _self;
  final $Res Function(PlaylistEntity) _then;

/// Create a copy of PlaylistEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? comment = freezed,Object? songCount = freezed,Object? duration = freezed,Object? public = freezed,Object? owner = freezed,Object? created = freezed,Object? changed = freezed,Object? coverArt = freezed,Object? entry = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,public: freezed == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as DateTime?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlaylistEntity implements PlaylistEntity {
  const _PlaylistEntity({this.id, this.name, this.comment, this.songCount, this.duration, this.public, this.owner, this.created, this.changed, this.coverArt, final  List<SongEntity>? entry}): _entry = entry;
  factory _PlaylistEntity.fromJson(Map<String, dynamic> json) => _$PlaylistEntityFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? comment;
@override final  int? songCount;
@override final  int? duration;
@override final  bool? public;
@override final  String? owner;
@override final  DateTime? created;
@override final  DateTime? changed;
@override final  String? coverArt;
 final  List<SongEntity>? _entry;
@override List<SongEntity>? get entry {
  final value = _entry;
  if (value == null) return null;
  if (_entry is EqualUnmodifiableListView) return _entry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PlaylistEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaylistEntityCopyWith<_PlaylistEntity> get copyWith => __$PlaylistEntityCopyWithImpl<_PlaylistEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaylistEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaylistEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.public, public) || other.public == public)&&(identical(other.owner, owner) || other.owner == owner)&&(identical(other.created, created) || other.created == created)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&const DeepCollectionEquality().equals(other._entry, _entry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,comment,songCount,duration,public,owner,created,changed,coverArt,const DeepCollectionEquality().hash(_entry));

@override
String toString() {
  return 'PlaylistEntity(id: $id, name: $name, comment: $comment, songCount: $songCount, duration: $duration, public: $public, owner: $owner, created: $created, changed: $changed, coverArt: $coverArt, entry: $entry)';
}


}

/// @nodoc
abstract mixin class _$PlaylistEntityCopyWith<$Res> implements $PlaylistEntityCopyWith<$Res> {
  factory _$PlaylistEntityCopyWith(_PlaylistEntity value, $Res Function(_PlaylistEntity) _then) = __$PlaylistEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? comment, int? songCount, int? duration, bool? public, String? owner, DateTime? created, DateTime? changed, String? coverArt, List<SongEntity>? entry
});




}
/// @nodoc
class __$PlaylistEntityCopyWithImpl<$Res>
    implements _$PlaylistEntityCopyWith<$Res> {
  __$PlaylistEntityCopyWithImpl(this._self, this._then);

  final _PlaylistEntity _self;
  final $Res Function(_PlaylistEntity) _then;

/// Create a copy of PlaylistEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? comment = freezed,Object? songCount = freezed,Object? duration = freezed,Object? public = freezed,Object? owner = freezed,Object? created = freezed,Object? changed = freezed,Object? coverArt = freezed,Object? entry = freezed,}) {
  return _then(_PlaylistEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,public: freezed == public ? _self.public : public // ignore: cast_nullable_to_non_nullable
as bool?,owner: freezed == owner ? _self.owner : owner // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as DateTime?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,entry: freezed == entry ? _self._entry : entry // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}


}


/// @nodoc
mixin _$PlaylistsEntity {

 List<PlaylistEntity>? get playlist;
/// Create a copy of PlaylistsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaylistsEntityCopyWith<PlaylistsEntity> get copyWith => _$PlaylistsEntityCopyWithImpl<PlaylistsEntity>(this as PlaylistsEntity, _$identity);

  /// Serializes this PlaylistsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaylistsEntity&&const DeepCollectionEquality().equals(other.playlist, playlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(playlist));

@override
String toString() {
  return 'PlaylistsEntity(playlist: $playlist)';
}


}

/// @nodoc
abstract mixin class $PlaylistsEntityCopyWith<$Res>  {
  factory $PlaylistsEntityCopyWith(PlaylistsEntity value, $Res Function(PlaylistsEntity) _then) = _$PlaylistsEntityCopyWithImpl;
@useResult
$Res call({
 List<PlaylistEntity>? playlist
});




}
/// @nodoc
class _$PlaylistsEntityCopyWithImpl<$Res>
    implements $PlaylistsEntityCopyWith<$Res> {
  _$PlaylistsEntityCopyWithImpl(this._self, this._then);

  final PlaylistsEntity _self;
  final $Res Function(PlaylistsEntity) _then;

/// Create a copy of PlaylistsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playlist = freezed,}) {
  return _then(_self.copyWith(
playlist: freezed == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as List<PlaylistEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlaylistsEntity implements PlaylistsEntity {
  const _PlaylistsEntity({final  List<PlaylistEntity>? playlist}): _playlist = playlist;
  factory _PlaylistsEntity.fromJson(Map<String, dynamic> json) => _$PlaylistsEntityFromJson(json);

 final  List<PlaylistEntity>? _playlist;
@override List<PlaylistEntity>? get playlist {
  final value = _playlist;
  if (value == null) return null;
  if (_playlist is EqualUnmodifiableListView) return _playlist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of PlaylistsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaylistsEntityCopyWith<_PlaylistsEntity> get copyWith => __$PlaylistsEntityCopyWithImpl<_PlaylistsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaylistsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaylistsEntity&&const DeepCollectionEquality().equals(other._playlist, _playlist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_playlist));

@override
String toString() {
  return 'PlaylistsEntity(playlist: $playlist)';
}


}

/// @nodoc
abstract mixin class _$PlaylistsEntityCopyWith<$Res> implements $PlaylistsEntityCopyWith<$Res> {
  factory _$PlaylistsEntityCopyWith(_PlaylistsEntity value, $Res Function(_PlaylistsEntity) _then) = __$PlaylistsEntityCopyWithImpl;
@override @useResult
$Res call({
 List<PlaylistEntity>? playlist
});




}
/// @nodoc
class __$PlaylistsEntityCopyWithImpl<$Res>
    implements _$PlaylistsEntityCopyWith<$Res> {
  __$PlaylistsEntityCopyWithImpl(this._self, this._then);

  final _PlaylistsEntity _self;
  final $Res Function(_PlaylistsEntity) _then;

/// Create a copy of PlaylistsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playlist = freezed,}) {
  return _then(_PlaylistsEntity(
playlist: freezed == playlist ? _self._playlist : playlist // ignore: cast_nullable_to_non_nullable
as List<PlaylistEntity>?,
  ));
}


}

// dart format on
