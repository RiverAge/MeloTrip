import 'package:flutter/services.dart';

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
