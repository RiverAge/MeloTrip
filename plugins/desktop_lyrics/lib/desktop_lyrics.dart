import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class DesktopLyricsLine {
  const DesktopLyricsLine({required this.startMs, required this.values});

  final int startMs;
  final List<String> values;
}

@immutable
class DesktopLyricToken {
  const DesktopLyricToken({required this.text, required this.progress});

  final String text;
  final double progress;
}

@immutable
class DesktopLyricTokenTiming {
  const DesktopLyricTokenTiming({required this.text, required this.durationMs});

  final String text;
  final int durationMs;
}

@immutable
class DesktopLyricFrame {
  const DesktopLyricFrame.line({required this.currentLine, this.lineProgress = 0.0})
    : tokens = const [];

  const DesktopLyricFrame.tokenized({
    required this.tokens,
    this.currentLine = '',
    this.lineProgress = 0.0,
  });

  final String currentLine;
  final double lineProgress;
  final List<DesktopLyricToken> tokens;

  factory DesktopLyricFrame.fromTimedTokens({
    required List<DesktopLyricTokenTiming> tokens,
    required double lineProgress,
  }) {
    final normalized = lineProgress.clamp(0.0, 1.0);
    if (tokens.isEmpty) {
      return DesktopLyricFrame.line(currentLine: '', lineProgress: normalized);
    }
    var total = 0;
    for (final token in tokens) {
      total += token.durationMs > 0 ? token.durationMs : 1;
    }
    var elapsed = 0;
    final mapped = <DesktopLyricToken>[];
    for (final token in tokens) {
      final duration = token.durationMs > 0 ? token.durationMs : 1;
      final start = elapsed / total;
      final end = (elapsed + duration) / total;
      final local = ((normalized - start) / (end - start)).clamp(0.0, 1.0);
      mapped.add(DesktopLyricToken(text: token.text, progress: local));
      elapsed += duration;
    }
    return DesktopLyricFrame.tokenized(
      currentLine: tokens.map((e) => e.text).join(),
      lineProgress: normalized,
      tokens: mapped,
    );
  }
}

@immutable
class DesktopLyricsInteractionConfig {
  const DesktopLyricsInteractionConfig({
    required this.enabled,
    required this.clickThrough,
  });

  final bool enabled;
  final bool clickThrough;
}

@immutable
class DesktopLyricsTextConfig {
  const DesktopLyricsTextConfig({
    required this.fontSize,
    this.textColor,
    this.shadowColor,
    this.strokeColor,
    this.strokeWidth,
    this.fontFamily,
    this.textAlign,
    this.fontWeight,
  });

  final double fontSize;
  final Color? textColor;
  final Color? shadowColor;
  final Color? strokeColor;
  final double? strokeWidth;
  final String? fontFamily;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
}

@immutable
class DesktopLyricsBackgroundConfig {
  const DesktopLyricsBackgroundConfig({
    this.backgroundColor,
    this.backgroundRadius,
    this.backgroundPadding,
  });

  final Color? backgroundColor;
  final double? backgroundRadius;
  final double? backgroundPadding;
}

@immutable
class DesktopLyricsGradientConfig {
  const DesktopLyricsGradientConfig({
    this.textGradientEnabled,
    this.textGradientStartColor,
    this.textGradientEndColor,
    this.textGradientAngle,
  });

  final bool? textGradientEnabled;
  final Color? textGradientStartColor;
  final Color? textGradientEndColor;
  final double? textGradientAngle;
}

@immutable
class DesktopLyricsLayoutConfig {
  const DesktopLyricsLayoutConfig({this.overlayWidth, this.overlayHeight});

  final double? overlayWidth;
  final double? overlayHeight;
}

@immutable
class DesktopLyricsConfig {
  const DesktopLyricsConfig({
    required this.interaction,
    required this.text,
    required this.opacity,
    this.background = const DesktopLyricsBackgroundConfig(),
    this.gradient = const DesktopLyricsGradientConfig(),
    this.layout = const DesktopLyricsLayoutConfig(),
  });

  final DesktopLyricsInteractionConfig interaction;
  final DesktopLyricsTextConfig text;
  final double opacity;
  final DesktopLyricsBackgroundConfig background;
  final DesktopLyricsGradientConfig gradient;
  final DesktopLyricsLayoutConfig layout;
}

@immutable
class DesktopLyricsStateSnapshot {
  const DesktopLyricsStateSnapshot({
    required this.enabled,
    required this.clickThrough,
    required this.fontSize,
    required this.opacity,
    required this.textColorArgb,
    required this.shadowColorArgb,
    required this.strokeColorArgb,
    required this.strokeWidth,
    required this.textGradientEnabled,
    required this.textGradientStartArgb,
    required this.textGradientEndArgb,
    required this.backgroundColorArgb,
    required this.textAlign,
    required this.fontWeightValue,
    required this.overlayWidth,
    required this.overlayHeight,
  });

  final bool enabled;
  final bool clickThrough;
  final double fontSize;
  final double opacity;
  final int textColorArgb;
  final int shadowColorArgb;
  final int strokeColorArgb;
  final double strokeWidth;
  final bool textGradientEnabled;
  final int textGradientStartArgb;
  final int textGradientEndArgb;
  final int backgroundColorArgb;
  final TextAlign textAlign;
  final int fontWeightValue;
  final double overlayWidth;
  final double overlayHeight;
}

class DesktopLyrics {
  DesktopLyrics._({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'desktop_lyrics';
  static final DesktopLyrics instance = DesktopLyrics._();

  final MethodChannel _channel;

  bool _enabled = true;
  bool _clickThrough = false;
  double _fontSize = 38.0;
  double _opacity = 0.96;
  int _textColorArgb = 0xFFF6F7FF;
  int _shadowColorArgb = 0x00000000;
  int _strokeColorArgb = 0x00000000;
  double _strokeWidth = 0.0;
  bool _textGradientEnabled = true;
  int _textGradientStartArgb = 0xFFFFD36E;
  int _textGradientEndArgb = 0xFFFF4D8D;
  int _backgroundColorArgb = 0x7A220A35;
  TextAlign _textAlign = TextAlign.start;
  int _fontWeightValue = FontWeight.w400.value;
  double _overlayWidth = 980.0;
  double _overlayHeight = 160.0;
  bool _autoOverlayHeight = true;
  bool _perfEnabled = false;
  int _perfTargetFps = 0;
  String _perfMode = 'line';
  bool _perfGradient = false;
  int _perfAttempted = 0;
  int _perfSent = 0;
  int _perfDropped = 0;
  int _perfSampleCount = 0;
  double _perfTotalMs = 0.0;
  DateTime _perfLastLogAt = DateTime.now();

  DesktopLyricsStateSnapshot get state => DesktopLyricsStateSnapshot(
    enabled: _enabled,
    clickThrough: _clickThrough,
    fontSize: _fontSize,
    opacity: _opacity,
    textColorArgb: _textColorArgb,
    shadowColorArgb: _shadowColorArgb,
    strokeColorArgb: _strokeColorArgb,
    strokeWidth: _strokeWidth,
    textGradientEnabled: _textGradientEnabled,
    textGradientStartArgb: _textGradientStartArgb,
    textGradientEndArgb: _textGradientEndArgb,
    backgroundColorArgb: _backgroundColorArgb,
    textAlign: _textAlign,
    fontWeightValue: _fontWeightValue,
    overlayWidth: _overlayWidth,
    overlayHeight: _overlayHeight,
  );

  Future<void> show() async => _invoke('show');

  Future<void> hide() async => _invoke('hide');

  Future<void> dispose() async => _invoke('dispose');

  Future<void> updateTrack({
    String? songId,
    String? title,
    String? artist,
    required List<DesktopLyricsLine> lines,
  }) async {
    await _invoke('updateTrack', {
      'songId': songId,
      'title': title,
      'artist': artist,
      'lines': lines.map((e) => {'start': e.startMs, 'value': e.values}).toList(),
    });
  }

  Future<void> updateProgress({
    required Duration position,
    required Duration? duration,
  }) async {
    await _invoke('updateProgress', {
      'positionMs': position.inMilliseconds,
      'durationMs': duration?.inMilliseconds ?? 0,
    });
  }

  Future<void> render(DesktopLyricFrame frame) async {
    _perfAttempted += _perfEnabled ? 1 : 0;
    final sw = _perfEnabled ? (Stopwatch()..start()) : null;
    final result = await _invoke('updateLyricFrame', {
      'currentLine': frame.currentLine,
      'lineProgress': frame.lineProgress.clamp(0.0, 1.0),
      'tokens': frame.tokens
          .map((e) => {'text': e.text, 'progress': e.progress.clamp(0.0, 1.0)})
          .toList(),
    });
    if (_perfEnabled) {
      sw!.stop();
      _perfSampleCount++;
      _perfTotalMs += sw.elapsedMicroseconds / 1000.0;
      if (result == null) {
        _perfDropped++;
      } else {
        _perfSent++;
      }
      final now = DateTime.now();
      if (now.difference(_perfLastLogAt).inMilliseconds >= 1000) {
        final avg = _perfSampleCount == 0 ? 0.0 : _perfTotalMs / _perfSampleCount;
        debugPrint(
          'fps(target=$_perfTargetFps attempted=$_perfAttempted sent=$_perfSent drops=$_perfDropped avg=${avg.toStringAsFixed(2)} ms gradient=$_perfGradient mode=$_perfMode)',
        );
        _perfLastLogAt = now;
        _perfAttempted = 0;
        _perfSent = 0;
        _perfDropped = 0;
        _perfSampleCount = 0;
        _perfTotalMs = 0;
      }
    }
  }

  void setPerformanceProbe({
    required bool enabled,
    int targetFps = 0,
    String mode = 'line',
    bool gradient = false,
  }) {
    _perfEnabled = enabled;
    _perfTargetFps = targetFps;
    _perfMode = mode;
    _perfGradient = gradient;
    _perfAttempted = 0;
    _perfSent = 0;
    _perfDropped = 0;
    _perfSampleCount = 0;
    _perfTotalMs = 0;
    _perfLastLogAt = DateTime.now();
  }

  Future<void> configure(DesktopLyricsConfig config) async {
    final nextEnabled = config.interaction.enabled;
    final nextClickThrough = config.interaction.clickThrough;
    final nextFontSize = config.text.fontSize;
    final nextOpacity = config.opacity;
    final nextTextColorArgb = config.text.textColor?.toARGB32() ?? _textColorArgb;
    final nextShadowColorArgb =
        config.text.shadowColor?.toARGB32() ?? _shadowColorArgb;
    final nextStrokeColorArgb =
        config.text.strokeColor?.toARGB32() ?? _strokeColorArgb;
    final nextStrokeWidth = config.text.strokeWidth ?? _strokeWidth;
    final nextTextGradientEnabled = config.gradient.textGradientEnabled ?? false;
    final nextTextGradientStartArgb =
        config.gradient.textGradientStartColor?.toARGB32() ?? nextTextColorArgb;
    final nextTextGradientEndArgb =
        config.gradient.textGradientEndColor?.toARGB32() ?? nextTextColorArgb;
    final nextBackgroundColorArgb =
        config.background.backgroundColor?.toARGB32() ?? 0x00000000;
    final nextTextAlign = config.text.textAlign ?? TextAlign.start;
    final nextFontWeightValue = config.text.fontWeight?.value ?? FontWeight.w400.value;
    final nextOverlayWidth = config.layout.overlayWidth ?? _overlayWidth;
    final nextAutoOverlayHeight = config.layout.overlayHeight == null;
    final nextOverlayHeight = config.layout.overlayHeight ?? _overlayHeight;

    await _invoke('updateConfig', {
      'enabled': nextEnabled,
      'clickThrough': nextClickThrough,
      'fontSize': nextFontSize,
      'opacity': nextOpacity,
      'textColorArgb': nextTextColorArgb,
      'shadowColorArgb': nextShadowColorArgb,
      'strokeColorArgb': nextStrokeColorArgb,
      'strokeWidth': nextStrokeWidth,
      'backgroundColorArgb': nextBackgroundColorArgb,
      'backgroundRadius': config.background.backgroundRadius ?? 16.0,
      'backgroundPadding': config.background.backgroundPadding ?? 10.0,
      'textGradientEnabled': nextTextGradientEnabled,
      'textGradientStartArgb': nextTextGradientStartArgb,
      'textGradientEndArgb': nextTextGradientEndArgb,
      'textGradientAngle': config.gradient.textGradientAngle ?? 0.0,
      'overlayWidth': nextOverlayWidth,
      // overlayHeight is omitted from payload to signal auto-height mode.
      if (!nextAutoOverlayHeight) 'overlayHeight': nextOverlayHeight,
      'fontFamily': config.text.fontFamily ?? 'Segoe UI',
      'textAlign': _toNativeTextAlign(nextTextAlign),
      'fontWeightValue': nextFontWeightValue,
    });

    _enabled = nextEnabled;
    _clickThrough = nextClickThrough;
    _fontSize = nextFontSize;
    _opacity = nextOpacity;
    _textColorArgb = nextTextColorArgb;
    _shadowColorArgb = nextShadowColorArgb;
    _strokeColorArgb = nextStrokeColorArgb;
    _strokeWidth = nextStrokeWidth;
    _textGradientEnabled = nextTextGradientEnabled;
    _textGradientStartArgb = nextTextGradientStartArgb;
    _textGradientEndArgb = nextTextGradientEndArgb;
    _backgroundColorArgb = nextBackgroundColorArgb;
    _textAlign = nextTextAlign;
    _fontWeightValue = nextFontWeightValue;
    _overlayWidth = nextOverlayWidth;
    _overlayHeight = nextOverlayHeight;
    _autoOverlayHeight = nextAutoOverlayHeight;
  }

  int _toNativeTextAlign(TextAlign value) {
    switch (value) {
      case TextAlign.center:
        return 1;
      case TextAlign.end:
      case TextAlign.right:
        return 2;
      default:
        return 0;
    }
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
