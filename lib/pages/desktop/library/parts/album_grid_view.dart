part of '../albums_page.dart';

class AlbumGridView extends StatelessWidget {
  const AlbumGridView({
    super.key,
    required this.albums,
    required this.hasMore,
    required this.scrollController,
  });

  final List<AlbumEntity> albums;
  final bool hasMore;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final itemCount = albums.length + (hasMore ? 1 : 0);
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 20,
        mainAxisSpacing: 24,
        childAspectRatio: 0.75,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        if (index >= albums.length) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        return DesktopAlbumCard(album: albums[index]);
      },
    );
  }
}
