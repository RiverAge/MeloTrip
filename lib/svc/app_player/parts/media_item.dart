part of '../player_handler.dart';

extension PlayerMediaItem on AppPlayer {
  // Future<bool> _isCurrentStarred() async {
  //   final song =
  //       playQueue.songs.isEmpty ? null : playQueue.songs[playQueue.index];
  //   if (song == null) return false;
  //   final res = await Http.get<Map<String, dynamic>>(
  //     '/rest/getSong',
  //     queryParameters: {'id': song.id},
  //   );
  //   final data = res?.data;
  //   if (data == null) return false;
  //   return SubsonicResponse.fromJson(data).subsonicResponse?.song?.starred !=
  //       null;
  // }

  Future<void> _updateCurrentMediaItemButton() async {
    // final starred = await _isCurrentStarred();
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          // MediaControl.custom(
          //   androidIcon:
          //       'drawable/media_contrl_favorite${starred ? '_fill' : ''}',
          //   label: 'favorite',
          //   name: 'favorite',
          //   extras: <String, dynamic>{'starred': starred},
          // ),
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          // MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },

        androidCompactActionIndices: const [0, 1, 3],
        processingState:
            _player.state.buffering
                ? AudioProcessingState.buffering
                : _player.state.completed
                ? AudioProcessingState.completed
                : AudioProcessingState.ready,
        playing: playing,
        updatePosition: position,
        bufferedPosition: buffer,
        speed: rate,
      ),
    );
  }

  // 播放列表或者当前的播放项目变化时
  // 同步后台播放队列
  // 同步App播放通知
  //   Future<void> _updateMediaItem() async {
  //     if (playQueue.index >= playQueue.songs.length) {
  //       const item = MediaItem(
  //         id: '-1',
  //         album: 'MeloTrip',
  //         title: 'MeloTrip',
  //         artist: 'MeloTrip',
  //         duration: Duration.zero,
  //         playable: false,
  //       );
  //       mediaItem.add(item);
  //       Http.get('/rest/savePlayQueue?id=');
  //       return;
  //     }
  //     final song = playQueue.songs[playQueue.index];
  //     final url = await buildSubsonicUrl(
  //       '/rest/getCoverArt?id=${song.id}',
  //       proxy: true,
  //     );
  //     final duartion = song.duration;
  //     final item = MediaItem(
  //       id: song.id ?? '-1',
  //       album: song.album,
  //       title: song.title ?? '没有标题',
  //       artist: song.artist,
  //       duration: duartion != null ? Duration(seconds: duartion) : Duration.zero,
  //       artUri: Uri.parse(url),
  //     );

  //     mediaItem.add(item);

  //     final ids = playQueue.songs.map((e) => e.id).join(',');
  //     Http.get('/rest/savePlayQueue?id=$ids&current=${item.id}');
  //   }
}
