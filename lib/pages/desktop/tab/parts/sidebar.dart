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
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
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
