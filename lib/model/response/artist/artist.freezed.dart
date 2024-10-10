// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ArtistEntity _$ArtistEntityFromJson(Map<String, dynamic> json) {
  return _ArtistEntity.fromJson(json);
}

/// @nodoc
mixin _$ArtistEntity {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get coverArt => throw _privateConstructorUsedError;
  int? get albumCount => throw _privateConstructorUsedError;
  String? get artistImageUrl => throw _privateConstructorUsedError;
  List<AlbumEntity>? get album => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArtistEntityCopyWith<ArtistEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArtistEntityCopyWith<$Res> {
  factory $ArtistEntityCopyWith(
          ArtistEntity value, $Res Function(ArtistEntity) then) =
      _$ArtistEntityCopyWithImpl<$Res, ArtistEntity>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? coverArt,
      int? albumCount,
      String? artistImageUrl,
      List<AlbumEntity>? album});
}

/// @nodoc
class _$ArtistEntityCopyWithImpl<$Res, $Val extends ArtistEntity>
    implements $ArtistEntityCopyWith<$Res> {
  _$ArtistEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? coverArt = freezed,
    Object? albumCount = freezed,
    Object? artistImageUrl = freezed,
    Object? album = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      coverArt: freezed == coverArt
          ? _value.coverArt
          : coverArt // ignore: cast_nullable_to_non_nullable
              as String?,
      albumCount: freezed == albumCount
          ? _value.albumCount
          : albumCount // ignore: cast_nullable_to_non_nullable
              as int?,
      artistImageUrl: freezed == artistImageUrl
          ? _value.artistImageUrl
          : artistImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArtistEntityImplCopyWith<$Res>
    implements $ArtistEntityCopyWith<$Res> {
  factory _$$ArtistEntityImplCopyWith(
          _$ArtistEntityImpl value, $Res Function(_$ArtistEntityImpl) then) =
      __$$ArtistEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? coverArt,
      int? albumCount,
      String? artistImageUrl,
      List<AlbumEntity>? album});
}

/// @nodoc
class __$$ArtistEntityImplCopyWithImpl<$Res>
    extends _$ArtistEntityCopyWithImpl<$Res, _$ArtistEntityImpl>
    implements _$$ArtistEntityImplCopyWith<$Res> {
  __$$ArtistEntityImplCopyWithImpl(
      _$ArtistEntityImpl _value, $Res Function(_$ArtistEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? coverArt = freezed,
    Object? albumCount = freezed,
    Object? artistImageUrl = freezed,
    Object? album = freezed,
  }) {
    return _then(_$ArtistEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      coverArt: freezed == coverArt
          ? _value.coverArt
          : coverArt // ignore: cast_nullable_to_non_nullable
              as String?,
      albumCount: freezed == albumCount
          ? _value.albumCount
          : albumCount // ignore: cast_nullable_to_non_nullable
              as int?,
      artistImageUrl: freezed == artistImageUrl
          ? _value.artistImageUrl
          : artistImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      album: freezed == album
          ? _value._album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArtistEntityImpl implements _ArtistEntity {
  const _$ArtistEntityImpl(
      {this.id,
      this.name,
      this.coverArt,
      this.albumCount,
      this.artistImageUrl,
      final List<AlbumEntity>? album})
      : _album = album;

  factory _$ArtistEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArtistEntityImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? coverArt;
  @override
  final int? albumCount;
  @override
  final String? artistImageUrl;
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
    return 'ArtistEntity(id: $id, name: $name, coverArt: $coverArt, albumCount: $albumCount, artistImageUrl: $artistImageUrl, album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArtistEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.coverArt, coverArt) ||
                other.coverArt == coverArt) &&
            (identical(other.albumCount, albumCount) ||
                other.albumCount == albumCount) &&
            (identical(other.artistImageUrl, artistImageUrl) ||
                other.artistImageUrl == artistImageUrl) &&
            const DeepCollectionEquality().equals(other._album, _album));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, coverArt, albumCount,
      artistImageUrl, const DeepCollectionEquality().hash(_album));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArtistEntityImplCopyWith<_$ArtistEntityImpl> get copyWith =>
      __$$ArtistEntityImplCopyWithImpl<_$ArtistEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArtistEntityImplToJson(
      this,
    );
  }
}

abstract class _ArtistEntity implements ArtistEntity {
  const factory _ArtistEntity(
      {final String? id,
      final String? name,
      final String? coverArt,
      final int? albumCount,
      final String? artistImageUrl,
      final List<AlbumEntity>? album}) = _$ArtistEntityImpl;

  factory _ArtistEntity.fromJson(Map<String, dynamic> json) =
      _$ArtistEntityImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get coverArt;
  @override
  int? get albumCount;
  @override
  String? get artistImageUrl;
  @override
  List<AlbumEntity>? get album;
  @override
  @JsonKey(ignore: true)
  _$$ArtistEntityImplCopyWith<_$ArtistEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
