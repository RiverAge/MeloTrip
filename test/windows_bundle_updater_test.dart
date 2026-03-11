import 'package:flutter_test/flutter_test.dart';
import 'package:update_installer/update_installer.dart';

void main() {
  test('windows updater launcher builds argument list for bundled exe', () {
    final args = WindowsBundleUpdaterLauncher.buildArgs(
      archivePath: r'C:\temp\melotrip-windows-x64.zip',
      currentExePath: r'C:\MeloTrip\MeloTrip.exe',
      currentProcessId: 4242,
    );

    expect(args, <String>[
      '--archive',
      r'C:\temp\melotrip-windows-x64.zip',
      '--install-dir',
      r'C:\MeloTrip',
      '--executable',
      r'C:\MeloTrip\MeloTrip.exe',
      '--pid',
      '4242',
    ]);
  });
}
