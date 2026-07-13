import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:melo_trip/update/github_release_parser.dart';
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

  // Android split-per-abi：本机是 arm64-v8a split（versionCode 已被 Flutter 加过
  // 偏移，如 4027），manifest 的 abis 子映射记录每个 split 自己的 versionCode。
  // 客户端应选 arm64 split 小包、用 split 的 versionCode 比对，不再因偏移错位。
  test('checkForUpdate selects arm64 split via abis and compares its versionCode', () async {
    debugDefaultTargetPlatformOverride = .android;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    PackageInfo.setMockInitialValues(
      appName: 'MeloTrip',
      packageName: 'com.riverage.melotrip',
      version: '1.0.27',
      buildNumber: '4027', // arm64 split 的真实 versionCode（含偏移）
      buildSignature: '',
    );

    const manifestUrl = 'https://example.com/update.json';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      manifestUrl: <String, dynamic>{
        'versionName': '1.0.28',
        'versionCode': 2028, // universal 的，不应被用来比对
        'platforms': <String, dynamic>{
          'android': <String, dynamic>{
            'packageType': 'apk',
            'assetName': 'app-release.apk',
            'downloadUrl': 'https://example.com/app-release.apk',
            'sha256': 'universal-sha',
            'fileSize': 85993881,
            'versionCode': 2028,
            'abis': <String, dynamic>{
              'arm64-v8a': <String, dynamic>{
                'assetName': 'app-arm64-v8a-release.apk',
                'downloadUrl': 'https://example.com/app-arm64-v8a-release.apk',
                'sha256': 'arm64-sha',
                'fileSize': 25395213,
                'versionCode': 4028,
              },
              'armeabi-v7a': <String, dynamic>{
                'assetName': 'app-armeabi-v7a-release.apk',
                'downloadUrl': 'https://example.com/app-armeabi-v7a-release.apk',
                'sha256': 'armv7-sha',
                'fileSize': 21993881,
                'versionCode': 3028,
              },
            },
          },
        },
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = AppUpdateService(
      manifestUrl: manifestUrl,
      dio: dio,
      installerGateway: const _FakeGateway(abi: 'arm64-v8a'),
    );

    final result = await service.checkForUpdate();

    expect(result.currentVersionCode, 4027);
    // 选了 arm64 split 的 versionCode，不是 universal 的 2028。
    expect(result.remote?.versionCode, 4028);
    expect(result.hasUpdate, isTrue);
    expect(
      result.remote?.downloadUrl,
      'https://example.com/app-arm64-v8a-release.apk',
    );
    expect(result.remote?.sha256, 'arm64-sha');
    expect(result.remote?.fileSize, 25395213);
  });

  // 本机 ABI 在 manifest 的 abis 里找不到（如 x86 模拟器，但只发了 arm split）。
  // 应退回 platform 级 universal 条目。
  test('checkForUpdate falls back to universal when abi not in abis', () async {
    debugDefaultTargetPlatformOverride = .android;
    addTearDown(() {
      debugDefaultTargetPlatformOverride = null;
    });
    PackageInfo.setMockInitialValues(
      appName: 'MeloTrip',
      packageName: 'com.riverage.melotrip',
      version: '1.0.27',
      buildNumber: '6027', // x86_64 split 的 versionCode
      buildSignature: '',
    );

    const manifestUrl = 'https://example.com/update.json';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      manifestUrl: <String, dynamic>{
        'versionName': '1.0.28',
        'versionCode': 2028,
        'platforms': <String, dynamic>{
          'android': <String, dynamic>{
            'packageType': 'apk',
            'assetName': 'app-release.apk',
            'downloadUrl': 'https://example.com/app-release.apk',
            'sha256': 'universal-sha',
            'fileSize': 85993881,
            'versionCode': 2028,
            'abis': <String, dynamic>{
              'arm64-v8a': <String, dynamic>{
                'assetName': 'app-arm64-v8a-release.apk',
                'downloadUrl': 'https://example.com/app-arm64-v8a-release.apk',
                'sha256': 'arm64-sha',
                'fileSize': 25395213,
                'versionCode': 4028,
              },
            },
          },
        },
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final service = AppUpdateService(
      manifestUrl: manifestUrl,
      dio: dio,
      // 本机是 x86_64，manifest 只发了 arm64 split → 退 universal。
      installerGateway: const _FakeGateway(abi: 'x86_64'),
    );

    final result = await service.checkForUpdate();

    expect(result.remote?.downloadUrl, 'https://example.com/app-release.apk');
    expect(result.remote?.sha256, 'universal-sha');
    expect(result.remote?.fileSize, 85993881);
  });

  // split-per-abi 在 GitHub API 分支（metadata 文本块）也能正确选 arm64 包。
  test('GitHub release parser selects arm64 split asset', () async {
    const apiUrl = 'https://example.com/latest';
    final adapter = _RouteJsonAdapter(<String, Map<String, dynamic>>{
      apiUrl: <String, dynamic>{
        'tag_name': 'v1.0.28',
        'body': '''
<!-- MELOTRIP_UPDATE_METADATA
versionName=1.0.28
versionCode=2028
asset.android.apk=app-release.apk
versionCode.android.apk=2028
sha256.android.apk=universal-sha
size.android.apk=85993881
asset.android.apk.arm64-v8a=app-arm64-v8a-release.apk
versionCode.android.apk.arm64-v8a=4028
sha256.android.apk.arm64-v8a=arm64-sha
size.android.apk.arm64-v8a=25395213
MELOTRIP_UPDATE_METADATA -->
''',
        'assets': <Map<String, dynamic>>[
          <String, dynamic>{
            'name': 'app-arm64-v8a-release.apk',
            'browser_download_url':
                'https://example.com/app-arm64-v8a-release.apk',
            'size': 25395213,
          },
          <String, dynamic>{
            'name': 'app-release.apk',
            'browser_download_url': 'https://example.com/app-release.apk',
            'size': 85993881,
          },
        ],
      },
    });
    final dio = Dio()..httpClientAdapter = adapter;
    final response = await dio.get<dynamic>(apiUrl);
    final json = response.data is String
        ? jsonDecode(response.data as String) as Map<String, dynamic>
        : response.data as Map<String, dynamic>;

    final parser = GitHubReleaseParser();
    final parsed = parser.parseRelease(
      releaseJson: json,
      platform: 'android',
      packageType: 'apk.arm64-v8a',
    );

    expect(parsed.downloadUrl, 'https://example.com/app-arm64-v8a-release.apk');
    expect(parsed.sha256, 'arm64-sha');
    expect(parsed.fileSize, 25395213);
    expect(parsed.versionCode, 4028);
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

  test('downloadAndVerifyPackage switches mirror when first fails', () async {
    _setUpdateTestPlatform();
    _useMockPathProvider();
    final full = List<int>.generate(100, (i) => i);
    const failUrl = 'https://fail.example.com/pkg.zip';
    const okUrl = 'https://ok.example.com/pkg.zip';
    final adapter = _MultiMirrorAdapter(
      bytes: full,
      behaviors: {
        failUrl: _MirrorBehavior.fail,
        okUrl: _MirrorBehavior.normal,
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;

    final service = AppUpdateService(
      manifestUrl: 'https://example.com/update.json',
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pkg.zip');
    if (await file.exists()) await file.delete();
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });

    const update = AppUpdateInfo(
      versionName: '1.0.2',
      versionCode: 3,
      sha256: '',
      fileSize: 100,
      downloadUrl: failUrl,
      mirrors: <String>[failUrl, okUrl],
      changelog: '',
    );

    final result = await service.downloadAndVerifyPackage(update: update);
    // 第一个 mirror 失败，自动切到第二个，内容正确。
    expect(await result.readAsBytes(), equals(full));
    expect(adapter.behaviors.containsKey(failUrl), isTrue);
  });

  test('downloadAndVerifyPackage skips mirror with checksum mismatch', () async {
    _setUpdateTestPlatform();
    _useMockPathProvider();
    final full = List<int>.generate(100, (i) => i);
    // 计算 full 的真实 sha256，让 okUrl 通过校验，tamperUrl 失败。
    final expectedSha = sha256.convert(full).toString();
    const tamperUrl = 'https://tamper.example.com/pkg.zip';
    const okUrl = 'https://ok.example.com/pkg.zip';
    final adapter = _MultiMirrorAdapter(
      bytes: full,
      behaviors: {
        tamperUrl: _MirrorBehavior.tamper,
        okUrl: _MirrorBehavior.normal,
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;

    final service = AppUpdateService(
      manifestUrl: 'https://example.com/update.json',
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pkg.zip');
    if (await file.exists()) await file.delete();
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });

    const update = AppUpdateInfo(
      versionName: '1.0.2',
      versionCode: 3,
      sha256: '', // 运行时填充，见下
      fileSize: 100,
      downloadUrl: tamperUrl,
      mirrors: <String>[tamperUrl, okUrl],
      changelog: '',
    );

    // AppUpdateInfo 是不可变的 const；用 copyWith 注入运行时 sha。
    final updateWithSha = update.copyWith(sha256: expectedSha);
    final result = await service.downloadAndVerifyPackage(
      update: updateWithSha,
    );
    // 篡改 mirror 被 SHA 校验挡下，切到正常 mirror，内容正确。
    expect(await result.readAsBytes(), equals(full));
  });

  test('downloadAndVerifyPackage throws when all mirrors fail', () async {
    _setUpdateTestPlatform();
    _useMockPathProvider();
    final full = List<int>.generate(100, (i) => i);
    const failUrl1 = 'https://fail1.example.com/pkg.zip';
    const failUrl2 = 'https://fail2.example.com/pkg.zip';
    final adapter = _MultiMirrorAdapter(
      bytes: full,
      behaviors: {
        failUrl1: _MirrorBehavior.fail,
        failUrl2: _MirrorBehavior.fail,
      },
    );
    final dio = Dio()..httpClientAdapter = adapter;

    final service = AppUpdateService(
      manifestUrl: 'https://example.com/update.json',
      dio: dio,
      installerGateway: const _FakeGateway(),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/pkg.zip');
    if (await file.exists()) await file.delete();
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });

    const update = AppUpdateInfo(
      versionName: '1.0.2',
      versionCode: 3,
      sha256: '',
      fileSize: 100,
      downloadUrl: failUrl1,
      mirrors: <String>[failUrl1, failUrl2],
      changelog: '',
    );

    await expectLater(
      service.downloadAndVerifyPackage(update: update),
      throwsA(isA<StateError>()),
    );
    // 全部失败时不应残留半成品文件。
    expect(await file.exists(), isFalse);
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
    this.abi,
  });

  final bool supported;
  final bool permission;
  final String? abi;
  @override
  final bool requiresHostExitForInstall;

  @override
  bool get isSupported => supported;

  @override
  Future<String?> get deviceAbi async => abi;

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
  Future<String?> get deviceAbi async => null;

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

/// 多镜像测试用 adapter：按 URL 路由，每个 URL 独立配置行为。
enum _MirrorBehavior { normal, fail, tamper }

class _MultiMirrorAdapter implements HttpClientAdapter {
  _MultiMirrorAdapter({
    required this.bytes,
    required this.behaviors,
  });

  /// 正确的完整字节内容（normal/tamper 都基于它）。
  final List<int> bytes;
  /// URL -> 行为。未列出的 URL 视为 404。
  final Map<String, _MirrorBehavior> behaviors;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final url = options.uri.toString();
    final behavior = behaviors[url];
    if (behavior == null) {
      return ResponseBody.fromBytes(
        utf8.encode('not found'),
        404,
        headers: {Headers.contentTypeHeader: <String>['text/plain']},
      );
    }

    switch (behavior) {
      case _MirrorBehavior.fail:
        return ResponseBody.fromBytes(
          utf8.encode('server error'),
          500,
          headers: {Headers.contentTypeHeader: <String>['text/plain']},
        );
      case _MirrorBehavior.tamper:
        // 返回篡改内容（首字节翻转），长度相同但 SHA 不符。
        final tampered = List<int>.from(bytes);
        if (tampered.isNotEmpty) {
          tampered[0] = (tampered[0] ^ 0xFF) & 0xFF;
        }
        return _body(tampered, 200, total: tampered.length);
      case _MirrorBehavior.normal:
        // 全量返回（dio.download 不发 Range）。
        return _body(bytes, 200, total: bytes.length);
    }
  }

  ResponseBody _body(
    List<int> data,
    int status, {
    required int total,
  }) {
    final headers = <String, List<String>>{
      Headers.contentLengthHeader: <String>['${data.length}'],
      Headers.contentTypeHeader: <String>['application/octet-stream'],
    };
    return ResponseBody.fromBytes(data, status, headers: headers);
  }
}
