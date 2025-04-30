part of '../home_page.dart';

class _RecToday extends StatelessWidget with SongControl {
  const _RecToday();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 32),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.recommendedToday,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  minimumSize: Size.zero, // Set this
                  padding: EdgeInsets.zero,
                ),
                onPressed:
                    () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const RecommendTodayPage(),
                      ),
                    ),
                child: Text(
                  AppLocalizations.of(context)!.viewAll,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        AsyncValueBuilder(
          provider: recTodayProvider,
          builder: (ctx, data, _) {
            if (data.length < 5) {
              return const NoData();
            }
            return Column(
              children:
                  data
                      .sublist(0, 5)
                      .map(
                        (e) => ListTile(
                          onTap: () async {
                            final handler = await AppPlayerHandler.instance;
                            final player = handler.player;
                            await player.insertAndPlay(e);
                          },
                          title: Text(
                            e.title ?? '',
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '${e.album} - ${e.artist}',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant
                                  .withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                          leading: Container(
                            width: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                            ),
                            child: ArtworkImage(id: e.id),
                          ),
                          trailing: IconButton(
                            onPressed: () => _onPress(ctx, e),
                            icon: const Icon(Icons.more_horiz_rounded),
                          ),
                        ),
                      )
                      .toList(),
            );
          },
        ),
      ],
    );
  }

  _onPress(BuildContext context, SongEntity song) {
    showSongControlSheet(context, song.id);
    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (context) {
    //       return _SongControls(song: song);
    //     });
  }
}
