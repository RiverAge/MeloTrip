import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'desktop_lyrics_platform_interface.dart';

/// An implementation of [DesktopLyricsPlatform] that uses method channels.
class MethodChannelDesktopLyrics extends DesktopLyricsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('desktop_lyrics');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }
}
