# MeloTrip

[English](README.md) | 简体中文

<p align="center">
  <img src="images/icon/icon.png" alt="MeloTrip icon" width="120" />
</p>

<p align="center">
  一个面向 Navidrome 与 Subsonic 服务端的 Flutter 音乐客户端，兼顾移动端听歌体验与桌面端音乐库管理。
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img alt="Powered by Codex" src="https://img.shields.io/badge/Powered%20by-Codex-111111?logo=openai&logoColor=white" />
  <img alt="Powered by Gemini" src="https://img.shields.io/badge/Powered%20by-Gemini-4285F4?logo=google-gemini&logoColor=white" />
  <img alt="Platforms" src="https://img.shields.io/badge/Platforms-Android%20%7C%20iOS%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-2E7D32" />
  <img alt="License" src="https://img.shields.io/badge/License-MIT-black" />
</p>

## 项目简介

MeloTrip 是一个基于 Flutter 构建的跨平台音乐客户端，面向 Navidrome 与 Subsonic API 生态。项目重点放在顺畅的播放链路、快速搜索、歌单与收藏管理、歌词体验，以及更适合桌面场景的原生化交互，而不是简单放大移动端界面。

## 主要特性

- 支持 Android、iOS、Windows、macOS、Linux
- 移动端与桌面端分别适配的界面布局
- 基于 `media_kit` 与 `audio_service` 的播放能力
- 提供搜索、专辑、歌手、歌曲、歌单与收藏等核心功能
- 支持桌面歌词显示
- 内置英文与简体中文本地化

## 平台支持

| Platform | Status |
| --- | --- |
| Android | Supported |
| iOS | Supported |
| Windows | Supported |
| macOS | Supported |
| Linux | Supported |
| Web | Not targeted currently |

## 技术栈

- Flutter
- Riverpod
- Dio
- Freezed + json_serializable
- `media_kit`
- `audio_service`
- `sqflite`

## 快速开始

### 环境要求

- Flutter 3.x
- 与 `pubspec.yaml` 中声明版本兼容的 Dart SDK
- 可访问的 Navidrome 或兼容 Subsonic 的服务端

### 初始化

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### 常用开发命令

```bash
dart run build_runner watch
flutter gen-l10n
dart run flutter_native_splash:create
flutter analyze
flutter test
```

## 本地化

所有面向用户的文案都通过 Flutter l10n 资源管理，当前已提供英文与简体中文。
