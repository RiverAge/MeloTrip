// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'starred.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StarredEntity _$StarredEntityFromJson(Map<String, dynamic> json) {
  return _StarredEntity.fromJson(json);
}

/// @nodoc
mixin _$StarredEntity {
  List<SongEntity>? get song => throw _privateConstructorUsedError;
  List<AlbumEntity>? get album => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StarredEntityCopyWith<StarredEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StarredEntityCopyWith<$Res> {
  factory $StarredEntityCopyWith(
          StarredEntity value, $Res Function(StarredEntity) then) =
      _$StarredEntityCopyWithImpl<$Res, StarredEntity>;
  @useResult
  $Res call({List<SongEntity>? song, List<AlbumEntity>? album});
}

/// @nodoc
class _$StarredEntityCopyWithImpl<$Res, $Val extends StarredEntity>
    implements $StarredEntityCopyWith<$Res> {
  _$StarredEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = freezed,
    Object? album = freezed,
  }) {
    return _then(_value.copyWith(
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StarredEntityImplCopyWith<$Res>
    implements $StarredEntityCopyWith<$Res> {
  factory _$$StarredEntityImplCopyWith(
          _$StarredEntityImpl value, $Res Function(_$StarredEntityImpl) then) =
      __$$StarredEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SongEntity>? song, List<AlbumEntity>? album});
}

/// @nodoc
class __$$StarredEntityImplCopyWithImpl<$Res>
    extends _$StarredEntityCopyWithImpl<$Res, _$StarredEntityImpl>
    implements _$$StarredEntityImplCopyWith<$Res> {
  __$$StarredEntityImplCopyWithImpl(
      _$StarredEntityImpl _value, $Res Function(_$StarredEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = freezed,
    Object? album = freezed,
  }) {
    return _then(_$StarredEntityImpl(
      song: freezed == song
          ? _value._song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      album: freezed == album
          ? _value._album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StarredEntityImpl implements _StarredEntity {
  const _$StarredEntityImpl(
      {final List<SongEntity>? song, final List<AlbumEntity>? album})
      : _song = song,
        _album = album;

  factory _$StarredEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$StarredEntityImplFromJson(json);

  final List<SongEntity>? _song;
  @override
  List<SongEntity>? get song {
    final value = _song;
    if (value == null) return null;
    if (_song is EqualUnmodifiableListView) return _song;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<AlbumEntity>? _album;
  @override
  List<AlbumEntity>? get album {
    final value = _album;
    if (value == null) return null;
    if (_album is EqualUnmodifiableListView) return _album;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'StarredEntity(song: $song, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StarredEntityImpl &&
            const DeepCollectionEquality().equals(other._song, _song) &&
            const DeepCollectionEquality().equals(other._album, _album));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_song),
      const DeepCollectionEquality().hash(_album));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StarredEntityImplCopyWith<_$StarredEntityImpl> get copyWith =>
      __$$StarredEntityImplCopyWithImpl<_$StarredEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StarredEntityImplToJson(
      this,
    );
  }
}

abstract class _StarredEntity implements StarredEntity {
  const factory _StarredEntity(
      {final List<SongEntity>? song,
      final List<AlbumEntity>? album}) = _$StarredEntityImpl;

  factory _StarredEntity.fromJson(Map<String, dynamic> json) =
      _$StarredEntityImpl.fromJson;

  @override
  List<SongEntity>? get song;
  @override
  List<AlbumEntity>? get album;
  @override
  @JsonKey(ignore: true)
  _$$StarredEntityImplCopyWith<_$StarredEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
