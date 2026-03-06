import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('desktop_lyrics');

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('apply survives MissingPluginException from channel', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw MissingPluginException();
    });

    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      lyrics.state.copyWith(
        interaction: lyrics.state.interaction.copyWith(enabled: true),
      ),
    );

    expect(lyrics.state.interaction.enabled, true);
  });

  test('render survives PlatformException from channel', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) async {
      throw PlatformException(code: 'fail', message: 'mock failure');
    });

    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      lyrics.state.copyWith(
        interaction: lyrics.state.interaction.copyWith(enabled: true),
      ),
    );

    await lyrics.render(
      const DesktopLyricsFrame.line(currentLine: 'platform error path'),
    );
  });

  test('render maps TextAlign.right to native end alignment', () async {
    final calls = <MethodCall>[];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });

    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.apply(
      lyrics.state.copyWith(
        interaction: lyrics.state.interaction.copyWith(enabled: true),
        text: lyrics.state.text.copyWith(textAlign: TextAlign.right),
      ),
    );

    final configCall =
        calls.firstWhere((call) => call.method == 'updateConfig');
    final payload = configCall.arguments as Map<Object?, Object?>;
    expect(payload['textAlign'], 2);
  });
}
