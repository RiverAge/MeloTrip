import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/app_update_service.dart';

void main() {
  group('AppUpdateInfo', () {
    test('fromJson parses correctly', () {
      final json = {
        'versionName': '1.0.0',
        'versionCode': 100,
        'sha256': 'abc123',
        'fileSize': 1024,
        'downloadUrl': 'https://example.com/update.apk',
        'changelog': 'Bug fixes',
      };

      final info = AppUpdateInfo.fromJson(json);
      
      expect(info.versionName, equals('1.0.0'));
      expect(info.versionCode, equals(100));
      expect(info.sha256, equals('abc123'));
      expect(info.fileSize, equals(1024));
      expect(info.downloadUrl, contains('example.com'));
      expect(info.changelog, contains('Bug fixes'));
    });

    test('fromJson handles string numbers', () {
      final json = {
        'versionName': '1.0.0',
        'versionCode': '100',
        'sha256': 'abc',
        'fileSize': '1024',
        'downloadUrl': 'url',
        'changelog': '',
      };

      final info = AppUpdateInfo.fromJson(json);
      expect(info.versionCode, equals(100));
      expect(info.fileSize, equals(1024));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};
      final info = AppUpdateInfo.fromJson(json);
      
      expect(info.versionName, equals(''));
      expect(info.versionCode, equals(0));
      expect(info.sha256, equals(''));
      expect(info.fileSize, equals(0));
    });
  });

  group('AppUpdateCheckResult', () {
    test('creates result with no update', () {
      final result = AppUpdateCheckResult(
        currentVersionName: '1.0.0',
        currentVersionCode: 99,
        remote: null,
        hasUpdate: false,
      );

      expect(result.currentVersionName, equals('1.0.0'));
      expect(result.currentVersionCode, equals(99));
      expect(result.remote, isNull);
      expect(result.hasUpdate, isFalse);
    });

    test('creates result with update available', () {
      final remote = AppUpdateInfo(
        versionName: '1.0.1',
        versionCode: 100,
        sha256: 'abc',
        fileSize: 1024,
        downloadUrl: 'url',
        changelog: '',
      );

      final result = AppUpdateCheckResult(
        currentVersionName: '1.0.0',
        currentVersionCode: 99,
        remote: remote,
        hasUpdate: true,
      );

      expect(result.hasUpdate, isTrue);
      expect(result.remote?.versionName, equals('1.0.1'));
    });
  });

  group('UpdateDownloadStage enum', () {
    test('has downloading and verifying values', () {
      expect(UpdateDownloadStage.downloading, isNotNull);
      expect(UpdateDownloadStage.verifying, isNotNull);
    });
  });
}
