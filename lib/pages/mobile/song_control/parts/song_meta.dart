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

    final creditsValue = _creditsValue(l10n, song.contributors);
    if (creditsValue != null) {
      addMetaRow(
        _MetaItem(
          icon: Icons.person_pin_rounded,
          label: l10n.songMetaCredits,
          value: creditsValue,
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
                  maxLines: 8,
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

/// Aggregate contributors into one multi-line string keyed by person.
///
/// Mirrors the credit source's own design (see AppleMusicDecrypt
/// `src/credits.py`): credits are authored per-person, so we pivot the flat
/// `role -> [artist]` list Navidrome returns back into `person -> [roles]`.
/// Each person gets one line: `name — role1 · role2 · ...`, joined across
/// people by newlines. The performer's English `subRole` is intentionally
/// ignored — it duplicates the role tags and only carries English labels.
///
/// Roles are de-duplicated per person and ordered by [_roleRank] (composer
/// first, then the canonical [_roleLabel] switch order; unknown roles sink to
/// the end). People keep the order of their first appearance in
/// `contributors`.
String? _creditsValue(
  AppLocalizations l10n,
  List<ContributorEntity>? contributors,
) {
  final byPerson = <String, List<String>>{};
  for (final c in contributors ?? const <ContributorEntity>[]) {
    final name = c.name?.trim();
    if (name == null || name.isEmpty) continue;
    final role = c.role?.trim();
    if (role == null || role.isEmpty) continue;
    final roles = byPerson.putIfAbsent(name, () => <String>[]);
    if (!roles.contains(role)) roles.add(role);
  }
  if (byPerson.isEmpty) return null;

  return byPerson.entries.map((entry) {
    final roles = List<String>.of(entry.value)
      ..sort((a, b) => _roleRank(a).compareTo(_roleRank(b)));
    final rolesStr = roles.map((r) => _roleLabel(l10n, r)).join(' · ');
    return '${entry.key} — $rolesStr';
  }).join('\n');
}

/// Display priority for a contributor role: composer/lyricist first, then the
/// rest by their canonical [_roleLabel] switch order. Unknown roles sink to
/// the end while keeping stable relative order (same rank → 0).
int _roleRank(String role) {
  const order = [
    'composer',
    'lyricist',
    'conductor',
    'arranger',
    'producer',
    'director',
    'engineer',
    'mixer',
    'remixer',
    'djmixer',
    'performer',
  ];
  final i = order.indexOf(role);
  return i < 0 ? order.length : i;
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
