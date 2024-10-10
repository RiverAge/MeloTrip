// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result3.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SearchResult3Entity _$SearchResult3EntityFromJson(Map<String, dynamic> json) {
  return _SearchResult3Entity.fromJson(json);
}

/// @nodoc
mixin _$SearchResult3Entity {
  List<AlbumEntity>? get album => throw _privateConstructorUsedError;
  List<SongEntity>? get song => throw _privateConstructorUsedError;
  List<ArtistEntity>? get artist => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SearchResult3EntityCopyWith<SearchResult3Entity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SearchResult3EntityCopyWith<$Res> {
  factory $SearchResult3EntityCopyWith(
          SearchResult3Entity value, $Res Function(SearchResult3Entity) then) =
      _$SearchResult3EntityCopyWithImpl<$Res, SearchResult3Entity>;
  @useResult
  $Res call(
      {List<AlbumEntity>? album,
      List<SongEntity>? song,
      List<ArtistEntity>? artist});
}

/// @nodoc
class _$SearchResult3EntityCopyWithImpl<$Res, $Val extends SearchResult3Entity>
    implements $SearchResult3EntityCopyWith<$Res> {
  _$SearchResult3EntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
    Object? song = freezed,
    Object? artist = freezed,
  }) {
    return _then(_value.copyWith(
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as List<ArtistEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SearchResult3EntityImplCopyWith<$Res>
    implements $SearchResult3EntityCopyWith<$Res> {
  factory _$$SearchResult3EntityImplCopyWith(_$SearchResult3EntityImpl value,
          $Res Function(_$SearchResult3EntityImpl) then) =
      __$$SearchResult3EntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<AlbumEntity>? album,
      List<SongEntity>? song,
      List<ArtistEntity>? artist});
}

/// @nodoc
class __$$SearchResult3EntityImplCopyWithImpl<$Res>
    extends _$SearchResult3EntityCopyWithImpl<$Res, _$SearchResult3EntityImpl>
    implements _$$SearchResult3EntityImplCopyWith<$Res> {
  __$$SearchResult3EntityImplCopyWithImpl(_$SearchResult3EntityImpl _value,
      $Res Function(_$SearchResult3EntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
    Object? song = freezed,
    Object? artist = freezed,
  }) {
    return _then(_$SearchResult3EntityImpl(
      album: freezed == album
          ? _value._album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
      song: freezed == song
          ? _value._song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      artist: freezed == artist
          ? _value._artist
          : artist // ignore: cast_nullable_to_non_nullable
              as List<ArtistEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SearchResult3EntityImpl implements _SearchResult3Entity {
  const _$SearchResult3EntityImpl(
      {final List<AlbumEntity>? album,
      final List<SongEntity>? song,
      final List<ArtistEntity>? artist})
      : _album = album,
        _song = song,
        _artist = artist;

  factory _$SearchResult3EntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$SearchResult3EntityImplFromJson(json);

  final List<AlbumEntity>? _album;
  @override
  List<AlbumEntity>? get album {
    final value = _album;
    if (value == null) return null;
    if (_album is EqualUnmodifiableListView) return _album;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<SongEntity>? _song;
  @override
  List<SongEntity>? get song {
    final value = _song;
    if (value == null) return null;
    if (_song is EqualUnmodifiableListView) return _song;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<ArtistEntity>? _artist;
  @override
  List<ArtistEntity>? get artist {
    final value = _artist;
    if (value == null) return null;
    if (_artist is EqualUnmodifiableListView) return _artist;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'SearchResult3Entity(album: $album, song: $song, artist: $artist)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SearchResult3EntityImpl &&
            const DeepCollectionEquality().equals(other._album, _album) &&
            const DeepCollectionEquality().equals(other._song, _song) &&
            const DeepCollectionEquality().equals(other._artist, _artist));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_album),
      const DeepCollectionEquality().hash(_song),
      const DeepCollectionEquality().hash(_artist));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SearchResult3EntityImplCopyWith<_$SearchResult3EntityImpl> get copyWith =>
      __$$SearchResult3EntityImplCopyWithImpl<_$SearchResult3EntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SearchResult3EntityImplToJson(
      this,
    );
  }
}

abstract class _SearchResult3Entity implements SearchResult3Entity {
  const factory _SearchResult3Entity(
      {final List<AlbumEntity>? album,
      final List<SongEntity>? song,
      final List<ArtistEntity>? artist}) = _$SearchResult3EntityImpl;

  factory _SearchResult3Entity.fromJson(Map<String, dynamic> json) =
      _$SearchResult3EntityImpl.fromJson;

  @override
  List<AlbumEntity>? get album;
  @override
  List<SongEntity>? get song;
  @override
  List<ArtistEntity>? get artist;
  @override
  @JsonKey(ignore: true)
  _$$SearchResult3EntityImplCopyWith<_$SearchResult3EntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
