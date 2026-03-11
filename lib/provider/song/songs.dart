import 'package:dio/dio.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'songs.g.dart';

class SongSearchQuery {
  const SongSearchQuery({
    required this.query,
    this.songCount,
    this.songOffset,
    this.albumCount,
    this.artistCount,
  });

  final String query;
  final int? songCount;
  final int? songOffset;
  final int? albumCount;
  final int? artistCount;

  SongSearchQuery copyWith({
    String? query,
    int? songCount,
    int? songOffset,
    int? albumCount,
    int? artistCount,
  }) {
    return SongSearchQuery(
      query: query ?? this.query,
      songCount: songCount ?? this.songCount,
      songOffset: songOffset ?? this.songOffset,
      albumCount: albumCount ?? this.albumCount,
      artistCount: artistCount ?? this.artistCount,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'query': query,
      if (songCount != null) 'songCount': songCount,
      if (songOffset != null) 'songOffset': songOffset,
      if (albumCount != null) 'albumCount': albumCount,
      if (artistCount != null) 'artistCount': artistCount,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SongSearchQuery &&
          query == other.query &&
          songCount == other.songCount &&
          songOffset == other.songOffset &&
          albumCount == other.albumCount &&
          artistCount == other.artistCount;

  @override
  int get hashCode =>
      Object.hash(query, songCount, songOffset, albumCount, artistCount);
}

Future<SubsonicResponse?> fetchSongSearchResponse(
  Dio api, {
  required SongSearchQuery query,
  CancelToken? cancelToken,
}) async {
  final res = await api.get<Map<String, dynamic>>(
    '/rest/search3',
    queryParameters: query.toQueryParameters(),
    cancelToken: cancelToken,
  );

  final data = res.data;
  if (data == null) return null;
  return SubsonicResponse.fromJson(data);
}

Future<List<SongEntity>> fetchSongSearchItems(
  Dio api, {
  required SongSearchQuery query,
  CancelToken? cancelToken,
}) async {
  final response = await fetchSongSearchResponse(
    api,
    query: query,
    cancelToken: cancelToken,
  );
  return response?.subsonicResponse?.searchResult3?.song ??
      const <SongEntity>[];
}

class PaginatedSongListState {
  const PaginatedSongListState({
    this.items = const <SongEntity>[],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
    this.error,
  });

  final List<SongEntity> items;
  final bool isLoading;
  final bool hasMore;
  final int offset;
  final Object? error;

  PaginatedSongListState copyWith({
    List<SongEntity>? items,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    Object? error = _sentinel,
  }) {
    return PaginatedSongListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      error: identical(error, _sentinel) ? this.error : error,
    );
  }
}

const Object _sentinel = Object();

@Riverpod(keepAlive: true)
class PaginatedSongList extends _$PaginatedSongList {
  late final SongSearchQuery _query;

  @override
  PaginatedSongListState build(SongSearchQuery query) {
    _query = query;
    Future<void>.microtask(loadInitial);
    return const PaginatedSongListState();
  }

  Future<void> loadInitial() async {
    state = const PaginatedSongListState(isLoading: true);
    try {
      final result = await _fetchPage(0);
      if (!ref.mounted) return;
      final pageSize = _query.songCount ?? result.length;
      state = PaginatedSongListState(
        items: result,
        offset: result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = PaginatedSongListState(hasMore: false, error: error);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _fetchPage(state.offset);
      if (!ref.mounted) return;
      final pageSize = _query.songCount ?? result.length;
      state = state.copyWith(
        items: <SongEntity>[...state.items, ...result],
        offset: state.offset + result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
        isLoading: false,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<List<SongEntity>> _fetchPage(int offset) async {
    final api = await ref.read(apiProvider.future);
    return fetchSongSearchItems(
      api,
      query: _query.copyWith(songOffset: offset),
    );
  }
}
