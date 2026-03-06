# desktop_lyrics

[![pub package](https://img.shields.io/pub/v/desktop_lyrics.svg)](https://pub.dev/packages/desktop_lyrics)
[![Powered by Codex](https://img.shields.io/badge/Powered%20by-Codex-0A84FF?logo=openai&logoColor=white)](https://openai.com)
[![Gemini](https://img.shields.io/badge/Gemini-1A73E8?logo=google&logoColor=white)](https://gemini.google.com)

Flutter 桌面悬浮歌词插件。

[English README](README.md)

## 功能特性

- 桌面置顶悬浮歌词窗口。
- 支持单行歌词与逐词/逐字卡拉 OK 进度渲染。
- 支持运行时样式配置（字体、对齐、描边、阴影、渐变、背景）。
- 支持交互控制（启用/禁用、点击穿透）。
- 支持布局控制（宽度 + 可选自动高度）。

## 平台支持

- Windows：已支持
- Linux：已支持
  - Wayland：由于技术原因，暂不支持点击穿透。
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
// Default: disabled. Call apply(enabled: true) before showing overlay.

void onLyricsChanged() {
  final enabled = lyrics.state.interaction.enabled;
  // 使用 state 字段更新 UI
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

- `DesktopLyrics.apply(DesktopLyricsConfig config)`
- `DesktopLyrics.state`（唯一读取入口）
- `DesktopLyrics.render(DesktopLyricsFrame frame)`
- `DesktopLyrics.addListener(...)` / `removeListener(...)`
- `DesktopLyrics.dispose()`

## 说明

- Linux 已知问题：悬浮窗不会自动跟随系统缩放或分辨率变化（X11 与 Wayland 都可能出现）。


- Default visibility is `enabled: false`.