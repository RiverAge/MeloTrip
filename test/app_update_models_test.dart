import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';

void main() {
  test('AppUpdateInfo.fromJson parses mixed numeric types', () {
    final info = AppUpdateInfo.fromJson({
      'versionName': '1.2.3',
      'versionCode': '42',
      'sha256': 'abc',
      'fileSize': 1024.0,
      'downloadUrl': 'https://example.com/app.apk',
      'changelog': 'fixes',
    });

    expect(info.versionName, '1.2.3');
    expect(info.versionCode, 42);
    expect(info.fileSize, 1024);
    expect(info.sha256, 'abc');
    expect(info.downloadUrl, 'https://example.com/app.apk');
    expect(info.changelog, 'fixes');
  });

  test('AppUpdateCheckResult stores expected fields', () {
    const info = AppUpdateInfo(
      versionName: '1.2.0',
      versionCode: 12,
      sha256: 'x',
      fileSize: 1,
      downloadUrl: 'u',
      changelog: 'c',
    );
    const result = AppUpdateCheckResult(
      currentVersionName: '1.1.0',
      currentVersionCode: 11,
      remote: info,
      hasUpdate: true,
    );

    expect(result.currentVersionName, '1.1.0');
    expect(result.currentVersionCode, 11);
    expect(result.remote?.versionCode, 12);
    expect(result.hasUpdate, isTrue);
  });
}
