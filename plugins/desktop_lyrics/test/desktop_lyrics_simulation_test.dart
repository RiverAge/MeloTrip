import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('desktop_lyrics');
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

  test('simulated karaoke frames can be streamed continuously', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.configure(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: true,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(fontSize: 28),
        background: DesktopLyricsBackgroundConfig(opacity: 0.92),
      ),
    );
    await lyrics.show();

    for (var i = 0; i <= 20; i++) {
      final lineProgress = i / 20.0;
      final tokenA = (lineProgress * 1.4).clamp(0.0, 1.0);
      final tokenB = ((lineProgress - 0.3) * 1.5).clamp(0.0, 1.0);
      final tokenC = ((lineProgress - 0.65) * 2.2).clamp(0.0, 1.0);

      await lyrics.render(
        DesktopLyricsFrame.tokenized(
          lineProgress: lineProgress,
          tokens: [
            DesktopLyricsToken(text: 'Hello ', progress: tokenA),
            DesktopLyricsToken(text: 'desktop ', progress: tokenB),
            DesktopLyricsToken(text: 'lyrics', progress: tokenC),
          ],
        ),
      );
    }

    await lyrics.hide();
    await lyrics.dispose();

    final renderCalls =
        calls.where((call) => call.method == 'updateLyricFrame').toList();
    expect(renderCalls.length, 21);

    final firstFrame = renderCalls.first.arguments as Map<Object?, Object?>;
    final lastFrame = renderCalls.last.arguments as Map<Object?, Object?>;
    expect(firstFrame['lineProgress'], 0.0);
    expect(lastFrame['lineProgress'], 1.0);
    expect(firstFrame['currentLine'], 'Hello desktop lyrics');
  });

  test('line frame uses visible default progress when omitted', () async {
    final lyrics = DesktopLyrics(channel: channel);
    await lyrics.render(const DesktopLyricsFrame.line(currentLine: 'Visible'));
    final renderCalls =
        calls.where((call) => call.method == 'updateLyricFrame').toList();
    final payload = renderCalls.last.arguments as Map<Object?, Object?>;
    expect(payload['lineProgress'], 1.0);
  });
}
