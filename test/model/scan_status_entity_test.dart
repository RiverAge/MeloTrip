import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';

void main() {
  group('ScanStatusEntity', () {
    test('fromJson creates instance with correct values', () {
      final json = {
        'scanning': true,
        'count': 100,
        'folderCount': 10,
        'lastScan': '2024-01-01T12:00:00Z',
      };

      final entity = ScanStatusEntity.fromJson(json);

      expect(entity.scanning, true);
      expect(entity.count, 100);
      expect(entity.folderCount, 10);
      expect(entity.lastScan, isA<DateTime>());
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final entity = ScanStatusEntity.fromJson(json);

      expect(entity.scanning, null);
      expect(entity.count, null);
      expect(entity.folderCount, null);
      expect(entity.lastScan, null);
    });

    test('copyWith creates new instance with updated values', () {
      final original = ScanStatusEntity(
        scanning: false,
        count: 50,
        folderCount: 5,
      );

      final copy = original.copyWith(
        scanning: true,
        count: 100,
      );

      expect(copy.scanning, true);
      expect(copy.count, 100);
      expect(copy.folderCount, 5);
    });
  });
}
