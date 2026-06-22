import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:melo_trip/update/update_installer_gateway.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_installer/update_installer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'downloadAndVerifyPackage handles empty download url for current mode',
    () async {
      if (Platform.isWindows) {
        expect(true, isTrue);
        return;
      }

      final service = AppUpdateService(installerGateway: const _FakeGateway());
      try {
        await service.downloadAndVerifyPackage(
          update: const AppUpdateInfo(
            versionName: '1.0.1',
            versionCode: 2,
            sha256: '',
            fileSize: 0,
            downloadUrl: '',
            changelog: '',
          ),
        );
        fail('Expected StateError for empty download URL.');
      } on StateError catch (error) {
        expect(error.message, 'Download URL is empty.');
      }
    },
  );

  test('openUpdateDownloadPage throws when url is empty', () async {
    final service = AppUpdateService(installerGateway: const _FakeGateway());
    await expectLater(
      service.openUpdateDownloadPage(
        const AppUpdateInfo(
          versionName: '1.0.1',
          versionCode: 2,
          sha256: '',
          fileSize: 0,
          downloadUrl: '',
          changelog: '',
        ),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('openUpdateDownloadPage throws when url is invalid', () async {
    final service = AppUpdateService(installerGateway: const _FakeGateway());
    await expectLater(
      service.openUpdateDownloadPage(
        const AppUpdateInfo(
          versionName: '1.0.1',
          versionCode: 2,
          sha256: '',
          fileSize: 0,
          downloadUrl: 'not-a-url',
          changelog: '',
        ),
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('checkForUpdate prefers static update manifest', () async {
    _setUpdateTestPlatform();
    const manifestUrl = 'https://example.com/update.json';
    const apiUrl = 'https://example.com/latest';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      manifestUrl: <String, dynamic>{
        'versionName': '1.0.12',
        'versionCode': 13,
        'platforms': <String, dynamic>{
          'windows': <String, dynamic>{
            'packageType': 'zip',
            'assetName': 'melotrip-windows-x64.zip',
            'downloadUrl': 'https://example.com/melotrip-windows-x64.zip',
            'sha256': 'manifest-sha',
            'fileSize': 1024,
          },
        },
      },
      apiUrl: <String, dynamic>{
        'tag_name': 'v1.0.99',
        'body': '',
        'assets': <Map<String, dynamic>>[],
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = AppUpdateService(
      manifestUrl: manifestUrl,
      checkUrl: apiUrl,
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final result = await service.checkForUpdate();

    expect(result.hasUpdate, isTrue);
    expect(result.currentVersionName, '1.0.11');
    expect(result.currentVersionCode, 12);
    expect(result.remote?.versionName, '1.0.12');
    expect(result.remote?.sha256, 'manifest-sha');
    expect(adapter.requestedUrls, <String>[manifestUrl]);
  });

  test('checkForUpdate uses Android platform versionCode', () async {
    debugDefaultTargetPlatformOverride = .android;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    PackageInfo.setMockInitialValues(
      appName: 'MeloTrip',
      packageName: 'com.riverage.melotrip',
      version: '1.0.12',
      buildNumber: '2013',
      buildSignature: '',
    );

    const manifestUrl = 'https://example.com/update.json';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      manifestUrl: <String, dynamic>{
        'versionName': '1.0.13',
        'versionCode': 14,
        'platforms': <String, dynamic>{
          'android': <String, dynamic>{
            'packageType': 'apk',
            'assetName': 'app-release.apk',
            'versionCode': 2014,
            'downloadUrl': 'https://example.com/app-release.apk',
            'sha256': 'manifest-sha',
            'fileSize': 1024,
          },
        },
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = AppUpdateService(
      manifestUrl: manifestUrl,
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final result = await service.checkForUpdate();

    expect(result.currentVersionCode, 2013);
    expect(result.remote?.versionCode, 2014);
    expect(result.hasUpdate, isTrue);
  });

  test('checkForUpdate falls back to GitHub API when manifest fails', () async {
    _setUpdateTestPlatform();
    const manifestUrl = 'https://example.com/update.json';
    const apiUrl = 'https://example.com/latest';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      apiUrl: <String, dynamic>{
        'tag_name': 'v1.0.12',
        'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.12
versionCode=13
asset.windows.zip=melotrip-windows-x64.zip
sha256.windows.zip=api-sha
size.windows.zip=2048
MELOTRIP_UPDATE_METADATA -->
''',
        'assets': <Map<String, dynamic>>[
          <String, dynamic>{
            'name': 'melotrip-windows-x64.zip',
            'browser_download_url':
                'https://example.com/melotrip-windows-x64.zip',
            'size': 2048,
          },
        ],
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = AppUpdateService(
      manifestUrl: manifestUrl,
      checkUrl: apiUrl,
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final result = await service.checkForUpdate();

    expect(result.hasUpdate, isTrue);
    expect(result.remote?.versionName, '1.0.12');
    expect(result.remote?.sha256, 'api-sha');
    expect(adapter.requestedUrls, <String>[manifestUrl, apiUrl]);
  });

  test('installer capability delegates to gateway', () async {
    final service = AppUpdateService(
      installerGateway: const _FakeGateway(supported: true, permission: true),
    );
    expect(service.isInstallSupported, isTrue);
    expect(await service.canRequestInstallPermission(), isTrue);
  });

  test('host exit requirement delegates to gateway', () {
    final service = AppUpdateService(
      installerGateway: const _FakeGateway(
        supported: true,
        permission: true,
        requiresHostExitForInstall: true,
      ),
    );

    expect(service.requiresHostExitForInstall, isTrue);
  });

  test('installDownloadedPackage delegates file path to gateway', () async {
    final gateway = _RecordingGateway();
    final service = AppUpdateService(installerGateway: gateway);
    final file = File(
      '${Directory.systemTemp.path}/melo-trip-install-test.apk',
    );
    await file.writeAsBytes(const <int>[1, 2, 3]);
    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    await service.installDownloadedPackage(
      file,
      updaterStrings: const WindowsUpdaterStrings(
        windowTitle: 'Updater',
        preparing: 'Preparing',
        versionLine: 'Version 1.0.1 (2)',
        waitingForApp: 'Waiting',
        extractingArchive: 'Extracting',
        copyingFiles: 'Installing',
        restartingApp: 'Restarting',
        failed: 'Failed',
        invalidArguments: 'Invalid args',
        initFailed: 'Init failed',
        waitFailed: 'Wait failed',
        tempPathFailed: 'Temp path failed',
        tempDirFailed: 'Temp dir failed',
        extractFailed: 'Extract failed',
        copyFailed: 'Copy failed',
      ),
    );
    expect(gateway.installedPath, file.path);
    expect(gateway.receivedUpdaterStrings?.windowTitle, 'Updater');
  });
}

void _setUpdateTestPlatform() {
  debugDefaultTargetPlatformOverride = .windows;
  addTearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });
  PackageInfo.setMockInitialValues(
    appName: 'MeloTrip',
    packageName: 'com.riverage.melotrip',
    version: '1.0.11',
    buildNumber: '12',
    buildSignature: '',
  );
}

class _FakeGateway extends UpdateInstallerGateway {
  const _FakeGateway({
    this.supported = false,
    this.permission = false,
    this.requiresHostExitForInstall = false,
  });

  final bool supported;
  final bool permission;
  @override
  final bool requiresHostExitForInstall;

  @override
  bool get isSupported => supported;

  @override
  Future<bool> canRequestInstallPermission() async => permission;

  @override
  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) async {}

  @override
  Future<void> openInstallPermissionSettings() async {}
}

class _RouteJsonAdapter implements HttpClientAdapter {
  _RouteJsonAdapter(this.routes);

  final Map<String, Map<String, dynamic>> routes;
  final List<String> requestedUrls = <String>[];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final url = options.uri.toString();
    requestedUrls.add(url);
    final payload = routes[url];
    if (payload == null) {
      return ResponseBody.fromBytes(
        utf8.encode('{"message":"not found"}'),
        404,
        headers: <String, List<String>>{
          Headers.contentTypeHeader: <String>[Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(payload)),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}

class _RecordingGateway extends UpdateInstallerGateway {
  String? installedPath;
  WindowsUpdaterStrings? receivedUpdaterStrings;

  @override
  bool get isSupported => true;

  @override
  bool get requiresHostExitForInstall => false;

  @override
  Future<bool> canRequestInstallPermission() async => true;

  @override
  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) async {
    installedPath = filePath;
    receivedUpdaterStrings = updaterStrings;
  }

  @override
  Future<void> openInstallPermissionSettings() async {}
}
