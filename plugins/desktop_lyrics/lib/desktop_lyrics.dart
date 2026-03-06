import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A token segment for karaoke-style lyric rendering.
///
/// [text] is the token content and [progress] is its local highlight progress
/// in range `0.0..1.0`.
@immutable
class DesktopLyricsToken {
  /// Creates a token segment with text and local progress.
  const DesktopLyricsToken({required this.text, required this.progress});

  final String text;
  final double progress;
}

/// A token with a relative duration used to build karaoke frames.
@immutable
class DesktopLyricsTokenTiming {
  /// Creates a timed token.
  const DesktopLyricsTokenTiming({required this.text, required this.duration});

  final String text;
  final Duration duration;
}

/// A token with absolute time range used to build karaoke frames.
@immutable
class DesktopLyricsTimelineToken {
  /// Creates a timeline token.
  const DesktopLyricsTimelineToken({
    required this.text,
    required this.start,
    required this.end,
  });

  final String text;
  final Duration start;
  final Duration end;
}

/// A render frame consumed by the desktop lyrics overlay.
@immutable
class DesktopLyricsFrame {
  /// Builds a static line frame.
  ///
  /// [lineProgress] defaults to `1.0` to keep text fully visible.
  // `.line` is for static single-line display by default, so progress defaults
  // to fully visible. Callers can pass a custom value when they need sweeping.
  const DesktopLyricsFrame.line(
      {required this.currentLine, this.lineProgress = 1.0})
      : tokens = const [];

  /// Builds a tokenized frame for karaoke rendering.
  ///
  /// If [resolvedLine] is omitted, line text is derived from [tokens].
  const DesktopLyricsFrame.tokenized({
    required this.tokens,
    this.lineProgress,
    String? resolvedLine,
  }) : currentLine = resolvedLine ?? '';

  final String currentLine;
  final double? lineProgress;
  final List<DesktopLyricsToken> tokens;

  /// Returns the effective line text for native rendering.
  String get effectiveLine =>
      tokens.isNotEmpty ? tokens.map((e) => e.text).join() : currentLine;

  /// Creates a frame from relative token durations.
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

  /// Creates a frame from absolute timeline tokens and current playback [position].
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

/// Interaction options for the overlay window.
@immutable
class DesktopLyricsInteractionConfig {
  /// Creates interaction configuration.
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

  /// Returns a copy with selective overrides.
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

/// Text style configuration for lyrics content.
@immutable
class DesktopLyricsTextConfig {
  /// Creates text style configuration.
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

  /// Returns a copy with selective overrides.
  DesktopLyricsTextConfig copyWith({
    double? fontSize,
    Color? textColor,
    Color? shadowColor,
    Color? strokeColor,
    double? strokeWidth,
    String? fontFamily,
    TextAlign? textAlign,
    FontWeight? fontWeight,
  }) {
    return DesktopLyricsTextConfig(
      fontSize: fontSize ?? this.fontSize,
      textColor: textColor ?? this.textColor,
      shadowColor: shadowColor ?? this.shadowColor,
      strokeColor: strokeColor ?? this.strokeColor,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      fontFamily: fontFamily ?? this.fontFamily,
      textAlign: textAlign ?? this.textAlign,
      fontWeight: fontWeight ?? this.fontWeight,
    );
  }
}

/// Background style configuration for the overlay panel.
@immutable
class DesktopLyricsBackgroundConfig {
  /// Creates background style configuration.
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
  int get hashCode => Object.hash(
      opacity, backgroundColor, backgroundRadius, backgroundPadding);

  /// Returns a copy with selective overrides.
  DesktopLyricsBackgroundConfig copyWith({
    double? opacity,
    Color? backgroundColor,
    double? backgroundRadius,
    double? backgroundPadding,
  }) {
    return DesktopLyricsBackgroundConfig(
      opacity: opacity ?? this.opacity,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      backgroundRadius: backgroundRadius ?? this.backgroundRadius,
      backgroundPadding: backgroundPadding ?? this.backgroundPadding,
    );
  }
}

/// Gradient configuration for lyric text fill.
@immutable
class DesktopLyricsGradientConfig {
  /// Creates gradient style configuration.
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

  /// Returns a copy with selective overrides.
  DesktopLyricsGradientConfig copyWith({
    bool? textGradientEnabled,
    Color? textGradientStartColor,
    Color? textGradientEndColor,
    double? textGradientAngle,
  }) {
    return DesktopLyricsGradientConfig(
      textGradientEnabled: textGradientEnabled ?? this.textGradientEnabled,
      textGradientStartColor:
          textGradientStartColor ?? this.textGradientStartColor,
      textGradientEndColor: textGradientEndColor ?? this.textGradientEndColor,
      textGradientAngle: textGradientAngle ?? this.textGradientAngle,
    );
  }
}

/// Layout configuration for the overlay window.
@immutable
class DesktopLyricsLayoutConfig {
  /// Creates layout configuration.
  const DesktopLyricsLayoutConfig({this.overlayWidth});

  final double? overlayWidth;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsLayoutConfig && overlayWidth == other.overlayWidth;

  @override
  int get hashCode => overlayWidth.hashCode;

  /// Returns a copy with selective overrides.
  DesktopLyricsLayoutConfig copyWith({
    double? overlayWidth,
  }) {
    return DesktopLyricsLayoutConfig(
      overlayWidth: overlayWidth ?? this.overlayWidth,
    );
  }
}

/// Complete configuration object for desktop lyrics overlay.
@immutable
class DesktopLyricsConfig {
  /// Creates full overlay configuration.
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
  int get hashCode =>
      Object.hash(interaction, text, background, gradient, layout);

  /// Returns a copy with selective overrides.
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

/// Read-only snapshot of current runtime state.
@immutable
class DesktopLyricsStateSnapshot {
  /// Creates a state snapshot.
  const DesktopLyricsStateSnapshot({
    required this.interaction,
    required this.text,
    required this.background,
    required this.gradient,
    required this.layout,
  });

  final DesktopLyricsInteractionConfig interaction;
  final DesktopLyricsTextConfig text;
  final DesktopLyricsBackgroundConfig background;
  final DesktopLyricsGradientConfig gradient;
  final DesktopLyricsLayoutConfig layout;

  /// Converts current snapshot into a full config object.
  DesktopLyricsConfig toConfig() {
    return DesktopLyricsConfig(
      interaction: interaction,
      text: text,
      background: background,
      gradient: gradient,
      layout: layout,
    );
  }

  /// Creates a config from this snapshot with selective overrides.
  DesktopLyricsConfig copyWith({
    DesktopLyricsInteractionConfig? interaction,
    DesktopLyricsTextConfig? text,
    DesktopLyricsBackgroundConfig? background,
    DesktopLyricsGradientConfig? gradient,
    DesktopLyricsLayoutConfig? layout,
  }) {
    return toConfig().copyWith(
      interaction: interaction,
      text: text,
      background: background,
      gradient: gradient,
      layout: layout,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DesktopLyricsStateSnapshot &&
          interaction == other.interaction &&
          text == other.text &&
          background == other.background &&
          gradient == other.gradient &&
          layout == other.layout;

  @override
  int get hashCode =>
      Object.hash(interaction, text, background, gradient, layout);
}

class _DesktopLyricsService {
  _DesktopLyricsService({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'desktop_lyrics';

  final MethodChannel _channel;
  final _perf = _PerformanceTracker();

  Future<void> dispose() async => _invoke('dispose');

  Future<void> render(DesktopLyricsFrame frame) async {
    final currentLine = frame.effectiveLine;
    final rawProgress = frame.lineProgress;
    final double currentProgress = (rawProgress != null && rawProgress.isFinite)
        ? rawProgress.clamp(0.0, 1.0).toDouble()
        : 1.0;

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
  /// Creates a desktop lyrics controller.
  ///
  /// By default this returns a shared singleton instance to avoid state split
  /// between `apply` and `render` call sites.
  factory DesktopLyrics({MethodChannel? channel}) {
    if (channel != null) {
      return DesktopLyrics._internal(channel: channel, shared: false);
    }
    final existing = _sharedInstance;
    if (existing != null && !existing._disposed) {
      return existing;
    }
    final created = DesktopLyrics._internal(shared: true);
    _sharedInstance = created;
    return created;
  }

  DesktopLyrics._internal({MethodChannel? channel, required bool shared})
      : _service = _DesktopLyricsService(channel: channel),
        _shared = shared;

  static DesktopLyrics? _sharedInstance;

  final _DesktopLyricsService _service;
  final bool _shared;
  DesktopLyricsConfig _config = const DesktopLyricsConfig(
    interaction: DesktopLyricsInteractionConfig(
      enabled: false,
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
    ),
  );
  bool _disposed = false;
  Future<void> _configWriteQueue = Future.value();

  /// Current state snapshot used for state-driven UI updates.
  DesktopLyricsStateSnapshot get state => DesktopLyricsStateSnapshot(
        interaction: _config.interaction,
        text: _config.text,
        background: _config.background,
        gradient: _config.gradient,
        layout: _config.layout,
      );

  /// Applies a full config update to native overlay.
  ///
  /// Updates are serialized to preserve order when called rapidly.
  Future<void> apply(DesktopLyricsConfig value) {
    if (value == _config) return Future.value();
    _configWriteQueue = _configWriteQueue.then((_) async {
      if (value == _config) return;
      await _service.configure(value);
      _config = value;
      if (!_disposed) notifyListeners();
    });
    return _configWriteQueue;
  }

  /// Renders one lyric frame.
  Future<void> render(DesktopLyricsFrame frame) {
    if (!_config.interaction.enabled) return Future.value();
    return _service.render(frame);
  }

  @override

  /// Disposes native resources and removes listeners.
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    if (_shared && identical(_sharedInstance, this)) {
      _sharedInstance = null;
    }
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
