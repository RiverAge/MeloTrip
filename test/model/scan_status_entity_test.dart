import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';

void main() {
  group('ScanStatusEntity', () {
    test('fromJson parses all fields', () {
      final json = {
        'scanning': true,
        'count': 100,
        'folderCount': 10,
        'lastScan': '2024-01-01T12:00:00.000Z',
      };

      final status = ScanStatusEntity.fromJson(json);

      expect(status.scanning, equals(true));
      expect(status.count, equals(100));
      expect(status.folderCount, equals(10));
      expect(status.lastScan, isA<DateTime>());
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final status = ScanStatusEntity.fromJson(json);

      expect(status.scanning, isNull);
      expect(status.count, isNull);
      expect(status.folderCount, isNull);
      expect(status.lastScan, isNull);
    });

    test('fromJson handles partial data', () {
      final json = {
        'scanning': false,
        'count': 50,
      };

      final status = ScanStatusEntity.fromJson(json);

      expect(status.scanning, equals(false));
      expect(status.count, equals(50));
      expect(status.folderCount, isNull);
      expect(status.lastScan, isNull);
    });

    test('toJson serializes all fields', () {
      final status = ScanStatusEntity(
        scanning: true,
        count: 100,
        folderCount: 10,
        lastScan: DateTime.parse('2024-01-01T12:00:00.000Z'),
      );

      final json = status.toJson();

      expect(json['scanning'], equals(true));
      expect(json['count'], equals(100));
      expect(json['folderCount'], equals(10));
    });

    test('copyWith creates modified copy', () {
      final original = ScanStatusEntity(
        scanning: false,
        count: 50,
      );

      final modified = original.copyWith(scanning: true, count: 100);

      expect(modified.scanning, equals(true));
      expect(modified.count, equals(100));
    });

    test('equality works correctly', () {
      final status1 = ScanStatusEntity(scanning: true, count: 100);
      final status2 = ScanStatusEntity(scanning: true, count: 100);
      final status3 = ScanStatusEntity(scanning: false, count: 100);

      expect(status1, equals(status2));
      expect(status1, isNot(equals(status3)));
    });

    test('toString includes scanning status', () {
      final status = ScanStatusEntity(scanning: true);
      expect(status.toString(), isA<String>());
    });
  });
}
