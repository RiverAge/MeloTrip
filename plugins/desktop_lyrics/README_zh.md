# desktop_lyrics

[![pub package](https://img.shields.io/pub/v/desktop_lyrics.svg)](https://pub.dev/packages/desktop_lyrics)

Flutter 桌面悬浮歌词插件。

[English README](README.md)

## 功能特性

- 桌面置顶悬浮歌词窗口。
- 支持单行歌词与逐词/逐字卡拉 OK 进度渲染。
- 运行时可配置样式（字体、对齐、描边、阴影、渐变、背景）。
- 支持交互控制（启用/禁用、点击穿透）。
- 支持布局控制（宽度 + 自动高度）。

## 平台支持

- Windows：已支持
- Linux：已支持
- macOS：暂未实现（调用会安全返回）

## 安装

```yaml
dependencies:
  desktop_lyrics: ^0.0.1
```

## 快速开始

```dart
import 'package:desktop_lyrics/desktop_lyrics.dart';

final lyrics = DesktopLyrics();

await lyrics.applyConfig(
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
    layout: DesktopLyricsLayoutConfig(
      overlayWidth: 980,
    ),
  ),
);

await lyrics.render(
  const DesktopLyricsFrame.line(
    currentLine: 'Never gonna give you up',
    lineProgress: 1.0,
  ),
);
```

## 卡拉 OK 帧构建

使用 `DesktopLyricsFrame.fromTimedTokens`：

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

或使用时间轴 token：

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

## API 摘要

- `DesktopLyrics.applyConfig(DesktopLyricsConfig config)`
- `DesktopLyrics.setEnabled(bool enabled)`
- `DesktopLyrics.config` / `DesktopLyrics.enabled`（只读状态快照）
- `DesktopLyrics.render(DesktopLyricsFrame frame)`
- `DesktopLyrics.state` + `addListener(...)`（用于响应式配置 UI）
- `DesktopLyrics.dispose()`

## 说明

- 插件不负责持久化配置。
- 建议宿主应用自行保存配置并在启动后重新应用。
- `DesktopLyricsFrame.line` 默认 `lineProgress = 1.0`，确保文本可见。
