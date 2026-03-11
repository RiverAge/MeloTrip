import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
Future<SubsonicResponse?> songDetail(Ref ref, String? songId) async {
  final id = songId;
  if (id == null) {
    return null;
  }

  final repository = ref.read(songDetailRepositoryProvider);
  return repository.fetchSongDetail(id);
}

@riverpod
class SongFavorite extends _$SongFavorite {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> toggleFavorite(SongEntity? song) async {
    if (song == null || song.id == null) {
      return null;
    }

    final res = await ref.read(songDetailProvider(song.id).future);
    final starred = res?.subsonicResponse?.song?.starred;
    final subsonic = await ref.read(songDetailRepositoryProvider).toggleFavorite(
      songId: song.id!,
      isStarred: starred != null,
    );
    if (subsonic?.subsonicResponse?.status == 'ok') {
      ref.invalidate(songDetailProvider(song.id));
    }
    return subsonic;
  }
}

@riverpod
class SongRating extends _$SongRating {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> updateRating(String? songId, int? rating) async {
    if (songId == null || rating == null) {
      return null;
    }

    final subsonic = await ref.read(songDetailRepositoryProvider).setRating(
      songId: songId,
      rating: rating,
    );
    if (subsonic?.subsonicResponse?.status == 'ok') {
      ref.invalidate(songDetailProvider(songId));
    }
    return subsonic;
  }
}
