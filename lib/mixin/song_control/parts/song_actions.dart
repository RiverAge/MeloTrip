part of '../song_control.dart';

class _SongActions extends StatelessWidget {
  const _SongActions({required this.song, required this.onToggleFavorite});
  final SongEntity song;
  final void Function() onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final isStarred = song.starred != null;
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final index = playQueue.index;
        final songs = playQueue.songs;
        final current =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];

        final isCurrent = current?.id == song.id;
        final isNext =
            ((index + 1) < songs.length) && songs[index + 1].id == song.id;

        final indexOfSong = songs.indexWhere((e) => e.id == song.id);

        return Container(
          padding: EdgeInsets.only(bottom: 11),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AsyncStreamBuilder(
                provider: playingStreamProvider,
                builder: (_, playing, __) {
                  final isCurrentPlaying = playing && isCurrent;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final handler = await AppPlayerHandler.instance;
                          final player = handler.player;
                          if (isCurrentPlaying) {
                            await player.pause();
                          } else if (isCurrent) {
                            await player.play();
                          } else {
                            await player.insertAndPlay(song);
                          }
                        },
                        icon: Icon(
                          isCurrentPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                      ),
                      Text(
                        isCurrentPlaying ? '暂停' : '播放',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  );
                },
              ),
              // }),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isStarred ? Icons.favorite : Icons.favorite_outline,
                      color: isStarred ? Colors.red : null,
                    ),
                  ),
                  Text(
                    isStarred ? '取消收藏' : '收藏',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              if (!isCurrent && !isNext)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final handler = await AppPlayerHandler.instance;
                        final player = handler.player;
                        player.insertToNext(song);
                      },
                      icon: const Icon(Icons.not_started_outlined),
                    ),
                    const Text(
                      '下一首播放',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              if (indexOfSong == -1)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final handler = await AppPlayerHandler.instance;
                        final player = handler.player;
                        player.insertToEnd(song);
                      },
                      icon: const Icon(Icons.playlist_add_outlined),
                    ),
                    const Text(
                      '加至播放列表',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              if (indexOfSong != -1 && !isCurrent)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final handler = await AppPlayerHandler.instance;
                        final player = handler.player;
                        player.removeQueueItemAt(indexOfSong);
                      },
                      icon: const Icon(Icons.playlist_remove_outlined),
                    ),
                    const Text(
                      '移出播放列表',
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddToPlaylistPage(song: song),
                        ),
                      );
                    },
                    icon: const Icon(Icons.library_add_check_outlined),
                  ),
                  const Text(
                    '加至歌单',
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
