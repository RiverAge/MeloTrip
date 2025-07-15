part of 'music_bar.dart';

class _BottomSheetActionsMode extends StatelessWidget {
  const _BottomSheetActionsMode();
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return IconButton(
          onPressed: () {
            if (player.playlistMode == PlaylistMode.loop) {
              player.setPlaylistMode(PlaylistMode.none);
            } else if (player.playlistMode == PlaylistMode.none) {
              player.setPlaylistMode(PlaylistMode.single);
            } else if (player.playlistMode == PlaylistMode.single) {
              player.setPlaylistMode(PlaylistMode.loop);
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
    );
  }
}
