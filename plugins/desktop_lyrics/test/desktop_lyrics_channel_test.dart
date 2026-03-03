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
          if (call.method == 'getPlatformVersion') return 'Windows 11';
          return null;
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('sends show/hide/dispose calls', () async {
    const lyrics = DesktopLyrics();

    await lyrics.show();
    await lyrics.hide();
    await lyrics.dispose();

    expect(calls.map((e) => e.method), ['show', 'hide', 'dispose']);
  });

  test('serializes track/progress/config payloads', () async {
    const lyrics = DesktopLyrics();
    await lyrics.updateTrack(
      songId: 's1',
      title: 'Song',
      artist: 'Artist',
      lines: const [
        DesktopLyricsLine(startMs: 1000, values: ['line1', 'line2']),
      ],
    );
    await lyrics.updateProgress(
      position: const Duration(seconds: 12),
      duration: const Duration(minutes: 3),
    );
    await lyrics.updateConfig(
      const DesktopLyricsConfig(
        enabled: true,
        clickThrough: false,
        fontSize: 30,
        opacity: 0.8,
        textColorArgb: 0xFFFFFFFF,
        shadowColorArgb: 0xFF000000,
        strokeColorArgb: 0xFFFF0000,
        strokeWidth: 1.5,
      ),
    );

    final trackMap = calls[0].arguments as Map<Object?, Object?>;
    final lineList = trackMap['lines'] as List<Object?>;
    final firstLine = lineList.first as Map<Object?, Object?>;
    expect(calls[0].method, 'updateTrack');
    expect(trackMap['songId'], 's1');
    expect(trackMap['title'], 'Song');
    expect(trackMap['artist'], 'Artist');
    expect(firstLine['start'], 1000);
    expect(firstLine['value'], ['line1', 'line2']);

    final progressMap = calls[1].arguments as Map<Object?, Object?>;
    expect(calls[1].method, 'updateProgress');
    expect(progressMap['positionMs'], 12000);
    expect(progressMap['durationMs'], 180000);

    final configMap = calls[2].arguments as Map<Object?, Object?>;
    expect(calls[2].method, 'updateConfig');
    expect(configMap['enabled'], true);
    expect(configMap['clickThrough'], false);
    expect(configMap['fontSize'], 30.0);
    expect(configMap['opacity'], 0.8);
    expect(configMap['textColorArgb'], 0xFFFFFFFF);
    expect(configMap['shadowColorArgb'], 0xFF000000);
    expect(configMap['strokeColorArgb'], 0xFFFF0000);
    expect(configMap['strokeWidth'], 1.5);
  });

  test('getPlatformVersion delegates to channel', () async {
    const lyrics = DesktopLyrics();
    final version = await lyrics.getPlatformVersion();
    expect(version, 'Windows 11');
    expect(calls.single.method, 'getPlatformVersion');
  });
}
