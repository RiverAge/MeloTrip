part of '../playing_page.dart';

class _MusicControls extends StatelessWidget {
  const _MusicControls();

  SnackBar _buildSnack(BuildContext context, String text, Size size) {
    final padding = (size.width - 100) / 2;
    final bottom = (size.height - 50) / 2;
    return SnackBar(
      elevation: 0,
      content: Text(
        text,
        textAlign: .center,
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
      ),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: bottom, left: padding, right: padding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      duration: const Duration(seconds: 2),
      backgroundColor: Theme.of(
        context,
      ).colorScheme.scrim.withValues(alpha: 178 / 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return PlayQueueBuilder(
          builder: (context, playQueue, ref) {
            final current = playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
            return Row(
              mainAxisAlignment: .center,
              children: [
                AsyncValueBuilder(
                  provider: lyricsProvider(current?.id),
                  loading: (_, _) => const SizedBox.shrink(),
                  builder: (_, lyricsResult, _) {
                    if (lyricsResult.isErr) {
                      return const SizedBox.shrink();
                    }
                    final structuredLyrics =
                        lyricsResult
                            .data
                            ?.subsonicResponse
                            ?.lyricsList
                            ?.structuredLyrics ??
                        [];
                    if (structuredLyrics.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final sourceLabel = switch (structuredLyrics.first.lang) {
                      'NetEase' => 'NETEASE',
                      'AM' => 'APPLE',
                      _ => 'DEFAULT',
                    };
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.5, color: color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        l10n.lyricsSource(sourceLabel),
                        style: TextStyle(
                          height: 1.0,
                          fontSize: 12,
                          fontWeight: .bold,
                          color: color,
                        ),
                        textHeightBehavior: const TextHeightBehavior(
                          applyHeightToFirstAscent: false,
                          applyHeightToLastDescent: false,
                          leadingDistribution: TextLeadingDistribution.even,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    final messenger = ScaffoldMessenger.of(context);
                    final size = MediaQuery.sizeOf(context);
                    final playModeNoneText = l10n.playModeNone;
                    final playModeLoopText = l10n.playModeLoop;
                    final playModeSingleText = l10n.playModeSingle;
                    if (player.playlistMode == .loop) {
                      player.setPlaylistMode(.none);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(context, playModeNoneText, size),
                      );
                    } else if (player.playlistMode == .none) {
                      player.setPlaylistMode(.single);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(context, playModeSingleText, size),
                      );
                    } else if (player.playlistMode == .single) {
                      player.setPlaylistMode(.loop);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(context, playModeLoopText, size),
                      );
                    }
                  },
                  icon: AsyncStreamBuilder(
                    provider: player.playlistModeStream,
                    builder: (_, playlistMode) {
                      return Icon(switch (playlistMode) {
                        .none => Icons.queue_music_outlined,
                        .loop => Icons.repeat,
                        .single => Icons.repeat_one,
                      });
                    },
                  ),
                ),
                const SizedBox(width: 30),
                // Similar Radio button
                IconButton(
                  onPressed: current != null
                      ? () async {
                          final radioQueueNotifier = ref.read(
                            radioQueueProvider.notifier,
                          );
                          await radioQueueNotifier.startRadio(current);
                          final radioQueue = ref.read(radioQueueProvider);
                          if (radioQueue.isNotEmpty) {
                            await player.setPlaylist(
                              songs: radioQueue,
                              initialId: radioQueue.first.id,
                            );
                            await player.play();
                            if (context.mounted) {
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
                      : null,
                  icon: const Icon(Icons.radio_outlined),
                  tooltip: l10n.similarRadio,
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => AddToPlaylistPage(song: current),
                    ),
                  ),
                  icon: const Icon(Icons.playlist_add),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => showSongControlSheet(context, current?.id),
                  icon: const Icon(Icons.more_horiz_rounded),
                  iconSize: 30,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
