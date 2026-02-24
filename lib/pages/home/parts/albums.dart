part of '../home_page.dart';

class _Albums extends StatelessWidget {
  const _Albums({required this.type, required this.title});

  final AlumsType type;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 12),
        AsyncValueBuilder(
          provider: albumsProvider(type),
          builder: (context, data, ref) {
            final albums = data.subsonicResponse?.albumList?.album ?? [];
            if (albums.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: albums.length,
                itemBuilder: (_, idx) => _itemBuilder(context, albums[idx]),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, AlbumEntity album) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ArtworkImage(
                    fit: BoxFit.cover,
                    id: album.id,
                    size: 200,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                album.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                album.artist ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: .7,
                  ),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
