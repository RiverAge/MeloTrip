part of '../album_detail_page.dart';

class _ListItem extends StatelessWidget with SongControl {
  _ListItem({
    required this.song,
    required this.idx,
    required this.player,
    required this.isCurrentPlaying,
  });
  final SongEntity? song;
  final int idx;
  final AppPlayer player;
  final bool isCurrentPlaying;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final sLocal = song;
        if (sLocal == null) return;
        final playQueue = player.playQueue;
        final currentSong =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
        if (currentSong?.id == sLocal.id) {
          player.playOrPause();
        } else {
          player.insertAndPlay(sLocal);
        }
      },
      horizontalTitleGap: 2,
      selected: isCurrentPlaying,
      leading: SizedBox(width: 45, child: Text('#${song?.track}')),
      title: Row(
        children: [
          isCurrentPlaying
              ? SizedBox(
                  width: 30,
                  child: Image.asset(
                    'images/playing.gif',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              : const SizedBox.shrink(),
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
  }
}
