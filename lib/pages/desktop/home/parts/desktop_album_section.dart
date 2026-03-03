part of '../home_page.dart';

class _DesktopAlbumSection extends ConsumerWidget {
  const _DesktopAlbumSection({required this.title, required this.type});

  final String title;
  final AlumsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(title: title, onViewAll: () {}),
          SizedBox(
            height: 212,
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
                      padding: const EdgeInsets.only(right: 18),
                      child: SizedBox(
                        width: 160,
                        child: _DesktopAlbumCard(album: albums[index]),
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
