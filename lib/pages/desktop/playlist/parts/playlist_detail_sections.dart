part of '../playlist_detail_page.dart';

class PlaylistHeader extends StatelessWidget {
  const PlaylistHeader({
    required this.playlist,
    required this.songs,
    required this.l10n,
    required this.onPlayAll,
    required this.onPlayNext,
    required this.onPlayLast,
    super.key,
  });

  final dynamic playlist;
  final List<SongEntity> songs;
  final AppLocalizations l10n;
  final VoidCallback onPlayAll;
  final VoidCallback onPlayNext;
  final VoidCallback onPlayLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ArtworkImage(
              id: playlist.id,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              size: 400,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.playlist,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  playlist.name ?? '-',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    FilledButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayAll,
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: Text(l10n.play),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayNext,
                      icon: const Icon(Icons.redo_rounded, size: 18),
                      label: Text(l10n.playAddToNext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayLast,
                      icon: const Icon(Icons.skip_next_rounded, size: 18),
                      label: Text(l10n.playAddToLast),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaylistToolbar extends StatelessWidget {
  const PlaylistToolbar({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color iconColor = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.shuffle_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Text(
            l10n.track,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.sort_by_alpha_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.filter_list_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.refresh_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.more_horiz_rounded, size: 18, color: iconColor),
          const Spacer(),
          Text(
            l10n.edit,
            style: theme.textTheme.labelMedium?.copyWith(color: iconColor),
          ),
          const SizedBox(width: 16),
          Icon(Icons.expand_less_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Icon(Icons.grid_view_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Icon(Icons.tune_rounded, size: 18, color: iconColor),
        ],
      ),
    );
  }
}

class PlaylistTrackTableHeader extends StatelessWidget {
  const PlaylistTrackTableHeader({
    required this.theme,
    required this.l10n,
    super.key,
  });

  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final TextStyle headerStyle = kPlaylistHeaderStyle.copyWith(
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('#', style: headerStyle)),
          Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
          SizedBox(
            width: 60,
            child: Icon(
              Icons.access_time_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
            ),
          ),
          Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
          Expanded(
            flex: 2,
            child: Text(l10n.songMetaGenre, style: headerStyle),
          ),
          SizedBox(
            width: 60,
            child: Text(l10n.songMetaYear, style: headerStyle),
          ),
          const SizedBox(width: 30),
        ],
      ),
    );
  }
}

const TextStyle kPlaylistHeaderStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
);

class PlaylistTrackRow extends StatelessWidget {
  const PlaylistTrackRow({
    required this.index,
    required this.song,
    required this.onTap,
    super.key,
  });

  final int index;
  final SongEntity song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ArtworkImage(
                      id: song.id,
                      size: 80,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          song.artist ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                _formatSec(song.duration ?? 0),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                song.album ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                song.genre ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '${song.year ?? ''}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSec(int sec) {
    final String m = (sec ~/ 60).toString().padLeft(1, '0');
    final String s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
