import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
Future<SubsonicResponse?> songDetail(Ref ref, String? songId) async {
  final id = songId;
  if (id == null) {
    return null;
  }

  final res = await Http.get<Map<String, dynamic>>('/rest/getSong',
      queryParameters: {'id': songId});

  final data = res?.data;
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

  Future<SubsonicResponse?> toggleFavorite(String? songId) async {
    if (songId == null) {
      return null;
    }

    final res = await ref.watch(songDetailProvider(songId).future);
    final starred = res?.subsonicResponse?.song?.starred;

    final ret = await Http.get<Map<String, dynamic>>(
        '/rest/${starred != null ? 'un' : ''}star',
        queryParameters: {'id': songId});

    final data = ret?.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(songDetailProvider(songId));
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

    final ret = await Http.get<Map<String, dynamic>>('/rest/setRating',
        queryParameters: {'id': songId, 'rating': rating});

    final data = ret?.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(songDetailProvider(songId));
    }
    return subsonic;
  }
}
