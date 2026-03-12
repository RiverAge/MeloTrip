part of '../desktop_lyrics.dart';

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
      'textAlign':
          _toNativeTextAlign(config.text.textAlign ?? TextAlign.center),
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
