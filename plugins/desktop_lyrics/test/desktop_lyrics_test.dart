import 'package:flutter_test/flutter_test.dart';
import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:desktop_lyrics/desktop_lyrics_platform_interface.dart';
import 'package:desktop_lyrics/desktop_lyrics_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDesktopLyricsPlatform
    with MockPlatformInterfaceMixin
    implements DesktopLyricsPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DesktopLyricsPlatform initialPlatform = DesktopLyricsPlatform.instance;

  test('$MethodChannelDesktopLyrics is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDesktopLyrics>());
  });

  test('getPlatformVersion', () async {
    DesktopLyrics desktopLyricsPlugin = DesktopLyrics();
    MockDesktopLyricsPlatform fakePlatform = MockDesktopLyricsPlatform();
    DesktopLyricsPlatform.instance = fakePlatform;

    expect(await desktopLyricsPlugin.getPlatformVersion(), '42');
  });
}
