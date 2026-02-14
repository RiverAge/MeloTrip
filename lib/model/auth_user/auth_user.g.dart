// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  salt: json['salt'] as String?,
  token: json['token'] as String?,
  username: json['username'] as String?,
  host: json['host'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'salt': instance.salt,
  'token': instance.token,
  'username': instance.username,
  'host': instance.host,
};
