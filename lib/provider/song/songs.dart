import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/repository/song/song_repository.dart';
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

@Riverpod(keepAlive: true)
class PaginatedSongList extends _$PaginatedSongList {
  late final SongSearchQuery _query;

  @override
  PaginatedListSnapshot<SongEntity> build(SongSearchQuery query) {
    _query = query;
    Future<void>.microtask(loadInitial);
    return const PaginatedListSnapshot<SongEntity>();
  }

  Future<void> loadInitial() async {
    state = const PaginatedListSnapshot<SongEntity>(isLoading: true);
    final result = await _fetchPage(0);
    if (!ref.mounted) return;
    result.when(
      ok: (items) {
        final pageSize = _query.songCount ?? items.length;
        state = PaginatedListSnapshot<SongEntity>(
          items: items,
          offset: items.length,
          hasMore: pageSize > 0 && items.length >= pageSize,
        );
      },
      err: (error) {
        state = PaginatedListSnapshot<SongEntity>(
          hasMore: false,
          error: PaginatedListFailure(message: error.message, cause: error),
        );
      },
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _fetchPage(state.offset);
    if (!ref.mounted) return;
    result.when(
      ok: (items) {
        final pageSize = _query.songCount ?? items.length;
        state = state.copyWith(
          items: <SongEntity>[...state.items, ...items],
          offset: state.offset + items.length,
          hasMore: pageSize > 0 && items.length >= pageSize,
          isLoading: false,
        );
      },
      err: (error) {
        state = state.copyWith(
          isLoading: false,
          error: PaginatedListFailure(message: error.message, cause: error),
        );
      },
    );
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<Result<List<SongEntity>, AppFailure>> _fetchPage(int offset) async {
    final repository = ref.read(songRepositoryProvider);
    return repository.tryFetchSongSearchItems(
      query: _query.copyWith(songOffset: offset),
    );
  }
}
