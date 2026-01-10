// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_completion_chunk.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatCompletionChunk {

 String? get id; String? get object; int? get created; String? get model; List<ChatCompletionChunkChoice>? get choices; ChatCompletionChunkUsage? get usage;
/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCompletionChunkCopyWith<ChatCompletionChunk> get copyWith => _$ChatCompletionChunkCopyWithImpl<ChatCompletionChunk>(this as ChatCompletionChunk, _$identity);

  /// Serializes this ChatCompletionChunk to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCompletionChunk&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other.choices, choices)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,created,model,const DeepCollectionEquality().hash(choices),usage);

@override
String toString() {
  return 'ChatCompletionChunk(id: $id, object: $object, created: $created, model: $model, choices: $choices, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $ChatCompletionChunkCopyWith<$Res>  {
  factory $ChatCompletionChunkCopyWith(ChatCompletionChunk value, $Res Function(ChatCompletionChunk) _then) = _$ChatCompletionChunkCopyWithImpl;
@useResult
$Res call({
 String? id, String? object, int? created, String? model, List<ChatCompletionChunkChoice>? choices, ChatCompletionChunkUsage? usage
});


$ChatCompletionChunkUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class _$ChatCompletionChunkCopyWithImpl<$Res>
    implements $ChatCompletionChunkCopyWith<$Res> {
  _$ChatCompletionChunkCopyWithImpl(this._self, this._then);

  final ChatCompletionChunk _self;
  final $Res Function(ChatCompletionChunk) _then;

/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? object = freezed,Object? created = freezed,Object? model = freezed,Object? choices = freezed,Object? usage = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,object: freezed == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,choices: freezed == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<ChatCompletionChunkChoice>?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkUsage?,
  ));
}
/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $ChatCompletionChunkUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatCompletionChunk].
extension ChatCompletionChunkPatterns on ChatCompletionChunk {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCompletionChunk value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCompletionChunk() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCompletionChunk value)  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunk():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCompletionChunk value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunk() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? object,  int? created,  String? model,  List<ChatCompletionChunkChoice>? choices,  ChatCompletionChunkUsage? usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCompletionChunk() when $default != null:
return $default(_that.id,_that.object,_that.created,_that.model,_that.choices,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? object,  int? created,  String? model,  List<ChatCompletionChunkChoice>? choices,  ChatCompletionChunkUsage? usage)  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunk():
return $default(_that.id,_that.object,_that.created,_that.model,_that.choices,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? object,  int? created,  String? model,  List<ChatCompletionChunkChoice>? choices,  ChatCompletionChunkUsage? usage)?  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunk() when $default != null:
return $default(_that.id,_that.object,_that.created,_that.model,_that.choices,_that.usage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCompletionChunk implements ChatCompletionChunk {
  const _ChatCompletionChunk({this.id, this.object, this.created, this.model, final  List<ChatCompletionChunkChoice>? choices, this.usage}): _choices = choices;
  factory _ChatCompletionChunk.fromJson(Map<String, dynamic> json) => _$ChatCompletionChunkFromJson(json);

@override final  String? id;
@override final  String? object;
@override final  int? created;
@override final  String? model;
 final  List<ChatCompletionChunkChoice>? _choices;
@override List<ChatCompletionChunkChoice>? get choices {
  final value = _choices;
  if (value == null) return null;
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ChatCompletionChunkUsage? usage;

/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCompletionChunkCopyWith<_ChatCompletionChunk> get copyWith => __$ChatCompletionChunkCopyWithImpl<_ChatCompletionChunk>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCompletionChunkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCompletionChunk&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.created, created) || other.created == created)&&(identical(other.model, model) || other.model == model)&&const DeepCollectionEquality().equals(other._choices, _choices)&&(identical(other.usage, usage) || other.usage == usage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,created,model,const DeepCollectionEquality().hash(_choices),usage);

@override
String toString() {
  return 'ChatCompletionChunk(id: $id, object: $object, created: $created, model: $model, choices: $choices, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$ChatCompletionChunkCopyWith<$Res> implements $ChatCompletionChunkCopyWith<$Res> {
  factory _$ChatCompletionChunkCopyWith(_ChatCompletionChunk value, $Res Function(_ChatCompletionChunk) _then) = __$ChatCompletionChunkCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? object, int? created, String? model, List<ChatCompletionChunkChoice>? choices, ChatCompletionChunkUsage? usage
});


@override $ChatCompletionChunkUsageCopyWith<$Res>? get usage;

}
/// @nodoc
class __$ChatCompletionChunkCopyWithImpl<$Res>
    implements _$ChatCompletionChunkCopyWith<$Res> {
  __$ChatCompletionChunkCopyWithImpl(this._self, this._then);

  final _ChatCompletionChunk _self;
  final $Res Function(_ChatCompletionChunk) _then;

/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? object = freezed,Object? created = freezed,Object? model = freezed,Object? choices = freezed,Object? usage = freezed,}) {
  return _then(_ChatCompletionChunk(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,object: freezed == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,choices: freezed == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<ChatCompletionChunkChoice>?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkUsage?,
  ));
}

/// Create a copy of ChatCompletionChunk
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkUsageCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $ChatCompletionChunkUsageCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// @nodoc
mixin _$ChatCompletionChunkChoice {

 num? get index; ChatCompletionChunkChoiceDelta? get delta; ChatCompletionChunkChoiceDelta? get message; String? get logprobs;@JsonKey(name: 'finish_reason') String? get finishReason;@JsonKey(name: 'matched_stop') num? get matchedStop;
/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceCopyWith<ChatCompletionChunkChoice> get copyWith => _$ChatCompletionChunkChoiceCopyWithImpl<ChatCompletionChunkChoice>(this as ChatCompletionChunkChoice, _$identity);

  /// Serializes this ChatCompletionChunkChoice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCompletionChunkChoice&&(identical(other.index, index) || other.index == index)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.message, message) || other.message == message)&&(identical(other.logprobs, logprobs) || other.logprobs == logprobs)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason)&&(identical(other.matchedStop, matchedStop) || other.matchedStop == matchedStop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,delta,message,logprobs,finishReason,matchedStop);

@override
String toString() {
  return 'ChatCompletionChunkChoice(index: $index, delta: $delta, message: $message, logprobs: $logprobs, finishReason: $finishReason, matchedStop: $matchedStop)';
}


}

/// @nodoc
abstract mixin class $ChatCompletionChunkChoiceCopyWith<$Res>  {
  factory $ChatCompletionChunkChoiceCopyWith(ChatCompletionChunkChoice value, $Res Function(ChatCompletionChunkChoice) _then) = _$ChatCompletionChunkChoiceCopyWithImpl;
@useResult
$Res call({
 num? index, ChatCompletionChunkChoiceDelta? delta, ChatCompletionChunkChoiceDelta? message, String? logprobs,@JsonKey(name: 'finish_reason') String? finishReason,@JsonKey(name: 'matched_stop') num? matchedStop
});


$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get delta;$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get message;

}
/// @nodoc
class _$ChatCompletionChunkChoiceCopyWithImpl<$Res>
    implements $ChatCompletionChunkChoiceCopyWith<$Res> {
  _$ChatCompletionChunkChoiceCopyWithImpl(this._self, this._then);

  final ChatCompletionChunkChoice _self;
  final $Res Function(ChatCompletionChunkChoice) _then;

/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? index = freezed,Object? delta = freezed,Object? message = freezed,Object? logprobs = freezed,Object? finishReason = freezed,Object? matchedStop = freezed,}) {
  return _then(_self.copyWith(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as num?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkChoiceDelta?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkChoiceDelta?,logprobs: freezed == logprobs ? _self.logprobs : logprobs // ignore: cast_nullable_to_non_nullable
as String?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,matchedStop: freezed == matchedStop ? _self.matchedStop : matchedStop // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}
/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get delta {
    if (_self.delta == null) {
    return null;
  }

  return $ChatCompletionChunkChoiceDeltaCopyWith<$Res>(_self.delta!, (value) {
    return _then(_self.copyWith(delta: value));
  });
}/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $ChatCompletionChunkChoiceDeltaCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChatCompletionChunkChoice].
extension ChatCompletionChunkChoicePatterns on ChatCompletionChunkChoice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCompletionChunkChoice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCompletionChunkChoice value)  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCompletionChunkChoice value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( num? index,  ChatCompletionChunkChoiceDelta? delta,  ChatCompletionChunkChoiceDelta? message,  String? logprobs, @JsonKey(name: 'finish_reason')  String? finishReason, @JsonKey(name: 'matched_stop')  num? matchedStop)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice() when $default != null:
return $default(_that.index,_that.delta,_that.message,_that.logprobs,_that.finishReason,_that.matchedStop);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( num? index,  ChatCompletionChunkChoiceDelta? delta,  ChatCompletionChunkChoiceDelta? message,  String? logprobs, @JsonKey(name: 'finish_reason')  String? finishReason, @JsonKey(name: 'matched_stop')  num? matchedStop)  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice():
return $default(_that.index,_that.delta,_that.message,_that.logprobs,_that.finishReason,_that.matchedStop);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( num? index,  ChatCompletionChunkChoiceDelta? delta,  ChatCompletionChunkChoiceDelta? message,  String? logprobs, @JsonKey(name: 'finish_reason')  String? finishReason, @JsonKey(name: 'matched_stop')  num? matchedStop)?  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoice() when $default != null:
return $default(_that.index,_that.delta,_that.message,_that.logprobs,_that.finishReason,_that.matchedStop);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCompletionChunkChoice implements ChatCompletionChunkChoice {
  const _ChatCompletionChunkChoice({this.index, this.delta, this.message, this.logprobs, @JsonKey(name: 'finish_reason') this.finishReason, @JsonKey(name: 'matched_stop') this.matchedStop});
  factory _ChatCompletionChunkChoice.fromJson(Map<String, dynamic> json) => _$ChatCompletionChunkChoiceFromJson(json);

@override final  num? index;
@override final  ChatCompletionChunkChoiceDelta? delta;
@override final  ChatCompletionChunkChoiceDelta? message;
@override final  String? logprobs;
@override@JsonKey(name: 'finish_reason') final  String? finishReason;
@override@JsonKey(name: 'matched_stop') final  num? matchedStop;

/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCompletionChunkChoiceCopyWith<_ChatCompletionChunkChoice> get copyWith => __$ChatCompletionChunkChoiceCopyWithImpl<_ChatCompletionChunkChoice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCompletionChunkChoiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCompletionChunkChoice&&(identical(other.index, index) || other.index == index)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.message, message) || other.message == message)&&(identical(other.logprobs, logprobs) || other.logprobs == logprobs)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason)&&(identical(other.matchedStop, matchedStop) || other.matchedStop == matchedStop));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,index,delta,message,logprobs,finishReason,matchedStop);

@override
String toString() {
  return 'ChatCompletionChunkChoice(index: $index, delta: $delta, message: $message, logprobs: $logprobs, finishReason: $finishReason, matchedStop: $matchedStop)';
}


}

/// @nodoc
abstract mixin class _$ChatCompletionChunkChoiceCopyWith<$Res> implements $ChatCompletionChunkChoiceCopyWith<$Res> {
  factory _$ChatCompletionChunkChoiceCopyWith(_ChatCompletionChunkChoice value, $Res Function(_ChatCompletionChunkChoice) _then) = __$ChatCompletionChunkChoiceCopyWithImpl;
@override @useResult
$Res call({
 num? index, ChatCompletionChunkChoiceDelta? delta, ChatCompletionChunkChoiceDelta? message, String? logprobs,@JsonKey(name: 'finish_reason') String? finishReason,@JsonKey(name: 'matched_stop') num? matchedStop
});


@override $ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get delta;@override $ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get message;

}
/// @nodoc
class __$ChatCompletionChunkChoiceCopyWithImpl<$Res>
    implements _$ChatCompletionChunkChoiceCopyWith<$Res> {
  __$ChatCompletionChunkChoiceCopyWithImpl(this._self, this._then);

  final _ChatCompletionChunkChoice _self;
  final $Res Function(_ChatCompletionChunkChoice) _then;

/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? index = freezed,Object? delta = freezed,Object? message = freezed,Object? logprobs = freezed,Object? finishReason = freezed,Object? matchedStop = freezed,}) {
  return _then(_ChatCompletionChunkChoice(
index: freezed == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as num?,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkChoiceDelta?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as ChatCompletionChunkChoiceDelta?,logprobs: freezed == logprobs ? _self.logprobs : logprobs // ignore: cast_nullable_to_non_nullable
as String?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,matchedStop: freezed == matchedStop ? _self.matchedStop : matchedStop // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get delta {
    if (_self.delta == null) {
    return null;
  }

  return $ChatCompletionChunkChoiceDeltaCopyWith<$Res>(_self.delta!, (value) {
    return _then(_self.copyWith(delta: value));
  });
}/// Create a copy of ChatCompletionChunkChoice
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceDeltaCopyWith<$Res>? get message {
    if (_self.message == null) {
    return null;
  }

  return $ChatCompletionChunkChoiceDeltaCopyWith<$Res>(_self.message!, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// @nodoc
mixin _$ChatCompletionChunkChoiceDelta {

 String? get role; String? get content;@JsonKey(name: 'reasoning_content') String? get reasoningContent;@JsonKey(name: 'tool_calls') String? get toolCalls;
/// Create a copy of ChatCompletionChunkChoiceDelta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCompletionChunkChoiceDeltaCopyWith<ChatCompletionChunkChoiceDelta> get copyWith => _$ChatCompletionChunkChoiceDeltaCopyWithImpl<ChatCompletionChunkChoiceDelta>(this as ChatCompletionChunkChoiceDelta, _$identity);

  /// Serializes this ChatCompletionChunkChoiceDelta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCompletionChunkChoiceDelta&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.toolCalls, toolCalls) || other.toolCalls == toolCalls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content,reasoningContent,toolCalls);

@override
String toString() {
  return 'ChatCompletionChunkChoiceDelta(role: $role, content: $content, reasoningContent: $reasoningContent, toolCalls: $toolCalls)';
}


}

/// @nodoc
abstract mixin class $ChatCompletionChunkChoiceDeltaCopyWith<$Res>  {
  factory $ChatCompletionChunkChoiceDeltaCopyWith(ChatCompletionChunkChoiceDelta value, $Res Function(ChatCompletionChunkChoiceDelta) _then) = _$ChatCompletionChunkChoiceDeltaCopyWithImpl;
@useResult
$Res call({
 String? role, String? content,@JsonKey(name: 'reasoning_content') String? reasoningContent,@JsonKey(name: 'tool_calls') String? toolCalls
});




}
/// @nodoc
class _$ChatCompletionChunkChoiceDeltaCopyWithImpl<$Res>
    implements $ChatCompletionChunkChoiceDeltaCopyWith<$Res> {
  _$ChatCompletionChunkChoiceDeltaCopyWithImpl(this._self, this._then);

  final ChatCompletionChunkChoiceDelta _self;
  final $Res Function(ChatCompletionChunkChoiceDelta) _then;

/// Create a copy of ChatCompletionChunkChoiceDelta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? content = freezed,Object? reasoningContent = freezed,Object? toolCalls = freezed,}) {
  return _then(_self.copyWith(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,toolCalls: freezed == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCompletionChunkChoiceDelta].
extension ChatCompletionChunkChoiceDeltaPatterns on ChatCompletionChunkChoiceDelta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCompletionChunkChoiceDelta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCompletionChunkChoiceDelta value)  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCompletionChunkChoiceDelta value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? role,  String? content, @JsonKey(name: 'reasoning_content')  String? reasoningContent, @JsonKey(name: 'tool_calls')  String? toolCalls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta() when $default != null:
return $default(_that.role,_that.content,_that.reasoningContent,_that.toolCalls);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? role,  String? content, @JsonKey(name: 'reasoning_content')  String? reasoningContent, @JsonKey(name: 'tool_calls')  String? toolCalls)  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta():
return $default(_that.role,_that.content,_that.reasoningContent,_that.toolCalls);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? role,  String? content, @JsonKey(name: 'reasoning_content')  String? reasoningContent, @JsonKey(name: 'tool_calls')  String? toolCalls)?  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkChoiceDelta() when $default != null:
return $default(_that.role,_that.content,_that.reasoningContent,_that.toolCalls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCompletionChunkChoiceDelta implements ChatCompletionChunkChoiceDelta {
  const _ChatCompletionChunkChoiceDelta({this.role, this.content, @JsonKey(name: 'reasoning_content') this.reasoningContent, @JsonKey(name: 'tool_calls') this.toolCalls});
  factory _ChatCompletionChunkChoiceDelta.fromJson(Map<String, dynamic> json) => _$ChatCompletionChunkChoiceDeltaFromJson(json);

@override final  String? role;
@override final  String? content;
@override@JsonKey(name: 'reasoning_content') final  String? reasoningContent;
@override@JsonKey(name: 'tool_calls') final  String? toolCalls;

/// Create a copy of ChatCompletionChunkChoiceDelta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCompletionChunkChoiceDeltaCopyWith<_ChatCompletionChunkChoiceDelta> get copyWith => __$ChatCompletionChunkChoiceDeltaCopyWithImpl<_ChatCompletionChunkChoiceDelta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCompletionChunkChoiceDeltaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCompletionChunkChoiceDelta&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.toolCalls, toolCalls) || other.toolCalls == toolCalls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content,reasoningContent,toolCalls);

@override
String toString() {
  return 'ChatCompletionChunkChoiceDelta(role: $role, content: $content, reasoningContent: $reasoningContent, toolCalls: $toolCalls)';
}


}

/// @nodoc
abstract mixin class _$ChatCompletionChunkChoiceDeltaCopyWith<$Res> implements $ChatCompletionChunkChoiceDeltaCopyWith<$Res> {
  factory _$ChatCompletionChunkChoiceDeltaCopyWith(_ChatCompletionChunkChoiceDelta value, $Res Function(_ChatCompletionChunkChoiceDelta) _then) = __$ChatCompletionChunkChoiceDeltaCopyWithImpl;
@override @useResult
$Res call({
 String? role, String? content,@JsonKey(name: 'reasoning_content') String? reasoningContent,@JsonKey(name: 'tool_calls') String? toolCalls
});




}
/// @nodoc
class __$ChatCompletionChunkChoiceDeltaCopyWithImpl<$Res>
    implements _$ChatCompletionChunkChoiceDeltaCopyWith<$Res> {
  __$ChatCompletionChunkChoiceDeltaCopyWithImpl(this._self, this._then);

  final _ChatCompletionChunkChoiceDelta _self;
  final $Res Function(_ChatCompletionChunkChoiceDelta) _then;

/// Create a copy of ChatCompletionChunkChoiceDelta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? content = freezed,Object? reasoningContent = freezed,Object? toolCalls = freezed,}) {
  return _then(_ChatCompletionChunkChoiceDelta(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,toolCalls: freezed == toolCalls ? _self.toolCalls : toolCalls // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatCompletionChunkUsage {

@JsonKey(name: 'prompt_tokens') num? get promptTokens;@JsonKey(name: 'total_tokens') num? get totalTokens;@JsonKey(name: 'completion_tokens') num? get completionTokens;@JsonKey(name: 'prompt_tokens_details') String? get promptTokensDetails;@JsonKey(name: 'reasoning_tokens') num? get reasoningTokens;
/// Create a copy of ChatCompletionChunkUsage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCompletionChunkUsageCopyWith<ChatCompletionChunkUsage> get copyWith => _$ChatCompletionChunkUsageCopyWithImpl<ChatCompletionChunkUsage>(this as ChatCompletionChunkUsage, _$identity);

  /// Serializes this ChatCompletionChunkUsage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCompletionChunkUsage&&(identical(other.promptTokens, promptTokens) || other.promptTokens == promptTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens)&&(identical(other.completionTokens, completionTokens) || other.completionTokens == completionTokens)&&(identical(other.promptTokensDetails, promptTokensDetails) || other.promptTokensDetails == promptTokensDetails)&&(identical(other.reasoningTokens, reasoningTokens) || other.reasoningTokens == reasoningTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokens,totalTokens,completionTokens,promptTokensDetails,reasoningTokens);

@override
String toString() {
  return 'ChatCompletionChunkUsage(promptTokens: $promptTokens, totalTokens: $totalTokens, completionTokens: $completionTokens, promptTokensDetails: $promptTokensDetails, reasoningTokens: $reasoningTokens)';
}


}

/// @nodoc
abstract mixin class $ChatCompletionChunkUsageCopyWith<$Res>  {
  factory $ChatCompletionChunkUsageCopyWith(ChatCompletionChunkUsage value, $Res Function(ChatCompletionChunkUsage) _then) = _$ChatCompletionChunkUsageCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'prompt_tokens') num? promptTokens,@JsonKey(name: 'total_tokens') num? totalTokens,@JsonKey(name: 'completion_tokens') num? completionTokens,@JsonKey(name: 'prompt_tokens_details') String? promptTokensDetails,@JsonKey(name: 'reasoning_tokens') num? reasoningTokens
});




}
/// @nodoc
class _$ChatCompletionChunkUsageCopyWithImpl<$Res>
    implements $ChatCompletionChunkUsageCopyWith<$Res> {
  _$ChatCompletionChunkUsageCopyWithImpl(this._self, this._then);

  final ChatCompletionChunkUsage _self;
  final $Res Function(ChatCompletionChunkUsage) _then;

/// Create a copy of ChatCompletionChunkUsage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? promptTokens = freezed,Object? totalTokens = freezed,Object? completionTokens = freezed,Object? promptTokensDetails = freezed,Object? reasoningTokens = freezed,}) {
  return _then(_self.copyWith(
promptTokens: freezed == promptTokens ? _self.promptTokens : promptTokens // ignore: cast_nullable_to_non_nullable
as num?,totalTokens: freezed == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as num?,completionTokens: freezed == completionTokens ? _self.completionTokens : completionTokens // ignore: cast_nullable_to_non_nullable
as num?,promptTokensDetails: freezed == promptTokensDetails ? _self.promptTokensDetails : promptTokensDetails // ignore: cast_nullable_to_non_nullable
as String?,reasoningTokens: freezed == reasoningTokens ? _self.reasoningTokens : reasoningTokens // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCompletionChunkUsage].
extension ChatCompletionChunkUsagePatterns on ChatCompletionChunkUsage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCompletionChunkUsage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCompletionChunkUsage value)  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCompletionChunkUsage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'prompt_tokens')  num? promptTokens, @JsonKey(name: 'total_tokens')  num? totalTokens, @JsonKey(name: 'completion_tokens')  num? completionTokens, @JsonKey(name: 'prompt_tokens_details')  String? promptTokensDetails, @JsonKey(name: 'reasoning_tokens')  num? reasoningTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage() when $default != null:
return $default(_that.promptTokens,_that.totalTokens,_that.completionTokens,_that.promptTokensDetails,_that.reasoningTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'prompt_tokens')  num? promptTokens, @JsonKey(name: 'total_tokens')  num? totalTokens, @JsonKey(name: 'completion_tokens')  num? completionTokens, @JsonKey(name: 'prompt_tokens_details')  String? promptTokensDetails, @JsonKey(name: 'reasoning_tokens')  num? reasoningTokens)  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage():
return $default(_that.promptTokens,_that.totalTokens,_that.completionTokens,_that.promptTokensDetails,_that.reasoningTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'prompt_tokens')  num? promptTokens, @JsonKey(name: 'total_tokens')  num? totalTokens, @JsonKey(name: 'completion_tokens')  num? completionTokens, @JsonKey(name: 'prompt_tokens_details')  String? promptTokensDetails, @JsonKey(name: 'reasoning_tokens')  num? reasoningTokens)?  $default,) {final _that = this;
switch (_that) {
case _ChatCompletionChunkUsage() when $default != null:
return $default(_that.promptTokens,_that.totalTokens,_that.completionTokens,_that.promptTokensDetails,_that.reasoningTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCompletionChunkUsage implements ChatCompletionChunkUsage {
  const _ChatCompletionChunkUsage({@JsonKey(name: 'prompt_tokens') this.promptTokens, @JsonKey(name: 'total_tokens') this.totalTokens, @JsonKey(name: 'completion_tokens') this.completionTokens, @JsonKey(name: 'prompt_tokens_details') this.promptTokensDetails, @JsonKey(name: 'reasoning_tokens') this.reasoningTokens});
  factory _ChatCompletionChunkUsage.fromJson(Map<String, dynamic> json) => _$ChatCompletionChunkUsageFromJson(json);

@override@JsonKey(name: 'prompt_tokens') final  num? promptTokens;
@override@JsonKey(name: 'total_tokens') final  num? totalTokens;
@override@JsonKey(name: 'completion_tokens') final  num? completionTokens;
@override@JsonKey(name: 'prompt_tokens_details') final  String? promptTokensDetails;
@override@JsonKey(name: 'reasoning_tokens') final  num? reasoningTokens;

/// Create a copy of ChatCompletionChunkUsage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCompletionChunkUsageCopyWith<_ChatCompletionChunkUsage> get copyWith => __$ChatCompletionChunkUsageCopyWithImpl<_ChatCompletionChunkUsage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCompletionChunkUsageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCompletionChunkUsage&&(identical(other.promptTokens, promptTokens) || other.promptTokens == promptTokens)&&(identical(other.totalTokens, totalTokens) || other.totalTokens == totalTokens)&&(identical(other.completionTokens, completionTokens) || other.completionTokens == completionTokens)&&(identical(other.promptTokensDetails, promptTokensDetails) || other.promptTokensDetails == promptTokensDetails)&&(identical(other.reasoningTokens, reasoningTokens) || other.reasoningTokens == reasoningTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,promptTokens,totalTokens,completionTokens,promptTokensDetails,reasoningTokens);

@override
String toString() {
  return 'ChatCompletionChunkUsage(promptTokens: $promptTokens, totalTokens: $totalTokens, completionTokens: $completionTokens, promptTokensDetails: $promptTokensDetails, reasoningTokens: $reasoningTokens)';
}


}

/// @nodoc
abstract mixin class _$ChatCompletionChunkUsageCopyWith<$Res> implements $ChatCompletionChunkUsageCopyWith<$Res> {
  factory _$ChatCompletionChunkUsageCopyWith(_ChatCompletionChunkUsage value, $Res Function(_ChatCompletionChunkUsage) _then) = __$ChatCompletionChunkUsageCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'prompt_tokens') num? promptTokens,@JsonKey(name: 'total_tokens') num? totalTokens,@JsonKey(name: 'completion_tokens') num? completionTokens,@JsonKey(name: 'prompt_tokens_details') String? promptTokensDetails,@JsonKey(name: 'reasoning_tokens') num? reasoningTokens
});




}
/// @nodoc
class __$ChatCompletionChunkUsageCopyWithImpl<$Res>
    implements _$ChatCompletionChunkUsageCopyWith<$Res> {
  __$ChatCompletionChunkUsageCopyWithImpl(this._self, this._then);

  final _ChatCompletionChunkUsage _self;
  final $Res Function(_ChatCompletionChunkUsage) _then;

/// Create a copy of ChatCompletionChunkUsage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? promptTokens = freezed,Object? totalTokens = freezed,Object? completionTokens = freezed,Object? promptTokensDetails = freezed,Object? reasoningTokens = freezed,}) {
  return _then(_ChatCompletionChunkUsage(
promptTokens: freezed == promptTokens ? _self.promptTokens : promptTokens // ignore: cast_nullable_to_non_nullable
as num?,totalTokens: freezed == totalTokens ? _self.totalTokens : totalTokens // ignore: cast_nullable_to_non_nullable
as num?,completionTokens: freezed == completionTokens ? _self.completionTokens : completionTokens // ignore: cast_nullable_to_non_nullable
as num?,promptTokensDetails: freezed == promptTokensDetails ? _self.promptTokensDetails : promptTokensDetails // ignore: cast_nullable_to_non_nullable
as String?,reasoningTokens: freezed == reasoningTokens ? _self.reasoningTokens : reasoningTokens // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}

// dart format on
