import 'package:melo_trip/model/response/album/album.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:melo_trip/repository/album/album_repository.dart';

part 'albums.g.dart';

enum AlumsType { random, newest, recent, frequent }

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

class PaginatedAlbumListState {
  const PaginatedAlbumListState({
    this.items = const <AlbumEntity>[],
    this.isLoading = false,
    this.hasMore = true,
    this.offset = 0,
    this.error,
  });

  final List<AlbumEntity> items;
  final bool isLoading;
  final bool hasMore;
  final int offset;
  final Object? error;

  PaginatedAlbumListState copyWith({
    List<AlbumEntity>? items,
    bool? isLoading,
    bool? hasMore,
    int? offset,
    Object? error = _sentinel,
  }) {
    return PaginatedAlbumListState(
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
class PaginatedAlbumList extends _$PaginatedAlbumList {
  late final AlbumListQuery _query;

  @override
  PaginatedAlbumListState build(AlbumListQuery query) {
    _query = query;
    Future<void>.microtask(loadInitial);
    return const PaginatedAlbumListState();
  }

  Future<void> loadInitial() async {
    state = const PaginatedAlbumListState(isLoading: true);
    try {
      final result = await _fetchPage(0);
      if (!ref.mounted) return;
      final pageSize = _query.size ?? result.length;
      state = PaginatedAlbumListState(
        items: result,
        offset: result.length,
        hasMore: pageSize > 0 && result.length >= pageSize,
      );
    } catch (error) {
      if (!ref.mounted) return;
      state = PaginatedAlbumListState(hasMore: false, error: error);
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
      state = state.copyWith(isLoading: false, error: error);
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
Future<List<AlbumEntity>> albums(Ref ref, AlumsType type) async {
  final repository = ref.read(albumRepositoryProvider);
  return repository.fetchAlbumListItems(
    query: AlbumListQuery(type: type.name),
  );
}
