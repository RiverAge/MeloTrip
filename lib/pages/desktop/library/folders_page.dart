import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/folder/folders.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/helper/index.dart';

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

class _LeftPane extends ConsumerStatefulWidget {
  const _LeftPane();

  @override
  ConsumerState<_LeftPane> createState() => _LeftPaneState();
}

class _LeftPaneState extends ConsumerState<_LeftPane> {
  final ScrollController _scrollController = ScrollController();
  static const double _rowHeight = 40.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncScroll(List<TreeDisplayNode> nodes) {
    if (!_scrollController.hasClients) return; // 守卫：确保控制器已附着
    final selected = ref.read(selectedFolderProvider);
    if (selected == null) return;

    final index = nodes.indexWhere((node) => node.id == selected.id);
    if (index != -1) {
      final viewportHeight = _scrollController.position.viewportDimension;
      final targetOffset = (index * _rowHeight) - (viewportHeight * 0.2);
      final safeOffset = targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent);
      
      _scrollController.animateTo(
        safeOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final flattenedTree = ref.watch(flattenedTreeProvider);

    ref.listen(flattenedTreeProvider, (prev, next) {
      next.whenData(_syncScroll);
    });

    return flattenedTree.when(
      data: (nodes) => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: nodes.length,
        itemExtent: _rowHeight,
        itemBuilder: (context, index) {
          return _TreeRow(node: nodes[index]);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => const SizedBox(),
    );
  }
}

class _TreeRow extends ConsumerWidget {
  const _TreeRow({required this.node});
  final TreeDisplayNode node;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isSelected = ref.watch(selectedFolderProvider)?.id == node.id;
    final entry = node.entry;

    return InkWell(
      onTap: () {
        final isCurrentlySelected = ref.read(selectedFolderProvider)?.id == entry.id;
        
        if (!isCurrentlySelected) {
          // 1. 如果未选中，执行全量导航（Navigate），内部会自动 add 到展开列表，并同步面包屑
          ref.read(selectedFolderProvider.notifier).navigateTo(entry, node.fullPath);
        } else if (entry.isDir) {
           // 2. 如果已选中且是目录，执行切换（Toggle）。此时不再会有后台异步 add 干扰。
           ref.read(expandedFolderIdsProvider.notifier).toggle(entry.id);
        }
      },
      child: Container(
        color: isSelected ? theme.colorScheme.surfaceContainerHighest : null,
        padding: EdgeInsets.fromLTRB(16.0 + (node.depth * 16.0), 0, 16, 0),
        height: _LeftPaneState._rowHeight,
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
            if (node.isLoading)
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else if (entry.isDir)
              Icon(
                node.isExpanded
                    ? Icons.keyboard_arrow_down_rounded
                    : Icons.keyboard_arrow_right_rounded,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
          ],
        ),
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
                  mainAxisSize: .min,
                  children: [
                    Icon(Icons.home_rounded, 
                      size: 18, 
                      color: path.isEmpty ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant
                    ),
                    const SizedBox(width: 8),
                    // 将“现在就听”改为“主页”
                    Text(l10n.home, style: style?.copyWith(
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
                  ref.read(selectedFolderProvider.notifier).navigateTo(entry, path.sublist(0, i + 1));
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
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final Widget row = _FolderEntryRow(
                index: index + 1,
                entry: entries[index],
                allEntries: entries,
              );
              return row;
            },
          ),
        ),
      ],
    );
  }
}

class _FolderEntryRow extends ConsumerStatefulWidget {
  const _FolderEntryRow({
    required this.index,
    required this.entry,
    required this.allEntries,
  });

  final int index;
  final FolderIndexEntry entry;
  final List<FolderIndexEntry> allEntries;

  @override
  ConsumerState<_FolderEntryRow> createState() => _FolderEntryRowState();
}

class _FolderEntryRowState extends ConsumerState<_FolderEntryRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () async {
          if (entry.isDir) {
            final currentPath = ref.read(folderPathProvider);
            final newPath = [...currentPath, entry];
            ref.read(selectedFolderProvider.notifier).navigateTo(entry, newPath);
          }
          // 全行点击不再触发歌曲播放
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            children: [
              SizedBox(
                width: 30,
                child: Text(
                  '${widget.index}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Row(
                  children: [
                    if (entry.isDir)
                      Icon(
                        Icons.folder_rounded,
                        color: theme.colorScheme.secondary.withValues(alpha: .85),
                        size: 20,
                      )
                    else
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: ArtworkImage(
                              id: entry.coverArt,
                              width: 40,
                              height: 40,
                              size: 100,
                            ),
                          ),
                          if (_isHovered)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.scrim.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.play_arrow_rounded,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    onPressed: () async {
                                      final songs = widget.allEntries
                                          .where((e) => !e.isDir)
                                          .map((e) => e.toSong())
                                          .toList();
                                      final player = await ref.read(appPlayerHandlerProvider.future);
                                      if (player != null) {
                                        await player.setPlaylist(songs: songs, initialId: entry.id);
                                        await player.play();
                                      }
                                    },
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: .min,
                        children: [
                          Text(
                            entry.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (!entry.isDir && entry.artist != null)
                            Text(
                              entry.artist!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 11,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12), // 间距微调
              SizedBox(
                width: 60,
                child: Text(
                  durationFormatter(entry.duration),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  entry.album ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  entry.genre ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              SizedBox(
                width: 60,
                child: Text(
                  entry.year?.toString() ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
      ),
    );
  }
}
