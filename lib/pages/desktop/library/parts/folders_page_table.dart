part of '../folders_page.dart';

class _FolderTable extends StatelessWidget {
  const _FolderTable({required this.entries, required this.l10n});

  final List<FolderIndexEntry> entries;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: .7,
    );
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
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text('#', style: headerStyle),
                  ),
                ),
              ),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 72),
                    child: Icon(
                      Icons.access_time_rounded,
                      size: 14,
                      color: headerColor,
                    ),
                  ),
                ),
              ),
              Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
              Expanded(
                flex: 2,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 72),
                    child: Text(
                      l10n.songMetaYear,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: headerStyle,
                    ),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
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
              return _FolderEntryRow(
                index: index + 1,
                entry: entries[index],
                allEntries: entries,
              );
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

  Future<void> _playEntry(FolderIndexEntry entry) async {
    final songs = widget.allEntries
        .where((e) => !e.isDir)
        .map((e) => e.toSong())
        .toList();
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return;
    }

    await player.setPlaylist(songs: songs, initialId: entry.id);
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entry = widget.entry;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () async {
          if (!entry.isDir) {
            return;
          }

          final currentPath = ref.read(folderPathProvider);
          final newPath = [...currentPath, entry];
          ref.read(selectedFolderProvider.notifier).navigateTo(entry, newPath);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 40),
                    child: Text(
                      '${widget.index}',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
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
                        color: theme.colorScheme.secondary.withValues(
                          alpha: .85,
                        ),
                        size: 20,
                      )
                    else
                      _FolderEntryArtwork(
                        entry: entry,
                        isHovered: _isHovered,
                        onPlayPressed: () => _playEntry(entry),
                      ),
                    const SizedBox(width: 12),
                    Expanded(child: _FolderEntryTitle(entry: entry)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 72),
                    child: Text(
                      durationFormatter(entry.duration),
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  entry.album ?? '',
                  maxLines: 1,
                  overflow: .ellipsis,
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
                  overflow: .ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: .centerLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 72),
                    child: Text(
                      entry.year?.toString() ?? '',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox.square(dimension: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderEntryArtwork extends StatelessWidget {
  const _FolderEntryArtwork({
    required this.entry,
    required this.isHovered,
    required this.onPlayPressed,
  });

  final FolderIndexEntry entry;
  final bool isHovered;
  final VoidCallback onPlayPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
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
        if (isHovered)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.scrim.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.play_arrow_rounded,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: onPlayPressed,
                  style: IconButton.styleFrom(
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _FolderEntryTitle extends StatelessWidget {
  const _FolderEntryTitle({required this.entry});

  final FolderIndexEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          entry.name,
          maxLines: 1,
          overflow: .ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (!entry.isDir && entry.artist != null)
          Text(
            entry.artist!,
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 11,
            ),
          ),
      ],
    );
  }
}
