import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:melo_trip/update/update_installer_gateway.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
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

  test('downloadAndVerifyPackage resumes from partial file via Range', () async {
    _setUpdateTestPlatform();
    _useMockPathProvider();
    // 远端"文件"是 0..99 共 100 字节。预先写好前 40 字节作为半成品，
    // 期望下载时带上 Range: bytes=40- 并只取剩余 60 字节 append。
    final full = List<int>.generate(100, (i) => i);
    final adapter = _RangeBytesAdapter(
      url: 'https://example.com/pkg.zip',
      bytes: full,
    );
    final dio = Dio()..httpClientAdapter = adapter;

    final service = AppUpdateService(
      manifestUrl: 'https://example.com/update.json',
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    // 准备半成品文件：写入前 40 字节，复刻断点续传的本地状态。
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pkg.zip');
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(full.sublist(0, 40));
    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    const update = AppUpdateInfo(
      versionName: '1.0.2',
      versionCode: 3,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/pkg.zip',
      changelog: '',
    );

    final result = await service.downloadAndVerifyPackage(update: update);

    expect(await result.length(), 100);
    expect(await result.readAsBytes(), equals(full));
    // 关键：发起了带 Range 的请求，且起始字节正是 40。
    expect(adapter.rangeRequests, contains('bytes=40-'));
  });

  test('downloadAndVerifyPackage falls back to full download on 200', () async {
    _setUpdateTestPlatform();
    _useMockPathProvider();
    // 服务器忽略 Range、回 200 给全量。本地半成品应被覆盖重下。
    final full = List<int>.generate(100, (i) => i);
    final adapter = _RangeBytesAdapter(
      url: 'https://example.com/pkg.zip',
      bytes: full,
      ignoreRange: true, // 始终返回 200 + 全量
    );
    final dio = Dio()..httpClientAdapter = adapter;

    final service = AppUpdateService(
      manifestUrl: 'https://example.com/update.json',
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pkg.zip');
    if (await file.exists()) {
      await file.delete();
    }
    await file.writeAsBytes(full.sublist(0, 40)); // 脏的半成品
    addTearDown(() async {
      if (await file.exists()) {
        await file.delete();
      }
    });

    const update = AppUpdateInfo(
      versionName: '1.0.2',
      versionCode: 3,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/pkg.zip',
      changelog: '',
    );

    final result = await service.downloadAndVerifyPackage(update: update);
    // 全量覆盖后内容正确，没有 append 造成的重复。
    expect(await result.readAsBytes(), equals(full));
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

/// 支持断点续传的二进制 adapter：带 Range 头的请求回 206 + 对应切片；
/// [ignoreRange]=true 时一律回 200 + 全量（模拟服务器不支持续传）。
class _RangeBytesAdapter implements HttpClientAdapter {
  _RangeBytesAdapter({
    required this.url,
    required this.bytes,
    this.ignoreRange = false,
  });

  final String url;
  final List<int> bytes;
  final bool ignoreRange;
  final List<String> rangeRequests = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (options.uri.toString() != url) {
      return ResponseBody.fromBytes(
        utf8.encode('not found'),
        404,
        headers: {Headers.contentTypeHeader: <String>['text/plain']},
      );
    }

    final range = options.headers['Range'] as String?;
    if (range != null) {
      rangeRequests.add(range);
    }

    if (ignoreRange || range == null) {
      return _body(bytes, 200, total: bytes.length);
    }

    final startMatch = RegExp(r'bytes=(\d+)-').firstMatch(range);
    final start = startMatch != null ? int.parse(startMatch.group(1)!) : 0;
    final slice = start < bytes.length ? bytes.sublist(start) : <int>[];
    return _body(slice, 206, total: bytes.length, start: start);
  }

  ResponseBody _body(
    List<int> data,
    int status, {
    required int total,
    int start = 0,
  }) {
    final headers = <String, List<String>>{
      Headers.contentLengthHeader: <String>['${data.length}'],
      Headers.contentTypeHeader: <String>['application/octet-stream'],
    };
    if (status == 206) {
      headers['Content-Range'] = <String>['bytes $start-${total - 1}/$total'];
    }
    return ResponseBody.fromBytes(data, status, headers: headers);
  }
}

/// 把临时目录指向系统 temp 的 mock，避免依赖原生 path_provider 插件。
class _MockPathProvider extends PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => Directory.systemTemp.path;

  @override
  Future<String?> getApplicationSupportPath() async =>
      Directory.systemTemp.path;

  @override
  Future<String?> getApplicationDocumentsPath() async =>
      Directory.systemTemp.path;
}

void _useMockPathProvider() {
  PathProviderPlatform.instance = _MockPathProvider();
}
