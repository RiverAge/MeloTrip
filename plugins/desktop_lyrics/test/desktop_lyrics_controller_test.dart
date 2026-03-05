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

  test('applyConfig notifies listeners once', () async {
    final controller = DesktopLyrics(channel: channel);
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.applyConfig(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: true,
          clickThrough: false,
        ),
        text: DesktopLyricsTextConfig(fontSize: 32),
      ),
    );

    expect(notified, 1);
    expect(calls.last.method, 'updateConfig');
  });

  test('setEnabled routes through updateConfig enabled flag', () async {
    final controller = DesktopLyrics(channel: channel);

    await controller.setEnabled(false);
    await controller.setEnabled(true);

    final methodCalls =
        calls.where((call) => call.method == 'updateConfig').toList();
    expect(methodCalls.length, 2);
    final hideArgs = methodCalls[0].arguments as Map<Object?, Object?>;
    final showArgs = methodCalls[1].arguments as Map<Object?, Object?>;
    expect(hideArgs['enabled'], false);
    expect(showArgs['enabled'], true);
    expect(controller.enabled, true);
  });
}
