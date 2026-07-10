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

    for (final row in _creditsRows(l10n, song.contributors)) {
      addMetaRow(row);
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

/// Build one `_MetaItem` row per contributor role, with composers shown first.
///
/// Each row's value joins all participants of that role with ' / '. Performer
/// rows embed the sub-role (e.g. "Guitar: John") when present. Roles without a
/// known label fall back to a title-cased role string.
List<Widget> _creditsRows(
  AppLocalizations l10n,
  List<ContributorEntity>? contributors,
) {
  final byRole = <String, List<ContributorEntity>>{};
  for (final c in contributors ?? const <ContributorEntity>[]) {
    final role = c.role?.trim();
    if (role == null || role.isEmpty) continue;
    final name = c.name?.trim();
    if (name == null || name.isEmpty) continue;
    (byRole[role] ??= <ContributorEntity>[]).add(c);
  }
  if (byRole.isEmpty) return const <Widget>[];

  final roles = byRole.keys.toList()
    ..sort((a, b) {
      // Composer first, then alphabetical for stable ordering.
      if (a == 'composer' && b != 'composer') return -1;
      if (b == 'composer' && a != 'composer') return 1;
      return a.compareTo(b);
    });

  return roles.map((role) {
    final participants = byRole[role]!;
    final value = participants
        .map((c) {
          final name = c.name!.trim();
          final subRole = c.subRole?.trim();
          return subRole == null || subRole.isEmpty
              ? name
              : '$subRole: $name';
        })
        .join(' / ');
    return _MetaItem(
      icon: Icons.person_pin_rounded,
      label: _roleLabel(l10n, role),
      value: value,
    );
  }).toList();
}

String _roleLabel(AppLocalizations l10n, String role) {
  switch (role) {
    case 'composer':
      return l10n.songMetaRoleComposer;
    case 'lyricist':
      return l10n.songMetaRoleLyricist;
    case 'conductor':
      return l10n.songMetaRoleConductor;
    case 'arranger':
      return l10n.songMetaRoleArranger;
    case 'producer':
      return l10n.songMetaRoleProducer;
    case 'director':
      return l10n.songMetaRoleDirector;
    case 'engineer':
      return l10n.songMetaRoleEngineer;
    case 'mixer':
      return l10n.songMetaRoleMixer;
    case 'remixer':
      return l10n.songMetaRoleRemixer;
    case 'djmixer':
      return l10n.songMetaRoleDjMixer;
    case 'performer':
      return l10n.songMetaRolePerformer;
    default:
      return role[0].toUpperCase() + role.substring(1);
  }
}
