part of '../favorites_page.dart';

class _TrackList extends ConsumerWidget {
  const _TrackList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.7,
    );
    final headerStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ).copyWith(color: headerColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text('#', style: headerStyle),
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 72),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: headerColor,
                    ),
                  ),
                ),
              ),
              Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
              const SizedBox.square(dimension: 16),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: songs.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final song = songs[index];
              return SongTrackRow(index: index + 1, song: song);
            },
          ),
        ),
      ],
    );
  }
}

class _AlbumGrid extends StatelessWidget {
  const _AlbumGrid({required this.albums});

  final List<AlbumEntity> albums;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) {
        return DesktopAlbumCard(album: albums[index]);
      },
    );
  }
}

class _ArtistGrid extends StatelessWidget {
  const _ArtistGrid({required this.artists});

  final List<ArtistEntity> artists;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.8,
      ),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ArtistCard(
          key: ValueKey<String>(artist.id ?? '$index'),
          artist: ArtistIndexEntry(
            id: artist.id ?? '',
            name: artist.name ?? '-',
            albumCount: artist.albumCount,
            coverArt: artist.coverArt,
          ),
        );
      },
    );
  }
}
