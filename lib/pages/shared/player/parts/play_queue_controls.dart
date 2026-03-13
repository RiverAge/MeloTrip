part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

class _PlayQueuePlaylistModeButton extends ConsumerWidget {
  const _PlayQueuePlaylistModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return IconButton(
          onPressed: () {
            if (player.playlistMode == .loop) {
              player.setPlaylistMode(.none);
            } else if (player.playlistMode == .none) {
              player.setPlaylistMode(.single);
            } else {
              player.setPlaylistMode(.loop);
            }
          },
          icon: AsyncStreamBuilder(
            provider: player.playlistModeStream,
            builder: (_, playlistMode) {
              return Icon(switch (playlistMode) {
                .none => Icons.queue_music_outlined,
                .loop => Icons.repeat_rounded,
                .single => Icons.repeat_one_rounded,
              });
            },
          ),
        );
      },
    );
  }
}

class _PlayQueueShuffleModeButton extends ConsumerWidget {
  const _PlayQueueShuffleModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return AsyncStreamBuilder(
          provider: player.playlistModeStream,
          builder: (_, playlistMode) {
            return IconButton(
              onPressed: playlistMode == .single
                  ? null
                  : () => player.setShuffleModeEnabled(!player.shuffle),
              icon: AsyncStreamBuilder(
                provider: player.shuffleStream,
                builder: (_, enabled) {
                  return Icon(
                    enabled ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
                    color: enabled
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}