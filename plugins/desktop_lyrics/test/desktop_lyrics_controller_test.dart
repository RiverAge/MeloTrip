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

  test('default state starts disabled', () {
    final controller = DesktopLyrics(channel: channel);
    expect(controller.state.interaction.enabled, false);
  });

  test('apply notifies listeners once', () async {
    final controller = DesktopLyrics(channel: channel);
    var notified = 0;
    controller.addListener(() => notified++);

    await controller.apply(
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

  test('enabled toggle via apply updates enabled flag', () async {
    final controller = DesktopLyrics(channel: channel);

    await controller.apply(
      controller.state.copyWith(
        interaction: controller.state.interaction.copyWith(enabled: true),
      ),
    );
    await controller.apply(
      controller.state.copyWith(
        interaction: controller.state.interaction.copyWith(enabled: false),
      ),
    );

    final methodCalls =
        calls.where((call) => call.method == 'updateConfig').toList();
    expect(methodCalls.length, 2);
    final showArgs = methodCalls[0].arguments as Map<Object?, Object?>;
    final hideArgs = methodCalls[1].arguments as Map<Object?, Object?>;
    expect(showArgs['enabled'], true);
    expect(hideArgs['enabled'], false);
    expect(controller.state.interaction.enabled, false);
  });

  test('state snapshot reflects applied config fields', () async {
    final controller = DesktopLyrics(channel: channel);

    await controller.apply(
      const DesktopLyricsConfig(
        interaction: DesktopLyricsInteractionConfig(
          enabled: false,
          clickThrough: true,
        ),
        text: DesktopLyricsTextConfig(
          fontSize: 44,
          textColor: Color(0xFF102030),
          shadowColor: Color(0x80101010),
          strokeColor: Color(0xFF405060),
          strokeWidth: 2.0,
          fontFamily: 'Segoe UI',
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w700,
        ),
        background: DesktopLyricsBackgroundConfig(
          opacity: 0.77,
          backgroundColor: Color(0xAA112233),
          backgroundRadius: 20,
          backgroundPadding: 14,
        ),
        gradient: DesktopLyricsGradientConfig(
          textGradientEnabled: true,
          textGradientStartColor: Color(0xFFFFAA00),
          textGradientEndColor: Color(0xFF00AABB),
          textGradientAngle: 12,
        ),
        layout: DesktopLyricsLayoutConfig(
          overlayWidth: 1111,
        ),
      ),
    );

    final state = controller.state;
    expect(state.interaction.enabled, false);
    expect(state.interaction.clickThrough, true);
    expect(state.text.fontSize, 44);
    expect(state.background.opacity, 0.77);
    expect(state.text.textColor, const Color(0xFF102030));
    expect(state.text.shadowColor, const Color(0x80101010));
    expect(state.text.strokeColor, const Color(0xFF405060));
    expect(state.text.strokeWidth, 2.0);
    expect(state.gradient.textGradientEnabled, true);
    expect(state.gradient.textGradientStartColor, const Color(0xFFFFAA00));
    expect(state.gradient.textGradientEndColor, const Color(0xFF00AABB));
    expect(state.gradient.textGradientAngle, 12);
    expect(state.background.backgroundColor, const Color(0xAA112233));
    expect(state.background.backgroundRadius, 20);
    expect(state.background.backgroundPadding, 14);
    expect(state.text.textAlign, TextAlign.center);
    expect(state.text.fontFamily, 'Segoe UI');
    expect(state.text.fontWeight, FontWeight.w700);
    expect(state.layout.overlayWidth, 1111);
  });
}
