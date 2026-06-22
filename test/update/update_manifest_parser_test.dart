import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/update_manifest_parser.dart';

void main() {
  group('UpdateManifestParser', () {
    late UpdateManifestParser parser;

    setUp(() {
      parser = UpdateManifestParser();
    });

    test('parses matching platform package', () {
      final manifestJson = <String, dynamic>{
        'versionName': '1.0.12',
        'versionCode': 13,
        'changelog': 'notes',
        'platforms': <String, dynamic>{
          'windows': <String, dynamic>{
            'packageType': 'zip',
            'assetName': 'melotrip-windows-x64.zip',
            'downloadUrl': 'https://example.com/melotrip-windows-x64.zip',
            'sha256': 'abc123',
            'fileSize': 1024,
          },
        },
      };

      final info = parser.parseManifest(
        manifestJson: manifestJson,
        platform: 'windows',
        packageType: 'zip',
      );

      expect(info.versionName, '1.0.12');
      expect(info.versionCode, 13);
      expect(info.downloadUrl, contains('melotrip-windows-x64.zip'));
      expect(info.sha256, 'abc123');
      expect(info.fileSize, 1024);
      expect(info.changelog, 'notes');
    });

    test('derives download url from repository and tag', () {
      final manifestJson = <String, dynamic>{
        'repository': 'RiverAge/MeloTrip',
        'tagName': 'v1.0.12',
        'versionName': '1.0.12',
        'versionCode': 13,
        'platforms': <String, dynamic>{
          'linux': <String, dynamic>{
            'packageType': 'tar.gz',
            'assetName': 'melotrip-linux-x64.tar.gz',
            'sha256': 'linux-sha',
            'size': 2048,
          },
        },
      };

      final info = parser.parseManifest(
        manifestJson: manifestJson,
        platform: 'linux',
        packageType: 'tar.gz',
      );

      expect(
        info.downloadUrl,
        'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.12/'
        'melotrip-linux-x64.tar.gz',
      );
      expect(info.fileSize, 2048);
    });

    test('throws when package type does not match', () {
      final manifestJson = <String, dynamic>{
        'versionName': '1.0.12',
        'versionCode': 13,
        'platforms': <String, dynamic>{
          'windows': <String, dynamic>{'packageType': 'zip'},
        },
      };

      expect(
        () => parser.parseManifest(
          manifestJson: manifestJson,
          platform: 'windows',
          packageType: 'apk',
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
