part of '../favorite_page.dart';

class _AlbumsBuilder extends StatelessWidget {
  const _AlbumsBuilder({required this.albums, required this.onToggleFavorite});
  final List<AlbumEntity>? albums;
  final void Function(AlbumEntity album) onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final effectiveAlbums = albums;
    return effectiveAlbums == null
        ? const Center(child: NoData())
        : ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 15),
          separatorBuilder: (context, index) => const Divider(),
          itemCount: effectiveAlbums.length,
          itemBuilder: (_, index) {
            final album = effectiveAlbums[index];
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AlbumDetailPage(albumId: album.id),
                  ),
                );
              },
              title: Text(album.name ?? '', overflow: TextOverflow.ellipsis),
              subtitle: Text(
                overflow: TextOverflow.ellipsis,
                '${album.songCount}${AppLocalizations.of(context)!.songCountUnit} - ${album.artist}',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: .5),
                  fontSize: 12,
                ),
              ),
              leading: Container(
                width: 50,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ArtworkImage(id: album.id),
              ),
              trailing: IconButton(
                onPressed: () => onToggleFavorite(album),
                icon: const Icon(Icons.heart_broken),
              ),
            );
          },
        );
  }
}
