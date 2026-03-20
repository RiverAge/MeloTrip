part of '../search_shared_widgets.dart';

class _SongResultTile extends StatelessWidget {
  const _SongResultTile({required this.song, required this.onTap});

  final SongEntity song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      title: song.title ?? '',
      subtitle: _joinNonEmpty(<String?>[song.album, song.artist]),
      artworkId: song.id,
      onTap: onTap,
    );
  }
}

class _AlbumResultTile extends StatelessWidget {
  const _AlbumResultTile({required this.album, required this.onTap});

  final AlbumEntity album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ResultTile(
      title: album.name ?? '',
      subtitle: _joinNonEmpty(<String?>[album.artist, album.year?.toString()]),
      artworkId: album.id,
      onTap: onTap,
    );
  }
}

class _ArtistResultTile extends StatelessWidget {
  const _ArtistResultTile({required this.artist, required this.onTap});

  final ArtistEntity artist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return _ResultTile(
      title: artist.name ?? '',
      subtitle: artist.albumCount == null
          ? ''
          : '${artist.albumCount} ${l10n.albumCount}',
      artworkId: artist.coverArt,
      onTap: onTap,
    );
  }
}

class _ResultTile extends StatelessWidget {
  const _ResultTile({
    required this.title,
    required this.subtitle,
    required this.artworkId,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String? artworkId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    const double artworkSize = 52;
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ArtworkImage(
                  id: artworkId,
                  width: artworkSize,
                  height: artworkSize,
                  size: 200,
                  fit: .cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(
                      title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w600,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...<Widget>[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _joinNonEmpty(List<String?> values) {
  return values
      .whereType<String>()
      .where((String value) => value.isNotEmpty)
      .join(' - ');
}
