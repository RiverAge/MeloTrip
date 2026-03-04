import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromTimedTokens maps line progress to token progress', () {
    final frame = DesktopLyricsFrame.fromTimedTokens(
      lineProgress: 0.5,
      tokens: const [
        DesktopLyricsTokenTiming(text: 'Never ', durationMs: 1000),
        DesktopLyricsTokenTiming(text: 'gonna ', durationMs: 1000),
        DesktopLyricsTokenTiming(text: 'give ', durationMs: 1000),
        DesktopLyricsTokenTiming(text: 'you up', durationMs: 1000),
      ],
    );

    expect(frame.currentLine, 'Never gonna give you up');
    expect(frame.tokens.length, 4);
    expect(frame.tokens[0].progress, 1.0);
    expect(frame.tokens[1].progress, 1.0);
    expect(frame.tokens[2].progress, 0.0);
    expect(frame.tokens[3].progress, 0.0);
  });

  test('fromKaraokeTimeline computes line and token progress by position', () {
    final frame = DesktopLyricsFrame.fromKaraokeTimeline(
      positionMs: 2500,
      tokens: const [
        DesktopLyricsTimelineToken(text: 'Ne', startMs: 0, endMs: 1000),
        DesktopLyricsTimelineToken(text: 'ver ', startMs: 1000, endMs: 2000),
        DesktopLyricsTimelineToken(text: 'go', startMs: 2000, endMs: 3000),
        DesktopLyricsTimelineToken(text: 'nna', startMs: 3000, endMs: 4000),
      ],
    );

    expect(frame.currentLine, 'Never gonna');
    expect(frame.lineProgress, closeTo(0.625, 0.0001));
    expect(frame.tokens[0].progress, 1.0);
    expect(frame.tokens[1].progress, 1.0);
    expect(frame.tokens[2].progress, 0.5);
    expect(frame.tokens[3].progress, 0.0);
  });
}
