part of '../folders_page.dart';

class _PageHeader extends ConsumerWidget {
  const _PageHeader({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final count = ref.watch(folderIndexesProvider).maybeWhen(
      data: (data) => data.length,
      orElse: () => 0,
    );

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
              Icons.folder_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            l10n.folder,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _RightPane extends ConsumerWidget {
  const _RightPane();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final path = ref.watch(folderPathProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Breadcrumbs(path: path, l10n: l10n),
        const Divider(height: 1),
        Expanded(
          child: AsyncValueBuilder(
            provider: folderContentsProvider,
            loading: (_, _) => const SizedBox(),
            builder: (context, data, _) {
              return _FolderTable(entries: data, l10n: l10n);
            },
          ),
        ),
      ],
    );
  }
}

class _Breadcrumbs extends ConsumerWidget {
  const _Breadcrumbs({required this.path, required this.l10n});

  final List<FolderIndexEntry> path;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final style = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 13,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ref.read(selectedFolderProvider.notifier).set(null);
                ref.read(folderPathProvider.notifier).set([]);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      size: 18,
                      color: path.isEmpty
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.home,
                      style: style?.copyWith(
                        fontWeight: path.isEmpty
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: path.isEmpty
                            ? theme.colorScheme.onSurface
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          for (int i = 0; i < path.length; i++) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  final entry = path[i];
                  ref.read(
                    selectedFolderProvider.notifier,
                  ).navigateTo(entry, path.sublist(0, i + 1));
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    path[i].name,
                    style: style?.copyWith(
                      fontWeight: i == path.length - 1
                          ? FontWeight.bold
                          : null,
                      color: i == path.length - 1
                          ? theme.colorScheme.onSurface
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
