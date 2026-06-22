part of '../song_control.dart';

class _SongMeta extends StatelessWidget {
  const _SongMeta({
    required this.song,
    required this.onOpenArtist,
    required this.onOpenAlbum,
  });

  final SongEntity song;
  final void Function(String artistId) onOpenArtist;
  final void Function() onOpenAlbum;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final artists = song.artists ?? [];
    final artistNames = artists
        .map((artist) => artist.name?.trim() ?? '')
        .where((name) => name.isNotEmpty)
        .join(' / ');
    final metaRows = <Widget>[];

    void addMetaRow(Widget row) {
      if (metaRows.isNotEmpty) metaRows.add(_MetaSeparator());
      metaRows.add(row);
    }

    if (artistNames.isNotEmpty) {
      addMetaRow(
        _MetaItem(
          icon: Icons.group_rounded,
          label: l10n.artist,
          value: artistNames,
          onTap: artists.length == 1 && artists.first.id != null
              ? () => onOpenArtist(artists.first.id!)
              : null,
        ),
      );
    }

    addMetaRow(
      _MetaItem(
        icon: Icons.album_outlined,
        label: l10n.album,
        value: song.album ?? '-',
        onTap: onOpenAlbum,
      ),
    );

    if (song.genre != null) {
      addMetaRow(
        _MetaItem(
          icon: Icons.gesture_rounded,
          label: l10n.songMetaGenre,
          value: song.genre!,
        ),
      );
    }

    if (song.year != null) {
      addMetaRow(
        _MetaItem(
          icon: Icons.date_range_outlined,
          label: l10n.songMetaYear,
          value: '${song.year}',
        ),
      );
    }

    if (song.track != null) {
      final trackText = song.discNumber == null
          ? '${song.track}'
          : '${song.discNumber}-${song.track}';
      addMetaRow(
        _MetaItem(
          icon: Icons.disc_full_outlined,
          label: l10n.songMetaTrackNumber,
          value: trackText,
        ),
      );
    }

    addMetaRow(
      _MetaItem(
        icon: Icons.storage_rounded,
        label: l10n.songMetaSize,
        value: fileSizeFormatter(song.size),
      ),
    );

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(children: metaRows),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final content = Padding(
      padding: const EdgeInsets.fromLTRB(6, 10, 2, 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: 22,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.76),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
            ),
          ],
        ],
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: content,
    );
  }
}

class _MetaSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 42),
      child: Divider(
        height: 1,
        color: Theme.of(
          context,
        ).colorScheme.outlineVariant.withValues(alpha: 0.42),
      ),
    );
  }
}
