// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayQueue {

 List<SongEntity> get songs; int get index;
/// Create a copy of PlayQueue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayQueueCopyWith<PlayQueue> get copyWith => _$PlayQueueCopyWithImpl<PlayQueue>(this as PlayQueue, _$identity);

  /// Serializes this PlayQueue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayQueue&&const DeepCollectionEquality().equals(other.songs, songs)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(songs),index);

@override
String toString() {
  return 'PlayQueue(songs: $songs, index: $index)';
}


}

/// @nodoc
abstract mixin class $PlayQueueCopyWith<$Res>  {
  factory $PlayQueueCopyWith(PlayQueue value, $Res Function(PlayQueue) _then) = _$PlayQueueCopyWithImpl;
@useResult
$Res call({
 List<SongEntity> songs, int index
});




}
/// @nodoc
class _$PlayQueueCopyWithImpl<$Res>
    implements $PlayQueueCopyWith<$Res> {
  _$PlayQueueCopyWithImpl(this._self, this._then);

  final PlayQueue _self;
  final $Res Function(PlayQueue) _then;

/// Create a copy of PlayQueue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? songs = null,Object? index = null,}) {
  return _then(_self.copyWith(
songs: null == songs ? _self.songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongEntity>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayQueue implements PlayQueue {
  const _PlayQueue({final  List<SongEntity> songs = const [], this.index = -1}): _songs = songs;
  factory _PlayQueue.fromJson(Map<String, dynamic> json) => _$PlayQueueFromJson(json);

 final  List<SongEntity> _songs;
@override@JsonKey() List<SongEntity> get songs {
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_songs);
}

@override@JsonKey() final  int index;

/// Create a copy of PlayQueue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayQueueCopyWith<_PlayQueue> get copyWith => __$PlayQueueCopyWithImpl<_PlayQueue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayQueueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayQueue&&const DeepCollectionEquality().equals(other._songs, _songs)&&(identical(other.index, index) || other.index == index));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_songs),index);

@override
String toString() {
  return 'PlayQueue(songs: $songs, index: $index)';
}


}

/// @nodoc
abstract mixin class _$PlayQueueCopyWith<$Res> implements $PlayQueueCopyWith<$Res> {
  factory _$PlayQueueCopyWith(_PlayQueue value, $Res Function(_PlayQueue) _then) = __$PlayQueueCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity> songs, int index
});




}
/// @nodoc
class __$PlayQueueCopyWithImpl<$Res>
    implements _$PlayQueueCopyWith<$Res> {
  __$PlayQueueCopyWithImpl(this._self, this._then);

  final _PlayQueue _self;
  final $Res Function(_PlayQueue) _then;

/// Create a copy of PlayQueue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? songs = null,Object? index = null,}) {
  return _then(_PlayQueue(
songs: null == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongEntity>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
