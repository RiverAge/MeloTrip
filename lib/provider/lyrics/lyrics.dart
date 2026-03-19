import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/lyrics/lyrics_merge.dart';
import 'package:melo_trip/repository/lyrics/lyrics_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics.g.dart';

@riverpod
Future<Result<SubsonicResponse, AppFailure>?> lyrics(Ref ref, String? songId) async {
  if (songId == null) return null;

  final repository = ref.read(lyricsRepositoryProvider);
  final result = await repository.tryFetchLyrics(songId);
  return result.when(
    ok: (response) => Result.ok(mergePreferredStructuredLyrics(response)),
    err: Result.err,
  );
}
