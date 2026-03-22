import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum WindowBarState { maximized, restored, minimized }

class WindowTitleBarConfig {
  const WindowTitleBarConfig({
    required this.enabled,
    this.title,
    this.backgroundColor,
    // Windows currently consumes drag-region geometry.
    // Linux/macOS ignore these values for now.
    this.dragRegionHeight = 60,
    this.dragRegionRightInset = 180,
  });

  final bool enabled;
  final String? title;
  final Color? backgroundColor;
  final int dragRegionHeight;
  final int dragRegionRightInset;

  WindowTitleBarConfig copyWith({
    bool? enabled,
    String? title,
    Color? backgroundColor,
    int? dragRegionHeight,
    int? dragRegionRightInset,
  }) {
    return WindowTitleBarConfig(
      enabled: enabled ?? this.enabled,
      title: title ?? this.title,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      dragRegionHeight: dragRegionHeight ?? this.dragRegionHeight,
      dragRegionRightInset: dragRegionRightInset ?? this.dragRegionRightInset,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WindowTitleBarConfig &&
          enabled == other.enabled &&
          title == other.title &&
          backgroundColor == other.backgroundColor &&
          dragRegionHeight == other.dragRegionHeight &&
          dragRegionRightInset == other.dragRegionRightInset;

  @override
  int get hashCode => Object.hash(
    enabled,
    title,
    backgroundColor,
    dragRegionHeight,
    dragRegionRightInset,
  );
}

class WindowTitleBarStateSnapshot {
  static const Object _unset = Object();

  const WindowTitleBarStateSnapshot({
    required this.enabled,
    required this.windowState,
    required this.title,
    required this.backgroundColor,
  });

  final bool enabled;
  final WindowBarState windowState;
  final String title;
  final Color? backgroundColor;

  WindowTitleBarStateSnapshot copyWith({
    bool? enabled,
    WindowBarState? windowState,
    String? title,
    Object? backgroundColor = _unset,
  }) {
    return WindowTitleBarStateSnapshot(
      enabled: enabled ?? this.enabled,
      windowState: windowState ?? this.windowState,
      title: title ?? this.title,
      backgroundColor: backgroundColor == _unset
          ? this.backgroundColor
          : backgroundColor as Color?,
    );
  }

  WindowTitleBarConfig toConfig({
    int dragRegionHeight = 60,
    int dragRegionRightInset = 180,
  }) {
    return WindowTitleBarConfig(
      enabled: enabled,
      title: title,
      backgroundColor: backgroundColor,
      dragRegionHeight: dragRegionHeight,
      dragRegionRightInset: dragRegionRightInset,
    );
  }
}

class WindowTitleBar extends ChangeNotifier {
  factory WindowTitleBar({MethodChannel? channel}) {
    if (channel != null) {
      return WindowTitleBar._internal(channel: channel, shared: false);
    }
    final existing = _sharedInstance;
    if (existing != null && !existing._disposed) {
      return existing;
    }
    final created = WindowTitleBar._internal(shared: true);
    _sharedInstance = created;
    return created;
  }

  WindowTitleBar._internal({MethodChannel? channel, required bool shared})
    : _channel = channel ?? const MethodChannel('melo_trip/window_title_bar'),
      _shared = shared {
    _channel.setMethodCallHandler(_handleMethodCall);
    unawaited(_syncStateFromNative());
  }

  static WindowTitleBar? _sharedInstance;

  final MethodChannel _channel;
  final bool _shared;
  bool _disposed = false;
  Future<void> _configWriteQueue = Future.value();

  WindowTitleBarStateSnapshot _state = const WindowTitleBarStateSnapshot(
    enabled: false,
    windowState: WindowBarState.restored,
    title: '',
    backgroundColor: null,
  );
  WindowTitleBarStateSnapshot get state => _state;

  final StreamController<WindowTitleBarStateSnapshot> _stateController =
      StreamController<WindowTitleBarStateSnapshot>.broadcast();
  Stream<WindowTitleBarStateSnapshot> get stateStream => _stateController.stream;

  static bool get isSupportedPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS);

  Future<void> apply(WindowTitleBarConfig config) {
    final nextTitle = config.title ?? _state.title;
    _configWriteQueue = _configWriteQueue.then((_) async {
      var enabled = false;
      if (isSupportedPlatform) {
        final result = await _invoke<bool>('apply', <String, Object?>{
          'enabled': config.enabled,
          'dragRegionHeight': config.dragRegionHeight,
          'dragRegionRightInset': config.dragRegionRightInset,
        });
        enabled = result ?? false;
      }

      final maximized = enabled ? await isMaximized() : false;
      _setState(
        _state.copyWith(
          enabled: enabled,
          windowState: maximized
              ? WindowBarState.maximized
              : WindowBarState.restored,
          title: nextTitle,
          backgroundColor: config.backgroundColor,
        ),
      );
    });
    return _configWriteQueue;
  }

  Future<void> minimize() async {
    if (!isSupportedPlatform) {
      return;
    }
    await _invoke<void>('minimize');
  }

  Future<void> toggleMaximize() async {
    if (!isSupportedPlatform) {
      return;
    }
    await _invoke<void>('toggleMaximize');
  }

  Future<bool> isMaximized() async {
    if (!isSupportedPlatform) {
      return false;
    }
    final result = await _invoke<bool>('isMaximized');
    return result ?? false;
  }

  Future<void> close() async {
    if (!isSupportedPlatform) {
      return;
    }
    await _invoke<void>('close');
  }

  Future<void> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onWindowStateChanged':
        final args = call.arguments as Map;
        final stateStr = args['state'] as String;
        WindowBarState? state;
        switch (stateStr) {
          case 'maximized':
            state = WindowBarState.maximized;
            break;
          case 'restored':
            state = WindowBarState.restored;
            break;
          case 'minimized':
            state = WindowBarState.minimized;
            break;
        }
        if (state != null) {
          _setState(_state.copyWith(windowState: state));
        }
        break;
    }
  }

  Future<void> _syncStateFromNative() async {
    final maximized = await isMaximized();
    _setState(
      _state.copyWith(
        windowState: maximized
            ? WindowBarState.maximized
            : WindowBarState.restored,
      ),
    );
  }

  Future<T?> _invoke<T>(String method, [Object? arguments]) async {
    try {
      return await _channel.invokeMethod<T>(method, arguments);
    } on MissingPluginException {
      return null;
    } on PlatformException catch (err) {
      debugPrint('window_title_bar $method failed: ${err.message}');
      return null;
    }
  }

  void _setState(WindowTitleBarStateSnapshot next) {
    _state = next;
    _stateController.add(_state);
    if (!_disposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    if (_disposed) {
      return;
    }
    _disposed = true;
    if (_shared && identical(_sharedInstance, this)) {
      _sharedInstance = null;
    }
    _stateController.close();
    super.dispose();
  }
}
