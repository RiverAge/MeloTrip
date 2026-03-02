import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  SongEntity song(String id) => SongEntity(id: id, title: 'Song $id');

  test('returns existing index when song is already in queue', () {
    final queue = PlayQueue(
      songs: [song('1'), song('2'), song('3')],
      index: 1,
    );

    final index = resolveInsertToNextIndex(
      playQueue: queue,
      song: song('3'),
    );

    expect(index, 2);
  });

  test('returns next index when song is not in queue', () {
    final queue = PlayQueue(
      songs: [song('1'), song('2'), song('3')],
      index: 1,
    );

    final index = resolveInsertToNextIndex(
      playQueue: queue,
      song: song('9'),
    );

    expect(index, 2);
  });

  test('returns zero for empty queue', () {
    final queue = PlayQueue(songs: const [], index: -1);

    final index = resolveInsertToNextIndex(
      playQueue: queue,
      song: song('9'),
    );

    expect(index, 0);
  });

  test('clamps to queue length when current index is out of range', () {
    final queue = PlayQueue(
      songs: [song('1'), song('2')],
      index: 10,
    );

    final index = resolveInsertToNextIndex(
      playQueue: queue,
      song: song('9'),
    );

    expect(index, 2);
  });
}
