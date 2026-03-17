import 'package:flutter/material.dart';
import 'package:melo_trip/pages/desktop/library/widgets/view_types.dart';

class AlbumPageHeader extends StatelessWidget {
  const AlbumPageHeader({
    super.key,
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
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
          AlbumViewSwitcher(current: viewType, onChanged: onViewTypeChanged),
        ],
      ),
    );
  }
}

class AlbumViewSwitcher extends StatelessWidget {
  const AlbumViewSwitcher({
    super.key,
    required this.current,
    required this.onChanged,
    this.showDetailOption = true,
  });

  final AppViewType current;
  final ValueChanged<AppViewType> onChanged;
  final bool showDetailOption;

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
          _ViewItem(
            icon: Icons.grid_view_rounded,
            selected: current == AppViewType.grid,
            onTap: () => onChanged(AppViewType.grid),
          ),
          _ViewItem(
            icon: Icons.view_list_rounded,
            selected: current == AppViewType.table,
            onTap: () => onChanged(AppViewType.table),
          ),
          if (showDetailOption)
            _ViewItem(
              icon: Icons.view_headline_rounded,
              selected: current == AppViewType.detail,
              onTap: () => onChanged(AppViewType.detail),
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
