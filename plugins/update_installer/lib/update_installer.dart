import 'dart:io';

import 'package:flutter/services.dart';

class WindowsUpdaterStrings {
  const WindowsUpdaterStrings({
    required this.windowTitle,
    required this.preparing,
    required this.versionLine,
    required this.waitingForApp,
    required this.extractingArchive,
    required this.copyingFiles,
    required this.restartingApp,
    required this.failed,
    required this.invalidArguments,
    required this.initFailed,
    required this.waitFailed,
    required this.tempPathFailed,
    required this.tempDirFailed,
    required this.extractFailed,
    required this.copyFailed,
  });

  final String windowTitle;
  final String preparing;
  final String versionLine;
  final String waitingForApp;
  final String extractingArchive;
  final String copyingFiles;
  final String restartingApp;
  final String failed;
  final String invalidArguments;
  final String initFailed;
  final String waitFailed;
  final String tempPathFailed;
  final String tempDirFailed;
  final String extractFailed;
  final String copyFailed;

  Map<String, Object> toMap() {
    return <String, Object>{
      'windowTitle': windowTitle,
      'preparing': preparing,
      'versionLine': versionLine,
      'waitingForApp': waitingForApp,
      'extractingArchive': extractingArchive,
      'copyingFiles': copyingFiles,
      'restartingApp': restartingApp,
      'failed': failed,
      'invalidArguments': invalidArguments,
      'initFailed': initFailed,
      'waitFailed': waitFailed,
      'tempPathFailed': tempPathFailed,
      'tempDirFailed': tempDirFailed,
      'extractFailed': extractFailed,
      'copyFailed': copyFailed,
    };
  }
}

class UpdateInstaller {
  UpdateInstaller._();

  static const MethodChannel _channel = MethodChannel(
    'com.meme.melotrip/update',
  );

  static Future<bool> canRequestPackageInstalls() async {
    final result =
        await _channel.invokeMethod<bool>('canRequestPackageInstalls');
    return result ?? false;
  }

  static Future<void> openUnknownSourcesSettings() async {
    await _channel.invokeMethod<void>('openUnknownSourcesSettings');
  }

  static Future<void> installApk(String filePath) async {
    await _channel.invokeMethod<void>('installApk', {'filePath': filePath});
  }

  static Future<void> launchWindowsBundledUpdater({
    required String archivePath,
    required String currentExePath,
    required int currentProcessId,
    required WindowsUpdaterStrings updaterStrings,
  }) async {
    await _channel.invokeMethod<void>('launchBundledUpdater', <String, Object>{
      'archivePath': archivePath,
      'currentExePath': currentExePath,
      'currentProcessId': currentProcessId,
      'updaterStrings': updaterStrings.toMap(),
    });
  }
}

class WindowsBundleUpdaterLauncher {
  const WindowsBundleUpdaterLauncher();

  Future<void> launch({
    required String archivePath,
    required String currentExePath,
    required int currentProcessId,
    required WindowsUpdaterStrings updaterStrings,
  }) async {
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'Windows bundled updater is only available on Windows',
      );
    }

    await UpdateInstaller.launchWindowsBundledUpdater(
      archivePath: archivePath,
      currentExePath: currentExePath,
      currentProcessId: currentProcessId,
      updaterStrings: updaterStrings,
    );
  }
}
