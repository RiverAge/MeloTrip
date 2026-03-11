import 'package:melo_trip/model/common/paginated_list_snapshot.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artists.g.dart';

const int kArtistPageSize = 60;

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
    try {
      final List<ArtistIndexEntry> artists = await fetchAllArtists(ref);
      if (!ref.mounted) return;
      final int visibleCount = artists.length < kArtistPageSize
          ? artists.length
          : kArtistPageSize;
      state = PaginatedListSnapshot<ArtistIndexEntry>(
        items: artists,
        offset: visibleCount,
        hasMore: visibleCount < artists.length,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = const PaginatedListSnapshot<ArtistIndexEntry>();
    }
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

Future<List<ArtistIndexEntry>> fetchAllArtists(Ref ref) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getArtists');
  final data = res.data;
  if (data == null) return const <ArtistIndexEntry>[];

  final indexes =
      data['subsonic-response']?['artists']?['index'] as List<dynamic>? ??
      const <dynamic>[];
  final entries = <ArtistIndexEntry>[];
  for (final idx in indexes) {
    final artists = idx['artist'] as List<dynamic>? ?? const <dynamic>[];
    for (final artist in artists) {
      entries.add(
        ArtistIndexEntry(
          id: artist['id']?.toString() ?? '',
          name: artist['name']?.toString() ?? '',
          coverArt: artist['coverArt']?.toString(),
          albumCount: artist['albumCount'] as int?,
        ),
      );
    }
  }
  return entries;
}
