// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatMessage {

 String get id; MessageRole get role; String get content;@JsonKey(name: 'reasoning_content') String? get reasoningContent; String? get model;@JsonKey(name: 'reasoning_duration') Duration? get reasoningDuration;@JsonKey(name: 'total_duration') Duration? get totalDuration;@EpochDateTimeConverter() DateTime get timestamp;@BooleanConvert()@JsonKey(name: 'is_streaming') bool get isStreaming; String? get error;
/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatMessageCopyWith<ChatMessage> get copyWith => _$ChatMessageCopyWithImpl<ChatMessage>(this as ChatMessage, _$identity);

  /// Serializes this ChatMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.model, model) || other.model == model)&&(identical(other.reasoningDuration, reasoningDuration) || other.reasoningDuration == reasoningDuration)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,model,reasoningDuration,totalDuration,timestamp,isStreaming,error);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, model: $model, reasoningDuration: $reasoningDuration, totalDuration: $totalDuration, timestamp: $timestamp, isStreaming: $isStreaming, error: $error)';
}


}

/// @nodoc
abstract mixin class $ChatMessageCopyWith<$Res>  {
  factory $ChatMessageCopyWith(ChatMessage value, $Res Function(ChatMessage) _then) = _$ChatMessageCopyWithImpl;
@useResult
$Res call({
 String id, MessageRole role, String content,@JsonKey(name: 'reasoning_content') String? reasoningContent, String? model,@JsonKey(name: 'reasoning_duration') Duration? reasoningDuration,@JsonKey(name: 'total_duration') Duration? totalDuration,@EpochDateTimeConverter() DateTime timestamp,@BooleanConvert()@JsonKey(name: 'is_streaming') bool isStreaming, String? error
});




}
/// @nodoc
class _$ChatMessageCopyWithImpl<$Res>
    implements $ChatMessageCopyWith<$Res> {
  _$ChatMessageCopyWithImpl(this._self, this._then);

  final ChatMessage _self;
  final $Res Function(ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? model = freezed,Object? reasoningDuration = freezed,Object? totalDuration = freezed,Object? timestamp = null,Object? isStreaming = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,reasoningDuration: freezed == reasoningDuration ? _self.reasoningDuration : reasoningDuration // ignore: cast_nullable_to_non_nullable
as Duration?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatMessage].
extension ChatMessagePatterns on ChatMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatMessage value)  $default,){
final _that = this;
switch (_that) {
case _ChatMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatMessage value)?  $default,){
final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MessageRole role,  String content, @JsonKey(name: 'reasoning_content')  String? reasoningContent,  String? model, @JsonKey(name: 'reasoning_duration')  Duration? reasoningDuration, @JsonKey(name: 'total_duration')  Duration? totalDuration, @EpochDateTimeConverter()  DateTime timestamp, @BooleanConvert()@JsonKey(name: 'is_streaming')  bool isStreaming,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.model,_that.reasoningDuration,_that.totalDuration,_that.timestamp,_that.isStreaming,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MessageRole role,  String content, @JsonKey(name: 'reasoning_content')  String? reasoningContent,  String? model, @JsonKey(name: 'reasoning_duration')  Duration? reasoningDuration, @JsonKey(name: 'total_duration')  Duration? totalDuration, @EpochDateTimeConverter()  DateTime timestamp, @BooleanConvert()@JsonKey(name: 'is_streaming')  bool isStreaming,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ChatMessage():
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.model,_that.reasoningDuration,_that.totalDuration,_that.timestamp,_that.isStreaming,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MessageRole role,  String content, @JsonKey(name: 'reasoning_content')  String? reasoningContent,  String? model, @JsonKey(name: 'reasoning_duration')  Duration? reasoningDuration, @JsonKey(name: 'total_duration')  Duration? totalDuration, @EpochDateTimeConverter()  DateTime timestamp, @BooleanConvert()@JsonKey(name: 'is_streaming')  bool isStreaming,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ChatMessage() when $default != null:
return $default(_that.id,_that.role,_that.content,_that.reasoningContent,_that.model,_that.reasoningDuration,_that.totalDuration,_that.timestamp,_that.isStreaming,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatMessage implements ChatMessage {
  const _ChatMessage({required this.id, required this.role, required this.content, @JsonKey(name: 'reasoning_content') this.reasoningContent, this.model, @JsonKey(name: 'reasoning_duration') this.reasoningDuration, @JsonKey(name: 'total_duration') this.totalDuration, @EpochDateTimeConverter() required this.timestamp, @BooleanConvert()@JsonKey(name: 'is_streaming') this.isStreaming = false, this.error});
  factory _ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);

@override final  String id;
@override final  MessageRole role;
@override final  String content;
@override@JsonKey(name: 'reasoning_content') final  String? reasoningContent;
@override final  String? model;
@override@JsonKey(name: 'reasoning_duration') final  Duration? reasoningDuration;
@override@JsonKey(name: 'total_duration') final  Duration? totalDuration;
@override@EpochDateTimeConverter() final  DateTime timestamp;
@override@BooleanConvert()@JsonKey(name: 'is_streaming') final  bool isStreaming;
@override final  String? error;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatMessageCopyWith<_ChatMessage> get copyWith => __$ChatMessageCopyWithImpl<_ChatMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.reasoningContent, reasoningContent) || other.reasoningContent == reasoningContent)&&(identical(other.model, model) || other.model == model)&&(identical(other.reasoningDuration, reasoningDuration) || other.reasoningDuration == reasoningDuration)&&(identical(other.totalDuration, totalDuration) || other.totalDuration == totalDuration)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.isStreaming, isStreaming) || other.isStreaming == isStreaming)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,role,content,reasoningContent,model,reasoningDuration,totalDuration,timestamp,isStreaming,error);

@override
String toString() {
  return 'ChatMessage(id: $id, role: $role, content: $content, reasoningContent: $reasoningContent, model: $model, reasoningDuration: $reasoningDuration, totalDuration: $totalDuration, timestamp: $timestamp, isStreaming: $isStreaming, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ChatMessageCopyWith<$Res> implements $ChatMessageCopyWith<$Res> {
  factory _$ChatMessageCopyWith(_ChatMessage value, $Res Function(_ChatMessage) _then) = __$ChatMessageCopyWithImpl;
@override @useResult
$Res call({
 String id, MessageRole role, String content,@JsonKey(name: 'reasoning_content') String? reasoningContent, String? model,@JsonKey(name: 'reasoning_duration') Duration? reasoningDuration,@JsonKey(name: 'total_duration') Duration? totalDuration,@EpochDateTimeConverter() DateTime timestamp,@BooleanConvert()@JsonKey(name: 'is_streaming') bool isStreaming, String? error
});




}
/// @nodoc
class __$ChatMessageCopyWithImpl<$Res>
    implements _$ChatMessageCopyWith<$Res> {
  __$ChatMessageCopyWithImpl(this._self, this._then);

  final _ChatMessage _self;
  final $Res Function(_ChatMessage) _then;

/// Create a copy of ChatMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? role = null,Object? content = null,Object? reasoningContent = freezed,Object? model = freezed,Object? reasoningDuration = freezed,Object? totalDuration = freezed,Object? timestamp = null,Object? isStreaming = null,Object? error = freezed,}) {
  return _then(_ChatMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as MessageRole,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,reasoningContent: freezed == reasoningContent ? _self.reasoningContent : reasoningContent // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,reasoningDuration: freezed == reasoningDuration ? _self.reasoningDuration : reasoningDuration // ignore: cast_nullable_to_non_nullable
as Duration?,totalDuration: freezed == totalDuration ? _self.totalDuration : totalDuration // ignore: cast_nullable_to_non_nullable
as Duration?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,isStreaming: null == isStreaming ? _self.isStreaming : isStreaming // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChatCoversation {

 String get id; String get title; List<ChatMessage> get messages;
/// Create a copy of ChatCoversation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatCoversationCopyWith<ChatCoversation> get copyWith => _$ChatCoversationCopyWithImpl<ChatCoversation>(this as ChatCoversation, _$identity);

  /// Serializes this ChatCoversation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatCoversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.messages, messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(messages));

@override
String toString() {
  return 'ChatCoversation(id: $id, title: $title, messages: $messages)';
}


}

/// @nodoc
abstract mixin class $ChatCoversationCopyWith<$Res>  {
  factory $ChatCoversationCopyWith(ChatCoversation value, $Res Function(ChatCoversation) _then) = _$ChatCoversationCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<ChatMessage> messages
});




}
/// @nodoc
class _$ChatCoversationCopyWithImpl<$Res>
    implements $ChatCoversationCopyWith<$Res> {
  _$ChatCoversationCopyWithImpl(this._self, this._then);

  final ChatCoversation _self;
  final $Res Function(ChatCoversation) _then;

/// Create a copy of ChatCoversation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? messages = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatCoversation].
extension ChatCoversationPatterns on ChatCoversation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatCoversation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatCoversation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatCoversation value)  $default,){
final _that = this;
switch (_that) {
case _ChatCoversation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatCoversation value)?  $default,){
final _that = this;
switch (_that) {
case _ChatCoversation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<ChatMessage> messages)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatCoversation() when $default != null:
return $default(_that.id,_that.title,_that.messages);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<ChatMessage> messages)  $default,) {final _that = this;
switch (_that) {
case _ChatCoversation():
return $default(_that.id,_that.title,_that.messages);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<ChatMessage> messages)?  $default,) {final _that = this;
switch (_that) {
case _ChatCoversation() when $default != null:
return $default(_that.id,_that.title,_that.messages);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatCoversation implements ChatCoversation {
  const _ChatCoversation({required this.id, required this.title, final  List<ChatMessage> messages = const []}): _messages = messages;
  factory _ChatCoversation.fromJson(Map<String, dynamic> json) => _$ChatCoversationFromJson(json);

@override final  String id;
@override final  String title;
 final  List<ChatMessage> _messages;
@override@JsonKey() List<ChatMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}


/// Create a copy of ChatCoversation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatCoversationCopyWith<_ChatCoversation> get copyWith => __$ChatCoversationCopyWithImpl<_ChatCoversation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatCoversationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatCoversation&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._messages, _messages));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_messages));

@override
String toString() {
  return 'ChatCoversation(id: $id, title: $title, messages: $messages)';
}


}

/// @nodoc
abstract mixin class _$ChatCoversationCopyWith<$Res> implements $ChatCoversationCopyWith<$Res> {
  factory _$ChatCoversationCopyWith(_ChatCoversation value, $Res Function(_ChatCoversation) _then) = __$ChatCoversationCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<ChatMessage> messages
});




}
/// @nodoc
class __$ChatCoversationCopyWithImpl<$Res>
    implements _$ChatCoversationCopyWith<$Res> {
  __$ChatCoversationCopyWithImpl(this._self, this._then);

  final _ChatCoversation _self;
  final $Res Function(_ChatCoversation) _then;

/// Create a copy of ChatCoversation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? messages = null,}) {
  return _then(_ChatCoversation(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<ChatMessage>,
  ));
}


}

// dart format on
