part of '../search_page.dart';

class _AlbumItem extends StatelessWidget {
  final AlbumEntity album;

  const _AlbumItem({required this.album});

  @override
  Widget build(BuildContext context) => ListTile(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album.id)),
      );
    },
    leading: Container(
      height: 50,
      width: 50,
      clipBehavior: .antiAlias,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: ArtworkImage(id: album.id),
    ),
    title: Text(
      '${album.name}',
      overflow: .ellipsis,
      style: const TextStyle(fontSize: 14, fontWeight: .bold),
    ),
    subtitle: Row(
      children: [
        _Tag(text: durationFormatter(album.duration ?? 0)),
        Expanded(
          child: Text(
            overflow: .ellipsis,
            '${album.artist} ${album.songCount}${AppLocalizations.of(context)!.songCountUnit} ${album.year ?? ''}',
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    ),
  );
}
