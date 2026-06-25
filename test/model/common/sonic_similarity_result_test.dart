import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/sonic_similarity_result.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  group('SonicSimilarityResult', () {
    test('creates result with songs', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final result = SonicSimilarityResult(songs: songs);

      expect(result.songs.length, 2);
      expect(result.songs[0].id, 'song-1');
      expect(result.isUnanalyzed, false);
      expect(result.isEmpty, false);
      expect(result.isNotEmpty, true);
    });

    test('creates empty result', () {
      const result = SonicSimilarityResult.empty;

      expect(result.songs.isEmpty, true);
      expect(result.isUnanalyzed, false);
      expect(result.isEmpty, true);
      expect(result.isNotEmpty, false);
    });

    test('creates unanalyzed result', () {
      const result = SonicSimilarityResult.unanalyzed;

      expect(result.songs.isEmpty, true);
      expect(result.isUnanalyzed, true);
      expect(result.isEmpty, true);
    });

    test('distinguishes empty from unanalyzed', () {
      const emptyResult = SonicSimilarityResult.empty;
      const unanalyzedResult = SonicSimilarityResult.unanalyzed;

      // Both are empty
      expect(emptyResult.isEmpty, true);
      expect(unanalyzedResult.isEmpty, true);

      // But unanalyzed has the flag set
      expect(emptyResult.isUnanalyzed, false);
      expect(unanalyzedResult.isUnanalyzed, true);
    });

    test('custom result with unanalyzed flag', () {
      final result = SonicSimilarityResult(
        songs: [],
        isUnanalyzed: true,
      );

      expect(result.isEmpty, true);
      expect(result.isUnanalyzed, true);
    });
  });
}
