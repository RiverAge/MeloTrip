import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';
import 'package:melo_trip/provider/update/update_flow.dart';

class _FakeUpdateService extends AppUpdateService {
  _FakeUpdateService({
    this.checkResult,
    this.installSupported = true,
    this.canInstallPermission = true,
    this.downloadError,
    this.installError,
    this.downloadDelay = Duration.zero,
  }) : super(checkUrl: 'https://example.com/check');

  final AppUpdateCheckResult? checkResult;
  final bool installSupported;
  final bool canInstallPermission;
  final Object? downloadError;
  final Object? installError;
  final Duration downloadDelay;

  bool openInstallSettingsCalled = false;
  bool installCalled = false;

  @override
  bool get isInstallSupported => installSupported;

  @override
  Future<bool> canRequestInstallPermission() async => canInstallPermission;

  @override
  Future<void> openInstallPermissionSettings() async {
    openInstallSettingsCalled = true;
  }

  @override
  Future<AppUpdateCheckResult> checkForUpdate() async {
    if (checkResult == null) {
      throw StateError('no result');
    }
    return checkResult!;
  }

  @override
  Future<File> downloadAndVerifyApk({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) async {
    if (downloadDelay > Duration.zero) {
      await Future<void>.delayed(downloadDelay);
    }
    if (downloadError != null) {
      throw downloadError!;
    }
    onStageChanged?.call(UpdateDownloadStage.downloading);
    onProgress?.call(update.fileSize ~/ 2, update.fileSize, 0.5);
    onStageChanged?.call(UpdateDownloadStage.verifying);

    final dir = await Directory.systemTemp.createTemp('melo-trip-test');
    final file = File('${dir.path}/app.apk');
    await file.writeAsBytes([1, 2, 3, 4]);
    return file;
  }

  @override
  Future<void> installDownloadedPackage(File file) async {
    if (installError != null) {
      throw installError!;
    }
    installCalled = true;
  }
}

void main() {
  test('UpdateFlowState copyWith and clearEtaSeconds', () {
    const base = UpdateFlowState(
      isChecking: true,
      etaSeconds: 30,
      stage: UpdateUiStage.downloading,
    );
    final next = base.copyWith(isChecking: false, clearEtaSeconds: true);

    expect(next.isChecking, isFalse);
    expect(next.etaSeconds, isNull);
    expect(next.stage, UpdateUiStage.downloading);
  });

  test('checkForUpdate toggles checking state', () async {
    const info = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 10,
      downloadUrl: 'https://example.com/a.apk',
      changelog: 'x',
    );
    const result = AppUpdateCheckResult(
      currentVersionName: '1.0.0',
      currentVersionCode: 1,
      remote: info,
      hasUpdate: true,
    );
    final service = _FakeUpdateService(checkResult: result);
    final controller = UpdateFlowController(service);

    expect(controller.state.isChecking, isFalse);
    final ret = await controller.checkForUpdate();
    expect(ret.hasUpdate, isTrue);
    expect(controller.state.isChecking, isFalse);
  });

  test('getInstallCapability returns all branches', () async {
    final notSupported = UpdateFlowController(
      _FakeUpdateService(installSupported: false),
    );
    expect(await notSupported.getInstallCapability(), InstallCapability.notSupported);

    final permissionRequired = UpdateFlowController(
      _FakeUpdateService(installSupported: true, canInstallPermission: false),
    );
    expect(
      await permissionRequired.getInstallCapability(),
      InstallCapability.permissionRequired,
    );

    final supported = UpdateFlowController(
      _FakeUpdateService(installSupported: true, canInstallPermission: true),
    );
    expect(await supported.getInstallCapability(), InstallCapability.supported);
  });

  test('openInstallPermissionSettings delegates to service', () async {
    final service = _FakeUpdateService();
    final controller = UpdateFlowController(service);
    await controller.openInstallPermissionSettings();
    expect(service.openInstallSettingsCalled, isTrue);
  });

  test('downloadAndInstall succeeds and resets state', () async {
    final service = _FakeUpdateService();
    final controller = UpdateFlowController(service);
    const update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final error = await controller.downloadAndInstall(update);
    expect(error, isNull);
    expect(service.installCalled, isTrue);
    expect(controller.state.isUpdating, isFalse);
    expect(controller.state.stage, UpdateUiStage.idle);
  });

  test('downloadAndInstall prevents concurrent update', () async {
    final service = _FakeUpdateService(downloadDelay: const Duration(milliseconds: 120));
    final controller = UpdateFlowController(service);
    const update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final first = controller.downloadAndInstall(update);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final second = await controller.downloadAndInstall(update);

    expect(second, 'Update is already in progress.');
    await first;
  });

  test('downloadAndInstall returns error message on failure', () async {
    final controller = UpdateFlowController(
      _FakeUpdateService(downloadError: StateError('download failed')),
    );
    const update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final error = await controller.downloadAndInstall(update);
    expect(error, contains('download failed'));
    expect(controller.state.isUpdating, isFalse);
    expect(controller.state.stage, UpdateUiStage.idle);
  });
}
