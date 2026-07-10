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
        // 背景恒为 scrim（纯黑半透明，不随明暗/主题色变化），故文字固定用
        // 浅色，而非跟随主题色的 onPrimary——否则深色主题下亮 seed 会让
        // onPrimary 变深，深字黑底对比塌掉、发灰难读。
        style: TextStyle(color: Colors.white.withValues(alpha: 222 / 255)),
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
