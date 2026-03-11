import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/artist/artist_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artist_detail.g.dart';

@riverpod
Future<SubsonicResponse?> artistDetail(Ref ref, String? artistId) async {
  final id = artistId;
  if (id == null) {
    return null;
  }

  final repository = ref.read(artistDetailRepositoryProvider);
  return repository.fetchArtistDetail(id);
}
