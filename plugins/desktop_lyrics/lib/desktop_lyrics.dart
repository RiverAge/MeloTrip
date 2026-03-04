import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

@immutable
class DesktopLyricsToken {
  const DesktopLyricsToken({required this.text, required this.progress});

  final String text;
  final double progress;
}

@immutable
class DesktopLyricsTokenTiming {
  const DesktopLyricsTokenTiming({required this.text, required this.durationMs});

  final String text;
  final int durationMs;
}

@immutable
class DesktopLyricsTimelineToken {
  const DesktopLyricsTimelineToken({
    required this.text,
    required this.startMs,
    required this.endMs,
  });

  final String text;
  final int startMs;
  final int endMs;
}

@immutable
class DesktopLyricsFrame {
  // `.line` is for static single-line display by default, so progress defaults
  // to fully visible. Callers can pass a custom value when they need sweeping.
  const DesktopLyricsFrame.line({required this.currentLine, this.lineProgress = 1.0})
    : tokens = const [];

  const DesktopLyricsFrame.tokenized({
    required this.tokens,
    this.currentLine = '',
    this.lineProgress = double.nan,
  });

  final String currentLine;
  final double lineProgress;
  final List<DesktopLyricsToken> tokens;

  factory DesktopLyricsFrame.fromTimedTokens({
    required List<DesktopLyricsTokenTiming> tokens,
    required double lineProgress,
  }) {
    final normalized = lineProgress.clamp(0.0, 1.0);
    if (tokens.isEmpty) {
      return DesktopLyricsFrame.line(currentLine: '', lineProgress: normalized);
    }
    var total = 0;
    for (final token in tokens) {
      total += token.durationMs > 0 ? token.durationMs : 1;
    }
    var elapsed = 0;
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final duration = token.durationMs > 0 ? token.durationMs : 1;
      final start = elapsed / total;
      final end = (elapsed + duration) / total;
      final local = ((normalized - start) / (end - start)).clamp(0.0, 1.0);
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
      elapsed += duration;
    }
    return DesktopLyricsFrame.tokenized(
      currentLine: tokens.map((e) => e.text).join(),
      lineProgress: normalized,
      tokens: mapped,
    );
  }

  factory DesktopLyricsFrame.fromKaraokeTimeline({
    required int positionMs,
    required List<DesktopLyricsTimelineToken> tokens,
  }) {
    if (tokens.isEmpty) {
      return const DesktopLyricsFrame.line(currentLine: '', lineProgress: 1.0);
    }
    final minStart = tokens.first.startMs;
    final maxEnd = tokens.last.endMs;
    final total = (maxEnd - minStart).clamp(1, 1 << 30);
    final normalized =
        ((positionMs - minStart) / total).clamp(0.0, 1.0).toDouble();
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final denom = (token.endMs - token.startMs).clamp(1, 1 << 30);
      final local =
          ((positionMs - token.startMs) / denom).clamp(0.0, 1.0).toDouble();
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
    }
    return DesktopLyricsFrame.tokenized(
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsInteractionConfig &&
          enabled == other.enabled &&
          clickThrough == other.clickThrough;

  @override
  int get hashCode => Object.hash(enabled, clickThrough);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsTextConfig &&
          fontSize == other.fontSize &&
          textColor == other.textColor &&
          shadowColor == other.shadowColor &&
          strokeColor == other.strokeColor &&
          strokeWidth == other.strokeWidth &&
          fontFamily == other.fontFamily &&
          textAlign == other.textAlign &&
          fontWeight == other.fontWeight;

  @override
  int get hashCode => Object.hash(
    fontSize,
    textColor,
    shadowColor,
    strokeColor,
    strokeWidth,
    fontFamily,
    textAlign,
    fontWeight,
  );
}

@immutable
class DesktopLyricsBackgroundConfig {
  const DesktopLyricsBackgroundConfig({
    this.backgroundColor,
    this.backgroundRadius = 16.0,
    this.backgroundPadding = 10.0,
  });

  final Color? backgroundColor;
  final double backgroundRadius;
  final double backgroundPadding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsBackgroundConfig &&
          backgroundColor == other.backgroundColor &&
          backgroundRadius == other.backgroundRadius &&
          backgroundPadding == other.backgroundPadding;

  @override
  int get hashCode =>
      Object.hash(backgroundColor, backgroundRadius, backgroundPadding);
}

@immutable
class DesktopLyricsGradientConfig {
  const DesktopLyricsGradientConfig({
    this.textGradientEnabled,
    this.textGradientStartColor,
    this.textGradientEndColor,
    this.textGradientAngle = 0.0,
  });

  final bool? textGradientEnabled;
  final Color? textGradientStartColor;
  final Color? textGradientEndColor;
  final double textGradientAngle;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsGradientConfig &&
          textGradientEnabled == other.textGradientEnabled &&
          textGradientStartColor == other.textGradientStartColor &&
          textGradientEndColor == other.textGradientEndColor &&
          textGradientAngle == other.textGradientAngle;

  @override
  int get hashCode => Object.hash(
    textGradientEnabled,
    textGradientStartColor,
    textGradientEndColor,
    textGradientAngle,
  );
}

@immutable
class DesktopLyricsLayoutConfig {
  const DesktopLyricsLayoutConfig({this.overlayWidth, this.overlayHeight});

  final double? overlayWidth;
  final double? overlayHeight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsLayoutConfig &&
          overlayWidth == other.overlayWidth &&
          overlayHeight == other.overlayHeight;

  @override
  int get hashCode => Object.hash(overlayWidth, overlayHeight);
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsConfig &&
          interaction == other.interaction &&
          text == other.text &&
          opacity == other.opacity &&
          background == other.background &&
          gradient == other.gradient &&
          layout == other.layout;

  @override
  int get hashCode =>
      Object.hash(interaction, text, opacity, background, gradient, layout);

  DesktopLyricsConfig copyWith({
    DesktopLyricsInteractionConfig? interaction,
    DesktopLyricsTextConfig? text,
    double? opacity,
    DesktopLyricsBackgroundConfig? background,
    DesktopLyricsGradientConfig? gradient,
    DesktopLyricsLayoutConfig? layout,
  }) {
    return DesktopLyricsConfig(
      interaction: interaction ?? this.interaction,
      text: text ?? this.text,
      opacity: opacity ?? this.opacity,
      background: background ?? this.background,
      gradient: gradient ?? this.gradient,
      layout: layout ?? this.layout,
    );
  }
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
    required this.textGradientAngle,
    required this.backgroundColorArgb,
    required this.backgroundRadius,
    required this.backgroundPadding,
    required this.textAlign,
    required this.fontFamily,
    required this.fontWeightValue,
    required this.autoOverlayHeight,
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
  final double textGradientAngle;
  final int backgroundColorArgb;
  final double backgroundRadius;
  final double backgroundPadding;
  final TextAlign textAlign;
  final String fontFamily;
  final int fontWeightValue;
  final bool autoOverlayHeight;
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
  double _backgroundRadius = 16.0;
  double _backgroundPadding = 10.0;
  String _fontFamily = 'Segoe UI';
  double _textGradientAngle = 0.0;
  bool _autoOverlayHeight = true;
  final _perf = _PerformanceTracker();
  static const int _minRenderIntervalMs = 33;
  static const double _minProgressDelta = 0.01;
  DateTime _lastRenderAt = DateTime.fromMillisecondsSinceEpoch(0);
  String _lastRenderLine = '';
  double _lastRenderProgress = 1.0;

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
    textGradientAngle: _textGradientAngle,
    backgroundColorArgb: _backgroundColorArgb,
    backgroundRadius: _backgroundRadius,
    backgroundPadding: _backgroundPadding,
    textAlign: _textAlign,
    fontFamily: _fontFamily,
    fontWeightValue: _fontWeightValue,
    autoOverlayHeight: _autoOverlayHeight,
    overlayWidth: _overlayWidth,
    overlayHeight: _overlayHeight,
  );

  Future<void> show() async => _invoke('show');

  Future<void> hide() async => _invoke('hide');

  Future<void> dispose() async => _invoke('dispose');

  Future<void> render(DesktopLyricsFrame frame) async {
    final currentLine = frame.currentLine.isNotEmpty
        ? frame.currentLine
        : frame.tokens.map((e) => e.text).join();
    final rawProgress = frame.lineProgress;
    final tokensProgress = _deriveProgressFromTokens(frame.tokens);
    final double currentProgress = rawProgress.isFinite
        ? rawProgress.clamp(0.0, 1.0).toDouble()
        : (tokensProgress ?? 1.0);
    final now = DateTime.now();
    final sameLine = currentLine == _lastRenderLine;
    final smallDelta =
        (currentProgress - _lastRenderProgress).abs() < _minProgressDelta;
    final withinInterval =
        now.difference(_lastRenderAt).inMilliseconds < _minRenderIntervalMs;
    if (sameLine && smallDelta && withinInterval) {
      _perf.recordThrottled();
      return;
    }
    _lastRenderAt = now;
    _lastRenderLine = currentLine;
    _lastRenderProgress = currentProgress;

    final sw = _perf.startAttempt();
    final result = await _invoke('updateLyricFrame', {
      'currentLine': currentLine,
      'lineProgress': currentProgress,
    });
    _perf.recordResult(sw, success: result != null);
    _perf.maybeLog();
  }

  void setPerformanceProbe({
    required bool enabled,
    int targetFps = 0,
    String mode = 'line',
    bool gradient = false,
  }) {
    _perf.configure(
      enabled: enabled,
      targetFps: targetFps,
      mode: mode,
      gradient: gradient,
    );
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
        config.gradient.textGradientStartColor?.toARGB32() ?? _textGradientStartArgb;
    final nextTextGradientEndArgb =
        config.gradient.textGradientEndColor?.toARGB32() ?? _textGradientEndArgb;
    final nextBackgroundColorArgb =
        config.background.backgroundColor?.toARGB32() ?? _backgroundColorArgb;
    final nextBackgroundRadius = config.background.backgroundRadius;
    final nextBackgroundPadding = config.background.backgroundPadding;
    final nextGradientAngle = config.gradient.textGradientAngle;
    final nextTextAlign = config.text.textAlign ?? TextAlign.start;
    final nextFontFamily = config.text.fontFamily ?? _fontFamily;
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
      'backgroundRadius': nextBackgroundRadius,
      'backgroundPadding': nextBackgroundPadding,
      'textGradientEnabled': nextTextGradientEnabled,
      'textGradientStartArgb': nextTextGradientStartArgb,
      'textGradientEndArgb': nextTextGradientEndArgb,
      'textGradientAngle': nextGradientAngle,
      'overlayWidth': nextOverlayWidth,
      // overlayHeight is omitted from payload to signal auto-height mode.
      if (!nextAutoOverlayHeight) 'overlayHeight': nextOverlayHeight,
      'fontFamily': nextFontFamily,
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
    _textGradientAngle = nextGradientAngle;
    _backgroundColorArgb = nextBackgroundColorArgb;
    _backgroundRadius = nextBackgroundRadius;
    _backgroundPadding = nextBackgroundPadding;
    _textAlign = nextTextAlign;
    _fontFamily = nextFontFamily;
    _fontWeightValue = nextFontWeightValue;
    _autoOverlayHeight = nextAutoOverlayHeight;
    _overlayWidth = nextOverlayWidth;
    _overlayHeight = nextOverlayHeight;
  }

  double? _deriveProgressFromTokens(List<DesktopLyricsToken> tokens) {
    if (tokens.isEmpty) return null;
    var totalWeight = 0.0;
    var sum = 0.0;
    for (final token in tokens) {
      final weight = token.text.runes.length.toDouble().clamp(1.0, double.infinity);
      totalWeight += weight;
      sum += token.progress.clamp(0.0, 1.0) * weight;
    }
    if (totalWeight <= 0) return 1.0;
    return (sum / totalWeight).clamp(0.0, 1.0).toDouble();
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

class _PerformanceTracker {
  bool enabled = false;
  int targetFps = 0;
  String mode = 'line';
  bool gradient = false;

  int attempted = 0;
  int sent = 0;
  int throttled = 0;
  int failed = 0;
  int sampleCount = 0;
  double totalMs = 0.0;
  DateTime lastLogAt = DateTime.now();

  void configure({
    required bool enabled,
    required int targetFps,
    required String mode,
    required bool gradient,
  }) {
    this.enabled = enabled;
    this.targetFps = targetFps;
    this.mode = mode;
    this.gradient = gradient;
    attempted = 0;
    sent = 0;
    throttled = 0;
    failed = 0;
    sampleCount = 0;
    totalMs = 0.0;
    lastLogAt = DateTime.now();
  }

  Stopwatch? startAttempt() {
    if (!enabled) return null;
    attempted++;
    return Stopwatch()..start();
  }

  void recordThrottled() {
    if (!enabled) return;
    throttled++;
  }

  void recordResult(Stopwatch? stopwatch, {required bool success}) {
    if (!enabled || stopwatch == null) return;
    stopwatch.stop();
    sampleCount++;
    totalMs += stopwatch.elapsedMicroseconds / 1000.0;
    if (success) {
      sent++;
    } else {
      failed++;
    }
  }

  void maybeLog() {
    if (!enabled) return;
    final now = DateTime.now();
    if (now.difference(lastLogAt).inMilliseconds < 1000) return;
    final avg = sampleCount == 0 ? 0.0 : totalMs / sampleCount;
    debugPrint(
      'fps(target=$targetFps attempted=$attempted sent=$sent throttled=$throttled failed=$failed avg=${avg.toStringAsFixed(2)} ms gradient=$gradient mode=$mode)',
    );
    lastLogAt = now;
    attempted = 0;
    sent = 0;
    throttled = 0;
    failed = 0;
    sampleCount = 0;
    totalMs = 0.0;
  }
}
