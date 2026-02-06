part of '../playing_page.dart';

class _MusicControls extends StatelessWidget with SongControl {
  const _MusicControls();

  SnackBar _buildSnack(String text, Size size) {
    // return SnackBar(
    //   content: Text(text),
    //   behavior: SnackBarBehavior.floating,
    //   margin: EdgeInsets.only(bottom: 205, left: 10, right: 10),
    // );
    final padding = (size.width - 100) / 2;
    final bottom = (size.height - 50) / 2;
    return SnackBar(
      elevation: 0,
      content: Text(
        text,
        textAlign: TextAlign.center, // 文字居中
        style: const TextStyle(color: Colors.white),
      ),
      behavior: SnackBarBehavior.floating, // 设置为悬浮模式
      margin: EdgeInsets.only(bottom: bottom, left: padding, right: padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25), // 圆角，做成胶囊形状
      ),
      duration: const Duration(seconds: 2), // 停留时间
      backgroundColor: Colors.black87.withAlpha(178), // 半透明背景
      // content: Text(playModeNoneText),
      // behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(
      //   bottom: height - 250,
      //   left: 10,
      //   right: 10,
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current = playQueue.index >= playQueue.songs.length
            ? null
            : playQueue.songs[playQueue.index];
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AsyncValueBuilder(
              provider: appPlayerHandlerProvider,
              builder: (context, player, ref) {
                final size = MediaQuery.of(context).size;
                return IconButton(
                  color: Theme.of(context).colorScheme.primary.withAlpha(127),
                  onPressed: () {
                    final messenger = ScaffoldMessenger.of(context);
                    final playModeNoneText = AppLocalizations.of(
                      context,
                    )!.playModeNone;
                    final playModeLoopText = AppLocalizations.of(
                      context,
                    )!.playModeLoop;
                    final playModeSingleText = AppLocalizations.of(
                      context,
                    )!.playModeSingle;
                    if (player.playlistMode == PlaylistMode.loop) {
                      player.setPlaylistMode(PlaylistMode.none);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(playModeNoneText, size),
                      );
                    } else if (player.playlistMode == PlaylistMode.none) {
                      player.setPlaylistMode(PlaylistMode.single);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(playModeSingleText, size),
                      );
                    } else if (player.playlistMode == PlaylistMode.single) {
                      player.setPlaylistMode(PlaylistMode.loop);
                      messenger.clearSnackBars();
                      messenger.showSnackBar(
                        _buildSnack(playModeLoopText, size),
                      );
                    }
                  },
                  icon: AsyncStreamBuilder(
                    provider: player.playlistModeStream,
                    builder: (_, playlistMode) {
                      return Icon(switch (playlistMode) {
                        PlaylistMode.none => Icons.queue_music_outlined,
                        PlaylistMode.loop => Icons.repeat,
                        PlaylistMode.single => Icons.repeat_one_outlined,
                      });
                    },
                  ),
                );
              },
            ),
            SizedBox(width: 30),
            IconButton(
              color: Theme.of(context).colorScheme.primary.withAlpha(127),
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
              color: Theme.of(context).colorScheme.primary.withAlpha(127),
              icon: const Icon(Icons.more_horiz_rounded),
              iconSize: 30,
            ),

            // AsyncStreamBuilder(
            //   provider: playlistModeStreamProvider,
            //   builder: (_, playlistMode, __) {
            //     return IconButton(
            //       onPressed:
            //           playlistMode == PlaylistMode.single
            //               ? null
            //               : () async {
            //                 final messenger = ScaffoldMessenger.of(context);
            //                 final height = MediaQuery.of(context).size.height;
            //                 final hanlder = await AppPlayerHandler.instance;
            //                 final player = hanlder.player;
            //                 await player.setShuffleModeEnabled(
            //                   !player.shuffleModeEnabled,
            //                 );
            //                 messenger.clearSnackBars();
            //                 messenger.showSnackBar(
            //                   SnackBar(
            //                     content: Text(
            //                       textAlign: TextAlign.center,
            //                       '随机${player.shuffleModeEnabled ? '开启' : '关闭'}',
            //                     ),
            //                     behavior: SnackBarBehavior.floating,
            //                     margin: EdgeInsets.only(
            //                       bottom: height - 150,
            //                       left: 10,
            //                       right: 10,
            //                     ),
            //                   ),
            //                 );
            //               },
            //       icon: AsyncStreamBuilder(
            //         provider: shuffleModeEnabledStreamProvider,
            //         builder: (_, mode, __) {
            //           return mode
            //               ? Icon(
            //                 Icons.shuffle_on_outlined,
            //                 color: Theme.of(context).colorScheme.primary,
            //               )
            //               : const Icon(Icons.shuffle_outlined);
            //         },
            //       ),
            //     );
            //   },
            // ),
          ],
        );
      },
    );
  }
}
