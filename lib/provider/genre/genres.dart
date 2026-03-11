import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

Future<SubsonicResponse?> fetchGenresResponse(Ref ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getGenres');
  final data = res.data;
  if (data == null) return null;
  return SubsonicResponse.fromJson(data);
}

Future<List<GenreEntity>> fetchGenresItems(Ref ref) async {
  final response = await fetchGenresResponse(ref);
  return response?.subsonicResponse?.genres?.genre ?? const <GenreEntity>[];
}

final genresProvider = FutureProvider<List<GenreEntity>>((ref) async {
  return fetchGenresItems(ref);
});
