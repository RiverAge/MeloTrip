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
PlayQueueEntity _$PlayQueueEntityFromJson(
  Map<String, dynamic> json
) {
    return _PlayQueueEntityClass.fromJson(
      json
    );
}

/// @nodoc
mixin _$PlayQueueEntity {

 List<SongEntity>? get entry; String? get current; int? get position; String? get username; DateTime? get changed; String? get changedBy;
/// Create a copy of PlayQueueEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayQueueEntityCopyWith<PlayQueueEntity> get copyWith => _$PlayQueueEntityCopyWithImpl<PlayQueueEntity>(this as PlayQueueEntity, _$identity);

  /// Serializes this PlayQueueEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayQueueEntity&&const DeepCollectionEquality().equals(other.entry, entry)&&(identical(other.current, current) || other.current == current)&&(identical(other.position, position) || other.position == position)&&(identical(other.username, username) || other.username == username)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(entry),current,position,username,changed,changedBy);

@override
String toString() {
  return 'PlayQueueEntity(entry: $entry, current: $current, position: $position, username: $username, changed: $changed, changedBy: $changedBy)';
}


}

/// @nodoc
abstract mixin class $PlayQueueEntityCopyWith<$Res>  {
  factory $PlayQueueEntityCopyWith(PlayQueueEntity value, $Res Function(PlayQueueEntity) _then) = _$PlayQueueEntityCopyWithImpl;
@useResult
$Res call({
 List<SongEntity>? entry, String? current, int? position, String? username, DateTime? changed, String? changedBy
});




}
/// @nodoc
class _$PlayQueueEntityCopyWithImpl<$Res>
    implements $PlayQueueEntityCopyWith<$Res> {
  _$PlayQueueEntityCopyWithImpl(this._self, this._then);

  final PlayQueueEntity _self;
  final $Res Function(PlayQueueEntity) _then;

/// Create a copy of PlayQueueEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entry = freezed,Object? current = freezed,Object? position = freezed,Object? username = freezed,Object? changed = freezed,Object? changedBy = freezed,}) {
  return _then(_self.copyWith(
entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as DateTime?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _PlayQueueEntityClass implements PlayQueueEntity {
  const _PlayQueueEntityClass({final  List<SongEntity>? entry, this.current, this.position, this.username, this.changed, this.changedBy}): _entry = entry;
  factory _PlayQueueEntityClass.fromJson(Map<String, dynamic> json) => _$PlayQueueEntityClassFromJson(json);

 final  List<SongEntity>? _entry;
@override List<SongEntity>? get entry {
  final value = _entry;
  if (value == null) return null;
  if (_entry is EqualUnmodifiableListView) return _entry;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? current;
@override final  int? position;
@override final  String? username;
@override final  DateTime? changed;
@override final  String? changedBy;

/// Create a copy of PlayQueueEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayQueueEntityClassCopyWith<_PlayQueueEntityClass> get copyWith => __$PlayQueueEntityClassCopyWithImpl<_PlayQueueEntityClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayQueueEntityClassToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayQueueEntityClass&&const DeepCollectionEquality().equals(other._entry, _entry)&&(identical(other.current, current) || other.current == current)&&(identical(other.position, position) || other.position == position)&&(identical(other.username, username) || other.username == username)&&(identical(other.changed, changed) || other.changed == changed)&&(identical(other.changedBy, changedBy) || other.changedBy == changedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_entry),current,position,username,changed,changedBy);

@override
String toString() {
  return 'PlayQueueEntity(entry: $entry, current: $current, position: $position, username: $username, changed: $changed, changedBy: $changedBy)';
}


}

/// @nodoc
abstract mixin class _$PlayQueueEntityClassCopyWith<$Res> implements $PlayQueueEntityCopyWith<$Res> {
  factory _$PlayQueueEntityClassCopyWith(_PlayQueueEntityClass value, $Res Function(_PlayQueueEntityClass) _then) = __$PlayQueueEntityClassCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity>? entry, String? current, int? position, String? username, DateTime? changed, String? changedBy
});




}
/// @nodoc
class __$PlayQueueEntityClassCopyWithImpl<$Res>
    implements _$PlayQueueEntityClassCopyWith<$Res> {
  __$PlayQueueEntityClassCopyWithImpl(this._self, this._then);

  final _PlayQueueEntityClass _self;
  final $Res Function(_PlayQueueEntityClass) _then;

/// Create a copy of PlayQueueEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entry = freezed,Object? current = freezed,Object? position = freezed,Object? username = freezed,Object? changed = freezed,Object? changedBy = freezed,}) {
  return _then(_PlayQueueEntityClass(
entry: freezed == entry ? _self._entry : entry // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as String?,position: freezed == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,changed: freezed == changed ? _self.changed : changed // ignore: cast_nullable_to_non_nullable
as DateTime?,changedBy: freezed == changedBy ? _self.changedBy : changedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
