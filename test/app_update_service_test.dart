import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/update/update_installer_gateway.dart';
import 'package:melo_trip/update/app_update_service.dart';
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
