import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
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
    try {
      final result = await _fetchPage(0);
      if (!ref.mounted) return;
      final pageSize = _query.songCount ?? result.length;
      state = PaginatedListSnapshot<SongEntity>(
        items: result,
        offset: result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = PaginatedListSnapshot<SongEntity>(
        hasMore: false,
        error: PaginatedListFailure.from(error),
      );
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
      state = state.copyWith(
        isLoading: false,
        error: PaginatedListFailure.from(error),
      );
    }
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<List<SongEntity>> _fetchPage(int offset) async {
    final repository = ref.read(songRepositoryProvider);
    return repository.fetchSongSearchItems(
      query: _query.copyWith(songOffset: offset),
    );
  }
}
