import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/github_release_parser.dart';

void main() {
  group('GitHubReleaseParser', () {
    late GitHubReleaseParser parser;

    setUp(() {
      parser = GitHubReleaseParser();
    });

    group('parseRelease', () {
      test('parses new MELOTRIP_UPDATE_METADATA format correctly', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.android.apk=app-release.apk
sha256.android.apk=abc123def456
size.android.apk=1048576
asset.windows.zip=melotrip-windows-x64.zip
sha256.windows.zip=win123sha256
size.windows.zip=2097152
MELOTRIP_UPDATE_METADATA -->

## Changelog
- Bug fixes
- Performance improvements
''',
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/app-release.apk',
              'size': 1048576,
            },
            {
              'name': 'melotrip-windows-x64.zip',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/melotrip-windows-x64.zip',
              'size': 2097152,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'android',
          packageType: 'apk',
        );

        expect(info.versionName, equals('1.0.10'));
        expect(info.versionCode, equals(11));
        expect(info.sha256, equals('abc123def456'));
        expect(info.fileSize, equals(1048576));
        expect(
          info.downloadUrl,
          contains('app-release.apk'),
        );
        expect(info.changelog, contains('Bug fixes'));
        expect(info.changelog, isNot(contains('MELOTRIP_UPDATE_METADATA')));
      });

      test('parses legacy METADATA format correctly for Android', () {
        final releaseJson = {
          'tag_name': 'v1.0.9',
          'body': '''
<!-- METADATA
Version: 1.0.9
Build: 10
SHA256: legacy123sha
Size: 524288
METADATA -->

## Release Notes
- Initial release
''',
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.9/app-release.apk',
              'size': 524288,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'android',
          packageType: 'apk',
        );

        expect(info.versionName, equals('1.0.9'));
        expect(info.versionCode, equals(10));
        expect(info.sha256, equals('legacy123sha'));
        expect(info.fileSize, equals(524288));
      });

      test('extracts version from tag when metadata version is missing', () {
        final releaseJson = {
          'tag_name': 'v2.0.0',
          'body': '', // No metadata block
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url': 'https://example.com/app-release.apk',
              'size': 1024,
            },
          ],
        };

        // This should throw because versionCode is required
        expect(
          () => parser.parseRelease(
            releaseJson: releaseJson,
            platform: 'android',
            packageType: 'apk',
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('selects correct asset for Windows platform', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.windows.zip=melotrip-windows-x64.zip
sha256.windows.zip=winsha256
size.windows.zip=2097152
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'melotrip-windows-x64.zip',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/melotrip-windows-x64.zip',
              'size': 2097152,
            },
            {
              'name': 'app-release.apk',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/app-release.apk',
              'size': 1048576,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'windows',
          packageType: 'zip',
        );

        expect(info.downloadUrl, contains('melotrip-windows-x64.zip'));
        expect(info.sha256, equals('winsha256'));
        expect(info.fileSize, equals(2097152));
      });

      test('selects correct asset for Linux platform', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.linux.tar.gz=melotrip-linux-x64.tar.gz
sha256.linux.tar.gz=linuxsha256
size.linux.tar.gz=1572864
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'melotrip-linux-x64.tar.gz',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/melotrip-linux-x64.tar.gz',
              'size': 1572864,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'linux',
          packageType: 'tar.gz',
        );

        expect(info.downloadUrl, contains('melotrip-linux-x64.tar.gz'));
        expect(info.sha256, equals('linuxsha256'));
        expect(info.fileSize, equals(1572864));
      });

      test('selects correct asset for macOS platform', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.macos.zip=melotrip-macos.zip
sha256.macos.zip=macossha256
size.macos.zip=2621440
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'melotrip-macos.zip',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/melotrip-macos.zip',
              'size': 2621440,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'macos',
          packageType: 'zip',
        );

        expect(info.downloadUrl, contains('melotrip-macos.zip'));
        expect(info.sha256, equals('macossha256'));
        expect(info.fileSize, equals(2621440));
      });

      test('throws when release has no tag_name', () {
        final releaseJson = {
          'body': '',
          'assets': [],
        };

        expect(
          () => parser.parseRelease(
            releaseJson: releaseJson,
            platform: 'android',
            packageType: 'apk',
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('throws when release has no assets', () {
        final releaseJson = {
          'tag_name': 'v1.0.0',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.0
versionCode=1
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [],
        };

        expect(
          () => parser.parseRelease(
            releaseJson: releaseJson,
            platform: 'android',
            packageType: 'apk',
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('throws when matching asset not found', () {
        final releaseJson = {
          'tag_name': 'v1.0.0',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.0
versionCode=1
asset.android.apk=different-name.apk
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url': 'https://example.com/app-release.apk',
              'size': 1024,
            },
          ],
        };

        expect(
          () => parser.parseRelease(
            releaseJson: releaseJson,
            platform: 'android',
            packageType: 'apk',
          ),
          throwsA(isA<StateError>()),
        );
      });

      test('uses asset size when metadata size is missing', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.android.apk=app-release.apk
sha256.android.apk=somehash
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url': 'https://example.com/app-release.apk',
              'size': 2048576,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'android',
          packageType: 'apk',
        );

        expect(info.fileSize, equals(2048576));
      });

      test('removes both metadata blocks from changelog', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.android.apk=app-release.apk
MELOTRIP_UPDATE_METADATA -->

<!-- METADATA
Old metadata block
METADATA -->

## What's New
- Feature A
- Bug fix B
''',
          'assets': [
            {
              'name': 'app-release.apk',
              'browser_download_url': 'https://example.com/app-release.apk',
              'size': 1024,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'android',
          packageType: 'apk',
        );

        expect(info.changelog, isNot(contains('MELOTRIP_UPDATE_METADATA')));
        expect(info.changelog, isNot(contains('METADATA')));
        expect(info.changelog, contains("What's New"));
      });

      test('supports tar.gz package type with custom asset name', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
asset.linux.tar.gz=custom-linux-release.tar.gz
sha256.linux.tar.gz=linuxsha256
size.linux.tar.gz=1572864
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'custom-linux-release.tar.gz',
              'browser_download_url':
                  'https://github.com/RiverAge/MeloTrip/releases/download/v1.0.10/custom-linux-release.tar.gz',
              'size': 1572864,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'linux',
          packageType: 'tar.gz',
        );

        expect(info.downloadUrl, contains('custom-linux-release.tar.gz'));
        expect(info.sha256, equals('linuxsha256'));
        expect(info.fileSize, equals(1572864));
      });
    });

    group('platform asset selection', () {
      test('uses default asset name when not specified in metadata', () {
        final releaseJson = {
          'tag_name': 'v1.0.10',
          'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.10
versionCode=11
MELOTRIP_UPDATE_METADATA -->
''',
          'assets': [
            {
              'name': 'melotrip-windows-x64.zip',
              'browser_download_url': 'https://example.com/melotrip-windows-x64.zip',
              'size': 2097152,
            },
          ],
        };

        final info = parser.parseRelease(
          releaseJson: releaseJson,
          platform: 'windows',
          packageType: 'zip',
        );

        expect(info.downloadUrl, contains('melotrip-windows-x64.zip'));
      });
    });
  });
}
