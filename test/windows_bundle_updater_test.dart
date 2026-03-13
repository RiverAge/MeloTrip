import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:update_installer/update_installer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const MethodChannel channel = MethodChannel('com.meme.melotrip/update');
  const updaterStrings = WindowsUpdaterStrings(
    windowTitle: 'Updater',
    versionLine: 'Version 1.0.1 (2)',
    preparing: 'Preparing',
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
  );

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test(
    'windows updater launcher forwards launch request to plugin channel',
    () async {
      if (!Platform.isWindows) {
        await expectLater(
          const WindowsBundleUpdaterLauncher().launch(
            archivePath: r'C:\temp\melotrip-windows-x64.zip',
            currentExePath: r'C:\MeloTrip\MeloTrip.exe',
            currentProcessId: 4242,
            updaterStrings: updaterStrings,
          ),
          throwsA(isA<UnsupportedError>()),
        );
        return;
      }

      MethodCall? capturedCall;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (MethodCall call) async {
            capturedCall = call;
            return null;
          });

      await const WindowsBundleUpdaterLauncher().launch(
        archivePath: r'C:\temp\melotrip-windows-x64.zip',
        currentExePath: r'C:\MeloTrip\MeloTrip.exe',
        currentProcessId: 4242,
        updaterStrings: updaterStrings,
      );

      expect(capturedCall?.method, 'launchBundledUpdater');
      expect(capturedCall?.arguments, <String, Object>{
        'archivePath': r'C:\temp\melotrip-windows-x64.zip',
        'currentExePath': r'C:\MeloTrip\MeloTrip.exe',
        'currentProcessId': 4242,
        'updaterStrings': updaterStrings.toMap(),
      });
    },
  );
}
