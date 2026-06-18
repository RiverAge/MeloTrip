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
    final l10n = AppLocalizations.of(context)!;
    final isStarred = song.starred != null;
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final index = playQueue.index;
        final songs = playQueue.songs;
        final current = playQueue.index >= playQueue.songs.length
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
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AsyncStreamBuilder(
                      provider: player.playingStream,
                      builder: (_, playing) {
                        final isCurrentPlaying = playing && isCurrent;
                        return _ActionButton(
                          icon: Icon(
                            isCurrentPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                          ),
                          label: isCurrentPlaying ? l10n.pause : l10n.play,
                          onPressed: () {
                            if (isCurrentPlaying) {
                              player.pause();
                            } else if (isCurrent) {
                              player.play();
                            } else {
                              player.insertAndPlay(song);
                            }
                          },
                        );
                      },
                    ),
                    // Similar songs button
                    _ActionButton(
                      icon: const Icon(Icons.graphic_eq_outlined),
                      label: l10n.similarSongs,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SimilarSongsPage(
                              songId: song.id,
                              songTitle: song.title,
                            ),
                          ),
                        );
                      },
                    ),
                    // Similar Radio button
                    _ActionButton(
                      icon: const Icon(Icons.radio_outlined),
                      label: l10n.similarRadio,
                      onPressed: () async {
                        final radioQueueNotifier = ref.read(
                          radioQueueProvider.notifier,
                        );
                        await radioQueueNotifier.startRadio(song);
                        final radioQueue = ref.read(radioQueueProvider);
                        if (radioQueue.isNotEmpty) {
                          // Play the radio queue
                          await player.setPlaylist(
                            songs: radioQueue,
                            initialId: radioQueue.first.id,
                          );
                          await player.play();
                          if (context.mounted) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.radioPlaying),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.noSongsFoundForRadio),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          }
                        }
                      },
                    ),
                    _ActionButton(
                      icon: Icon(
                        isStarred ? Icons.favorite : Icons.favorite_outline,
                        color: isStarred
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                      label: isStarred ? l10n.unfavorite : l10n.favorite,
                      onPressed: onToggleFavorite,
                    ),
                    if (!isCurrent && !isNext)
                      _ActionButton(
                        icon: const Icon(Icons.not_started_outlined),
                        label: l10n.playNext,
                        onPressed: () {
                          player.insertToNext(song);
                        },
                      ),
                    if (indexOfSong == -1)
                      _ActionButton(
                        icon: const Icon(Icons.playlist_add_outlined),
                        label: l10n.addToPlayQueue,
                        onPressed: () {
                          player.insertToEnd(song);
                        },
                      ),
                    if (indexOfSong != -1 && !isCurrent)
                      _ActionButton(
                        icon: const Icon(Icons.playlist_remove_outlined),
                        label: l10n.removeFromPlayQueue,
                        onPressed: () {
                          player.removeQueueItemAt(indexOfSong);
                        },
                      ),
                    _ActionButton(
                      icon: const Icon(Icons.library_add_check_outlined),
                      label: l10n.addToPlaylist,
                      onPressed: onAddToPlaylist,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final Widget icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(onPressed: onPressed, icon: icon),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
