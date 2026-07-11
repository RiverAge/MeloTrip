part of '../playlist_detail_page.dart';

class _PlaylistDetailBuilder extends StatelessWidget {
  const _PlaylistDetailBuilder({required this.playlist});

  final PlaylistEntity playlist;

  void _onDeleteSong(int songIndexToRemove, WidgetRef ref) {
    final playlistId = playlist.id;
    if (playlistId == null) return;
    ref
        .read(playlistDetailProvider(playlistId).notifier)
        .modify(
          songIndexToRemove: songIndexToRemove,
        );
  }

  @override
  Widget build(BuildContext context) {
    // 本 builder 在 [CustomScrollView] 的 slivers 列表里直接作为一员，故
    // 每条返回路径都必须是 Sliver（否则 RenderViewport 会因收到 RenderBox
    // 子节点抛 "expected a child of type RenderSliver"）。数据路径直接返回
    // [_buildList] 里的 [SliverList]（不要包 SliverToBoxAdapter——SliverList
    // 本身就是 RenderSliver）；仅 loading / error 这类 Box 状态才包成
    // SliverToBoxAdapter 以满足 viewport 类型约束。
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      loading: (_, _) => const SliverToBoxAdapter(child: SizedBox.shrink()),
      // player 未就绪（data == null）时 AsyncValueBuilder 默认返回 NoData
      // （RenderBox）。本 builder 在 slivers 列表里，故同样包成 Sliver。
      empty: (_, _) => const SliverToBoxAdapter(child: NoData()),
      builder: (context, player, _) {
        return PlayQueueBuilder(
          // playQueueStream 首帧（waiting）时回到这里。本 builder 在
          // slivers 列表里，故占位也必须是 Sliver：包成空的
          // SliverToBoxAdapter，避免把 RenderBox 塞进 viewport。
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
    return SliverList.separated(
      separatorBuilder: (context, _) => const Divider(),
      itemCount: playlist.entry?.length,
      itemBuilder: (_, idx) {
        final song = playlist.entry?[idx];
        final isCurrentPlaying = currentSongId == song?.id && isPlaying;
        return ListTile(
          onTap: () {
            if (song == null) return;
            player.playOrToggleFromSongTap(song);
          },
          horizontalTitleGap: 2,
          selected: isCurrentPlaying,
          leading: Row(
            mainAxisSize: .min,
            children: [
              Text(
                (idx + 1).toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: .italic,
                  fontWeight: .bold,
                ),
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                clipBehavior: .antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ArtworkImage(id: song?.id),
              ),
            ],
          ),
          title: Row(
            children: [
              isCurrentPlaying
                  ? SizedBox(
                      width: 30,
                      child: Image.asset(
                        'images/playing.gif',
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : const SizedBox.shrink(),
              Expanded(child: Text(song?.title ?? '')),
            ],
          ),
          subtitle: Text(
            '${song?.artist} ${durationFormatter(song?.duration)}',
          ),
          trailing: Row(
            mainAxisSize: .min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline_outlined),
                onPressed: () => _onDeleteSong(idx, ref),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz_rounded),
                onPressed: () => showSongControlSheet(context, song?.id),
              ),
            ],
          ),
        );
      },
    );
  }
}


