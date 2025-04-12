// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rec_today.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecTodayEntity {

 DateTime? get update; List<SongEntity>? get songs;
/// Create a copy of RecTodayEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecTodayEntityCopyWith<RecTodayEntity> get copyWith => _$RecTodayEntityCopyWithImpl<RecTodayEntity>(this as RecTodayEntity, _$identity);

  /// Serializes this RecTodayEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecTodayEntity&&(identical(other.update, update) || other.update == update)&&const DeepCollectionEquality().equals(other.songs, songs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,update,const DeepCollectionEquality().hash(songs));

@override
String toString() {
  return 'RecTodayEntity(update: $update, songs: $songs)';
}


}

/// @nodoc
abstract mixin class $RecTodayEntityCopyWith<$Res>  {
  factory $RecTodayEntityCopyWith(RecTodayEntity value, $Res Function(RecTodayEntity) _then) = _$RecTodayEntityCopyWithImpl;
@useResult
$Res call({
 DateTime? update, List<SongEntity>? songs
});




}
/// @nodoc
class _$RecTodayEntityCopyWithImpl<$Res>
    implements $RecTodayEntityCopyWith<$Res> {
  _$RecTodayEntityCopyWithImpl(this._self, this._then);

  final RecTodayEntity _self;
  final $Res Function(RecTodayEntity) _then;

/// Create a copy of RecTodayEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? update = freezed,Object? songs = freezed,}) {
  return _then(_self.copyWith(
update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as DateTime?,songs: freezed == songs ? _self.songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RecTodayEntity implements RecTodayEntity {
  const _RecTodayEntity({this.update, final  List<SongEntity>? songs}): _songs = songs;
  factory _RecTodayEntity.fromJson(Map<String, dynamic> json) => _$RecTodayEntityFromJson(json);

@override final  DateTime? update;
 final  List<SongEntity>? _songs;
@override List<SongEntity>? get songs {
  final value = _songs;
  if (value == null) return null;
  if (_songs is EqualUnmodifiableListView) return _songs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RecTodayEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecTodayEntityCopyWith<_RecTodayEntity> get copyWith => __$RecTodayEntityCopyWithImpl<_RecTodayEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecTodayEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecTodayEntity&&(identical(other.update, update) || other.update == update)&&const DeepCollectionEquality().equals(other._songs, _songs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,update,const DeepCollectionEquality().hash(_songs));

@override
String toString() {
  return 'RecTodayEntity(update: $update, songs: $songs)';
}


}

/// @nodoc
abstract mixin class _$RecTodayEntityCopyWith<$Res> implements $RecTodayEntityCopyWith<$Res> {
  factory _$RecTodayEntityCopyWith(_RecTodayEntity value, $Res Function(_RecTodayEntity) _then) = __$RecTodayEntityCopyWithImpl;
@override @useResult
$Res call({
 DateTime? update, List<SongEntity>? songs
});




}
/// @nodoc
class __$RecTodayEntityCopyWithImpl<$Res>
    implements _$RecTodayEntityCopyWith<$Res> {
  __$RecTodayEntityCopyWithImpl(this._self, this._then);

  final _RecTodayEntity _self;
  final $Res Function(_RecTodayEntity) _then;

/// Create a copy of RecTodayEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? update = freezed,Object? songs = freezed,}) {
  return _then(_RecTodayEntity(
update: freezed == update ? _self.update : update // ignore: cast_nullable_to_non_nullable
as DateTime?,songs: freezed == songs ? _self._songs : songs // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}


}

// dart format on
