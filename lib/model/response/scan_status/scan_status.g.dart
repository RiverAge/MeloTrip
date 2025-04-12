// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanStatusEntity _$ScanStatusEntityFromJson(Map<String, dynamic> json) =>
    _ScanStatusEntity(
      scanning: json['scanning'] as bool?,
      count: (json['count'] as num?)?.toInt(),
      folderCount: (json['folderCount'] as num?)?.toInt(),
      lastScan:
          json['lastScan'] == null
              ? null
              : DateTime.parse(json['lastScan'] as String),
    );

Map<String, dynamic> _$ScanStatusEntityToJson(_ScanStatusEntity instance) =>
    <String, dynamic>{
      'scanning': instance.scanning,
      'count': instance.count,
      'folderCount': instance.folderCount,
      'lastScan': instance.lastScan?.toIso8601String(),
    };
