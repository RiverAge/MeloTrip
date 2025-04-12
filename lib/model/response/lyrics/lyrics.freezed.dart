// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lyrics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LyricsListEntity {

 List<StructuredLyric>? get structuredLyrics;
/// Create a copy of LyricsListEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LyricsListEntityCopyWith<LyricsListEntity> get copyWith => _$LyricsListEntityCopyWithImpl<LyricsListEntity>(this as LyricsListEntity, _$identity);

  /// Serializes this LyricsListEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LyricsListEntity&&const DeepCollectionEquality().equals(other.structuredLyrics, structuredLyrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(structuredLyrics));

@override
String toString() {
  return 'LyricsListEntity(structuredLyrics: $structuredLyrics)';
}


}

/// @nodoc
abstract mixin class $LyricsListEntityCopyWith<$Res>  {
  factory $LyricsListEntityCopyWith(LyricsListEntity value, $Res Function(LyricsListEntity) _then) = _$LyricsListEntityCopyWithImpl;
@useResult
$Res call({
 List<StructuredLyric>? structuredLyrics
});




}
/// @nodoc
class _$LyricsListEntityCopyWithImpl<$Res>
    implements $LyricsListEntityCopyWith<$Res> {
  _$LyricsListEntityCopyWithImpl(this._self, this._then);

  final LyricsListEntity _self;
  final $Res Function(LyricsListEntity) _then;

/// Create a copy of LyricsListEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? structuredLyrics = freezed,}) {
  return _then(_self.copyWith(
structuredLyrics: freezed == structuredLyrics ? _self.structuredLyrics : structuredLyrics // ignore: cast_nullable_to_non_nullable
as List<StructuredLyric>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _LyricsListEntity implements LyricsListEntity {
  const _LyricsListEntity({final  List<StructuredLyric>? structuredLyrics}): _structuredLyrics = structuredLyrics;
  factory _LyricsListEntity.fromJson(Map<String, dynamic> json) => _$LyricsListEntityFromJson(json);

 final  List<StructuredLyric>? _structuredLyrics;
@override List<StructuredLyric>? get structuredLyrics {
  final value = _structuredLyrics;
  if (value == null) return null;
  if (_structuredLyrics is EqualUnmodifiableListView) return _structuredLyrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of LyricsListEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LyricsListEntityCopyWith<_LyricsListEntity> get copyWith => __$LyricsListEntityCopyWithImpl<_LyricsListEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LyricsListEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LyricsListEntity&&const DeepCollectionEquality().equals(other._structuredLyrics, _structuredLyrics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_structuredLyrics));

@override
String toString() {
  return 'LyricsListEntity(structuredLyrics: $structuredLyrics)';
}


}

/// @nodoc
abstract mixin class _$LyricsListEntityCopyWith<$Res> implements $LyricsListEntityCopyWith<$Res> {
  factory _$LyricsListEntityCopyWith(_LyricsListEntity value, $Res Function(_LyricsListEntity) _then) = __$LyricsListEntityCopyWithImpl;
@override @useResult
$Res call({
 List<StructuredLyric>? structuredLyrics
});




}
/// @nodoc
class __$LyricsListEntityCopyWithImpl<$Res>
    implements _$LyricsListEntityCopyWith<$Res> {
  __$LyricsListEntityCopyWithImpl(this._self, this._then);

  final _LyricsListEntity _self;
  final $Res Function(_LyricsListEntity) _then;

/// Create a copy of LyricsListEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? structuredLyrics = freezed,}) {
  return _then(_LyricsListEntity(
structuredLyrics: freezed == structuredLyrics ? _self._structuredLyrics : structuredLyrics // ignore: cast_nullable_to_non_nullable
as List<StructuredLyric>?,
  ));
}


}


/// @nodoc
mixin _$StructuredLyric {

 String? get displayArtist; String? get displayTitle; String? get lang;@LinesConvert() List<Line>? get line; int? get offset; bool? get synced;
/// Create a copy of StructuredLyric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StructuredLyricCopyWith<StructuredLyric> get copyWith => _$StructuredLyricCopyWithImpl<StructuredLyric>(this as StructuredLyric, _$identity);

  /// Serializes this StructuredLyric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StructuredLyric&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other.line, line)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.synced, synced) || other.synced == synced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayArtist,displayTitle,lang,const DeepCollectionEquality().hash(line),offset,synced);

@override
String toString() {
  return 'StructuredLyric(displayArtist: $displayArtist, displayTitle: $displayTitle, lang: $lang, line: $line, offset: $offset, synced: $synced)';
}


}

/// @nodoc
abstract mixin class $StructuredLyricCopyWith<$Res>  {
  factory $StructuredLyricCopyWith(StructuredLyric value, $Res Function(StructuredLyric) _then) = _$StructuredLyricCopyWithImpl;
@useResult
$Res call({
 String? displayArtist, String? displayTitle, String? lang,@LinesConvert() List<Line>? line, int? offset, bool? synced
});




}
/// @nodoc
class _$StructuredLyricCopyWithImpl<$Res>
    implements $StructuredLyricCopyWith<$Res> {
  _$StructuredLyricCopyWithImpl(this._self, this._then);

  final StructuredLyric _self;
  final $Res Function(StructuredLyric) _then;

/// Create a copy of StructuredLyric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayArtist = freezed,Object? displayTitle = freezed,Object? lang = freezed,Object? line = freezed,Object? offset = freezed,Object? synced = freezed,}) {
  return _then(_self.copyWith(
displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as List<Line>?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,synced: freezed == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StructuredLyric implements StructuredLyric {
  const _StructuredLyric({this.displayArtist, this.displayTitle, this.lang, @LinesConvert() final  List<Line>? line, this.offset, this.synced}): _line = line;
  factory _StructuredLyric.fromJson(Map<String, dynamic> json) => _$StructuredLyricFromJson(json);

@override final  String? displayArtist;
@override final  String? displayTitle;
@override final  String? lang;
 final  List<Line>? _line;
@override@LinesConvert() List<Line>? get line {
  final value = _line;
  if (value == null) return null;
  if (_line is EqualUnmodifiableListView) return _line;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? offset;
@override final  bool? synced;

/// Create a copy of StructuredLyric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StructuredLyricCopyWith<_StructuredLyric> get copyWith => __$StructuredLyricCopyWithImpl<_StructuredLyric>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StructuredLyricToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StructuredLyric&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other._line, _line)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.synced, synced) || other.synced == synced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayArtist,displayTitle,lang,const DeepCollectionEquality().hash(_line),offset,synced);

@override
String toString() {
  return 'StructuredLyric(displayArtist: $displayArtist, displayTitle: $displayTitle, lang: $lang, line: $line, offset: $offset, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$StructuredLyricCopyWith<$Res> implements $StructuredLyricCopyWith<$Res> {
  factory _$StructuredLyricCopyWith(_StructuredLyric value, $Res Function(_StructuredLyric) _then) = __$StructuredLyricCopyWithImpl;
@override @useResult
$Res call({
 String? displayArtist, String? displayTitle, String? lang,@LinesConvert() List<Line>? line, int? offset, bool? synced
});




}
/// @nodoc
class __$StructuredLyricCopyWithImpl<$Res>
    implements _$StructuredLyricCopyWith<$Res> {
  __$StructuredLyricCopyWithImpl(this._self, this._then);

  final _StructuredLyric _self;
  final $Res Function(_StructuredLyric) _then;

/// Create a copy of StructuredLyric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayArtist = freezed,Object? displayTitle = freezed,Object? lang = freezed,Object? line = freezed,Object? offset = freezed,Object? synced = freezed,}) {
  return _then(_StructuredLyric(
displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self._line : line // ignore: cast_nullable_to_non_nullable
as List<Line>?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,synced: freezed == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$Line {

 int? get start; String? get value;
/// Create a copy of Line
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LineCopyWith<Line> get copyWith => _$LineCopyWithImpl<Line>(this as Line, _$identity);

  /// Serializes this Line to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Line&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,value);

@override
String toString() {
  return 'Line(start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class $LineCopyWith<$Res>  {
  factory $LineCopyWith(Line value, $Res Function(Line) _then) = _$LineCopyWithImpl;
@useResult
$Res call({
 int? start, String? value
});




}
/// @nodoc
class _$LineCopyWithImpl<$Res>
    implements $LineCopyWith<$Res> {
  _$LineCopyWithImpl(this._self, this._then);

  final Line _self;
  final $Res Function(Line) _then;

/// Create a copy of Line
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = freezed,Object? value = freezed,}) {
  return _then(_self.copyWith(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Line implements Line {
  const _Line({this.start, this.value});
  factory _Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);

@override final  int? start;
@override final  String? value;

/// Create a copy of Line
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LineCopyWith<_Line> get copyWith => __$LineCopyWithImpl<_Line>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Line&&(identical(other.start, start) || other.start == start)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,value);

@override
String toString() {
  return 'Line(start: $start, value: $value)';
}


}

/// @nodoc
abstract mixin class _$LineCopyWith<$Res> implements $LineCopyWith<$Res> {
  factory _$LineCopyWith(_Line value, $Res Function(_Line) _then) = __$LineCopyWithImpl;
@override @useResult
$Res call({
 int? start, String? value
});




}
/// @nodoc
class __$LineCopyWithImpl<$Res>
    implements _$LineCopyWith<$Res> {
  __$LineCopyWithImpl(this._self, this._then);

  final _Line _self;
  final $Res Function(_Line) _then;

/// Create a copy of Line
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = freezed,Object? value = freezed,}) {
  return _then(_Line(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
