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
    final List<ButtonSegment<AppViewType>> segments = <ButtonSegment<AppViewType>>[
      const ButtonSegment<AppViewType>(
        value: AppViewType.grid,
        icon: Icon(Icons.grid_view_rounded, size: 18),
      ),
      const ButtonSegment<AppViewType>(
        value: AppViewType.table,
        icon: Icon(Icons.view_list_rounded, size: 18),
      ),
    ];

    if (showDetailOption) {
      segments.add(
        const ButtonSegment<AppViewType>(
          value: AppViewType.detail,
          icon: Icon(Icons.view_headline_rounded, size: 18),
        ),
      );
    }

    return SegmentedButton<AppViewType>(
      segments: segments,
      selected: <AppViewType>{current},
      onSelectionChanged: (Set<AppViewType> values) {
        if (values.isNotEmpty) {
          onChanged(values.first);
        }
      },
      showSelectedIcon: false,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.surface;
          }
          return theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          );
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.colorScheme.primary;
          }
          return theme.colorScheme.onSurfaceVariant;
        }),
        padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
        side: WidgetStateProperty.all(BorderSide.none),
      ),
    );
  }
}
