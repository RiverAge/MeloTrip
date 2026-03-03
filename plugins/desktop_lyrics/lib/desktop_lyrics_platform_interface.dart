import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'desktop_lyrics_method_channel.dart';

abstract class DesktopLyricsPlatform extends PlatformInterface {
  /// Constructs a DesktopLyricsPlatform.
  DesktopLyricsPlatform() : super(token: _token);

  static final Object _token = Object();

  static DesktopLyricsPlatform _instance = MethodChannelDesktopLyrics();

  /// The default instance of [DesktopLyricsPlatform] to use.
  ///
  /// Defaults to [MethodChannelDesktopLyrics].
  static DesktopLyricsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DesktopLyricsPlatform] when
  /// they register themselves.
  static set instance(DesktopLyricsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
