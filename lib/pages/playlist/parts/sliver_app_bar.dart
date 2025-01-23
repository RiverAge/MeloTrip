part of '../playlist_detail_page.dart';

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({required this.playlist});

  final PlaylistEntity playlist;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        expandedHeight: 180,
        floating: false,
        pinned: true,
        snap: false,
        flexibleSpace: FlexibleSpaceBar(
            expandedTitleScale: 1.3,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                playlist.public == true
                    ? const Icon(Icons.public_outlined, size: 20)
                    : const Icon(Icons.lock_outline, size: 20),
                const SizedBox(width: 3),
                Expanded(child: Text(playlist.name ?? '')),
                InkWell(
                  child: const Icon(Icons.edit_outlined),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => EditPlaylistPage(
                              playlistId: playlist.id,
                            )));
                  },
                ),
                const SizedBox(width: 15),
                InkWell(
                    onTap: () async {
                      final effectiveSongs = playlist.entry;
                      if (effectiveSongs == null || effectiveSongs.isEmpty) {
                        return;
                      }
                      final handler = await AppPlayerHandler.instance;
                      final player = handler.player;
                      await player.setPlaylist(
                          songs: effectiveSongs,
                          initialId: effectiveSongs[0].id);
                      player.play();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.play_circle_outline_outlined),
                    ))
              ],
            ),
            background: Stack(fit: StackFit.expand, children: [
              ArtworkImage(id: playlist.coverArt, fit: BoxFit.cover),
              Positioned.fill(
                  child: Container(
                color: Theme.of(context)
                    .colorScheme
                    .surface
                    .withValues(alpha: 0.8),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      playlist.comment ?? '',
                      style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                              .withValues(alpha: 0.5)),
                    ),
                    // child: Text(playlist.comment ?? ''),
                  ),
                ),
              ))
            ])));
  }
}
