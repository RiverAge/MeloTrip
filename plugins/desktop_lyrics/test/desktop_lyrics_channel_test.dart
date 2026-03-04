import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelName = 'desktop_lyrics';
  const channel = MethodChannel(channelName);

  final calls = <MethodCall>[];

  setUp(() {
    calls.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('setEnabled uses updateConfig and dispose call', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.setEnabled(false);
    await lyrics.setEnabled(true);
    await lyrics.shutdown();

    expect(calls.map((e) => e.method), ['updateConfig', 'updateConfig', 'dispose']);
    final hideArgs = calls[0].arguments as Map<Object?, Object?>;
    final showArgs = calls[1].arguments as Map<Object?, Object?>;
    expect(hideArgs['enabled'], false);
    expect(showArgs['enabled'], true);
  });

  test('serializes render/config payloads', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.render(const DesktopLyricsFrame.line(currentLine: 'line1'));
    await lyrics.setConfig(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: true,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: 30,
          textColor: Color(0xFFFFFFFF),
          shadowColor: Color(0xFF000000),
          strokeColor: Color(0xFFFF0000),
          strokeWidth: 1.5,
        ),
        background: DesktopLyricsBackgroundConfig(opacity: 0.8),
      ),
    );

    final frameMap = calls[0].arguments as Map<Object?, Object?>;
    expect(calls[0].method, 'updateLyricFrame');
    expect(frameMap['currentLine'], 'line1');
    expect(frameMap['lineProgress'], 1.0);

    final configMap = calls[1].arguments as Map<Object?, Object?>;
    expect(calls[1].method, 'updateConfig');
    expect(configMap['enabled'], true);
    expect(configMap['clickThrough'], false);
    expect(configMap['fontSize'], 30.0);
    expect(configMap['opacity'], 0.8);
    expect(configMap['textColorArgb'], 0xFFFFFFFF);
    expect(configMap['shadowColorArgb'], 0xFF000000);
    expect(configMap['strokeColorArgb'], 0xFFFF0000);
    expect(configMap['strokeWidth'], 1.5);
  });
}
