import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_title_bar/window_title_bar.dart';

final Provider<WindowTitleBar> windowTitleBarClientProvider =
    Provider<WindowTitleBar>((_) {
      return WindowTitleBar();
    });
