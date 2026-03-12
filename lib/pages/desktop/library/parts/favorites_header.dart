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
      child: Row(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: onTypeChanged,
                    itemBuilder: (context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(value: 'songs', child: Text(l10n.song)),
                      PopupMenuItem(value: 'albums', child: Text(l10n.album)),
                      PopupMenuItem(value: 'artists', child: Text(l10n.artist)),
                    ],
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Text(
                currentType == 'songs'
                    ? l10n.song
                    : currentType == 'albums'
                    ? l10n.album
                    : l10n.artist,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: <Widget>[
          _ToolbarButton(label: l10n.name, icon: Icons.sort_by_alpha_rounded),
          const SizedBox(width: 16),
          const _ToolbarIcon(icon: Icons.refresh_rounded),
          const Spacer(),
          const _ToolbarIcon(icon: Icons.grid_view_rounded),
        ],
      ),
    );
  }
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: .3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(width: 8),
          Icon(icon, size: 16),
        ],
      ),
    );
  }
}

class _ToolbarIcon extends StatelessWidget {
  const _ToolbarIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant);
  }
}
