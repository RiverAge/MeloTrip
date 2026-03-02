import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  SongEntity buildSong(String id) {
    return SongEntity(id: id, title: 't-$id', artist: 'a-$id');
  }

  test('dispatchSongTapPlayback toggles when tapping current song', () async {
    final playQueue = PlayQueue(
      songs: [buildSong('1'), buildSong('2')],
      index: 1,
    );
    var toggleCalls = 0;
    SongEntity? playedSong;

    await dispatchSongTapPlayback(
      playQueue: playQueue,
      song: buildSong('2'),
      onToggleCurrent: () async {
        toggleCalls++;
      },
      onPlayTarget: (song) async {
        playedSong = song;
      },
    );

    expect(toggleCalls, 1);
    expect(playedSong, isNull);
  });

  test('dispatchSongTapPlayback plays target when tapping non-current song', () async {
    final playQueue = PlayQueue(
      songs: [buildSong('1'), buildSong('2')],
      index: 0,
    );
    var toggleCalls = 0;
    SongEntity? playedSong;
    final target = buildSong('2');

    await dispatchSongTapPlayback(
      playQueue: playQueue,
      song: target,
      onToggleCurrent: () async {
        toggleCalls++;
      },
      onPlayTarget: (song) async {
        playedSong = song;
      },
    );

    expect(toggleCalls, 0);
    expect(playedSong?.id, target.id);
  });

  test('isCurrentSongTap returns false for out-of-range index', () {
    final playQueue = PlayQueue(songs: [buildSong('1')], index: 3);

    final result = isCurrentSongTap(
      playQueue: playQueue,
      song: buildSong('1'),
    );

    expect(result, isFalse);
  });
}
