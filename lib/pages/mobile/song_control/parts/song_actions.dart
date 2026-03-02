part of '../song_control.dart';

class _SongActions extends StatelessWidget {
  const _SongActions({
    required this.song,
    required this.onToggleFavorite,
    required this.onAddToPlaylist,
  });
  final SongEntity song;
  final void Function() onToggleFavorite;
  final void Function() onAddToPlaylist;

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
          padding: EdgeInsets.only(top: 4, bottom: 11),
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(
                width: 1,
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: AsyncValueBuilder(
            provider: appPlayerHandlerProvider,
            builder: (context, player, _) {
              return Row(
                mainAxisAlignment: .spaceAround,
                children: [
                  AsyncStreamBuilder(
                    provider: player.playingStream,
                    builder: (_, playing) {
                      final isCurrentPlaying = playing && isCurrent;
                      return Column(
                        mainAxisSize: .min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (isCurrentPlaying) {
                                player.pause();
                              } else if (isCurrent) {
                                player.play();
                              } else {
                                player.insertAndPlay(song);
                              }
                            },
                            icon: Icon(
                              isCurrentPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                            ),
                          ),
                          Text(
                            isCurrentPlaying
                                ? AppLocalizations.of(context)!.pause
                                : AppLocalizations.of(context)!.play,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      );
                    },
                  ),
                  // }),
                  Column(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        onPressed: onToggleFavorite,
                        icon: Icon(
                          isStarred ? Icons.favorite : Icons.favorite_outline,
                          color: isStarred ? Colors.red : null,
                        ),
                      ),
                      Text(
                        isStarred
                            ? AppLocalizations.of(context)!.unfavorite
                            : AppLocalizations.of(context)!.favorite,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  if (!isCurrent && !isNext)
                    Column(
                      mainAxisSize: .min,
                      children: [
                        IconButton(
                          onPressed: () {
                            player.insertToNext(song);
                          },
                          icon: const Icon(Icons.not_started_outlined),
                        ),
                        Text(
                          AppLocalizations.of(context)!.playNext,
                          style: TextStyle(fontSize: 12),
                          textAlign: .center,
                        ),
                      ],
                    ),
                  if (indexOfSong == -1)
                    Column(
                      mainAxisSize: .min,
                      children: [
                        IconButton(
                          onPressed: () {
                            player.insertToEnd(song);
                          },
                          icon: const Icon(Icons.playlist_add_outlined),
                        ),
                        Text(
                          AppLocalizations.of(context)!.addToPlayQueue,
                          style: TextStyle(fontSize: 12),
                          textAlign: .center,
                        ),
                      ],
                    ),
                  if (indexOfSong != -1 && !isCurrent)
                    Column(
                      mainAxisSize: .min,
                      children: [
                        IconButton(
                          onPressed: () {
                            player.removeQueueItemAt(indexOfSong);
                          },
                          icon: const Icon(Icons.playlist_remove_outlined),
                        ),
                        Text(
                          AppLocalizations.of(context)!.removeFromPlayQueue,
                          style: TextStyle(fontSize: 12),
                          textAlign: .center,
                        ),
                      ],
                    ),

                  Column(
                    mainAxisSize: .min,
                    children: [
                      IconButton(
                        onPressed: onAddToPlaylist,
                        icon: const Icon(Icons.library_add_check_outlined),
                      ),
                      Text(
                        AppLocalizations.of(context)!.addToPlaylist,
                        style: TextStyle(fontSize: 12),
                        textAlign: .center,
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
