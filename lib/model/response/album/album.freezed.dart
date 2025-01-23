// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AlbumEntity _$AlbumEntityFromJson(Map<String, dynamic> json) {
  return _AlbumEntity.fromJson(json);
}

/// @nodoc
mixin _$AlbumEntity {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get artist => throw _privateConstructorUsedError;
  String? get artistId => throw _privateConstructorUsedError;
  String? get coverArt => throw _privateConstructorUsedError;
  int? get songCount => throw _privateConstructorUsedError;
  int? get duration => throw _privateConstructorUsedError;
  DateTime? get created => throw _privateConstructorUsedError;
  DateTime? get starred => throw _privateConstructorUsedError;
  int? get year => throw _privateConstructorUsedError;
  String? get genre => throw _privateConstructorUsedError;
  int? get userRating => throw _privateConstructorUsedError;
  List<GenreElement>? get genres => throw _privateConstructorUsedError;
  String? get musicBrainzId => throw _privateConstructorUsedError;
  bool? get isCompilation => throw _privateConstructorUsedError;
  String? get sortName => throw _privateConstructorUsedError;
  List<DiscTitle>? get discTitles => throw _privateConstructorUsedError;
  ReleaseDate? get originalReleaseDate => throw _privateConstructorUsedError;
  ReleaseDate? get releaseDate => throw _privateConstructorUsedError;
  List<SongEntity>? get song => throw _privateConstructorUsedError;

  /// Serializes this AlbumEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumEntityCopyWith<AlbumEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumEntityCopyWith<$Res> {
  factory $AlbumEntityCopyWith(
          AlbumEntity value, $Res Function(AlbumEntity) then) =
      _$AlbumEntityCopyWithImpl<$Res, AlbumEntity>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? artist,
      String? artistId,
      String? coverArt,
      int? songCount,
      int? duration,
      DateTime? created,
      DateTime? starred,
      int? year,
      String? genre,
      int? userRating,
      List<GenreElement>? genres,
      String? musicBrainzId,
      bool? isCompilation,
      String? sortName,
      List<DiscTitle>? discTitles,
      ReleaseDate? originalReleaseDate,
      ReleaseDate? releaseDate,
      List<SongEntity>? song});

  $ReleaseDateCopyWith<$Res>? get originalReleaseDate;
  $ReleaseDateCopyWith<$Res>? get releaseDate;
}

/// @nodoc
class _$AlbumEntityCopyWithImpl<$Res, $Val extends AlbumEntity>
    implements $AlbumEntityCopyWith<$Res> {
  _$AlbumEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? artist = freezed,
    Object? artistId = freezed,
    Object? coverArt = freezed,
    Object? songCount = freezed,
    Object? duration = freezed,
    Object? created = freezed,
    Object? starred = freezed,
    Object? year = freezed,
    Object? genre = freezed,
    Object? userRating = freezed,
    Object? genres = freezed,
    Object? musicBrainzId = freezed,
    Object? isCompilation = freezed,
    Object? sortName = freezed,
    Object? discTitles = freezed,
    Object? originalReleaseDate = freezed,
    Object? releaseDate = freezed,
    Object? song = freezed,
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
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String?,
      artistId: freezed == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String?,
      coverArt: freezed == coverArt
          ? _value.coverArt
          : coverArt // ignore: cast_nullable_to_non_nullable
              as String?,
      songCount: freezed == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      starred: freezed == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreElement>?,
      musicBrainzId: freezed == musicBrainzId
          ? _value.musicBrainzId
          : musicBrainzId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompilation: freezed == isCompilation
          ? _value.isCompilation
          : isCompilation // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortName: freezed == sortName
          ? _value.sortName
          : sortName // ignore: cast_nullable_to_non_nullable
              as String?,
      discTitles: freezed == discTitles
          ? _value.discTitles
          : discTitles // ignore: cast_nullable_to_non_nullable
              as List<DiscTitle>?,
      originalReleaseDate: freezed == originalReleaseDate
          ? _value.originalReleaseDate
          : originalReleaseDate // ignore: cast_nullable_to_non_nullable
              as ReleaseDate?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as ReleaseDate?,
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ) as $Val);
  }

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReleaseDateCopyWith<$Res>? get originalReleaseDate {
    if (_value.originalReleaseDate == null) {
      return null;
    }

    return $ReleaseDateCopyWith<$Res>(_value.originalReleaseDate!, (value) {
      return _then(_value.copyWith(originalReleaseDate: value) as $Val);
    });
  }

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReleaseDateCopyWith<$Res>? get releaseDate {
    if (_value.releaseDate == null) {
      return null;
    }

    return $ReleaseDateCopyWith<$Res>(_value.releaseDate!, (value) {
      return _then(_value.copyWith(releaseDate: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AlbumEntityImplCopyWith<$Res>
    implements $AlbumEntityCopyWith<$Res> {
  factory _$$AlbumEntityImplCopyWith(
          _$AlbumEntityImpl value, $Res Function(_$AlbumEntityImpl) then) =
      __$$AlbumEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? artist,
      String? artistId,
      String? coverArt,
      int? songCount,
      int? duration,
      DateTime? created,
      DateTime? starred,
      int? year,
      String? genre,
      int? userRating,
      List<GenreElement>? genres,
      String? musicBrainzId,
      bool? isCompilation,
      String? sortName,
      List<DiscTitle>? discTitles,
      ReleaseDate? originalReleaseDate,
      ReleaseDate? releaseDate,
      List<SongEntity>? song});

  @override
  $ReleaseDateCopyWith<$Res>? get originalReleaseDate;
  @override
  $ReleaseDateCopyWith<$Res>? get releaseDate;
}

/// @nodoc
class __$$AlbumEntityImplCopyWithImpl<$Res>
    extends _$AlbumEntityCopyWithImpl<$Res, _$AlbumEntityImpl>
    implements _$$AlbumEntityImplCopyWith<$Res> {
  __$$AlbumEntityImplCopyWithImpl(
      _$AlbumEntityImpl _value, $Res Function(_$AlbumEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? artist = freezed,
    Object? artistId = freezed,
    Object? coverArt = freezed,
    Object? songCount = freezed,
    Object? duration = freezed,
    Object? created = freezed,
    Object? starred = freezed,
    Object? year = freezed,
    Object? genre = freezed,
    Object? userRating = freezed,
    Object? genres = freezed,
    Object? musicBrainzId = freezed,
    Object? isCompilation = freezed,
    Object? sortName = freezed,
    Object? discTitles = freezed,
    Object? originalReleaseDate = freezed,
    Object? releaseDate = freezed,
    Object? song = freezed,
  }) {
    return _then(_$AlbumEntityImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as String?,
      artistId: freezed == artistId
          ? _value.artistId
          : artistId // ignore: cast_nullable_to_non_nullable
              as String?,
      coverArt: freezed == coverArt
          ? _value.coverArt
          : coverArt // ignore: cast_nullable_to_non_nullable
              as String?,
      songCount: freezed == songCount
          ? _value.songCount
          : songCount // ignore: cast_nullable_to_non_nullable
              as int?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      starred: freezed == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      year: freezed == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int?,
      genre: freezed == genre
          ? _value.genre
          : genre // ignore: cast_nullable_to_non_nullable
              as String?,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
              as int?,
      genres: freezed == genres
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<GenreElement>?,
      musicBrainzId: freezed == musicBrainzId
          ? _value.musicBrainzId
          : musicBrainzId // ignore: cast_nullable_to_non_nullable
              as String?,
      isCompilation: freezed == isCompilation
          ? _value.isCompilation
          : isCompilation // ignore: cast_nullable_to_non_nullable
              as bool?,
      sortName: freezed == sortName
          ? _value.sortName
          : sortName // ignore: cast_nullable_to_non_nullable
              as String?,
      discTitles: freezed == discTitles
          ? _value._discTitles
          : discTitles // ignore: cast_nullable_to_non_nullable
              as List<DiscTitle>?,
      originalReleaseDate: freezed == originalReleaseDate
          ? _value.originalReleaseDate
          : originalReleaseDate // ignore: cast_nullable_to_non_nullable
              as ReleaseDate?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as ReleaseDate?,
      song: freezed == song
          ? _value._song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlbumEntityImpl implements _AlbumEntity {
  const _$AlbumEntityImpl(
      {this.id,
      this.name,
      this.artist,
      this.artistId,
      this.coverArt,
      this.songCount,
      this.duration,
      this.created,
      this.starred,
      this.year,
      this.genre,
      this.userRating,
      final List<GenreElement>? genres,
      this.musicBrainzId,
      this.isCompilation,
      this.sortName,
      final List<DiscTitle>? discTitles,
      this.originalReleaseDate,
      this.releaseDate,
      final List<SongEntity>? song})
      : _genres = genres,
        _discTitles = discTitles,
        _song = song;

  factory _$AlbumEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumEntityImplFromJson(json);

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? artist;
  @override
  final String? artistId;
  @override
  final String? coverArt;
  @override
  final int? songCount;
  @override
  final int? duration;
  @override
  final DateTime? created;
  @override
  final DateTime? starred;
  @override
  final int? year;
  @override
  final String? genre;
  @override
  final int? userRating;
  final List<GenreElement>? _genres;
  @override
  List<GenreElement>? get genres {
    final value = _genres;
    if (value == null) return null;
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? musicBrainzId;
  @override
  final bool? isCompilation;
  @override
  final String? sortName;
  final List<DiscTitle>? _discTitles;
  @override
  List<DiscTitle>? get discTitles {
    final value = _discTitles;
    if (value == null) return null;
    if (_discTitles is EqualUnmodifiableListView) return _discTitles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final ReleaseDate? originalReleaseDate;
  @override
  final ReleaseDate? releaseDate;
  final List<SongEntity>? _song;
  @override
  List<SongEntity>? get song {
    final value = _song;
    if (value == null) return null;
    if (_song is EqualUnmodifiableListView) return _song;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AlbumEntity(id: $id, name: $name, artist: $artist, artistId: $artistId, coverArt: $coverArt, songCount: $songCount, duration: $duration, created: $created, starred: $starred, year: $year, genre: $genre, userRating: $userRating, genres: $genres, musicBrainzId: $musicBrainzId, isCompilation: $isCompilation, sortName: $sortName, discTitles: $discTitles, originalReleaseDate: $originalReleaseDate, releaseDate: $releaseDate, song: $song)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.artistId, artistId) ||
                other.artistId == artistId) &&
            (identical(other.coverArt, coverArt) ||
                other.coverArt == coverArt) &&
            (identical(other.songCount, songCount) ||
                other.songCount == songCount) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.starred, starred) || other.starred == starred) &&
            (identical(other.year, year) || other.year == year) &&
            (identical(other.genre, genre) || other.genre == genre) &&
            (identical(other.userRating, userRating) ||
                other.userRating == userRating) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            (identical(other.musicBrainzId, musicBrainzId) ||
                other.musicBrainzId == musicBrainzId) &&
            (identical(other.isCompilation, isCompilation) ||
                other.isCompilation == isCompilation) &&
            (identical(other.sortName, sortName) ||
                other.sortName == sortName) &&
            const DeepCollectionEquality()
                .equals(other._discTitles, _discTitles) &&
            (identical(other.originalReleaseDate, originalReleaseDate) ||
                other.originalReleaseDate == originalReleaseDate) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            const DeepCollectionEquality().equals(other._song, _song));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        artist,
        artistId,
        coverArt,
        songCount,
        duration,
        created,
        starred,
        year,
        genre,
        userRating,
        const DeepCollectionEquality().hash(_genres),
        musicBrainzId,
        isCompilation,
        sortName,
        const DeepCollectionEquality().hash(_discTitles),
        originalReleaseDate,
        releaseDate,
        const DeepCollectionEquality().hash(_song)
      ]);

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumEntityImplCopyWith<_$AlbumEntityImpl> get copyWith =>
      __$$AlbumEntityImplCopyWithImpl<_$AlbumEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumEntityImplToJson(
      this,
    );
  }
}

abstract class _AlbumEntity implements AlbumEntity {
  const factory _AlbumEntity(
      {final String? id,
      final String? name,
      final String? artist,
      final String? artistId,
      final String? coverArt,
      final int? songCount,
      final int? duration,
      final DateTime? created,
      final DateTime? starred,
      final int? year,
      final String? genre,
      final int? userRating,
      final List<GenreElement>? genres,
      final String? musicBrainzId,
      final bool? isCompilation,
      final String? sortName,
      final List<DiscTitle>? discTitles,
      final ReleaseDate? originalReleaseDate,
      final ReleaseDate? releaseDate,
      final List<SongEntity>? song}) = _$AlbumEntityImpl;

  factory _AlbumEntity.fromJson(Map<String, dynamic> json) =
      _$AlbumEntityImpl.fromJson;

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get artist;
  @override
  String? get artistId;
  @override
  String? get coverArt;
  @override
  int? get songCount;
  @override
  int? get duration;
  @override
  DateTime? get created;
  @override
  DateTime? get starred;
  @override
  int? get year;
  @override
  String? get genre;
  @override
  int? get userRating;
  @override
  List<GenreElement>? get genres;
  @override
  String? get musicBrainzId;
  @override
  bool? get isCompilation;
  @override
  String? get sortName;
  @override
  List<DiscTitle>? get discTitles;
  @override
  ReleaseDate? get originalReleaseDate;
  @override
  ReleaseDate? get releaseDate;
  @override
  List<SongEntity>? get song;

  /// Create a copy of AlbumEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumEntityImplCopyWith<_$AlbumEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

DiscTitle _$DiscTitleFromJson(Map<String, dynamic> json) {
  return _DiscTitle.fromJson(json);
}

/// @nodoc
mixin _$DiscTitle {
  int? get disc => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;

  /// Serializes this DiscTitle to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DiscTitle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DiscTitleCopyWith<DiscTitle> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DiscTitleCopyWith<$Res> {
  factory $DiscTitleCopyWith(DiscTitle value, $Res Function(DiscTitle) then) =
      _$DiscTitleCopyWithImpl<$Res, DiscTitle>;
  @useResult
  $Res call({int? disc, String? title});
}

/// @nodoc
class _$DiscTitleCopyWithImpl<$Res, $Val extends DiscTitle>
    implements $DiscTitleCopyWith<$Res> {
  _$DiscTitleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DiscTitle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disc = freezed,
    Object? title = freezed,
  }) {
    return _then(_value.copyWith(
      disc: freezed == disc
          ? _value.disc
          : disc // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DiscTitleImplCopyWith<$Res>
    implements $DiscTitleCopyWith<$Res> {
  factory _$$DiscTitleImplCopyWith(
          _$DiscTitleImpl value, $Res Function(_$DiscTitleImpl) then) =
      __$$DiscTitleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? disc, String? title});
}

/// @nodoc
class __$$DiscTitleImplCopyWithImpl<$Res>
    extends _$DiscTitleCopyWithImpl<$Res, _$DiscTitleImpl>
    implements _$$DiscTitleImplCopyWith<$Res> {
  __$$DiscTitleImplCopyWithImpl(
      _$DiscTitleImpl _value, $Res Function(_$DiscTitleImpl) _then)
      : super(_value, _then);

  /// Create a copy of DiscTitle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? disc = freezed,
    Object? title = freezed,
  }) {
    return _then(_$DiscTitleImpl(
      disc: freezed == disc
          ? _value.disc
          : disc // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DiscTitleImpl implements _DiscTitle {
  const _$DiscTitleImpl({this.disc, this.title});

  factory _$DiscTitleImpl.fromJson(Map<String, dynamic> json) =>
      _$$DiscTitleImplFromJson(json);

  @override
  final int? disc;
  @override
  final String? title;

  @override
  String toString() {
    return 'DiscTitle(disc: $disc, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscTitleImpl &&
            (identical(other.disc, disc) || other.disc == disc) &&
            (identical(other.title, title) || other.title == title));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, disc, title);

  /// Create a copy of DiscTitle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscTitleImplCopyWith<_$DiscTitleImpl> get copyWith =>
      __$$DiscTitleImplCopyWithImpl<_$DiscTitleImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DiscTitleImplToJson(
      this,
    );
  }
}

abstract class _DiscTitle implements DiscTitle {
  const factory _DiscTitle({final int? disc, final String? title}) =
      _$DiscTitleImpl;

  factory _DiscTitle.fromJson(Map<String, dynamic> json) =
      _$DiscTitleImpl.fromJson;

  @override
  int? get disc;
  @override
  String? get title;

  /// Create a copy of DiscTitle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscTitleImplCopyWith<_$DiscTitleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) {
  return _ReleaseDate.fromJson(json);
}

/// @nodoc
mixin _$ReleaseDate {
  /// Serializes this ReleaseDate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReleaseDateCopyWith<$Res> {
  factory $ReleaseDateCopyWith(
          ReleaseDate value, $Res Function(ReleaseDate) then) =
      _$ReleaseDateCopyWithImpl<$Res, ReleaseDate>;
}

/// @nodoc
class _$ReleaseDateCopyWithImpl<$Res, $Val extends ReleaseDate>
    implements $ReleaseDateCopyWith<$Res> {
  _$ReleaseDateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ReleaseDateImplCopyWith<$Res> {
  factory _$$ReleaseDateImplCopyWith(
          _$ReleaseDateImpl value, $Res Function(_$ReleaseDateImpl) then) =
      __$$ReleaseDateImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReleaseDateImplCopyWithImpl<$Res>
    extends _$ReleaseDateCopyWithImpl<$Res, _$ReleaseDateImpl>
    implements _$$ReleaseDateImplCopyWith<$Res> {
  __$$ReleaseDateImplCopyWithImpl(
      _$ReleaseDateImpl _value, $Res Function(_$ReleaseDateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReleaseDate
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ReleaseDateImpl implements _ReleaseDate {
  const _$ReleaseDateImpl();

  factory _$ReleaseDateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReleaseDateImplFromJson(json);

  @override
  String toString() {
    return 'ReleaseDate()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReleaseDateImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  Map<String, dynamic> toJson() {
    return _$$ReleaseDateImplToJson(
      this,
    );
  }
}

abstract class _ReleaseDate implements ReleaseDate {
  const factory _ReleaseDate() = _$ReleaseDateImpl;

  factory _ReleaseDate.fromJson(Map<String, dynamic> json) =
      _$ReleaseDateImpl.fromJson;
}

AlbumListEntity _$AlbumListEntityFromJson(Map<String, dynamic> json) {
  return _AlbumListEntity.fromJson(json);
}

/// @nodoc
mixin _$AlbumListEntity {
  List<AlbumEntity>? get album => throw _privateConstructorUsedError;

  /// Serializes this AlbumListEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AlbumListEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AlbumListEntityCopyWith<AlbumListEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AlbumListEntityCopyWith<$Res> {
  factory $AlbumListEntityCopyWith(
          AlbumListEntity value, $Res Function(AlbumListEntity) then) =
      _$AlbumListEntityCopyWithImpl<$Res, AlbumListEntity>;
  @useResult
  $Res call({List<AlbumEntity>? album});
}

/// @nodoc
class _$AlbumListEntityCopyWithImpl<$Res, $Val extends AlbumListEntity>
    implements $AlbumListEntityCopyWith<$Res> {
  _$AlbumListEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AlbumListEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
  }) {
    return _then(_value.copyWith(
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AlbumListEntityImplCopyWith<$Res>
    implements $AlbumListEntityCopyWith<$Res> {
  factory _$$AlbumListEntityImplCopyWith(_$AlbumListEntityImpl value,
          $Res Function(_$AlbumListEntityImpl) then) =
      __$$AlbumListEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<AlbumEntity>? album});
}

/// @nodoc
class __$$AlbumListEntityImplCopyWithImpl<$Res>
    extends _$AlbumListEntityCopyWithImpl<$Res, _$AlbumListEntityImpl>
    implements _$$AlbumListEntityImplCopyWith<$Res> {
  __$$AlbumListEntityImplCopyWithImpl(
      _$AlbumListEntityImpl _value, $Res Function(_$AlbumListEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of AlbumListEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? album = freezed,
  }) {
    return _then(_$AlbumListEntityImpl(
      album: freezed == album
          ? _value._album
          : album // ignore: cast_nullable_to_non_nullable
              as List<AlbumEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AlbumListEntityImpl implements _AlbumListEntity {
  const _$AlbumListEntityImpl({final List<AlbumEntity>? album})
      : _album = album;

  factory _$AlbumListEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$AlbumListEntityImplFromJson(json);

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
    return 'AlbumListEntity(album: $album)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AlbumListEntityImpl &&
            const DeepCollectionEquality().equals(other._album, _album));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_album));

  /// Create a copy of AlbumListEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AlbumListEntityImplCopyWith<_$AlbumListEntityImpl> get copyWith =>
      __$$AlbumListEntityImplCopyWithImpl<_$AlbumListEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AlbumListEntityImplToJson(
      this,
    );
  }
}

abstract class _AlbumListEntity implements AlbumListEntity {
  const factory _AlbumListEntity({final List<AlbumEntity>? album}) =
      _$AlbumListEntityImpl;

  factory _AlbumListEntity.fromJson(Map<String, dynamic> json) =
      _$AlbumListEntityImpl.fromJson;

  @override
  List<AlbumEntity>? get album;

  /// Create a copy of AlbumListEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AlbumListEntityImplCopyWith<_$AlbumListEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
