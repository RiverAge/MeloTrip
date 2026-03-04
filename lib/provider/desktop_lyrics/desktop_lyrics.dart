import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:desktop_lyrics/desktop_lyrics.dart';

final desktopLyricsServiceProvider = ChangeNotifierProvider<DesktopLyrics>(
  (_) => DesktopLyrics(),
);

final desktopLyricsPreviewingProvider = StateProvider<bool>((_) => false);
