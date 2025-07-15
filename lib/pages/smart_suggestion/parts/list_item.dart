part of '../smart_suggestion_page.dart';

class _ListItem extends StatelessWidget with SongControl {
  const _ListItem({required this.song, required this.index});
  final SongEntity song;
  final int index;
  @override
  Widget build(BuildContext context) => AsyncValueBuilder(
    provider: appPlayerHandlerProvider,
    builder: (context, player, _) {
      return ListTile(
        onTap: () {
          player.insertAndPlay(song);
        },
        minTileHeight: 1,
        dense: false,
        minVerticalPadding: 0,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (index + 1).toString(),
              style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
            ),
            Container(
              width: 45,
              height: 45,
              margin: const EdgeInsets.only(left: 15),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: ArtworkImage(id: song.id),
            ),
          ],
        ),
        title: Text(song.title ?? ''),
        subtitle: Text(
          '${song.album} - ${song.artist}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: IconButton(
          onPressed: () => showSongControlSheet(context, song.id),
          icon: const Icon(Icons.more_horiz_rounded),
        ),
      );
    },
  );
}
