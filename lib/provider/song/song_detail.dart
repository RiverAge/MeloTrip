import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/smart_suggestion/smart_suggestion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
Future<SubsonicResponse?> songDetail(Ref ref, String? songId) async {
  final id = songId;
  if (id == null) {
    return null;
  }

  final api = await ref.read(apiProvider.future);

  final res = await api.get<Map<String, dynamic>>(
    '/rest/getSong',
    queryParameters: {'id': songId},
  );

  final data = res.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
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

    final api = await ref.read(apiProvider.future);

    if (starred == null && song.id != null) {
      ref.read(smartSuggestionProvider.notifier).similarSongs(song);
    }

    final ret = await api.get<Map<String, dynamic>>(
      '/rest/${starred != null ? 'un' : ''}star',
      queryParameters: {'id': song.id},
    );

    final data = ret.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
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

    final api = await ref.read(apiProvider.future);
    final ret = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: {'id': songId, 'rating': rating},
    );

    final data = ret.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(songDetailProvider(songId));
    }
    return subsonic;
  }
}
