// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
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


/// Adds pattern-matching-related methods to [LyricsListEntity].
extension LyricsListEntityPatterns on LyricsListEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LyricsListEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LyricsListEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LyricsListEntity value)  $default,){
final _that = this;
switch (_that) {
case _LyricsListEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LyricsListEntity value)?  $default,){
final _that = this;
switch (_that) {
case _LyricsListEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StructuredLyric>? structuredLyrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LyricsListEntity() when $default != null:
return $default(_that.structuredLyrics);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StructuredLyric>? structuredLyrics)  $default,) {final _that = this;
switch (_that) {
case _LyricsListEntity():
return $default(_that.structuredLyrics);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StructuredLyric>? structuredLyrics)?  $default,) {final _that = this;
switch (_that) {
case _LyricsListEntity() when $default != null:
return $default(_that.structuredLyrics);case _:
  return null;

}
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

 String? get displayArtist; String? get displayTitle; String? get kind; String? get lang; List<Line>? get line; List<Agent>? get agents; List<CueLine>? get cueLine; int? get offset; bool? get synced;
/// Create a copy of StructuredLyric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StructuredLyricCopyWith<StructuredLyric> get copyWith => _$StructuredLyricCopyWithImpl<StructuredLyric>(this as StructuredLyric, _$identity);

  /// Serializes this StructuredLyric to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StructuredLyric&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other.line, line)&&const DeepCollectionEquality().equals(other.agents, agents)&&const DeepCollectionEquality().equals(other.cueLine, cueLine)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.synced, synced) || other.synced == synced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayArtist,displayTitle,kind,lang,const DeepCollectionEquality().hash(line),const DeepCollectionEquality().hash(agents),const DeepCollectionEquality().hash(cueLine),offset,synced);

@override
String toString() {
  return 'StructuredLyric(displayArtist: $displayArtist, displayTitle: $displayTitle, kind: $kind, lang: $lang, line: $line, agents: $agents, cueLine: $cueLine, offset: $offset, synced: $synced)';
}


}

/// @nodoc
abstract mixin class $StructuredLyricCopyWith<$Res>  {
  factory $StructuredLyricCopyWith(StructuredLyric value, $Res Function(StructuredLyric) _then) = _$StructuredLyricCopyWithImpl;
@useResult
$Res call({
 String? displayArtist, String? displayTitle, String? kind, String? lang, List<Line>? line, List<Agent>? agents, List<CueLine>? cueLine, int? offset, bool? synced
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
@pragma('vm:prefer-inline') @override $Res call({Object? displayArtist = freezed,Object? displayTitle = freezed,Object? kind = freezed,Object? lang = freezed,Object? line = freezed,Object? agents = freezed,Object? cueLine = freezed,Object? offset = freezed,Object? synced = freezed,}) {
  return _then(_self.copyWith(
displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self.line : line // ignore: cast_nullable_to_non_nullable
as List<Line>?,agents: freezed == agents ? _self.agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>?,cueLine: freezed == cueLine ? _self.cueLine : cueLine // ignore: cast_nullable_to_non_nullable
as List<CueLine>?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as int?,synced: freezed == synced ? _self.synced : synced // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [StructuredLyric].
extension StructuredLyricPatterns on StructuredLyric {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StructuredLyric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StructuredLyric() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StructuredLyric value)  $default,){
final _that = this;
switch (_that) {
case _StructuredLyric():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StructuredLyric value)?  $default,){
final _that = this;
switch (_that) {
case _StructuredLyric() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayArtist,  String? displayTitle,  String? kind,  String? lang,  List<Line>? line,  List<Agent>? agents,  List<CueLine>? cueLine,  int? offset,  bool? synced)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StructuredLyric() when $default != null:
return $default(_that.displayArtist,_that.displayTitle,_that.kind,_that.lang,_that.line,_that.agents,_that.cueLine,_that.offset,_that.synced);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayArtist,  String? displayTitle,  String? kind,  String? lang,  List<Line>? line,  List<Agent>? agents,  List<CueLine>? cueLine,  int? offset,  bool? synced)  $default,) {final _that = this;
switch (_that) {
case _StructuredLyric():
return $default(_that.displayArtist,_that.displayTitle,_that.kind,_that.lang,_that.line,_that.agents,_that.cueLine,_that.offset,_that.synced);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayArtist,  String? displayTitle,  String? kind,  String? lang,  List<Line>? line,  List<Agent>? agents,  List<CueLine>? cueLine,  int? offset,  bool? synced)?  $default,) {final _that = this;
switch (_that) {
case _StructuredLyric() when $default != null:
return $default(_that.displayArtist,_that.displayTitle,_that.kind,_that.lang,_that.line,_that.agents,_that.cueLine,_that.offset,_that.synced);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StructuredLyric implements StructuredLyric {
  const _StructuredLyric({this.displayArtist, this.displayTitle, this.kind, this.lang, final  List<Line>? line, final  List<Agent>? agents, final  List<CueLine>? cueLine, this.offset, this.synced}): _line = line,_agents = agents,_cueLine = cueLine;
  factory _StructuredLyric.fromJson(Map<String, dynamic> json) => _$StructuredLyricFromJson(json);

@override final  String? displayArtist;
@override final  String? displayTitle;
@override final  String? kind;
@override final  String? lang;
 final  List<Line>? _line;
@override List<Line>? get line {
  final value = _line;
  if (value == null) return null;
  if (_line is EqualUnmodifiableListView) return _line;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<Agent>? _agents;
@override List<Agent>? get agents {
  final value = _agents;
  if (value == null) return null;
  if (_agents is EqualUnmodifiableListView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<CueLine>? _cueLine;
@override List<CueLine>? get cueLine {
  final value = _cueLine;
  if (value == null) return null;
  if (_cueLine is EqualUnmodifiableListView) return _cueLine;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StructuredLyric&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&(identical(other.displayTitle, displayTitle) || other.displayTitle == displayTitle)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.lang, lang) || other.lang == lang)&&const DeepCollectionEquality().equals(other._line, _line)&&const DeepCollectionEquality().equals(other._agents, _agents)&&const DeepCollectionEquality().equals(other._cueLine, _cueLine)&&(identical(other.offset, offset) || other.offset == offset)&&(identical(other.synced, synced) || other.synced == synced));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,displayArtist,displayTitle,kind,lang,const DeepCollectionEquality().hash(_line),const DeepCollectionEquality().hash(_agents),const DeepCollectionEquality().hash(_cueLine),offset,synced);

@override
String toString() {
  return 'StructuredLyric(displayArtist: $displayArtist, displayTitle: $displayTitle, kind: $kind, lang: $lang, line: $line, agents: $agents, cueLine: $cueLine, offset: $offset, synced: $synced)';
}


}

/// @nodoc
abstract mixin class _$StructuredLyricCopyWith<$Res> implements $StructuredLyricCopyWith<$Res> {
  factory _$StructuredLyricCopyWith(_StructuredLyric value, $Res Function(_StructuredLyric) _then) = __$StructuredLyricCopyWithImpl;
@override @useResult
$Res call({
 String? displayArtist, String? displayTitle, String? kind, String? lang, List<Line>? line, List<Agent>? agents, List<CueLine>? cueLine, int? offset, bool? synced
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
@override @pragma('vm:prefer-inline') $Res call({Object? displayArtist = freezed,Object? displayTitle = freezed,Object? kind = freezed,Object? lang = freezed,Object? line = freezed,Object? agents = freezed,Object? cueLine = freezed,Object? offset = freezed,Object? synced = freezed,}) {
  return _then(_StructuredLyric(
displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,displayTitle: freezed == displayTitle ? _self.displayTitle : displayTitle // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,lang: freezed == lang ? _self.lang : lang // ignore: cast_nullable_to_non_nullable
as String?,line: freezed == line ? _self._line : line // ignore: cast_nullable_to_non_nullable
as List<Line>?,agents: freezed == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>?,cueLine: freezed == cueLine ? _self._cueLine : cueLine // ignore: cast_nullable_to_non_nullable
as List<CueLine>?,offset: freezed == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [Line].
extension LinePatterns on Line {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Line value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Line() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Line value)  $default,){
final _that = this;
switch (_that) {
case _Line():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Line value)?  $default,){
final _that = this;
switch (_that) {
case _Line() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? start,  String? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Line() when $default != null:
return $default(_that.start,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? start,  String? value)  $default,) {final _that = this;
switch (_that) {
case _Line():
return $default(_that.start,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? start,  String? value)?  $default,) {final _that = this;
switch (_that) {
case _Line() when $default != null:
return $default(_that.start,_that.value);case _:
  return null;

}
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


/// @nodoc
mixin _$Cue {

 int? get start; int? get end; int? get byteStart; int? get byteEnd; String? get value;
/// Create a copy of Cue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CueCopyWith<Cue> get copyWith => _$CueCopyWithImpl<Cue>(this as Cue, _$identity);

  /// Serializes this Cue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cue&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.byteStart, byteStart) || other.byteStart == byteStart)&&(identical(other.byteEnd, byteEnd) || other.byteEnd == byteEnd)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,byteStart,byteEnd,value);

@override
String toString() {
  return 'Cue(start: $start, end: $end, byteStart: $byteStart, byteEnd: $byteEnd, value: $value)';
}


}

/// @nodoc
abstract mixin class $CueCopyWith<$Res>  {
  factory $CueCopyWith(Cue value, $Res Function(Cue) _then) = _$CueCopyWithImpl;
@useResult
$Res call({
 int? start, int? end, int? byteStart, int? byteEnd, String? value
});




}
/// @nodoc
class _$CueCopyWithImpl<$Res>
    implements $CueCopyWith<$Res> {
  _$CueCopyWithImpl(this._self, this._then);

  final Cue _self;
  final $Res Function(Cue) _then;

/// Create a copy of Cue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? start = freezed,Object? end = freezed,Object? byteStart = freezed,Object? byteEnd = freezed,Object? value = freezed,}) {
  return _then(_self.copyWith(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,byteStart: freezed == byteStart ? _self.byteStart : byteStart // ignore: cast_nullable_to_non_nullable
as int?,byteEnd: freezed == byteEnd ? _self.byteEnd : byteEnd // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Cue].
extension CuePatterns on Cue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cue() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cue value)  $default,){
final _that = this;
switch (_that) {
case _Cue():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cue value)?  $default,){
final _that = this;
switch (_that) {
case _Cue() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? start,  int? end,  int? byteStart,  int? byteEnd,  String? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cue() when $default != null:
return $default(_that.start,_that.end,_that.byteStart,_that.byteEnd,_that.value);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? start,  int? end,  int? byteStart,  int? byteEnd,  String? value)  $default,) {final _that = this;
switch (_that) {
case _Cue():
return $default(_that.start,_that.end,_that.byteStart,_that.byteEnd,_that.value);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? start,  int? end,  int? byteStart,  int? byteEnd,  String? value)?  $default,) {final _that = this;
switch (_that) {
case _Cue() when $default != null:
return $default(_that.start,_that.end,_that.byteStart,_that.byteEnd,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Cue implements Cue {
  const _Cue({this.start, this.end, this.byteStart, this.byteEnd, this.value});
  factory _Cue.fromJson(Map<String, dynamic> json) => _$CueFromJson(json);

@override final  int? start;
@override final  int? end;
@override final  int? byteStart;
@override final  int? byteEnd;
@override final  String? value;

/// Create a copy of Cue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CueCopyWith<_Cue> get copyWith => __$CueCopyWithImpl<_Cue>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cue&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.byteStart, byteStart) || other.byteStart == byteStart)&&(identical(other.byteEnd, byteEnd) || other.byteEnd == byteEnd)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,start,end,byteStart,byteEnd,value);

@override
String toString() {
  return 'Cue(start: $start, end: $end, byteStart: $byteStart, byteEnd: $byteEnd, value: $value)';
}


}

/// @nodoc
abstract mixin class _$CueCopyWith<$Res> implements $CueCopyWith<$Res> {
  factory _$CueCopyWith(_Cue value, $Res Function(_Cue) _then) = __$CueCopyWithImpl;
@override @useResult
$Res call({
 int? start, int? end, int? byteStart, int? byteEnd, String? value
});




}
/// @nodoc
class __$CueCopyWithImpl<$Res>
    implements _$CueCopyWith<$Res> {
  __$CueCopyWithImpl(this._self, this._then);

  final _Cue _self;
  final $Res Function(_Cue) _then;

/// Create a copy of Cue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? start = freezed,Object? end = freezed,Object? byteStart = freezed,Object? byteEnd = freezed,Object? value = freezed,}) {
  return _then(_Cue(
start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,byteStart: freezed == byteStart ? _self.byteStart : byteStart // ignore: cast_nullable_to_non_nullable
as int?,byteEnd: freezed == byteEnd ? _self.byteEnd : byteEnd // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CueLine {

 int? get index; int? get start; int? get end; String? get value; String? get agentId; List<Cue>? get cue;
/// Create a copy of CueLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CueLineCopyWith<CueLine> get copyWith => _$CueLineCopyWithImpl<CueLine>(this as CueLine, _$identity);

  /// Serializes this CueLine to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CueLine&&(identical(other.index, index) || other.index == index)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.value, value) || other.value == value)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&const DeepCollectionEquality().equals(other.cue, cue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,start,end,value,agentId,const DeepCollectionEquality().hash(cue));

@override
String toString() {
  return 'CueLine(index: $index, start: $start, end: $end, value: $value, agentId: $agentId, cue: $cue)';
}


}

/// @nodoc
abstract mixin class $CueLineCopyWith<$Res>  {
  factory $CueLineCopyWith(CueLine value, $Res Function(CueLine) _then) = _$CueLineCopyWithImpl;
@useResult
$Res call({
 int? index, int? start, int? end, String? value, String? agentId, List<Cue>? cue
});




}
/// @nodoc
class _$CueLineCopyWithImpl<$Res>
    implements $CueLineCopyWith<$Res> {
  _$CueLineCopyWithImpl(this._self, this._then);

  final CueLine _self;
  final $Res Function(CueLine) _then;

/// Create a copy of CueLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,Object? start = freezed,Object? end = freezed,Object? value = freezed,Object? agentId = freezed,Object? cue = freezed,}) {
  return _then(_self.copyWith(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,cue: freezed == cue ? _self.cue : cue // ignore: cast_nullable_to_non_nullable
as List<Cue>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CueLine].
extension CueLinePatterns on CueLine {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CueLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CueLine() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CueLine value)  $default,){
final _that = this;
switch (_that) {
case _CueLine():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CueLine value)?  $default,){
final _that = this;
switch (_that) {
case _CueLine() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? index,  int? start,  int? end,  String? value,  String? agentId,  List<Cue>? cue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CueLine() when $default != null:
return $default(_that.index,_that.start,_that.end,_that.value,_that.agentId,_that.cue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? index,  int? start,  int? end,  String? value,  String? agentId,  List<Cue>? cue)  $default,) {final _that = this;
switch (_that) {
case _CueLine():
return $default(_that.index,_that.start,_that.end,_that.value,_that.agentId,_that.cue);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? index,  int? start,  int? end,  String? value,  String? agentId,  List<Cue>? cue)?  $default,) {final _that = this;
switch (_that) {
case _CueLine() when $default != null:
return $default(_that.index,_that.start,_that.end,_that.value,_that.agentId,_that.cue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CueLine implements CueLine {
  const _CueLine({this.index, this.start, this.end, this.value, this.agentId, final  List<Cue>? cue}): _cue = cue;
  factory _CueLine.fromJson(Map<String, dynamic> json) => _$CueLineFromJson(json);

@override final  int? index;
@override final  int? start;
@override final  int? end;
@override final  String? value;
@override final  String? agentId;
 final  List<Cue>? _cue;
@override List<Cue>? get cue {
  final value = _cue;
  if (value == null) return null;
  if (_cue is EqualUnmodifiableListView) return _cue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of CueLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CueLineCopyWith<_CueLine> get copyWith => __$CueLineCopyWithImpl<_CueLine>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CueLineToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CueLine&&(identical(other.index, index) || other.index == index)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.value, value) || other.value == value)&&(identical(other.agentId, agentId) || other.agentId == agentId)&&const DeepCollectionEquality().equals(other._cue, _cue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,start,end,value,agentId,const DeepCollectionEquality().hash(_cue));

@override
String toString() {
  return 'CueLine(index: $index, start: $start, end: $end, value: $value, agentId: $agentId, cue: $cue)';
}


}

/// @nodoc
abstract mixin class _$CueLineCopyWith<$Res> implements $CueLineCopyWith<$Res> {
  factory _$CueLineCopyWith(_CueLine value, $Res Function(_CueLine) _then) = __$CueLineCopyWithImpl;
@override @useResult
$Res call({
 int? index, int? start, int? end, String? value, String? agentId, List<Cue>? cue
});




}
/// @nodoc
class __$CueLineCopyWithImpl<$Res>
    implements _$CueLineCopyWith<$Res> {
  __$CueLineCopyWithImpl(this._self, this._then);

  final _CueLine _self;
  final $Res Function(_CueLine) _then;

/// Create a copy of CueLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? start = freezed,Object? end = freezed,Object? value = freezed,Object? agentId = freezed,Object? cue = freezed,}) {
  return _then(_CueLine(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int?,start: freezed == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as int?,end: freezed == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as int?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,agentId: freezed == agentId ? _self.agentId : agentId // ignore: cast_nullable_to_non_nullable
as String?,cue: freezed == cue ? _self._cue : cue // ignore: cast_nullable_to_non_nullable
as List<Cue>?,
  ));
}


}


/// @nodoc
mixin _$Agent {

 String? get id; String? get role; String? get name;
/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCopyWith<Agent> get copyWith => _$AgentCopyWithImpl<Agent>(this as Agent, _$identity);

  /// Serializes this Agent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agent&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,name);

@override
String toString() {
  return 'Agent(id: $id, role: $role, name: $name)';
}


}

/// @nodoc
abstract mixin class $AgentCopyWith<$Res>  {
  factory $AgentCopyWith(Agent value, $Res Function(Agent) _then) = _$AgentCopyWithImpl;
@useResult
$Res call({
 String? id, String? role, String? name
});




}
/// @nodoc
class _$AgentCopyWithImpl<$Res>
    implements $AgentCopyWith<$Res> {
  _$AgentCopyWithImpl(this._self, this._then);

  final Agent _self;
  final $Res Function(Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? role = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Agent].
extension AgentPatterns on Agent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agent value)  $default,){
final _that = this;
switch (_that) {
case _Agent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agent value)?  $default,){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? role,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.id,_that.role,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? role,  String? name)  $default,) {final _that = this;
switch (_that) {
case _Agent():
return $default(_that.id,_that.role,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? role,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.id,_that.role,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Agent implements Agent {
  const _Agent({this.id, this.role, this.name});
  factory _Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);

@override final  String? id;
@override final  String? role;
@override final  String? name;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCopyWith<_Agent> get copyWith => __$AgentCopyWithImpl<_Agent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agent&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,name);

@override
String toString() {
  return 'Agent(id: $id, role: $role, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AgentCopyWith<$Res> implements $AgentCopyWith<$Res> {
  factory _$AgentCopyWith(_Agent value, $Res Function(_Agent) _then) = __$AgentCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? role, String? name
});




}
/// @nodoc
class __$AgentCopyWithImpl<$Res>
    implements _$AgentCopyWith<$Res> {
  __$AgentCopyWithImpl(this._self, this._then);

  final _Agent _self;
  final $Res Function(_Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? role = freezed,Object? name = freezed,}) {
  return _then(_Agent(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
