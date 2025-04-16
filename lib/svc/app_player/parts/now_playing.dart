part of '../player_handler.dart';

extension PlayerNowPlaying on AppPlayer {
  _updateScrolling(Duration position) {
    if (_nowPlaying && _submission && position.inSeconds < 1) {
      _nowPlaying = false;
      _submission = false;
    } else if (!_nowPlaying && position.inSeconds > 1) {
      _nowPlaying = true;
      if (playQueue.songs.isEmpty) {
        return;
      }
      Http.get(
        '/rest/scrobble',
        queryParameters: {
          'id': playQueue.songs[playQueue.index].id,
          'submission': false,
        },
      );
    } else if (!_submission &&
        position.inSeconds > (duration?.inSeconds ?? 0) * 2 / 3) {
      _submission = true;
      if (playQueue.songs.isEmpty) {
        return;
      }
      Http.get(
        '/rest/scrobble',
        queryParameters: {
          'id': playQueue.songs[playQueue.index].id,
          'time': DateTime.now().millisecondsSinceEpoch,
          'submission': true,
        },
      );
    }
  }
}
