part of '../artists_page.dart';

class ArtistPageHeader extends StatelessWidget {
  const ArtistPageHeader({
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
    super.key,
  });

  final String title;
  final int count;
  final AppViewType viewType;
  final ValueChanged<AppViewType> onViewTypeChanged;

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
              Icons.people_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: .w900,
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
              '',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          ArtistViewSwitcher(
            current: viewType,
            onChanged: onViewTypeChanged,
          ),
        ],
      ),
    );
  }
}

class ArtistViewSwitcher extends StatelessWidget {
  const ArtistViewSwitcher({
    required this.current,
    required this.onChanged,
    super.key,
  });

  final AppViewType current;
  final ValueChanged<AppViewType> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _ArtistViewItem(
            icon: Icons.grid_view_rounded,
            selected: current == AppViewType.grid,
            onTap: () => onChanged(AppViewType.grid),
          ),
          _ArtistViewItem(
            icon: Icons.view_list_rounded,
            selected: current == AppViewType.table,
            onTap: () => onChanged(AppViewType.table),
          ),
        ],
      ),
    );
  }
}

class _ArtistViewItem extends StatelessWidget {
  const _ArtistViewItem({
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

class ArtistPageToolbar extends StatelessWidget {
  const ArtistPageToolbar({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}