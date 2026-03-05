import 'dart:async';

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
  const DesktopLyricsTokenTiming({required this.text, required this.duration});

  final String text;
  final Duration duration;
}

@immutable
class DesktopLyricsTimelineToken {
  const DesktopLyricsTimelineToken({
    required this.text,
    required this.start,
    required this.end,
  });

  final String text;
  final Duration start;
  final Duration end;
}

@immutable
class DesktopLyricsFrame {
  // `.line` is for static single-line display by default, so progress defaults
  // to fully visible. Callers can pass a custom value when they need sweeping.
  const DesktopLyricsFrame.line({required this.currentLine, this.lineProgress = 1.0})
    : tokens = const [];

  const DesktopLyricsFrame.tokenized({
    required this.tokens,
    this.lineProgress,
    String? resolvedLine,
  }) : currentLine = resolvedLine ?? '';

  final String currentLine;
  final double? lineProgress;
  final List<DesktopLyricsToken> tokens;
  String get effectiveLine =>
      tokens.isNotEmpty ? tokens.map((e) => e.text).join() : currentLine;

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
      final ms = token.duration.inMilliseconds;
      total += ms > 0 ? ms : 1;
    }
    var elapsed = 0;
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final ms = token.duration.inMilliseconds;
      final duration = ms > 0 ? ms : 1;
      final start = elapsed / total;
      final end = (elapsed + duration) / total;
      final local = ((normalized - start) / (end - start)).clamp(0.0, 1.0);
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
      elapsed += duration;
    }
    return DesktopLyricsFrame.tokenized(
      resolvedLine: tokens.map((e) => e.text).join(),
      lineProgress: normalized,
      tokens: mapped,
    );
  }

  factory DesktopLyricsFrame.fromKaraokeTimeline({
    required Duration position,
    required List<DesktopLyricsTimelineToken> tokens,
  }) {
    if (tokens.isEmpty) {
      return const DesktopLyricsFrame.line(currentLine: '', lineProgress: 1.0);
    }
    final positionMs = position.inMilliseconds;
    final minStart = tokens.first.start.inMilliseconds;
    final maxEnd = tokens.last.end.inMilliseconds;
    final total = (maxEnd - minStart).clamp(1, 1 << 30);
    final normalized =
        ((positionMs - minStart) / total).clamp(0.0, 1.0).toDouble();
    final mapped = <DesktopLyricsToken>[];
    for (final token in tokens) {
      final tokenStart = token.start.inMilliseconds;
      final tokenEnd = token.end.inMilliseconds;
      final denom = (tokenEnd - tokenStart).clamp(1, 1 << 30);
      final local =
          ((positionMs - tokenStart) / denom).clamp(0.0, 1.0).toDouble();
      mapped.add(DesktopLyricsToken(text: token.text, progress: local));
    }
    return DesktopLyricsFrame.tokenized(
      resolvedLine: tokens.map((e) => e.text).join(),
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

  DesktopLyricsInteractionConfig copyWith({
    bool? enabled,
    bool? clickThrough,
  }) {
    return DesktopLyricsInteractionConfig(
      enabled: enabled ?? this.enabled,
      clickThrough: clickThrough ?? this.clickThrough,
    );
  }
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
    this.opacity = 0.96,
    this.backgroundColor,
    this.backgroundRadius = 16.0,
    this.backgroundPadding = 10.0,
  });

  final double opacity;
  final Color? backgroundColor;
  final double backgroundRadius;
  final double backgroundPadding;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsBackgroundConfig &&
          opacity == other.opacity &&
          backgroundColor == other.backgroundColor &&
          backgroundRadius == other.backgroundRadius &&
          backgroundPadding == other.backgroundPadding;

  @override
  int get hashCode =>
      Object.hash(opacity, backgroundColor, backgroundRadius, backgroundPadding);
}

@immutable
class DesktopLyricsGradientConfig {
  const DesktopLyricsGradientConfig({
    this.textGradientEnabled = false,
    this.textGradientStartColor,
    this.textGradientEndColor,
    this.textGradientAngle = 0.0,
  });

  final bool textGradientEnabled;
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
    this.background = const DesktopLyricsBackgroundConfig(),
    this.gradient = const DesktopLyricsGradientConfig(),
    this.layout = const DesktopLyricsLayoutConfig(),
  });

  final DesktopLyricsInteractionConfig interaction;
  final DesktopLyricsTextConfig text;
  final DesktopLyricsBackgroundConfig background;
  final DesktopLyricsGradientConfig gradient;
  final DesktopLyricsLayoutConfig layout;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsConfig &&
          interaction == other.interaction &&
          text == other.text &&
          background == other.background &&
          gradient == other.gradient &&
          layout == other.layout;

  @override
  int get hashCode => Object.hash(interaction, text, background, gradient, layout);

  DesktopLyricsConfig copyWith({
    DesktopLyricsInteractionConfig? interaction,
    DesktopLyricsTextConfig? text,
    DesktopLyricsBackgroundConfig? background,
    DesktopLyricsGradientConfig? gradient,
    DesktopLyricsLayoutConfig? layout,
  }) {
    return DesktopLyricsConfig(
      interaction: interaction ?? this.interaction,
      text: text ?? this.text,
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
    required this.backgroundOpacity,
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
  final double backgroundOpacity;
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsStateSnapshot &&
          enabled == other.enabled &&
          clickThrough == other.clickThrough &&
          fontSize == other.fontSize &&
          backgroundOpacity == other.backgroundOpacity &&
          textColorArgb == other.textColorArgb &&
          shadowColorArgb == other.shadowColorArgb &&
          strokeColorArgb == other.strokeColorArgb &&
          strokeWidth == other.strokeWidth &&
          textGradientEnabled == other.textGradientEnabled &&
          textGradientStartArgb == other.textGradientStartArgb &&
          textGradientEndArgb == other.textGradientEndArgb &&
          textGradientAngle == other.textGradientAngle &&
          backgroundColorArgb == other.backgroundColorArgb &&
          backgroundRadius == other.backgroundRadius &&
          backgroundPadding == other.backgroundPadding &&
          textAlign == other.textAlign &&
          fontFamily == other.fontFamily &&
          fontWeightValue == other.fontWeightValue &&
          autoOverlayHeight == other.autoOverlayHeight &&
          overlayWidth == other.overlayWidth &&
          overlayHeight == other.overlayHeight;

  @override
  int get hashCode => Object.hashAll([
    enabled,
    clickThrough,
    fontSize,
    backgroundOpacity,
    textColorArgb,
    shadowColorArgb,
    strokeColorArgb,
    strokeWidth,
    textGradientEnabled,
    textGradientStartArgb,
    textGradientEndArgb,
    textGradientAngle,
    backgroundColorArgb,
    backgroundRadius,
    backgroundPadding,
    textAlign,
    fontFamily,
    fontWeightValue,
    autoOverlayHeight,
    overlayWidth,
    overlayHeight,
  ]);
}

class _DesktopLyricsService {
  _DesktopLyricsService({MethodChannel? channel})
    : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'desktop_lyrics';

  final MethodChannel _channel;
  final _perf = _PerformanceTracker();
  DateTime _lastRenderAt = DateTime.fromMillisecondsSinceEpoch(0);
  String _lastRenderLine = '';
  double _lastRenderProgress = 1.0;
  Duration _minRenderInterval = Duration.zero;
  double _minProgressDelta = 0.0;

  Future<void> dispose() async => _invoke('dispose');

  Future<void> render(DesktopLyricsFrame frame) async {
    final currentLine = frame.effectiveLine;
    final rawProgress = frame.lineProgress;
    final double currentProgress = (rawProgress != null && rawProgress.isFinite)
        ? rawProgress.clamp(0.0, 1.0).toDouble()
        : 1.0;
    final now = DateTime.now();
    final sameLine = currentLine == _lastRenderLine;
    final smallDelta = (currentProgress - _lastRenderProgress).abs() < _minProgressDelta;
    final withinInterval = now.difference(_lastRenderAt) < _minRenderInterval;
    if (_minRenderInterval > Duration.zero &&
        sameLine &&
        smallDelta &&
        withinInterval) {
      _perf.recordThrottled();
      _perf.maybeLog();
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

  @visibleForTesting
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

  void setRenderRateLimit({
    required int maxFps,
    required double minProgressDelta,
  }) {
    if (maxFps <= 0) {
      _minRenderInterval = Duration.zero;
    } else {
      _minRenderInterval = Duration(milliseconds: (1000 / maxFps).round());
    }
    _minProgressDelta = minProgressDelta.clamp(0.0, 1.0);
  }

  Future<void> configure(DesktopLyricsConfig config) async {
    await _invoke('updateConfig', {
      'enabled': config.interaction.enabled,
      'clickThrough': config.interaction.clickThrough,
      'fontSize': config.text.fontSize,
      'opacity': config.background.opacity,
      'textColorArgb': config.text.textColor?.toARGB32() ?? 0xFFF6F7FF,
      'shadowColorArgb': config.text.shadowColor?.toARGB32() ?? 0x00000000,
      'strokeColorArgb': config.text.strokeColor?.toARGB32() ?? 0x00000000,
      'strokeWidth': config.text.strokeWidth ?? 0.0,
      'backgroundColorArgb':
          config.background.backgroundColor?.toARGB32() ?? 0x7A220A35,
      'backgroundRadius': config.background.backgroundRadius,
      'backgroundPadding': config.background.backgroundPadding,
      'textGradientEnabled': config.gradient.textGradientEnabled,
      'textGradientStartArgb':
          config.gradient.textGradientStartColor?.toARGB32() ?? 0xFFFFD36E,
      'textGradientEndArgb':
          config.gradient.textGradientEndColor?.toARGB32() ?? 0xFFFF4D8D,
      'textGradientAngle': config.gradient.textGradientAngle,
      'overlayWidth': config.layout.overlayWidth ?? 980.0,
      // overlayHeight is omitted from payload to signal auto-height mode.
      if (config.layout.overlayHeight != null)
        'overlayHeight': config.layout.overlayHeight,
      'fontFamily': config.text.fontFamily ?? 'Segoe UI',
      'textAlign': _toNativeTextAlign(config.text.textAlign ?? TextAlign.start),
      'fontWeightValue': config.text.fontWeight?.value ?? FontWeight.w400.value,
    });
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

class DesktopLyrics extends ChangeNotifier {
  DesktopLyrics({MethodChannel? channel})
    : _service = _DesktopLyricsService(channel: channel);

  final _DesktopLyricsService _service;
  DesktopLyricsConfig _config = const DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: true,
      clickThrough: false,
    ),
    text: DesktopLyricsTextConfig(
      fontSize: 30.0,
      textColor: Color(0xFFF6F7FF),
      shadowColor: Color(0x00000000),
      strokeColor: Color(0x00000000),
      strokeWidth: 0.0,
      fontFamily: 'Segoe UI',
      textAlign: TextAlign.start,
      fontWeight: FontWeight.w400,
    ),
    background: DesktopLyricsBackgroundConfig(
      opacity: 0.96,
      backgroundColor: Color(0x7A220A35),
      backgroundRadius: 16.0,
      backgroundPadding: 8.0,
    ),
    gradient: DesktopLyricsGradientConfig(
      textGradientEnabled: true,
      textGradientStartColor: Color(0xFFFFD36E),
      textGradientEndColor: Color(0xFFFF4D8D),
      textGradientAngle: 0.0,
    ),
    layout: DesktopLyricsLayoutConfig(
      overlayWidth: 720.0,
      overlayHeight: null,
    ),
  );
  bool _disposed = false;
  Future<void> _configWriteQueue = Future.value();

  DesktopLyricsConfig get config => _config;
  bool get enabled => _config.interaction.enabled;
  DesktopLyricsStateSnapshot get state => DesktopLyricsStateSnapshot(
    enabled: _config.interaction.enabled,
    clickThrough: _config.interaction.clickThrough,
    fontSize: _config.text.fontSize,
    backgroundOpacity: _config.background.opacity,
    textColorArgb: _config.text.textColor?.toARGB32() ?? 0xFFF6F7FF,
    shadowColorArgb: _config.text.shadowColor?.toARGB32() ?? 0x00000000,
    strokeColorArgb: _config.text.strokeColor?.toARGB32() ?? 0x00000000,
    strokeWidth: _config.text.strokeWidth ?? 0.0,
    textGradientEnabled: _config.gradient.textGradientEnabled,
    textGradientStartArgb:
        _config.gradient.textGradientStartColor?.toARGB32() ?? 0xFFFFD36E,
    textGradientEndArgb:
        _config.gradient.textGradientEndColor?.toARGB32() ?? 0xFFFF4D8D,
    textGradientAngle: _config.gradient.textGradientAngle,
    backgroundColorArgb:
        _config.background.backgroundColor?.toARGB32() ?? 0x7A220A35,
    backgroundRadius: _config.background.backgroundRadius,
    backgroundPadding: _config.background.backgroundPadding,
    textAlign: _config.text.textAlign ?? TextAlign.start,
    fontFamily: _config.text.fontFamily ?? 'Segoe UI',
    fontWeightValue: _config.text.fontWeight?.value ?? FontWeight.w400.value,
    autoOverlayHeight: _config.layout.overlayHeight == null,
    overlayWidth: _config.layout.overlayWidth ?? 980.0,
    overlayHeight: _config.layout.overlayHeight ?? 160.0,
  );

  Future<void> applyConfig(DesktopLyricsConfig value) {
    if (value == _config) return Future.value();
    _configWriteQueue = _configWriteQueue.then((_) async {
      if (value == _config) return;
      await _service.configure(value);
      _config = value;
      if (!_disposed) notifyListeners();
    });
    return _configWriteQueue;
  }

  Future<void> setEnabled(bool value) {
    if (value == _config.interaction.enabled) return Future.value();
    return applyConfig(
      _config.copyWith(
        interaction: _config.interaction.copyWith(enabled: value),
      ),
    );
  }

  Future<void> render(DesktopLyricsFrame frame) => _service.render(frame);
  void setRenderRateLimit({int maxFps = 0, double minProgressDelta = 0.0}) {
    _service.setRenderRateLimit(
      maxFps: maxFps,
      minProgressDelta: minProgressDelta,
    );
  }

  Future<void> shutdown() => _service.dispose();

  @override
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    unawaited(_service.dispose());
    super.dispose();
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
