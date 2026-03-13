part of '../favorites_page.dart';

class _TrackList extends StatelessWidget {
  const _TrackList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: songs.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) => ListTile(
        leading: Text('${index + 1}'),
        title: Text(songs[index].title ?? '-'),
        subtitle: Text(songs[index].artist ?? '-'),
        trailing: Icon(
          Icons.favorite_rounded,
          color: theme.colorScheme.primary,
          size: 16,
        ),
      ),
    );
  }
}

class _AlbumGrid extends StatelessWidget {
  const _AlbumGrid({required this.albums});

  final List<AlbumEntity> albums;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: albums.length,
      itemBuilder: (context, index) => Column(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            albums[index].name ?? '-',
            maxLines: 1,
            overflow: .ellipsis,
          ),
        ],
      ),
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
      itemBuilder: (context, index) => _FavoriteArtistCard(artist: artists[index]),
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
                                id: widget.artist.coverArt,
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
