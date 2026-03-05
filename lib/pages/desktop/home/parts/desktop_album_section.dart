part of '../home_page.dart';

class _DesktopAlbumSection extends ConsumerWidget {
  const _DesktopAlbumSection({required this.title, required this.type});

  static const _cardWidth = 160.0;
  static const _cardGap = 18.0;
  static const _metaBlockHeight = 52.0;
  static const _cardHeight = _cardWidth + _metaBlockHeight;

  final String title;
  final AlumsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _SectionHeader(title: title, onViewAll: () {}),
          SizedBox(
            height: _cardHeight,
            child: AsyncValueBuilder(
              provider: albumsProvider(type),
              loading: (_, _) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              empty: (_, _) => const SizedBox.shrink(),
              builder: (context, data, _) {
                final albums = data.subsonicResponse?.albumList?.album ?? [];
                if (albums.isEmpty) return const SizedBox.shrink();
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: albums.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: _cardGap),
                      child: SizedBox(
                        width: _cardWidth,
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
