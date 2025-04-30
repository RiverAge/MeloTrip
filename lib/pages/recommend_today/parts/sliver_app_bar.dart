part of '../recommend_today_page.dart';

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar({required this.songs});

  final List<SongEntity> songs;

  _onPlay(List<SongEntity> songs) async {
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    await player.setPlaylist(songs: songs);
    player.play();
  }

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
              '${AppLocalizations.of(context)!.recommendedToday}·${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: () => _onPlay(songs),
              style: IconButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.all(0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              icon: const Icon(Icons.play_circle_outline),
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
