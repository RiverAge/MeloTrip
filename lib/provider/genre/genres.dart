import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/genre/genres_repository.dart';

Future<SubsonicResponse?> fetchGenresResponse(Ref ref) {
  final repository = ref.read(genresRepositoryProvider);
  return repository.fetchGenresResponse();
}

Future<List<GenreEntity>> fetchGenresItems(Ref ref) async {
  final repository = ref.read(genresRepositoryProvider);
  return repository.fetchGenresItems();
}

final genresProvider = FutureProvider<List<GenreEntity>>((ref) async {
  return fetchGenresItems(ref);
});
