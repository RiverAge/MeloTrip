part of 'music_bar.dart';

class _BottomSheetControls extends StatelessWidget {
  const _BottomSheetControls();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            final hanlder = await AppPlayerHandler.instance;
            final player = hanlder.player;
            if (player.playlistMode == PlaylistMode.loop) {
              player.setLoopMode(PlaylistMode.none);
            } else if (player.playlistMode == PlaylistMode.none) {
              player.setLoopMode(PlaylistMode.single);
            } else if (player.playlistMode == PlaylistMode.single) {
              player.setLoopMode(PlaylistMode.loop);
            }
          },
          icon: AsyncStreamBuilder(
            provider: playlistModeStreamProvider,
            builder: (_, playlistMode, __) {
              return Icon(switch (playlistMode) {
                PlaylistMode.none => Icons.queue_music_outlined,
                PlaylistMode.loop => Icons.repeat,
                PlaylistMode.single => Icons.repeat_one_outlined,
              });
            },
          ),
        ),
        // AsyncStreamBuilder(
        //     provider: playlistModeStreamProvider,
        //     builder: (_, playlistMode, __) {
        //       return IconButton(
        //           onPressed: playlistMode == PlaylistMode.single
        //               ? null
        //               : () async {
        //                   final hanlder = await AppPlayerHandler.instance;
        //                   final player = hanlder.player;
        //                   await player
        //                       .setShuffleModeEnabled(!player.shuffleModeEnabled);
        //                 },
        //           icon: AsyncStreamBuilder(
        //               provider: shuffleModeEnabledStreamProvider,
        //               builder: (_, mode, __) {
        //                 return mode
        //                     ? Icon(Icons.shuffle_on_outlined,
        //                         color: Theme.of(context).colorScheme.primary)
        //                     : const Icon(Icons.shuffle_outlined);
        //               }));
        //     })
      ],
    );
  }
}
