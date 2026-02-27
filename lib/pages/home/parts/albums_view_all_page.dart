part of '../home_page.dart';

class _AlbumsViewAllPage extends ConsumerStatefulWidget {
  const _AlbumsViewAllPage({
    required this.type,
    required this.title,
    required this.layout,
  });

  final AlumsType type;
  final String title;
  final AlbumLayout layout;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlbumsViewAllPageState();
}

class _AlbumsViewAllPageState extends ConsumerState<_AlbumsViewAllPage> {
  static const _pageSize = 30;
  final ScrollController _scrollController = ScrollController();
  final List<AlbumEntity> _albums = <AlbumEntity>[];

  var _isLoading = false;
  var _hasMore = true;
  Object? _error;
  int _offset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadMore();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading || !_hasMore) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoading || !_hasMore) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final api = await ref.read(apiProvider.future);
      final res = await api.get<Map<String, dynamic>>(
        '/rest/getAlbumList',
        queryParameters: {
          'type': widget.type.name,
          'size': _pageSize,
          'offset': _offset,
        },
      );

      final data = res.data;
      final parsed = data == null ? null : SubsonicResponse.fromJson(data);
      final pageAlbums = parsed?.subsonicResponse?.albumList?.album ?? [];

      if (!mounted) return;
      setState(() {
        _albums.addAll(pageAlbums);
        _offset += pageAlbums.length;
        _hasMore = pageAlbums.length >= _pageSize;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: switch ((_albums.isEmpty, _isLoading, _error)) {
                (true, true, _) => const Center(
                  child: CircularProgressIndicator(),
                ),
                (true, false, final error?) => _buildErrorState(context, error),
                (true, false, null) => NoData(),
                _ => RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: _buildListByLayout(context),
                ),
              },
            ),
            if (_isLoading && _albums.isNotEmpty)
              const LinearProgressIndicator(minHeight: 2),
            if (!_hasMore && _albums.isNotEmpty) const EndofData(),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    setState(() {
      _albums.clear();
      _offset = 0;
      _hasMore = true;
      _error = null;
    });
    await _loadMore();
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: .min,
          children: [
            Text(
              AppLocalizations.of(context)!.encounterUnknownError,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: _loadMore, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildListByLayout(BuildContext context) {
    return switch (widget.layout) {
      .grid => GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _albums.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemBuilder: (_, idx) => _buildCardItem(context, _albums[idx]),
      ),
      .tile => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _albums.length,
        itemBuilder: (_, idx) => _buildTileItem(context, _albums[idx]),
      ),
      .horizontal => ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _albums.length,
        itemBuilder: (_, idx) => _buildTileItem(context, _albums[idx]),
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
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: .start,
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
                  child: ArtworkImage(fit: .cover, id: album.id, size: 300),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album.name ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: .bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              album.artist ?? '',
              maxLines: 1,
              overflow: .ellipsis,
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
                fit: .cover,
                size: 200,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    album.name ?? '',
                    style: const TextStyle(fontSize: 15, fontWeight: .w600),
                    maxLines: 1,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${album.artist} 路 ${album.year ?? ""}',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                    maxLines: 1,
                    overflow: .ellipsis,
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
