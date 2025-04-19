part of 'music_bar.dart';

class _BottomSheetActionsMode extends StatelessWidget {
  const _BottomSheetActionsMode();
  @override
  Widget build(BuildContext context) {
    return IconButton(
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
    );
  }
}
