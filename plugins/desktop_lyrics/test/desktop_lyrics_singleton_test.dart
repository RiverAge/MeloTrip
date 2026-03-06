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
    DesktopLyrics().dispose();
  });

  test('default constructor returns shared instance', () {
    final first = DesktopLyrics();
    final second = DesktopLyrics();
    expect(identical(first, second), isTrue);
  });

  test('dispose resets shared instance lifecycle', () {
    final first = DesktopLyrics();
    first.dispose();
    final second = DesktopLyrics();
    expect(identical(first, second), isFalse);
  });

  test('shared instance keeps apply and render in one state', () async {
    final applyRef = DesktopLyrics();
    final renderRef = DesktopLyrics();

    await applyRef.apply(
      applyRef.state.copyWith(
        interaction: applyRef.state.interaction.copyWith(enabled: true),
      ),
    );
    await renderRef.render(const DesktopLyricsFrame.line(currentLine: 'line'));

    final methods = calls.map((e) => e.method).toList();
    expect(methods, contains('updateConfig'));
    expect(methods, contains('updateLyricFrame'));
    expect(renderRef.state.interaction.enabled, isTrue);
  });
}
