part of '../playlist_detail_page.dart';

class _PlaylistDetailBuilder extends StatelessWidget {
  const _PlaylistDetailBuilder({required this.playlist});

  final PlaylistEntity playlist;

  void _onDeleteSong(int songIndexToRemove, WidgetRef ref) {
    final playlistId = playlist.id;
    if (playlistId == null) return;
    ref
        .read(playlistDetailProvider(playlistId).notifier)
        .modify(songIndexToRemove: songIndexToRemove);
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      loading: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      empty: (_, _) => const SliverToBoxAdapter(child: NoData()),
      builder: (context, player, _) {
        return PlayQueueBuilder(
          loadingBuilder: (ctx, _) =>
              const SliverToBoxAdapter(child: SizedBox.shrink()),
          builder: (context, playQueue, ref) {
            final currentSong = playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
            return AsyncStreamBuilder(
              provider: player.playingStream,
              loading: (_) => _buildList(
                context: context,
                ref: ref,
                player: player,
                currentSongId: currentSong?.id,
                isPlaying: false,
              ),
              builder: (_, playing) => _buildList(
                context: context,
                ref: ref,
                player: player,
                currentSongId: currentSong?.id,
                isPlaying: playing,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildList({
    required BuildContext context,
    required WidgetRef ref,
    required AppPlayer player,
    required String? currentSongId,
    required bool isPlaying,
  }) {
    final songs = playlist.entry;
    if (songs == null) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList.separated(
        separatorBuilder: (context, _) => const SizedBox(height: 4),
        itemCount: songs.length,
        itemBuilder: (_, idx) {
          final song = songs[idx];
          final isCurrentPlaying = currentSongId == song.id && isPlaying;

          return _SongTile(
            song: song,
            index: idx,
            isCurrentPlaying: isCurrentPlaying,
            onTap: () => player.playOrToggleFromSongTap(song),
            onDelete: () => _onDeleteSong(idx, ref),
            onMore: () => showSongControlSheet(context, song.id),
          );
        },
      ),
    );
  }
}

/// 歌曲列表项 - 卡片式设计
class _SongTile extends StatelessWidget {
  const _SongTile({
    required this.song,
    required this.index,
    required this.isCurrentPlaying,
    required this.onTap,
    required this.onDelete,
    required this.onMore,
  });

  final dynamic song;
  final int index;
  final bool isCurrentPlaying;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: isCurrentPlaying
          ? colorScheme.primaryContainer.withValues(alpha: 0.3)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              // 序号或播放指示器（斜体）
              SizedBox(
                width: 32,
                child: isCurrentPlaying
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: Image.asset(
                          'images/playing.gif',
                          color: colorScheme.primary,
                        ),
                      )
                    : Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
              const SizedBox(width: 10),
              // 歌曲封面
              Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorScheme.surfaceContainerHighest,
                ),
                child: ArtworkImage(
                  id: song.id,
                  size: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              // 歌曲信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title ?? l10n.unknownError,
                      style: TextStyle(
                        fontWeight: isCurrentPlaying
                            ? FontWeight.w700
                            : FontWeight.w500,
                        fontSize: 14,
                        color: isCurrentPlaying
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${song.artist ?? l10n.unknownError} · ${durationFormatter(song.duration)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // 操作按钮
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onDelete,
                    splashRadius: 20,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert_rounded,
                      size: 18,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: onMore,
                    splashRadius: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
