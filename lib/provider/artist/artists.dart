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

class PaginatedArtistsState {
  const PaginatedArtistsState({
    this.allArtists = const <ArtistIndexEntry>[],
    this.visibleCount = 0,
    this.isLoading = false,
  });

  final List<ArtistIndexEntry> allArtists;
  final int visibleCount;
  final bool isLoading;

  List<ArtistIndexEntry> get visibleArtists {
    final int safeCount = visibleCount.clamp(0, allArtists.length);
    return allArtists.take(safeCount).toList(growable: false);
  }

  bool get hasMore => visibleCount < allArtists.length;

  PaginatedArtistsState copyWith({
    List<ArtistIndexEntry>? allArtists,
    int? visibleCount,
    bool? isLoading,
  }) {
    return PaginatedArtistsState(
      allArtists: allArtists ?? this.allArtists,
      visibleCount: visibleCount ?? this.visibleCount,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

@Riverpod(keepAlive: true)
class PaginatedArtists extends _$PaginatedArtists {
  @override
  PaginatedArtistsState build() {
    Future<void>.microtask(loadInitial);
    return const PaginatedArtistsState();
  }

  Future<void> loadInitial() async {
    state = const PaginatedArtistsState(isLoading: true);
    try {
      final List<ArtistIndexEntry> artists = await fetchAllArtists(ref);
      if (!ref.mounted) return;
      state = PaginatedArtistsState(
        allArtists: artists,
        visibleCount: artists.length < kArtistPageSize
            ? artists.length
            : kArtistPageSize,
      );
    } catch (_) {
      if (!ref.mounted) return;
      state = const PaginatedArtistsState();
    }
  }

  void loadMore() {
    if (state.isLoading || !state.hasMore) return;
    final int nextVisibleCount = state.visibleCount + kArtistPageSize;
    state = state.copyWith(
      visibleCount: nextVisibleCount > state.allArtists.length
          ? state.allArtists.length
          : nextVisibleCount,
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
