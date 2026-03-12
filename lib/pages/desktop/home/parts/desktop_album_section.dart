part of '../home_page.dart';

class _DesktopAlbumSection extends ConsumerStatefulWidget {
  const _DesktopAlbumSection({required this.title, required this.type});

  static const int _fetchSize = 50;

  static const _cardWidth = 160.0;
  static const _cardGap = 18.0;
  static const _metaBlockHeight = 52.0;
  static const _cardHeight = _cardWidth + _metaBlockHeight;

  final String title;
  final AlbumListType type;

  @override
  ConsumerState<_DesktopAlbumSection> createState() =>
      _DesktopAlbumSectionState();
}

class _DesktopAlbumSectionState extends ConsumerState<_DesktopAlbumSection> {
  late final ScrollController _scrollController;
  bool _canScrollBack = false;
  bool _canScrollForward = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollUpdate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _onScrollUpdate();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollUpdate);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollUpdate() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final canBack = pos.pixels > 1.0;
    final canForward = pos.pixels < pos.maxScrollExtent - 1.0;
    if (canBack != _canScrollBack || canForward != _canScrollForward) {
      setState(() {
        _canScrollBack = canBack;
        _canScrollForward = canForward;
      });
    }
  }

  void _onScrollBack() {
    if (!_canScrollBack) return;
    final double currentOffset = _scrollController.offset;
    final double viewWidth = _scrollController.position.viewportDimension;
    final double scrollDistance = viewWidth * 0.8;
    _scrollController.animateTo(
      (currentOffset - scrollDistance).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  void _onScrollForward() {
    if (!_canScrollForward) return;
    final double currentOffset = _scrollController.offset;
    final double viewWidth = _scrollController.position.viewportDimension;
    final double scrollDistance = viewWidth * 0.8;
    _scrollController.animateTo(
      (currentOffset + scrollDistance).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            title: widget.title,
            onScrollBack: _canScrollBack ? _onScrollBack : null,
            onScrollForward: _canScrollForward ? _onScrollForward : null,
          ),
          SizedBox(
            height: _DesktopAlbumSection._cardHeight,
            child: AsyncValueBuilder(
              provider: albumListProvider(
                AlbumListQuery(
                  type: widget.type.name,
                  size: _DesktopAlbumSection._fetchSize,
                ),
              ),
              loading: (_, _) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              empty: (_, _) => const SizedBox.shrink(),
              builder: (context, data, _) {
                final albums = data;
                if (albums.isEmpty) return const SizedBox.shrink();

                // Trigger scroll state update once the list is built
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) _onScrollUpdate();
                });

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: albums.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        right: _DesktopAlbumSection._cardGap,
                      ),
                      child: SizedBox(
                        width: _DesktopAlbumSection._cardWidth,
                        child: DesktopAlbumCard(album: albums[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
