import 'package:flutter_riverpod/legacy.dart';
import 'package:desktop_lyrics/desktop_lyrics.dart';

final desktopLyricsServiceProvider = ChangeNotifierProvider<DesktopLyrics>(
  (_) => DesktopLyrics(),
);

final desktopLyricsPreviewingProvider = StateProvider<bool>((_) => false);
