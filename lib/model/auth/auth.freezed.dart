// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Auth {

 String? get id; bool? get isAdmin; String? get lastFmApiKey; String? get name; String? get subsonicSalt; String? get subsonicToken; String? get token; String? get username; String? get host;
/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthCopyWith<Auth> get copyWith => _$AuthCopyWithImpl<Auth>(this as Auth, _$identity);

  /// Serializes this Auth to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Auth&&(identical(other.id, id) || other.id == id)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.lastFmApiKey, lastFmApiKey) || other.lastFmApiKey == lastFmApiKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.subsonicSalt, subsonicSalt) || other.subsonicSalt == subsonicSalt)&&(identical(other.subsonicToken, subsonicToken) || other.subsonicToken == subsonicToken)&&(identical(other.token, token) || other.token == token)&&(identical(other.username, username) || other.username == username)&&(identical(other.host, host) || other.host == host));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isAdmin,lastFmApiKey,name,subsonicSalt,subsonicToken,token,username,host);

@override
String toString() {
  return 'Auth(id: $id, isAdmin: $isAdmin, lastFmApiKey: $lastFmApiKey, name: $name, subsonicSalt: $subsonicSalt, subsonicToken: $subsonicToken, token: $token, username: $username, host: $host)';
}


}

/// @nodoc
abstract mixin class $AuthCopyWith<$Res>  {
  factory $AuthCopyWith(Auth value, $Res Function(Auth) _then) = _$AuthCopyWithImpl;
@useResult
$Res call({
 String? id, bool? isAdmin, String? lastFmApiKey, String? name, String? subsonicSalt, String? subsonicToken, String? token, String? username, String? host
});




}
/// @nodoc
class _$AuthCopyWithImpl<$Res>
    implements $AuthCopyWith<$Res> {
  _$AuthCopyWithImpl(this._self, this._then);

  final Auth _self;
  final $Res Function(Auth) _then;

/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? isAdmin = freezed,Object? lastFmApiKey = freezed,Object? name = freezed,Object? subsonicSalt = freezed,Object? subsonicToken = freezed,Object? token = freezed,Object? username = freezed,Object? host = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,lastFmApiKey: freezed == lastFmApiKey ? _self.lastFmApiKey : lastFmApiKey // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,subsonicSalt: freezed == subsonicSalt ? _self.subsonicSalt : subsonicSalt // ignore: cast_nullable_to_non_nullable
as String?,subsonicToken: freezed == subsonicToken ? _self.subsonicToken : subsonicToken // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Auth implements Auth {
  const _Auth({this.id, this.isAdmin, this.lastFmApiKey, this.name, this.subsonicSalt, this.subsonicToken, this.token, this.username, this.host});
  factory _Auth.fromJson(Map<String, dynamic> json) => _$AuthFromJson(json);

@override final  String? id;
@override final  bool? isAdmin;
@override final  String? lastFmApiKey;
@override final  String? name;
@override final  String? subsonicSalt;
@override final  String? subsonicToken;
@override final  String? token;
@override final  String? username;
@override final  String? host;

/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthCopyWith<_Auth> get copyWith => __$AuthCopyWithImpl<_Auth>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Auth&&(identical(other.id, id) || other.id == id)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.lastFmApiKey, lastFmApiKey) || other.lastFmApiKey == lastFmApiKey)&&(identical(other.name, name) || other.name == name)&&(identical(other.subsonicSalt, subsonicSalt) || other.subsonicSalt == subsonicSalt)&&(identical(other.subsonicToken, subsonicToken) || other.subsonicToken == subsonicToken)&&(identical(other.token, token) || other.token == token)&&(identical(other.username, username) || other.username == username)&&(identical(other.host, host) || other.host == host));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,isAdmin,lastFmApiKey,name,subsonicSalt,subsonicToken,token,username,host);

@override
String toString() {
  return 'Auth(id: $id, isAdmin: $isAdmin, lastFmApiKey: $lastFmApiKey, name: $name, subsonicSalt: $subsonicSalt, subsonicToken: $subsonicToken, token: $token, username: $username, host: $host)';
}


}

/// @nodoc
abstract mixin class _$AuthCopyWith<$Res> implements $AuthCopyWith<$Res> {
  factory _$AuthCopyWith(_Auth value, $Res Function(_Auth) _then) = __$AuthCopyWithImpl;
@override @useResult
$Res call({
 String? id, bool? isAdmin, String? lastFmApiKey, String? name, String? subsonicSalt, String? subsonicToken, String? token, String? username, String? host
});




}
/// @nodoc
class __$AuthCopyWithImpl<$Res>
    implements _$AuthCopyWith<$Res> {
  __$AuthCopyWithImpl(this._self, this._then);

  final _Auth _self;
  final $Res Function(_Auth) _then;

/// Create a copy of Auth
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? isAdmin = freezed,Object? lastFmApiKey = freezed,Object? name = freezed,Object? subsonicSalt = freezed,Object? subsonicToken = freezed,Object? token = freezed,Object? username = freezed,Object? host = freezed,}) {
  return _then(_Auth(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,lastFmApiKey: freezed == lastFmApiKey ? _self.lastFmApiKey : lastFmApiKey // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,subsonicSalt: freezed == subsonicSalt ? _self.subsonicSalt : subsonicSalt // ignore: cast_nullable_to_non_nullable
as String?,subsonicToken: freezed == subsonicToken ? _self.subsonicToken : subsonicToken // ignore: cast_nullable_to_non_nullable
as String?,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,host: freezed == host ? _self.host : host // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
