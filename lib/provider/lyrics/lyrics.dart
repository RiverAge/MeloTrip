import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/lyrics/lyrics_merge.dart';
import 'package:melo_trip/repository/lyrics/lyrics_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics.g.dart';

@riverpod
Future<SubsonicResponse?> lyrics(Ref ref, String? songId) async {
  if (songId == null) return null;

  final repository = ref.read(lyricsRepositoryProvider);
  final response = await repository.fetchLyrics(songId);
  return mergePreferredStructuredLyrics(response);
}
