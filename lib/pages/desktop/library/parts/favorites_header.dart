part of '../favorites_page.dart';

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.currentType,
    required this.onTypeChanged,
  });

  final String title;
  final String currentType;
  final ValueChanged<String> onTypeChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.favorite_rounded,
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
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _TypeChip(
                label: l10n.song,
                selected: currentType == 'songs',
                onTap: () => onTypeChanged('songs'),
              ),
              const SizedBox(width: 8),
              _TypeChip(
                label: l10n.album,
                selected: currentType == 'albums',
                onTap: () => onTypeChanged('albums'),
              ),
              const SizedBox(width: 8),
              _TypeChip(
                label: l10n.artist,
                selected: currentType == 'artists',
                onTap: () => onTypeChanged('artists'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.4,
              ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurfaceVariant,
            fontWeight: selected ? .bold : .normal,
          ),
        ),
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}
