import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/favorite_artist_weighted_seeds.dart';

void main() {
  test('extractFavoriteArtistSeedSongIds extracts artist album songs', () {
    final ids = extractFavoriteArtistSeedSongIds([
      AlbumEntity(
        id: 'album-1',
        song: [
          SongEntity(id: 'song-1', title: 'Song 1'),
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

  test('extractFavoriteArtistSeedSongIds respects maxSeeds', () {
    final ids = extractFavoriteArtistSeedSongIds([
      AlbumEntity(
        id: 'album-1',
        song: [
          SongEntity(id: 'song-1', title: 'Song 1'),
          SongEntity(id: 'song-2', title: 'Song 2'),
        ],
      ),
    ], maxSeeds: 1);

    expect(ids, ['song-1']);
  });

  test('convertFavoriteArtistSeedsToWeighted marks favorite artist source', () {
    final seeds = convertFavoriteArtistSeedsToWeighted(['song-1']);

    expect(seeds.single.songId, 'song-1');
    expect(seeds.single.source, SeedSource.favoriteArtist);
    expect(seeds.single.weight, 0.78);
    expect(seeds.single.reason, 'favorite_artist');
  });
}
