import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/favorite_album_weighted_seeds.dart';

void main() {
  test('extractFavoriteAlbumSeedSongIds extracts album songs in order', () {
    final ids = extractFavoriteAlbumSeedSongIds([
      AlbumEntity(
        id: 'album-1',
        song: [
          SongEntity(id: 'song-1', title: 'Song 1'),
          SongEntity(id: null, title: 'Missing'),
          SongEntity(id: 'song-2', title: 'Song 2'),
        ],
      ),
      AlbumEntity(
        id: 'album-2',
        song: [
          SongEntity(id: 'song-1', title: 'Duplicate'),
          SongEntity(id: 'song-3', title: 'Song 3'),
        ],
      ),
    ]);

    expect(ids, ['song-1', 'song-2', 'song-3']);
  });

  test('extractFavoriteAlbumSeedSongIds respects maxSeeds', () {
    final ids = extractFavoriteAlbumSeedSongIds([
      AlbumEntity(
        id: 'album-1',
        song: [
          SongEntity(id: 'song-1', title: 'Song 1'),
          SongEntity(id: 'song-2', title: 'Song 2'),
          SongEntity(id: 'song-3', title: 'Song 3'),
        ],
      ),
    ], maxSeeds: 2);

    expect(ids, ['song-1', 'song-2']);
  });

  test('convertFavoriteAlbumSeedsToWeighted marks favorite album source', () {
    final seeds = convertFavoriteAlbumSeedsToWeighted(['song-1']);

    expect(seeds.single.songId, 'song-1');
    expect(seeds.single.source, SeedSource.favoriteAlbum);
    expect(seeds.single.weight, 0.85);
    expect(seeds.single.reason, 'favorite_album');
  });
}
