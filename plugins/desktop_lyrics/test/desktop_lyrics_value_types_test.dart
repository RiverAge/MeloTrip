import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('token timing and timeline token constructors are usable', () {
    const timed = DesktopLyricsTokenTiming(
      text: 'A',
      duration: Duration(milliseconds: 120),
    );
    const timeline = DesktopLyricsTimelineToken(
      text: 'B',
      start: Duration(milliseconds: 10),
      end: Duration(milliseconds: 90),
    );
    expect(timed.text, 'A');
    expect(timeline.text, 'B');
  });

  test('fromTimedTokens handles empty tokens', () {
    final frame = DesktopLyricsFrame.fromTimedTokens(
      tokens: const [],
      lineProgress: 0.3,
    );

    expect(frame.currentLine, '');
    expect(frame.tokens, isEmpty);
    expect(frame.lineProgress, 0.3);
  });

  test('config value objects support equality/hashCode/copyWith', () {
    const interaction = DesktopLyricsInteractionConfig(
      enabled: true,
      clickThrough: false,
    );
    final interaction2 = interaction.copyWith(clickThrough: true);
    expect(interaction2.enabled, true);
    expect(interaction2.clickThrough, true);
    expect(interaction == interaction2, false);
    expect(interaction.hashCode == interaction2.hashCode, false);

    const text = DesktopLyricsTextConfig(
      fontSize: 32,
      textColor: Color(0xFFFFFFFF),
      shadowColor: Color(0x66000000),
      strokeColor: Color(0xFF000000),
      strokeWidth: 1,
      fontFamily: 'Segoe UI',
      textAlign: TextAlign.center,
      fontWeight: FontWeight.w600,
    );
    final text2 = text.copyWith(fontSize: 36, textAlign: TextAlign.end);
    expect(text2.fontSize, 36);
    expect(text2.textAlign, TextAlign.end);
    expect(text2.hashCode, isNot(text.hashCode));
    expect(text.copyWith(), text);

    const background = DesktopLyricsBackgroundConfig(
      opacity: 0.8,
      backgroundColor: Color(0xAA112233),
      backgroundRadius: 18,
      backgroundPadding: 12,
    );
    final background2 = background.copyWith(backgroundPadding: 16);
    expect(background2.backgroundPadding, 16);
    expect(background2, isNot(background));
    expect(background.copyWith(), background);

    const gradient = DesktopLyricsGradientConfig(
      textGradientEnabled: true,
      textGradientStartColor: Color(0xFFFFAA00),
      textGradientEndColor: Color(0xFF00AABB),
      textGradientAngle: 20,
    );
    final gradient2 = gradient.copyWith(textGradientEnabled: false);
    expect(gradient2.textGradientEnabled, false);
    expect(gradient2, isNot(gradient));
    expect(gradient.copyWith(), gradient);

    const layout = DesktopLyricsLayoutConfig(overlayWidth: 900);
    final layout2 = layout.copyWith(overlayWidth: 1200);
    expect(layout2.overlayWidth, 1200);
    expect(layout2.hashCode, isNot(layout.hashCode));
    expect(layout.copyWith(), layout);

    final config = DesktopLyricsConfig(
      interaction: interaction,
      text: text,
      background: background,
      gradient: gradient,
      layout: layout,
    );
    final config2 = config.copyWith(
      interaction: interaction2,
      text: text2,
      background: background2,
      gradient: gradient2,
      layout: layout2,
    );
    expect(config2.interaction.clickThrough, true);
    expect(config2.text.fontSize, 36);
    expect(config2.background.backgroundPadding, 16);
    expect(config2.gradient.textGradientEnabled, false);
    expect(config2.layout.overlayWidth, 1200);
    expect(config2 == config, false);
    expect(config2.hashCode == config.hashCode, false);
    expect(config.copyWith(), config);
  });

  test('state snapshot copyWith/toConfig are stable', () {
    const snapshot = DesktopLyricsStateSnapshot(
      interaction: DesktopLyricsInteractionConfig(
        enabled: false,
        clickThrough: true,
      ),
      text: DesktopLyricsTextConfig(fontSize: 30),
      background: DesktopLyricsBackgroundConfig(),
      gradient: DesktopLyricsGradientConfig(),
      layout: DesktopLyricsLayoutConfig(overlayWidth: 800),
    );

    final config = snapshot.toConfig();
    expect(config.interaction.enabled, false);
    expect(config.layout.overlayWidth, 800);

    final updated = snapshot.copyWith(
      interaction: snapshot.interaction.copyWith(enabled: true),
    );
    expect(updated.interaction.enabled, true);
    expect(updated.interaction.clickThrough, true);

    final snapshot2 = DesktopLyricsStateSnapshot(
      interaction: snapshot.interaction,
      text: snapshot.text,
      background: snapshot.background,
      gradient: snapshot.gradient,
      layout: snapshot.layout,
    );
    expect(snapshot2, snapshot);
    expect(snapshot2.hashCode, snapshot.hashCode);
  });
}
