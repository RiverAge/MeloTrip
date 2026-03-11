part of '../home_page.dart';

class _AlbumsViewAllPage extends ConsumerStatefulWidget {
  const _AlbumsViewAllPage({
    required this.type,
    required this.title,
    required this.layout,
  });

  final AlbumListType type;
  final String title;
  final AlbumLayout layout;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlbumsViewAllPageState();
}

class _AlbumsViewAllPageState extends ConsumerState<_AlbumsViewAllPage> {
  static const int _pageSize = 30;
  final ScrollController _scrollController = ScrollController();

  AlbumListQuery get _query =>
      AlbumListQuery(type: widget.type.name, size: _pageSize);

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(paginatedAlbumListProvider(_query));
    if (!_scrollController.hasClients || state.isLoading || !state.hasMore) {
      return;
    }
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(paginatedAlbumListProvider(_query).notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(paginatedAlbumListProvider(_query));

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: switch ((
                state.items.isEmpty,
                state.isLoading,
                state.error,
              )) {
                (true, true, _) => const Center(
                  child: CircularProgressIndicator(),
                ),
                (true, false, final error?) => _buildErrorState(context, error),
                (true, false, null) => NoData(),
                _ => RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: _buildListByLayout(context, state.items),
                ),
              },
            ),
            if (state.isLoading && state.items.isNotEmpty)
              const LinearProgressIndicator(minHeight: 2),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() {
    return ref.read(paginatedAlbumListProvider(_query).notifier).refresh();
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.encounterUnknownError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => ref
                  .read(paginatedAlbumListProvider(_query).notifier)
                  .refresh(),
              child: Text(AppLocalizations.of(context)!.retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListByLayout(BuildContext context, List<AlbumEntity> albums) {
    return switch (widget.layout) {
      AlbumLayout.grid => GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, idx) => _buildCardItem(context, albums[idx]),
      ),
      AlbumLayout.tile => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: albums.length,
        itemBuilder: (_, idx) => _buildTileItem(context, albums[idx]),
      ),
      AlbumLayout.horizontal => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: albums.length,
        itemBuilder: (_, idx) => _buildTileItem(context, albums[idx]),
      ),
    };
  }

  Widget _buildCardItem(BuildContext context, AlbumEntity album) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AlbumDetailPage(albumId: album.id)),
      ),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
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
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileItem(BuildContext context, AlbumEntity album) {
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
