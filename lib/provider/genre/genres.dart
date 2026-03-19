import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/repository/genre/genres_repository.dart';

Future<List<GenreEntity>> fetchGenresItems(Ref ref) async {
  final repository = ref.read(genresRepositoryProvider);
  final result = await repository.tryFetchGenresItems();
  return result.when(
    ok: (items) => items,
    err: (failure) => throw failure,
  );
}

final genresProvider = FutureProvider<List<GenreEntity>>((ref) async {
  return fetchGenresItems(ref);
});
