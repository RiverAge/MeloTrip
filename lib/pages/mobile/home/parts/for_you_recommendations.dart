part of '../home_page.dart';

class _ForYouRecommendations extends StatelessWidget {
  const _ForYouRecommendations();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AsyncValueBuilder(
      provider: forYouRecommendationsProvider,
      builder: (context, songs, ref) {
        // Show placeholder when no recommendations
        if (songs.isEmpty) {
          return const _ForYouPlaceholder();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Text(
                    l10n.guessYouLike,
                    style: const TextStyle(fontSize: 18, fontWeight: .w900),
                  ),
                  // Play all button
                  TextButton.icon(
                    onPressed: () async {
                      final player = await ref.read(
                        appPlayerHandlerProvider.future,
                      );
                      if (player != null) {
                        await player.setPlaylist(
                          songs: songs,
                          initialId: songs.first.id,
                        );
                        await player.play();
                      }
                    },
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      l10n.play,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ScrollConfiguration(
                  behavior: const _HorizontalCardScrollBehavior(),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return _SongCard(song: song);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HorizontalCardScrollBehavior extends MaterialScrollBehavior {
  const _HorizontalCardScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    .mouse,
  };
}

class _SongCard extends StatelessWidget {
  const _SongCard({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = song.displayArtist ?? song.artist ?? '';

    return Consumer(
      builder: (context, ref, _) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 130,
            child: InkWell(
              onTap: () async {
                final player = await ref.read(appPlayerHandlerProvider.future);
                if (player != null) {
                  await player.insertAndPlay(song);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
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
                              color: theme.colorScheme.shadow.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ArtworkImage(
                            fit: .cover,
                            id: song.coverArt ?? song.albumId,
                            size: 300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.title ?? '',
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
                      artist,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .7,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
