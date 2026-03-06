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

  test('apply toggles enabled flag and dispose call', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      lyrics.state.copyWith(
        interaction: lyrics.state.interaction.copyWith(enabled: true),
      ),
    );
    await lyrics.apply(
      lyrics.state.copyWith(
        interaction: lyrics.state.interaction.copyWith(enabled: false),
      ),
    );
    lyrics.dispose();
    await Future<void>.delayed(Duration.zero);

    expect(calls.map((e) => e.method),
        ['updateConfig', 'updateConfig', 'dispose']);
    final showArgs = calls[0].arguments as Map<Object?, Object?>;
    final hideArgs = calls[1].arguments as Map<Object?, Object?>;
    expect(showArgs['enabled'], true);
    expect(hideArgs['enabled'], false);
  });

  test('serializes render/config payloads', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.render(const DesktopLyricsFrame.line(currentLine: 'line1'));
    await lyrics.apply(
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

  test('serializes full config contract for native parity', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: false,
          clickThrough: true,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: 42,
          textColor: Color(0xFF123456),
          shadowColor: Color(0x88223344),
          strokeColor: Color(0xAA445566),
          strokeWidth: 2.25,
          fontFamily: 'Noto Sans CJK',
          textAlign: TextAlign.end,
          fontWeight: FontWeight.w700,
        ),
        background: DesktopLyricsBackgroundConfig(
          opacity: 0.7,
          backgroundColor: Color(0xCC010203),
          backgroundRadius: 18.0,
          backgroundPadding: 14.0,
        ),
        gradient: DesktopLyricsGradientConfig(
          textGradientEnabled: true,
          textGradientStartColor: Color(0xFFFFAA00),
          textGradientEndColor: Color(0xFF00AABB),
          textGradientAngle: 35.0,
        ),
        layout: DesktopLyricsLayoutConfig(
          overlayWidth: 1200.0,
        ),
      ),
    );

    final configMap = calls.single.arguments as Map<Object?, Object?>;
    expect(configMap['enabled'], false);
    expect(configMap['clickThrough'], true);
    expect(configMap['fontSize'], 42.0);
    expect(configMap['opacity'], 0.7);
    expect(configMap['textColorArgb'], 0xFF123456);
    expect(configMap['shadowColorArgb'], 0x88223344);
    expect(configMap['strokeColorArgb'], 0xAA445566);
    expect(configMap['strokeWidth'], 2.25);
    expect(configMap['backgroundColorArgb'], 0xCC010203);
    expect(configMap['backgroundRadius'], 18.0);
    expect(configMap['backgroundPadding'], 14.0);
    expect(configMap['textGradientEnabled'], true);
    expect(configMap['textGradientStartArgb'], 0xFFFFAA00);
    expect(configMap['textGradientEndArgb'], 0xFF00AABB);
    expect(configMap['textGradientAngle'], 35.0);
    expect(configMap['overlayWidth'], 1200.0);
    expect(configMap.containsKey('overlayHeight'), false);
    expect(configMap['fontFamily'], 'Noto Sans CJK');
    expect(configMap['textAlign'], 2);
    expect(configMap['fontWeightValue'], 700);
  });

  test('omits overlayHeight in auto-height mode', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: true,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(fontSize: 30),
        layout: DesktopLyricsLayoutConfig(overlayWidth: 960.0),
      ),
    );

    final configMap = calls.single.arguments as Map<Object?, Object?>;
    expect(configMap['overlayWidth'], 960.0);
    expect(configMap.containsKey('overlayHeight'), false);
  });

  test('render clamps out-of-range and invalid progress', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.render(
      const DesktopLyricsFrame.tokenized(
        tokens: [DesktopLyricsToken(text: 'A', progress: 1.0)],
        lineProgress: -3.0,
      ),
    );
    await lyrics.render(
      const DesktopLyricsFrame.tokenized(
        tokens: [DesktopLyricsToken(text: 'B', progress: 1.0)],
        lineProgress: 5.0,
      ),
    );
    await lyrics.render(
      const DesktopLyricsFrame.tokenized(
        tokens: [DesktopLyricsToken(text: 'C', progress: 1.0)],
        lineProgress: double.nan,
      ),
    );

    final first = calls[0].arguments as Map<Object?, Object?>;
    final second = calls[1].arguments as Map<Object?, Object?>;
    final third = calls[2].arguments as Map<Object?, Object?>;
    expect(first['lineProgress'], 0.0);
    expect(second['lineProgress'], 1.0);
    expect(third['lineProgress'], 1.0);
  });
}
