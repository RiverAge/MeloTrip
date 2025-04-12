part of '../album_detail_page.dart';

class _AlbumCover extends StatelessWidget {
  const _AlbumCover({required this.album});
  final AlbumEntity album;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: ArtworkImage(
        id: album.id,
        size: 300,
        fit: BoxFit.cover,
      ),
    );
  }
}
