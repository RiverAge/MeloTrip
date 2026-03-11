import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_logic/android_apk_installer.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';

void main() {
  test('downloadAndVerifyApk throws when download url is empty', () {
    final service = AppUpdateService(installerGateway: const _FakeGateway());

    expect(
      () => service.downloadAndVerifyApk(
        update: const AppUpdateInfo(
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

  test('installer capability delegates to gateway', () async {
    final service = AppUpdateService(
      installerGateway: const _FakeGateway(supported: true, permission: true),
    );
    expect(service.isInstallSupported, isTrue);
    expect(await service.canRequestInstallPermission(), isTrue);
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

    await service.installDownloadedPackage(file);
    expect(gateway.installedPath, file.path);
  });
}

class _FakeGateway extends UpdateInstallerGateway {
  const _FakeGateway({this.supported = false, this.permission = false});

  final bool supported;
  final bool permission;

  @override
  bool get isSupported => supported;

  @override
  Future<bool> canRequestInstallPermission() async => permission;

  @override
  Future<void> installPackage(String filePath) async {}

  @override
  Future<void> openInstallPermissionSettings() async {}
}

class _RecordingGateway extends UpdateInstallerGateway {
  String? installedPath;

  @override
  bool get isSupported => true;

  @override
  Future<bool> canRequestInstallPermission() async => true;

  @override
  Future<void> installPackage(String filePath) async {
    installedPath = filePath;
  }

  @override
  Future<void> openInstallPermissionSettings() async {}
}
