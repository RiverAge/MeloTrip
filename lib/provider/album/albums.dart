import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:melo_trip/repository/album/album_repository.dart';

part 'albums.g.dart';

enum AlbumListType { random, newest, recent, frequent }

class AlbumListQuery {
  const AlbumListQuery({required this.type, this.size, this.offset});

  final String type;
  final int? size;
  final int? offset;

  AlbumListQuery copyWith({String? type, int? size, int? offset}) {
    return AlbumListQuery(
      type: type ?? this.type,
      size: size ?? this.size,
      offset: offset ?? this.offset,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return <String, dynamic>{
      'type': type,
      if (size != null) 'size': size,
      if (offset != null) 'offset': offset,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlbumListQuery &&
          type == other.type &&
          size == other.size &&
          offset == other.offset;

  @override
  int get hashCode => Object.hash(type, size, offset);
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
    try {
      final result = await _fetchPage(0);
      if (!ref.mounted) return;
      final pageSize = _query.size ?? result.length;
      state = PaginatedListSnapshot<AlbumEntity>(
        items: result,
        offset: result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = PaginatedListSnapshot<AlbumEntity>(
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
      final pageSize = _query.size ?? result.length;
      state = state.copyWith(
        items: <AlbumEntity>[...state.items, ...result],
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

  Future<List<AlbumEntity>> _fetchPage(int offset) async {
    final repository = ref.read(albumRepositoryProvider);
    return repository.fetchAlbumListItems(
      query: _query.copyWith(offset: offset),
    );
  }
}

@riverpod
Future<List<AlbumEntity>> albumList(Ref ref, AlbumListQuery query) async {
  final repository = ref.read(albumRepositoryProvider);
  return repository.fetchAlbumListItems(query: query);
}
