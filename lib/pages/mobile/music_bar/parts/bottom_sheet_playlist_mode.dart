part of 'music_bar.dart';

class _BottomSheePlaylistMode extends StatelessWidget {
  const _BottomSheePlaylistMode();
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return IconButton(
          onPressed: () {
            if (player.playlistMode == .loop) {
              player.setPlaylistMode(.none);
            } else if (player.playlistMode == .none) {
              player.setPlaylistMode(.single);
            } else if (player.playlistMode == .single) {
              player.setPlaylistMode(.loop);
            }
          },
          icon: AsyncStreamBuilder(
            provider: player.playlistModeStream,
            builder: (_, playlistMode) {
              return Icon(switch (playlistMode) {
                .none => Icons.queue_music_outlined,
                .loop => Icons.repeat,
                .single => Icons.repeat_one_outlined,
              });
            },
          ),
        );
      },
    );
  }
}
