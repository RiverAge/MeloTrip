part of '../album_detail_page.dart';

class _AlbumCover extends StatelessWidget {
  const _AlbumCover({required this.album});
  final AlbumEntity album;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(50),
            blurRadius: 20,
            offset: Offset(0, 10),
            spreadRadius: 8,
          ),
        ],
      ),
      width: 150,
      height: 150,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: ArtworkImage(id: album.id, size: 5000, fit: BoxFit.cover),
      ),
    );
  }
}
