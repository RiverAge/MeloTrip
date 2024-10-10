part of '../album_detail_page.dart';

class _AlbumPlayAll extends StatelessWidget {
  const _AlbumPlayAll({required this.songs});
  final List<SongEntity>? songs;

  _onPress() async {
    final effectiveSongs = songs;
    if (effectiveSongs == null || effectiveSongs.isEmpty) return;
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    await player.setPlaylist(
        songs: effectiveSongs, initialId: effectiveSongs[0].id);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 15,
        bottom: 15,
        child: IconButton(
          icon: const Icon(Icons.play_circle_outline_outlined, size: 30),
          onPressed: _onPress,
        ));
  }
}
