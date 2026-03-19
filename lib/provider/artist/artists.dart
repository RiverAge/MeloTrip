import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/repository/artist/artists_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artists.g.dart';

const int kArtistPageSize = 24;

class ArtistIndexEntry {
  const ArtistIndexEntry({
    required this.id,
    required this.name,
    this.coverArt,
    this.albumCount,
  });

  final String id;
  final String name;
  final String? coverArt;
  final int? albumCount;
}

@Riverpod(keepAlive: true)
class PaginatedArtists extends _$PaginatedArtists {
  @override
  PaginatedListSnapshot<ArtistIndexEntry> build() {
    Future<void>.microtask(loadInitial);
    return const PaginatedListSnapshot<ArtistIndexEntry>();
  }

  Future<void> loadInitial() async {
    state = const PaginatedListSnapshot<ArtistIndexEntry>(isLoading: true);
    final repository = ref.read(artistsRepositoryProvider);
    final result = await repository.tryFetchAllArtists();
    if (!ref.mounted) return;

    result.when(
      ok: (artists) {
        final int visibleCount = artists.length < kArtistPageSize
            ? artists.length
            : kArtistPageSize;
        state = PaginatedListSnapshot<ArtistIndexEntry>(
          items: artists,
          offset: visibleCount,
          hasMore: visibleCount < artists.length,
        );
      },
      err: (error) {
        state = PaginatedListSnapshot<ArtistIndexEntry>(
          hasMore: false,
          error: PaginatedListFailure(message: error.message, cause: error),
        );
      },
    );
  }

  void loadMore() {
    if (state.isLoading || !state.hasMore) return;
    final int nextVisibleCount = state.offset + kArtistPageSize;
    state = state.copyWith(
      offset: nextVisibleCount > state.items.length
          ? state.items.length
          : nextVisibleCount,
      hasMore: nextVisibleCount < state.items.length,
    );
  }
}
