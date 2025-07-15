part of '../smart_suggestion_page.dart';

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context) => SliverAppBar(
    expandedHeight: 230,
    floating: false,
    pinned: true,
    snap: false,
    flexibleSpace: FlexibleSpaceBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            const Spacer(),
            Text(
              AppLocalizations.of(context)!.guessYouLike,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            AsyncValueBuilder(
              provider: appPlayerHandlerProvider,
              builder: (context, player, _) {
                return IconButton(
                  onPressed: () async {
                    await player.setPlaylist(
                      songs: [...songs, ...player.playQueue.songs],
                      initialId: songs[0].id,
                    );
                    player.play();
                  },
                  style: IconButton.styleFrom(
                    minimumSize: Size.zero,
                    padding: const EdgeInsets.all(0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.play_circle_outline),
                );
              },
            ),
          ],
        ),
      ),
      centerTitle: true,
      background: _SliverBackground(
        songIds: songs.sublist(0, 4).map((e) => e.id).toList(),
      ),
      collapseMode: CollapseMode.pin,
    ),
  );
}
