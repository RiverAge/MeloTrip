import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/folder/folders.dart';
import 'package:melo_trip/repository/folder/folders_repository.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

final _treeItemKeys = <String, GlobalKey>{};

class DesktopFoldersPage extends ConsumerWidget {
  const DesktopFoldersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PageHeader(l10n: l10n),
          const Divider(height: 1),
          const Expanded(
            child: Row(
              children: [
                SizedBox(width: 280, child: _LeftPane()),
                VerticalDivider(width: 1),
                Expanded(child: _RightPane()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        children: [
          Text(
            l10n.folder,
            style: theme.textTheme.headlineSmall?.copyWith(
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
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
            style: IconButton.styleFrom(
              visualDensity: VisualDensity.compact,
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftPane extends ConsumerStatefulWidget {
  const _LeftPane();

  @override
  ConsumerState<_LeftPane> createState() => _LeftPaneState();
}

class _LeftPaneState extends ConsumerState<_LeftPane> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(selectedFolderProvider, (prev, next) {
      if (next != null) {
        Future.delayed(const Duration(milliseconds: 100), () {
          final key = _treeItemKeys[next.id];
          if (key?.currentContext != null) {
            Scrollable.ensureVisible(
              key!.currentContext!,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: 0.3,
            );
          }
        });
      }
    });

    final indexes = ref.watch(folderIndexesProvider);
    return indexes.when(
      data: (data) => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _TreeItem(entry: data[index], depth: 0);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox(),
    );
  }
}

class _TreeItem extends ConsumerWidget {
  _TreeItem({required this.entry, required this.depth})
      : super(key: _treeItemKeys.putIfAbsent(entry.id, () => GlobalKey()));

  final FolderIndexEntry entry;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isExpanded = ref.watch(expandedFolderIdsProvider).contains(entry.id);
    final isSelected = ref.watch(selectedFolderProvider)?.id == entry.id;

    return Column(
      children: [
        InkWell(
          onTap: () {
            ref.read(selectedFolderProvider.notifier).set(entry);
            if (entry.isDir) {
              ref.read(expandedFolderIdsProvider.notifier).toggle(entry.id);
            }
            ref.read(folderPathProvider.notifier).set([entry]);
          },
          child: Container(
            color: isSelected ? theme.colorScheme.surfaceContainerHighest : null,
            padding: EdgeInsets.fromLTRB(16.0 + (depth * 16.0), 8, 16, 8),
            child: Row(
              children: [
                Icon(
                  entry.isDir ? Icons.folder_rounded : Icons.music_note_rounded,
                  size: 18,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary.withValues(alpha: .8),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: isSelected ? FontWeight.bold : null,
                    ),
                  ),
                ),
                if (entry.isDir)
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down_rounded
                        : Icons.keyboard_arrow_right_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
        if (isExpanded && entry.isDir)
          _ChildFolders(parentId: entry.id, depth: depth + 1),
      ],
    );
  }
}

class _ChildFolders extends ConsumerWidget {
  const _ChildFolders({required this.parentId, required this.depth});
  final String parentId;
  final int depth;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(foldersRepositoryProvider);
    return FutureBuilder<List<FolderIndexEntry>>(
      future: repository.fetchMusicDirectory(parentId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();
        final children = snapshot.data!.where((e) => e.isDir).toList();
        return Column(
          children: children
              .map((e) => _TreeItem(entry: e, depth: depth))
              .toList(),
        );
      },
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    Icon(Icons.home_rounded, 
                      size: 18, 
                      color: path.isEmpty ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant
                    ),
                    const SizedBox(width: 8),
                    Text(l10n.listenNow, style: style?.copyWith(
                      fontWeight: path.isEmpty ? FontWeight.bold : FontWeight.normal,
                      color: path.isEmpty ? theme.colorScheme.onSurface : null,
                    )),
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
                  ref.read(selectedFolderProvider.notifier).set(entry);
                  ref.read(folderPathProvider.notifier).set(path.sublist(0, i + 1));
                  for (final p in path.sublist(0, i + 1)) {
                    ref.read(expandedFolderIdsProvider.notifier).add(p.id);
                  }
                },
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  child: Text(
                    path[i].name,
                    style: style?.copyWith(
                      fontWeight: i == path.length - 1 ? FontWeight.bold : null,
                      color: i == path.length - 1 ? theme.colorScheme.onSurface : null,
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

class _FolderTable extends StatelessWidget {
  const _FolderTable({required this.entries, required this.l10n});
  final List<FolderIndexEntry> entries;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: .7);
    final headerStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ).copyWith(color: headerColor);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 12),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              SizedBox(
                width: 60,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: headerColor,
                ),
              ),
              Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
              Expanded(
                flex: 2,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              SizedBox(
                width: 60,
                child: Text(l10n.songMetaYear, style: headerStyle),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return _FolderRow(index: index + 1, entry: entries[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _FolderRow extends ConsumerWidget {
  const _FolderRow({required this.index, required this.entry});
  final int index;
  final FolderIndexEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {
        if (entry.isDir) {
          ref.read(selectedFolderProvider.notifier).set(entry);
          final currentPath = ref.read(folderPathProvider);
          final newPath = [...currentPath, entry];
          ref.read(folderPathProvider.notifier).set(newPath);
          for (final p in newPath) {
            ref.read(expandedFolderIdsProvider.notifier).add(p.id);
          }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  Icon(
                    entry.isDir ? Icons.folder_rounded : Icons.music_note_rounded,
                    color: theme.colorScheme.secondary.withValues(alpha: .85),
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 60),
            const Expanded(flex: 3, child: SizedBox()),
            const Expanded(flex: 2, child: SizedBox()),
            const SizedBox(width: 60),
            const SizedBox(width: 30),
          ],
        ),
      ),
    );
  }
}
