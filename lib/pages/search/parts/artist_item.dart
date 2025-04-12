part of '../search_page.dart';

class _ArtistItem extends StatelessWidget {
  final ArtistEntity artist;

  const _ArtistItem({required this.artist});

  @override
  Widget build(BuildContext context) => ListTile(
      leading: Container(
          height: 50,
          width: 50,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: ArtworkImage(id: artist.coverArt)),
      title: Text(artist.name ?? ''),
      subtitle: Text('专辑数量 ${artist.albumCount}'),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ArtistDetailPage(artistId: artist.id)));
      });
}
