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
    final theme = Theme.of(context);
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

        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: AsyncValueBuilder(
              provider: appPlayerHandlerProvider,
              builder: (context, player, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    crossAxisAlignment: .start,
                    children: [
                      AsyncStreamBuilder(
                        provider: player.playingStream,
                        builder: (_, playing) {
                          final isCurrentPlaying = playing && isCurrent;
                          return _PrimaryActionButton(
                            icon: isCurrentPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
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
                      _ActionButton(
                        icon: Icons.graphic_eq_outlined,
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
                      _ActionButton(
                        icon: Icons.radio_outlined,
                        label: l10n.similarRadio,
                        onPressed: () async {
                          final radioQueueNotifier = ref.read(
                            radioQueueProvider.notifier,
                          );
                          await radioQueueNotifier.startRadio(song);
                          final radioQueue = ref.read(radioQueueProvider);
                          if (radioQueue.isNotEmpty) {
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
                        icon: isStarred
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        iconColor: isStarred ? theme.colorScheme.error : null,
                        label: isStarred ? l10n.unfavorite : l10n.favorite,
                        onPressed: onToggleFavorite,
                      ),
                      if (!isCurrent && !isNext)
                        _ActionButton(
                          icon: Icons.not_started_outlined,
                          label: l10n.playNext,
                          onPressed: () {
                            player.insertToNext(song);
                          },
                        ),
                      if (indexOfSong == -1)
                        _ActionButton(
                          icon: Icons.playlist_add_outlined,
                          label: l10n.addToPlayQueue,
                          onPressed: () {
                            player.insertToEnd(song);
                          },
                        ),
                      if (indexOfSong != -1 && !isCurrent)
                        _ActionButton(
                          icon: Icons.playlist_remove_outlined,
                          label: l10n.removeFromPlayQueue,
                          onPressed: () {
                            player.removeQueueItemAt(indexOfSong);
                          },
                        ),
                      _ActionButton(
                        icon: Icons.library_add_check_outlined,
                        label: l10n.addToPlaylist,
                        onPressed: onAddToPlaylist,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _PrimaryActionButton extends StatelessWidget {
  const _PrimaryActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 60,
      child: Column(
        mainAxisSize: .min,
        children: [
          IconButton.filled(
            onPressed: onPressed,
            iconSize: 28,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(52),
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
            ),
            icon: Icon(icon),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return SizedBox(
      width: 60,
      child: Column(
        mainAxisSize: .min,
        children: [
          IconButton.filledTonal(
            onPressed: onPressed,
            iconSize: 22,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(44),
              backgroundColor: colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.58,
              ),
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            icon: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}
