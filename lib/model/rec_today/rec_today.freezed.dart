// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rec_today.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecTodayEntity _$RecTodayEntityFromJson(Map<String, dynamic> json) {
  return _RecTodayEntity.fromJson(json);
}

/// @nodoc
mixin _$RecTodayEntity {
  DateTime? get update => throw _privateConstructorUsedError;
  List<SongEntity>? get songs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RecTodayEntityCopyWith<RecTodayEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecTodayEntityCopyWith<$Res> {
  factory $RecTodayEntityCopyWith(
          RecTodayEntity value, $Res Function(RecTodayEntity) then) =
      _$RecTodayEntityCopyWithImpl<$Res, RecTodayEntity>;
  @useResult
  $Res call({DateTime? update, List<SongEntity>? songs});
}

/// @nodoc
class _$RecTodayEntityCopyWithImpl<$Res, $Val extends RecTodayEntity>
    implements $RecTodayEntityCopyWith<$Res> {
  _$RecTodayEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? update = freezed,
    Object? songs = freezed,
  }) {
    return _then(_value.copyWith(
      update: freezed == update
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      songs: freezed == songs
          ? _value.songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecTodayEntityImplCopyWith<$Res>
    implements $RecTodayEntityCopyWith<$Res> {
  factory _$$RecTodayEntityImplCopyWith(_$RecTodayEntityImpl value,
          $Res Function(_$RecTodayEntityImpl) then) =
      __$$RecTodayEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? update, List<SongEntity>? songs});
}

/// @nodoc
class __$$RecTodayEntityImplCopyWithImpl<$Res>
    extends _$RecTodayEntityCopyWithImpl<$Res, _$RecTodayEntityImpl>
    implements _$$RecTodayEntityImplCopyWith<$Res> {
  __$$RecTodayEntityImplCopyWithImpl(
      _$RecTodayEntityImpl _value, $Res Function(_$RecTodayEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? update = freezed,
    Object? songs = freezed,
  }) {
    return _then(_$RecTodayEntityImpl(
      update: freezed == update
          ? _value.update
          : update // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      songs: freezed == songs
          ? _value._songs
          : songs // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecTodayEntityImpl implements _RecTodayEntity {
  const _$RecTodayEntityImpl({this.update, final List<SongEntity>? songs})
      : _songs = songs;

  factory _$RecTodayEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecTodayEntityImplFromJson(json);

  @override
  final DateTime? update;
  final List<SongEntity>? _songs;
  @override
  List<SongEntity>? get songs {
    final value = _songs;
    if (value == null) return null;
    if (_songs is EqualUnmodifiableListView) return _songs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RecTodayEntity(update: $update, songs: $songs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecTodayEntityImpl &&
            (identical(other.update, update) || other.update == update) &&
            const DeepCollectionEquality().equals(other._songs, _songs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, update, const DeepCollectionEquality().hash(_songs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecTodayEntityImplCopyWith<_$RecTodayEntityImpl> get copyWith =>
      __$$RecTodayEntityImplCopyWithImpl<_$RecTodayEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecTodayEntityImplToJson(
      this,
    );
  }
}

abstract class _RecTodayEntity implements RecTodayEntity {
  const factory _RecTodayEntity(
      {final DateTime? update,
      final List<SongEntity>? songs}) = _$RecTodayEntityImpl;

  factory _RecTodayEntity.fromJson(Map<String, dynamic> json) =
      _$RecTodayEntityImpl.fromJson;

  @override
  DateTime? get update;
  @override
  List<SongEntity>? get songs;
  @override
  @JsonKey(ignore: true)
  _$$RecTodayEntityImplCopyWith<_$RecTodayEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
