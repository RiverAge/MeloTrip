# desktop_lyrics

[![pub package](https://img.shields.io/pub/v/desktop_lyrics.svg)](https://pub.dev/packages/desktop_lyrics)
[![Powered by Codex](https://img.shields.io/badge/Powered%20by-Codex-0A84FF?logo=openai&logoColor=white)](https://openai.com)
[![Gemini](https://img.shields.io/badge/Gemini-1A73E8?logo=google&logoColor=white)](https://gemini.google.com)

Desktop floating lyrics overlay plugin for Flutter.

[中文文档](README_zh.md)

## Features

- Floating top-most lyrics window for desktop.
- Supports both static line rendering and token/timeline karaoke progress.
- Runtime style configuration (font, alignment, stroke, shadow, gradient, background).
- Overlay interaction controls (enable/disable, click-through).
- Layout controls (width + optional auto height).

## Platform Support

- Windows: supported
- Linux: supported
  - Wayland: click-through is currently not supported due to technical limitations.
- macOS: currently not implemented (calls return safely)

## Installation

```yaml
dependencies:
  desktop_lyrics: ^0.0.1
```

## Quick Start

```dart
import 'package:desktop_lyrics/desktop_lyrics.dart';

final lyrics = DesktopLyrics();

void onLyricsChanged() {
  final enabled = lyrics.state.interaction.enabled;
  // update UI with state fields
}

lyrics.addListener(onLyricsChanged);

await lyrics.apply(
  lyrics.state.copyWith(
    interaction: lyrics.state.interaction.copyWith(
      enabled: true,
      clickThrough: false,
    ),
    text: lyrics.state.text.copyWith(fontSize: 34),
    background: lyrics.state.background.copyWith(opacity: 0.93),
    layout: lyrics.state.layout.copyWith(overlayWidth: 980),
  ),
);

await lyrics.render(
  const DesktopLyricsFrame.line(
    currentLine: 'Never gonna give you up',
    lineProgress: 1.0,
  ),
);

lyrics.removeListener(onLyricsChanged);
lyrics.dispose();
```

## Karaoke Frames

Use `DesktopLyricsFrame.fromTimedTokens`:

```dart
final frame = DesktopLyricsFrame.fromTimedTokens(
  tokens: const [
    DesktopLyricsTokenTiming(text: 'Never ', duration: Duration(milliseconds: 700)),
    DesktopLyricsTokenTiming(text: 'gonna ', duration: Duration(milliseconds: 600)),
    DesktopLyricsTokenTiming(text: 'give ', duration: Duration(milliseconds: 500)),
    DesktopLyricsTokenTiming(text: 'you up', duration: Duration(milliseconds: 700)),
  ],
  lineProgress: 0.45,
);
await lyrics.render(frame);
```

Or use timeline tokens:

```dart
final frame = DesktopLyricsFrame.fromKaraokeTimeline(
  position: position,
  tokens: const [
    DesktopLyricsTimelineToken(
      text: 'Ne',
      start: Duration.zero,
      end: Duration(milliseconds: 250),
    ),
    DesktopLyricsTimelineToken(
      text: 'ver ',
      start: Duration(milliseconds: 250),
      end: Duration(milliseconds: 700),
    ),
  ],
);
await lyrics.render(frame);
```

## API Summary

- `DesktopLyrics.apply(DesktopLyricsConfig config)`
- `DesktopLyrics.state` (single read entry)
- `DesktopLyrics.render(DesktopLyricsFrame frame)`
- `DesktopLyrics.addListener(...)` / `removeListener(...)`
- `DesktopLyrics.dispose()`

## Publish (Tag + Trusted Publisher)

1. Ensure `pubspec.yaml` version matches your target tag version.
2. Create and push tag:
   - `git tag v0.0.1`
   - `git push origin v0.0.1`
3. The `desktop_lyrics_publish` workflow will run and publish automatically.

Trusted Publisher setup (one-time on pub.dev):

1. Go to package admin page on pub.dev.
2. Add trusted publisher for GitHub repository `587626/desktop_lyrics`.
3. Keep workflow permission `id-token: write` (already configured in `publish.yml`).

## Notes

- Linux known issue: overlay size/position does not automatically follow system scaling or resolution changes (can occur on both X11 and Wayland).
