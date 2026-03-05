# desktop_lyrics

Desktop floating lyrics plugin for Flutter.

## Features

- Windows desktop floating lyrics overlay.
- Real-time frame rendering (line or tokenized karaoke progress).
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

final lyrics = DesktopLyrics();

await lyrics.setConfig(
  const DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: true,
      clickThrough: false,
    ),
    text: DesktopLyricsTextConfig(
      fontSize: 34,
    ),
    background: DesktopLyricsBackgroundConfig(
      opacity: 0.93,
    ),
  ),
);

await lyrics.setEnabled(true);
await lyrics.render(
  const DesktopLyricsFrame.line(
    currentLine: 'First line',
    lineProgress: 1.0,
  ),
);

// Optional: enable internal rate limit (disabled by default).
lyrics.setRenderRateLimit(maxFps: 60, minProgressDelta: 0.01);

lyrics.dispose();
```

## API

- `DesktopLyrics` (recommended)
  - `setConfig(DesktopLyricsConfig config)` or `config = ...`
  - `setEnabled(bool enabled)`
  - `render(DesktopLyricsFrame frame)`
  - `setRenderRateLimit({int maxFps = 0, double minProgressDelta = 0.0})`
  - `state` + `addListener(...)` for reactive UI updates

## Notes

- The plugin does not persist any settings by itself.
- Host app should manage configuration and call `setConfig` (or assign `config`) as needed.

