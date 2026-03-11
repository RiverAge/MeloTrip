# MeloTrip

<p align="center">
  <img src="images/icon/icon.png" alt="MeloTrip icon" width="120" />
</p>

<p align="center">
  一个基于 Flutter 构建的 Navidrome / Subsonic 音乐客户端，兼顾移动端体验与桌面端沉浸式播放。
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img alt="Powered by Codex" src="https://img.shields.io/badge/Powered%20by-Codex-111111?logo=openai&logoColor=white" />
  <img alt="Powered by Gemini" src="https://img.shields.io/badge/Powered%20by-Gemini-4285F4?logo=google-gemini&logoColor=white" />
</p>

<p align="center">
  <img alt="Windows" src="https://img.shields.io/badge/Desktop-Windows-0078D6?logo=windows&logoColor=white" />
  <img alt="macOS" src="https://img.shields.io/badge/Desktop-macOS-000000?logo=apple&logoColor=white" />
  <img alt="Linux" src="https://img.shields.io/badge/Desktop-Linux-FCC624?logo=linux&logoColor=black" />
</p>

## 项目简介

MeloTrip 是一个面向个人音乐库的 Flutter 客户端，围绕 Navidrome / Subsonic 生态构建，重点放在播放、搜索、歌单、歌词以及桌面端浏览体验。

当前仓库已经包含：

- 移动端界面与播放控制
- 桌面端独立导航与布局
- Windows / macOS / Linux 桌面工程
- 桌面歌词能力
- 中英文本地化

## 设计方向

- 移动端：保持播放链路直接，尽量减少操作层级。
- 桌面端：更强调侧边导航、内容分栏、全局搜索与播放面板联动。
- 视觉参考：桌面端设计参考了 Feishin。

## 技术栈

- Flutter
- Riverpod
- Dio
- Freezed / Json Serializable
- `media_kit`
- `audio_service`
- `sqflite`

## 平台支持

| Platform | Status |
| --- | --- |
| Android | Supported |
| iOS | Supported |
| Windows | Supported |
| macOS | Supported |
| Linux | Supported |
| Web | Not a current target |

## 本地开发

```bash
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter run
```

开发中常用命令：

```bash
dart run build_runner watch
flutter gen-l10n
dart run flutter_native_splash:create
```

## 质量检查

```bash
flutter analyze
flutter test
```

当前基础测试主要覆盖：

- 本地化资源加载
- 初始路由跳转
- 部分 provider 的空数据与解析行为
- 首页占位内容的存在性

## 说明

- 首页推荐区目前仍保留占位实现。
- 当前版本号见 `pubspec.yaml`：`1.0.8+9`