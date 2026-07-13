import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:update_installer/update_installer.dart';

abstract class UpdateInstallerGateway {
  const UpdateInstallerGateway();

  factory UpdateInstallerGateway.auto({
    WindowsBundleUpdaterLauncher windowsUpdaterLauncher =
        const WindowsBundleUpdaterLauncher(),
  }) {
    if (!kIsWeb && defaultTargetPlatform == .android) {
      return const _AndroidUpdateInstallerGateway();
    }
    if (!kIsWeb && defaultTargetPlatform == .windows) {
      return _WindowsBundleUpdateInstallerGateway(
        windowsUpdaterLauncher: windowsUpdaterLauncher,
      );
    }
    return const _NoopUpdateInstallerGateway();
  }

  bool get isSupported;

  bool get requiresHostExitForInstall;

  /// 当前设备首选 ABI（仅 Android 有意义，如 "arm64-v8a" / "armeabi-v7a" /
  /// "x86_64"）。用于从 split-per-abi 产物里选对应包，避免下载含全套 .so 的
  /// universal 大包。桌面 / 未知平台返回 null。
  Future<String?> get deviceAbi;

  Future<bool> canRequestInstallPermission();

  Future<void> openInstallPermissionSettings();

  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  });
}

class _AndroidUpdateInstallerGateway extends UpdateInstallerGateway {
  const _AndroidUpdateInstallerGateway();

  @override
  bool get isSupported => true;

  @override
  bool get requiresHostExitForInstall => false;

  @override
  Future<String?> get deviceAbi => UpdateInstaller.getDeviceAbi();

  @override
  Future<bool> canRequestInstallPermission() async {
    return UpdateInstaller.canRequestPackageInstalls();
  }

  @override
  Future<void> openInstallPermissionSettings() async {
    await UpdateInstaller.openUnknownSourcesSettings();
  }

  @override
  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) async {
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
  Future<String?> get deviceAbi async => null;

  @override
  Future<bool> canRequestInstallPermission() async => true;

  @override
  Future<void> openInstallPermissionSettings() async {}

  @override
  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) {
    if (updaterStrings == null) {
      throw StateError('Windows updater strings are required on Windows.');
    }
    return _windowsUpdaterLauncher.launch(
      archivePath: filePath,
      currentExePath: Platform.resolvedExecutable,
      currentProcessId: pid,
      updaterStrings: updaterStrings,
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
  Future<String?> get deviceAbi async => null;

  @override
  Future<bool> canRequestInstallPermission() async => false;

  @override
  Future<void> openInstallPermissionSettings() async {}

  @override
  Future<void> installPackage(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) {
    throw UnsupportedError('Package installation is unavailable');
  }
}
