import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

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
}

class WindowsBundleUpdaterLauncher {
  const WindowsBundleUpdaterLauncher();

  static const String bundledExecutableName = 'MeloTripUpdater.exe';

  static List<String> buildArgs({
    required String archivePath,
    required String currentExePath,
    required int currentProcessId,
  }) {
    return <String>[
      '--archive',
      archivePath,
      '--install-dir',
      p.dirname(currentExePath),
      '--executable',
      currentExePath,
      '--pid',
      '$currentProcessId',
    ];
  }

  Future<void> launch({
    required String archivePath,
    required String currentExePath,
    required int currentProcessId,
  }) async {
    final bundledUpdater = File(
      p.join(p.dirname(currentExePath), bundledExecutableName),
    );
    if (!await bundledUpdater.exists()) {
      throw StateError('Bundled updater is missing: ${bundledUpdater.path}');
    }

    final launcherDir = await Directory.systemTemp.createTemp(
      'melotrip-updater-',
    );
    final launcherPath = p.join(launcherDir.path, bundledExecutableName);
    await bundledUpdater.copy(launcherPath);

    await Process.start(
      launcherPath,
      buildArgs(
        archivePath: archivePath,
        currentExePath: currentExePath,
        currentProcessId: currentProcessId,
      ),
      mode: ProcessStartMode.detached,
    );
  }
}
