import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  SongEntity song(String id) => SongEntity(id: id, title: 'Song $id');

  test('returns next index when song is already in queue at next slot', () {
    final queue = PlayQueue(songs: [song('1'), song('2'), song('3')], index: 1);

    final index = resolveInsertToNextIndex(playQueue: queue, song: song('3'));

    expect(index, 2);
  });

  test('returns next index even when song is already elsewhere in queue', () {
    // Current is song('2') at index 1; song('1') sits before it but the
    // user asks to set it as next-to-play, so the target is index+1 = 2.
    final queue = PlayQueue(songs: [song('1'), song('2'), song('3')], index: 1);

    final index = resolveInsertToNextIndex(playQueue: queue, song: song('1'));

    expect(index, 2);
  });

  test('returns next index when song is not in queue', () {
    final queue = PlayQueue(songs: [song('1'), song('2'), song('3')], index: 1);

    final index = resolveInsertToNextIndex(playQueue: queue, song: song('9'));

    expect(index, 2);
  });

  test('returns zero for empty queue', () {
    final queue = PlayQueue(songs: const [], index: -1);

    final index = resolveInsertToNextIndex(playQueue: queue, song: song('9'));

    expect(index, 0);
  });

  test('clamps to queue length when current index is out of range', () {
    final queue = PlayQueue(songs: [song('1'), song('2')], index: 10);

    final index = resolveInsertToNextIndex(playQueue: queue, song: song('9'));

    expect(index, 2);
  });
}
