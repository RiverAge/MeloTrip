// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String?,
  isAdmin: json['isAdmin'] as bool?,
  name: json['name'] as String?,
  subsonicSalt: json['subsonicSalt'] as String?,
  subsonicToken: json['subsonicToken'] as String?,
  token: json['token'] as String?,
  username: json['username'] as String?,
  host: json['host'] as String?,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'isAdmin': instance.isAdmin,
  'name': instance.name,
  'subsonicSalt': instance.subsonicSalt,
  'subsonicToken': instance.subsonicToken,
  'token': instance.token,
  'username': instance.username,
  'host': instance.host,
};
