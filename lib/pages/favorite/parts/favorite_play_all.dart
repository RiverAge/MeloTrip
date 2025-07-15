part of '../favorite_page.dart';

class _FavoritePlayAll extends StatelessWidget {
  const _FavoritePlayAll({required this.songs});
  final List<SongEntity> songs;
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return IconButton(
          onPressed: () async {
            final effectiveSongs = songs;
            if (effectiveSongs.isEmpty) return;
            await player.setPlaylist(
              songs: [...effectiveSongs, ...player.playQueue.songs],
              initialId: effectiveSongs[0].id,
            );
            player.play();
          },
          icon: const Icon(Icons.play_circle_outline),
        );
      },
    );
  }
}
