import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/song/songs.dart';
import 'package:melo_trip/repository/song/song_repository.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchProvider =
    FutureProvider<Result<SubsonicResponse, AppFailure>?>((ref) async {
      final query = ref.watch(searchQueryProvider);
      if (query.isEmpty) return null;

      await Future.delayed(const Duration(milliseconds: 600));
      if (ref.read(searchQueryProvider) != query) return null;

      return ref.read(searchByQueryProvider(query).future);
    });

final searchByQueryProvider =
    FutureProvider.family<Result<SubsonicResponse, AppFailure>?, String>((
      ref,
      query,
    ) async {
      if (query.isEmpty) return null;

      final cancelToken = CancelToken();
      ref.onDispose(() => cancelToken.cancel());

      final repository = ref.read(songRepositoryProvider);
      return repository.tryFetchSongSearchResponse(
        query: SongSearchQuery(query: query),
        cancelToken: cancelToken,
      );
    });
