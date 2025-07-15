part of '../playing_page.dart';

class _MusicControls extends StatelessWidget {
  const _MusicControls();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AsyncValueBuilder(
          provider: appPlayerHandlerProvider,
          builder: (context, player, ref) {
            return IconButton(
              onPressed: () {
                final messenger = ScaffoldMessenger.of(context);
                final playModeNoneText =
                    AppLocalizations.of(context)!.playModeNone;
                final playModeLoopText =
                    AppLocalizations.of(context)!.playModeLoop;
                final playModeSingleText =
                    AppLocalizations.of(context)!.playModeSingle;
                final height = MediaQuery.of(context).size.height;
                if (player.playlistMode == PlaylistMode.loop) {
                  player.setPlaylistMode(PlaylistMode.none);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(playModeNoneText),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: height - 150,
                        left: 10,
                        right: 10,
                      ),
                    ),
                  );
                } else if (player.playlistMode == PlaylistMode.none) {
                  player.setPlaylistMode(PlaylistMode.single);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(playModeSingleText),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: height - 150,
                        left: 10,
                        right: 10,
                      ),
                    ),
                  );
                } else if (player.playlistMode == PlaylistMode.single) {
                  player.setPlaylistMode(PlaylistMode.loop);
                  messenger.clearSnackBars();
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text(playModeLoopText),
                      behavior: SnackBarBehavior.floating,
                      margin: EdgeInsets.only(
                        bottom: height - 150,
                        left: 10,
                        right: 10,
                      ),
                    ),
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
  }
}
