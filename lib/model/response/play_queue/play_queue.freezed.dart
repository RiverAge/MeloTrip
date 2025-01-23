// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_queue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlayQueueEntity _$PlayQueueEntityFromJson(Map<String, dynamic> json) {
  return _PlayQueueEntityClass.fromJson(json);
}

/// @nodoc
mixin _$PlayQueueEntity {
  List<SongEntity>? get entry => throw _privateConstructorUsedError;
  String? get current => throw _privateConstructorUsedError;
  int? get position => throw _privateConstructorUsedError;
  String? get username => throw _privateConstructorUsedError;
  DateTime? get changed => throw _privateConstructorUsedError;
  String? get changedBy => throw _privateConstructorUsedError;

  /// Serializes this PlayQueueEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlayQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlayQueueEntityCopyWith<PlayQueueEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayQueueEntityCopyWith<$Res> {
  factory $PlayQueueEntityCopyWith(
          PlayQueueEntity value, $Res Function(PlayQueueEntity) then) =
      _$PlayQueueEntityCopyWithImpl<$Res, PlayQueueEntity>;
  @useResult
  $Res call(
      {List<SongEntity>? entry,
      String? current,
      int? position,
      String? username,
      DateTime? changed,
      String? changedBy});
}

/// @nodoc
class _$PlayQueueEntityCopyWithImpl<$Res, $Val extends PlayQueueEntity>
    implements $PlayQueueEntityCopyWith<$Res> {
  _$PlayQueueEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlayQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entry = freezed,
    Object? current = freezed,
    Object? position = freezed,
    Object? username = freezed,
    Object? changed = freezed,
    Object? changedBy = freezed,
  }) {
    return _then(_value.copyWith(
      entry: freezed == entry
          ? _value.entry
          : entry // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      current: freezed == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      changed: freezed == changed
          ? _value.changed
          : changed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlayQueueEntityClassImplCopyWith<$Res>
    implements $PlayQueueEntityCopyWith<$Res> {
  factory _$$PlayQueueEntityClassImplCopyWith(_$PlayQueueEntityClassImpl value,
          $Res Function(_$PlayQueueEntityClassImpl) then) =
      __$$PlayQueueEntityClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<SongEntity>? entry,
      String? current,
      int? position,
      String? username,
      DateTime? changed,
      String? changedBy});
}

/// @nodoc
class __$$PlayQueueEntityClassImplCopyWithImpl<$Res>
    extends _$PlayQueueEntityCopyWithImpl<$Res, _$PlayQueueEntityClassImpl>
    implements _$$PlayQueueEntityClassImplCopyWith<$Res> {
  __$$PlayQueueEntityClassImplCopyWithImpl(_$PlayQueueEntityClassImpl _value,
      $Res Function(_$PlayQueueEntityClassImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlayQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entry = freezed,
    Object? current = freezed,
    Object? position = freezed,
    Object? username = freezed,
    Object? changed = freezed,
    Object? changedBy = freezed,
  }) {
    return _then(_$PlayQueueEntityClassImpl(
      entry: freezed == entry
          ? _value._entry
          : entry // ignore: cast_nullable_to_non_nullable
              as List<SongEntity>?,
      current: freezed == current
          ? _value.current
          : current // ignore: cast_nullable_to_non_nullable
              as String?,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as int?,
      username: freezed == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String?,
      changed: freezed == changed
          ? _value.changed
          : changed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      changedBy: freezed == changedBy
          ? _value.changedBy
          : changedBy // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlayQueueEntityClassImpl implements _PlayQueueEntityClass {
  const _$PlayQueueEntityClassImpl(
      {final List<SongEntity>? entry,
      this.current,
      this.position,
      this.username,
      this.changed,
      this.changedBy})
      : _entry = entry;

  factory _$PlayQueueEntityClassImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlayQueueEntityClassImplFromJson(json);

  final List<SongEntity>? _entry;
  @override
  List<SongEntity>? get entry {
    final value = _entry;
    if (value == null) return null;
    if (_entry is EqualUnmodifiableListView) return _entry;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? current;
  @override
  final int? position;
  @override
  final String? username;
  @override
  final DateTime? changed;
  @override
  final String? changedBy;

  @override
  String toString() {
    return 'PlayQueueEntity(entry: $entry, current: $current, position: $position, username: $username, changed: $changed, changedBy: $changedBy)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlayQueueEntityClassImpl &&
            const DeepCollectionEquality().equals(other._entry, _entry) &&
            (identical(other.current, current) || other.current == current) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.changed, changed) || other.changed == changed) &&
            (identical(other.changedBy, changedBy) ||
                other.changedBy == changedBy));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_entry),
      current,
      position,
      username,
      changed,
      changedBy);

  /// Create a copy of PlayQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlayQueueEntityClassImplCopyWith<_$PlayQueueEntityClassImpl>
      get copyWith =>
          __$$PlayQueueEntityClassImplCopyWithImpl<_$PlayQueueEntityClassImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlayQueueEntityClassImplToJson(
      this,
    );
  }
}

abstract class _PlayQueueEntityClass implements PlayQueueEntity {
  const factory _PlayQueueEntityClass(
      {final List<SongEntity>? entry,
      final String? current,
      final int? position,
      final String? username,
      final DateTime? changed,
      final String? changedBy}) = _$PlayQueueEntityClassImpl;

  factory _PlayQueueEntityClass.fromJson(Map<String, dynamic> json) =
      _$PlayQueueEntityClassImpl.fromJson;

  @override
  List<SongEntity>? get entry;
  @override
  String? get current;
  @override
  int? get position;
  @override
  String? get username;
  @override
  DateTime? get changed;
  @override
  String? get changedBy;

  /// Create a copy of PlayQueueEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlayQueueEntityClassImplCopyWith<_$PlayQueueEntityClassImpl>
      get copyWith => throw _privateConstructorUsedError;
}
