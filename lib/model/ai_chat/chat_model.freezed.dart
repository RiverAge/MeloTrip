// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatModel {

 String? get id; String? get object;@JsonKey(name: 'owned_by') String? get ownedBy; int? get created; int get maxTokens;
/// Create a copy of ChatModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatModelCopyWith<ChatModel> get copyWith => _$ChatModelCopyWithImpl<ChatModel>(this as ChatModel, _$identity);

  /// Serializes this ChatModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatModel&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.created, created) || other.created == created)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,ownedBy,created,maxTokens);

@override
String toString() {
  return 'ChatModel(id: $id, object: $object, ownedBy: $ownedBy, created: $created, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class $ChatModelCopyWith<$Res>  {
  factory $ChatModelCopyWith(ChatModel value, $Res Function(ChatModel) _then) = _$ChatModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? object,@JsonKey(name: 'owned_by') String? ownedBy, int? created, int maxTokens
});




}
/// @nodoc
class _$ChatModelCopyWithImpl<$Res>
    implements $ChatModelCopyWith<$Res> {
  _$ChatModelCopyWithImpl(this._self, this._then);

  final ChatModel _self;
  final $Res Function(ChatModel) _then;

/// Create a copy of ChatModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? object = freezed,Object? ownedBy = freezed,Object? created = freezed,Object? maxTokens = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,object: freezed == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String?,ownedBy: freezed == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ChatModel].
extension ChatModelPatterns on ChatModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChatModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChatModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChatModel value)  $default,){
final _that = this;
switch (_that) {
case _ChatModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChatModel value)?  $default,){
final _that = this;
switch (_that) {
case _ChatModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? object, @JsonKey(name: 'owned_by')  String? ownedBy,  int? created,  int maxTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChatModel() when $default != null:
return $default(_that.id,_that.object,_that.ownedBy,_that.created,_that.maxTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? object, @JsonKey(name: 'owned_by')  String? ownedBy,  int? created,  int maxTokens)  $default,) {final _that = this;
switch (_that) {
case _ChatModel():
return $default(_that.id,_that.object,_that.ownedBy,_that.created,_that.maxTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? object, @JsonKey(name: 'owned_by')  String? ownedBy,  int? created,  int maxTokens)?  $default,) {final _that = this;
switch (_that) {
case _ChatModel() when $default != null:
return $default(_that.id,_that.object,_that.ownedBy,_that.created,_that.maxTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChatModel implements ChatModel {
  const _ChatModel({this.id, this.object, @JsonKey(name: 'owned_by') this.ownedBy, this.created, this.maxTokens = 4096});
  factory _ChatModel.fromJson(Map<String, dynamic> json) => _$ChatModelFromJson(json);

@override final  String? id;
@override final  String? object;
@override@JsonKey(name: 'owned_by') final  String? ownedBy;
@override final  int? created;
@override@JsonKey() final  int maxTokens;

/// Create a copy of ChatModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatModelCopyWith<_ChatModel> get copyWith => __$ChatModelCopyWithImpl<_ChatModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChatModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatModel&&(identical(other.id, id) || other.id == id)&&(identical(other.object, object) || other.object == object)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.created, created) || other.created == created)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,object,ownedBy,created,maxTokens);

@override
String toString() {
  return 'ChatModel(id: $id, object: $object, ownedBy: $ownedBy, created: $created, maxTokens: $maxTokens)';
}


}

/// @nodoc
abstract mixin class _$ChatModelCopyWith<$Res> implements $ChatModelCopyWith<$Res> {
  factory _$ChatModelCopyWith(_ChatModel value, $Res Function(_ChatModel) _then) = __$ChatModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? object,@JsonKey(name: 'owned_by') String? ownedBy, int? created, int maxTokens
});




}
/// @nodoc
class __$ChatModelCopyWithImpl<$Res>
    implements _$ChatModelCopyWith<$Res> {
  __$ChatModelCopyWithImpl(this._self, this._then);

  final _ChatModel _self;
  final $Res Function(_ChatModel) _then;

/// Create a copy of ChatModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? object = freezed,Object? ownedBy = freezed,Object? created = freezed,Object? maxTokens = null,}) {
  return _then(_ChatModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,object: freezed == object ? _self.object : object // ignore: cast_nullable_to_non_nullable
as String?,ownedBy: freezed == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as int?,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
