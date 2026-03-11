import 'dart:io';

import 'package:update_installer/update_installer.dart';

abstract class UpdateInstallerGateway {
  const UpdateInstallerGateway();

  factory UpdateInstallerGateway.auto({
    WindowsBundleUpdaterLauncher windowsUpdaterLauncher =
        const WindowsBundleUpdaterLauncher(),
  }) {
    if (Platform.isAndroid) {
      return const _AndroidUpdateInstallerGateway();
    }
    if (Platform.isWindows) {
      return _WindowsBundleUpdateInstallerGateway(
        windowsUpdaterLauncher: windowsUpdaterLauncher,
      );
    }
    return const _NoopUpdateInstallerGateway();
  }

  bool get isSupported;

  bool get requiresHostExitForInstall;

  Future<bool> canRequestInstallPermission();

  Future<void> openInstallPermissionSettings();

  Future<void> installPackage(String filePath);
}

class _AndroidUpdateInstallerGateway extends UpdateInstallerGateway {
  const _AndroidUpdateInstallerGateway();

  @override
  bool get isSupported => true;

  @override
  bool get requiresHostExitForInstall => false;

  @override
  Future<bool> canRequestInstallPermission() async {
    return UpdateInstaller.canRequestPackageInstalls();
  }

  @override
  Future<void> openInstallPermissionSettings() async {
    await UpdateInstaller.openUnknownSourcesSettings();
  }

  @override
  Future<void> installPackage(String filePath) async {
    await UpdateInstaller.installApk(filePath);
  }
}

class _WindowsBundleUpdateInstallerGateway extends UpdateInstallerGateway {
  const _WindowsBundleUpdateInstallerGateway({
    required WindowsBundleUpdaterLauncher windowsUpdaterLauncher,
  }) : _windowsUpdaterLauncher = windowsUpdaterLauncher;

  final WindowsBundleUpdaterLauncher _windowsUpdaterLauncher;

  @override
  bool get isSupported => true;

  @override
  bool get requiresHostExitForInstall => true;

  @override
  Future<bool> canRequestInstallPermission() async => true;

  @override
  Future<void> openInstallPermissionSettings() async {}

  @override
  Future<void> installPackage(String filePath) {
    return _windowsUpdaterLauncher.launch(
      archivePath: filePath,
      currentExePath: Platform.resolvedExecutable,
      currentProcessId: pid,
    );
  }
}

class _NoopUpdateInstallerGateway extends UpdateInstallerGateway {
  const _NoopUpdateInstallerGateway();

  @override
  bool get isSupported => false;

  @override
  bool get requiresHostExitForInstall => false;

  @override
  Future<bool> canRequestInstallPermission() async => false;

  @override
  Future<void> openInstallPermissionSettings() async {}

  @override
  Future<void> installPackage(String filePath) {
    throw UnsupportedError('Package installation is unavailable');
  }
}
