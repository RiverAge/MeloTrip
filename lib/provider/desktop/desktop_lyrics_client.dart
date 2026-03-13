import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Provider<DesktopLyrics> desktopLyricsClientProvider =
    Provider<DesktopLyrics>((_) {
      return DesktopLyrics();
    });
