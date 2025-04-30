part of '../playing_page.dart';

class _ArtistAndAlbum extends StatelessWidget with SongControl {
  const _ArtistAndAlbum();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
    child: PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];

        final effictiveArtist = current?.artists ?? [];
        final effectiveDisplayArtist =
            effictiveArtist.length > 1
                ? '${effictiveArtist[0].name}'
                : current?.displayArtist;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Wrap(
                children: [
                  if (effictiveArtist.length <= 2)
                    Text(
                      '$effectiveDisplayArtist',
                      style: const TextStyle(fontSize: 17),
                      textAlign: TextAlign.left,
                    ),
                  if (effictiveArtist.length > 2)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${effictiveArtist[0].name} • ${effictiveArtist[1].name}',
                          style: const TextStyle(fontSize: 17),
                        ),

                        Text(
                          '...等${effictiveArtist.length}位艺术家',
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withAlpha(100),
                          ),
                        ),
                      ],
                    ),
                  Text(
                    ' - ',
                    style: const TextStyle(fontSize: 17),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    ' ${current?.album ?? ''}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  onPressed:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => AddToPlaylistPage(song: current),
                        ),
                      ),
                  icon: const Icon(Icons.playlist_add),
                  iconSize: 30,
                ),
                IconButton(
                  onPressed: () => showSongControlSheet(context, current?.id),
                  icon: const Icon(Icons.more_horiz_rounded),
                  iconSize: 30,
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}
