part of '../album_detail_page.dart';

class _ListItem extends StatelessWidget with SongControl {
  _ListItem({required this.song, required this.idx});
  final SongEntity? song;
  final int idx;

  _onPlay(SongEntity? song) async {
    if (song == null) return;
    final hanlder = await AppPlayerHandler.instance;
    final player = hanlder.player;
    await player.insertAndPlay(song);
  }

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
        return ListTile(
          onTap: () => _onPlay(song),
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
              AsyncStreamBuilder(
                provider: playingStreamProvider,
                builder: (_, playing, __) {
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
              ),
              Expanded(child: Text(song?.title ?? '')),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text('${song?.artist} ${durationFormatter(song?.duration)}'),
          ),
          trailing: IconButton(
            onPressed: () => showSongControlSheet(context, song?.id),
            icon: const Icon(Icons.more_horiz_rounded),
          ),
        );
      },
    );
  }
}
