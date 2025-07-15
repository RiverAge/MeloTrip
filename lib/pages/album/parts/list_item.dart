part of '../album_detail_page.dart';

class _ListItem extends StatelessWidget with SongControl {
  _ListItem({required this.song, required this.idx});
  final SongEntity? song;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
        return AsyncValueBuilder(
          provider: appPlayerHandlerProvider,
          builder: (context, player, _) {
            return ListTile(
              onTap: () {
                final sLocal = song;
                if (sLocal == null) return;
                player.insertAndPlay(sLocal);
              },
              horizontalTitleGap: 2,
              selected: current?.id == song?.id,
              leading: Text(
                (idx + 1).toString().padLeft(2, ' '),
                style: const TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Row(
                children: [
                  AsyncValueBuilder(
                    provider: appPlayerHandlerProvider,
                    builder: (context, player, _) {
                      return AsyncStreamBuilder(
                        provider: player.playingStream,
                        builder: (_, playing) {
                          return current?.id == song?.id && playing
                              ? SizedBox(
                                width: 30,
                                child: Image.asset(
                                  'images/playing.gif',
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              )
                              : const SizedBox.shrink();
                        },
                      );
                    },
                  ),
                  Expanded(child: Text(song?.title ?? '')),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  '${song?.artist} ${durationFormatter(song?.duration)}',
                ),
              ),
              trailing: IconButton(
                onPressed: () => showSongControlSheet(context, song?.id),
                icon: const Icon(Icons.more_horiz_rounded),
              ),
            );
          },
        );
      },
    );
  }
}
