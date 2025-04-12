// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Auth _$AuthFromJson(Map<String, dynamic> json) => _Auth(
  id: json['id'] as String?,
  isAdmin: json['isAdmin'] as bool?,
  lastFmApiKey: json['lastFmApiKey'] as String?,
  name: json['name'] as String?,
  subsonicSalt: json['subsonicSalt'] as String?,
  subsonicToken: json['subsonicToken'] as String?,
  token: json['token'] as String?,
  username: json['username'] as String?,
  host: json['host'] as String?,
);

Map<String, dynamic> _$AuthToJson(_Auth instance) => <String, dynamic>{
  'id': instance.id,
  'isAdmin': instance.isAdmin,
  'lastFmApiKey': instance.lastFmApiKey,
  'name': instance.name,
  'subsonicSalt': instance.subsonicSalt,
  'subsonicToken': instance.subsonicToken,
  'token': instance.token,
  'username': instance.username,
  'host': instance.host,
};
