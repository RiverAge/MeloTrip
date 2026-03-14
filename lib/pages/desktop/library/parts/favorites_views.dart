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
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              SizedBox(
                width: 60,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: headerColor,
                ),
              ),
              Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
              const SizedBox(width: 30),
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

class _AlbumTableView extends StatelessWidget {
  const _AlbumTableView({required this.albums, required this.l10n});

  final List<AlbumEntity> albums;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return AlbumTableView(
      albums: albums,
      hasMore: false,
      scrollController: ScrollController(),
      l10n: l10n,
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
        // Convert ArtistEntity to ArtistIndexEntry for consistency if needed, 
        // or use a specific favorite artist card.
        return _FavoriteArtistCard(artist: artist);
      },
    );
  }
}

class _ArtistTableView extends StatelessWidget {
  const _ArtistTableView({required this.artists, required this.l10n});

  final List<ArtistEntity> artists;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    // Convert to ArtistIndexEntry to reuse ArtistTableView
    final entries = artists.map((e) => ArtistIndexEntry(
      id: e.id ?? '',
      name: e.name ?? '',
      albumCount: e.albumCount,
      coverArt: e.coverArt,
    )).toList();

    return ArtistTableView(
      artists: entries,
      hasMore: false,
      scrollController: ScrollController(),
      l10n: l10n,
    );
  }
}

class _FavoriteArtistCard extends StatefulWidget {
  const _FavoriteArtistCard({required this.artist});

  final ArtistEntity artist;

  @override
  State<_FavoriteArtistCard> createState() => _FavoriteArtistCardState();
}

class _FavoriteArtistCardState extends State<_FavoriteArtistCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.03 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: (_isHovered
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant)
                  .withValues(alpha: _isHovered ? 0.34 : 0.24),
            ),
            color: theme.colorScheme.surfaceContainerLow.withValues(
              alpha: _isHovered ? 0.95 : 0.84,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(
                  alpha: _isHovered ? 0.14 : 0.07,
                ),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 10 : 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        DesktopArtistDetailPage(artistId: widget.artist.id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Column(
                  children: <Widget>[
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.surfaceContainerHighest
                            .withValues(alpha: _isHovered ? 0.9 : 0.72),
                      ),
                      child: widget.artist.coverArt == null
                          ? Icon(
                              Icons.person_rounded,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.82),
                            )
                          : ClipOval(
                              child: ArtworkImage(
                                id: widget.artist.coverArt!,
                                size: 240,
                                width: 84,
                                height: 84,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.artist.name ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: _isHovered ? FontWeight.w800 : FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
