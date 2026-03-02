import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  SongEntity song({
    required String id,
    required String title,
    required int duration,
  }) {
    return SongEntity(
      id: id,
      title: title,
      album: 'Album',
      artist: 'Artist',
      duration: duration,
    );
  }

  test('buildMediaItemFromPlayQueue returns fallback when index is invalid', () {
    final item = buildMediaItemFromPlayQueue(
      playQueue: PlayQueue(songs: [song(id: '1', title: 'A', duration: 120)], index: 3),
    );

    expect(item.id, '-1');
    expect(item.title, 'MeloTrip');
    expect(item.playable, false);
    expect(item.duration, Duration.zero);
  });

  test('buildMediaItemFromPlayQueue maps current song metadata', () {
    final item = buildMediaItemFromPlayQueue(
      playQueue: PlayQueue(songs: [song(id: '2', title: 'B', duration: 90)], index: 0),
    );

    expect(item.id, '2');
    expect(item.title, 'B');
    expect(item.album, 'Album');
    expect(item.artist, 'Artist');
    expect(item.duration, const Duration(seconds: 90));
  });
}
