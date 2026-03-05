import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('fromTimedTokens maps line progress to token progress', () {
    final frame = DesktopLyricsFrame.fromTimedTokens(
      lineProgress: 0.5,
      tokens: const [
        DesktopLyricsTokenTiming(text: 'Never ', duration: Duration(seconds: 1)),
        DesktopLyricsTokenTiming(text: 'gonna ', duration: Duration(seconds: 1)),
        DesktopLyricsTokenTiming(text: 'give ', duration: Duration(seconds: 1)),
        DesktopLyricsTokenTiming(text: 'you up', duration: Duration(seconds: 1)),
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
      position: const Duration(milliseconds: 2500),
      tokens: const [
        DesktopLyricsTimelineToken(
          text: 'Ne',
          start: Duration.zero,
          end: Duration(seconds: 1),
        ),
        DesktopLyricsTimelineToken(
          text: 'ver ',
          start: Duration(seconds: 1),
          end: Duration(seconds: 2),
        ),
        DesktopLyricsTimelineToken(
          text: 'go',
          start: Duration(seconds: 2),
          end: Duration(seconds: 3),
        ),
        DesktopLyricsTimelineToken(
          text: 'nna',
          start: Duration(seconds: 3),
          end: Duration(seconds: 4),
        ),
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
