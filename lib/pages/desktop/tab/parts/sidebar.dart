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

    final libraryItems = <_SidebarNavItem>[
      _SidebarNavItem(
        index: 0,
        title: l10n.listenNow,
        icon: Icons.home_rounded,
        onTap: () => onSelected(0),
      ),
      _SidebarNavItem(
        index: 2,
        title: l10n.myFavorites,
        icon: Icons.favorite_outline_rounded,
        onTap: () => onSelected(2),
      ),
      _SidebarNavItem(
        index: 3,
        title: l10n.album,
        icon: Icons.album_outlined,
        onTap: () => onSelected(3),
      ),
      _SidebarNavItem(
        index: 4,
        title: l10n.song,
        icon: Icons.music_note_outlined,
        onTap: () => onSelected(4),
      ),
      _SidebarNavItem(
        index: 5,
        title: l10n.artist,
        icon: Icons.people_outline_rounded,
        onTap: () => onSelected(5),
      ),
      _SidebarNavItem(
        index: 6,
        title: l10n.songMetaGenre,
        icon: Icons.flag_outlined,
        onTap: () => onSelected(6),
      ),
      _SidebarNavItem(
        index: 7,
        title: l10n.songMetaPath,
        icon: Icons.folder_open_outlined,
        onTap: () => onSelected(7),
      ),
    ];

    return AnimatedContainer(
      duration: DesktopMotionTokens.slow,
      curve: DesktopMotionTokens.standardCurve,
      width: compact ? 220 : 260,
      color: theme.colorScheme.surfaceContainer,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _SidebarSearchButton(l10n: l10n),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _SidebarSection(
                  title: l10n.library,
                  children: libraryItems
                      .map(
                        (item) => _NavTile(
                          title: item.title,
                          icon: item.icon,
                          selected: currentIndex == item.index,
                          onTap: item.onTap,
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16),
                _SidebarSection(
                  title: l10n.myPlaylist,
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

class _SidebarNavItem {
  const _SidebarNavItem({
    required this.index,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final int index;
  final String title;
  final IconData icon;
  final VoidCallback onTap;
}

class _SidebarSection extends StatelessWidget {
  const _SidebarSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: .w900,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .7,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}
