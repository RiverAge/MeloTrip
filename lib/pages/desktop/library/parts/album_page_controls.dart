part of '../albums_page.dart';

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
  });

  final String title;
  final int count;
  final AlbumViewType viewType;
  final ValueChanged<AlbumViewType> onViewTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.album_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          _ViewSwitcher(current: viewType, onChanged: onViewTypeChanged),
        ],
      ),
    );
  }
}

class _ViewSwitcher extends StatelessWidget {
  const _ViewSwitcher({required this.current, required this.onChanged});

  final AlbumViewType current;
  final ValueChanged<AlbumViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ViewItem(
            icon: Icons.grid_view_rounded,
            selected: current == AlbumViewType.grid,
            onTap: () => onChanged(AlbumViewType.grid),
          ),
          _ViewItem(
            icon: Icons.view_list_rounded,
            selected: current == AlbumViewType.table,
            onTap: () => onChanged(AlbumViewType.table),
          ),
          _ViewItem(
            icon: Icons.view_headline_rounded,
            selected: current == AlbumViewType.detail,
            onTap: () => onChanged(AlbumViewType.detail),
          ),
        ],
      ),
    );
  }
}

class _ViewItem extends StatelessWidget {
  const _ViewItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 18,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            l10n.name,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.sort_by_alpha_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Icon(Icons.filter_list_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Icon(Icons.refresh_rounded, size: 18, color: iconColor),
        ],
      ),
    );
  }
}
