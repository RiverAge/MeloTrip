part of '../home_page.dart';

enum AlbumLayout { horizontal, grid, tile }

class _Albums extends StatelessWidget {
  const _Albums({
    required this.type,
    required this.title,
    this.layout = AlbumLayout.horizontal,
    this.limit,
    this.onViewAll,
  });

  final AlbumListType type;
  final String title;
  final AlbumLayout layout;
  final int? limit;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              if (layout != AlbumLayout.horizontal && onViewAll != null)
                TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    AppLocalizations.of(context)!.viewAll,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        AsyncValueBuilder(
          provider: albumListProvider(AlbumListQuery(type: type.name)),
          builder: (context, data, ref) {
            var albums = data;
            if (albums.isEmpty) return const SizedBox.shrink();

            if (limit != null) {
              albums = albums.take(limit!).toList();
            }

            return switch (layout) {
              AlbumLayout.horizontal => _buildHorizontal(context, albums),
              AlbumLayout.grid => _buildGrid(context, albums),
              AlbumLayout.tile => _buildTiles(context, albums),
            };
          },
        ),
      ],
    );
  }

  Widget _buildHorizontal(BuildContext context, List<AlbumEntity> albums) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        scrollDirection: Axis.horizontal,
        itemCount: albums.length,
        itemBuilder: (_, idx) => _cardItem(context, albums[idx], width: 140),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<AlbumEntity> albums) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, idx) => _cardItem(context, albums[idx]),
      ),
    );
  }

  Widget _buildTiles(BuildContext context, List<AlbumEntity> albums) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: albums.map((album) => _tileItem(context, album)).toList(),
      ),
    );
  }

  Widget _cardItem(BuildContext context, AlbumEntity album, {double? width}) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width == null ? 0 : 4),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: width,
          padding: const EdgeInsets.all(4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ArtworkImage(
                      fit: BoxFit.cover,
                      id: album.id,
                      size: 300,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                album.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
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
                    alpha: 0.7,
                  ),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tileItem(BuildContext context, AlbumEntity album) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album.id)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ArtworkImage(
                id: album.id,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                size: 200,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name ?? '',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${album.artist} - ${album.year ?? ""}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
            ),
          ],
        ),
      ),
    );
  }
}
