part of '../playlist_detail_page.dart';

class _PlaylistDetailBuilder extends StatelessWidget with SongControl {
  const _PlaylistDetailBuilder({required this.playlist});

  final PlaylistEntity playlist;
  _onPlay(SongEntity? song) async {
    if (song == null) return;
    final hanlder = await AppPlayerHandler.instance;
    final player = hanlder.player;
    await player.insertAndPlay(song);
  }

  _onDeleteSong(int songIndexToRemove, WidgetRef ref) async {
    final playlistId = playlist.id;
    if (playlistId == null) return;
    ref
        .read(playlistUpdateProvider.notifier)
        .modify(playlistId: playlistId, songIndexToRemove: songIndexToRemove);
  }

  @override
  Widget build(BuildContext context) {
    return SliverList.separated(
      separatorBuilder: (context, _) => const Divider(),
      itemCount: playlist.entry?.length,
      itemBuilder: (_, idx) {
        final song = playlist.entry?[idx];
        return PlayQueueBuilder(
          builder: (context, playQueue, ref) {
            final current =
                playQueue.index >= playQueue.songs.length
                    ? null
                    : playQueue.songs[playQueue.index];
            return ListTile(
              onTap: () => _onPlay(song),
              horizontalTitleGap: 2,
              selected: current?.id == song?.id,
              leading: Text(
                (idx + 1).toString(),
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Row(
                children: [
                  AsyncStreamBuilder(
                    provider: playingStreamProvider,
                    builder: (_, playing, __) {
                      return current?.id == song?.id && playing
                          ? SizedBox(
                            width: 30,
                            child: Image.asset(
                              'images/playing.gif',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                          : const SizedBox.shrink();
                    },
                  ),
                  Expanded(child: Text(song?.title ?? '')),
                ],
              ),
              subtitle: Text(
                '${song?.artist} ${durationFormatter(song?.duration)}',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
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
      },
    );
  }
}
