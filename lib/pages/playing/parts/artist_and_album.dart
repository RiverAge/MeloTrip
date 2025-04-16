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

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${current?.artist} - ${current?.album ?? ''}',
                style: const TextStyle(fontSize: 17),
                textAlign: TextAlign.left,
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
