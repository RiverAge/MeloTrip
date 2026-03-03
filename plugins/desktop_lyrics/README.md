# desktop_lyrics

Desktop floating lyrics plugin for Flutter.

## Features

- Windows desktop floating lyrics overlay.
- Real-time track/progress updates.
- Runtime style config via method channel parameters.
- Drag overlay when click-through is disabled.
- Double-click overlay to reset position near bottom center.

## Platform Support

- Windows: supported
- macOS/Linux: no-op (returns safely when native implementation is missing)

## Installation

```yaml
dependencies:
  desktop_lyrics: ^0.0.1
```

## Usage

```dart
import 'package:desktop_lyrics/desktop_lyrics.dart';

const desktopLyrics = DesktopLyrics();

await desktopLyrics.updateConfig(
  const DesktopLyricsConfig(
    enabled: true,
    clickThrough: false,
    fontSize: 34,
    opacity: 0.93,
    textColorArgb: 0xFFF2F2F8,
    shadowColorArgb: 0xFF121214,
    strokeColorArgb: 0x00000000,
    strokeWidth: 0,
  ),
);

await desktopLyrics.updateTrack(
  songId: 'song-id',
  title: 'Song Title',
  artist: 'Artist',
  lines: const [
    DesktopLyricsLine(startMs: 1200, values: ['First line']),
    DesktopLyricsLine(startMs: 3600, values: ['Second line']),
  ],
);

await desktopLyrics.show();
await desktopLyrics.updateProgress(
  position: const Duration(seconds: 15),
  duration: const Duration(minutes: 4),
);
```

## API

- `show()` / `hide()` / `dispose()`
- `updateTrack({songId, title, artist, lines})`
- `updateProgress({position, duration})`
- `updateConfig(DesktopLyricsConfig config)`
- `getPlatformVersion()`

## Notes

- The plugin does not persist any settings by itself.
- Host app should manage configuration and call `updateConfig` as needed.

