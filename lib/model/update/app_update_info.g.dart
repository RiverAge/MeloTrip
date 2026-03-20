// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUpdateInfo _$AppUpdateInfoFromJson(Map<String, dynamic> json) =>
    _AppUpdateInfo(
      versionName: json['versionName'] as String,
      versionCode: (json['versionCode'] as num).toInt(),
      sha256: json['sha256'] as String,
      fileSize: (json['fileSize'] as num).toInt(),
      downloadUrl: json['downloadUrl'] as String,
      changelog: json['changelog'] as String,
    );

Map<String, dynamic> _$AppUpdateInfoToJson(_AppUpdateInfo instance) =>
    <String, dynamic>{
      'versionName': instance.versionName,
      'versionCode': instance.versionCode,
      'sha256': instance.sha256,
      'fileSize': instance.fileSize,
      'downloadUrl': instance.downloadUrl,
      'changelog': instance.changelog,
    };
