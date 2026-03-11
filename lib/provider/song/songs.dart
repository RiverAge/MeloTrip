import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show Ref;
import 'package:flutter_riverpod/legacy.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

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

class PaginatedSongListNotifier extends StateNotifier<PaginatedSongListState> {
  PaginatedSongListNotifier(this._ref, this._query)
    : super(const PaginatedSongListState()) {
    loadInitial();
  }

  final Ref _ref;
  final SongSearchQuery _query;

  Future<void> loadInitial() async {
    state = const PaginatedSongListState(isLoading: true);
    try {
      final result = await _fetchPage(0);
      final pageSize = _query.songCount ?? result.length;
      state = PaginatedSongListState(
        items: result,
        offset: result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
      );
    } catch (error) {
      state = PaginatedSongListState(hasMore: false, error: error);
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _fetchPage(state.offset);
      final pageSize = _query.songCount ?? result.length;
      state = state.copyWith(
        items: <SongEntity>[...state.items, ...result],
        offset: state.offset + result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
        isLoading: false,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<List<SongEntity>> _fetchPage(int offset) async {
    final api = await _ref.read(apiProvider.future);
    return fetchSongSearchItems(
      api,
      query: _query.copyWith(songOffset: offset),
    );
  }
}

final paginatedSongListProvider =
    StateNotifierProvider.family<
      PaginatedSongListNotifier,
      PaginatedSongListState,
      SongSearchQuery
    >((ref, query) => PaginatedSongListNotifier(ref, query));
