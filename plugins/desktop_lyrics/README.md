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

final desktopLyrics = DesktopLyrics.instance;

await desktopLyrics.configure(
  const DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: true,
      clickThrough: false,
    ),
    text: DesktopLyricsTextConfig(
      fontSize: 34,
    ),
    opacity: 0.93,
  ),
);

await desktopLyrics.show();
await desktopLyrics.render(
  const DesktopLyricFrame.line(
    currentLine: 'First line',
    lineProgress: 1.0,
  ),
);
```

## API

- `show()` / `hide()` / `dispose()`
- `configure(DesktopLyricsConfig config)`
- `render(DesktopLyricFrame frame)`

## Notes

- The plugin does not persist any settings by itself.
- Host app should manage configuration and call `configure` as needed.

