import 'dart:io';

import 'package:update_installer/update_installer.dart';

abstract class UpdateInstallerGateway {
  const UpdateInstallerGateway();

  factory UpdateInstallerGateway.auto() {
    if (Platform.isAndroid) {
      return const _AndroidUpdateInstallerGateway();
    }
    return const _NoopUpdateInstallerGateway();
  }

  bool get isSupported;

  Future<bool> canRequestInstallPermission();

  Future<void> openInstallPermissionSettings();

  Future<void> installPackage(String filePath);
}

class _AndroidUpdateInstallerGateway extends UpdateInstallerGateway {
  const _AndroidUpdateInstallerGateway();

  @override
  bool get isSupported => true;

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

class _NoopUpdateInstallerGateway extends UpdateInstallerGateway {
  const _NoopUpdateInstallerGateway();

  @override
  bool get isSupported => false;

  @override
  Future<bool> canRequestInstallPermission() async => false;

  @override
  Future<void> openInstallPermissionSettings() async {}

  @override
  Future<void> installPackage(String filePath) {
    throw UnsupportedError('Package installation is Android only');
  }
}
