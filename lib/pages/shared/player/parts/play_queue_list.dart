part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

class _PlayQueueListView extends ConsumerStatefulWidget {
  const _PlayQueueListView({
    required this.playQueue,
    required this.player,
    required this.variant,
    required this.closeOnSelection,
  });

  final PlayQueue playQueue;
  final AppPlayer player;
  final PlayQueuePanelVariant variant;
  final bool closeOnSelection;

  @override
  ConsumerState<_PlayQueueListView> createState() => _PlayQueueListViewState();
}

class _PlayQueueListViewState extends ConsumerState<_PlayQueueListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToCurrentSong());
  }

  void _jumpToCurrentSong() {
    if (!_scrollController.hasClients) {
      return;
    }
    final offset = computePlayQueueJumpOffset(
      index: widget.playQueue.index,
      songCount: widget.playQueue.songs.length,
      maxScrollExtent: _scrollController.position.maxScrollExtent,
    );
    if (offset != null) {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
      provider: widget.player.playingStream,
      loading: (_) => _buildListView(playing: false),
      builder: (_, playing) => _buildListView(playing: playing),
    );
  }

  Widget _buildListView({required bool playing}) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        widget.variant == PlayQueuePanelVariant.desktop ? 12 : 8,
        10,
        widget.variant == PlayQueuePanelVariant.desktop ? 12 : 8,
        12,
      ),
      itemExtent: 72,
      itemCount: widget.playQueue.songs.length,
      itemBuilder: (context, index) {
        return _PlayQueueListItem(
          player: widget.player,
          songs: widget.playQueue.songs,
          currentPlayingIndex: widget.playQueue.index,
          index: index,
          isCurrentPlaying: playing && widget.playQueue.index == index,
          variant: widget.variant,
          closeOnSelection: widget.closeOnSelection,
        );
      },
    );
  }
}

class _PlayQueueListItem extends StatelessWidget {
  const _PlayQueueListItem({
    required this.player,
    required this.songs,
    required this.currentPlayingIndex,
    required this.index,
    required this.isCurrentPlaying,
    required this.variant,
    required this.closeOnSelection,
  });

  final AppPlayer player;
  final List<SongEntity> songs;
  final int currentPlayingIndex;
  final int index;
  final bool isCurrentPlaying;
  final PlayQueuePanelVariant variant;
  final bool closeOnSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentSong = songs[index];
    final isCurrent = currentPlayingIndex == index;
    final artist = (currentSong.displayArtist ?? currentSong.artist ?? '').trim();
    final album = (currentSong.album ?? '').trim();
    final subtitle = [artist, album].where((it) => it.isNotEmpty).join(' - ');
    final tile = ListTile(
      onTap: () {
        if (isCurrent) {
          player.playOrPause();
        } else {
          player.skipToQueueItem(index);
        }
        if (closeOnSelection) {
          Navigator.of(context).pop();
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Row(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              (index + 1).toString(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCurrent
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isCurrent ? .w700 : .w500,
                fontStyle: .italic,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: isCurrentPlaying ? 26 : 0,
              height: isCurrentPlaying ? 26 : 0,
              child: isCurrentPlaying
                  ? Image.asset(
                      'images/playing.gif',
                      color: colorScheme.primary,
                    )
                  : null,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: .antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: ArtworkImage(id: currentSong.id, size: 96, fit: .cover),
          ),
        ],
      ),
      title: Text(
        currentSong.title ?? '-',
        overflow: .ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isCurrent ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isCurrent ? .w700 : .w500,
        ),
      ),
      subtitle: Text(
        subtitle.isEmpty ? '-' : subtitle,
        overflow: .ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isCurrent
              ? colorScheme.primary.withValues(alpha: 0.82)
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
        ),
      ),
      trailing: IconButton(
        tooltip: AppLocalizations.of(context)!.removeFromPlayQueue,
        icon: const Icon(Icons.playlist_remove_rounded),
        onPressed: () => player.removeQueueItemAt(index),
      ),
    );

    if (variant == PlayQueuePanelVariant.mobile) {
      return tile;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primary.withValues(alpha: 0.08)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withValues(alpha: 0.28)
                : colorScheme.outlineVariant.withValues(alpha: 0.18),
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: tile,
      ),
    );
  }
}
