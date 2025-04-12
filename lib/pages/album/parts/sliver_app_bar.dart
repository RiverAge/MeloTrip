part of '../album_detail_page.dart';

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({
    required this.album,
    required this.onToggleFavorite,
    required this.onUpdateRating,
  });

  final AlbumEntity album;
  final void Function() onToggleFavorite;
  final void Function(int rating) onUpdateRating;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(album.name ?? ''),
      elevation: 3,
      expandedHeight: 180,
      floating: false,
      pinned: true,
      snap: false,
      actions: [
        IconButton(
          onPressed: onToggleFavorite,
          icon:
              album.starred != null
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_outline),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            ArtworkImage(id: album.id, fit: BoxFit.cover),
            _BlurredFilter(
              children: [
                _AlbumCover(album: album),
                _AlbumInfo(album: album, onUpdateRating: onUpdateRating),
              ],
            ),
            _AlbumPlayAll(songs: album.song),
          ],
        ),
      ),
    );
  }
}
