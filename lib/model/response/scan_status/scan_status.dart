import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_status.freezed.dart';
part 'scan_status.g.dart';

@freezed
abstract class ScanStatusEntity with _$ScanStatusEntity {
  const factory ScanStatusEntity({
    bool? scanning,
    int? count,
    int? folderCount,
    DateTime? lastScan,
  }) = _ScanStatusEntity;

  factory ScanStatusEntity.fromJson(Map<String, Object?> json) =>
      _$ScanStatusEntityFromJson(json);
}
