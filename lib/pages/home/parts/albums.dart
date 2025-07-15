part of '../home_page.dart';

class _Albums extends StatelessWidget {
  const _Albums({required this.type});
  final AlumsType type;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(switch (type) {
            AlumsType.newest => AppLocalizations.of(context)!.recentAdded,
            AlumsType.random => AppLocalizations.of(context)!.randomAlbum,
            AlumsType.recent => AppLocalizations.of(context)!.rencentPlayed,
          }, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          AsyncValueBuilder(
            provider: albumsProvider(type),
            builder: (context, data, ref) {
              final albums = data.subsonicResponse?.albumList?.album;
              return SizedBox(
                height: 150,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: albums?.length,
                  itemBuilder: (_, idx) => _itemBuilder(context, albums?[idx]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, AlbumEntity? album) {
    return Row(
      children: [
        Stack(
          children: [
            InkWell(
              onTap: () => _onTap(context, album),
              child: Container(
                clipBehavior: Clip.antiAlias,
                width: 150,
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ArtworkImage(
                  fit: BoxFit.cover,
                  id: album?.id,
                  size: 200,
                ),
              ),
            ),
            _positioned(context, album),
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  void _onTap(BuildContext context, AlbumEntity? album) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album?.id)),
    );
  }

  Widget _positioned(BuildContext context, AlbumEntity? album) {
    final color = Theme.of(
      context,
    ).colorScheme.onSurfaceVariant.withValues(alpha: 1);
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${album?.name}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      '${album?.artist}',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: color, fontSize: 10),
                    ),
                  ),
                  Text(
                    '${album?.songCount}${AppLocalizations.of(context)!.songCountUnit}',
                    style: TextStyle(fontSize: 10, color: color),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
