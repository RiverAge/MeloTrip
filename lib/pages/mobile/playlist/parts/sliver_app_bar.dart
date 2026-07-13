part of '../playlist_detail_page.dart';

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({required this.playlist});

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SliverAppBar(
      expandedHeight: 340,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      backgroundColor: colorScheme.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        title: Text(
          playlist.name ?? '',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        background: Stack(
          fit: StackFit.expand,
          children: [
            // 背景封面图
            ArtworkImage(
              id: playlist.coverArt,
              size: 1000,
              fit: BoxFit.cover,
            ),
            // 多层渐变遮罩，确保标题文字可读
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.5),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.6),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
            // 底部渐变过渡到页面背景
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      colorScheme.surface.withValues(alpha: 1.0),
                      colorScheme.surface.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, color: Colors.white),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => EditPlaylistPage(playlistId: playlist.id),
              ),
            );
          },
        ),
      ],
    );
  }
}
