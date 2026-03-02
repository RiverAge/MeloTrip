part of '../tab_page.dart';

class _DesktopSidebar extends ConsumerWidget {
  const _DesktopSidebar({
    required this.currentIndex,
    required this.onSelected,
    required this.l10n,
    required this.compact,
  });

  final int currentIndex;
  final ValueChanged<int> onSelected;
  final AppLocalizations l10n;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: compact ? 220 : 260,
      color: theme.colorScheme.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SidebarSearchButton(l10n: l10n),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarSection(
                  title: l10n.library,
                  showToggle: true,
                  children: [
                    _NavTile(
                      title: l10n.listenNow,
                      icon: Icons.home_rounded,
                      selected: currentIndex == 0,
                      onTap: () => onSelected(0),
                    ),
                    _NavTile(
                      title: l10n.myFavorites,
                      icon: Icons.favorite_outline_rounded,
                      selected: currentIndex == 2,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.album,
                      icon: Icons.album_outlined,
                      selected: currentIndex == 3,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.song,
                      icon: Icons.music_note_outlined,
                      selected: currentIndex == 4,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.artist,
                      icon: Icons.people_outline_rounded,
                      selected: currentIndex == 5,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.artist,
                      icon: Icons.person_outline_rounded,
                      selected: currentIndex == 6,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.songMetaGenre,
                      icon: Icons.flag_outlined,
                      selected: currentIndex == 7,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.songMetaPath,
                      icon: Icons.folder_open_outlined,
                      selected: currentIndex == 8,
                      onTap: () {},
                    ),
                    _NavTile(
                      title: l10n.playlist,
                      icon: Icons.radio_outlined,
                      selected: currentIndex == 9,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SidebarSection(
                  title: l10n.myPlaylist,
                  showToggle: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.list_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  children: [
                    AsyncValueBuilder(
                      provider: playlistsProvider,
                      loading: (_, _) => const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      empty: (_, _) => const SizedBox.shrink(),
                      builder: (context, data, _) {
                        final list =
                            data.subsonicResponse?.playlists?.playlist ?? [];
                        if (list.isEmpty) return const SizedBox.shrink();
                        return Column(
                          children: list
                              .map((it) => _PlaylistTile(item: it))
                              .toList(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _NavTile(
            title: l10n.settings,
            icon: Icons.settings_outlined,
            selected: currentIndex == 1,
            onTap: () => onSelected(1),
          ),
          const SizedBox(height: 8),
          const _SidebarServerCard(),
        ],
      ),
    );
  }
}

class _SidebarSection extends StatelessWidget {
  const _SidebarSection({
    required this.title,
    required this.children,
    this.showToggle = false,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final bool showToggle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ),
              ?trailing,
              if (showToggle) ...[
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: .7,
                  ),
                ),
              ],
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class _SidebarSearchButton extends StatelessWidget {
  const _SidebarSearchButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const DesktopSearchPage()));
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: isDark ? .4 : .65,
          ),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: .55),
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.searchHint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: .6,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.menu_rounded, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: .2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Tooltip(
        message: title,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 10),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({required this.item});

  final PlaylistEntity item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => DesktopPlaylistDetailPage(playlistId: item.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ArtworkImage(
                id: item.coverArt ?? item.id,
                width: 28,
                height: 28,
                fit: .cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    item.name ?? '-',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.library_music_rounded,
                        size: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: .86),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${item.songCount ?? 0} ${AppLocalizations.of(context)!.songCountUnit}',
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.schedule_rounded,
                        size: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: .86),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          durationFormatter(item.duration),
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
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
      ),
    );
  }
}

class _SidebarServerCard extends ConsumerWidget {
  const _SidebarServerCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return AsyncValueBuilder(
      provider: currentUserProvider,
      loading: (_, _) => const SizedBox.shrink(),
      empty: (_, _) => const SizedBox.shrink(),
      builder: (context, user, _) {
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: .6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.surface,
                child: ClipOval(
                  child: Image.asset(
                    'images/navidrome.png',
                    width: 30,
                    height: 30,
                    fit: .cover,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      user.host?.replaceFirst(RegExp(r'^https?://'), '') ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: const TextStyle(fontWeight: .w700, fontSize: 13),
                    ),
                    Text(
                      '${user.username ?? '-'} · ${l10n.serverStatus}',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
