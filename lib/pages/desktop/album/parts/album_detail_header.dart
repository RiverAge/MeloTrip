part of '../album_detail_page.dart';

class _AlbumDetailHeader extends StatelessWidget {
  const _AlbumDetailHeader({
    required this.album,
    required this.songs,
    required this.showTitle,
    required this.onPlayAlbum,
    required this.formatTotalDuration,
  });

  final AlbumEntity album;
  final List<SongEntity> songs;
  final bool showTitle;
  final Future<void> Function(WidgetRef ref) onPlayAlbum;
  final String Function(List<SongEntity> songs) formatTotalDuration;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 340,
      backgroundColor: theme.colorScheme.surface,
      elevation: showTitle ? 2 : 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: AnimatedOpacity(
        opacity: showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          album.name ?? '',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ArtworkImage(id: album.id, fit: BoxFit.cover, size: 800),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                color: theme.colorScheme.scrim.withValues(alpha: 0.24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: 0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ArtworkImage(id: album.id, size: 600),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          l10n.album,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.85),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            album.name ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.2,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _AlbumMetaRow(
                          album: album,
                          songs: songs,
                          formatTotalDuration: formatTotalDuration,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          album.artist ?? '-',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: <Widget>[
                            Consumer(
                              builder: (context, ref, _) {
                                return FilledButton.icon(
                                  onPressed: songs.isEmpty
                                      ? null
                                      : () => onPlayAlbum(ref),
                                  icon: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 24,
                                  ),
                                  label: Text(l10n.play),
                                  style: FilledButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                    backgroundColor: theme.colorScheme.primary,
                                    foregroundColor:
                                        theme.colorScheme.onPrimary,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            _HeaderOutlineButton(
                              icon: Icons.shuffle_rounded,
                              label: l10n.shuffleOn,
                            ),
                            const SizedBox(width: 12),
                            _HeaderOutlineButton(
                              icon: Icons.playlist_play_rounded,
                              label: l10n.playQueue,
                            ),
                            const Spacer(),
                            const Icon(Icons.star_border_rounded, size: 22),
                            const SizedBox(width: 16),
                            const Icon(Icons.favorite_border_rounded, size: 20),
                            const SizedBox(width: 16),
                            const Icon(Icons.more_horiz_rounded, size: 22),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumMetaRow extends StatelessWidget {
  const _AlbumMetaRow({
    required this.album,
    required this.songs,
    required this.formatTotalDuration,
  });

  final AlbumEntity album;
  final List<SongEntity> songs;
  final String Function(List<SongEntity> songs) formatTotalDuration;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    final String year = album.year == null
        ? ''
        : '${l10n.songMetaYear}: ${album.year}';
    final String count = '${songs.length} ${l10n.songCountUnit}';
    final String duration = formatTotalDuration(songs);
    final String summary = <String>[
      year,
      count,
      duration,
    ].where((String item) => item.isNotEmpty).join(' 璺?');

    return Row(
      children: <Widget>[
        Icon(
          Icons.music_note_rounded,
          size: 14,
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 4),
        Text(
          summary,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
