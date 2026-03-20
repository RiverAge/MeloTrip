import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:melo_trip/repository/album/album_repository.dart';

part 'albums.g.dart';

enum AlbumListType { random, newest, recent, frequent }

class AlbumListQuery {
  const AlbumListQuery({required this.type, this.size, this.offset, this.genre});

  final String type;
  final int? size;
  final int? offset;
  final String? genre;

  AlbumListQuery copyWith({String? type, int? size, int? offset, String? genre}) {
    return AlbumListQuery(
      type: type ?? this.type,
      size: size ?? this.size,
      offset: offset ?? this.offset,
      genre: genre ?? this.genre,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'type': type,
      if (size != null) 'size': size,
      if (offset != null) 'offset': offset,
      if (genre != null) 'genre': genre,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumListQuery &&
          type == other.type &&
          size == other.size &&
          offset == other.offset &&
          genre == other.genre;

  @override
  int get hashCode => Object.hash(type, size, offset, genre);
}

@Riverpod(keepAlive: true)
class PaginatedAlbumList extends _$PaginatedAlbumList {
  late final AlbumListQuery _query;

  @override
  PaginatedListSnapshot<AlbumEntity> build(AlbumListQuery query) {
    _query = query;
    Future<void>.microtask(loadInitial);
    return const PaginatedListSnapshot<AlbumEntity>();
  }

  Future<void> loadInitial() async {
    state = const PaginatedListSnapshot<AlbumEntity>(isLoading: true);
    final result = await _fetchPage(0);
    if (!ref.mounted) return;
    state = result.when(
      ok: (items) {
        final pageSize = _query.size ?? items.length;
        return PaginatedListSnapshot<AlbumEntity>(
          items: items,
          offset: items.length,
          hasMore: pageSize > 0 && items.length >= pageSize,
        );
      },
      err: (error) => PaginatedListSnapshot<AlbumEntity>(
        hasMore: false,
        error: PaginatedListFailure(message: error.message, cause: error),
      ),
    );
  }

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _fetchPage(state.offset);
    if (!ref.mounted) return;
    state = result.when(
      ok: (items) {
        final pageSize = _query.size ?? items.length;
        return state.copyWith(
          items: <AlbumEntity>[...state.items, ...items],
          offset: state.offset + items.length,
          hasMore: pageSize > 0 && items.length >= pageSize,
          isLoading: false,
        );
      },
      err: (error) => state.copyWith(
        isLoading: false,
        error: PaginatedListFailure(message: error.message, cause: error),
      ),
    );
  }

  Future<void> refresh() async {
    await loadInitial();
  }

  Future<Result<List<AlbumEntity>, AppFailure>> _fetchPage(int offset) async {
    final repository = ref.read(albumRepositoryProvider);
    return repository.tryFetchAlbumListItems(
      query: _query.copyWith(offset: offset),
    );
  }
}

@riverpod
Future<Result<List<AlbumEntity>, AppFailure>> albumList(
  Ref ref,
  AlbumListQuery query,
) async {
  final repository = ref.read(albumRepositoryProvider);
  return repository.tryFetchAlbumListItems(query: query);
}
