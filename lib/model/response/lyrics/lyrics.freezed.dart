// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lyrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LyricsListEntity _$LyricsListEntityFromJson(Map<String, dynamic> json) {
  return _LyricsListEntity.fromJson(json);
}

/// @nodoc
mixin _$LyricsListEntity {
  List<StructuredLyric>? get structuredLyrics =>
      throw _privateConstructorUsedError;

  /// Serializes this LyricsListEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LyricsListEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LyricsListEntityCopyWith<LyricsListEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LyricsListEntityCopyWith<$Res> {
  factory $LyricsListEntityCopyWith(
          LyricsListEntity value, $Res Function(LyricsListEntity) then) =
      _$LyricsListEntityCopyWithImpl<$Res, LyricsListEntity>;
  @useResult
  $Res call({List<StructuredLyric>? structuredLyrics});
}

/// @nodoc
class _$LyricsListEntityCopyWithImpl<$Res, $Val extends LyricsListEntity>
    implements $LyricsListEntityCopyWith<$Res> {
  _$LyricsListEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LyricsListEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? structuredLyrics = freezed,
  }) {
    return _then(_value.copyWith(
      structuredLyrics: freezed == structuredLyrics
          ? _value.structuredLyrics
          : structuredLyrics // ignore: cast_nullable_to_non_nullable
              as List<StructuredLyric>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LyricsListEntityImplCopyWith<$Res>
    implements $LyricsListEntityCopyWith<$Res> {
  factory _$$LyricsListEntityImplCopyWith(_$LyricsListEntityImpl value,
          $Res Function(_$LyricsListEntityImpl) then) =
      __$$LyricsListEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<StructuredLyric>? structuredLyrics});
}

/// @nodoc
class __$$LyricsListEntityImplCopyWithImpl<$Res>
    extends _$LyricsListEntityCopyWithImpl<$Res, _$LyricsListEntityImpl>
    implements _$$LyricsListEntityImplCopyWith<$Res> {
  __$$LyricsListEntityImplCopyWithImpl(_$LyricsListEntityImpl _value,
      $Res Function(_$LyricsListEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of LyricsListEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? structuredLyrics = freezed,
  }) {
    return _then(_$LyricsListEntityImpl(
      structuredLyrics: freezed == structuredLyrics
          ? _value._structuredLyrics
          : structuredLyrics // ignore: cast_nullable_to_non_nullable
              as List<StructuredLyric>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LyricsListEntityImpl implements _LyricsListEntity {
  const _$LyricsListEntityImpl({final List<StructuredLyric>? structuredLyrics})
      : _structuredLyrics = structuredLyrics;

  factory _$LyricsListEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$LyricsListEntityImplFromJson(json);

  final List<StructuredLyric>? _structuredLyrics;
  @override
  List<StructuredLyric>? get structuredLyrics {
    final value = _structuredLyrics;
    if (value == null) return null;
    if (_structuredLyrics is EqualUnmodifiableListView)
      return _structuredLyrics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'LyricsListEntity(structuredLyrics: $structuredLyrics)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LyricsListEntityImpl &&
            const DeepCollectionEquality()
                .equals(other._structuredLyrics, _structuredLyrics));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_structuredLyrics));

  /// Create a copy of LyricsListEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LyricsListEntityImplCopyWith<_$LyricsListEntityImpl> get copyWith =>
      __$$LyricsListEntityImplCopyWithImpl<_$LyricsListEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LyricsListEntityImplToJson(
      this,
    );
  }
}

abstract class _LyricsListEntity implements LyricsListEntity {
  const factory _LyricsListEntity(
      {final List<StructuredLyric>? structuredLyrics}) = _$LyricsListEntityImpl;

  factory _LyricsListEntity.fromJson(Map<String, dynamic> json) =
      _$LyricsListEntityImpl.fromJson;

  @override
  List<StructuredLyric>? get structuredLyrics;

  /// Create a copy of LyricsListEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LyricsListEntityImplCopyWith<_$LyricsListEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StructuredLyric _$StructuredLyricFromJson(Map<String, dynamic> json) {
  return _StructuredLyric.fromJson(json);
}

/// @nodoc
mixin _$StructuredLyric {
  String? get displayArtist => throw _privateConstructorUsedError;
  String? get displayTitle => throw _privateConstructorUsedError;
  String? get lang => throw _privateConstructorUsedError;
  List<Line>? get line => throw _privateConstructorUsedError;
  int? get offset => throw _privateConstructorUsedError;
  bool? get synced => throw _privateConstructorUsedError;

  /// Serializes this StructuredLyric to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StructuredLyric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StructuredLyricCopyWith<StructuredLyric> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StructuredLyricCopyWith<$Res> {
  factory $StructuredLyricCopyWith(
          StructuredLyric value, $Res Function(StructuredLyric) then) =
      _$StructuredLyricCopyWithImpl<$Res, StructuredLyric>;
  @useResult
  $Res call(
      {String? displayArtist,
      String? displayTitle,
      String? lang,
      List<Line>? line,
      int? offset,
      bool? synced});
}

/// @nodoc
class _$StructuredLyricCopyWithImpl<$Res, $Val extends StructuredLyric>
    implements $StructuredLyricCopyWith<$Res> {
  _$StructuredLyricCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StructuredLyric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayArtist = freezed,
    Object? displayTitle = freezed,
    Object? lang = freezed,
    Object? line = freezed,
    Object? offset = freezed,
    Object? synced = freezed,
  }) {
    return _then(_value.copyWith(
      displayArtist: freezed == displayArtist
          ? _value.displayArtist
          : displayArtist // ignore: cast_nullable_to_non_nullable
              as String?,
      displayTitle: freezed == displayTitle
          ? _value.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      line: freezed == line
          ? _value.line
          : line // ignore: cast_nullable_to_non_nullable
              as List<Line>?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      synced: freezed == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StructuredLyricImplCopyWith<$Res>
    implements $StructuredLyricCopyWith<$Res> {
  factory _$$StructuredLyricImplCopyWith(_$StructuredLyricImpl value,
          $Res Function(_$StructuredLyricImpl) then) =
      __$$StructuredLyricImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? displayArtist,
      String? displayTitle,
      String? lang,
      List<Line>? line,
      int? offset,
      bool? synced});
}

/// @nodoc
class __$$StructuredLyricImplCopyWithImpl<$Res>
    extends _$StructuredLyricCopyWithImpl<$Res, _$StructuredLyricImpl>
    implements _$$StructuredLyricImplCopyWith<$Res> {
  __$$StructuredLyricImplCopyWithImpl(
      _$StructuredLyricImpl _value, $Res Function(_$StructuredLyricImpl) _then)
      : super(_value, _then);

  /// Create a copy of StructuredLyric
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayArtist = freezed,
    Object? displayTitle = freezed,
    Object? lang = freezed,
    Object? line = freezed,
    Object? offset = freezed,
    Object? synced = freezed,
  }) {
    return _then(_$StructuredLyricImpl(
      displayArtist: freezed == displayArtist
          ? _value.displayArtist
          : displayArtist // ignore: cast_nullable_to_non_nullable
              as String?,
      displayTitle: freezed == displayTitle
          ? _value.displayTitle
          : displayTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      lang: freezed == lang
          ? _value.lang
          : lang // ignore: cast_nullable_to_non_nullable
              as String?,
      line: freezed == line
          ? _value._line
          : line // ignore: cast_nullable_to_non_nullable
              as List<Line>?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as int?,
      synced: freezed == synced
          ? _value.synced
          : synced // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StructuredLyricImpl implements _StructuredLyric {
  const _$StructuredLyricImpl(
      {this.displayArtist,
      this.displayTitle,
      this.lang,
      final List<Line>? line,
      this.offset,
      this.synced})
      : _line = line;

  factory _$StructuredLyricImpl.fromJson(Map<String, dynamic> json) =>
      _$$StructuredLyricImplFromJson(json);

  @override
  final String? displayArtist;
  @override
  final String? displayTitle;
  @override
  final String? lang;
  final List<Line>? _line;
  @override
  List<Line>? get line {
    final value = _line;
    if (value == null) return null;
    if (_line is EqualUnmodifiableListView) return _line;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? offset;
  @override
  final bool? synced;

  @override
  String toString() {
    return 'StructuredLyric(displayArtist: $displayArtist, displayTitle: $displayTitle, lang: $lang, line: $line, offset: $offset, synced: $synced)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StructuredLyricImpl &&
            (identical(other.displayArtist, displayArtist) ||
                other.displayArtist == displayArtist) &&
            (identical(other.displayTitle, displayTitle) ||
                other.displayTitle == displayTitle) &&
            (identical(other.lang, lang) || other.lang == lang) &&
            const DeepCollectionEquality().equals(other._line, _line) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.synced, synced) || other.synced == synced));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, displayArtist, displayTitle,
      lang, const DeepCollectionEquality().hash(_line), offset, synced);

  /// Create a copy of StructuredLyric
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StructuredLyricImplCopyWith<_$StructuredLyricImpl> get copyWith =>
      __$$StructuredLyricImplCopyWithImpl<_$StructuredLyricImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StructuredLyricImplToJson(
      this,
    );
  }
}

abstract class _StructuredLyric implements StructuredLyric {
  const factory _StructuredLyric(
      {final String? displayArtist,
      final String? displayTitle,
      final String? lang,
      final List<Line>? line,
      final int? offset,
      final bool? synced}) = _$StructuredLyricImpl;

  factory _StructuredLyric.fromJson(Map<String, dynamic> json) =
      _$StructuredLyricImpl.fromJson;

  @override
  String? get displayArtist;
  @override
  String? get displayTitle;
  @override
  String? get lang;
  @override
  List<Line>? get line;
  @override
  int? get offset;
  @override
  bool? get synced;

  /// Create a copy of StructuredLyric
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StructuredLyricImplCopyWith<_$StructuredLyricImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Line _$LineFromJson(Map<String, dynamic> json) {
  return _Line.fromJson(json);
}

/// @nodoc
mixin _$Line {
  int? get start => throw _privateConstructorUsedError;
  String? get value => throw _privateConstructorUsedError;

  /// Serializes this Line to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LineCopyWith<Line> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LineCopyWith<$Res> {
  factory $LineCopyWith(Line value, $Res Function(Line) then) =
      _$LineCopyWithImpl<$Res, Line>;
  @useResult
  $Res call({int? start, String? value});
}

/// @nodoc
class _$LineCopyWithImpl<$Res, $Val extends Line>
    implements $LineCopyWith<$Res> {
  _$LineCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = freezed,
    Object? value = freezed,
  }) {
    return _then(_value.copyWith(
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LineImplCopyWith<$Res> implements $LineCopyWith<$Res> {
  factory _$$LineImplCopyWith(
          _$LineImpl value, $Res Function(_$LineImpl) then) =
      __$$LineImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? start, String? value});
}

/// @nodoc
class __$$LineImplCopyWithImpl<$Res>
    extends _$LineCopyWithImpl<$Res, _$LineImpl>
    implements _$$LineImplCopyWith<$Res> {
  __$$LineImplCopyWithImpl(_$LineImpl _value, $Res Function(_$LineImpl) _then)
      : super(_value, _then);

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? start = freezed,
    Object? value = freezed,
  }) {
    return _then(_$LineImpl(
      start: freezed == start
          ? _value.start
          : start // ignore: cast_nullable_to_non_nullable
              as int?,
      value: freezed == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LineImpl implements _Line {
  const _$LineImpl({this.start, this.value});

  factory _$LineImpl.fromJson(Map<String, dynamic> json) =>
      _$$LineImplFromJson(json);

  @override
  final int? start;
  @override
  final String? value;

  @override
  String toString() {
    return 'Line(start: $start, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LineImpl &&
            (identical(other.start, start) || other.start == start) &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, start, value);

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LineImplCopyWith<_$LineImpl> get copyWith =>
      __$$LineImplCopyWithImpl<_$LineImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LineImplToJson(
      this,
    );
  }
}

abstract class _Line implements Line {
  const factory _Line({final int? start, final String? value}) = _$LineImpl;

  factory _Line.fromJson(Map<String, dynamic> json) = _$LineImpl.fromJson;

  @override
  int? get start;
  @override
  String? get value;

  /// Create a copy of Line
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LineImplCopyWith<_$LineImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
