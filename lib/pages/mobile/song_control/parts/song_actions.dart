part of '../song_control.dart';

class _SongActions extends StatefulWidget {
  const _SongActions({
    required this.song,
    required this.onToggleFavorite,
    required this.onAddToPlaylist,
  });
  final SongEntity song;
  final void Function() onToggleFavorite;
  final void Function() onAddToPlaylist;

  @override
  State<_SongActions> createState() => _SongActionsState();
}

class _SongActionsState extends State<_SongActions> {
  bool _moreExpanded = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final song = widget.song;
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
                // Primary row: Play, Play Next (conditional), Favorite, More.
                final primary = <Widget>[
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
                  if (!isCurrent && !isNext)
                    _ActionButton(
                      icon: Icons.not_started_outlined,
                      label: l10n.playNext,
                      onPressed: () {
                        player.insertToNext(song);
                      },
                    ),
                  _ActionButton(
                    icon: isStarred
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    iconColor: isStarred ? theme.colorScheme.error : null,
                    label: isStarred ? l10n.unfavorite : l10n.favorite,
                    onPressed: widget.onToggleFavorite,
                  ),
                  _ActionButton(
                    icon: _moreExpanded
                        ? Icons.expand_less_rounded
                        : Icons.more_horiz_rounded,
                    label: l10n.moreActions,
                    onPressed: () {
                      setState(() => _moreExpanded = !_moreExpanded);
                    },
                  ),
                ];

                // Secondary row (expanded): queue / playlist / radio / similar.
                final secondary = <Widget>[
                  if (indexOfSong == -1)
                    _ActionButton(
                      icon: Icons.playlist_add_outlined,
                      label: l10n.addToPlayQueue,
                      onPressed: () {
                        player.insertToEnd(song);
                      },
                    ),
                  _ActionButton(
                    icon: Icons.library_add_check_outlined,
                    label: l10n.addToPlaylist,
                    onPressed: widget.onAddToPlaylist,
                  ),
                  _ActionButton(
                    icon: Icons.radio_outlined,
                    label: l10n.similarRadio,
                    onPressed: () => _startSimilarRadio(
                      context: context,
                      ref: ref,
                      player: player,
                      song: song,
                      l10n: l10n,
                    ),
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
                  if (indexOfSong != -1 && !isCurrent)
                    _ActionButton(
                      icon: Icons.playlist_remove_outlined,
                      label: l10n.removeFromPlayQueue,
                      onPressed: () {
                        player.removeQueueItemAt(indexOfSong);
                      },
                    ),
                ];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CenteredActionStrip(children: primary),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      child: _moreExpanded && secondary.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 4,
                                runSpacing: 4,
                                children: secondary,
                              ),
                            )
                          : const SizedBox(width: double.infinity, height: 0),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _startSimilarRadio({
    required BuildContext context,
    required WidgetRef ref,
    required AppPlayer player,
    required SongEntity song,
    required AppLocalizations l10n,
  }) async {
    final radioQueueNotifier = ref.read(radioQueueProvider.notifier);
    await radioQueueNotifier.startRadio(song);
    final radioQueue = ref.read(radioQueueProvider);

    // Check if seed song was not analyzed
    if (radioQueueNotifier.isSeedSongUnanalyzed) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.songNotAnalyzedForRadio),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

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
  }
}

class _CenteredActionStrip extends StatelessWidget {
  const _CenteredActionStrip({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = children.length * _actionButtonWidth;
        final hasBoundedWidth = constraints.maxWidth.isFinite;
        final contentFits =
            hasBoundedWidth && contentWidth <= constraints.maxWidth;
        final rowWidth = contentFits ? constraints.maxWidth : contentWidth;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: hasBoundedWidth ? rowWidth : null,
            child: Row(
              mainAxisSize: .min,
              mainAxisAlignment: contentFits ? .center : .start,
              crossAxisAlignment: .start,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

const double _actionButtonWidth = 60;

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
      width: _actionButtonWidth,
      child: Column(
        mainAxisSize: .min,
        children: [
          IconButton.filled(
            onPressed: onPressed,
            iconSize: 22,
            style: IconButton.styleFrom(
              minimumSize: const Size.square(44),
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
      width: _actionButtonWidth,
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
