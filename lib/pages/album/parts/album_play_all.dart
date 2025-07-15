part of '../album_detail_page.dart';

class _AlbumPlayAll extends StatelessWidget {
  const _AlbumPlayAll({required this.songs});
  final List<SongEntity>? songs;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 15,
      bottom: 15,
      child: AsyncValueBuilder(
        provider: appPlayerHandlerProvider,
        builder: (context, player, _) {
          return IconButton(
            icon: const Icon(Icons.play_circle_outline_outlined, size: 30),
            onPressed: () async {
              final effectiveSongs = songs;
              if (effectiveSongs == null || effectiveSongs.isEmpty) return;
              await player.setPlaylist(
                songs: [...effectiveSongs, ...player.playQueue.songs],
                initialId: effectiveSongs[0].id,
              );
              player.play();
            },
          );
        },
      ),
    );
  }
}
