part of '../folders_page.dart';

class _LeftPane extends ConsumerStatefulWidget {
  const _LeftPane();

  @override
  ConsumerState<_LeftPane> createState() => _LeftPaneState();
}

class _LeftPaneState extends ConsumerState<_LeftPane> {
  static const double _rowHeight = 40.0;

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _syncScroll(List<TreeDisplayNode> nodes) {
    if (!_scrollController.hasClients) {
      return;
    }

    final selected = ref.read(selectedFolderProvider);
    if (selected == null) {
      return;
    }

    final index = nodes.indexWhere((node) => node.id == selected.id);
    if (index == -1) {
      return;
    }

    final viewportHeight = _scrollController.position.viewportDimension;
    final targetOffset = (index * _rowHeight) - (viewportHeight * 0.2);
    final safeOffset = targetOffset.clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    _scrollController.animateTo(
      safeOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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
        final isCurrentlySelected =
            ref.read(selectedFolderProvider)?.id == entry.id;

        if (!isCurrentlySelected) {
          ref.read(selectedFolderProvider.notifier).navigateTo(
            entry,
            node.fullPath,
          );
          return;
        }

        if (entry.isDir) {
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
