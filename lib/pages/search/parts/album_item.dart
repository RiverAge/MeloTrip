part of '../search_page.dart';

class _AlbumItem extends StatelessWidget {
  final AlbumEntity album;

  const _AlbumItem({required this.album});

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => AlbumDetailPage(albumId: album.id)));
      },
      leading: Container(
          height: 50,
          width: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: ArtworkImage(id: album.id)),
      title: Text('${album.name}',
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      subtitle: Row(
        children: [
          _Tag(text: durationFormatter(album.duration ?? 0)),
          Expanded(
              child: Text(
                  overflow: TextOverflow.ellipsis,
                  '${album.artist} ${album.songCount}首 ${album.year ?? ''}',
                  style: const TextStyle(fontSize: 12)))
        ],
      ));
}
