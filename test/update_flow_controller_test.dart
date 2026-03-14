import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/update/update_flow.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:update_installer/update_installer.dart';

part 'parts/update_flow_controller_test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('UpdateFlowState copyWith and clearEtaSeconds', () {
    const UpdateFlowState base = UpdateFlowState(
      isChecking: true,
      etaSeconds: 30,
      stage: UpdateUiStage.downloading,
    );
    final UpdateFlowState next = base.copyWith(
      isChecking: false,
      clearEtaSeconds: true,
    );

    expect(next.isChecking, isFalse);
    expect(next.etaSeconds, isNull);
    expect(next.stage, UpdateUiStage.downloading);
  });

  test('checkForUpdate stores available update in state', () async {
    const AppUpdateInfo info = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 10,
      downloadUrl: 'https://example.com/a.apk',
      changelog: 'x',
    );
    const AppUpdateCheckResult result = AppUpdateCheckResult(
      currentVersionName: '1.0.0',
      currentVersionCode: 1,
      remote: info,
      hasUpdate: true,
    );
    final _FakeUpdateService service = _FakeUpdateService(checkResult: result);
    final ProviderContainer container = _createContainer(service);
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );

    expect(controller.state.isChecking, isFalse);
    final AppUpdateCheckResult ret = await controller.checkForUpdate();
    expect(ret.hasUpdate, isTrue);
    expect(controller.state.isChecking, isFalse);
    expect(controller.state.hasChecked, isTrue);
    expect(controller.state.availableUpdate?.versionName, '1.0.1');
    expect(controller.state.currentVersionName, '1.0.0');
    expect(controller.state.currentVersionCode, 1);
    expect(controller.state.checkError, isNull);
  });

  test('checkForUpdate stores inline error state on failure', () async {
    final ProviderContainer container = _createContainer(
      _FakeUpdateService(checkError: StateError('boom')),
    );
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );

    await expectLater(controller.checkForUpdate(), throwsStateError);
    expect(controller.state.isChecking, isFalse);
    expect(controller.state.hasChecked, isTrue);
    expect(controller.state.availableUpdate, isNull);
    expect(controller.state.checkError, contains('boom'));
  });

  test('requiresHostExitForInstall delegates to service', () {
    final ProviderContainer container = _createContainer(
      _FakeUpdateService(requiresHostExit: true),
    );
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );

    expect(controller.requiresHostExitForInstall, isTrue);
  });

  test('getInstallCapability returns all branches', () async {
    final ProviderContainer notSupportedContainer = _createContainer(
      _FakeUpdateService(installSupported: false),
    );
    final UpdateFlowController notSupported = notSupportedContainer.read(
      updateFlowControllerProvider.notifier,
    );
    expect(
      await notSupported.getInstallCapability(),
      InstallCapability.notSupported,
    );

    final ProviderContainer permissionRequiredContainer = _createContainer(
      _FakeUpdateService(installSupported: true, canInstallPermission: false),
    );
    final UpdateFlowController permissionRequired = permissionRequiredContainer
        .read(updateFlowControllerProvider.notifier);
    expect(
      await permissionRequired.getInstallCapability(),
      InstallCapability.permissionRequired,
    );

    final ProviderContainer supportedContainer = _createContainer(
      _FakeUpdateService(installSupported: true, canInstallPermission: true),
    );
    final UpdateFlowController supported = supportedContainer.read(
      updateFlowControllerProvider.notifier,
    );
    expect(await supported.getInstallCapability(), InstallCapability.supported);
  });

  test('openInstallPermissionSettings delegates to service', () async {
    final _FakeUpdateService service = _FakeUpdateService();
    final ProviderContainer container = _createContainer(service);
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );
    await controller.openInstallPermissionSettings();
    expect(service.openInstallSettingsCalled, isTrue);
  });

  test('downloadAndInstall succeeds and resets state', () async {
    final _FakeUpdateService service = _FakeUpdateService();
    final ProviderContainer container = _createContainer(service);
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );
    const AppUpdateInfo update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final String? error = await controller.downloadAndInstall(update);
    expect(error, isNull);
    expect(service.installCalled, isTrue);
    expect(controller.state.isUpdating, isFalse);
    expect(controller.state.stage, UpdateUiStage.idle);
  });

  test(
    'downloadAndInstall auto installs desktop package after download',
    () async {
      final _FakeUpdateService service = _FakeUpdateService(
        requiresHostExit: true,
      );
      final ProviderContainer container = _createContainer(service);
      final UpdateFlowController controller = container.read(
        updateFlowControllerProvider.notifier,
      );
      const AppUpdateInfo update = AppUpdateInfo(
        versionName: '1.0.1',
        versionCode: 2,
        sha256: '',
        fileSize: 100,
        downloadUrl: 'https://example.com/a.zip',
        changelog: '',
      );

      const WindowsUpdaterStrings updaterStrings = WindowsUpdaterStrings(
        windowTitle: 'Updater',
        versionLine: 'Version 1.0.1 (2)',
        preparing: 'Preparing',
        waitingForApp: 'Waiting',
        extractingArchive: 'Extracting',
        copyingFiles: 'Installing',
        restartingApp: 'Restarting',
        failed: 'Failed',
        invalidArguments: 'Invalid',
        initFailed: 'Init failed',
        waitFailed: 'Wait failed',
        tempPathFailed: 'Temp path failed',
        tempDirFailed: 'Temp dir failed',
        extractFailed: 'Extract failed',
        copyFailed: 'Copy failed',
      );
      final String? error = await controller.downloadAndInstall(
        update,
        updaterStrings: updaterStrings,
      );

      expect(error, isNull);
      expect(service.installCalled, isTrue);
      expect(controller.state.isUpdating, isFalse);
      expect(controller.state.stage, UpdateUiStage.idle);
      expect(controller.state.pendingPackagePath, isNull);
      expect(service.receivedUpdaterStrings, updaterStrings);
    },
  );

  test('installPendingPackage delegates updater strings to service', () async {
    final _FakeUpdateService service = _FakeUpdateService(
      requiresHostExit: true,
      installError: StateError('first launch failed'),
    );
    final ProviderContainer container = _createContainer(service);
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );
    const AppUpdateInfo update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.zip',
      changelog: '',
    );
    const WindowsUpdaterStrings updaterStrings = WindowsUpdaterStrings(
      windowTitle: 'Updater',
      versionLine: 'Version 1.0.1 (2)',
      preparing: 'Preparing',
      waitingForApp: 'Waiting',
      extractingArchive: 'Extracting',
      copyingFiles: 'Installing',
      restartingApp: 'Restarting',
      failed: 'Failed',
      invalidArguments: 'Invalid',
      initFailed: 'Init failed',
      waitFailed: 'Wait failed',
      tempPathFailed: 'Temp path failed',
      tempDirFailed: 'Temp dir failed',
      extractFailed: 'Extract failed',
      copyFailed: 'Copy failed',
    );

    final String? firstError = await controller.downloadAndInstall(update);
    expect(firstError, contains('first launch failed'));
    service.installError = null;
    final String? error = await controller.installPendingPackage(
      updaterStrings: updaterStrings,
    );

    expect(error, isNull);
    expect(service.installCalled, isTrue);
    expect(service.receivedUpdaterStrings, isNotNull);
    expect(controller.state.stage, UpdateUiStage.idle);
    expect(controller.state.pendingPackagePath, isNull);
    expect(controller.state.pendingVersionName, isNull);
    expect(controller.state.pendingVersionCode, isNull);
  });

  test('downloadAndInstall prevents concurrent update', () async {
    final _FakeUpdateService service = _FakeUpdateService(
      downloadDelay: const Duration(milliseconds: 120),
    );
    final ProviderContainer container = _createContainer(service);
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );
    const AppUpdateInfo update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final Future<String?> first = controller.downloadAndInstall(update);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    final String? second = await controller.downloadAndInstall(update);

    expect(second, 'Update is already in progress.');
    await first;
  });

  test('downloadAndInstall returns error message on failure', () async {
    final ProviderContainer container = _createContainer(
      _FakeUpdateService(downloadError: StateError('download failed')),
    );
    final UpdateFlowController controller = container.read(
      updateFlowControllerProvider.notifier,
    );
    const AppUpdateInfo update = AppUpdateInfo(
      versionName: '1.0.1',
      versionCode: 2,
      sha256: '',
      fileSize: 100,
      downloadUrl: 'https://example.com/a.apk',
      changelog: '',
    );

    final String? error = await controller.downloadAndInstall(update);
    expect(error, contains('download failed'));
    expect(controller.state.isUpdating, isFalse);
    expect(controller.state.stage, UpdateUiStage.idle);
  });

  test(
    'downloadAndInstall keeps package ready when desktop installer fails',
    () async {
      final ProviderContainer container = _createContainer(
        _FakeUpdateService(
          requiresHostExit: true,
          installError: StateError('launch failed'),
        ),
      );
      final UpdateFlowController controller = container.read(
        updateFlowControllerProvider.notifier,
      );
      const AppUpdateInfo update = AppUpdateInfo(
        versionName: '1.0.1',
        versionCode: 2,
        sha256: '',
        fileSize: 100,
        downloadUrl: 'https://example.com/a.zip',
        changelog: '',
      );

      final String? error = await controller.downloadAndInstall(update);

      expect(error, contains('launch failed'));
      expect(controller.state.isUpdating, isFalse);
      expect(controller.state.stage, UpdateUiStage.readyToInstall);
      expect(controller.state.pendingPackagePath, isNotNull);
      expect(controller.state.pendingVersionName, '1.0.1');
      expect(controller.state.pendingVersionCode, 2);
    },
  );
}
