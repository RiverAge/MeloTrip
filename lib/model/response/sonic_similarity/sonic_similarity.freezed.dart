// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sonic_similarity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SonicMatch {

/// The matched song entry (named "entry" in Navidrome response)
@JsonKey(name: 'entry') SongEntity? get entry;/// Similarity score (0.0 to 1.0, higher is more similar)
/// This field comes from the AudioMuse-AI plugin response
 double? get similarity;
/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonicMatchCopyWith<SonicMatch> get copyWith => _$SonicMatchCopyWithImpl<SonicMatch>(this as SonicMatch, _$identity);

  /// Serializes this SonicMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonicMatch&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.similarity, similarity) || other.similarity == similarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entry,similarity);

@override
String toString() {
  return 'SonicMatch(entry: $entry, similarity: $similarity)';
}


}

/// @nodoc
abstract mixin class $SonicMatchCopyWith<$Res>  {
  factory $SonicMatchCopyWith(SonicMatch value, $Res Function(SonicMatch) _then) = _$SonicMatchCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'entry') SongEntity? entry, double? similarity
});


$SongEntityCopyWith<$Res>? get entry;

}
/// @nodoc
class _$SonicMatchCopyWithImpl<$Res>
    implements $SonicMatchCopyWith<$Res> {
  _$SonicMatchCopyWithImpl(this._self, this._then);

  final SonicMatch _self;
  final $Res Function(SonicMatch) _then;

/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? entry = freezed,Object? similarity = freezed,}) {
  return _then(_self.copyWith(
entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as SongEntity?,similarity: freezed == similarity ? _self.similarity : similarity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}
/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// Adds pattern-matching-related methods to [SonicMatch].
extension SonicMatchPatterns on SonicMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonicMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonicMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonicMatch value)  $default,){
final _that = this;
switch (_that) {
case _SonicMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonicMatch value)?  $default,){
final _that = this;
switch (_that) {
case _SonicMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry')  SongEntity? entry,  double? similarity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonicMatch() when $default != null:
return $default(_that.entry,_that.similarity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'entry')  SongEntity? entry,  double? similarity)  $default,) {final _that = this;
switch (_that) {
case _SonicMatch():
return $default(_that.entry,_that.similarity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'entry')  SongEntity? entry,  double? similarity)?  $default,) {final _that = this;
switch (_that) {
case _SonicMatch() when $default != null:
return $default(_that.entry,_that.similarity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonicMatch implements SonicMatch {
  const _SonicMatch({@JsonKey(name: 'entry') this.entry, this.similarity});
  factory _SonicMatch.fromJson(Map<String, dynamic> json) => _$SonicMatchFromJson(json);

/// The matched song entry (named "entry" in Navidrome response)
@override@JsonKey(name: 'entry') final  SongEntity? entry;
/// Similarity score (0.0 to 1.0, higher is more similar)
/// This field comes from the AudioMuse-AI plugin response
@override final  double? similarity;

/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonicMatchCopyWith<_SonicMatch> get copyWith => __$SonicMatchCopyWithImpl<_SonicMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonicMatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonicMatch&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.similarity, similarity) || other.similarity == similarity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,entry,similarity);

@override
String toString() {
  return 'SonicMatch(entry: $entry, similarity: $similarity)';
}


}

/// @nodoc
abstract mixin class _$SonicMatchCopyWith<$Res> implements $SonicMatchCopyWith<$Res> {
  factory _$SonicMatchCopyWith(_SonicMatch value, $Res Function(_SonicMatch) _then) = __$SonicMatchCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'entry') SongEntity? entry, double? similarity
});


@override $SongEntityCopyWith<$Res>? get entry;

}
/// @nodoc
class __$SonicMatchCopyWithImpl<$Res>
    implements _$SonicMatchCopyWith<$Res> {
  __$SonicMatchCopyWithImpl(this._self, this._then);

  final _SonicMatch _self;
  final $Res Function(_SonicMatch) _then;

/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? entry = freezed,Object? similarity = freezed,}) {
  return _then(_SonicMatch(
entry: freezed == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as SongEntity?,similarity: freezed == similarity ? _self.similarity : similarity // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

/// Create a copy of SonicMatch
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get entry {
    if (_self.entry == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.entry!, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// @nodoc
mixin _$SonicMatchesEntity {

/// List of sonic matches
@JsonKey(name: 'sonicMatch') List<SonicMatch> get sonicMatch;
/// Create a copy of SonicMatchesEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SonicMatchesEntityCopyWith<SonicMatchesEntity> get copyWith => _$SonicMatchesEntityCopyWithImpl<SonicMatchesEntity>(this as SonicMatchesEntity, _$identity);

  /// Serializes this SonicMatchesEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SonicMatchesEntity&&const DeepCollectionEquality().equals(other.sonicMatch, sonicMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(sonicMatch));

@override
String toString() {
  return 'SonicMatchesEntity(sonicMatch: $sonicMatch)';
}


}

/// @nodoc
abstract mixin class $SonicMatchesEntityCopyWith<$Res>  {
  factory $SonicMatchesEntityCopyWith(SonicMatchesEntity value, $Res Function(SonicMatchesEntity) _then) = _$SonicMatchesEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'sonicMatch') List<SonicMatch> sonicMatch
});




}
/// @nodoc
class _$SonicMatchesEntityCopyWithImpl<$Res>
    implements $SonicMatchesEntityCopyWith<$Res> {
  _$SonicMatchesEntityCopyWithImpl(this._self, this._then);

  final SonicMatchesEntity _self;
  final $Res Function(SonicMatchesEntity) _then;

/// Create a copy of SonicMatchesEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sonicMatch = null,}) {
  return _then(_self.copyWith(
sonicMatch: null == sonicMatch ? _self.sonicMatch : sonicMatch // ignore: cast_nullable_to_non_nullable
as List<SonicMatch>,
  ));
}

}


/// Adds pattern-matching-related methods to [SonicMatchesEntity].
extension SonicMatchesEntityPatterns on SonicMatchesEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SonicMatchesEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SonicMatchesEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SonicMatchesEntity value)  $default,){
final _that = this;
switch (_that) {
case _SonicMatchesEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SonicMatchesEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SonicMatchesEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'sonicMatch')  List<SonicMatch> sonicMatch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SonicMatchesEntity() when $default != null:
return $default(_that.sonicMatch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'sonicMatch')  List<SonicMatch> sonicMatch)  $default,) {final _that = this;
switch (_that) {
case _SonicMatchesEntity():
return $default(_that.sonicMatch);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'sonicMatch')  List<SonicMatch> sonicMatch)?  $default,) {final _that = this;
switch (_that) {
case _SonicMatchesEntity() when $default != null:
return $default(_that.sonicMatch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SonicMatchesEntity implements SonicMatchesEntity {
  const _SonicMatchesEntity({@JsonKey(name: 'sonicMatch') final  List<SonicMatch> sonicMatch = const []}): _sonicMatch = sonicMatch;
  factory _SonicMatchesEntity.fromJson(Map<String, dynamic> json) => _$SonicMatchesEntityFromJson(json);

/// List of sonic matches
 final  List<SonicMatch> _sonicMatch;
/// List of sonic matches
@override@JsonKey(name: 'sonicMatch') List<SonicMatch> get sonicMatch {
  if (_sonicMatch is EqualUnmodifiableListView) return _sonicMatch;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sonicMatch);
}


/// Create a copy of SonicMatchesEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SonicMatchesEntityCopyWith<_SonicMatchesEntity> get copyWith => __$SonicMatchesEntityCopyWithImpl<_SonicMatchesEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SonicMatchesEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SonicMatchesEntity&&const DeepCollectionEquality().equals(other._sonicMatch, _sonicMatch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_sonicMatch));

@override
String toString() {
  return 'SonicMatchesEntity(sonicMatch: $sonicMatch)';
}


}

/// @nodoc
abstract mixin class _$SonicMatchesEntityCopyWith<$Res> implements $SonicMatchesEntityCopyWith<$Res> {
  factory _$SonicMatchesEntityCopyWith(_SonicMatchesEntity value, $Res Function(_SonicMatchesEntity) _then) = __$SonicMatchesEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'sonicMatch') List<SonicMatch> sonicMatch
});




}
/// @nodoc
class __$SonicMatchesEntityCopyWithImpl<$Res>
    implements _$SonicMatchesEntityCopyWith<$Res> {
  __$SonicMatchesEntityCopyWithImpl(this._self, this._then);

  final _SonicMatchesEntity _self;
  final $Res Function(_SonicMatchesEntity) _then;

/// Create a copy of SonicMatchesEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sonicMatch = null,}) {
  return _then(_SonicMatchesEntity(
sonicMatch: null == sonicMatch ? _self._sonicMatch : sonicMatch // ignore: cast_nullable_to_non_nullable
as List<SonicMatch>,
  ));
}


}

// dart format on
