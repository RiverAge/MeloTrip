import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index_of_lyrics.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';

class DesktopLyricsRuntimeBindings {
  DesktopLyricsRuntimeBindings({
    required this.playQueueSubscription,
    required this.positionSubscription,
  });

  final StreamSubscription<dynamic> playQueueSubscription;
  final StreamSubscription<dynamic> positionSubscription;

  Future<void> cancel() async {
    await playQueueSubscription.cancel();
    await positionSubscription.cancel();
  }
}

class DesktopLyricsRuntime {
  Future<DesktopLyricsRuntimeBindings?> attach(WidgetRef ref) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return null;
    }

    final desktopLyrics = DesktopLyrics();
    List<Line>? lyricsLines;
    int currentLyricsIndex = -1;
    int lyricsRequestId = 0;
    String? lastSongId;

    final playQueueSubscription = player.playQueueStream.listen((queue) async {
      final songId =
          (queue.index >= queue.songs.length || queue.index < 0
                  ? null
                  : queue.songs[queue.index])
              ?.id;
      if (songId == lastSongId && lastSongId != null) {
        return;
      }

      unawaited(
        desktopLyrics.render(const DesktopLyricsFrame.line(currentLine: '')),
      );
      lastSongId = songId;
      if (songId != null) {
        currentLyricsIndex = -1;
        lyricsLines = null;
        final requestId = ++lyricsRequestId;
        final resp = await ref.read(lyricsProvider(songId).future);
        lyricsLines = requestId == lyricsRequestId
            ? resp
                  ?.subsonicResponse
                  ?.lyricsList
                  ?.structuredLyrics
                  ?.firstOrNull
                  ?.line
            : null;
      } else {
        lyricsLines = null;
      }

      unawaited(
        desktopLyrics.render(
          DesktopLyricsFrame.line(
            currentLine: lyricsLines?.firstOrNull?.value?.firstOrNull ?? '',
          ),
        ),
      );
    });

    final positionSubscription = player.positionStream.listen((duration) async {
      final lines = lyricsLines;
      if (lines == null) {
        return;
      }

      final idx = indexOfLyrics(sortedLyrics: lines, position: duration);
      if (currentLyricsIndex == idx || idx < 0 || idx >= lines.length) {
        return;
      }

      final line = lines[idx].value?.firstOrNull;
      currentLyricsIndex = idx;
      if (line == null) {
        return;
      }

      unawaited(
        desktopLyrics.render(DesktopLyricsFrame.line(currentLine: line)),
      );
    });

    return DesktopLyricsRuntimeBindings(
      playQueueSubscription: playQueueSubscription,
      positionSubscription: positionSubscription,
    );
  }
}

final Provider<DesktopLyricsRuntime> desktopLyricsRuntimeProvider =
    Provider<DesktopLyricsRuntime>((_) {
      return DesktopLyricsRuntime();
    });
