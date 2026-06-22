import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/playlist_weighted_seeds.dart';

void main() {
  test('selectPlaylistSeedCandidates prefers recently changed playlists', () {
    final playlists = [
      PlaylistEntity(id: 'old', songCount: 20, changed: DateTime(2024)),
      PlaylistEntity(id: 'new', songCount: 1, changed: DateTime(2026)),
      PlaylistEntity(id: '', songCount: 100, changed: DateTime(2027)),
    ];

    final selected = selectPlaylistSeedCandidates(playlists, maxPlaylists: 2);

    expect(selected.map((playlist) => playlist.id), ['new', 'old']);
  });

  test('extractPlaylistSeedSongIds samples playlists round-robin', () {
    final playlists = [
      PlaylistEntity(
        id: 'pl-1',
        entry: [
          SongEntity(id: 'a1', title: 'A1'),
          SongEntity(id: 'a2', title: 'A2'),
        ],
      ),
      PlaylistEntity(
        id: 'pl-2',
        entry: [
          SongEntity(id: 'b1', title: 'B1'),
          SongEntity(id: 'a1', title: 'Duplicate'),
          SongEntity(id: 'b3', title: 'B3'),
        ],
      ),
    ];

    final ids = extractPlaylistSeedSongIds(playlists, maxSeeds: 4);

    expect(ids, ['a1', 'b1', 'a2', 'b3']);
  });

  test('convertPlaylistSeedsToWeighted marks playlist source', () {
    final seeds = convertPlaylistSeedsToWeighted(['song-1']);

    expect(seeds.single.songId, 'song-1');
    expect(seeds.single.source, SeedSource.playlist);
    expect(seeds.single.weight, 0.7);
    expect(seeds.single.reason, 'playlist');
  });
}
