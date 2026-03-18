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
              '$count',
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
    return SegmentedButton<AppViewType>(
      segments: const <ButtonSegment<AppViewType>>[
        ButtonSegment<AppViewType>(
          value: AppViewType.grid,
          icon: Icon(Icons.grid_view_rounded, size: 18),
        ),
        ButtonSegment<AppViewType>(
          value: AppViewType.table,
          icon: Icon(Icons.view_list_rounded, size: 18),
        ),
      ],
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

class ArtistPageToolbar extends StatelessWidget {
  const ArtistPageToolbar({required this.l10n, super.key});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}
