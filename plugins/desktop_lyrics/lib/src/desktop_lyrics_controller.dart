part of '../desktop_lyrics.dart';

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
