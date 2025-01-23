// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'random_song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RandomSongsEntity _$RandomSongsEntityFromJson(Map<String, dynamic> json) {
  return _RandomSongsEntity.fromJson(json);
}

/// @nodoc
mixin _$RandomSongsEntity {
  List<SongEntity>? get song => throw _privateConstructorUsedError;

  /// Serializes this RandomSongsEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RandomSongsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RandomSongsEntityCopyWith<RandomSongsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RandomSongsEntityCopyWith<$Res> {
  factory $RandomSongsEntityCopyWith(
          RandomSongsEntity value, $Res Function(RandomSongsEntity) then) =
      _$RandomSongsEntityCopyWithImpl<$Res, RandomSongsEntity>;
  @useResult
  $Res call({List<SongEntity>? song});
}

/// @nodoc
class _$RandomSongsEntityCopyWithImpl<$Res, $Val extends RandomSongsEntity>
    implements $RandomSongsEntityCopyWith<$Res> {
  _$RandomSongsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RandomSongsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = freezed,
  }) {
    return _then(_value.copyWith(
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RandomSongsEntityImplCopyWith<$Res>
    implements $RandomSongsEntityCopyWith<$Res> {
  factory _$$RandomSongsEntityImplCopyWith(_$RandomSongsEntityImpl value,
          $Res Function(_$RandomSongsEntityImpl) then) =
      __$$RandomSongsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<SongEntity>? song});
}

/// @nodoc
class __$$RandomSongsEntityImplCopyWithImpl<$Res>
    extends _$RandomSongsEntityCopyWithImpl<$Res, _$RandomSongsEntityImpl>
    implements _$$RandomSongsEntityImplCopyWith<$Res> {
  __$$RandomSongsEntityImplCopyWithImpl(_$RandomSongsEntityImpl _value,
      $Res Function(_$RandomSongsEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of RandomSongsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? song = freezed,
  }) {
    return _then(_$RandomSongsEntityImpl(
      song: freezed == song
          ? _value._song
          : song // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RandomSongsEntityImpl implements _RandomSongsEntity {
  const _$RandomSongsEntityImpl({final List<SongEntity>? song}) : _song = song;

  factory _$RandomSongsEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RandomSongsEntityImplFromJson(json);

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
    return 'RandomSongsEntity(song: $song)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RandomSongsEntityImpl &&
            const DeepCollectionEquality().equals(other._song, _song));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_song));

  /// Create a copy of RandomSongsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RandomSongsEntityImplCopyWith<_$RandomSongsEntityImpl> get copyWith =>
      __$$RandomSongsEntityImplCopyWithImpl<_$RandomSongsEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RandomSongsEntityImplToJson(
      this,
    );
  }
}

abstract class _RandomSongsEntity implements RandomSongsEntity {
  const factory _RandomSongsEntity({final List<SongEntity>? song}) =
      _$RandomSongsEntityImpl;

  factory _RandomSongsEntity.fromJson(Map<String, dynamic> json) =
      _$RandomSongsEntityImpl.fromJson;

  @override
  List<SongEntity>? get song;

  /// Create a copy of RandomSongsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RandomSongsEntityImplCopyWith<_$RandomSongsEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
