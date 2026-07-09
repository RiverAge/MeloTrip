import 'dart:async';

import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/desktop/desktop_lyrics_client.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';

class DesktopLyricsRuntimeBindings {
  DesktopLyricsRuntimeBindings({
    required this.playQueueSubscription,
    required this.positionSubscription,
  });

  final StreamSubscription<PlayQueue> playQueueSubscription;
  final StreamSubscription<Duration> positionSubscription;

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

    final desktopLyrics = ref.read(desktopLyricsClientProvider);
    List<Line>? lyricsLines;
    Map<int, CueLine>? cueMap;
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
        cueMap = null;
        final requestId = ++lyricsRequestId;
        final resp = await ref.read(lyricsProvider(songId).future);
        if (requestId != lyricsRequestId) return;
        final structured = resp
            ?.data
            ?.subsonicResponse
            ?.lyricsList
            ?.structuredLyrics
            ?.firstOrNull;
        lyricsLines = structured?.line;
        cueMap = cueLinesByStart(structured);
      } else {
        lyricsLines = null;
        cueMap = null;
      }

      unawaited(
        desktopLyrics.render(
          DesktopLyricsFrame.line(
            currentLine: lyricsLines?.firstOrNull?.value ?? '',
          ),
        ),
      );
    });

    final positionSubscription = player.positionStream.listen((duration) async {
      final lines = lyricsLines;
      if (lines == null || lines.isEmpty) {
        return;
      }

      final idx = indexOfLyrics(sortedLyrics: lines, position: duration);
      if (idx < 0 || idx >= lines.length) {
        return;
      }
      final line = lines[idx].value;
      if (line == null || line.isEmpty) {
        return;
      }

      final lineChanged = currentLyricsIndex != idx;
      currentLyricsIndex = idx;

      // 有逐字 cue 时按已唱宽度比例喂 lineProgress，native 端按该比例做
      // 整行左→右 clip 高亮，呈现逐字扫过。无 cue 则整行全亮（lineProgress=1.0）。
      // 即便行未变化也要每 tick 更新 progress，故不在此提前 return。
      final start = lines[idx].start;
      final cueLine = start == null ? null : cueMap?[start];
      final cues = cueLine?.cue ?? const <Cue>[];
      final sweep = cues.isEmpty
          ? 1.0
          : cueLineSweepFraction(cues: cues, positionMs: duration.inMilliseconds);

      // 行没变、且无逐字（整行全亮）时无需重渲染，避免多余 channel 调用。
      if (!lineChanged && cues.isEmpty) {
        return;
      }

      unawaited(
        desktopLyrics.render(
          DesktopLyricsFrame.line(currentLine: line, lineProgress: sweep),
        ),
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
