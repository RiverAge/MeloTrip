// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanStatusEntityImpl _$$ScanStatusEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$ScanStatusEntityImpl(
      scanning: json['scanning'] as bool?,
      count: (json['count'] as num?)?.toInt(),
      folderCount: (json['folderCount'] as num?)?.toInt(),
      lastScan: json['lastScan'] == null
          ? null
          : DateTime.parse(json['lastScan'] as String),
    );

Map<String, dynamic> _$$ScanStatusEntityImplToJson(
        _$ScanStatusEntityImpl instance) =>
    <String, dynamic>{
      'scanning': instance.scanning,
      'count': instance.count,
      'folderCount': instance.folderCount,
      'lastScan': instance.lastScan?.toIso8601String(),
    };
