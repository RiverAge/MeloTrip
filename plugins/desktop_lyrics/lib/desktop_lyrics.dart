import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class DesktopLyricsLine {
  const DesktopLyricsLine({
    required this.startMs,
    required this.values,
  });

  final int startMs;
  final List<String> values;
}

@immutable
class DesktopLyricsConfig {
  const DesktopLyricsConfig({
    required this.enabled,
    required this.clickThrough,
    required this.fontSize,
    required this.opacity,
    this.textColorArgb,
    this.shadowColorArgb,
    this.strokeColorArgb,
    this.strokeWidth,
  });

  final bool enabled;
  final bool clickThrough;
  final double fontSize;
  final double opacity;
  final int? textColorArgb;
  final int? shadowColorArgb;
  final int? strokeColorArgb;
  final double? strokeWidth;
}

class DesktopLyrics {
  const DesktopLyrics({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'desktop_lyrics';
  final MethodChannel _channel;

  Future<void> show() async => _invoke('show');

  Future<void> hide() async => _invoke('hide');

  Future<void> dispose() async => _invoke('dispose');

  Future<void> updateTrack({
    required String? songId,
    required String? title,
    required String? artist,
    required List<DesktopLyricsLine> lines,
  }) async {
    await _invoke('updateTrack', {
      'songId': songId,
      'title': title,
      'artist': artist,
      'lines': lines
          .map((line) => {'start': line.startMs, 'value': line.values})
          .toList(),
    });
  }

  Future<void> updateProgress({
    required Duration position,
    required Duration? duration,
  }) async {
    await _invoke('updateProgress', {
      'positionMs': position.inMilliseconds,
      'durationMs': duration?.inMilliseconds,
    });
  }

  Future<void> updateConfig(DesktopLyricsConfig config) async {
    await _invoke('updateConfig', {
      'enabled': config.enabled,
      'clickThrough': config.clickThrough,
      'fontSize': config.fontSize,
      'opacity': config.opacity,
      'textColorArgb': config.textColorArgb,
      'shadowColorArgb': config.shadowColorArgb,
      'strokeColorArgb': config.strokeColorArgb,
      'strokeWidth': config.strokeWidth,
    });
  }

  Future<String?> getPlatformVersion() async {
    final value = await _invoke<String>('getPlatformVersion');
    return value;
  }

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null;
    } on PlatformException catch (err) {
      debugPrint('desktop_lyrics $method failed: ${err.message}');
      return null;
    }
  }
}
