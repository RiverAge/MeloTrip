part of '../albums_page.dart';

class AlbumTableView extends StatelessWidget {
  const AlbumTableView({
    super.key,
    required this.albums,
    required this.hasMore,
    required this.scrollController,
    required this.l10n,
  });

  final List<AlbumEntity> albums;
  final bool hasMore;
  final ScrollController scrollController;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.onSurfaceVariant.withValues(
      alpha: 0.7,
    );
    final headerStyle = _baseStyle.copyWith(color: headerColor);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 30, child: Text('#', style: headerStyle)),
              Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
              SizedBox(
                width: 80,
                child: Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: headerColor,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(l10n.songMetaGenre, style: headerStyle),
              ),
              SizedBox(
                width: 80,
                child: Text(l10n.songMetaYear, style: headerStyle),
              ),
              const SizedBox(width: 30),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: albums.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= albums.length) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return _AlbumTableRow(index: index + 1, album: albums[index]);
            },
          ),
        ),
      ],
    );
  }

  static const TextStyle _baseStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

class _AlbumTableRow extends StatelessWidget {
  const _AlbumTableRow({required this.index, required this.album});

  final int index;
  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ArtworkImage(
                      id: album.id,
                      size: 80,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          album.name ?? '-',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: .bold,
                          ),
                        ),
                        Text(
                          album.artist ?? '-',
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                _formatTotalDuration(album.duration),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                album.genre ?? '-',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                '${album.year ?? ""}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTotalDuration(int? seconds) {
    if (seconds == null) return '-';
    final int m = seconds ~/ 60;
    final String s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
